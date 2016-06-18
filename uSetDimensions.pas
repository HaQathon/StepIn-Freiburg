unit uSetDimensions;

interface
  procedure setWillkommenDimensions();

implementation

uses
  FMX.Forms,

  uFrmWillkommen;
procedure setWillkommenDimensions();
   begin
    with formWillkommen do
       begin
        layTitelBild.Height := Screen.Height / 2;
       end;
   end;

end.
