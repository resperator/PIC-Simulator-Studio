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
    gbWP: TGroupBox;
    lblAmin: TLabel;
    edtAmin: TEdit;
    edtAmax: TEdit;
    lblAmax: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edtVstart: TEdit;
    Label1: TLabel;
    Label4: TLabel;
    chkStart: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure edtAminChange(Sender: TObject);
    procedure edtAmaxChange(Sender: TObject);
    procedure edtVstartChange(Sender: TObject);


  private
    { Private declarations }


  public
    { Public declarations }
    OrigHandle:THandle; //Application.handle, кот. необходимо восстановить при выходе
    InternalIndex:integer; //Внутренний индекс в рамках данного семейства радиодеталей
    Device:TDevice; //Ссылка на экземпляр класса TDevice, для кот. вызвано окно
  end;

var
  formSettings: TformSettings;
  Vmin:array of single; //Минимальное напряжение
  Vmax:array of single; //Максимальное напряжения
  Vstart:array of single; //Напряжение при старте симуляции
  StartOnVal:array of boolean; //Флаг стартовать с определенного значения (или с последнего, с которого закончилась симуляция)
  Position: array of integer; //Позиция ползунка (0-200)
  md:array of boolean; //Нажата ли левая кнопка мыши? (Для перемещения ползунка)
  mdx:array of integer; //Координата X курсора мыши(Для перемещения ползунка)
  bmp_back: array of TBitmap; //Картинки - задний фон
  bmp_slider: array of TBitmap; //Картинки - задний фон



implementation

{$R *.dfm}








procedure TformSettings.btnCancelClick(Sender: TObject);
begin
self.Close;
end;

procedure TformSettings.btnOkClick(Sender: TObject);
var str:Ansistring;
A:integer;
B:single;
Vmin,Vmax:single;
formatSettings:TFormatSettings;
label lblZanovo1,lblZanovo2,lblZanovo3,lblZanovo4;
begin
device.LenSaveData:=16;
formatSettings:=TFormatSettings.Create();
formatSettings.ListSeparator:='.';
formatSettings.DecimalSeparator:='.';
//Chk
  if chkStart.Checked then
    Device.Savedata[0] := '1'
  else
    Device.Savedata[0] := '0';
//Vmin
Str:=edtAmin.Text;
if Str='' then str:='0';

 try
    B:= StrTofloat(Str,FormatSettings);    // Конечные пробелы не поддерживаются
  except
    on Exception : EConvertError do
        B:=0;
  end;
  if B<-9999 then B:=-9999;
  if B>99999 then B:=99999;
 Vmin:=B;
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
   device.Savedata[A]:=Str[A];
//Amax
Str:=edtAmax.Text;
if Str='' then str:='5';
 try
    B:= StrTofloat(Str,FormatSettings );    // Конечные пробелы не поддерживаются
  except
    on Exception : EConvertError do
        B:=5;
  end;
  if B<-9999 then B:=-9999;
  if B>99999 then B:=99999;
  if B<Vmin then B:=Vmin;

  Vmax:=B;
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
   device.Savedata[A+5]:=Str[A];
//Vstart
Str:=edtVstart.Text;
if Str='' then str:=floattostrf(Vmin,ffFixed,5,5,formatSettings);
 try
    B:= StrTofloat(Str,FormatSettings );    // Конечные пробелы не поддерживаются
  except
    on Exception : EConvertError do
        B:=Vmin;
  end;
  if B<-9999 then B:=-9999;
  if B>99999 then B:=99999;
  if  B<Vmin then b:=Vmin;
  if B>Vmax then b:=Vmax;

Str:=floattostrf(B,ffFixed,5,5,formatSettings);
if Length(Str)>5 then
begin
Str:=Copy(Str,1,5);
if copy(Str,5,1)='.' then if B>=0 then Str:='0'+Copy(Str,1,4) else Str:='-0'+ copy(Str,2,3);
end;
lblZanovo4:
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
   device.Savedata[A+10]:=Str[A];

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



procedure TformSettings.FormActivate(Sender: TObject);
vAR
Str:ansistring;
begin
self.Caption:=GetText(3)+': '+GetText(0)+' ('+inttostr(InternalIndex)+')';



//Amin
Str:=floattostrf(Vmin[InternalIndex],ffFixed,5,5,formatSettings);
if Length(Str)>5 then Str:=Copy(Str,1,5);
edtAmin.Text:=Str;
//Amax
Str:=floattostrf(Vmax[InternalIndex],ffFixed,5,5,formatSettings);
if Length(Str)>5 then Str:=Copy(Str,1,5);
edtAmax.Text:=Str;
//Vstart
if Vstart[InternalIndex]<Vmin[InternalIndex] then Vstart[InternalIndex]:=VMin[InternalIndex];
if Vstart[InternalIndex]>Vmax[InternalIndex] then Vstart[InternalIndex]:=VMax[InternalIndex];

Str:=floattostrf(Vstart[InternalIndex],ffFixed,5,5,formatSettings);
if Length(Str)>5 then Str:=Copy(Str,1,5);
edtVstart.Text:=Str;
end;

procedure TformSettings.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Application.Handle:=OrigHandle;
end;


procedure TformSettings.FormCreate(Sender: TObject);
begin


BtnOk.Caption:=GetText(1);
btnCancel.Caption:=GetText(2);
chkStart.Caption:=GetText(20);
gbWP.Caption:=GetText(21);






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


procedure TformSettings.edtVstartChange(Sender: TObject);
var h,SS:integer;
Str:string;
ET:boolean;
label lblZanovo, lblZanovo1,lblZanovo2;
begin
//Удаление всех символов, кроме "0","1","2","3","4","5","6","7","8","9",".",",","-".
Str:=edtVstart.Text;
SS:=edtVstart.SelStart;
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
edtVstart.Text:=Str;
edtVstart.SelStart:=SS;
end;

end.
