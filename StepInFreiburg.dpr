program StepInFreiburg;

uses
  System.StartUpCopy,
  FMX.Forms,
  uFrmMain in 'uFrmMain.pas' {Form2},
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
  uFrmFragen in 'uFrmFragen.pas' {formFragen},
  uFrmAufgabeHinzufuegen in 'uFrmAufgabeHinzufuegen.pas' {formAufgabeHinzufuegen},
  uFragen in 'Datenbanken\uFragen.pas',
  uUnterFragen in 'Datenbanken\uUnterFragen.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TformWillkommen, formWillkommen);
  Application.CreateForm(TformMain, formMain);
  Application.CreateForm(TformFragen, formFragen);
  Application.CreateForm(TformAufgabeHinzufuegen, formAufgabeHinzufuegen);
  Application.Run;
end.
