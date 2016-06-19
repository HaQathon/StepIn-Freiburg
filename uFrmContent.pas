unit uFrmContent;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.ScrollBox,
  FMX.Memo, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Header, uFrmWillkommen,
  FMX.WebBrowser;

type
  TFrmContent = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    laAufgaben: TLabel;
    btnBack: TButton;
    WebBrowser1: TWebBrowser;
    procedure btnBackClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FrmContent: TFrmContent;

implementation

{$R *.fmx}

procedure TFrmContent.btnBackClick(Sender: TObject);
  begin
   WebBrowser1.Visible := false;
   hide;
  end;

end.
