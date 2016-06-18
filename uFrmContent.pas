unit uFrmContent;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.ScrollBox,
  FMX.Memo, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Header;

type
  TFrmContent = class(TForm)
    Header1: THeader;
    lbl_title: TLabel;
    Memo1: TMemo;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FrmContent: TFrmContent;

implementation

{$R *.fmx}

end.
