unit fMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, uStepInWSClient,
  FMX.Controls.Presentation, FMX.StdCtrls, XSuperObject;

type
  TForm1 = class(TForm)
    btn_Content: TButton;
    btn_Attribute: TButton;
    procedure btn_ContentClick(Sender: TObject);
    procedure btn_AttributeClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.btn_AttributeClick(Sender: TObject);
   var
    restClient    : TStepInWSClient;
    ajsonResponse : ISuperObject;
   begin
    restClient := TStepInWSClient.Create;
    try
      ajsonResponse := restClient.GetAttribute('');
      showmessage(ajsonResponse.O['data'].A['attributes'].S[0]);
    finally
      ajsonResponse := NIL;
      restClient.Free;
    end;
   end;

procedure TForm1.btn_ContentClick(Sender: TObject);
   var
    restClient    : TStepInWSClient;
    ajsonResponse : ISuperObject;
   begin
    restClient := TStepInWSClient.Create;
    try
      ajsonResponse := restClient.GetContent('');
      showmessage(ajsonResponse.O['data'].A['content'].S[0]);
    finally
      ajsonResponse := NIL;
      restClient.Free;
    end;
   end;

end.
