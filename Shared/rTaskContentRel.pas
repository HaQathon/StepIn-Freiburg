unit rTaskContentRel;

interface

uses
  XSuperObject,
  uTaskContentRel,
  uRessource;

type
  TRessource_TaskContentRel = class(TRessource, IRessource)
  private

  public
    function GetRessourceName: string;

    function GET(const id: string; jsonResponse: ISuperObject): Boolean;
    function POST(const id: string; const payload: string; jsonResponse: ISuperObject): Boolean;
    function PUT(const id: string; const payload: string; jsonResponse: ISuperObject): Boolean;
    function DELETE(const id: string; jsonResponse: ISuperObject): Boolean;

    const RESSOURCENAME = 'taskcontentrel';
  end;

implementation

uses
  System.SysUtils,
  System.IOUtils,

  Winapi.ActiveX,
  System.Generics.Collections,
  Xml.XMLIntf,
  Xml.XMLDoc;

{ TRessource_Attribute }

function TRessource_TaskContentRel.DELETE(const id: string; jsonResponse: ISuperObject): Boolean;
   begin
    result := False;
   end;

function TRessource_TaskContentRel.GET(const id: string; jsonResponse: ISuperObject): Boolean;
   var
    taskContentRelList: TList<TTaskContentRel>;
    dbTaskContentRel : TTaskContentRelDatenbank;
    TaskContentRel: ISuperObject;
    aTaskContentRel:  TTaskContentRel;
   begin
    dbTaskContentRel := TTaskContentRelDatenbank.Create('StepIn');
    try
      if id.IsEmpty then
       begin
        taskContentRelList := dbTaskContentRel.getAllTaskContentRel;
        try
          for aTaskContentRel in taskContentRelList do
             begin
              TaskContentRel := SO();
              TaskContentRel := aTaskContentRel.AsJSONObject;

              jsonResponse.O['data'].A['taskcontentrel'].Add(TaskContentRel);
             end;
          result := True;
        finally
          taskContentRelList.Free;
        end;
       end
    else
       begin
        aTaskContentRel := dbTaskContentRel.get(strtointdef(id,0));
        if assigned(aTaskContentRel) then
           begin
              TaskContentRel := SO();
              TaskContentRel := aTaskContentRel.AsJSONObject;

              jsonResponse.O['data'].A['taskcontentrel'].Add(TaskContentRel);
            result := True;
           end;
       end;
    finally
     dbTaskContentRel.Free;
    end;
   end;

function TRessource_TaskContentRel.GetRessourceName: string;
   begin
    result := RESSOURCENAME;
   end;

function TRessource_TaskContentRel.POST(const id, payload: string; jsonResponse: ISuperObject): Boolean;
   var
    jsonRequest: ISuperObject;
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

function TRessource_TaskContentRel.PUT(const id, payload: string; jsonResponse: ISuperObject): Boolean;
   begin
    result := False;
   end;

end.
