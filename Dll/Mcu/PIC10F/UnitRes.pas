unit UnitRes;

interface
uses Registry,windows;
const
rg_COMPANY='AT-Control'; //!!!ВНИМАНИЕ, не меняйте значение этой константы!!!
rg_APPNAME='ATCSS1'; //!!!ВНИМАНИЕ, не меняйте значение этой константы!!!
var
v_Root_Key_current_user:Boolean;
v_Key_Path:string;
v_Key_Name:string;
V_Def_Val_Bool:boolean;
V_Def_Val_int:integer;
var
  Lang: integer;
procedure SetLang();
function GetText(Id: integer): string;

implementation
Procedure Get_from_db(id:integer);

begin
case id of
0: //Язык !!!ВНИМАНИЕ, не изменяйте значение этого параметра ниже!!!
begin
    v_Root_Key_current_user:=true;
    v_Key_Path:='software\'+ rg_COMPANY+'\'+ rg_APPNAME;
    v_Key_Name:='Lang';
    V_Def_Val_int:=0;
    exit;
end;

end;
end;
//Boolean
procedure WriteBool(id:integer; value:boolean);
 var Registry: TRegistry;
 begin
    Registry := TRegistry.Create();
    Get_from_db(id);
   { устанавливаем корневой ключ; напрмер hkey_local_machine или hkey_current_user }
   if v_Root_Key_current_user then Registry.RootKey:=hkey_current_user  else Registry.RootKey:=hkey_local_machine;
   Registry.OpenKey(v_Key_Path,true);
   registry.WriteBool(v_Key_Name,value);
   { закрываем и освобождаем ключ }
   Registry.CloseKey;
   Registry.Free;
end;

Function ReadBool(id:integer):boolean;
 var Registry: TRegistry;
 begin
    Registry := TRegistry.Create();
    Get_from_db(id);
   { устанавливаем корневой ключ; напрмер hkey_local_machine или hkey_current_user }
   if v_Root_Key_current_user then Registry.RootKey:=hkey_current_user  else Registry.RootKey:=hkey_local_machine;
   Registry.OpenKey(v_Key_Path,true);
   if registry.ValueExists(v_Key_Name) then ReadBool:=registry.ReadBool( v_Key_Name)
   else
    begin
     registry.WriteBool(v_Key_Name,V_Def_Val_Bool);
     ReadBool:=V_Def_Val_Bool;
    end;
   { закрываем и освобождаем ключ }
   Registry.CloseKey;
   Registry.Free;
end;
//Integer
procedure WriteInt(id:integer; value:integer);
 var Registry: TRegistry;
 begin
    Registry := TRegistry.Create();
    Get_from_db(id);
   { устанавливаем корневой ключ; напрмер hkey_local_machine или hkey_current_user }
   if v_Root_Key_current_user then Registry.RootKey:=hkey_current_user  else Registry.RootKey:=hkey_local_machine;
   Registry.OpenKey(v_Key_Path,true);
   registry.WriteInteger(v_Key_Name,value);
   { закрываем и освобождаем ключ }
   Registry.CloseKey;
   Registry.Free;
end;

Function ReadInt(id:integer):integer;
 var Registry: TRegistry;
 begin
    Registry := TRegistry.Create();
    Get_from_db(id);
   { устанавливаем корневой ключ; напрмер hkey_local_machine или hkey_current_user }
   if v_Root_Key_current_user then Registry.RootKey:=hkey_current_user  else Registry.RootKey:=hkey_local_machine;
   Registry.OpenKey(v_Key_Path,true);
   if registry.ValueExists(v_Key_Name) then ReadInt:=registry.ReadInteger( v_Key_Name)
   else
    begin
     registry.WriteInteger(v_Key_Name,V_Def_Val_int);
     ReadInt:=V_Def_Val_int;
    end;
   { закрываем и освобождаем ключ }
   Registry.CloseKey;
   Registry.Free;
end;



procedure SetLang();
var
vLang:integer;
begin
vLang:=ReadInt(0);
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
            result := 'Microcontroller Microchip Baseline Family';
          1:
            result := 'Микроконтроллер Microchip семейства Baseline';
        end;
        exit;
      end;
//Основные кнопки
    1: //Ok
           begin
        case Lang of
          0:
            result := 'OK';
          1:
            result := 'OK';
        end;
        exit;
      end;
      2: //Cancel
           begin
        case Lang of
          0:
            result := 'Cancel';
          1:
            result := 'Отмена';
        end;
        exit;
      end;
          3: //Settings
           begin
        case Lang of
          0:
            result := 'Settings';
          1:
            result := 'Настройки';
        end;
        exit;
      end;
//Вкладки настроек
    10: //Config bits
           begin
        case Lang of
          0:
            result := 'Config Bits';
          1:
            result := 'Биты конфигурации';
        end;
        exit;
      end;
    11: //Other
           begin
        case Lang of
          0:
            result := 'Other';
          1:
            result := 'Разное';
        end;
        exit;
      end;
//Описание битов конфигурации
    20: //WDTE
           begin
        case Lang of
          0:
            result := 'Watchdog Timer Enable bit';
          1:
            result := 'Бит включения сторожевого таймера (Watchdog Timer)';
        end;
        exit;
      end;
    21: //\CP
           begin
        case Lang of
          0:
            result := 'Code Protection bit - User Program Memory';
          1:
            result := 'Бит защиты кода (пользовательской программы) от чтения';
        end;
        exit;
      end;
    22: //MCLRE
           begin
        case Lang of
          0:
            result := 'GP3/\MCLR Pin function Select bit';
          1:
            result := 'Бит выбора функции вывода GP3/\MCLR';
        end;
        exit;
      end;
    23: //IOSCFS
           begin
        case Lang of
          0:
            result := 'Internal Oscillator Frequency Select bit';
          1:
            result := 'Бит выбора тактовой частоты МК';
        end;
        exit;
      end;

     24: //\MCPU
           begin
        case Lang of
          0:
            result := 'Master Clear Pull-up Enable bit. MCLRE must be a "1" to enable this selection.';
          1:
            result := 'Бит отключения подтягивающих резисторов. Бит MCLRE должен быть установлен на "1" чтобы включить эту опцию';
        end;
        exit;
      end;
     25: //FOSC<1:0>
     begin
        case Lang of
          0:
            result := 'FOSC<1:0>: Oscillator Selection bits:' + char(10)+char(13) +
            '11 = EXTRC = external oscillator' + char(10)+char(13) +
            '10 = INTRC = internal oscillator ' + char(10)+char(13) +
            '01 = XT oscillator' + char(10)+char(13) +
            '00 = LP oscillator';
          1:
            result := 'FOSC<1:0>: Биты выбора источника тактового сигнала:' + char(10)+char(13) +
            '11 = EXTRC = Внешний контур резистор/конденсатор ' + char(10)+char(13) +
            '10 = INTRC = Внутренний генератор' + char(10)+char(13) +
            '01 = XT Внешний кварцевый резонатогр' + char(10)+char(13) +
            '00 = LP Внешний кварц с низким энергопотреблением';
        end;
        exit;
      end;
     26: //\CPDF
     begin
        case Lang of
          0:
            result := 'Code Protection bit - Flash Data Memory';
          1:
            result := 'Бит защиты кода (флеш - памяти) от чтения';
        end;
        exit;
      end;
      27: //FOSC<1:0> //Для PIC16FX
     begin
        case Lang of
          0:
            result := 'FOSC<1:0>: Oscillator Selection bits:' + char(10)+char(13) +
            '11 = RC oscillator' + char(10)+char(13) +
            '10 = HS oscillator ' + char(10)+char(13) +
            '01 = XT oscillator' + char(10)+char(13) +
            '00 = LP oscillator';
          1:
            result := 'FOSC<1:0>: Биты выбора источника тактового сигнала:' + char(10)+char(13) +
            '11 = RC Внешний контур резистор/конденсатор ' + char(10)+char(13) +
            '10 = HS Внешний высокоскоростной резонатор' + char(10)+char(13) +
            '01 = XT Внешний кварцевый резонатор' + char(10)+char(13) +
            '00 = LP Внешний кварц с низким энергопотреблением';
        end;
        exit;
      end;

//Описание значений битов конфигурации
     50:
           begin
        case Lang of
          0:
            result := '"0":Disabled';
          1:
            result := '"0":Откл';
        end;
        exit;
      end;
     51:
           begin
        case Lang of
          0:
            result := '"1":Disabled';
          1:
            result := '"1":Откл';
        end;
        exit;
      end;
     52:
           begin
        case Lang of
          0:
            result := '"0":Enabled';
          1:
            result := '"0":Вкл';
        end;
        exit;
      end;
     53:
           begin
        case Lang of
          0:
            result := '"1":Enabled';
          1:
            result := '"1":Вкл';
        end;
        exit;
      end;
     54:
           begin
        case Lang of
          0:
            result := '"0":GP3';
          1:
            result := '"0":GP3';
        end;
        exit;
      end;
     55:
           begin
        case Lang of
          0:
            result := '"1":\MCLR';
          1:
            result := '"1":\MCLR';
        end;
        exit;
      end;
     56:
           begin
        case Lang of
          0:
            result := '"0":4 MHz';
          1:
            result := '"0":4 МГц';
        end;
        exit;
      end;
     57:
           begin
        case Lang of
          0:
            result := '"1":8 MHz';
          1:
            result := '"1":8 МГц';
        end;
        exit;
      end;
      58:
           begin
        case Lang of
          0:
            result := '"0":Pull-up enabled';
          1:
            result := '"0":Подтяг. вкл';
        end;
        exit;
      end;
      59:
           begin
        case Lang of
          0:
            result := '"1":Pull-up disabled';
          1:
            result := '"1":Подтяг. откл';
        end;
        exit;
      end;
      60:
           begin
        case Lang of
          0:
            result := '"0"';
          1:
            result := '"0"';
        end;
        exit;
      end;
      61:
           begin
        case Lang of
          0:
            result := '"1"';
          1:
            result := '"1"';
        end;
        exit;
      end;

      //Диалоги (ошибки и т.д.)
      100:
           begin
        case Lang of
          0:
            result := 'Invalid crystal frequency value (valid in range 100-999999999 Hz)';
          1:
            result := 'Неверное значение частоты кварца (частота должна быть в диапазоне 100-999999999 Гц)';
        end;
        exit;
      end;
      //Другие неспецифичные от модели элементы
      200:
                 begin
        case Lang of
          0:
            result := 'Use different crystal frequency (not recomended)';
          1:
            result := 'Использовать нестандартную частоту кварца (не рекомендуется)';
        end;
        exit;
      end;
      201:
                 begin
        case Lang of
          0:
            result := 'Advanced Configuration of Clock Frequency';
          1:
            result := 'Расширенные настройки тактовой частоты';
        end;
        exit;
      end;
      202:
                 begin
        case Lang of
          0:
            result := 'Clock Frequency:';
          1:
            result := 'Тактовая частота составляет:';
        end;
        exit;
      end;
      203:
                 begin
        case Lang of
          0:
            result := 'Hz';
          1:
            result := 'Гц';
        end;
        exit;
      end;
      204:
                 begin
        case Lang of
          0:
            result := 'Value if the state of bit is unknown';
          1:
            result := 'Значение, если состояние бита не известно';
        end;
        exit;
      end;
            205:
                 begin
        case Lang of
          0:
            result := '0 - Bit is clear (Default) ';
          1:
            result := '0 - Бит очищен (по-умолчанию)';
        end;
        exit;
      end;
                 206:
                 begin
        case Lang of
          0:
            result := '1 - Bit is set';
          1:
            result := '1 - Бит установлен';
        end;
        exit;
      end;
          207:
                 begin
        case Lang of
          0:
            result := 'Random';
          1:
            result := 'Случайно';
        end;
        exit;
      end;
      208:
                 begin
        case Lang of
          0:
            result := 'External Crystal Frequency:';
          1:
            result := 'Частота внешнего кварца:';
        end;
        exit;
      end;
      209:
                 begin
        case Lang of
          0:
            result := 'The selected clock source: ';
          1:
            result := 'Выбранный источник тактового сигнала: ';
        end;
        exit;
      end;
      210:
                 begin
        case Lang of
          0:
            result := 'LP (Low-Power Crystal)';
          1:
            result := 'LP (экономичный кварц)';
        end;
        exit;
      end;
      211:
                 begin
        case Lang of
          0:
            result := 'XT (Crystal/Resonator)';
          1:
            result := 'XT (кварц/резонатор)';
        end;
        exit;
      end;
      212:
                 begin
        case Lang of
          0:
            result := 'INTRC (Internal 4 MHz Oscillator)';
          1:
            result := 'INTRC (внутренний генератор 4 МГц)';
        end;
        exit;
      end;
      213:
                 begin
        case Lang of
          0:
            result := 'INTRC (Internal 8 MHz Oscillator)';
          1:
            result := 'INTRC (внутренний генератор 8 МГц)';
        end;
        exit;
      end;
      214:
                 begin
        case Lang of
          0:
            result := 'EXTRC (External RC oscillator)';
          1:
            result := 'EXTRC (внешний RC генератор)';
        end;
        exit;
      end;
       215:
                 begin
        case Lang of
          0:
            result := 'EXTHS (External HS Resonator)';
          1:
            result := 'EXTRC (внешний HS резонатор)';
        end;
        exit;
      end;


  end;
End;

end.
