library sdevSignalGenerator;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

{$R *.dres}

uses
  vcl.forms,
  Vcl.controls,
  System.SysUtils,
  System.Classes,
  winapi.windows,
  vcl.graphics,
  math,
  unitClasses4Devices in '..\..\..\Units\Other\unitClasses4Devices.pas',
  frmSettings in 'frmSettings.pas' {formSettings},
  UnitRes in 'UnitRes.pas';

Const
  cNumberOfPorts = 1; // Количество портов на нашем устройстве
  // cCurrentVersion:shortstring='1.0'; //Версия ATCSS, для кот. создается библиотека
  cImgDeviceWidth = 35; // Ширина изображения нашей радиодетали на "схеме"
  cImgDeviceHeigth = 24; // Высота изображения нашей радиодетали на "схеме"
  cDevType = 100; // Тип нашего устройства
  cSDevType: shortstring = 'Input';
  cSDevFamily: shortstring = 'Signal Generator';
  cSDevModel: shortstring = 'Signal Generator';
Var
  TD: array of TDevice;
  // Экземпляр класса "усройства", массив - потомучто может быть много устройств создано
  TID: TInfoDevice; // Экземпляр записи "Информация о устройстве"





{$R *.res}

// CallBack -методы
function BackProcGetLevel(Sender: TObject): single; stdcall;
// Функция обратного вызова уровня сигнала;
var vMC:int64;
vCF:integer;
time:single;
tdP,dV:single;
II:integer;
begin
  // if invert then result:=1 else result:=0;
  //result := nan;

  (Sender as trcport).Device.Get_MCandCF(vMC,vCF);
  time:=vMC/(vCF/4);
  II:=(Sender as trcport).Device.InternalIndex;
  tdP:=time*SignalFrq[II];
  dV:=Amax[II]-Amin[II];
  case SignalMode[II] of
  1://Синусойда
    begin
    result:=((1+Sin(2*pi*tdP))/2)*dV+Amin[II];
    exit;
    end;
  2://Прямоугольный
    begin
    if (tdP-Trunc(tdP))<=SignalD[II] then result:=Amax[II] else result:=Amin[II];
    exit;
    end;
  3://Треугольный
    begin
    result:= abs(0.5-tdP+Floor(tdP))*dV*2+Amin[II] ;
    exit;
    end;
  4://Пила
    begin
    result:= (tdP -Floor(tdP))*dV+Amin[II];
    exit;
    end;
  5://Пила наоборот
    begin
    result:=dV*(1-tdP +Floor(tdP))+Amin[II] ;
    exit;
    end;
  end;

end;

procedure BackProcDraw(Sender: TObject; isRunning: boolean;
  RunningTime: Extended); stdcall;
begin

  // Очистим Image
  if Assigned((Sender as TDevice).Image) then
  begin
 //   (Sender as TDevice).Image.CleanupInstance;
    (Sender as TDevice).Image.Canvas. Draw(0, 0,bmp_back[(Sender as TDevice).InternalIndex]);
  end;

end;

Procedure BackApplySaveData(Sender: TObject); stdcall;
var Str:ansistring;
A:integer;
B:single;
formatSettings:TFormatSettings;
begin

formatSettings:=TFormatSettings.Create();
formatSettings.ListSeparator:='.';
formatSettings.DecimalSeparator:='.';

  bmp_back[(Sender as TDevice).InternalIndex].Free;

  case (Sender as TDevice).SaveData[0] of
    '1':
      begin
        bmp_back[(Sender as TDevice).InternalIndex] := TBitmap.Create;
        bmp_back[(Sender as TDevice).InternalIndex].Handle :=
          LoadBitmap(HInstance, 'sin');
        SignalMode[(Sender as TDevice).InternalIndex]:=1;
      end;
    '2':
      begin
         bmp_back[(Sender as TDevice).InternalIndex] := TBitmap.Create;
        bmp_back[(Sender as TDevice).InternalIndex].Handle :=
          LoadBitmap(HInstance, 'rect');
        SignalMode[(Sender as TDevice).InternalIndex]:=2;
      end;
    '3':
      begin
        bmp_back[(Sender as TDevice).InternalIndex] := TBitmap.Create;
        bmp_back[(Sender as TDevice).InternalIndex].Handle :=
          LoadBitmap(HInstance, 'tri');
        SignalMode[(Sender as TDevice).InternalIndex]:=3;
      end;
    '4':
      begin
        bmp_back[(Sender as TDevice).InternalIndex] := TBitmap.Create;
        bmp_back[(Sender as TDevice).InternalIndex].Handle :=
          LoadBitmap(HInstance, 'saw');
        SignalMode[(Sender as TDevice).InternalIndex]:=4;
      end;
    '5':
      begin
        bmp_back[(Sender as TDevice).InternalIndex] := TBitmap.Create;
        bmp_back[(Sender as TDevice).InternalIndex].Handle :=
          LoadBitmap(HInstance, 'sawNR');
        SignalMode[(Sender as TDevice).InternalIndex]:=5;
      end;
    end;
//Freq

Str:='';
for A := 1 to 9 do
  Str:=Str+(Sender as TDevice).SaveData[A];
 try
    A := StrToInt(Str);
  except
    on Exception : EConvertError do
      A:=32768;
  end;
  if A<0 then A:=0;
  if A>999999999 then A:=999999999;
  SignalFrq[(Sender as TDevice).InternalIndex]:=A;
  SignalPeriod[(Sender as TDevice).InternalIndex]:=1/SignalFrq[(Sender as TDevice).InternalIndex];
//Amin
Str:='';
for A := 1 to 5 do
  Str:=Str+(Sender as TDevice).SaveData[A+9];
 try
    B := StrToFloat(Str,FormatSettings);
  except
    on Exception : EConvertError do
     B:=0;
  end;
  if B<-9999 then B:=-9999;
  if B>99999 then B:=99999;
Amin[(Sender as TDevice).InternalIndex]:=B;
//Amax
Str:='';
for A := 1 to 5 do
  Str:=Str+(Sender as TDevice).SaveData[A+14];
 try
    B := StrToFloat(Str,FormatSettings);
  except
    on Exception : EConvertError do
     B:=0;
  end;
  if B<-9999 then B:=-9999;
  if B>99999 then B:=99999;
Amax[(Sender as TDevice).InternalIndex]:=B;
//Duty cycle
SignalD[(Sender as TDevice).InternalIndex]:=ord((Sender as TDevice).SaveData[20])/100;

 BackProcDraw(Sender, false, 0);

end;


Procedure BackShowSettings(Sender: TObject); stdcall;
  var
  ss:TSTringstream;
begin

  application.Handle := TD[(Sender as TDevice).InternalIndex].hosthandle;
  Application.CreateForm(TformSettings, formSettings);
  // frmsettings.formSettings:=TFormSettings.Create(application);

  formSettings.InternalIndex := (Sender as TDevice).InternalIndex;
  formSettings.Device := (Sender as TDevice);
  formSettings.OrigHandle := TD[(Sender as TDevice).InternalIndex].OrigHandle;
  BackApplySaveData(Sender);
  formSettings.ShowModal;
  BackApplySaveData(Sender);





end;

Function What_is(var Version: shortstring): integer; stdcall;
begin
  Version := AppVersion4Dll;
  result := cDevType;
end;

Function Get_info_class(): TInfoDevice; stdcall;

begin
  // Установим язык
  UnitRes.SetLang();

  TID := TInfoDevice.Create;
  TID.vType := cDevType;
  TID.vSType := cSDevType;
  TID.vSFamily := cSDevFamily;
  TID.evFileName := '';
  TID.evLoaded := false;
  TID.evLibHandle := 0;
  SetLength(TID.vSModel, 1);
  TID.vSModel[0] := cSDevModel;
  TID.vIcon := LoadIcon(HInstance, 'tlb');
  TID.vSDisplayName := GetText(0);
  Get_info_class := TID;
  // ,GetText(0)
end;

Function Get_Device_class(hosthandle: THandle;MainDevice:TDevice): TDevice; stdcall;
Var
  HDll: THandle;
begin
  UnitRes.SetLang();
  // Создаем экземпляр класса нашего устройства
  SetLength(TD, High(TD) + 2); //Увеличим массив экземпляров TDevice
  SetLength(SignalMode, High(SignalMode) + 2); //Увеличим массив
  SetLength(SignalFrq, High(SignalFrq) + 2); //Увеличим массив
  SetLength(SignalPeriod, High(SignalPeriod) + 2); //Увеличим массив
  SetLength(Amin, High(Amin) + 2); //Увеличим массив
  SetLength(Amax, High(Amax) + 2); //Увеличим массив
  SetLength(SignalD, High(SignalD) + 2); //Увеличим массив
  SetLength(bmp_back, High(bmp_back) + 2); //Увеличим массив


  SignalMode[High(SignalMode)]:=0;
  SignalFrq[High(SignalFrq)]:=32768;
  SignalPeriod[High(SignalFrq)]:=1/SignalFrq[High(SignalFrq)];
  Amin[High(Amin)]:=0;
  Amax[High(Amax)]:=5;
  SignalD[High(Amax)]:=0.5;



  // frmsettings.SetColor(High(TD),0);

  HDll := application.Handle;
  TD[High(TD)] := TDevice.Create(High(TD), cImgDeviceWidth, cImgDeviceHeigth,
    cDevType, cSDevType, cSDevFamily, cSDevModel, cNumberOfPorts, @BackProcDraw,
    nil, Nil,  Nil,  Nil,  nil,
    @BackShowSettings,  @BackApplySaveData,nil, HDll, hosthandle,MainDevice,nil);
  TD[High(TD)].addPort('Generator_Out', 2, false, 0, @BackProcGetLevel);
  // Настройки применяем по-умолчанию:+1 при Low-To-Hight
  TD[High(TD)].LenSaveData := 21;
  //Sin
  TD[High(TD)].SaveData[0] := '1';
  //Freq 32768
  TD[High(TD)].SaveData[1] := '0';
  TD[High(TD)].SaveData[2] := '0';
  TD[High(TD)].SaveData[3] := '0';
  TD[High(TD)].SaveData[4] := '0';
  TD[High(TD)].SaveData[5] := '3';
  TD[High(TD)].SaveData[6] := '2';
  TD[High(TD)].SaveData[7] := '7';
  TD[High(TD)].SaveData[8] := '6';
  TD[High(TD)].SaveData[9] := '8';
  //Amin 0
  TD[High(TD)].SaveData[10] := '0';
  TD[High(TD)].SaveData[11] := '0';
  TD[High(TD)].SaveData[12] := '0';
  TD[High(TD)].SaveData[13] := '0';
  TD[High(TD)].SaveData[14] := '0';
  //Amax 5
  TD[High(TD)].SaveData[15] := '0';
  TD[High(TD)].SaveData[16] := '0';
  TD[High(TD)].SaveData[17] := '0';
  TD[High(TD)].SaveData[18] := '0';
  TD[High(TD)].SaveData[19] := '5';
  //Duty cycle
  TD[High(TD)].SaveData[20] := AnsiChar(50);

  TD[High(TD)].ApplySettings;





  // Возвратим ссылку на экземпляр класса устройства
  result := TD[High(TD)];

end;

// Объявление методов экспортными

exports Get_Device_class name 'Get_Device_class';

exports Get_info_class name 'Get_info_class';

exports What_is name 'What_is';

exports BackApplySaveData name 'BackApplySaveData';
begin
end.
