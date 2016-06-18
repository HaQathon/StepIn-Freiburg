unit Fmain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListView, FMX.MultiView, FMX.Edit,
  FMX.Objects, FMX.Header, uTask ;

type
  TForm2 = class(TForm)
    ListView1: TListView;
    MultiView1: TMultiView;
    Edit1: TEdit;
    ListView2: TListView;
    Image1: TImage;
    Header1: THeader;
    lbl_title: TLabel;
    btn_OpenMultiView: TButton;
    head_Mview: THeader;
    Button1: TButton;
    Aufgaben: TLabel;
    procedure btn_OpenMultiviewClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}
{$R *.Surface.fmx MSWINDOWS}

procedure TForm2.btn_OpenMultiviewClick(Sender: TObject);
 begin
  MultiView1.ShowMaster;
 end;


procedure TForm2.Button1Click(Sender: TObject);
 begin
  MultiView1.HideMaster;
 end;

end.
