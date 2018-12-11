library sdevCounter;

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
  cImgDeviceWidth = 171; // Ширина изображения нашей радиодетали на "схеме"
  cImgDeviceHeigth = 16; // Высота изображения нашей радиодетали на "схеме"
  cDevType = 50; // Тип нашего устройства
  cSDevType: shortstring = 'Indicator';
  cSDevFamily: shortstring = 'Simple Counter';
  cSDevModel: shortstring = 'Simple Counter';

Var
  TD: array of TDevice;
  // Экземпляр класса "усройства", массив - потомучто может быть много устройств создано

  TID: TInfoDevice; // Экземпляр записи "Информация о устройстве"

  GlowVoltage: single = 2; // Порог напряжения срабатывания
  LastLevel: array of boolean; //Последнее состояние на порте, чтобы отслеживать его изменение
  UpToDown: array of boolean; //Таймер +1 при перепаде с уровня 1 до 0
  MD:array of boolean; //Mouse down
  counerEnabled :array of boolean;
  Counter: array of int64;


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

var Int1,Int2:int64;


begin
  // Очистим Image
  if Assigned((Sender as TDevice).Image) then
  begin
//    (Sender as TDevice).Image.CleanupInstance;
    (Sender as TDevice).Image.Canvas.Draw(0, 0,bmp_back);
if MD[(Sender as TDevice).InternalIndex] then (Sender as TDevice).Image.Canvas.Draw(151, 0,bmp_1) else   (Sender as TDevice).Image.Canvas.Draw(151, 0,bmp_0);
    // if assigned((Sender as TDevice).Port[0].Node) then
    int1:=Counter[(Sender as TDevice).InternalIndex];

    int2:=int1 div 1000000000;
    Int1:=Int1-(Int2*1000000000);
    (Sender as TDevice).Image.Canvas.TextOut(4,1,inttostr(Int2));

    int2:=int1 div 100000000;
    Int1:=Int1-(Int2*100000000);
    (Sender as TDevice).Image.Canvas.TextOut(19,1,inttostr(Int2));

    int2:=int1 div 10000000;
    Int1:=Int1-(Int2*10000000);
    (Sender as TDevice).Image.Canvas.TextOut(34,1,inttostr(Int2));

    int2:=int1 div 1000000;
    Int1:=Int1-(Int2*1000000);
    (Sender as TDevice).Image.Canvas.TextOut(49,1,inttostr(Int2));

    int2:=int1 div 100000;
    Int1:=Int1-(Int2*100000);
    (Sender as TDevice).Image.Canvas.TextOut(64,1,inttostr(Int2));

    int2:=int1 div 10000;
    Int1:=Int1-(Int2*10000);
    (Sender as TDevice).Image.Canvas.TextOut(79,1,inttostr(Int2));

    int2:=int1 div 1000;
    Int1:=Int1-(Int2*1000);
    (Sender as TDevice).Image.Canvas.TextOut(94,1,inttostr(Int2));

    int2:=int1 div 100;
    Int1:=Int1-(Int2*100);
    (Sender as TDevice).Image.Canvas.TextOut(109,1,inttostr(Int2));

    int2:=int1 div 10;
    Int1:=Int1-(Int2*10);
    (Sender as TDevice).Image.Canvas.TextOut(124,1,inttostr(Int2));
    (Sender as TDevice).Image.Canvas.TextOut(139,1,inttostr(Int1));

      // else (Sender as TDevice).Image.Canvas.Draw(0,0,Bmp_0);
  end;

end;

Procedure SetupCounter(Sender: TObject);
label lbl1;
begin
if not assigned((Sender as TDevice).Image) then goto lbl1;

(Sender as TDevice).Image.Canvas.Font.Style:=[fsBold];
   case (Sender as TDevice).SaveData[0] of
    'R':
      begin
      (Sender as TDevice).Image.Canvas.Font.Color:=clRed;
      end;
    'G':
      begin
      (Sender as TDevice).Image.Canvas.Font.Color:=clGreen;
      end;
    'B':
      begin
(Sender as TDevice).Image.Canvas.Font.Color:=clBlue;
      end;
    'Y':
      begin
(Sender as TDevice).Image.Canvas.Font.Color:=clOlive;
      end;
    'L':
      begin
(Sender as TDevice).Image.Canvas.Font.Color:=clBlack;
      end;
  end;
  BackProcDraw(Sender,false,0);
lbl1:
  if (Sender as TDevice).SaveData[1] = 'H' then UpToDown[(Sender as TDevice).InternalIndex]:=true else UpToDown[(Sender as TDevice).InternalIndex]:=false;
  if (Sender as TDevice).SaveData[2] = 'A' then  Counter[(Sender as TDevice).InternalIndex]:=0;
end;

Procedure BackApplySaveData(Sender: TObject); stdcall;
begin
//(Sender as TDevice).Image.Canvas.Pen:=TPEn.Create;
SetupCounter(Sender);
 {


   }

end;

Procedure BackMD(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
  X, Y: integer); stdcall;
begin
  if (Button = mbLeft) and (X>151) and (X<171) and (Y>0) and (Y<16) then
    MD[(Sender as TDevice).InternalIndex]:=true;



end;

Procedure BackMU(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
  X, Y: integer); stdcall;
begin
 MD[(Sender as TDevice).InternalIndex]:=false;
   if (Button = mbLeft) and (X>151) and (X<171) and (Y>0) and (Y<16) then Counter[(Sender as TDevice).InternalIndex]:=0;

end;

procedure BackTact(Sender: TObject; Tact: INT64); stdcall;
var NowLevel:boolean;
Index:integer;
begin
Index:=(Sender as TDevice).InternalIndex;
if Tact=0 then
begin
LastLevel[Index]:=false;

//Проверим, подключен ли счетчик к какому-нибудь пину?
if Assigned((Sender as TDevice).Port[0].Node) then counerEnabled[Index]:=true else counerEnabled[Index]:=false;
end;
if counerEnabled[Index]=false then exit; //Счетчик не подключен



if (Sender as TDevice).Port[0].Node.GetLevel()<GlowVoltage then NowLevel:=false else NowLevel:=true;
if NowLevel=LastLevel[Index] then exit;
if NowLevel xor UpToDown[Index] then  Counter[Index]:=Counter[Index]+1;
LastLevel[Index]:=NowLevel;



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
  formSettings.ShowModal;
  SetupCounter(Sender);




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
  SetLength(LastLevel, High(LastLevel) + 2); //Увеличим массив
  SetLength(UpToDown, High(UpToDown) + 2); //Увеличим массив
  SetLength(MD, High(MD) + 2); //Увеличим массив
  SetLength(counerEnabled, High(counerEnabled) + 2); //Увеличим массив
  SetLength(Counter, High(Counter) + 2); //Увеличим массив (показания счетчика)
  LastLevel[High(LastLevel)]:=false;
  UpToDown[High(UpToDown)]:=false;
  MD[High(MD)]:=false;
  counerEnabled[High(counerEnabled)]:=false;

  Counter[High(Counter)]:=0;

  // frmsettings.SetColor(High(TD),0);

  HDll := application.Handle;
  TD[High(TD)] := TDevice.Create(High(TD), cImgDeviceWidth, cImgDeviceHeigth,
    cDevType, cSDevType, cSDevFamily, cSDevModel, cNumberOfPorts, @BackProcDraw,
    nil, @BackMD,  Nil,  @BackMU,  nil,
    @BackShowSettings,  @BackApplySaveData,@BackTact, HDll, hosthandle,MainDevice,nil);
  TD[High(TD)].addPort( 'Counter_In', 1, true, 0, @BackProcGetLevel);
  // Настройки применяем по-умолчанию:+1 при Low-To-Hight
  TD[High(TD)].LenSaveData := 3;
  TD[High(TD)].SaveData[0] := 'L';
  TD[High(TD)].SaveData[1] := 'H';
  TD[High(TD)].SaveData[2] := 'A';
  TD[High(TD)].ApplySettings;

  //Загрузка картинок
  if not assigned(bmp_back) then
  begin
  bmp_back:= TBitmap.Create;
  bmp_back.Handle :=
          LoadBitmap(HInstance, 'Frame');
  end;
  if not assigned(bmp_0) then
  begin
    bmp_0:= TBitmap.Create;
    bmp_0.Handle :=
          LoadBitmap(HInstance, 'Res0');
  end;
    if not assigned(bmp_1) then
  begin
    bmp_1:= TBitmap.Create;
    bmp_1.Handle :=
          LoadBitmap(HInstance, 'Res1');
  end;



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
