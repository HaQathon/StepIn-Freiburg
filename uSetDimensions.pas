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
      //  laStepIn.Height := screen.Height / 8;
      //  laWillkommen.Height := screen.Height / 8;
     //   laBeantworteFragen.Height := screen.Height / 8;
     //   imStartButton.Height := screen.Height / 8;
       end;
   end;

end.
