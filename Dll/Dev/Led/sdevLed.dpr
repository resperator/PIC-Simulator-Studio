library sdevLed;

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
  System.SysUtils,
  System.Classes,
  winapi.windows,
  vcl.graphics,
  math,
  unitClasses4Devices in '..\..\..\Units\Other\unitClasses4Devices.pas',
  frmSettings in 'frmSettings.pas' {formSettings} ,
  UnitRes in 'UnitRes.pas';

Const
  cNumberOfPorts = 1; // Количество портов на нашем устройстве
  // cCurrentVersion:shortstring='1.0'; //Версия ATCSS, для кот. создается библиотека
  cImgDeviceWidth = 16; // Ширина изображения нашей радиодетали на "схеме"
  cImgDeviceHeigth = 16; // Высота изображения нашей радиодетали на "схеме"
  cDevType = 50; // Тип нашего устройства
  cSDevType: shortstring = 'Indicator';
  cSDevFamily: shortstring = 'Simple LED';
  cSDevModel: shortstring = 'Simple LED';

Var
  TD: array of TDevice;
  // Экземпляр класса "усройства", массив - потомучто может быть много устройств создано
  // TP: TRCPorts;// Экземпляр массива "портов" , массив - потомучто может быть много устройств создано

  TID: TInfoDevice; // Экземпляр записи "Информация о устройстве"

  GlowVoltage: single = 2; // Напряжение свечения

  // var
  // bmp_0,bmp_1:TBitmap; //Картинки "горит" и "не горит"


  // Там определен HICON

{$R *.res}

  // CallBack -методы
function BackProcGetLevel(Sender: TObject): single; stdcall;
// Функция обратного вызова уровня сигнала;
begin
  // if invert then result:=1 else result:=0;
  result := nan;
end;

procedure BackProcDraw(Sender: TObject; isRunning: boolean;
  RunningTime: Extended); stdcall;
var
  s: integer;
  si: single;
begin
  // #NI инвертный сигнал свечения (5-2)В
  // Очистим Image
  if Assigned((Sender as TDevice).Image) then
  begin
 //   (Sender as TDevice).Image.CleanupInstance;
    if Assigned((Sender as TDevice).Port[0].Node) then
    begin
      si := (Sender as TDevice).Port[0].Node.GetLevel();
      if isnan(si) then
      begin
        (Sender as TDevice).Image.Canvas.Draw(0, 0,
          Bmp_0[(Sender as TDevice).InternalIndex]);
        exit;
      end;

      if (si > GlowVoltage) xor invert[(Sender as TDevice).InternalIndex] then
        (Sender as TDevice).Image.Canvas.Draw(0, 0,
          Bmp_1[(Sender as TDevice).InternalIndex])
      else
        (Sender as TDevice).Image.Canvas.Draw(0, 0,
          Bmp_0[(Sender as TDevice).InternalIndex])
    end
    else
      (Sender as TDevice).Image.Canvas.Draw(0, 0,
        Bmp_0[(Sender as TDevice).InternalIndex]);
  end;

end;

Procedure BackShowSettings(Sender: TObject); stdcall;

begin

  application.Handle := TD[(Sender as TDevice).InternalIndex].hosthandle;
  application.CreateForm(TformSettings, formSettings);
  // frmsettings.formSettings:=TFormSettings.Create(application);

  formSettings.InternalIndex := (Sender as TDevice).InternalIndex;
  formSettings.Device := (Sender as TDevice);
  formSettings.OrigHandle := TD[(Sender as TDevice).InternalIndex].OrigHandle;
  formSettings.ShowModal;

end;

Procedure BackApplySaveData(Sender: TObject); stdcall;
begin
  Bmp_0[(Sender as TDevice).InternalIndex].Free;
  Bmp_1[(Sender as TDevice).InternalIndex].Free;
  case (Sender as TDevice).SaveData[0] of
    'R':
      begin
        Bmp_0[(Sender as TDevice).InternalIndex] := TBitmap.Create;
        Bmp_0[(Sender as TDevice).InternalIndex].Handle :=
          LoadBitmap(HInstance, 'Red0');
        Bmp_1[(Sender as TDevice).InternalIndex] := TBitmap.Create;
        Bmp_1[(Sender as TDevice).InternalIndex].Handle :=
          LoadBitmap(HInstance, 'Red1');
      end;
    'G':
      begin
        Bmp_0[(Sender as TDevice).InternalIndex] := TBitmap.Create;
        Bmp_0[(Sender as TDevice).InternalIndex].Handle :=
          LoadBitmap(HInstance, 'Green0');
        Bmp_1[(Sender as TDevice).InternalIndex] := TBitmap.Create;
        Bmp_1[(Sender as TDevice).InternalIndex].Handle :=
          LoadBitmap(HInstance, 'Green1');
      end;
    'B':
      begin
        Bmp_0[(Sender as TDevice).InternalIndex] := TBitmap.Create;
        Bmp_0[(Sender as TDevice).InternalIndex].Handle :=
          LoadBitmap(HInstance, 'Blue0');
        Bmp_1[(Sender as TDevice).InternalIndex] := TBitmap.Create;
        Bmp_1[(Sender as TDevice).InternalIndex].Handle :=
          LoadBitmap(HInstance, 'Blue1');
      end;
    'Y':
      begin
        Bmp_0[(Sender as TDevice).InternalIndex] := TBitmap.Create;
        Bmp_0[(Sender as TDevice).InternalIndex].Handle :=
          LoadBitmap(HInstance, 'Yellow0');
        Bmp_1[(Sender as TDevice).InternalIndex] := TBitmap.Create;
        Bmp_1[(Sender as TDevice).InternalIndex].Handle :=
          LoadBitmap(HInstance, 'Yellow1');
      end;
    'W':
      begin
        Bmp_0[(Sender as TDevice).InternalIndex] := TBitmap.Create;
        Bmp_0[(Sender as TDevice).InternalIndex].Handle :=
          LoadBitmap(HInstance, 'White0');
        Bmp_1[(Sender as TDevice).InternalIndex] := TBitmap.Create;
        Bmp_1[(Sender as TDevice).InternalIndex].Handle :=
          LoadBitmap(HInstance, 'White1');
      end;

  end;
  if (Sender as TDevice).SaveData[1] = 'H' then
    invert[(Sender as TDevice).InternalIndex] := false
  else
    invert[(Sender as TDevice).InternalIndex] := true;
  BackProcDraw(Sender, false, 0);
end;
// Экспортные методы

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
  SetLength(TD, High(TD) + 2);
  SetLength(Bmp_0, High(Bmp_0) + 2);
  SetLength(Bmp_1, High(Bmp_1) + 2);
  SetLength(invert, High(invert) + 2);



  // frmsettings.SetColor(High(TD),0);

  HDll := application.Handle;
  TD[High(TD)] := TDevice.Create(High(TD), cImgDeviceWidth, cImgDeviceHeigth,
    cDevType, cSDevType, cSDevFamily, cSDevModel, cNumberOfPorts, @BackProcDraw,
    nil,  nil,  nil,  nil,  nil,
    @BackShowSettings,  @BackApplySaveData,nil, HDll, hosthandle,MainDevice,nil);
  TD[High(TD)].addPort('Led_In', 1, true, 0, @BackProcGetLevel);
  // Настройки применяем по-умолчанию:красный цвет, заг. при высоком уровне
  // Setlength(TD[High(TD)].SaveData,2);
  TD[High(TD)].LenSaveData := 2;
  TD[High(TD)].SaveData[0] := 'R';
  TD[High(TD)].SaveData[1] := 'H';
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

  // Код, выполняемый при загрузке библиотеки

end.
