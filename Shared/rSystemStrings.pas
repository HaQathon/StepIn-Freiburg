unit rSystemStrings;

interface

uses
  XSuperObject,
  uSystemStrings,
  uRessource;

type
  TRessource_SystemStrings = class(TRessource, IRessource)
  private

  public
    function GetRessourceName: string;

    function GET(const id: string; jsonResponse: ISuperObject): Boolean;
    function POST(const id: string; const payload: string; jsonResponse: ISuperObject): Boolean;
    function PUT(const id: string; const payload: string; jsonResponse: ISuperObject): Boolean;
    function DELETE(const id: string; jsonResponse: ISuperObject): Boolean;

    const RESSOURCENAME = 'systemstrings';
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

function TRessource_SystemStrings.DELETE(const id: string; jsonResponse: ISuperObject): Boolean;
   begin
    result := False;
   end;

function TRessource_SystemStrings.GET(const id: string; jsonResponse: ISuperObject): Boolean;
   var
    systemStringList: TList<TSystemString>;
    dbSystemString : TSystemStringDatenbank;
    SystemStrings: ISuperObject;
    systemString:  TSystemString;
   begin
    dbSystemString := TSystemStringDatenbank.Create('StepIn');
    try
      if id.IsEmpty then
       begin
        systemStringList := dbSystemString.getAllAttribute;
        try
          for systemString in systemStringList do
             begin
              SystemStrings := SO();
              SystemStrings := systemString.AsJSONObject;

              jsonResponse.O['data'].A['systemstrings'].Add(SystemStrings);
             end;
          result := True;
        finally
          systemStringList.Free;
        end;
       end
    else
       begin
        systemString := dbSystemString.get(id);
        if assigned(systemString) then
           begin
              SystemStrings := SO();
              SystemStrings := systemString.AsJSONObject;

              jsonResponse.O['data'].A['systemstrings'].Add(SystemStrings);
            result := True;
           end;
       end;
    finally
     dbSystemString.Free;
    end;
   end;

function TRessource_SystemStrings.GetRessourceName: string;
   begin
    result := RESSOURCENAME;
   end;

function TRessource_SystemStrings.POST(const id, payload: string; jsonResponse: ISuperObject): Boolean;
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

function TRessource_SystemStrings.PUT(const id, payload: string; jsonResponse: ISuperObject): Boolean;
   begin
    result := False;
   end;

end.
