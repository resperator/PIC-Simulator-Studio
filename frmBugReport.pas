unit frmBugReport;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,unitWeb, unitres;

type
  TformBugReport = class(TForm)
    Label1: TLabel;
    edtUserName: TEdit;
    Label2: TLabel;
    edtEmail: TEdit;
    btnCancel: TButton;
    btnSend: TButton;
    memoReport: TMemo;
    procedure btnCancelClick(Sender: TObject);
    procedure btnSendClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  formBugReport: TformBugReport;

implementation

{$R *.dfm}

procedure TformBugReport.btnCancelClick(Sender: TObject);
begin
formbugreport.Close;
end;

procedure TformBugReport.btnSendClick(Sender: TObject);
begin
showmessage(SendReport(edtUserName.Text,edtEmail.Text,memoreport.Text));
formbugreport.Close;
end;

procedure TformBugReport.FormCreate(Sender: TObject);
begin
caption:=gettext(7);
btnSend.Caption:=gettext(105);
btncancel.Caption:=gettext(102);
label1.Caption:=gettext(3100);
label2.Caption:=gettext(3101);
memoReport.text:=gettext(3102);
end;

end.
