unit uFrmContent;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.ScrollBox,
  FMX.Memo, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Header , uHlfsFktn;

type
  TFrmContent = class(TForm)
    Header1: THeader;
    lbl_title: TLabel;
    MContent: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    procedure OeffneContent(IDTask:Integer);
    { Public-Deklarationen }
  end;

var
  FrmContent: TFrmContent;
  TaskID    : Integer;

implementation

{$R *.fmx}

procedure TFrmContent.FormCreate(Sender: TObject);
   begin
    MContent.Lines.Add(LadeContentToTask(TaskID));
   end;

procedure TFrmContent.OeffneContent(IDTask:Integer);
   begin
    TaskID := 0;
    if IDTask < 0 then
       begin
        raise Exception.Create('Kein Gültiger Task mit gegeben');
       end;
    TaskID := IDTask; //IDTask ist die ID die vom vorherigen Form übergeben wird
    FormCreate(Self);
   end;
end.
