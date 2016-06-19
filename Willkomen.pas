unit Willkomen;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Ani,Fmain, FMX.Objects;

type
  TformWillkommen = class(TForm)
    Label1: TLabel;
    Image1: TImage;
    Label2: TLabel;
    Label4: TLabel;
    Image2: TImage;
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
   begin
    Main := TForm2.Create(Self);
    Main.Show;
   end;

end.
