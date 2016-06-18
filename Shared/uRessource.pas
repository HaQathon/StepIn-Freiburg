unit uRessource;

interface

uses
  XSuperObject,

  System.SyncObjs,
  System.Generics.Collections,

  IdContext,
  IdCustomHttpServer;

type
  IRessource = interface
  ['{2EDFB8CB-E44B-4A96-9A00-20BDC6CE53E3}']
    function GetRessourceName: string;

    function GET(const id: string; jsonResponse: ISuperObject): Boolean;
    function POST(const id: string; const payload: string; jsonResponse: ISuperObject): Boolean;
    function PUT(const id: string; const payload: string; jsonResponse: ISuperObject): Boolean;
    function DELETE(const id: string; jsonResponse: ISuperObject): Boolean;

    property RessourceName: string read GetRessourceName;
  end;

  TFileInfo = TPair<string, TDateTime>;
  TFileList = TList<TFileInfo>;

  TRessource = class abstract(TInterfacedObject)
  private
    FContext: TIdContext;
    FRequestInfo: TIdHTTPRequestInfo;
    FResponseInfo: TIdHTTPResponseInfo;
  protected
    function ListFiles(const Path, Mask: string; resultList: TFileList): Integer;
    function GetFileDate(const FileName: string): TDateTime;
    function ReadTextFile(const Path: string): string;

    property Context: TIdContext read FContext;
    property RequestInfo: TIdHTTPRequestInfo read FRequestInfo;
    property ResponseInfo: TIdHTTPResponseInfo read FResponseInfo;
  public
    constructor Create(const AContext: TIdContext; const ARequestInfo: TIdHTTPRequestInfo; const AResponseInfo: TIdHTTPResponseInfo);
  end;

  TRessourceFactory = class
  public
    class function CreateRessource(const RessouceName: string; const AContext: TIdContext; const ARequestInfo: TIdHTTPRequestInfo; const AResponseInfo: TIdHTTPResponseInfo): IRessource;
  end;

  TLogger = class
  private
    class var FLock: TCriticalSection;

    class constructor Create();
    class destructor Destroy;
  public
    class procedure Log(const s: string); overload;
    class procedure Log(const s: string; const params: array of const); overload;
  end;

const
  CURRENT_REST_VERSION = 'V1';

implementation

uses
  System.StrUtils,
  System.SysUtils,
  System.Classes,
  System.DateUtils,
  System.IOUtils,
  uAttribute,
  uContent,
  System.Generics.Defaults;

{ TRessourceFactory }

class function TRessourceFactory.CreateRessource(const RessouceName: string; const AContext: TIdContext; const ARequestInfo: TIdHTTPRequestInfo; const AResponseInfo: TIdHTTPResponseInfo): IRessource;
   begin
    case IndexText(RessouceName, [TRessource_Attribute.RESSOURCENAME, TRessource_Content.RESSOURCENAME]) of
      0: result := TRessource_Attribute.Create(AContext, ARequestInfo, AResponseInfo);
      1: result := TRessource_Content.Create(AContext, ARequestInfo, AResponseInfo);
      else result := NIL;
    end;
   end;

{ TRessource }

constructor TRessource.Create(const AContext: TIdContext; const ARequestInfo: TIdHTTPRequestInfo; const AResponseInfo: TIdHTTPResponseInfo);
   begin
    FContext := AContext;
    FRequestInfo := ARequestInfo;
    FResponseInfo := AResponseInfo;
   end;

function TRessource.GetFileDate(const FileName: string): TDateTime;
   begin
    FileAge(FileName, result);
   end;

function TRessource.ListFiles(const Path, Mask: string; resultList: TFileList): Integer;
   var
    Files: TStrings;
    FileName: string;
   begin
    resultList.Clear;

    Files := TStringList.Create();
    try
      //FindAllFiles(Files, Path, Mask, False);

      for FileName in Files do
         begin
          resultList.Add(TFileInfo.Create(FileName, GetFileDate(FileName)));
         end;
    finally
      Files.Free;
    end;

    resultList.Sort(TComparer<TFileInfo>.Construct(
      function (const L, R: TFileInfo): Integer
         begin
          result := CompareDateTime(R.Value, L.Value);
         end
    ));

    result := resultList.Count;
   end;

function TRessource.ReadTextFile(const Path: string): string;
   var
    Bytes: TBytes;
    Len: Integer;
   function ContainsPreamble(const Buffer, Signature: array of Byte): Boolean;
      var
       I: Integer;
      begin
       result := True;
       if Length(Buffer) >= Length(Signature) then
          begin
           for I := 1 to Length(Signature) do
              begin
               if Buffer[I - 1] <> Signature [I - 1] then
                  begin
                   result := False;
{b}                break;
                  end;
              end;
          end
        else result := False;
      end;
   begin
    Bytes := TFile.ReadAllBytes(Path);

    if ContainsPreamble(Bytes, TEncoding.UTF8.GetPreamble()) then
       begin
        Len := Length(TEncoding.UTF8.GetPreamble);
        result := TEncoding.UTF8.GetString(Bytes, Len, Length(Bytes) - Len);
       end
    else result := TEncoding.UTF8.GetString(Bytes);
   end;

{ TLogger }

class constructor TLogger.Create;
   begin
    FLock := TCriticalSection.Create;
   end;

class destructor TLogger.Destroy;
   begin
    FLock.Enter;
    FLock.Free;
   end;

class procedure TLogger.Log(const s: string; const params: array of const);
   begin
    Log(Format(s, params));
   end;

class procedure TLogger.Log(const s: string);
   var
    f: TextFile;
    FileName: string;
   begin
    FLock.Enter;
    try
      FileName := TPath.Combine(ExtractFilePath(ParamStr(0)), TPath.Combine('etc', 'Log_' + FormatDateTime('yyyymmdd', Now) + '.txt'));
{$IOChecks OFF}
      AssignFile(f, FileName);
      if FileExists(FileName) then Append(f)
      else Rewrite(f);

      Writeln(f, Format('%s: %s', [FormatDateTime('hh:nn:ss', Now), s]));
      CloseFile(f);
{$IOCHECKS ON}
    finally
      FLock.Leave;
    end;
   end;

end.
