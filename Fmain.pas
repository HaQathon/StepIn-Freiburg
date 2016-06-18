unit Fmain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListView, FMX.MultiView, FMX.Edit,
  FMX.Objects;

type
  TForm2 = class(TForm)
    ListView1: TListView;
    MultiView1: TMultiView;
    Edit1: TEdit;
    ListView2: TListView;
    Image1: TImage;
    Button1: TButton;
    Label1: TLabel;
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
uses
  uTask;

procedure TForm2.Button1Click(Sender: TObject);
var task: TTask;
  begin
   task := TaskDatenbank.get(1);
   Label1.Text := task.taskInfo;
  end;

end.
