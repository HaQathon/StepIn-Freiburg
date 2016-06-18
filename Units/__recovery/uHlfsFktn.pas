unit uHlfsFktn;

interface

uses

  {$ifdef mswindows}
  windows,
  {$endif}
  uFragen,
  uAttribut,
  uTaskContentRel,
  System.SysUtils,
  System.IOUtils;

function getHomePath(): string;
function GetLanguageID: String;
procedure addTestData;

implementation

function getHomePath(): string;
   begin
     {$ifdef windows}
     result := extractFilePath(paramStr(0);
     {$else}
     result := TPath.GetDocumentsPath;
     {$endif}
   end;

function GetLanguageID: String;
{$IFDEF IOS}
   var
  Languages: NSArray;
   begin
    Languages := TNSLocale.OCClass.preferredLanguages;
    Result := TNSString.Wrap(Languages.objectAtIndex(0)).UTF8String;
{$ENDIF}
{$IFDEF ANDROID}
   var
    LocServ: IFMXLocaleService;
   begin
    if TPlatformServices.Current.SupportsPlatformService(IFMXLocaleService,
     IInterface(LocServ)) then
     Result := LocServ.GetCurrentLangID;
{$ENDIF}
{$IFDEF MSWINDOWS}
   var
     buffer: MarshaledString;
     UserLCID: LCID;
     BufLen: Integer;
        begin // defaults
         UserLCID := GetUserDefaultLCID;
         BufLen := GetLocaleInfo(UserLCID, LOCALE_SISO639LANGNAME, nil, 0);
         buffer := StrAlloc(BufLen);
         if GetLocaleInfo(UserLCID, LOCALE_SISO639LANGNAME, buffer, BufLen) <> 0
         then
          Result := buffer
         else
          Result := 'en';
         StrDispose(buffer);
{$ENDIF}
    end;

{==============================================================}
procedure addTestData;
  var
  frage1:TFragen;
  frage2:TFragen;

  attr1:TAttribut;
  attr2:TAttribut;

  cont1:TTaskContentRel;
  cont2:TTaskContentRel;


  begin
  frage1:=TFragen.Create;
  frage2:=TFragen.Create;

  attr1:=TAttribut.Create;
  attr2:=TAttribut.Create;

  cont1:=TTaskContentRel.Create;
  cont2:=TTaskContentRel.Create;

  frage1.Frage:='Das ist eine Testfrage';
  frage2.Frage:='Das ist noch eine Testfrage';

  attr1.AttributName:='Ein Testattribut';
  attr2.AttributName:='Noch ein Testattribut';

  cont1.taskID:=0;
  cont1.contentID:=0;

  cont2.taskID:=1;
  cont2.contentID:=1;

  attr1.Verwendet:=0;
  attr2.Verwendet:=1;

  frage1.addToDatabase;
  frage2.addToDatabase;

  attr1.addToDatabase;
  attr2.addToDatabase;

  cont1.addToDatabase;
  cont2.addToDatabase;

  end;
end.
