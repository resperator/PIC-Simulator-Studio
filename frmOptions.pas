unit frmOptions;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, unitres, Vcl.StdCtrls,unitregistry;

type
  TFormOptions = class(TForm)
    gpbLang: TGroupBox;
    cbxLang: TComboBox;
    btnOk: TButton;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormOptions: TFormOptions;

implementation

{$R *.dfm}

procedure TFormOptions.btnCancelClick(Sender: TObject);
begin
self.Close;
end;

procedure TFormOptions.btnOkClick(Sender: TObject);
begin
writeint(0,cbxlang.ItemIndex);
SetLang;
unitres.ApplyLangToMainForm;
self.Close;
end;

procedure TFormOptions.FormCreate(Sender: TObject);
begin
caption:=unitres.gettext(11);
BtnOk.Caption:=GetText(101);
btnCancel.Caption:=GetText(102);
gpblang.caption:=gettext(500);
cbxLang.ItemIndex:=readint(0);
end;

end.
