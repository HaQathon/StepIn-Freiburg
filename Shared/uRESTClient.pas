unit uRESTClient;

interface

uses
  uRESTConnection,
  xSuperObject,

  Generics.Collections,

  System.SysUtils,
  System.Classes;

type
  TCompressionType = uRESTConnection.TCompressionType;
  TRequestMethod = (METHOD_GET, METHOD_POST, METHOD_PUT, METHOD_DELETE);
  ERESTException = class(Exception);

  IRESTResult = interface(IInterface)
    ['{33812B2C-99C5-4BE7-B0FF-BDBFE4E4563E}']

    function GetJSONResponse(): ISuperObject;
    function GetRessourceLocation(): string;

    function GetMessage(): string;
    function GetTotal(): Integer;
    function GetData(): ISuperObject;

    function GetResultCode: Integer;
    function GetSuccess(): Boolean;

    property JSONResponse: ISuperObject read GetJSONResponse;
    property RessourceLocation: string read GetRessourceLocation;

    property Message: string read GetMessage;
    property Total: Integer read GetTotal;
    property Data: ISuperObject read GetData;

    property StatusCode: Integer read GetResultCode;
    property Success: Boolean read GetSuccess;
  end;

  TRESTResult = class(TInterfacedObject, IRESTResult)
  protected
    FObj: ISuperObject;
    FRessourceLocation: string;
    FResultCode: Integer;
  public
    constructor Create(Obj: ISuperObject; ResultCode: Integer; RessourceLocation: string = '');
    destructor Destroy; override;

    function GetJSONResponse(): ISuperObject;
    function GetRessourceLocation(): string;

    function GetMessage(): string;
    function GetTotal(): Integer;
    function GetData(): ISuperObject;

    function GetResultCode: Integer;
    function GetSuccess(): Boolean;
  end;

  IRESTResult<T: class, constructor> = interface(IRESTResult)
    ['{9A75F790-62F7-4E06-BDE3-E690812D62F2}']

    function AsType(): T;
    function AsList(): TList<T>;
  end;

  TRESTResult<T: class, constructor> = class(TRESTResult, IRESTResult<T>)
  public
    function AsType(): T;
    function AsList(): TList<T>;
  end;

  TOnBeforeRequest = procedure(Sender: TObject; URL: string; Method: TRequestMethod; Payload: string) of Object;
  TOnAfterResponse = procedure(Sender: TObject; URL: string; Method: TRequestMethod; Payload: string; StatusCode: Integer) of Object;

  TRESTClient = class(TObject)
  private
    FHTTP: IHttpConnection;

    FBaseURL: string;

    FUseEncryption: Boolean;
    FExceptionOnNotSuccessfull: Boolean;

    FOnBeforeRequest: TOnBeforeRequest;
    FOnAfterResponse: TOnAfterResponse;
    function GenerateURL(Ressource: string; ID: string = ''; Params: string = ''): string;
    function DoRequest(const Url: string; Method: TRequestMethod; var ResultCode: Integer; const Content: string = ''): string;

    procedure CheckResponse(const response: string);
  public
    constructor Create(const BaseURL: string; const Username, Password: string; const UserAgent: string = 'highQ REST Client'; CompressionType: TCompressionType = ctNone; UseEncryption: Boolean = False);
    destructor Destroy; override;

    procedure SetHeaders(Headers: TStrings);

    function POST<T: class, constructor>(Ressource: string; Data: ISuperObject; ID: string = ''): IRESTResult<T>; overload;
    function POST(Ressource: string; Data: ISuperObject; ID: string = ''): IRESTResult; overload;
    function POST<T: class, constructor>(Ressource: string; Data: TObject; ID: string = ''): IRESTResult<T>; overload;
    function POST(Ressource: string; Data: TObject; ID: string = ''): IRESTResult; overload;

    function GET<T: class, constructor>(Ressource: string; ID: string = ''; Params: string = ''): IRESTResult<T>; overload;
    function GET(Ressource: string; ID: string = ''; Params: string = ''): IRESTResult; overload;

    function PUT(Ressource: string; ID: string; Data: ISuperObject): IRESTResult; overload;
    function PUT<T: class, constructor>(Ressource: string; ID: string; Data: ISuperObject): IRESTResult<T>; overload;
    function PUT(Ressource: string; ID: string; Data: TObject): IRESTResult; overload;
    function PUT<T: class, constructor>(Ressource: string; ID: string; Data: TObject): IRESTResult<T>; overload;

    property ExceptionOnNotSuccessfull: Boolean read FExceptionOnNotSuccessfull write FExceptionOnNotSuccessfull;
    property OnBeforeRequest: TOnBeforeRequest read FOnBeforeRequest write FOnBeforeRequest;
    property OnAfterResponse: TOnAfterResponse read FOnAfterResponse write FOnAfterResponse;
  end;

implementation

uses
  System.TypInfo,

  uRessource,

  IdURI,
  IdHTTP,
  IdGlobal;

{ TRESTClient }

procedure TRESTClient.CheckResponse(const response: string);
   begin
    if response = '' then
       begin
        raise ERESTException.Create('No response at all.');
       end;

    if not response.StartsWith('{') then
       begin
        raise ERESTException.CreateFmt('No JSON response: '#13#10#13#10'%s', [response]);
       end;
   end;

constructor TRESTClient.Create(const BaseURL: string; const Username, Password: string; const UserAgent: string; CompressionType: TCompressionType; UseEncryption: Boolean);
   begin
    FOnBeforeRequest := nil;
    FOnAfterResponse := nil;

    FHTTP := THttpConnectionIndyAuth.Create(Username, Password, UseEncryption)
            .SetUserAgent(UserAgent)
            .SetCompression(CompressionType)
            .SetAcceptCharset('utf-8')
            .SetContentType('application/json;charset=utf-8')
            .SetAcceptTypes('application/json')
            .SetTimeout(20000);

    FBaseURL := Trim(BaseURL);
    if FBaseURL.EndsWith('/') then System.Delete(FBaseURL, Length(FBaseURL), 1);

    FUseEncryption := UseEncryption;
    FExceptionOnNotSuccessfull := False;
   end;

procedure TRESTClient.SetHeaders(Headers: TStrings);
   begin
    FHTTP.SetHeaders(Headers);
   end;

destructor TRESTClient.Destroy;
   begin
    FHTTP := NIL;

    inherited;
   end;

function TRESTClient.DoRequest(const Url: string; Method: TRequestMethod; var ResultCode: Integer; const Content: string): string;
   var
    streamRequest: TStringStream;
    streamResponse: TMemoryStream;
   begin
    if Assigned(FOnBeforeRequest) then FOnBeforeRequest(self, URL, Method, Content);

    streamRequest  := TStringStream.Create(Content, TEncoding.UTF8);
    streamResponse := TMemoryStream.Create();

    try
      try
        case Method of
          METHOD_GET: FHTTP.Get(Url, streamResponse);
          METHOD_POST: FHTTP.Post(Url, streamRequest, streamResponse);
          METHOD_PUT: FHTTP.Put(Url, streamRequest, streamResponse);
          METHOD_DELETE: FHTTP.Delete(Url, streamRequest);
        end;

        streamResponse.Position := 0;
        result := ReadStringFromStream(streamResponse, -1, IndyTextEncoding_UTF8);
        ResultCode := FHTTP.ResponseCode;
      except
        on E: EIdHTTPProtocolException do
           begin
            ResultCode := E.ErrorCode;
            if E.ErrorCode = 302 then
               begin
                // Nope, no error, just a 302 forwarding to the ressource
                result := E.ErrorMessage;
               end
            else
               begin
                E.Message := Format('REST - %s'#13#10'%s'#13#10'%d: %s'#13#10'%s', [GetEnumName(TypeInfo(TRequestMethod), Ord(Method)), URL, E.ErrorCode, E.ErrorMessage, E.Message]);
                Exception.RaiseOuterException(E); // vorher ohne E
               end;
           end;
        on Ex: Exception do
           begin
            Ex.Message := Format('REST - %s'#13#10'%s'#13#10'%s', [GetEnumName(TypeInfo(TRequestMethod), Ord(Method)), URL, Ex.Message]);
            Exception.RaiseOuterException(Ex); // vorher ohne E
           end;
      end;

      if FHTTP.ResponseCode >= 500 then raise EHTTPError.Create(Format('HTTP Error: %d', [FHTTP.ResponseCode]), result, FHTTP.ResponseCode);
    finally
      streamResponse.Free;
      streamRequest.Free;
    end;

    if Assigned(FOnAfterResponse) then FOnAfterResponse(self, URL, Method, result, ResultCode);
   end;

function TRESTClient.GenerateURL(Ressource, ID, Params: string): string;
   var
    URI: TidURI;
   begin
    URI := TidURI.Create(FBaseURL + '/' + Ressource + '/' + ID);

    try
      if FUseEncryption then URI.Protocol := 'https'
      else URI.Protocol := 'http';

      URI.Params := Params;

      result := URI.GetFullURI();
    finally
      URI.Free;
    end;
   end;

function TRESTClient.GET(Ressource, ID, Params: string): IRESTResult;
   begin
    result := GET<TObject>(Ressource, ID, Params);
   end;

function TRESTClient.GET<T>(Ressource, ID, Params: string): IRESTResult<T>;
   var
    URL: string;
    response: string;
    ResultCode: Integer;
   begin
    try
      URL := GenerateURL(Ressource, ID, Params);
      TLogger.Log('Es wird ein GET auf folgende URL ausgeführt: %s', [URL]);
      response := DoRequest(URL, METHOD_GET, ResultCode);

      CheckResponse(response);

      result := TRESTResult<T>.Create(SO(response), ResultCode);

      if FExceptionOnNotSuccessfull and not result.Success then
         begin
          raise ERESTException.CreateFmt('Not successful with code %d and ErrorMessage: %s', [result.StatusCode, result.Message]);
         end;
    except
      on E: Exception do
         begin
          E.Message := Format('REST Exception in GET %s with ID "%s":'#13#10'%s', [Ressource, ID, E.Message]);
          Exception.RaiseOuterException(E);
         end;
    end;
   end;

function TRESTClient.POST(Ressource: string; Data: ISuperObject; ID: string = ''): IRESTResult;
   begin
    result := POST<TObject>(Ressource, Data, ID);
   end;

function TRESTClient.POST<T>(Ressource: string; Data: ISuperObject; ID: string = ''): IRESTResult<T>;
   var
    URL: string;
    response: string;
    ResultCode: Integer;
   begin                                   //   raise Exception.Create('Das hier funktioniert noch!');
    try                                    //   raise Exception.Create('Ab hier kommt seg fault');
      URL := GenerateURL(Ressource, ID);
      TLogger.Log('Es wird ein POST auf folgende URL ausgeführt: %s', [URL]);
      response := DoRequest(URL, METHOD_POST, ResultCode, Data.AsJSON());

      CheckResponse(response);

      result := TRESTResult<T>.Create(SO(response), ResultCode, FHTTP.GetRedirectLocation());

      if FExceptionOnNotSuccessfull and not result.Success then
         begin
          raise ERESTException.CreateFmt('Not successful with code %d and ErrorMessage: %s', [result.StatusCode, result.Message]);
         end;
    except
      on E: Exception do
         begin
          E.Message := Format('REST Exception in POST %s:'#13#10'%s', [Ressource, E.Message]);
          Exception.RaiseOuterException(E);
         end;
    end;
   end;

function TRESTClient.POST(Ressource: string; Data: TObject; ID: string = ''): IRESTResult;
   begin
    result := POST(Ressource, Data.AsJSONObject(), ID);
   end;

function TRESTClient.POST<T>(Ressource: string; Data: TObject; ID: string = ''): IRESTResult<T>;
   begin
    result := POST<T>(Ressource, Data.AsJSONObject(), ID);
   end;

function TRESTClient.PUT(Ressource, ID: string; Data: ISuperObject): IRESTResult;
   begin
    result := PUT<TObject>(Ressource, ID, Data);
   end;

function TRESTClient.PUT(Ressource, ID: string; Data: TObject): IRESTResult;
   begin
    result := PUT<TObject>(Ressource, ID, Data.AsJSONObject());
   end;

function TRESTClient.PUT<T>(Ressource, ID: string; Data: ISuperObject): IRESTResult<T>;
   var
    URL: string;
    response: string;
    ResultCode: Integer;
   begin
    try
      URL := GenerateURL(Ressource, ID);
      TLogger.Log('Es wird ein PUT auf folgende URL ausgeführt: %s', [URL]);
      response := DoRequest(URL, METHOD_PUT, ResultCode, Data.AsJSON());

      CheckResponse(response);

      result := TRESTResult<T>.Create(SO(response), ResultCode, FHTTP.GetRedirectLocation());

      if FExceptionOnNotSuccessfull and not result.Success then
         begin
          raise ERESTException.CreateFmt('Not successful with code %d and ErrorMessage: %s', [result.StatusCode, result.GetMessage()]);
         end;
    except
      on E: Exception do
         begin
          E.Message := Format('REST Exception in PUT %s:'#13#10'%s', [Ressource, E.Message]);
          Exception.RaiseOuterException(E); // vorher ohne E
         end;
    end;
   end;

function TRESTClient.PUT<T>(Ressource, ID: string; Data: TObject): IRESTResult<T>;
   begin
    result := PUT<T>(Ressource, ID, Data.AsJSONObject());
   end;

{ TRESTQueryResult }

constructor TRESTResult.Create(Obj: ISuperObject; ResultCode: Integer; RessourceLocation: string);
   begin
    inherited Create();

    FObj := Obj;
    FRessourceLocation := RessourceLocation;
    FResultCode := ResultCode;
   end;

destructor TRESTResult.Destroy;
   begin
     FObj := NIL;
    inherited;
   end;

function TRESTResult.GetData: ISuperObject;
   begin
    result := FObj.O['data'];
   end;

function TRESTResult.GetJSONResponse: ISuperObject;
   begin
    result := FObj;
   end;

function TRESTResult.GetMessage: string;
   begin
    result := FObj.S['message'];
   end;

function TRESTResult.GetRessourceLocation: string;
   begin
    result := FRessourceLocation;
   end;

function TRESTResult.GetResultCode: Integer;
   begin
    result := FResultCode;
   end;

function TRESTResult.GetSuccess: Boolean;
   begin
    result := FObj.B['success'];
   end;

function TRESTResult.GetTotal: Integer;
   begin
    result := FObj.I['total'];
   end;

{ TRESTQueryResult<T> }

function TRESTResult<T>.AsList: TList<T>;
   var
    Data: ISuperObject;
   begin
    Data := GetData;
    result := TList<T>.FromJSON(Data);
   end;

function TRESTResult<T>.AsType: T;
   var
    Data: ISuperObject;
   begin
    Data := GetData;
    result := T.FromJSON(Data);
   end;

end.
