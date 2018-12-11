unit frmSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,unitClasses4Devices,unitRes, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Imaging.pngimage;

type
  TformSettings = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    rbLow: TRadioButton;
    rbHigh: TRadioButton;
    gbColor: TGroupBox;
    rbRed: TRadioButton;
    rbGreen: TRadioButton;
    rbBlue: TRadioButton;
    rbYellow: TRadioButton;
    rbBlack: TRadioButton;
    gbOperateSignal: TGroupBox;
    gbReset: TGroupBox;
    chkAutoReset: TCheckBox;
    btnReset: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);

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
  bmp_back,bmp_1,bmp_0: TBitmap; //Картинки - задний фон, и кнопка reset



implementation

{$R *.dfm}




Procedure TformSettings.redrawForm();
begin

end;

procedure TformSettings.btnCancelClick(Sender: TObject);
begin
self.Close;
end;

procedure TformSettings.btnOkClick(Sender: TObject);


begin
device.LenSaveData:=3;
if rbred.Checked then device.Savedata[0]:='R';
if rbgreen.Checked then device.Savedata[0]:='G';
if rbblue.Checked then device.Savedata[0]:='B';
if rbyellow.Checked then device.Savedata[0]:='Y';
if rbBlack.Checked then device.Savedata[0]:='L';
if rbhigh.Checked then device.savedata[1]:='H' else device.savedata[1]:='L';
if chkAutoReset.Checked  then device.SaveData[2]:='A' else device.SaveData[2]:='0' ;



device.ApplySettings;
self.Close;
end;

procedure TformSettings.FormActivate(Sender: TObject);
begin
self.Caption:=GetText(3)+': '+GetText(0)+' ('+inttostr(InternalIndex)+')';
case device.SaveData[0] of
'R':
begin
rbRED.Checked := true;

end;
'G':
begin
rbgreen.Checked := true;

end;
'B':
begin
rbBLUE.Checked := true;

end;
'Y':
begin
rbYELLOW.Checked := true;

end;
'L':
begin
rbBlack.Checked := true;

end;

end;
if DEVICE.SaveData[1]='H' then
BEGIN
rbHigh.Checked:=true;

END
ELSE
BEGIN
rbLow.Checked:=true;

END;
if DEVICE.SaveData[2]='A' then chkAutoReset.Checked:=true else chkAutoReset.Checked:=false;
end;

procedure TformSettings.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Application.Handle:=OrigHandle;
end;

procedure TformSettings.FormCreate(Sender: TObject);
begin


BtnOk.Caption:=GetText(1);
btnCancel.Caption:=GetText(2);
gbcolor.Caption:=GetText(20);
gbOperatesignal.Caption:=GetText(21);
gbReset.Caption:=GetText(22);
rbred.Caption:=gettext(10);
rbgreen.Caption:=gettext(11);
rbblue.Caption:=gettext(12);
rbyellow.Caption:=gettext(13);
rbBlack.Caption:=gettext(14);
rbhigh.Caption:=Gettext(4);
rblow.Caption:=Gettext(5);
chkAutoReset.Caption:=gettext(23);
btnReset.Caption:=Gettext(22);

redrawForm();


end;

end.
