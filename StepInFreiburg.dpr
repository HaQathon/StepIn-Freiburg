program StepInFreiburg;

uses
  System.StartUpCopy,
  FMX.Forms,
  Willkomen in 'Willkomen.pas' ,
  Fmain in 'Fmain.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
