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
            result := 'Switch';
          1:
            result := 'Выключатель';
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
    4: // SPST
      begin
        case Lang of
          0:
            result := 'Single pole, single throw';
          1:
            result := 'Ключ';
        end;
        exit;
      end;
    5: // PTM
      begin
        case Lang of
          0:
            result := 'Push-to-make';
          1:
            result := 'Имппульсный';
        end;
        exit;
      end;
    6: // PTM
      begin
        case Lang of
          0:
            result := 'Push-to-break';
          1:
            result := 'Имппульсный на размыкание';
        end;
        exit;
      end;
    7: // HLSWP
      begin
        case Lang of
          0:
            result := 'High level signal when pressed';
          1:
            result := 'Высокий уровень сигнала, когда нажата';
        end;
        exit;
      end;
    // Colors
    10: // Red
      begin
        case Lang of
          0:
            result := 'Red';
          1:
            result := 'Красный';
        end;
        exit;
      end;
    11: // Green
      begin
        case Lang of
          0:
            result := 'Green';
          1:
            result := 'Зеленый';
        end;
        exit;
      end;
    12: // Blue
      begin
        case Lang of
          0:
            result := 'Blue';
          1:
            result := 'Синий';
        end;
        exit;
      end;
    13: // Yellow
      begin
        case Lang of
          0:
            result := 'Yellow';
          1:
            result := 'Желтый';
        end;
        exit;
      end;
    14: // White
      begin
        case Lang of
          0:
            result := 'Gray';
          1:
            result := 'Серый';
        end;
        exit;
      end;
    20: // gbColor
     begin
        case Lang of
          0:
            result := 'Color';
          1:
            result := 'Цвет';
        end;
        exit;
      end;
      21: // gbType
     begin
        case Lang of
          0:
            result := 'Type';
          1:
            result := 'Тип';
        end;
        exit;
      end;
        22: // gbEquivalentCircut
     begin
        case Lang of
          0:
            result := 'Equivalent Circut';
          1:
            result := 'Эквивалентная схема';
        end;
        exit;
      end;
        23: // gbPreview
     begin
        case Lang of
          0:
            result := 'Preview';
          1:
            result := 'Предпросмотр';
        end;
        exit;
      end;

  end;
End;

end.
