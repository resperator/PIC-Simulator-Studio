library sdev7SegmentIndicator;

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
  cNumberOfPorts = 9; // Количество портов на нашем устройстве
  // cCurrentVersion:shortstring='1.0'; //Версия ATCSS, для кот. создается библиотека
  cImgDeviceWidth = 45; // Ширина изображения нашей радиодетали на "схеме"
  cImgDeviceHeigth = 75; // Высота изображения нашей радиодетали на "схеме"
  cDevType = 51; // Тип нашего устройства
  cSDevType: shortstring = 'Presistence Indicator';
  cSDevFamily: shortstring = '7-Segment Indicator';
  cSDevModel: shortstring = '7-Segment Indicator';

Var
  TD: array of TDevice;
  // Экземпляр класса "усройства", массив - потомучто может быть много устройств создано
  TID: TInfoDevice; // Экземпляр записи "Информация о устройстве"

  GlowVoltage: single = 2; // Напряжение свечения
{$R *.res}

  // CallBack -методы
function BackProcGetLevel(Sender: TObject): single; stdcall;
// Функция обратного вызова уровня сигнала;
begin
  // if invert then result:=1 else result:=0;
  result := nan;
end;

/// //////////////////////////////////////////////////////////////
procedure BackProcDraw(Sender: TObject; isRunning: boolean;
  RunningTime: Extended); stdcall;
var
  res, X, Y: integer;
  resDP: boolean;

  si: single;

  Ii: boolean;

  RCT: TRect;

label PLOT,PLOT2, DRAW;

begin
  // #NI инвертный сигнал свечения (5-2)В
  // Очистим Image

  if Assigned((Sender as TDevice).Image) then
  begin
    res := 0; // По-умолчанию пусто
    resDP := false;
 //   (Sender as TDevice).Image.CleanupInstance;
    //Попытка построения, учитывая текущее состояние порта+статистические данные
    if EN[(Sender as TDevice).InternalIndex] then
    begin // Нужен какой-то уровень сигнала на EN
      if not Assigned((Sender as TDevice).Port[8].Node) then
        goto PLOT2;
      si := (Sender as TDevice).Port[8].Node.GetLevel();
      if isnan(si) then
        goto PLOT2;
      if (si > GlowVoltage) xor InvertEN[(Sender as TDevice).InternalIndex] then
        goto PLOT
      else
        goto PLOT2;
    end
    else
    begin // Не нужен сигнал на EN
    PLOT: //Построения, учитывая текущее состояние порта+статистические данные
      Ii := Invert[(Sender as TDevice).InternalIndex];

      if Assigned((Sender as TDevice).Port[0].Node) then
      begin
        si := (Sender as TDevice).Port[0].Node.GetLevel();
        if ((not isnan(si)) and ((si > GlowVoltage) xor Ii)) or (Seg_a_GLOW[(Sender as TDevice).InternalIndex]) then
          res := res + 1;
      end;
      if Assigned((Sender as TDevice).Port[1].Node) then
      begin
        si := (Sender as TDevice).Port[1].Node.GetLevel();
        if ((not isnan(si)) and ((si > GlowVoltage) xor Ii)) or (Seg_b_GLOW[(Sender as TDevice).InternalIndex]) then
          res := res + 2;
      end;
      if Assigned((Sender as TDevice).Port[2].Node) then
      begin
        si := (Sender as TDevice).Port[2].Node.GetLevel();
        if ((not isnan(si)) and ((si > GlowVoltage) xor Ii)) or (Seg_c_GLOW[(Sender as TDevice).InternalIndex]) then
          res := res + 4;
      end;
      if Assigned((Sender as TDevice).Port[3].Node) then
      begin
        si := (Sender as TDevice).Port[3].Node.GetLevel();
        if ((not isnan(si)) and ((si > GlowVoltage) xor Ii)) or (Seg_d_GLOW[(Sender as TDevice).InternalIndex]) then
          res := res + 8;
      end;
      if Assigned((Sender as TDevice).Port[4].Node) then
      begin
        si := (Sender as TDevice).Port[4].Node.GetLevel();
        if ((not isnan(si)) and ((si > GlowVoltage) xor Ii)) or (Seg_e_GLOW[(Sender as TDevice).InternalIndex]) then
          res := res + 16;
      end;
      if Assigned((Sender as TDevice).Port[5].Node) then
      begin
        si := (Sender as TDevice).Port[5].Node.GetLevel();
        if ((not isnan(si)) and ((si > GlowVoltage) xor Ii)) or (Seg_f_GLOW[(Sender as TDevice).InternalIndex]) then
          res := res + 32;
      end;
      if Assigned((Sender as TDevice).Port[6].Node) then
      begin
        si := (Sender as TDevice).Port[6].Node.GetLevel();
        if ((not isnan(si)) and ((si > GlowVoltage) xor Ii)) or (Seg_g_GLOW[(Sender as TDevice).InternalIndex]) then
          res := res + 64;
      end;
      if Assigned((Sender as TDevice).Port[7].Node) then
      begin
        si := (Sender as TDevice).Port[7].Node.GetLevel();
        if ((not isnan(si)) and ((si > GlowVoltage) xor Ii)) or (Seg_DP_GLOW[(Sender as TDevice).InternalIndex]) then
          resDP := true;
      end;
      goto DRAW;
    end;

 PLOT2: // Построение только по данным статистики
    if Seg_a_GLOW[(Sender as TDevice).InternalIndex] then
      res := res + 1;
    if Seg_b_GLOW[(Sender as TDevice).InternalIndex] then
      res := res + 2;
    if Seg_c_GLOW[(Sender as TDevice).InternalIndex] then
      res := res + 4;
    if Seg_d_GLOW[(Sender as TDevice).InternalIndex] then
      res := res + 8;
    if Seg_e_GLOW[(Sender as TDevice).InternalIndex] then
      res := res + 16;
    if Seg_f_GLOW[(Sender as TDevice).InternalIndex] then
      res := res + 32;
    if Seg_g_GLOW[(Sender as TDevice).InternalIndex] then
      res := res + 64;
    if Seg_DP_GLOW[(Sender as TDevice).InternalIndex] then
      resDP := true;

  DRAW: // Рисуем нужную цифру или знак
    Y := trunc(res / 16);
    X := res - (Y * 16);

    Y := Y * cImgDeviceHeigth;
    X := X * cImgDeviceWidth;
    RCT := Rect(X, Y, X + cImgDeviceWidth, Y + cImgDeviceHeigth);
    (Sender as TDevice).Image.Canvas.CopyRect(Rect(0, 0, cImgDeviceWidth,
      cImgDeviceHeigth), Bmp[(Sender as TDevice).InternalIndex].Canvas, RCT);
    (Sender as TDevice).Image.Canvas.MoveTo(0,0);
    (Sender as TDevice).Image.Canvas.LineTo(44,0);
    (Sender as TDevice).Image.Canvas.LineTo(44,74);
    (Sender as TDevice).Image.Canvas.LineTo(0,74);
    //(Sender as TDevice).Image.Canvas.LineTo(1,1);
    (Sender as TDevice).Image.Canvas.MoveTo(0,0);
    (Sender as TDevice).Image.Canvas.LineTo(0,74);
    if resDP then
    begin
    case (Sender as TDevice).Savedata[0]  of
    'G': (Sender as TDevice).Image.Canvas.Brush.Color:=clgreen;
    'B': (Sender as TDevice).Image.Canvas.Brush.Color:=clblue;
    'Y': (Sender as TDevice).Image.Canvas.Brush.Color:=clyellow;
    else
     (Sender as TDevice).Image.Canvas.Brush.Color:=clred;
    end;


     (Sender as TDevice).Image.Canvas.Ellipse(38,65,44,71);
    end;
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
  Bmp[(Sender as TDevice).InternalIndex].Free;

  case (Sender as TDevice).SaveData[0] of
    'R':
      begin
        Bmp[(Sender as TDevice).InternalIndex] := TBitmap.Create;
        Bmp[(Sender as TDevice).InternalIndex].Handle :=
          LoadBitmap(HInstance, 'Red');

      end;
    'G':
      begin
        Bmp[(Sender as TDevice).InternalIndex] := TBitmap.Create;
        Bmp[(Sender as TDevice).InternalIndex].Handle :=
          LoadBitmap(HInstance, 'Green');
      end;
    'B':
      begin
        Bmp[(Sender as TDevice).InternalIndex] := TBitmap.Create;
        Bmp[(Sender as TDevice).InternalIndex].Handle :=
          LoadBitmap(HInstance, 'Blue');
      end;
    'Y':
      begin
        Bmp[(Sender as TDevice).InternalIndex] := TBitmap.Create;
        Bmp[(Sender as TDevice).InternalIndex].Handle :=
          LoadBitmap(HInstance, 'Yellow');
      end;
  end;

  if (Sender as TDevice).SaveData[1] = 'H' then
    Invert[(Sender as TDevice).InternalIndex] := false
  else
    Invert[(Sender as TDevice).InternalIndex] := true;
  if (Sender as TDevice).SaveData[2] = 'D' then
    EN[(Sender as TDevice).InternalIndex] := false
  else
  begin
    EN[(Sender as TDevice).InternalIndex] := true;
    if (Sender as TDevice).SaveData[2] = 'H' then
      InvertEN[(Sender as TDevice).InternalIndex] := false
    else
      InvertEN[(Sender as TDevice).InternalIndex] := true;
  end;

  PrPeriod[(Sender as TDevice).InternalIndex] :=
    ord((Sender as TDevice).SaveData[3]);
  PrDC[(Sender as TDevice).InternalIndex] :=
    ord((Sender as TDevice).SaveData[4]);

  BackProcDraw(Sender, false, 0);
end;

/// ///////////////////////////////////////////////////
procedure BackTact(Sender: TObject; Tact: INT64); stdcall;
var
  Index: integer;
  si: single;
  Snder: TDevice;
  MC: INT64;
  CF: integer;
label consider;
begin
  Snder := (Sender as TDevice);
  Index := Snder.InternalIndex;
  // Самый первый такт, проверим какие пины подключены
  if Tact = 0 then
  begin
    if Assigned(Snder.Port[0].Node) then
      Seg_a_EN[Index] := true
    else
      Seg_a_EN[Index] := false;
    if Assigned(Snder.Port[1].Node) then
      Seg_b_EN[Index] := true
    else
      Seg_b_EN[Index] := false;
    if Assigned(Snder.Port[2].Node) then
      Seg_c_EN[Index] := true
    else
      Seg_c_EN[Index] := false;
    if Assigned(Snder.Port[3].Node) then
      Seg_d_EN[Index] := true
    else
      Seg_d_EN[Index] := false;
    if Assigned(Snder.Port[4].Node) then
      Seg_e_EN[Index] := true
    else
      Seg_e_EN[Index] := false;
    if Assigned(Snder.Port[5].Node) then
      Seg_f_EN[Index] := true
    else
      Seg_f_EN[Index] := false;
    if Assigned(Snder.Port[6].Node) then
      Seg_g_EN[Index] := true
    else
      Seg_g_EN[Index] := false;
    if Assigned(Snder.Port[7].Node) then
      Seg_DP_EN[Index] := true
    else
      Seg_DP_EN[Index] := false;
    if Assigned(Snder.Port[8].Node) then
      Seg_EN_EN[Index] := true
    else
      Seg_EN_EN[Index] := false;
    Ii[Index] := Invert[Snder.InternalIndex];
    Seg_a_CN[Index] := 0;
    Seg_b_CN[Index] := 0;
    Seg_c_CN[Index] := 0;
    Seg_d_CN[Index] := 0;
    Seg_e_CN[Index] := 0;
    Seg_f_CN[Index] := 0;
    Seg_g_CN[Index] := 0;
    Seg_DP_CN[Index] := 0;
    Seg_a_GLOW[Index] := false;
    Seg_b_GLOW[Index] := false;
    Seg_c_GLOW[Index] := false;
    Seg_d_GLOW[Index] := false;
    Seg_e_GLOW[Index] := false;
    Seg_f_GLOW[Index] := false;
    Seg_g_GLOW[Index] := false;
    Seg_DP_GLOW[Index] := false;

    Snder.Get_MCandCF(MC, CF);
    RefreshTact[Index] := trunc(CF / (4 * PrPeriod[Index]));
    DeltaRefreshTact[Index] := RefreshTact[Index];
  end;
  if EN[Snder.InternalIndex] then
  begin // Нужен какой-то уровень сигнала на EN
    if not Seg_EN_EN[Index] then
      exit; // EN никуда не подключен - выйти
    si := Snder.Port[8].Node.GetLevel();
    if isnan(si) then
      exit; // С порта EN пришел NAN - выйти
    if (si > GlowVoltage) xor InvertEN[Snder.InternalIndex] then
      goto consider
    else
      exit;
  end
  else
  begin // Не нужен сигнал на EN
  consider: // Или на EN нужный уровень сигнала
    if Seg_a_EN[Index] then
    begin
      si := Snder.Port[0].Node.GetLevel();
      if (not isnan(si)) and ((si > GlowVoltage) xor Ii[Index]) then
        Seg_a_CN[Index] := Seg_a_CN[Index] + 1;
    end;
    if Seg_b_EN[Index] then
    begin
      si := Snder.Port[1].Node.GetLevel();
      if (not isnan(si)) and ((si > GlowVoltage) xor Ii[Index]) then
        Seg_b_CN[Index] := Seg_b_CN[Index] + 1;
    end;
    if Seg_c_EN[Index] then
    begin
      si := Snder.Port[2].Node.GetLevel();
      if (not isnan(si)) and ((si > GlowVoltage) xor Ii[Index]) then
        Seg_c_CN[Index] := Seg_c_CN[Index] + 1;
    end;
    if Seg_d_EN[Index] then
    begin
      si := Snder.Port[3].Node.GetLevel();
      if (not isnan(si)) and ((si > GlowVoltage) xor Ii[Index]) then
        Seg_d_CN[Index] := Seg_d_CN[Index] + 1;
    end;
    if Seg_e_EN[Index] then
    begin
      si := Snder.Port[4].Node.GetLevel();
      if (not isnan(si)) and ((si > GlowVoltage) xor Ii[Index]) then
        Seg_e_CN[Index] := Seg_e_CN[Index] + 1;
    end;
    if Seg_f_EN[Index] then
    begin
      si := Snder.Port[5].Node.GetLevel();
      if (not isnan(si)) and ((si > GlowVoltage) xor Ii[Index]) then
        Seg_f_CN[Index] := Seg_f_CN[Index] + 1;
    end;
    if Seg_g_EN[Index] then
    begin
      si := Snder.Port[6].Node.GetLevel();
      if (not isnan(si)) and ((si > GlowVoltage) xor Ii[Index]) then
        Seg_g_CN[Index] := Seg_g_CN[Index] + 1;
    end;
    if Seg_DP_EN[Index] then
    begin
      si := Snder.Port[7].Node.GetLevel();
      if (not isnan(si)) and ((si > GlowVoltage) xor Ii[Index]) then
        Seg_DP_CN[Index] := Seg_DP_CN[Index] + 1;
    end;
  end;
  if Tact >= RefreshTact[Index] then
  begin
    RefreshTact[Index] := DeltaRefreshTact[Index] + Tact;
    if (PrDC[Index] / 100) <= (Seg_a_CN[Index] / DeltaRefreshTact[Index]) then
      Seg_a_GLOW[Index] := true
    else
      Seg_a_GLOW[Index] := false;
    if (PrDC[Index] / 100) <= (Seg_b_CN[Index] / DeltaRefreshTact[Index]) then
      Seg_b_GLOW[Index] := true
    else
      Seg_b_GLOW[Index] := false;
    if (PrDC[Index] / 100) <= (Seg_c_CN[Index] / DeltaRefreshTact[Index]) then
      Seg_c_GLOW[Index] := true
    else
      Seg_c_GLOW[Index] := false;
    if (PrDC[Index] / 100) <= (Seg_d_CN[Index] / DeltaRefreshTact[Index]) then
      Seg_d_GLOW[Index] := true
    else
      Seg_d_GLOW[Index] := false;
    if (PrDC[Index] / 100) <= (Seg_e_CN[Index] / DeltaRefreshTact[Index]) then
      Seg_e_GLOW[Index] := true
    else
      Seg_e_GLOW[Index] := false;
    if (PrDC[Index] / 100) <= (Seg_f_CN[Index] / DeltaRefreshTact[Index]) then
      Seg_f_GLOW[Index] := true
    else
      Seg_f_GLOW[Index] := false;
    if (PrDC[Index] / 100) <= (Seg_g_CN[Index] / DeltaRefreshTact[Index]) then
      Seg_g_GLOW[Index] := true
    else
      Seg_g_GLOW[Index] := false;
    if (PrDC[Index] / 100) <= (Seg_DP_CN[Index] / DeltaRefreshTact[Index]) then
      Seg_DP_GLOW[Index] := true
    else
      Seg_DP_GLOW[Index] := false;
    Seg_a_CN[Index] := 0;
    Seg_b_CN[Index] := 0;
    Seg_c_CN[Index] := 0;
    Seg_d_CN[Index] := 0;
    Seg_e_CN[Index] := 0;
    Seg_f_CN[Index] := 0;
    Seg_g_CN[Index] := 0;
    Seg_DP_CN[Index] := 0;

  end;

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

Function Get_Device_class(hosthandle: THandle; MainDevice: TDevice)
  : TDevice; stdcall;
Var
  HDll: THandle;
begin
  UnitRes.SetLang();
  // Создаем экземпляр класса нашего устройства
  SetLength(TD, High(TD) + 2);
  SetLength(Bmp, High(Bmp) + 2);
  SetLength(Invert, High(Invert) + 2);
  SetLength(InvertEN, High(InvertEN) + 2);
  SetLength(EN, High(EN) + 2);
  SetLength(PrPeriod, High(PrPeriod) + 2);
  SetLength(PrDC, High(PrDC) + 2);

  SetLength(Seg_a_EN, High(Seg_a_EN) + 2);
  SetLength(Seg_b_EN, High(Seg_b_EN) + 2);
  SetLength(Seg_c_EN, High(Seg_c_EN) + 2);
  SetLength(Seg_d_EN, High(Seg_d_EN) + 2);
  SetLength(Seg_e_EN, High(Seg_e_EN) + 2);
  SetLength(Seg_f_EN, High(Seg_f_EN) + 2);
  SetLength(Seg_g_EN, High(Seg_g_EN) + 2);
  SetLength(Seg_DP_EN, High(Seg_DP_EN) + 2);
  SetLength(Seg_EN_EN, High(Seg_EN_EN) + 2);

  SetLength(Seg_a_CN, High(Seg_a_CN) + 2);
  SetLength(Seg_b_CN, High(Seg_b_CN) + 2);
  SetLength(Seg_c_CN, High(Seg_c_CN) + 2);
  SetLength(Seg_d_CN, High(Seg_d_CN) + 2);
  SetLength(Seg_e_CN, High(Seg_e_CN) + 2);
  SetLength(Seg_f_CN, High(Seg_f_CN) + 2);
  SetLength(Seg_g_CN, High(Seg_g_CN) + 2);
  SetLength(Seg_DP_CN, High(Seg_DP_CN) + 2);

  SetLength(Seg_a_GLOW, High(Seg_a_GLOW) + 2);
  SetLength(Seg_b_GLOW, High(Seg_b_GLOW) + 2);
  SetLength(Seg_c_GLOW, High(Seg_c_GLOW) + 2);
  SetLength(Seg_d_GLOW, High(Seg_d_GLOW) + 2);
  SetLength(Seg_e_GLOW, High(Seg_e_GLOW) + 2);
  SetLength(Seg_f_GLOW, High(Seg_f_GLOW) + 2);
  SetLength(Seg_g_GLOW, High(Seg_g_GLOW) + 2);
  SetLength(Seg_DP_GLOW, High(Seg_DP_GLOW) + 2);

  SetLength(Ii, High(Ii) + 2);
  SetLength(RefreshTact, High(RefreshTact) + 2);
  SetLength(DeltaRefreshTact, High(DeltaRefreshTact) + 2);
  // frmsettings.SetColor(High(TD),0);

  HDll := application.Handle;
  TD[High(TD)] := TDevice.Create(High(TD), cImgDeviceWidth, cImgDeviceHeigth,
    cDevType, cSDevType, cSDevFamily, cSDevModel, cNumberOfPorts, @BackProcDraw,
    nil, nil, nil, nil, nil, @BackShowSettings, @BackApplySaveData, @BackTact,
    HDll, hosthandle, MainDevice, nil);
  TD[High(TD)].addPort('Segment_a_In', 1, true, 0, @BackProcGetLevel);
  TD[High(TD)].addPort('Segment_b_In', 1, true, 0, @BackProcGetLevel);
  TD[High(TD)].addPort('Segment_c_In', 1, true, 0, @BackProcGetLevel);
  TD[High(TD)].addPort('Segment_d_In', 1, true, 0, @BackProcGetLevel);
  TD[High(TD)].addPort('Segment_e_In', 1, true, 0, @BackProcGetLevel);
  TD[High(TD)].addPort('Segment_f_In', 1, true, 0, @BackProcGetLevel);
  TD[High(TD)].addPort('Segment_g_In', 1, true, 0, @BackProcGetLevel);
  TD[High(TD)].addPort('Segment_DP_In', 1, true, 0, @BackProcGetLevel);
  TD[High(TD)].addPort('Segment_EN_In', 1, true, 0, @BackProcGetLevel);
  // Настройки применяем по-умолчанию:красный цвет, заг. при высоком уровне
  // Setlength(TD[High(TD)].SaveData,2);
  TD[High(TD)].LenSaveData := 5;
  TD[High(TD)].SaveData[0] := 'R';
  TD[High(TD)].SaveData[1] := 'H';
  TD[High(TD)].SaveData[2] := 'D';
  TD[High(TD)].SaveData[3] := AnsiChar(25);
  TD[High(TD)].SaveData[4] := AnsiChar(10);
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
