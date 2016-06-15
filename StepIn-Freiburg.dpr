program StepInFreiburg;

uses
  System.StartUpCopy,
  FMX.Forms,
  FMain in 'FMain.pas' {FMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFmain, vFMain);
  Application.Run;
end.
