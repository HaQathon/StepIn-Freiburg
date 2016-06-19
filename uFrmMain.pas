unit uFrmMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListView, FMX.MultiView, FMX.Edit,
  FMX.Objects, FMX.Header, uTask, FMX.ListBox, FMX.Layouts, System.Generics.Collections,
  System.ImageList, FMX.ImgList, uAttribut, FMX.ExtCtrls, ufrmContent, uContent;

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
    lbAttribute: TListBox;
    paMenuHeader: TPanel;
    paHeader: TPanel;
    layTaskHinzufuegen: TLayout;
    Layout1: TLayout;
    ImageList1: TImageList;
    VertScrollBox1: TVertScrollBox;
    Layout2: TLayout;
    procedure btn_OpenMultiviewClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LadeAttributeAusDatenbank;
    procedure onAttributClick(Sender: TObject);

    procedure onAufgabeClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private-Deklarationen }
    aufgabenListe: TList<TTask>;
    attributListe: TList<TAttribut>;

    procedure addAufgabenExpander(aufgabe: TTask);
    procedure aufgabenAttributHinzufuegen(attributid: integer);
    procedure addAufgabenLayout(aufgabe: TTask);
    function getTasktoAttribute (AttributID :Integer): TStringlist;
  public
    { Public-Deklarationen }
    tmpContent: TContents;
    procedure aufgabenHinzufuegen();

  end;

var
  formMain: TformMain;

implementation

{$R *.fmx}

uses
  System.StrUtils,
  FMX.MultiResBitmap,
  FMX.WebBrowser,
  uFrmWillkommen,
  uFrmAufgabeHinzufuegen,
  uAttributeRel;

procedure TformMain.btn_OpenMultiviewClick(Sender: TObject);
 begin
  MultiView1.ShowMaster;
 end;


procedure TformMain.Button1Click(Sender: TObject);
 begin
  MultiView1.HideMaster;
 end;

procedure TformMain.FormActivate(Sender: TObject);
  begin
   LadeAttributeAusDatenbank;
   aufgabenHinzufuegen;
  end;

procedure TformMain.FormCreate(Sender: TObject);
var
   tempTask: TTask;
   begin
    LadeAttributeAusDatenbank;
    aufgabenHinzufuegen;
   end;

procedure TformMain.aufgabenHinzufuegen();
   var
     tempTask: TTask;
  begin
   if Assigned(aufgabenListe) then aufgabenListe.Clear;
   Layout2.DeleteChildren;
   aufgabenListe := TList<TTask>.Create;
   aufgabenListe := TaskDatenbank.getAllTasks();
   for tempTask in aufgabenListe do
      begin
//       addAufgabenExpander(tempTask);
       addAufgabenLayout(tempTask);
      end;
   end;

procedure TformMain.aufgabenAttributHinzufuegen(attributid: integer);
   var
     tempTask: TTask;
  begin
//   aufgabenListe := TList<TTask>.Create;
//   aufgabenListe := TaskDatenbank.sucheEintraege();   //  select * from tasks, attribute where id = taskID and id = attributID
//   for tempTask in aufgabenListe do
//      begin
//       addAufgabenExpander(tempTask);
//      end;
   end;

procedure TformMain.Image1Click(Sender: TObject);
  begin
   formAufgabeHinzufuegen.Show;
  end;


procedure TformMain.LadeAttributeAusDatenbank;
   procedure SetIcon(Eintrag: TListBoxItem; BitmapName: string);
      var
       Icon: TCustomBitmapItem;
       Size: TSize;
      begin
       if ImageList1.BitmapItemByName(BitmapName, Icon, Size) then
          begin
           Eintrag.ItemData.Bitmap := Icon.Bitmap;
          end
       else Eintrag.ItemData.Bitmap := nil;
      end;

   var
    attribut: TAttribut;
    Eintrag: TListBoxItem;
   begin
    lbAttribute.BeginUpdate;
    try
      lbAttribute.Clear;

      attributListe := AttributDatenbank.getAllAttribute();
        for attribut in attributListe do
           begin
            Eintrag := TListBoxItem.Create(lbAttribute);
            Eintrag.StyledSettings := Eintrag.StyledSettings - [TStyledSetting.Size, TStyledSetting.Family];
            Eintrag.TextAlign := TTextAlign.Leading;
            Eintrag.Parent := lbAttribute;
            Eintrag.Tag := attribut.id;


            case ansiindexstr(attribut.AttributName, ['Wohnung', 'Sprache', 'KFZ', 'Arbeit']) of
               0:
                 begin
                  Eintrag.Text := 'Wohnung';
                  SetIcon(Eintrag, 'wohnung_white');
                 end;
              1:
                 begin
                  Eintrag.Text := 'Sprache';
                  SetIcon(Eintrag, 'language_white');
                 end;
              2:
                 begin
                  Eintrag.Text := 'KFZ';
                  SetIcon(Eintrag, 'car_white');
                 end;
              3:
                 begin
                  Eintrag.Text := 'Arbeit';
                  SetIcon(Eintrag, 'car_white');
                 end;
            end;
            Eintrag.OnClick := onattributClick;
           end;

      Eintrag := TListBoxItem.Create(lbAttribute);
      Eintrag.StyledSettings := Eintrag.StyledSettings - [TStyledSetting.Size, TStyledSetting.Family];
      Eintrag.TextAlign := TTextAlign.Leading;
      Eintrag.Parent := lbAttribute;
      Eintrag.OnClick := onattributClick;
      Eintrag.Text := 'Eigene Aufgaben';

    finally
      lbAttribute.EndUpdate;
    end;
   end;

procedure TformMain.onAttributClick(Sender: TObject);
   VAR
     task: TTask;
     taskListSTring: TStringlist;
     i1: integer;
    begin
     MultiView1.HideMaster;
     laAufgaben.Text := TListBoxItem(Sender).Text;
     taskListSTring := getTasktoAttribute(TListBoxItem(Sender).tag);
    for i1 := 0 to pred(tasklistString.Count) do
       begin
         task := TaskDatenbank.sucheEintraege(Taskdatenbank.cTASK_NAME + '=' + tasklistString[i1])[0];

//        lbAufgaben.Items.Add(TaskList.Strings[i1]);

         addAufgabenLayout(task);
       end;
   // lade Aufgaben Zu Entsprechendem Typ
    end;

 function TformMain.getTasktoAttribute (AttributID :Integer): TStringlist;
   var
    helpList : TStringList;
    Task     : TTask;
    i1: Integer;
   begin
    Result   := TStringList.Create;
    helpList := TStringList.Create;
    Task     := TTask.Create;
    try
     helpList := AttributRelDatenbank.getTaskID(Attributid);
     for i1 := 0 to pred(helpList.Count) do
        begin
         TaskDatenbank.getTaskname(StrToInt(helpList.Strings[i1]));
         Result.Add(Task.taskName);
        end;
    finally

    end;
   end;



procedure TformMain.addAufgabenExpander(aufgabe: TTask);
   var
     titel: string;
     contentText: TLabel;
     lay: TLayout;
     cb: TcheckBox;
     exp: TExpander;
   begin
    //suche einträge von content where task id = aufgabe.id
    tmpContent := TContents.Create();
    tmpContent := ContentDatenbank.get(aufgabe.id);

    exp := TExpander.Create(self);
    exp.Align := TAlignLayout.Top;
    exp.StyleLookup := 'ExpanderStyle';
    exp.parent := Layout2;
    exp.IsExpanded := false;
    exp.Text := aufgabe.taskName;
    exp.Margins.Top := 10;


//    contentText := TLabel.Create(self);
//    contentText.parent := exp;
//    contentText.align := TAlignLayout.left;
//    contentText.width := self.width;
//    contentText.Text := tempContent.content;
//    contentText.AutoSize := true;
////
//    exp.height := contentText.Height + 20;
   end;

procedure TformMain.addAufgabenLayout(aufgabe: TTask);
   var
     frageText: TLabel;
     panelBack: TPanel;
     cb: TcheckBox;
     lbi: TListBoxItem;
     glyph: TGlyph;
   begin
    //suche einträge von content where task id = aufgabe.id
    if not assigned(tmpContent) then tmpContent := TContents.Create();
    tmpContent := ContentDatenbank.get(aufgabe.id);

          panelBack := TPanel.Create(self);
          panelBack.parent := layout2;
          panelBack.align := TAlignLayout.top;
          panelBack.Height := 50;
          panelBack.HitTest := true;
          panelBack.margins.Left := 10;
          panelBack.margins.Right := 10;
          panelBack.Margins.Top := 10;
          panelBack.StyleLookup := 'panelAufgabenStyle';
          panelBack.Tag := aufgabe.id;

          glyph := TGlyph.Create(self);
          glyph.parent := panelBack;
          glyph.Visible := true;
          glyph.align := TAlignLayout.left;
//          glyph.width := self.width * 0.1;
          glyph.Images := formWillkommen.ImageList1;
          glyph.ImageIndex := 8;
          glyph.margins.top := 3;
          glyph.margins.bottom := 3;
          glyph.margins.left := 5;
          glyph.margins.right := 8;


          cb := TCheckbox.Create(self);
          cb.parent := panelBack;
          cb.align := TAlignLayout.right;
          cb.isChecked := false;

          frageText := TLabel.Create(self);
          frageText.parent := panelBack;
          frageText.align := TAlignLayout.client;
//          frageText.width := self.width * 0.75;
          frageText.Text := aufgabe.taskName;
          frageText.AutoSize := true;


          panelBack.OnClick := onAufgabeClick;
   end;

procedure TformMain.onAufgabeClick(Sender: TObject);
    begin
        // ladeContent Zu Entsprechendem Typ
     tmpContent := ContentDatenbank.get(TPanel(Sender).Tag);
     frmcontent.WebBrowser1.LoadFromStrings(tmpContent.content,'');
     frmcontent.WebBrowser1.Visible := true;
//     frmContent.Memo1.Text := tmpContent.content;
     frmContent.show;

    end;

end.
