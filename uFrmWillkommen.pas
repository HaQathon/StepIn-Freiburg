unit uFrmWillkommen;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Ani,Fmain, FMX.Objects,
  FMX.Layouts;

type
  TformWillkommen = class(TForm)
    laStepIn: TLabel;
    imTitelBild: TImage;
    laWillkommen: TLabel;
    laBeantworteFragen: TLabel;
    imStartButton: TImage;
    layTitelBild: TLayout;
    procedure FormCreate(Sender: TObject);
    procedure imStartButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  formWillkommen: TformWillkommen;
  ErsterAufruf  : boolean;

implementation

{$R *.fmx}

procedure TformWillkommen.FormCreate(Sender: TObject);
   begin
    ErsterAufruf := false; // diese var setzten durch abfrage des SaveState

   end;

procedure TformWillkommen.imStartButtonClick(Sender: TObject);
   var
    Main : TForm2;
   begin
    if ErsterAufruf = true then
       begin
       //hier fragen anzeigen
       end
    else
       begin
        Main := TForm2.Create();
        Main.Show;
       end;

   end;

end.

