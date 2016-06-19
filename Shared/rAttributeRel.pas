unit rAttributeRel;

interface

uses
  XSuperObject,
  uAttributeRel,
  uRessource;

type
  TRessource_AttributeRel = class(TRessource, IRessource)
  private

  public
    function GetRessourceName: string;

    function GET(const id: string; jsonResponse: ISuperObject): Boolean;
    function POST(const id: string; const payload: string; jsonResponse: ISuperObject): Boolean;
    function PUT(const id: string; const payload: string; jsonResponse: ISuperObject): Boolean;
    function DELETE(const id: string; jsonResponse: ISuperObject): Boolean;

    const RESSOURCENAME = 'attributerel';
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

function TRessource_AttributeRel.DELETE(const id: string; jsonResponse: ISuperObject): Boolean;
   begin
    result := False;
   end;

function TRessource_AttributeRel.GET(const id: string; jsonResponse: ISuperObject): Boolean;
   var
    attributeRelList: TList<TAttributRel>;
    dbAttributeRel : TAttributRelDatenbank;
    AttributeRel: ISuperObject;
    attributRel:  TAttributRel;
   begin
    dbAttributeRel := TAttributRelDatenbank.Create('StepIn');
    try
      if id.IsEmpty then
       begin
        attributeRelList := dbAttributeRel.getAllAttribute;
        try
          for attributRel in attributeRelList do
             begin
              AttributeRel := SO();
              AttributeRel := attributRel.AsJSONObject;

              jsonResponse.O['data'].A['attributerel'].Add(AttributeRel);
             end;
          result := True;
        finally
          attributeRelList.Free;
        end;
       end
    else
       begin
        attributRel := dbAttributeRel.get(strtointdef(id,0));
        if assigned(attributRel) then
           begin
              AttributeRel := SO();
              AttributeRel := attributRel.AsJSONObject;

              jsonResponse.O['data'].A['attributerel'].Add(AttributeRel);
            result := True;
           end;
       end;
    finally
     dbAttributeRel.Free;
    end;
   end;

function TRessource_AttributeRel.GetRessourceName: string;
   begin
    result := RESSOURCENAME;
   end;

function TRessource_AttributeRel.POST(const id, payload: string; jsonResponse: ISuperObject): Boolean;
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

function TRessource_AttributeRel.PUT(const id, payload: string; jsonResponse: ISuperObject): Boolean;
   begin
    result := False;
   end;

end.
