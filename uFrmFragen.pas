unit uFrmFragen;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.ListBox, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Header,
  System.Generics.Collections, uFragen, uUnterfragen, uFrmWIllkommen, uFrmMain,
  FMX.ExtCtrls;

type
  TformFragen = class(TForm)
    paHeader: TPanel;
    laFragen: TLabel;
    Layout1: TLayout;
    VertScrollBox1: TVertScrollBox;
    Panel1: TPanel;
    Label1: TLabel;
    Layout2: TLayout;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
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
procedure TformFragen.Button1Click(Sender: TObject);
   begin
   formMain.show;
   end;

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
    exp.Align := TAlignLayout.Top;
    exp.parent := Layout2;
    exp.IsExpanded := false;
    exp.Text := frage.fragen;
    exp.Margins.Top := 10;
    exp.Margins.left := 10;
    exp.Margins.right := 10;

    for tmpUnterfrage in unterfragenListe do
       begin
          lay := TLayout.Create(self);
          lay.parent := exp;
          lay.align := TAlignLayout.top;
          lay.Height := 50;

          unterfrageText := TLabel.Create(self);
          unterfrageText.parent := lay;
          unterfrageText.align := TAlignLayout.left;
          unterfrageText.width := self.width * 0.85;
          unterfrageText.Text := tmpUnterfrage.fragen;
          unterfrageText.AutoSize := true;

          cb := TCheckbox.Create(self);
          cb.parent := lay;
          cb.align := TAlignLayout.client;
          cb.isChecked := false;
       end;
   end;

end.
