program StepInTestClient;

uses
  System.StartUpCopy,
  FMX.MobilePreview,
  FMX.Forms,
  uContent in '..\..\Shared\uContent.pas',
  uAttribute in '..\..\Shared\uAttribute.pas',
  uRessource in '..\..\Shared\uRessource.pas',
  xSuperObject in '..\..\Shared\xSuperObject.pas',
  xSuperJSON in '..\..\Shared\xSuperJSON.pas',
  uRESTClient in '..\..\Shared\uRESTClient.pas',
  uRESTConnection in '..\..\Shared\uRESTConnection.pas',
  uStepInWSClient in '..\..\Shared\uStepInWSClient.pas',
  fMain in 'fMain.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
