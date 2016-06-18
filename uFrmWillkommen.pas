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
    procedure FormSaveState(Sender: TObject);
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
   var
    r : TBinaryReader;
   begin
    SaveState.StoragePath := GetHomePath;      //anpassen an hilfsfunktion
    r := TBinaryReader.Create(SaveState.Stream);
    ErsterAufruf := true;
    try
      if SaveState.Stream.Size > 0 then
         begin
          ErsterAufruf := r.ReadBoolean;
         end;
    finally
      r.Free;
    end;
   end;
{ ============================================================================ }
procedure TformWillkommen.FormSaveState(Sender: TObject);
   var
    W : TBinaryWriter;
   begin
    SaveState.Stream.Clear;
    W := TBinaryWriter.Create(SaveState.Stream);
    try
      W.Write(boolean(ErsterAufruf));
    finally
      W.Free;
    end;
   end;
{ ============================================================================ }
procedure TformWillkommen.imStartButtonClick(Sender: TObject);
   var
    Main : TForm2;
   begin
    if ErsterAufruf = false then
       begin
       //hier fragen anzeigen
       end
    else
       begin
        Main := TForm2.Create(Self);
        Main.Show;
       end;

   end;
{ ============================================================================ }

end.

