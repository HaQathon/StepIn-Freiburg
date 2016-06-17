unit Willkomen;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Ani,Fmain, FMX.Objects,  FMX.Platform;

type
  TFWillkomen = class(TForm)
    lblStepIn: TLabel;
    Image1: TImage;
    lblWilkommen: TLabel;
    lblFragen: TLabel;
    btnStart: TImage;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FWillkomen: TFWillkomen;

implementation

{$R *.fmx}

//Dieses From soll als Startbildschrim verwendet werden

procedure TFWillkomen.Button1Click(Sender: TObject);
   var
    Main : TForm2;
   begin
    Main := TForm2.Create(Self); //hier soll die Fragen geöffnet werden
    Main.Show;
   end;
procedure TFWillkomen.FormCreate(Sender: TObject);
   var
    Sprache : TSysLocale;
    Device  : TPlatformServices;
   begin
    Device :=  TPlatformServices.Create;
    //hier soll der Savesate ausgelesen werden um zu prüfen ob dies der erste App start ist
    (*if not   then
       begin
        btnStart.Visible := false;
       end
    else
       begin
        btnStart.Visible := true;
       end;

    if  Sprache.PriLangID =  LANG_ENGLISH then
       begin
        //hier abfragen welche sprache verwendet wird

       end;
       *)
   end;

end.
