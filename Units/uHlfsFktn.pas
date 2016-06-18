unit uHlfsFktn;

interface

uses
  System.IOUtils;

function getHomePath(): string;

implementation

function getHomePath(): string;
   begin
     {$ifdef windows}
     result := extractFilePath(paramStr(0);
     {$else}
     result := TPath.GetDocumentsPath;
     {$endif}
   end;

end.
