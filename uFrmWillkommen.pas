unit uFrmWillkommen;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Ani, FMX.Objects,
  FMX.Layouts, FMX.ListBox, System.ImageList, FMX.ImgList;

type
  TformWillkommen = class(TForm)
    laStepIn: TLabel;
    laWillkommen: TLabel;
    laBeantworteFragen: TLabel;
    imStartButton: TImage;
    layTitelBild: TLayout;
    StyleBook1: TStyleBook;
    ImageList1: TImageList;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure imStartButtonClick(Sender: TObject);
    procedure FormSaveState(Sender: TObject);
    procedure layTitelBildClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  formWillkommen: TformWillkommen;
  ErsterAufruf : boolean = true;

implementation

{$R *.fmx}

uses
  uSetDimensions,
  uFrmFragen,
  uFrmMain;

procedure TformWillkommen.FormCreate(Sender: TObject);
   var
    r : TBinaryReader;
   begin
    SaveState.StoragePath := GetHomePath;      //anpassen an hilfsfunktion
    r := TBinaryReader.Create(SaveState.Stream);
    try
      if SaveState.Stream.Size > 0 then
         begin
          ErsterAufruf := r.ReadBoolean;
         end;
    finally
      r.Free;
    end;
    setWillkommenDimensions;
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
   begin
    if ErsterAufruf = true then
       begin
        ErsterAufruf := false;
        formFragen.Show;
       end
    else
       begin
        formMain.Show;
       end;

   end;
procedure TformWillkommen.layTitelBildClick(Sender: TObject);
begin

end;





{ ============================================================================ }

end.

