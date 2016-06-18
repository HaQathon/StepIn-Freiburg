unit Fmain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListView, FMX.MultiView, FMX.Edit,
  FMX.Objects, FMX.Header, uTask, FMX.ListBox, FMX.Layouts,System.Generics.Collections ;

type
  TformMain = class(TForm)
    ListView1: TListView;
    MultiView1: TMultiView;
    eSuchFeld: TEdit;
    Image1: TImage;
    Header1: THeader;
    lbl_title: TLabel;
    btn_OpenMultiView: TButton;
    head_Mview: THeader;
    Button1: TButton;
    laAttribute: TLabel;
    ListBox1: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    procedure btn_OpenMultiviewClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  formMain: TformMain;

implementation

{$R *.fmx}

procedure TformMain.btn_OpenMultiviewClick(Sender: TObject);
 begin
  MultiView1.ShowMaster;
 end;


procedure TformMain.Button1Click(Sender: TObject);
 begin
  MultiView1.HideMaster;
 end;

procedure TformMain.FormCreate(Sender: TObject);
var
  task:uTask.TTaskDatenbank;
  list:TList<TTask>;
  i:Integer;
  item: TListViewItem;
  dmy:TTask;
  begin
  task:= uTask.TTaskDatenbank.Create(uTask.TTaskDatenbank.cTABLE_NAME);
  list:=task.getAllTasks;
  dmy:=TTask.Create;
  dmy.taskName:='asdasd';
  list.Add(dmy);
    for i := 0 to list.Count-1 do  begin
      item:=ListView1.Items.Add;
      item.Text:=list.Items[i].taskName;

    end;

  end;


end.
