unit uFrmFragen;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.ListBox, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Header,
  System.Generics.Collections, uFragen, uUnterfragen, uFrmWIllkommen;

type
  TformFragen = class(TForm)
    lbFragen: TListBox;
    paHeader: TPanel;
    laFragen: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
    fragenListe: TList<TFragen>;
    unterfragenListe: TList<TUnterFrage>;
  public
    { Public-Deklarationen }
    procedure fragenHinzufuegen();
    procedure addFragenExpander(frage: TFragen; unterfragenListe: TList<TUnterFrage>);
  end;

var
  formFragen: TformFragen;

implementation

{$R *.fmx}
procedure TformFragen.FormCreate(Sender: TObject);
  begin
   fragenHinzufuegen();
  end;

procedure TformFragen.fragenHinzufuegen();
   var
     tmpFrage: TFragen;
  begin
   fragenListe := TList<TFragen>.Create;
   try
     fragenListe := FragenDatenbank.getAllFragen();
     for tmpFrage in fragenListe do
        begin
         unterfragenListe := unterfragenDatenbank.sucheEintraege(unterFragenDatenbank.cHauptfrageID + ' = ' + tmpFrage.id.ToString);                                  // TODO
         addFragenExpander(tmpFrage, unterfragenListe);
        end;
   finally
    fragenListe.Free;
   end;
  end;

procedure TformFragen.addFragenExpander(frage: TFragen; unterfragenListe: TList<TUnterFrage>);
   var
     titel: string;
     unterfrageText: TLabel;
     lay: TLayout;
     cb: TcheckBox;
     exp: TExpander;
     tmpUnterfrage: TUnterFrage;
   begin
    exp := TExpander.Create(self);
    exp.parent := lbFragen;
    exp.Text := frage.frage;

    for tmpUnterfrage in unterfragenListe do
       begin
          lay := TLayout.Create(self);
          lay.parent := exp;
          lay.align := TAlignLayout.top;
          lay.Height := 25;

          unterfrageText := TLabel.Create(self);
          unterfrageText.parent := lay;
          unterfrageText.align := TAlignLayout.Left;
          unterfrageText.width := lay.width * 0.75;
          unterfrageText.Text := tmpUnterfrage.fragen;

          cb := TCheckbox.Create(self);
          cb.parent := lay;
          cb.align := TAlignLayout.Client;
          cb.width := lay.width * 0.75;
          cb.isChecked := false;
       end;
    exp.height := 25 * unterFragenListe.Count + 10;
   end;

end.
