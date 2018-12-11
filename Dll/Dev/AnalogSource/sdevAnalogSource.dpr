library sdevAnalogSource;

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
  cImgDeviceWidth = 208; // Ширина изображения нашей радиодетали на "схеме"
  cImgDeviceHeigth = 43; // Высота изображения нашей радиодетали на "схеме"
  cDevType = 100; // Тип нашего устройства
  cSDevType: shortstring = 'Input';
  cSDevFamily: shortstring = 'Voltage Source';
  cSDevModel: shortstring = 'Voltage Source';
Var
  TD: array of TDevice;
  // Экземпляр класса "усройства", массив - потомучто может быть много устройств создано
  TID: TInfoDevice; // Экземпляр записи "Информация о устройстве"





{$R *.res}

// CallBack -методы
function BackProcGetLevel(Sender: TObject): single; stdcall;
// Функция обратного вызова уровня сигнала;
var fl:single;
begin
     fl:=(Vmax[(Sender as TRCport).device.InternalIndex]-Vmin[(Sender as TRCport).device.InternalIndex])/199;
    result:=fl*position[(Sender as TRCport).device.InternalIndex]+Vmin[(Sender as TRCport).device.InternalIndex];

end;

procedure BackProcDraw(Sender: TObject; isRunning: boolean;
  RunningTime: Extended); stdcall;
var
fl:single;
txt:string;
begin

  // Очистим Image
  if Assigned((Sender as TDevice).Image) then
  begin
 //   (Sender as TDevice).Image.CleanupInstance;
    (Sender as TDevice).Image.Canvas. Draw(0, 0,bmp_back[(Sender as TDevice).InternalIndex]);
        StretchBlt((Sender as TDevice).Image.Canvas.Handle,Position[(Sender as TDevice).InternalIndex],13,9,19,bmp_slider[(Sender as TDevice).InternalIndex].Canvas.Handle,0,0,9,19,SRCAND);
    (Sender as TDevice).Image.Canvas.Font.Size :=8;
    fl:=(Vmax[(Sender as TDevice).InternalIndex]-Vmin[(Sender as TDevice).InternalIndex])/199;
    fl:=fl*position[(Sender as TDevice).InternalIndex]+Vmin[(Sender as TDevice).InternalIndex];
    txt:='V='+ floattostrf(Fl,ffFixed,5,2);
   (Sender as TDevice).Image.Canvas.TextOut(floor((cimgdevicewidth/2)-((Sender as TDevice).Image.Canvas.TextExtent(txt).cx/2)), 0,txt );
    //(Sender as TDevice).Image.Canvas. Draw(1, 13,bmp_slider[(Sender as TDevice).InternalIndex]);
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


//StartOnValue
if (Sender as TDevice).SaveData[0]='1' then StartOnVal[(Sender as TDevice).InternalIndex]:=true else StartOnVal[(Sender as TDevice).InternalIndex]:=false;
//Amin
Str:='';
for A := 1 to 5 do
  Str:=Str+(Sender as TDevice).SaveData[A];
 try
    B := StrToFloat(Str,FormatSettings);
  except
    on Exception : EConvertError do
     B:=0;
  end;
  if B<-9999 then B:=-9999;
  if B>99999 then B:=99999;
Vmin[(Sender as TDevice).InternalIndex]:=B;
//Amax
Str:='';
for A := 1 to 5 do
  Str:=Str+(Sender as TDevice).SaveData[A+5];
 try
    B := StrToFloat(Str,FormatSettings);
  except
    on Exception : EConvertError do
     B:=0;
  end;
  if B<-9999 then B:=-9999;
  if B>99999 then B:=99999;
Vmax[(Sender as TDevice).InternalIndex]:=B;
//Astart
Str:='';
for A := 1 to 5 do
  Str:=Str+(Sender as TDevice).SaveData[A+10];
 try
    B := StrToFloat(Str,FormatSettings);
  except
    on Exception : EConvertError do
     B:=0;
  end;
  if B<-9999 then B:=-9999;
  if B>99999 then B:=99999;
Vstart[(Sender as TDevice).InternalIndex]:=B;

 BackProcDraw(Sender, false, 0);

end;

Procedure BackMD(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
  X, Y: integer); stdcall;
begin
  if (Button = mbLeft) and (Y>12) and (Y<30) and (X>Position[(Sender as TDevice).InternalIndex]) and (X<(Position[(Sender as TDevice).InternalIndex]+8)) then
    begin
      mdx[(Sender as TDevice).InternalIndex]:=X-Position[(Sender as TDevice).InternalIndex];
      md[(Sender as TDevice).InternalIndex]:=true;
    end;



end;

Procedure BackMM(Sender: TObject; Shift: TShiftState; X,
  Y: Integer); stdcall;
var tmpPos:integer;
begin
  if md[(Sender as TDevice).InternalIndex]=true  then
    begin
      tmpPos:=x-mdx[(Sender as TDevice).InternalIndex];
      if tmpPos<0 then tmppos:=0;
      if tmpPos>199 then tmpPos:=199;
       Position[(Sender as TDevice).InternalIndex]:=tmpPos;

    end;
end;
Procedure BackMU(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
  X, Y: integer); stdcall;
begin
  if Button = mbLeft then
    md[(Sender as TDevice).InternalIndex]:=false;
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

  SetLength(Vmin, High(Vmin) + 2); //Увеличим массив
  SetLength(Vmax, High(Vmax) + 2); //Увеличим массив
  SetLength(Vstart, High(Vstart) + 2); //Увеличим массив
  SetLength(StartOnVal, High(StartOnVal) + 2); //Увеличим массив
  SetLength(Position, High(Position) + 2); //Увеличим массив
  SetLength(mdx, High(mdx) + 2); //Увеличим массив
  SetLength(md, High(md) + 2); //Увеличим массив
  SetLength(bmp_back, High(bmp_back) + 2); //Увеличим массив
  SetLength(bmp_Slider, High(bmp_Slider) + 2); //Увеличим массив


  Vmin[High(Vmin)]:=0;
  Vmax[High(Vmax)]:=5;
  Vstart[High(Vstart)]:=0;
  StartOnVal[High(StartOnVal)]:=false;
  md[High(md)]:=false;
  Position[High(Position)]:=0;

  // frmsettings.SetColor(High(TD),0);

  HDll := application.Handle;
  TD[High(TD)] := TDevice.Create(High(TD), cImgDeviceWidth, cImgDeviceHeigth,
    cDevType, cSDevType, cSDevFamily, cSDevModel, cNumberOfPorts, @BackProcDraw,
    nil,  @BackMD,  @BackMM,  @BackMU,  nil,
    @BackShowSettings,  @BackApplySaveData,nil, HDll, hosthandle,MainDevice,nil);
  TD[High(TD)].addPort('VoltageSrc_Out', 2, false, 0, @BackProcGetLevel);
  // Настройки применяем по-умолчанию:+1 при Low-To-Hight
  TD[High(TD)].LenSaveData := 16;
  //Start on value
  TD[High(TD)].SaveData[0] := '0';
  //Vmin 0
  TD[High(TD)].SaveData[1] := '0';
  TD[High(TD)].SaveData[2] := '0';
  TD[High(TD)].SaveData[3] := '0';
  TD[High(TD)].SaveData[4] := '0';
  TD[High(TD)].SaveData[5] := '0';
  //Vmax 5
  TD[High(TD)].SaveData[6] := '0';
  TD[High(TD)].SaveData[7] := '0';
  TD[High(TD)].SaveData[8] := '0';
  TD[High(TD)].SaveData[9] := '0';
  TD[High(TD)].SaveData[10] := '5';
  //Vstart 0
  TD[High(TD)].SaveData[11] := '0';
  TD[High(TD)].SaveData[12] := '0';
  TD[High(TD)].SaveData[13] := '0';
  TD[High(TD)].SaveData[14] := '0';
  TD[High(TD)].SaveData[15] := '0';

  bmp_back[TD[High(TD)].InternalIndex].Free;
  bmp_back[TD[High(TD)].InternalIndex] := TBitmap.Create;
        bmp_back[TD[High(TD)].InternalIndex].Handle :=
          LoadBitmap(HInstance, 'Back');
  bmp_slider[TD[High(TD)].InternalIndex].Free;
  bmp_slider[TD[High(TD)].InternalIndex] := TBitmap.Create;
        bmp_slider[TD[High(TD)].InternalIndex].Handle :=
          LoadBitmap(HInstance, 'Slider');

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
