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
    gbEquivalentCircuit: TGroupBox;
    rbLow: TRadioButton;
    rbHigh: TRadioButton;
    gbColor: TGroupBox;
    rbRed: TRadioButton;
    rbGreen: TRadioButton;
    rbBlue: TRadioButton;
    rbYellow: TRadioButton;
    rbWhite: TRadioButton;
    imgHI: TImage;
    gbOperateSignal: TGroupBox;
    imgLO: TImage;
    gbPreview: TGroupBox;
    img0: TImage;
    img1: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure rbRedClick(Sender: TObject);
    procedure rbGreenClick(Sender: TObject);
    procedure rbBlueClick(Sender: TObject);
    procedure rbYellowClick(Sender: TObject);
    procedure rbWhiteClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure rbHighClick(Sender: TObject);
    procedure rbLowClick(Sender: TObject);
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
  bmp_0,bmp_1: array of TBitmap; //Картинки "горит" и "не горит"
  bmp0,bmp1:TBitmap; //Картинки "горит" и "не горит" в предпросмотре
  Color:char;
  Invert:array of boolean;
  tmpInvert:boolean;

Procedure SetColor(Id,No:integer);

implementation

{$R *.dfm}
Procedure SetColor(Id,No:integer);
begin
bmp0.Free;
bmp1.Free;
case No of
0: //Red
begin
  Bmp0:=TBitmap.Create;
  Bmp0.Handle:=LoadBitmap(HInstance,'Red0');
  Bmp1:=TBitmap.Create;
  Bmp1.Handle:=LoadBitmap(HInstance,'Red1');
  Color:='R';
end;
1: //Green
begin
    Bmp0:=TBitmap.Create;
  Bmp0.Handle:=LoadBitmap(HInstance,'Green0');
  Bmp1:=TBitmap.Create;
  Bmp1.Handle:=LoadBitmap(HInstance,'Green1');
  Color:='G';
end;
2: //Blue
begin
    Bmp0:=TBitmap.Create;
  Bmp0.Handle:=LoadBitmap(HInstance,'Blue0');
  Bmp1:=TBitmap.Create;
  Bmp1.Handle:=LoadBitmap(HInstance,'Blue1');
  Color:='B';
end;
3: //Yellow
begin
     Bmp0:=TBitmap.Create;
  Bmp0.Handle:=LoadBitmap(HInstance,'Yellow0');
  Bmp1:=TBitmap.Create;
  Bmp1.Handle:=LoadBitmap(HInstance,'Yellow1');
  Color:='Y';
end;
4: //White
begin
     Bmp0:=TBitmap.Create;
  Bmp0.Handle:=LoadBitmap(HInstance,'White0');
  Bmp1:=TBitmap.Create;
  Bmp1.Handle:=LoadBitmap(HInstance,'White1');
  Color:='W';
end;
end;
end;

procedure TformSettings.rbBlueClick(Sender: TObject);
begin
setcolor(InternalIndex,2);
redrawform;
end;

procedure TformSettings.rbGreenClick(Sender: TObject);
begin
setcolor(InternalIndex,1);
redrawform;
end;

procedure TformSettings.rbHighClick(Sender: TObject);
begin
tmpinvert:=false;
redrawform;
end;

procedure TformSettings.rbLowClick(Sender: TObject);
begin
tmpinvert:=true;
redrawform;
end;

procedure TformSettings.rbRedClick(Sender: TObject);
begin
setcolor(InternalIndex,0);
redrawform;
end;

procedure TformSettings.rbWhiteClick(Sender: TObject);
begin
setcolor(InternalIndex,4);
redrawform;
end;

procedure TformSettings.rbYellowClick(Sender: TObject);
begin
setcolor(InternalIndex,3);
redrawform;
end;

Procedure TformSettings.redrawForm();
begin
img0.Canvas.Draw(0,0,bmp0);
img1.Canvas.Draw(0,0,bmp1);
if tmpinvert then
begin
imglo.Visible:=true;
imghi.Visible:=false;
end
else
begin
imglo.Visible:=false;
imghi.Visible:=true;
end;
end;

procedure TformSettings.btnCancelClick(Sender: TObject);
begin
self.Close;
end;

procedure TformSettings.btnOkClick(Sender: TObject);


begin
device.LenSaveData:=2;
if rbred.Checked then device.Savedata[0]:='R';
if rbgreen.Checked then device.Savedata[0]:='G';
if rbblue.Checked then device.Savedata[0]:='B';
if rbyellow.Checked then device.Savedata[0]:='Y';
if rbwhite.Checked then device.Savedata[0]:='W';
if rbhigh.Checked then device.savedata[1]:='H' else device.savedata[1]:='L';
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
rbREDclick(sender);
end;
'G':
begin
rbgreen.Checked := true;
rbgreenclick(sender);
end;
'B':
begin
rbBLUE.Checked := true;
rbBLUEclick(sender);
end;
'Y':
begin
rbYELLOW.Checked := true;
rbYELLOWclick(sender);
end;
'W':
begin
rbWHITE.Checked := true;
rbWHITEclick(sender);
end;

end;
if DEVICE.SaveData[1]='H' then
BEGIN
rbHigh.Checked:=true;
rbHighClick(sender);
END
ELSE
BEGIN
rbLow.Checked:=true;
rbLowClick(sender);
END;
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
gbEquivalentCircuit.Caption:=GetText(22);
rbred.Caption:=gettext(10);
rbgreen.Caption:=gettext(11);
rbblue.Caption:=gettext(12);
rbyellow.Caption:=gettext(13);
rbwhite.Caption:=gettext(14);
rbhigh.Caption:=Gettext(4);
rblow.Caption:=Gettext(5);
gbpreview.Caption:=gettext(23);

redrawForm();


end;

end.
