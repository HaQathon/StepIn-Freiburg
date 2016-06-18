unit uAttribute;

interface

uses
  XSuperObject,

  uRessource;

type
  TRessource_Attribute = class(TRessource, IRessource)
  private

  public
    function GetRessourceName: string;

    function GET(const id: string; jsonResponse: ISuperObject): Boolean;
    function POST(const id: string; const payload: string; jsonResponse: ISuperObject): Boolean;
    function PUT(const id: string; const payload: string; jsonResponse: ISuperObject): Boolean;
    function DELETE(const id: string; jsonResponse: ISuperObject): Boolean;

    const RESSOURCENAME = 'attributes';
  end;

implementation

uses
  System.SysUtils,
  System.IOUtils,

  Winapi.ActiveX,

  Xml.XMLIntf,
  Xml.XMLDoc;

{ TRessource_Attribute }

function TRessource_Attribute.DELETE(const id: string; jsonResponse: ISuperObject): Boolean;
   begin
    result := False;
   end;

function TRessource_Attribute.GET(const id: string; jsonResponse: ISuperObject): Boolean;
   var
    attributeList: TFileList;
    fileInfo: TFileInfo;
    fileName: string;
    Attribute: ISuperObject;
   begin
    if id.IsEmpty then
       begin
        attributeList := TFileList.Create;
        try
          if ListFiles(TPath.Combine(ExtractFilePath(ParamStr(0)), 'schichten'), 'schichten_*.xml', attributeList) > 0 then
             begin
              for fileInfo in attributeList do
                 begin
                  Attribute := SO();

                  Attribute.S['id']   := ChangeFileExt(ExtractFileName(fileInfo.Key), '');
                  Attribute.D['date'] := fileInfo.Value;

                  jsonResponse.O['data'].A['attributes'].Add(Attribute);
                 end;
             end;
          result := True;
        finally
          attributeList.Free;
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

function TRessource_Attribute.GetRessourceName: string;
   begin
    result := RESSOURCENAME;
   end;

function TRessource_Attribute.POST(const id, payload: string; jsonResponse: ISuperObject): Boolean;
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

function TRessource_Attribute.PUT(const id, payload: string; jsonResponse: ISuperObject): Boolean;
   begin
    result := False;
   end;

end.
