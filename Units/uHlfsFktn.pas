unit uHlfsFktn;

interface

uses
<<<<<<< HEAD
  {$ifdef mswindows}
  windows,
  {$endif}
  System.SysUtils,
  System.IOUtils;

function getHomePath(): string;
function GetLanguageID: String;
//=======

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
end.
