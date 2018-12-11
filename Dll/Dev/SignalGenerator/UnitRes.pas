unit UnitRes;

interface

uses Registry, windows;

const
  rg_COMPANY = 'AT-Control';
  // !!!ВНИМАНИЕ, не меняйте значение этой константы!!!
  rg_APPNAME = 'ATCSS1'; // !!!ВНИМАНИЕ, не меняйте значение этой константы!!!

var
  v_Root_Key_current_user: Boolean;
  v_Key_Path: string;
  v_Key_Name: string;
  V_Def_Val_Bool: Boolean;
  V_Def_Val_int: integer;

var
  Lang: integer;
procedure SetLang();
function GetText(Id: integer): string;

implementation

Procedure Get_from_db(Id: integer);

begin
  case Id of
    0: // Язык !!!ВНИМАНИЕ, не изменяйте значение этого параметра ниже!!!
      begin
        v_Root_Key_current_user := true;
        v_Key_Path := 'software\' + rg_COMPANY + '\' + rg_APPNAME;
        v_Key_Name := 'Lang';
        V_Def_Val_int := 0;
        exit;
      end;

  end;
end;

// Boolean
procedure WriteBool(Id: integer; value: Boolean);
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create();
  Get_from_db(Id);
  { устанавливаем корневой ключ; напрмер hkey_local_machine или hkey_current_user }
  if v_Root_Key_current_user then
    Registry.RootKey := hkey_current_user
  else
    Registry.RootKey := hkey_local_machine;
  Registry.OpenKey(v_Key_Path, true);
  Registry.WriteBool(v_Key_Name, value);
  { закрываем и освобождаем ключ }
  Registry.CloseKey;
  Registry.Free;
end;

Function ReadBool(Id: integer): Boolean;
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create();
  Get_from_db(Id);
  { устанавливаем корневой ключ; напрмер hkey_local_machine или hkey_current_user }
  if v_Root_Key_current_user then
    Registry.RootKey := hkey_current_user
  else
    Registry.RootKey := hkey_local_machine;
  Registry.OpenKey(v_Key_Path, true);
  if Registry.ValueExists(v_Key_Name) then
    ReadBool := Registry.ReadBool(v_Key_Name)
  else
  begin
    Registry.WriteBool(v_Key_Name, V_Def_Val_Bool);
    ReadBool := V_Def_Val_Bool;
  end;
  { закрываем и освобождаем ключ }
  Registry.CloseKey;
  Registry.Free;
end;

// Integer
procedure WriteInt(Id: integer; value: integer);
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create();
  Get_from_db(Id);
  { устанавливаем корневой ключ; напрмер hkey_local_machine или hkey_current_user }
  if v_Root_Key_current_user then
    Registry.RootKey := hkey_current_user
  else
    Registry.RootKey := hkey_local_machine;
  Registry.OpenKey(v_Key_Path, true);
  Registry.WriteInteger(v_Key_Name, value);
  { закрываем и освобождаем ключ }
  Registry.CloseKey;
  Registry.Free;
end;

Function ReadInt(Id: integer): integer;
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create();
  Get_from_db(Id);
  { устанавливаем корневой ключ; напрмер hkey_local_machine или hkey_current_user }
  if v_Root_Key_current_user then
    Registry.RootKey := hkey_current_user
  else
    Registry.RootKey := hkey_local_machine;
  Registry.OpenKey(v_Key_Path, true);
  if Registry.ValueExists(v_Key_Name) then
    ReadInt := Registry.ReadInteger(v_Key_Name)
  else
  begin
    Registry.WriteInteger(v_Key_Name, V_Def_Val_int);
    ReadInt := V_Def_Val_int;
  end;
  { закрываем и освобождаем ключ }
  Registry.CloseKey;
  Registry.Free;
end;

procedure SetLang();
var
  vLang: integer;
begin
  vLang := ReadInt(0);
  case vLang of
    0:
      Lang := 0; // English
    1:
      Lang := 1; // Russian
  else
    Lang := 0; // English for other
  end;
end;

function GetText(Id: integer): string;
Begin

  case Id of
    0: // title shown on the panel
      begin
        case Lang of
          0:
            result := 'Signal generator';
          1:
            result := 'Генератор сигналов';
        end;
        exit;
      end;
    1: // Ok
      begin
        case Lang of
          0:
            result := 'OK';
          1:
            result := 'OK';
        end;
        exit;
      end;
    2: // Cancel
      begin
        case Lang of
          0:
            result := 'Cancel';
          1:
            result := 'Отмена';
        end;
        exit;
      end;
    3: // Settings
      begin
        case Lang of
          0:
            result := 'Settings';
          1:
            result := 'Настройки';
        end;
        exit;
      end;
    4: // Frequency
      begin
        case Lang of
          0:
            result := 'Frequency';
          1:
            result := 'Частота';
        end;
        exit;
      end;
    5: // Hz
      begin
        case Lang of
          0:
            result := 'Hz';
          1:
            result := 'Гц';
        end;
        exit;
      end;
    6: // Duty cycle
      begin
        case Lang of
          0:
            result := 'Duty cycle';
          1:
            result := 'Коэфф. заполнения';
        end;
        exit;
      end;
    // Colors
    10: // Red
      begin
        case Lang of
          0:
            result := 'Sine';
          1:
            result := 'Синусоида';
        end;
        exit;
      end;
    11: // Green
      begin
        case Lang of
          0:
            result := 'Rectangular';
          1:
            result := 'Прямоугольный';
        end;
        exit;
      end;
    12: // Blue
      begin
        case Lang of
          0:
            result := 'Triangular';
          1:
            result := 'Треугольный';
        end;
        exit;
      end;
    13: // Yellow
      begin
        case Lang of
          0:
            result := 'Sawtooth';
          1:
            result := 'Пилообразный';
        end;
        exit;
      end;
    14: // White
      begin
        case Lang of
          0:
            result := 'Sawtooth (Negative ramp)';
          1:
            result := 'Пилообразный (Отрицательный спад)';
        end;
        exit;
      end;
    20: // gbColor
     begin
        case Lang of
          0:
            result := 'Waveform';
          1:
            result := 'Форма сигнала';
        end;
        exit;
      end;
      21: // gbOperatesignal
     begin
        case Lang of
          0:
            result := 'Signal characteristics';
          1:
            result := 'Параметры сигнала';
        end;
        exit;
      end;
        22: //gbEquivalentCircuit
     begin
        case Lang of
          0:
            result := 'Chart';
          1:
            result := 'График';
        end;
        exit;
      end;
        23: // chkAutoReset
     begin
        case Lang of
          0:
            result := 'Auto reset on start simulation';
          1:
            result := 'Автоматический сброс при старте симуляции';
        end;
        exit;
      end;

  end;
End;

end.
