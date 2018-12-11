library sdevKey;

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
  vcl.controls,
  unitClasses4Devices in '..\..\..\Units\Other\unitClasses4Devices.pas',
  frmSettings in 'frmSettings.pas' {formSettings} ,
  UnitRes in 'UnitRes.pas';

Const
  cNumberOfPorts = 1; //  оличество портов на нашем устройстве
  // cCurrentVersion:shortstring='1.0'; //¬ерси€ ATCSS, дл€ кот. создаетс€ библиотека
  cImgDeviceWidth = 20; // Ўирина изображени€ нашей радиодетали на "схеме"
  cImgDeviceHeigth = 20; // ¬ысота изображени€ нашей радиодетали на "схеме"
  cDevType = 100; // “ип нашего устройства
  cSDevType: shortstring = 'Input';
  cSDevFamily: shortstring = 'Switch';
  cSDevModel: shortstring = 'Switch';

Var
  TD: array of TDevice;
  // Ёкземпл€р класса "усройства", массив - потомучто может быть много устройств создано
  // TP: TRCPorts;// Ёкземпл€р массива "портов" , массив - потомучто может быть много устройств создано
  TID: TInfoDevice; // Ёкземпл€р записи "»нформаци€ о устройстве"

var
  Pushed: array of boolean;
  // “екущее состо€ние (нажато или нет), массив - потомучто м/б несколько экземпл€ров устройства
  // bmp_0,bmp_1:TBitmap; // артинки "нажато" и "не нажато"

{$R *.res}

  // CallBack -методы
function BackProcGetLevel(Sender: TObject): single; stdcall;
// ‘ункци€ обратного вызова уровн€ сигнала;
var tmpB:boolean;
begin
  // #NI
  // if invert then result:=1 else result:=0;
  if aHI[(Sender as trcport).Device.InternalIndex] then tmpB:=false else tmpB:=true;
  if Pushed[(Sender as trcport).Device.InternalIndex] xor tmpB  then
    result := 5
  else
    result := 0;
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

procedure BackProcDraw(Sender: TObject; isRunning: boolean;
  RunningTime: Extended); stdcall;
var
  s: integer;
begin

  // ќчистим Image
  if Assigned((Sender as TDevice).Image) then
  begin
//    (Sender as TDevice).Image.CleanupInstance;
    // if assigned((Sender as TDevice).Port[0].Node) then
    if Pushed[(Sender as TDevice).InternalIndex] then
      (Sender as TDevice).Image.Canvas.Draw(0, 0,
        Bmp_1[(Sender as TDevice).InternalIndex])
    else
      (Sender as TDevice).Image.Canvas.Draw(0, 0,
        Bmp_0[(Sender as TDevice).InternalIndex])
      // else (Sender as TDevice).Image.Canvas.Draw(0,0,Bmp_0);
  end;

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
          LoadBitmap(HInstance, 'Gray0');
        Bmp_1[(Sender as TDevice).InternalIndex] := TBitmap.Create;
        Bmp_1[(Sender as TDevice).InternalIndex].Handle :=
          LoadBitmap(HInstance, 'Gray1');
      end;

  end;
  if (Sender as TDevice).SaveData[1] = 'S' then
    aType[(Sender as TDevice).InternalIndex] := 0
  else if (Sender as TDevice).SaveData[1] = 'S' then
    aType[(Sender as TDevice).InternalIndex] := 1
  else
    aType[(Sender as TDevice).InternalIndex] := 2;

  if (Sender as TDevice).SaveData[2] = 'H' then
    aHI[(Sender as TDevice).InternalIndex] := true
  else
    aHI[(Sender as TDevice).InternalIndex] := false;
  BackProcDraw(Sender, false, 0);
end;

Procedure BackMD(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
  X, Y: integer); stdcall;
begin
  if Button = mbLeft then
    case aType[(Sender as TDevice).InternalIndex] of
      0:
        Pushed[(Sender as TDevice).InternalIndex] :=
          not Pushed[(Sender as TDevice).InternalIndex];
    else
      Pushed[(Sender as TDevice).InternalIndex] := true;

    end;

end;

Procedure BackMU(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
  X, Y: integer); stdcall;
begin
  if Button = mbLeft then
    case aType[(Sender as TDevice).InternalIndex] of
      0:

    else
      Pushed[(Sender as TDevice).InternalIndex] := false;

    end;
end;

// Ёкспортные методы
Function What_is(var Version: shortstring): integer; stdcall;
begin
  Version := AppVersion4Dll;
  result := cDevType;

end;

Function Get_info_class(): TInfoDevice; stdcall;

begin
  // ”становим €зык
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
end;

Function Get_Device_class(hosthandle: THandle;MainDevice:TDevice): TDevice; stdcall;
begin
  UnitRes.SetLang();

  // —оздаем экземпл€р класса нашего устройства
  // —оздаем экземпл€р класса нашего устройства
  SetLength(TD, High(TD) + 2);
  SetLength(Bmp_0, High(Bmp_0) + 2);
  SetLength(Bmp_1, High(Bmp_1) + 2);
  SetLength(aType, High(aType) + 2);
  SetLength(aHI, High(aType) + 2);

  TD[High(TD)] := TDevice.Create(High(TD), cImgDeviceWidth, cImgDeviceHeigth,
    cDevType, cSDevType, cSDevFamily, cSDevModel, cNumberOfPorts, @BackProcDraw,
    nil,  @BackMD,  Nil,  @BackMU,  nil,
    @BackShowSettings,  @BackApplySaveData,nil, application.Handle,
    hosthandle,MainDevice,nil);
  TD[High(TD)].addPort('Switch_Out', 2, true, 0, @BackProcGetLevel);

  TD[High(TD)].LenSaveData := 3;
  TD[High(TD)].SaveData[0] := 'R';
  TD[High(TD)].SaveData[1] := 'M';
  TD[High(TD)].SaveData[2] := 'H';
  TD[High(TD)].ApplySettings;
  // —оздадим экземпл€р массива Pushed
  SetLength(Pushed, High(TD) + 1);
  Pushed[High(TD)] := false;
  // ¬озвратим ссылку на экземпл€р класса устройства
  result := TD[High(TD)];

end;

exports Get_Device_class name 'Get_Device_class';

exports Get_info_class name 'Get_info_class';

exports What_is name 'What_is';

exports BackApplySaveData name 'BackApplySaveData';

begin

end.
