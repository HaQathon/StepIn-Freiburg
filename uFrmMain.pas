unit uFrmMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListView, FMX.MultiView, FMX.Edit,
  FMX.Objects, FMX.Header, uTask, FMX.ListBox, FMX.Layouts ;

type
  TformMain = class(TForm)
    ListView1: TListView;
    MultiView1: TMultiView;
    eSuchFeld: TEdit;
    Image1: TImage;
    laAufgaben: TLabel;
    btnMenu: TButton;
    Button1: TButton;
    laAttribute: TLabel;
    ListBox1: TListBox;
    paMenuHeader: TPanel;
    paHeader: TPanel;
    layTaskHinzufuegen: TLayout;
    Layout1: TLayout;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    ListBox2: TListBox;
    procedure btn_OpenMultiviewClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  formMain: TformMain;

implementation

{$R *.fmx}

uses
  uFrmWillkommen,
  uFrmAufgabeHinzufuegen;

procedure TformMain.btn_OpenMultiviewClick(Sender: TObject);
 begin
  MultiView1.ShowMaster;
 end;


procedure TformMain.Button1Click(Sender: TObject);
 begin
  MultiView1.HideMaster;
 end;

procedure TformMain.Image1Click(Sender: TObject);
  begin
   formAufgabeHinzufuegen.Show;
  end;

end.
