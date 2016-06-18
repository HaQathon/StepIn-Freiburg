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
    lbiKFZ: TListBoxItem;
    lbiWohnung: TListBoxItem;
    lbiKinder: TListBoxItem;
    lbiHaustiere: TListBoxItem;
    ListBox2: TListBox;
    lbiAusweise: TListBoxItem;
    procedure btn_OpenMultiviewClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure lbiKFZClick(Sender: TObject);
    procedure lbiWohnungClick(Sender: TObject);
    procedure lbiKinderClick(Sender: TObject);
    procedure lbiHaustiereClick(Sender: TObject);
    procedure lbiAusweiseClick(Sender: TObject);
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

procedure TformMain.lbiAusweiseClick(Sender: TObject);
   begin
    MultiView1.HideMaster;
    lbiAusweise.IsSelected := false;
    laAufgaben.Text := 'Ausweis';

   //show all ausweis aufgaben
   end;

procedure TformMain.lbiHaustiereClick(Sender: TObject);
begin
   MultiView1.HideMaster;
   lbiHaustiere.IsSelected := false;
   laAufgaben.Text := 'Haustiere';
   //show all haustiere aufgaben
end;

procedure TformMain.lbiKFZClick(Sender: TObject);
  begin
   MultiView1.HideMaster;
   lbiKFZ.IsSelected := false;
   laAufgaben.Text := 'KFZ';
   //show all kfz aufgaben
  end;

procedure TformMain.lbiKinderClick(Sender: TObject);
begin
   MultiView1.HideMaster;
   lbiKinder.IsSelected := false;
   laAufgaben.Text := 'Kinder';
   //show all kinder aufgaben
end;

procedure TformMain.lbiWohnungClick(Sender: TObject);
begin
   MultiView1.HideMaster;
   lbiWohnung.IsSelected := false;
   laAufgaben.Text := 'Wohnung';
   //show all wohnung aufgaben
end;

end.
