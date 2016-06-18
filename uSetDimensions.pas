unit uSetDimensions;

interface
  procedure setWillkommenDimensions();
  procedure setMainDimensions();

implementation

uses
  FMX.Forms,

  uFrmWillkommen,
  uFrmMain;
procedure setWillkommenDimensions();
   begin
    with formWillkommen do
       begin
        layTitelBild.Height := Screen.Height / 3;
        laStepIn.Height := screen.Height / 8;
        laWillkommen.Height := screen.Height / 8;
        laBeantworteFragen.Height := screen.Height / 8;
       end;
   end;

procedure setMainDimensions();
   begin
    with formMain do
       begin
        paHeader.height := screen.Height / 10;

        multiView1.width := screen.width / 4 * 3;
        layTaskHinzufuegen.width := screen.Height / 10;
       end;
   end;

end.
