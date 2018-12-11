unit frmSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,unitClasses4Devices,unitRes, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Imaging.pngimage, Vcl.ComCtrls;

type
  TformSettings = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    gbTextSettings: TGroupBox;
    CD: TColorDialog;
    btnTextColor: TButton;
    btnBackTextColor: TButton;
    lblText: TLabel;
    edtText: TEdit;
    chkBold: TCheckBox;
    chkItalic: TCheckBox;
    chkUnderline: TCheckBox;
    lblSize: TLabel;
    tbSize: TTrackBar;
    gbPreview: TGroupBox;
    img: TImage;
    shTC: TShape;
    shBC: TShape;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnTextColorClick(Sender: TObject);
    procedure btnBackTextColorClick(Sender: TObject);
    procedure tbSizeChange(Sender: TObject);
    procedure edtTextChange(Sender: TObject);
    procedure chkBoldClick(Sender: TObject);
    procedure chkItalicClick(Sender: TObject);
    procedure chkUnderlineClick(Sender: TObject);

  private
    { Private declarations }
    Procedure redrawForm();

  public
    { Public declarations }
    OrigHandle:THandle; //Application.handle, кот. необходимо восстановить при выходе
    InternalIndex:integer; //Внутренний индекс в рамках данного семейства радиодеталей
    Device:TDevice; //Ссылка на экземпляр класса TDevice, для кот. вызвано окно
  end;

var
  formSettings: TformSettings;
  vTextColor: array of TColor;
  vBackColor: array of TColor;
  vSize: array of integer;
  vBold: array of boolean;
  vItalic: array of boolean;
  vUnderline: array of boolean;
  vText: array of shortstring;

implementation

{$R *.dfm}




Procedure TformSettings.redrawForm();
begin
if Not assigned(img.Canvas) then exit;

//img.CleanupInstance;
PatBlt(img.Canvas.Handle, 0, 0,
img.ClientWidth, img.ClientHeight, WHITENESS);
img.Canvas.Font.Size:=tbSize.Position;
img.Canvas.Font.Color:=shTC.Brush.Color;
img.Canvas.Brush.Color:=shBC.Brush.Color;

img.Canvas.Font.Style:=[];
if chkBold.Checked then img.Canvas.Font.Style:=img.Canvas.Font.Style+[fsBold];
if chkItalic.Checked then img.Canvas.Font.Style:=img.Canvas.Font.Style+[fsItalic];
if chkUnderline.Checked then img.Canvas.Font.Style:=img.Canvas.Font.Style+[fsUnderline];

img.Canvas.TextOut(1,1,edtText.Text);
lblSize.Caption:=gettext(14)+' '+ inttostr(tbSize.Position);



end;

procedure TformSettings.tbSizeChange(Sender: TObject);
begin
tbSize.ShowHint:=false;
tbSize.Hint:=inttostr(tbSize.Position);
redrawForm;
application.ProcessMessages;
tbSize.ShowHint:=true;

end;

procedure TformSettings.btnBackTextColorClick(Sender: TObject);
begin
if cd.Execute()=false then exit;
shBC.Brush.Color:=cd.Color;
redrawForm;
end;

procedure TformSettings.btnCancelClick(Sender: TObject);
begin
self.Close;
end;

procedure TformSettings.btnOkClick(Sender: TObject);
var
Str:AnsiString;
I:integer;

begin
device.LenSaveData:=111;


device.Savedata[0]:=AnsiChar(GetRValue(shTC.Brush.Color)); //R Текста

device.Savedata[1]:=AnsiChar(GetGValue(shTC.Brush.Color)); //G Текста

device.Savedata[2]:=AnsiChar(GetBValue(shTC.Brush.Color)); //B Текста

device.Savedata[3]:=AnsiChar(GetRValue(shBC.Brush.Color)); //R Фона Текста

device.Savedata[4]:=AnsiChar(GetGValue(shBC.Brush.Color)); //G Фона Текста

device.Savedata[5]:=AnsiChar(GetBValue(shBC.Brush.Color)); //B Фона Текста

device.Savedata[6]:=AnsiChar(tbSize.Position); //Размер
if chkBold.Checked then device.Savedata[7]:='1' else device.Savedata[7]:='0'; //Жирность
if chkItalic.Checked then device.Savedata[8]:='1' else device.Savedata[8]:='0'; //Курсивность
if chkUnderLine.Checked then device.Savedata[9]:='1' else device.Savedata[9]:='0'; //Подчеркнутость
device.Savedata[10]:=AnsiChar(Length(edtText.Text)); //Количество символов
Str:=edtText.Text;
for I := 1 to Length(Str) do
     device.Savedata[10+I]:=Str[I];
device.ApplySettings;
self.Close;
end;

procedure TformSettings.btnTextColorClick(Sender: TObject);
begin
if cd.Execute()=false then exit;
shTC.brush.Color:=cd.Color;
redrawForm;
end;

procedure TformSettings.chkBoldClick(Sender: TObject);
begin
redrawForm;
end;

procedure TformSettings.chkItalicClick(Sender: TObject);
begin
redrawForm;
end;

procedure TformSettings.chkUnderlineClick(Sender: TObject);
begin
redrawForm;
end;

procedure TformSettings.edtTextChange(Sender: TObject);
begin
redrawForm;
end;

procedure TformSettings.FormActivate(Sender: TObject);
var r,g,b,c:byte;
i:integer;
Str:ansistring;
begin
self.Caption:=GetText(3)+': '+GetText(0)+' ('+inttostr(InternalIndex)+')';
r:=ord(Device.SaveData[0]);
g:=ord(Device.SaveData[1]);
b:=ord(Device.SaveData[2]);
shTC.Brush.Color:=rgb(r,g,b);
r:=ord(Device.SaveData[3]);
g:=ord(Device.SaveData[4]);
b:=ord(Device.SaveData[5]);
shBC.Brush.Color:=rgb(r,g,b);
tbSize.Position:=ord(Device.SaveData[6]);
if Device.SaveData[7]='1' then chkBold.Checked:=true else chkBold.Checked:=false;
if Device.SaveData[8]='1' then chkItalic.Checked:=true else chkItalic.Checked:=false;
if Device.SaveData[9]='1' then chkUnderLine.Checked:=true else chkUnderLine.Checked:=false;
C:=ord(Device.SaveData[10]);
Str:='';
for I := 1 to C do
  begin
    Str:=Str+Device.SaveData[10+I];
  end;
edtText.Text:= Str;

redrawForm;


end;

procedure TformSettings.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Application.Handle:=OrigHandle;
end;

procedure TformSettings.FormCreate(Sender: TObject);
begin


BtnOk.Caption:=GetText(1);
btnCancel.Caption:=GetText(2);
gbTextSettings.Caption:=GetText(20);
btnTextColor.Caption:=GetText(21);
btnBackTextColor.Caption:=GetText(22);
chkBold.Caption:=gettext(10);
chkItalic.Caption:=gettext(11);
chkUnderLine.Caption:=gettext(12);
lblText.Caption:=gettext(13);
lblSize.Caption:=gettext(14);
gbPreview.Caption:=Gettext(4);


redrawForm();


end;

end.
