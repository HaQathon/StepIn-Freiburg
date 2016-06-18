unit uContent;

interface

uses
  XSuperObject,

  uRessource;

type
  TRessource_Content = class(TRessource, IRessource)
  private

  public
    function GetRessourceName: string;

    function GET(const id: string; jsonResponse: ISuperObject): Boolean;
    function POST(const id: string; const payload: string; jsonResponse: ISuperObject): Boolean;
    function PUT(const id: string; const payload: string; jsonResponse: ISuperObject): Boolean;
    function DELETE(const id: string; jsonResponse: ISuperObject): Boolean;

    const RESSOURCENAME = 'content';
  end;

implementation

uses
  System.SysUtils,
  System.IOUtils,

  Winapi.ActiveX,

  Xml.XMLIntf,
  Xml.XMLDoc;

{ TRessource_Attribute }

function TRessource_Content.DELETE(const id: string; jsonResponse: ISuperObject): Boolean;
   begin
    result := False;
   end;

function TRessource_Content.GET(const id: string; jsonResponse: ISuperObject): Boolean;
   var
    contentList: TFileList;
    fileInfo: TFileInfo;
    fileName: string;
    Content: string;
   begin
    if id.IsEmpty then
       begin
        TLogger.Log('GET');
        Content := 'hello world';
        jsonResponse.O['data'].A['content'].Add(Content);
        contentList := TFileList.Create;
        try
          if ListFiles(TPath.Combine(ExtractFilePath(ParamStr(0)), 'content'), 'content*.xml', contentList) > 0 then
             begin
              for fileInfo in contentList do
                 begin
//                  Content := SO();
//
//                  Content.S['id']   := ChangeFileExt(ExtractFileName(fileInfo.Key), '');
//                  Content.D['date'] := fileInfo.Value;


                  jsonResponse.O['data'].A['attributes'].Add(Content);
                 end;
             end;
          result := True;
        finally
          contentList.Free;
        end;
       end
    else
       begin
        fileName := TPath.Combine(ExtractFilePath(ParamStr(0)), TPath.Combine('schichten', id + '.xml'));
        if FileExists(fileName) then
           begin
            jsonResponse.O['data'].S['id']      := ChangeFileExt(ExtractFileName(fileName), '');
            jsonResponse.O['data'].D['date']    := GetFileDate(fileName);
            jsonResponse.O['data'].S['content'] := ReadTextFile(fileName);

            result := True;
           end;
       end;
   end;

function TRessource_Content.GetRessourceName: string;
   begin
    result := RESSOURCENAME;
   end;

function TRessource_Content.POST(const id, payload: string; jsonResponse: ISuperObject): Boolean;
   var
    jsonRequest: ISuperObject;
    I1: Integer;
   begin
    jsonRequest := SO(payload);

    if jsonRequest.Null['data'] = jAssigned then
       begin
        CoInitialize(NIL);


       end
    else
       begin
        jsonResponse.S['errorMsg'] := 'No data provided';
       end;
   end;

function TRessource_Content.PUT(const id, payload: string; jsonResponse: ISuperObject): Boolean;
   begin
    result := False;
   end;

end.
