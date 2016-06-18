unit uAttribute;

interface

uses
  XSuperObject,
  uAttribut,
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
  System.Generics.Collections,
  Xml.XMLIntf,
  Xml.XMLDoc;

{ TRessource_Attribute }

function TRessource_Attribute.DELETE(const id: string; jsonResponse: ISuperObject): Boolean;
   begin
    result := False;
   end;

function TRessource_Attribute.GET(const id: string; jsonResponse: ISuperObject): Boolean;
   var
    attributeList: TList<TAttribut>;
    dbAttribute : TAttributDatenbank;
    Attribute: ISuperObject;
    attribut:  TAttribut;
   begin
    dbAttribute := TAttributDatenbank.Create('StepIn');
    try
      if id.IsEmpty then
       begin
        attributeList := dbAttribute.getAllAttribute;
        try
          for attribut in attributeList do
             begin
              Attribute := SO();
              Attribute := attribut.AsJSONObject;

              jsonResponse.O['data'].A['attributes'].Add(Attribute);
             end;
          result := True;
        finally
          attributeList.Free;
        end;
       end
    else
       begin
        attribut := dbAttribute.get(strtointdef(id,0));
        if assigned(attribut) then
           begin
              Attribute := SO();
              Attribute := attribut.AsJSONObject;

              jsonResponse.O['data'].A['attributes'].Add(Attribute);
            result := True;
           end;
       end;
    finally
     dbAttribute.Free;
    end;
   end;

function TRessource_Attribute.GetRessourceName: string;
   begin
    result := RESSOURCENAME;
   end;

function TRessource_Attribute.POST(const id, payload: string; jsonResponse: ISuperObject): Boolean;
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

function TRessource_Attribute.PUT(const id, payload: string; jsonResponse: ISuperObject): Boolean;
   begin
    result := False;
   end;

end.
