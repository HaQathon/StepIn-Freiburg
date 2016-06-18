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
//   var
//    attributeList: TList<TAttribut>;
//    dbAttribute : TAttributDatenbank;
//    Attribute: ISuperObject;
//    attribut:  TAttribut;
   begin
//    dbAttribute := TAttributDatenbank.Create('StepIn');
//    try
//      if id.IsEmpty then
//       begin
//        attributeList := dbAttribute.getAllAttribute;
//        try
//          for attribut in attributeList do
//             begin
//              Attribute := SO();
//              Attribute := attribut.AsJSONObject;
//
//              jsonResponse.O['data'].A['attributes'].Add(Attribute);
//             end;
//          result := True;
//        finally
//          attributeList.Free;
//        end;
//       end
//    else
//       begin
//        attribut := dbAttribute.get(strtointdef(id,0));
//        if assigned(attribut) then
//           begin
//              Attribute := SO();
//              Attribute := attribut.AsJSONObject;
//
//              jsonResponse.O['data'].A['attributes'].Add(Attribute);
//            result := True;
//           end;
//       end;
//    finally
//     dbAttribute.Free;
//    end;
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
