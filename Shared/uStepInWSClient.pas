unit uStepInWSClient;


interface

uses
  xSuperObject,
  uRESTClient;

type
  TStepInWSClient = class
  private
    FRESTClient: TRESTClient;
  public
    constructor Create;
    destructor Destroy; override;

    function sendContent(aJSONRequest: ISuperObject): ISuperObject;
    function sendAttribute(aJSONRequest: ISuperObject): ISuperObject;

    function getContent(const id: string): ISuperObject;
    function getAttribute(const id: string): ISuperObject;

  end;

implementation

uses
  System.SysUtils;

{ THUSSTWSClient }

const
STEP_IN_SERVER_URL = 'http://localhost:7373/HUSST/V1';


constructor TStepInWSClient.Create;
   var
    CompressionType: TCompressionType;
   begin
    CompressionType := TCompressionType.ctGzip;
    //CompressionType := TCompressionType.ctNone;

    FRESTClient := TRESTClient.Create(STEP_IN_SERVER_URL, 'StepIn', 'testPassword', 'OS Version, App Version', CompressionType, false);
   end;

destructor TStepInWSClient.Destroy;
   begin
    FRESTClient.Free;

    inherited;
   end;

function TStepInWSClient.sendContent(aJSONRequest: ISuperObject): ISuperObject;
   begin
    result := FRESTClient.POST('content', aJSONRequest).JSONResponse;
   end;

function TStepInWSClient.sendAttribute(aJSONRequest: ISuperObject): ISuperObject;
   begin
    result := FRESTClient.POST('attribute', aJSONRequest).JSONResponse;
   end;

function TStepInWSClient.getContent(const id: string): ISuperObject;
   begin
    result := FRESTClient.GET('content').GetJsonResponse();
   end;

function TStepInWSClient.GetAttribute(const id: string): ISuperObject;
   begin
    result := FRESTClient.GET('attribute').GetJsonResponse();
   end;

end.
