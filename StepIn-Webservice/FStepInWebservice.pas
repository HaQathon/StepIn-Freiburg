unit FStepInWebservice;

interface

uses
  Winapi.Windows,

  System.SysUtils,
  System.Classes,

  Vcl.SvcMgr,

  IdBaseComponent,
  IdComponent,
  IdCustomTCPServer,
  IdCustomHTTPServer,
  IdHTTPServer,
  IdContext,
  IdSSLOpenSSLHeaders,
  IdSSLOpenSSL,

  XSuperObject;

type
  TStepInService = class(TService)
    IdStepInServer: TIdHTTPServer;
    procedure FormCreate(Sender: TObject);
    procedure IdHUSSTServerCommandGet(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);

    procedure ServiceAfterInstall(Sender: TService);
    procedure IdHUSSTServerQuerySSLPort(APort: Word; var VUseSSL: Boolean);
    procedure OnGetPassword(var Password: String);
    function OnVerifyPeer(Certificate: TIdX509; AOk: Boolean; ADepth, AError: Integer): Boolean;
  private
    { Private declarations }
    function DecodeRequest(const ARequestInfo: TIdHTTPRequestInfo): string;
    procedure EncodeResponse(const ARequestInfo: TIdHTTPRequestInfo; const AResponseInfo: TIdHTTPResponseInfo; const response: string);
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  StepInService: TStepInService;

implementation

uses
  System.RegularExpressions,
  System.IOUtils,
  System.Win.Registry,

  IdGlobal,
  IdGlobalProtocols,
  IdCompressorZLib,
  IdZLib,

  //uSQLConnection,
  uRessource;

{$R *.dfm}

const
  SESSION_TIMEOUT  = 600;
  DEFAULT_PORT     = 7373;

  SVC_DESCRIPTION  = 'Webservice-Schnittstelle für den Datenaustausch mit StepIn-Freiburg App';
  DISPLAY_NAME     = 'StepIn-Freiburg Daten Webservice';


procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  StepInService.Controller(CtrlCode);
end;

function TStepInService.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

function TStepInService.DecodeRequest(const ARequestInfo: TIdHTTPRequestInfo): string;
   var
    Compressor: TIdCompressorZLib;
    tmpStream: TStream;
   begin
    if Assigned(ARequestInfo.PostStream) then
       begin
        Compressor := TIdCompressorZLib.Create;
        tmpStream := TMemoryStream.Create;
        try
          case PosInStrArray(ARequestInfo.ContentEncoding, ['gzip', 'deflate'], False) of
            0: Compressor.DecompressGZipStream(ARequestInfo.PostStream, tmpStream);
            1: Compressor.DecompressHTTPDeflate(ARequestInfo.PostStream, tmpStream);
            else tmpStream.CopyFrom(ARequestInfo.PostStream, 0);
          end;

          tmpStream.Position := 0;

          result := ReadStringAsCharset(tmpStream, ARequestInfo.CharSet);
        finally
          tmpStream.Free;
          Compressor.Free;
        end;
       end
    else
       begin
        result := ARequestInfo.Params.Text;
        if result = '' then result := ARequestInfo.UnparsedParams;
       end;
   end;

procedure TStepInService.EncodeResponse(const ARequestInfo: TIdHTTPRequestInfo; const AResponseInfo: TIdHTTPResponseInfo; const response: string);
   var
    Compressor: TIdCompressorZLib;
    tmpStream: TStream;
   begin
    Compressor := TIdCompressorZLib.Create;
    tmpStream := TMemoryStream.Create;

    try
      AResponseInfo.ContentStream := TMemoryStream.Create;

      if ARequestInfo.AcceptCharSet.Contains('UTF-8') then
         begin
          WriteStringToStream(tmpStream, response, IndyTextEncoding_UTF8);
          AResponseInfo.CharSet := 'UTF-8';
         end
      else if ARequestInfo.AcceptCharSet.Contains('ISO-8859-1') then
         begin
          WriteStringToStream(tmpStream, response, IndyTextEncoding_ASCII);
          AResponseInfo.CharSet := 'ISO-8859-1';
         end
      else
         begin
          WriteStringToStream(tmpStream, response, IndyTextEncoding_Default);
         end;

      tmpStream.Position := 0;

      if ARequestInfo.AcceptEncoding.Contains('gzip') then
         begin
          Compressor.CompressStream(tmpStream, AResponseInfo.ContentStream, 9, GZIP_WINBITS, 9, 0);
          AResponseInfo.ContentEncoding := 'gzip';
         end
      else if ARequestInfo.AcceptEncoding.Contains('deflate') then
         begin
          Compressor.CompressHTTPDeflate(tmpStream, AResponseInfo.ContentStream, 4);
          AResponseInfo.ContentEncoding := 'deflate';
         end
      else
         begin
          AResponseInfo.ContentStream.CopyFrom(tmpStream, 0);
          AResponseInfo.ContentEncoding := 'identity';
         end;
    finally
      tmpStream.Free;
      Compressor.Free;
    end;
   end;

procedure TStepInService.FormCreate(Sender: TObject);
   var
    path : String;
    SSLHandler: TIdServerIOHandlerSSLOpenSSL;
   begin
    IdStepInServer.DefaultPort       := DEFAULT_PORT;
    IdStepInServer.Bindings.Add.Port := DEFAULT_PORT;
    IdStepInServer.Bindings.Add.Port := DEFAULT_PORT + 1;
    IdStepInServer.SessionTimeOut    := SESSION_TIMEOUT;

    path := ExtractFilePath(paramstr(0));
    IdOpenSSLSetLibPath(path);

    SSLHandler := TIdServerIOHandlerSSLOpenSSL.Create(IdStepInServer);

    SSLHandler.SSLOptions.CertFile     := TPath.Combine(TPath.Combine(ExtractFilePath(ParamStr(0)), 'zertifikate'), 'cert_CHILD.pem');
    SSLHandler.SSLOptions.KeyFile      := TPath.Combine(TPath.Combine(ExtractFilePath(ParamStr(0)), 'zertifikate'), 'key_CHILD.pem');
    SSLHandler.SSLOptions.RootCertFile := TPath.Combine(TPath.Combine(ExtractFilePath(ParamStr(0)), 'zertifikate'), 'cert_ROOT.pem');
    SSLHandler.SSLOptions.Method       := sslvTLSv1_2;
    SSLHandler.SSLOptions.Mode         := sslmServer;
    SSLHandler.SSLOptions.VerifyDepth  := 1;
    SSLHandler.SSLOptions.VerifyMode   := []; // [sslvrfPeer, sslvrfFailIfNoPeerCert, sslvrfClientOnce];

    SSLHandler.OnGetPassword := OnGetPassword;
    SSLHandler.OnVerifyPeer  := OnVerifyPeer;

//    IdStepInServer.IOHandler := SSLHandler;
    IdStepInServer.Active    := True;
   end;

procedure TStepInService.IdHUSSTServerCommandGet(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
   var
    jsonResponse: ISuperObject;
    result: Boolean;
    Match: TMatch;
    payload: string;
    ressource: IRessource;
    id: string;
   begin
    TLogger.Log('Command: %s', [ARequestInfo.Command]);
    TLogger.Log('Path: %s', [ARequestInfo.Document]);
    TLogger.Log('User: %s', [ARequestInfo.AuthUsername]);
    TLogger.Log('Agent: %s', [ARequestInfo.UserAgent]);
    TLogger.Log('Content-Encoding: %s, Accept-Encoding: %s, Content-Type: %s, Accept: %s, Charset: %s, Accept-Charset: %s', [ARequestInfo.ContentEncoding, ARequestInfo.AcceptEncoding, ARequestInfo.ContentType, ARequestInfo.Accept, ARequestInfo.CharSet, ARequestInfo.AcceptCharSet]);

    try
      if not ARequestInfo.AuthPassword.Equals('testPassword') then raise Exception.CreateFmt('Invalid user auth for user %s', [ARequestInfo.AuthUsername]);

      jsonResponse := SO();

      payload := DecodeRequest(ARequestInfo);

      Match := TRegEx.Match(ARequestInfo.Document, '^\/data\/([\w.]+)\/(\w+)\/?(\w*)', [roIgnoreCase]);

      if Match.Success then
         begin
          id := Match.Groups[3].Value;

          TLogger.Log('Version %s, resource %s, id %s', [Match.Groups[1].Value, Match.Groups[2].Value, id]);

          if SameText(Match.Groups[1].Value, 'V1') then
             begin
              ressource := TRessourceFactory.CreateRessource(Match.Groups[2].Value, AContext, ARequestInfo, AResponseInfo);

              if Assigned(ressource) then
                 begin
                  case ARequestInfo.CommandType of
                    hcGET   : result := ressource.GET(id, jsonResponse);
                    hcDELETE: result := ressource.DELETE(id, jsonResponse);
                    hcPUT   : result := ressource.PUT(id, payload, jsonResponse);
                    hcPOST  : result := ressource.POST(id, payload, jsonResponse);
                    else result := False;
                  end;
                 end
              else
                 begin
                  jsonResponse.S['errorMsg'] := Format('Ressource type ''%s'' not found', [Match.Groups[2].Value]);
                  result := False;
                 end;
             end
          else
             begin
              jsonResponse.S['errorMsg'] := Format('API version ''%s'' is not valid', [Match.Groups[1].Value]);
              result := False;
             end;
         end
      else
         begin
          jsonResponse.S['errorMsg'] := Format('Cannot extract API version and ressource type from path ''%s''', [ARequestInfo.Document]);
          result := False;
         end;

      jsonResponse.B['success'] := result;

      EncodeResponse(ARequestInfo, AResponseInfo, JSONResponse.AsJSON);
      AResponseInfo.ContentType := 'application/json';

      if result then TLogger.Log('Response result is positive')
      else TLogger.Log('Response result is negative with message: %s', [jsonResponse.S['errorMsg']]);
    except
      on e: Exception do
         begin
          TLogger.Log('Exception type %s with message: %s', [e.ClassName, e.Message]);
          raise;
         end;
    end;
   end;

procedure TStepInService.IdHUSSTServerQuerySSLPort(APort: Word; var VUseSSL: Boolean);
   begin
    VUseSSL := (APort = DEFAULT_PORT + 1);

    TLogger.Log('');
    TLogger.Log('=================  New Request  =================');
    TLogger.Log('New Connection on Port %d, use SSL: %s', [APort, BoolToStr(VUseSSL, True)]);
   end;

procedure TStepInService.OnGetPassword(var Password: String);
   begin
    Password := 'changeit';
   end;

function TStepInService.OnVerifyPeer(Certificate: TIdX509; AOk: Boolean; ADepth, AError: Integer): Boolean;
   begin
    // Ermöglicht die Validierung eines Clientzertifikates
    result := AOk;
   end;

procedure TStepInService.ServiceAfterInstall(Sender: TService);
   const
    SERVICE_KEY = '\SYSTEM\CurrentControlSet\Services\';
   var
    Reg: TRegistry;
   begin
    Reg := TRegistry.Create(KEY_READ or KEY_WRITE);
    try
      Reg.RootKey := HKEY_LOCAL_MACHINE;
      if (Reg.KeyExists(SERVICE_KEY + Name)) then
         begin
          if Reg.OpenKey(SERVICE_KEY + Name, false) then
             begin
              Reg.WriteString('Description', SVC_DESCRIPTION);
              Reg.CloseKey;
             end;
         end;
    finally
      Reg.Free;
    end;
   end;



end.
