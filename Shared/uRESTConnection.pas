unit uRESTConnection;

interface

uses
  System.Classes,
  System.SysUtils,

  IdSSLOpenSSL,
  REST.OpenSSL, // dll header import
  IdHTTP;

type
  EHTTPError = class(Exception)
  private
    FErrorCode: Integer;
    FErrorMessage: string;
  public
    constructor Create(const AMsg, AErrorMessage: string; const AErrorCode: integer); overload; virtual;

    property ErrorMessage: string read FErrorMessage;
    property ErrorCode: integer read FErrorCode;
  end;

  TIdHTTP = class(idHTTP.TIdHTTP)
  public
    procedure Delete(AURL: string);
  end;

  TCompressionType = (ctNone, ctGzip, ctDeflate);

  IHttpConnection = interface
  ['{B9611100-5243-4874-A777-D91448517116}']
    function SetAcceptTypes(AAcceptTypes: string): IHttpConnection;
    function SetAcceptCharset(AAcceptCharset: string): IHttpConnection;
    function SetContentType(AContentTypes: string): IHttpConnection;
    function SetHeaders(AHeaders: TStrings): IHttpConnection;
    function SetCompression(Compression: TCompressionType): IHttpConnection;
    function SetUserAgent(UserAgent: string): IHttpConnection;
    function SetTimeout(Timeout: Cardinal): IHttpConnection;

    procedure Get(AUrl: string; AResponse: TStream);
    procedure Post(AUrl: string; AContent, AResponse: TStream);
    procedure Put(AUrl: string; AContent, AResponse: TStream);
    procedure Delete(AUrl: string; AContent: TStream);

    function GetResponseCode: Integer;
    function GetRedirectLocation: string;

    property ResponseCode: Integer read GetResponseCode;
  end;

  THttpConnectionIndyAuth = class(TInterfacedObject, IHttpConnection)
  private
    FIdHttp: TIdHTTP;
    FCompression: TCompressionType;
    FFirstCall: Boolean;

    procedure HandleNextAuth;
    procedure HandleCompression(const Source, Dest: TStream);

    function OnVerifyPeer(Certificate: TIdX509; AOk: Boolean; ADepth, AError: Integer): Boolean;
  public
    constructor Create(AUserName: string; APassword: string; UseSSL: Boolean);
    destructor Destroy; override;

    function SetAcceptTypes(AAcceptTypes: string): IHttpConnection;
    function SetAcceptCharset(AAcceptCharset: string): IHttpConnection;
    function SetContentType(AContentTypes: string): IHttpConnection;
    function SetHeaders(AHeaders: TStrings): IHttpConnection;
    function SetCompression(Compression: TCompressionType): IHttpConnection;
    function SetUserAgent(UserAgent: string): IHttpConnection;
    function SetTimeout(Timeout: Cardinal): IHttpConnection;

    procedure Get(AUrl: string; AResponse: TStream);
    procedure Post(AUrl: string; AContent: TStream; AResponse: TStream);
    procedure Put(AUrl: string; AContent: TStream; AResponse: TStream);
    procedure Delete(AUrl: string; AContent: TStream);

    function GetResponseCode: Integer;
    function GetRedirectLocation: string;
  end;

implementation

uses
  IdAllAuthentications,
  IdCompressorZLib,
  IDZlib;

{ THttpConnectionIndy }

constructor THttpConnectionIndyAuth.Create(AUserName: string; APassword: string; UseSSL: Boolean);
   var
    SSLIOHandler: TIdSSLIOHandlerSocketOpenSSL;
   begin
    FIdHttp := TIdHTTP.Create(nil);

    if UseSSL then
       begin
        SSLIOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(FIdHttp);
        SSLIOHandler.SSLOptions.Mode        := sslmClient;
        SSLIOHandler.SSLOptions.Method      := sslvTLSv1_2;
        SSLIOHandler.SSLOptions.VerifyMode  := [sslvrfPeer];
        SSLIOHandler.SSLOptions.VerifyDepth := 2;

        SSLIOHandler.OnVerifyPeer := OnVerifyPeer;

        FIdHttp.IOHandler := SSLIOHandler;
       end;

    FIdHttp.HandleRedirects := False;
    FIdHttp.ProtocolVersion := pv1_1;
    FIdHttp.Request.CustomHeaders.FoldLines := False;

    FIdHttp.Request.BasicAuthentication := True;
    FIdHttp.Request.Username := AUserName;
    FIdHttp.Request.Password := APassword;


    FIdHttp.HTTPOptions := FIdHttp.HTTPOptions + [hoInProcessAuth];

    FFirstCall := True;
   end;

procedure THttpConnectionIndyAuth.Delete(AUrl: string; AContent: TStream);
   begin
    FIdHttp.Request.Source := AContent;

    HandleNextAuth;

    FIdHttp.Delete(AUrl);
   end;

destructor THttpConnectionIndyAuth.Destroy;
   begin
    FIdHttp.Free;
    inherited;
   end;

procedure THttpConnectionIndyAuth.Get(AUrl: string; AResponse: TStream);
   begin
    HandleNextAuth;
    FIdHttp.Get(AUrl, AResponse);
   end;

function THttpConnectionIndyAuth.GetRedirectLocation: string;
   begin
    result := FIdHttp.Response.Location;
   end;

function THttpConnectionIndyAuth.GetResponseCode: Integer;
   begin
    result := FIdHttp.Response.ResponseCode;
   end;

procedure THttpConnectionIndyAuth.HandleCompression(const Source, Dest: TStream);
   begin
    Source.Position := 0;

    case FCompression of
      ctNone:
         begin
          Dest.CopyFrom(Source, 0);
         end;
      ctGzip:
         begin
          FIdHttp.Request.ContentEncoding := 'gzip';
          FIdHttp.Compressor.CompressStream(Source, Dest, 9, GZIP_WINBITS, 9, 0);
         end;
      ctDeflate:
         begin
          FIdHttp.Request.ContentEncoding := 'deflate';
          FIdHttp.Compressor.CompressHTTPDeflate(Source, Dest, 4);
         end;
    end;

    Dest.Position := 0;
   end;

procedure THttpConnectionIndyAuth.HandleNextAuth;
   begin
    if FFirstCall then FFirstCall := False
    else FIdHttp.Request.Authentication.Next;
   end;

function THttpConnectionIndyAuth.OnVerifyPeer(Certificate: TIdX509; AOk: Boolean; ADepth, AError: Integer): Boolean;
   const
    CAFingerprint = 'CE:07:1B:04:1E:A5:85:2D:54:F6:60:BB:D3:78:18:F9';
    X509_V_ERR_SELF_SIGNED_CERT_IN_CHAIN = 19;
   begin
    // Note this is called MULTIPLE times, one for each cert in the chain,
    // starting with the CA cert & ending with the user cert.

    if not AOk and (AError = X509_V_ERR_SELF_SIGNED_CERT_IN_CHAIN) then
       begin
        // CA per Fingerprint identifizieren
        result := SameText(CAFingerprint, Certificate.FingerprintAsString);
       end
    else
       begin
        // AOK reflects the result of the verification by Indy
        result := AOk;
       end;

    // Zeitliche Gültigkeit
    result := result and (Certificate.notBefore < now) and (Certificate.notAfter > now);
   end;

procedure THttpConnectionIndyAuth.Post(AUrl: string; AContent, AResponse: TStream);
   var
    lReqStream: TStream;
   begin
    HandleNextAuth;

    lReqStream := TMemoryStream.Create;
    try
      HandleCompression(AContent, lReqStream);

      FIdHttp.Post(AUrl, lReqStream, AResponse);
    finally
      lReqStream.Free;
    end;
   end;

procedure THttpConnectionIndyAuth.Put(AUrl: string; AContent, AResponse: TStream);
   var
    lReqStream: TStream;
   begin
    HandleNextAuth;

    lReqStream := TMemoryStream.Create;
    try
      HandleCompression(AContent, lReqStream);

      FIdHttp.Put(AUrl, lReqStream, AResponse);
    finally
      lReqStream.Free;
    end;
   end;

function THttpConnectionIndyAuth.SetAcceptCharset(AAcceptCharset: string): IHttpConnection;
   begin
    FIdHttp.Request.AcceptCharSet := AAcceptCharset;
    result := self;
   end;

function THttpConnectionIndyAuth.SetAcceptTypes(AAcceptTypes: string): IHttpConnection;
   begin
    FIdHttp.Request.Accept := AAcceptTypes;
    result := self;
   end;

function THttpConnectionIndyAuth.SetContentType(AContentTypes: string): IHttpConnection;
   begin
    FIdHttp.Request.ContentType := AContentTypes;
    result := self;
   end;

function THttpConnectionIndyAuth.SetCompression(Compression: TCompressionType): IHttpConnection;
   begin
    if (FCompression <> Compression) then
       begin
        FCompression := Compression;

        if Assigned(FIdHttp.Compressor) then
           begin
{$ifdef AUTOREFCOUNT}
{$else}
            FIdHttp.Compressor.Free;
{$endif}
            FIdHttp.Compressor := NIL;
           end;

        if FCompression <> ctNone then
           begin
            {$IFDEF DELPHI_XE2}
              {$Message Warn 'TIdCompressorZLib does not work properly in Delphi XE2. Access violation occurs.'}
            {$ENDIF}
            FIdHttp.Compressor := TIdCompressorZLib.Create(FIdHttp);
           end;
       end;

    result := self;
   end;

function THttpConnectionIndyAuth.SetHeaders(AHeaders: TStrings): IHttpConnection;
   begin
    FIdHttp.Request.CustomHeaders.Clear;
    FIdHttp.Request.CustomHeaders.AddStrings(AHeaders);
    result := Self;
   end;

function THttpConnectionIndyAuth.SetTimeout(Timeout: Cardinal): IHttpConnection;
   begin
    FIdHttp.ConnectTimeout := Timeout;
    FIdHttp.ReadTimeout := Timeout;
    result := self;
   end;

function THttpConnectionIndyAuth.SetUserAgent(UserAgent: string): IHttpConnection;
   begin
    FIdHttp.Request.UserAgent := UserAgent;
    result := self;
   end;

{ TIdHTTP }

procedure TIdHTTP.Delete(AURL: string);
   begin
    DoRequest(Id_HTTPMethodDelete, AURL, Request.Source, nil, []);
   end;

{ EHTTPError }

constructor EHTTPError.Create(const AMsg, AErrorMessage: string; const AErrorCode: integer);
   begin
    inherited Create(AMsg);
    FErrorMessage := AErrorMessage;
    FErrorCode := AErrorCode;
   end;

end.
