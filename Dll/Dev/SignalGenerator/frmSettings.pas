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
    gbWaveform: TGroupBox;
    rbSin: TRadioButton;
    rbRectangular: TRadioButton;
    rbTriangular: TRadioButton;
    rbSawtooth: TRadioButton;
    rbSawtoothNR: TRadioButton;
    gbWP: TGroupBox;
    gbEquivalentCircuit: TGroupBox;
    ImgSawNR: TImage;
    imgSaw: TImage;
    imgTri: TImage;
    imgRect: TImage;
    imgSin: TImage;
    edtFrq: TEdit;
    lblFrq: TLabel;
    lblAmin: TLabel;
    edtAmin: TEdit;
    edtAmax: TEdit;
    lblAmax: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edtDC: TEdit;
    lblDC: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure rbSinClick(Sender: TObject);
    procedure rbRectangularClick(Sender: TObject);
    procedure rbTriangularClick(Sender: TObject);
    procedure rbSawtoothClick(Sender: TObject);
    procedure rbSawtoothNRClick(Sender: TObject);
    procedure edtFrqChange(Sender: TObject);
    procedure edtAminChange(Sender: TObject);
    procedure edtAmaxChange(Sender: TObject);
    procedure edtDCChange(Sender: TObject);

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
  SignalMode:array of integer;
  SignalFrq: array of int64;
  SignalPeriod: array of Single;
  SignalD: array of Single;
  Amin:array of single;
  Amax:array of single;
  bmp_back: array of TBitmap; //Картинки - задний фон




implementation

{$R *.dfm}




procedure TformSettings.rbRectangularClick(Sender: TObject);
begin
SignalMode[InternalIndex]:=2;
redrawForm;
end;

procedure TformSettings.rbSawtoothClick(Sender: TObject);
begin
SignalMode[InternalIndex]:=4;
redrawForm;
end;

procedure TformSettings.rbSawtoothNRClick(Sender: TObject);
begin
SignalMode[InternalIndex]:=5;
redrawForm;
end;

procedure TformSettings.rbSinClick(Sender: TObject);
begin
SignalMode[InternalIndex]:=1;
redrawForm;
end;

procedure TformSettings.rbTriangularClick(Sender: TObject);
begin
SignalMode[InternalIndex]:=3;
redrawForm;
end;

Procedure TformSettings.redrawForm();
begin

  imgSin.visible:=false;
  imgRect.visible:=false;
  imgTri.visible:=false;
  imgSaw.visible:=false;
  imgSawNR.visible:=false;

  lblDC.Enabled:=false;
  edtDC.Enabled:=false;
  label4.Enabled:=false;

  case SignalMode[InternalIndex] of
  1:
  begin
  imgSin.visible:=true;
  end;
  2:
  begin
  imgRect.visible:=true;
  lblDC.Enabled:=true;
  edtDC.Enabled:=true;
  label4.Enabled:=true;
  end;
  3:
  begin
  imgTri.visible:=true;
  end;
  4:
  begin
  imgSaw.visible:=true;
  end;
  5:
  begin
  imgSawNR.visible:=true;
  end;

  end;


end;



procedure TformSettings.btnCancelClick(Sender: TObject);
begin
self.Close;
end;

procedure TformSettings.btnOkClick(Sender: TObject);
var str:Ansistring;
A:integer;
B:single;
formatSettings:TFormatSettings;
label lblZanovo1,lblZanovo2,lblZanovo3;
begin
device.LenSaveData:=21;
formatSettings:=TFormatSettings.Create();
formatSettings.ListSeparator:='.';
formatSettings.DecimalSeparator:='.';
//Waveform
if rbSin.Checked then device.Savedata[0]:='1';
if rbRectangular.Checked then device.Savedata[0]:='2';
if rbTriangular.Checked then device.Savedata[0]:='3';
if rbSawtooth.Checked then device.Savedata[0]:='4';
if rbSawtoothNR.Checked then device.Savedata[0]:='5';
//Freq
Str:=edtfrq.Text;
if Str='' then Str:='32768';
 try
    A := StrToInt(Str);    // Конечные пробелы не поддерживаются
  except
    on Exception : EConvertError do
        A:=32768;
  end;
  if A<0 then A:=0;
  if A>999999999 then A:=999999999;
Str:=inttostr(A);
if Length(Str)>9 then Str:=Copy(Str,1,9);
lblZanovo1:
if Length(Str)<9 then
  begin
    Str:='0'+Str;
    goto lblZanovo1;
  end;
for A := 1 to 9 do
   device.Savedata[A]:=Str[A];
//Amin
Str:=edtAmin.Text;
if Str='' then Str:='0';
 try
    B:= StrTofloat(Str,FormatSettings);    // Конечные пробелы не поддерживаются
  except
    on Exception : EConvertError do
        B:=0;
  end;
  if B<-9999 then B:=-9999;
  if B>99999 then B:=99999;
Str:=floattostrf(B,ffFixed,5,5,formatSettings);
if Length(Str)>5 then
begin
Str:=Copy(Str,1,5);
if copy(Str,5,1)='.' then if B>=0 then Str:='0'+Copy(Str,1,4) else Str:='-0'+ copy(Str,2,3);
end;
lblZanovo2:
if Length(Str)<5 then
  if pos('.',Str)>0 then
  begin //Дробное число
    Str:=Str+'0'; //Добавим в конец 0
    goto lblZanovo2;
  end
  else
  begin //Целое число
  if B>=0 then
  begin //Положительное
    Str:='0'+Str; //Добавим в начало 0
    goto lblZanovo2;
  end
  else
  begin //Отрицательное
    Str:='-0'+Copy(Str,2,Length(Str)-1); //Добавим в начало -0
    goto lblZanovo2;
  end;
  end;
for A := 1 to 5 do
   device.Savedata[A+9]:=Str[A];
//Amax
Str:=edtAmax.Text;
if Str='' then Str:='5';
 try
    B:= StrTofloat(Str,FormatSettings );    // Конечные пробелы не поддерживаются
  except
    on Exception : EConvertError do
        B:=5;
  end;
  if B<-9999 then B:=-9999;
  if B>99999 then B:=99999;
Str:=floattostrf(B,ffFixed,5,5,formatSettings);
if Length(Str)>5 then
begin
Str:=Copy(Str,1,5);
if copy(Str,5,1)='.' then if B>=0 then Str:='0'+Copy(Str,1,4) else Str:='-0'+ copy(Str,2,3);
end;
lblZanovo3:
if Length(Str)<5 then
  if pos('.',Str)>0 then
  begin //Дробное число
    Str:=Str+'0'; //Добавим в конец 0
    goto lblZanovo3;
  end
  else
  begin //Целое число
  if B>=0 then
  begin //Положительное
    Str:='0'+Str; //Добавим в начало 0
    goto lblZanovo3;
  end
  else
  begin //Отрицательное
    Str:='-0'+Copy(Str,2,Length(Str)-1); //Добавим в начало -0
    goto lblZanovo3;
  end;
  end;
for A := 1 to 5 do
   device.Savedata[A+14]:=Str[A];
//Duty cycle
Str:=edtDC.Text;
if Str='' then Str:='50';
 try
    A := StrToInt(Str);    // Конечные пробелы не поддерживаются
  except
    on Exception : EConvertError do
        A:=50;
  end;
  if A<0 then A:=0;
  if A>100 then A:=100;

  device.Savedata[20]:=AnsiChar(A);
self.Close;
end;

procedure TformSettings.edtAminChange(Sender: TObject);
var h,SS:integer;
Str:string;
ET:boolean;
label lblZanovo, lblZanovo1, lblZanovo2;
begin
//Удаление всех символов, кроме "0","1","2","3","4","5","6","7","8","9",".",",","-".
Str:=edtAmin.Text;
SS:=edtAmin.SelStart;
lblZanovo:
for h := 1  to length(Str) do
  begin
    if ((Str[h]='0') or (Str[h]='1') or (Str[h]='2') or (Str[h]='3') or (Str[h]='4') or (Str[h]='5') or (Str[h]='6') or (Str[h]='7') or (Str[h]='8') or (Str[h]='9') or (Str[h]='.') or (Str[h]=',') or (Str[h]='-')) = false then
    begin
      Delete(Str,h,1);
      goto lblZanovo;
    end;
  end;
//Минус может быть только в самом начале
lblZanovo1:
for h := 2  to length(Str) do
  begin
    if Str[h]='-' then
    begin
      Delete(str,h,1);
      goto lblZanovo1;
    end;
  end;
//Замена всех запятых на точки
for h := 1  to length(Str) do
  begin
    if Str[h]=',' then Str[h]:='.'
  end;
//Удаление последних точек
lblZanovo2:
ET:=false;
for h := 1  to length(Str) do
  begin
    if str[h]='.' then
      if ET=false then ET:=true
        else
        begin
          Delete(str,h,1);
          goto lblZanovo2;
        end;
  end;
edtAmin.Text:=Str;
edtAmin.SelStart:=SS;
end;

procedure TformSettings.edtFrqChange(Sender: TObject);
var h,SS:integer;
Str:string;
ET:boolean;
label lblZanovo, lblZanovo2;
begin
//Удаление всех символов, кроме "0","1","2","3","4","5","6","7","8","9",".",",".
Str:=edtFrq.Text;
SS:=edtFrq.SelStart;
lblZanovo:
for h := 1  to length(Str) do
  begin
    if ((Str[h]='0') or (Str[h]='1') or (Str[h]='2') or (Str[h]='3') or (Str[h]='4') or (Str[h]='5') or (Str[h]='6') or (Str[h]='7') or (Str[h]='8') or (Str[h]='9') or (Str[h]='.') or (Str[h]=',')) = false then
    begin
      Delete(Str,h,1);
      goto lblZanovo;
    end;
  end;
//Замена всех запятых на точки
for h := 1  to length(Str) do
  begin
    if Str[h]=',' then Str[h]:='.'
  end;
//Удаление последних точек
lblZanovo2:
ET:=false;
for h := 1  to length(Str) do
  begin
    if str[h]='.' then
      if ET=false then ET:=true
        else
        begin
          Delete(str,h,1);
          goto lblZanovo2;
        end;
  end;
edtFrq.Text:=Str;
edtFrq.SelStart:=SS;
end;

procedure TformSettings.FormActivate(Sender: TObject);
vAR
Str:ansistring;
begin
self.Caption:=GetText(3)+': '+GetText(0)+' ('+inttostr(InternalIndex)+')';


//Форма сигнала
case SignalMode[InternalIndex] of
1:
begin
rbSin.Checked := true;
end;
2:
begin
rbrectangular.Checked := true;
end;
3:
begin
rbtriangular.Checked := true;
end;
4:
begin
rbsawtooth.Checked := true;
end;
5:
begin
rbsawtoothNR.Checked := true;
end;
end;
//Freq
Str:=inttostr(SignalFrq[InternalIndex]);
if Length(Str)>9 then Str:=Copy(Str,1,9);
edtFrq.Text:=Str;
//Amin
Str:=floattostrf(Amin[InternalIndex],ffFixed,5,5,formatSettings);
if Length(Str)>5 then Str:=Copy(Str,1,5);
edtAmin.Text:=Str;
//Amax
Str:=floattostrf(Amax[InternalIndex],ffFixed,5,5,formatSettings);
if Length(Str)>5 then Str:=Copy(Str,1,5);
edtAmax.Text:=Str;
//Duty cycle
edtDC.Text:=inttostr(Round(SignalD[InternalIndex]*100));
end;

procedure TformSettings.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Application.Handle:=OrigHandle;
end;


procedure TformSettings.FormCreate(Sender: TObject);
begin


BtnOk.Caption:=GetText(1);
btnCancel.Caption:=GetText(2);
gbWaveform.Caption:=GetText(20);
gbWP.Caption:=GetText(21);
gbEquivalentCircuit.Caption:=GetText(22);

rbsin.Caption:=gettext(10);
rbRectangular.Caption:=gettext(11);
rbTriangular.Caption:=gettext(12);
rbSawtooth.Caption:=gettext(13);
rbSawtoothNR.Caption:=gettext(14);
lblFrq.Caption:=Gettext(4);
Label1.Caption:=Gettext(5);
lblDC.Caption:=Gettext(6);


redrawForm();


end;

procedure TformSettings.edtDCChange(Sender: TObject);
var h,SS:integer;
Str:string;
label lblZanovo;
begin
//Удаление всех символов, кроме "0","1","2","3","4","5","6","7","8","9"
Str:=edtDC.Text;
SS:=edtDC.SelStart;
lblZanovo:
for h := 1  to length(Str) do
  begin
    if ((Str[h]='0') or (Str[h]='1') or (Str[h]='2') or (Str[h]='3') or (Str[h]='4') or (Str[h]='5') or (Str[h]='6') or (Str[h]='7') or (Str[h]='8') or (Str[h]='9')) = false then
    begin
      Delete(Str,h,1);
      goto lblZanovo;
    end;
  end;
edtDC.Text:=Str;
edtDC.SelStart:=SS;
end;

procedure TformSettings.edtAmaxChange(Sender: TObject);
var h,SS:integer;
Str:string;
ET:boolean;
label lblZanovo, lblZanovo1,lblZanovo2;
begin
//Удаление всех символов, кроме "0","1","2","3","4","5","6","7","8","9",".",",","-".
Str:=edtAmax.Text;
SS:=edtAmax.SelStart;
lblZanovo:
for h := 1  to length(Str) do
  begin
    if ((Str[h]='0') or (Str[h]='1') or (Str[h]='2') or (Str[h]='3') or (Str[h]='4') or (Str[h]='5') or (Str[h]='6') or (Str[h]='7') or (Str[h]='8') or (Str[h]='9') or (Str[h]='.') or (Str[h]=',') or (Str[h]='-')) = false then
    begin
      Delete(Str,h,1);
      goto lblZanovo;
    end;
  end;
//Минус может быть только в самом начале
lblZanovo1:
for h := 2  to length(Str) do
  begin
    if Str[h]='-' then
    begin
      Delete(str,h,1);
      goto lblZanovo1;
    end;
  end;
//Замена всех запятых на точки
for h := 1  to length(Str) do
  begin
    if Str[h]=',' then Str[h]:='.'
  end;
//Удаление последних точек
lblZanovo2:
ET:=false;
for h := 1  to length(Str) do
  begin
    if str[h]='.' then
      if ET=false then ET:=true
        else
        begin
          Delete(str,h,1);
          goto lblZanovo2;
        end;
  end;
edtAmax.Text:=Str;
edtAmax.SelStart:=SS;
end;


end.
