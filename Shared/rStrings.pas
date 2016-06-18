unit rStrings;

interface

uses
  XSuperObject,
  uStrings,
  uRessource;

type
  TRessource_Strings = class(TRessource, IRessource)
  private

  public
    function GetRessourceName: string;

    function GET(const id: string; jsonResponse: ISuperObject): Boolean;
    function POST(const id: string; const payload: string; jsonResponse: ISuperObject): Boolean;
    function PUT(const id: string; const payload: string; jsonResponse: ISuperObject): Boolean;
    function DELETE(const id: string; jsonResponse: ISuperObject): Boolean;

    const RESSOURCENAME = 'strings';
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

function TRessource_Strings.DELETE(const id: string; jsonResponse: ISuperObject): Boolean;
   begin
    result := False;
   end;

function TRessource_Strings.GET(const id: string; jsonResponse: ISuperObject): Boolean;
   var
    stringList: TList<TString>;
    dbString : TStringDatenbank;
    Strings: ISuperObject;
    aString:  TString;
   begin
    dbString := TStringDatenbank.Create('StepIn');
    try
      if id.IsEmpty then
       begin
        stringList := dbString.getAllAttribute;
        try
          for astring in stringList do
             begin
              Strings := SO();
              Strings := aString.AsJSONObject;

              jsonResponse.O['data'].A['strings'].Add(Strings);
             end;
          result := True;
        finally
          stringList.Free;
        end;
       end
    else
       begin
        astring := dbString.get(id);
        if assigned(astring) then
           begin
              Strings := SO();
              Strings := aString.AsJSONObject;

              jsonResponse.O['data'].A['strings'].Add(Strings);
            result := True;
           end;
       end;
    finally
     dbString.Free;
    end;
   end;

function TRessource_Strings.GetRessourceName: string;
   begin
    result := RESSOURCENAME;
   end;

function TRessource_Strings.POST(const id, payload: string; jsonResponse: ISuperObject): Boolean;
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

function TRessource_Strings.PUT(const id, payload: string; jsonResponse: ISuperObject): Boolean;
   begin
    result := False;
   end;

end.
