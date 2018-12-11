unit frmShareware;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Unitres, Vcl.StdCtrls, Vcl.ExtCtrls,shellapi;

type
  TformShareware = class(TForm)
    Button1: TButton;
    Button2: TButton;
    LinkLabel1: TLinkLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure LinkLabel1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  formShareware: TformShareware;

implementation

{$R *.dfm}

procedure TformShareware.Button1Click(Sender: TObject);
begin

SELF.Close;
end;

procedure TformShareware.Button2Click(Sender: TObject);
begin
ShellExecute(handle,'open','http://at-control.com/downloads.html',nil,nil,SW_SHOWNORMAL);
SELF.Close;

end;

procedure TformShareware.FormCreate(Sender: TObject);
begin
 caption :=  gettext(12);
  button1.Caption:=gettext(102);
  button2.Caption:=gettext(101);
  linklabel1.Caption:=gettext(2100);

end;

procedure TformShareware.LinkLabel1Click(Sender: TObject);
begin

ShellExecute(handle,'open','http://at-control.com/downloads.html',nil,nil,SW_SHOWNORMAL);
end;

end.
