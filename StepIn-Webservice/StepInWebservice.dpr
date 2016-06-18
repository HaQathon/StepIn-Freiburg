program StepInWebservice;

uses
  Vcl.SvcMgr,
  IdZLib in '..\..\Objects\Patch\IdZLib.pas',
  uRessource in '..\Shared\uRessource.pas',
  uAttribute in '..\Shared\uAttribute.pas',
  uContent in '..\Shared\uContent.pas',
  FStepInWebservice in 'FStepInWebservice.pas' {StepInService: TService};

{$R *.RES}

begin
  // Windows 2003 Server requires StartServiceCtrlDispatcher to be
  // called before CoRegisterClassObject, which can be called indirectly
  // by Application.Initialize. TServiceApplication.DelayInitialize allows
  // Application.Initialize to be called from TService.Main (after
  // StartServiceCtrlDispatcher has been called).
  //
  // Delayed initialization of the Application object may affect
  // events which then occur prior to initialization, such as
  // TService.OnCreate. It is only recommended if the ServiceApplication
  // registers a class object with OLE and is intended for use with
  // Windows 2003 Server.
  //
  // Application.DelayInitialize := True;
  //

  if not Application.DelayInitialize or Application.Installing then
     begin
      Application.Initialize;
     end;

  Application.CreateForm(TStepInService, StepInService);
  Application.Run;
end.
