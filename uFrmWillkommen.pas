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
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  formWillkommen: TformWillkommen;

implementation

{$R *.fmx}

procedure TformWillkommen.Button1Click(Sender: TObject);
   var
    Main : TForm2;
    sprache :TSysLocale;
   begin
    Main := TForm2.Create(Self);
    Main.Show;
    sprache.PriLangID :=
   end;

end.
