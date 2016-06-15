program StepInFreiburg;

uses
  System.StartUpCopy,
  FMX.Forms,
  Fmain in 'Fmain.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
