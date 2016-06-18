unit uFrmAufgabeHinzufuegen;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.ListBox, FMX.ScrollBox, FMX.Memo,
  FMX.Edit, uFrmWillkommen;

type
  TformAufgabeHinzufuegen = class(TForm)
    paHeader: TPanel;
    laAufgaben: TLabel;
    Layout1: TLayout;
    eTitel: TEdit;
    memoBeschreibung: TMemo;
    btnAufgabeSpeichern: TButton;
    cbAttributAuswahl: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure btnAufgabeSpeichernClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  formAufgabeHinzufuegen: TformAufgabeHinzufuegen;

implementation

{$R *.fmx}

uses
  System.Generics.collections,
  uAttribut, uTask;

procedure TformAufgabeHinzufuegen.btnAufgabeSpeichernClick(Sender: TObject);
   var
    tempTask: TTask;
  begin
    tempTask := TTask.Create;
    tempTask.taskName := eTitel.Text;
    tempTask.taskInfo := memoBeschreibung.Text;
    TaskDatenbank.addToDatabase(tempTask);
  end;

procedure TformAufgabeHinzufuegen.FormCreate(Sender: TObject);
   var
     attribute: TList<TAttribut>;
     tmpAttribut: TAttribut;
  begin
   attribute := TList<TAttribut>.Create;
   try
     attribute := AttributDatenbank.getAllAttribute();
     for tmpAttribut in attribute do
        begin
         cbAttributAuswahl.Items.Add(tmpAttribut.AttributName);
        end;
   finally
    attribute.Free;
   end;

  end;

end.
