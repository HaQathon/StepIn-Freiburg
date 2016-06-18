program StepInFreiburg;

uses
  System.StartUpCopy,
  FMX.Forms,
  Fmain in 'Fmain.pas' {Form2},
  uTask in 'Datenbanken\uTask.pas',
  uSQLConnection in 'Units\uSQLConnection.pas',
  uTableBase in 'Units\uTableBase.pas',
  uAttribut in 'Datenbanken\uAttribut.pas',
  uStrings in 'Datenbanken\uStrings.pas',
  uAttributeRel in 'Datenbanken\uAttributeRel.pas',
  uSystemStrings in 'Datenbanken\uSystemStrings.pas',
  uFrmWillkommen in 'uFrmWillkommen.pas' {formWillkommen},
  uSetDimensions in 'uSetDimensions.pas',
  uTaskContentRel in 'Datenbanken\uTaskContentRel.pas',
  uHlfsFktn in 'Units\uHlfsFktn.pas',
  uFrmFragen in 'uFrmFragen.pas' {fFragen};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TformWillkommen, formWillkommen);
  Application.CreateForm(TfFragen, fFragen);
  Application.Run;
end.
