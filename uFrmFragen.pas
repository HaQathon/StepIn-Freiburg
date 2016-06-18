unit uFrmFragen;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.ListBox, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Header;

type
  TfFragen = class(TForm)
    Header1: THeader;
    lbl_title: TLabel;
    ListBox1: TListBox;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  fFragen: TfFragen;

implementation

{$R *.fmx}

end.