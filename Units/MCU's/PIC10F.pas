unit PIC10F;

interface

uses
  Classes,sysutils,mmsystem;
procedure PCLpp();
procedure resetRAM(Id:Byte);
procedure SelectMC(Id:byte);
function GetInstruction():String;
function DimensionCPUCyclesPerSecond:int64;
Function BinToHex():string;
procedure ByteToBinInCD(X:Byte);
Function BinToDec():integer;
function ReadRAM(ByteNo:Integer; BitNo:Byte):boolean;

type
  TRun = class(TThread)
  private
    { Private declarations }

  protected
    procedure Execute; override;

  end;
type TMatrixRAM = record
  IDEaddres:Integer;
  SIMadress:Word; //Будет создаваться автоматически
  IDEName:String[16];
  IDEHexaddres:string[3];
  Used:boolean;
  SFR:boolean;
  VirtSFR:boolean;
  delta:boolean;
  greenDelta:boolean;
 // value: array[0..7] of boolean;
  deltabit: array[0..7] of boolean; //Что изменилось(бит)
  usedbit: array[0..7] of boolean;   //Какие биты используются
  bitname:array[0..7] of string[8];
  ToClearDelta:boolean;
  BreakPoint:boolean;
  GreenBP:boolean;

end;
type TSystemCommand = record
  CommandName:String[10];
end;
type TConfigBits = record
  Name:string;
  Description:string;
  No:integer;
  Value0:string;
  Value1:string;
end;
var
//Блок переменных, отвечающих за режим работы симулятора
rtMCId:byte; //Ид Микроконтроллера
rtRunning:boolean; //А вообще запущено ли?
rtStepByStep:boolean; //Шаг за шагом?
rtexStep:boolean; //разрешает сделать шаг
rtPause:boolean; //пауза
rtWithDelay:boolean; //С задержкой
rtDelayMS:integer; //Задержка
rtWithSyncro:boolean; //С синхронизацией к реальному времени
rtSyncro:real = 1; //Синхро коэф
rtRefreshComplete:boolean = false; //Для режима с задержкой и степ бай степ

rtSyncroTMP:int64; //Временный коэф для синхронизации (сбрасываеться каждую секунду)

rtCyclPerCycMK:int64; //Коэф, показывающий, сколько тактов CPU в одном такте МК
rtCrystalFreq:int64; //Сколько Гц в кварце МК

//Переменные, отвечающие за "систему команд"
SystemCommand:array of TSystemCommand;
SystemCommandCounter:integer;

//Основная переменная, обозначает "рабочую точку" программы
I:Integer;
//Переменная "реального положения дел на порту GPIO
realGPIO:array[0..7] of boolean;
//Переменная, ответственная за режим "сна";
SleepMode:boolean;
sleepRegGPIO:array[0..7] of boolean;  //Здесь будут храниться данные регистра GPIO до входа в режим сна
//Описание переменных, связанных с моделю МК
MatrixRAM:array of TMatrixRAM; //Основная матрица для в/д симулятора и IDE
AllRAMSize:Word; //Полный размер RAM - GPR,SFR, включая виртуальные
SFRCount:Word; //кол-во SFR, включая W и виртуальные
GPRCount:Word; //кол-во GPR
ROM_Size:Integer; //Полный размер ROM
//Описание ПЗУ
ROM:array of array[0..11] of boolean;
ROM_Str_No:array of integer;
ROM_Str_No_from:array of integer;
ROM_Str_No_to:array of integer;
ROM_BP:array of boolean;//Точки останова для ПЗУ
//Текущая комманда из ПЗУ
CurrentCommand:array[0..11] of boolean;
//Регистр W
regW:Word;
//Регистр TRIS
regTRISGPIO:Word;
// Регистр OPTION
regOPTION:Word;
//Регистр INDF
regINDF:Word;
//Регистр TMR0 Prescaler
regTMR0P:Word;
//Оперативная память, вклучая GFR и SFR
RAM:array of array of boolean;
//Бит конфигурации
Config:array[0..11] of boolean;
ConfigBits:array of TConfigBits;
ConfigBitsCounter:integer;
//Instruction Counter
IC:Int64;
//Machine cycles
MC:Int64;
//UserTimer
UserTimer:Extended;
//Stack
stMax:byte;
StC:byte;
St: array[0..1] of byte;
bSt:array[0..1,0..7] of boolean;
//WDT
rtTaktsWDT:Real; //Сколько такстов до сброса
TaktsWDT:Real; //Сколько сейчас прошло тактов
rtKWDT:byte;//Коэф деления WDT
//Timer0
rtKTMR0:byte;//Коэф деления  Timer0
rtTMR0:int64;//Инкременты таймера, без учета предделителя
//Адрес и данные в Ram, которые должны будут быть изменены
ChangeAddr:Word;
СhangeData:array[0..7] of boolean;
ChangeBitAddr:Word;
ChangeBitNo:Byte;
ChangeBitData:boolean;
ChangeDataNotInstruction:boolean; //Изменение не из инструкции т.е. не из BCF, MOVF и т.д., а из внутр. механизмов
//Параметр, в котором содержаться bin-данные для конвертирования в др СИ
par:array[0..8] of boolean;
//Параметр функции возврата комманды, в кот. содержится комманда, кот. нужно расшифровать
parCommand:array[0..11] of boolean;
//Параметр, в кот. будет содержаться ссылка на номер строки после GOTO
parGOTOaddr:integer;
//Временные (промежуточные переменные
tempPCL:array[0..7] of boolean;
implementation
uses main;


{
  Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure TRun.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end;

    or

    Synchronize(
      procedure
      begin
        Form1.Caption := 'Updated in thread via an anonymous method'
      end
      )
    );

  where an anonymous method is passed.

  Similarly, the developer can call the Queue method with similar parameters as
  above, instead passing another TThread class as the first parameter, putting
  the calling thread in a queue with the other thread.

}

{ TRun }
procedure ChangeRAMBit();  //Исп. переменные ChangeBitAddr, ChangeBitNo, ChangeBitData
var
temp:byte;
begin
//Проверка, а вообще используется ли этот байт
if MatrixRAM[ChangeBitAddr].Used  then  //Используется
  begin

  MatrixRAM[ChangeBitAddr].delta:=true;
   //Бэкап данных в матрице, чтобы можно было вычислить что именно изменилось
  //MatrixRAM[ChangeBitAddr].lastvalue[ChangeBitNo]:=RAM[ChangeAddr,ChangeBitNo];
  //Определение ред дельты

  if ChangeBitData<>RAM[ChangeBitAddr,ChangeBitNo] then
  begin  //Красная дельта
  MatrixRAM[ChangeBitAddr].greenDelta:=false;
  MatrixRAM[ChangeBitAddr].deltabit[ChangeBitNo]:=true;
    //Проверка на брейкпоинт красный
    if MatrixRAM[ChangeBitAddr].BreakPoint then
      begin
        PIC10F.rtPause:=true;
      end;

  end
  else
  begin //Зеленая дельта
  MatrixRAM[ChangeBitAddr].greenDelta:=true;
  MatrixRAM[ChangeBitAddr].deltabit[ChangeBitNo]:=true;
  //Проверка на брейкпоинт зеленый
    if MatrixRAM[ChangeBitAddr].BreakPoint and MatrixRAM[ChangeBitAddr].greenBP then
      begin
        PIC10F.rtPause:=true;
      end;
  end;
//Проверка, вдруг что-то специальное изменяется
  if ChangeBitAddr=6 then //Регстр GPIO
  begin
  //Чтение
  if RAM[regTRISGPIO,0] then //Если на вход
      RAM[ChangeBitAddr,0]:=RealGPIO[0];
  if RAM[regTRISGPIO,1] then //Если на вход
      RAM[ChangeBitAddr,1]:=RealGPIO[1];
  if RAM[regTRISGPIO,2] then //Если на вход
      RAM[ChangeBitAddr,2]:=RealGPIO[2];
  if RAM[regTRISGPIO,3] then //Если на вход
      RAM[ChangeBitAddr,3]:=RealGPIO[3];
  //Модификация
  RAM[ChangeBitAddr,ChangeBitNo]:=ChangeBitData;
  //Запись
  if not RAM[regTRISGPIO,ChangeBitNo]  then realGPIO[ChangeBitNo]:=ChangeBitData;
  exit;
  end;

  if ChangeBitAddr=0 then //Регстр INDF
  begin
  par[0]:=RAM[4,0];
  par[1]:=RAM[4,1];
  par[2]:=RAM[4,2];
  par[3]:=RAM[4,3];
  par[4]:=RAM[4,4];
  par[5]:=false;
  par[6]:=false;
  par[7]:=false;
  par[8]:=false;
  temp:=BinToDec();
  ChangeBitAddr:=temp;
  if temp<>0 then ChangeRAMBit();
  RAM[0,ChangeBitNo]:=RAM[ChangeBitAddr,ChangeBitNo];
  exit;
  end;

  if ChangeBitAddr=4 then //Регистр FSR
  Begin
  //Проверка, а не биты 5-7 ли хотят изменять?
  if ChangeBitNo>4 then exit; //Если да, то выход

  //Сама измена
  RAM[ChangeBitAddr,ChangeBitNo]:=ChangeBitData;
  //Изменим IndF
  par[0]:=RAM[4,0];
  par[1]:=RAM[4,1];
  par[2]:=RAM[4,2];
  par[3]:=RAM[4,3];
  par[4]:=RAM[4,4];
  par[5]:=false;
  par[6]:=false;
  par[7]:=false;
  par[8]:=false;
  temp:=BinToDec();
  RAM[0,0]:=RAM[temp,0];
  RAM[0,1]:=RAM[temp,1];
  RAM[0,2]:=RAM[temp,2];
  RAM[0,3]:=RAM[temp,3];
  RAM[0,4]:=RAM[temp,4];
  RAM[0,5]:=RAM[temp,5];
  RAM[0,6]:=RAM[temp,6];
  RAM[0,7]:=RAM[temp,7];
  exit;
  End;

  //Сама измена
  RAM[ChangeBitAddr,ChangeBitNo]:=ChangeBitData;
   //Проверка, из программы или внутр. механизмов все это вызвано
  if ChangeDataNotInstruction then
    begin
    //Из внутр. механизмов

    ChangeDataNotInstruction:=false;
    end
      else
    begin
    // Из польз. программы
    if ChangeBitAddr=1 then//TMR0
      begin
      par[0]:= RAM[ChangeBitAddr,0];
      par[1]:= RAM[ChangeBitAddr,1];
      par[2]:= RAM[ChangeBitAddr,2];
      par[3]:= RAM[ChangeBitAddr,3];
      par[4]:= RAM[ChangeBitAddr,4];
      par[5]:= RAM[ChangeBitAddr,5];
      par[6]:= RAM[ChangeBitAddr,6];
      par[7]:= RAM[ChangeBitAddr,7];
      par[8]:=false;
      rtTMR0:=BinToDec()*rtKTMR0;
      end;

    end;
  end
  else
  begin
  //Не используется бит
  end;


end;

procedure PCLpp();  //Увеличение на 1 счетчика PCL
label lExit;
begin
  // Закачка PCL во временную переменную
  tempPCL[0]:=RAM[2,0];
  tempPCL[1]:=RAM[2,1];
  tempPCL[2]:=RAM[2,2];
  tempPCL[3]:=RAM[2,3];
  tempPCL[4]:=RAM[2,4];
  tempPCL[5]:=RAM[2,5];
  tempPCL[6]:=RAM[2,6];
  tempPCL[7]:=RAM[2,7];

  if RAM[2,0]=false then
  begin
    RAM[2,0]:=true;
    goto lExit;
  end
  else
  begin
    RAM[2,0]:=false;
    if RAM[2,1]=false then
    begin
      RAM[2,1]:=true;
      goto lExit;
    end
    else
    begin
      RAM[2,1]:=false;
      if RAM[2,2]=false then
      begin
        RAM[2,2]:=true;
        goto lExit;
      end
      else
      begin
        RAM[2,2]:=false;
        if RAM[2,3]=false then
        begin
        RAM[2,3]:=true;
        goto lExit;
        end
        else
        begin
          RAM[2,3]:=false;
          if RAM[2,4]=false then
          begin
          RAM[2,4]:=true;
          goto lExit;
          end
          else
          begin
            RAM[2,4]:=false;
            if RAM[2,5]=false then
            begin
            RAM[2,5]:=true;
            goto lExit;
            end
            else
            begin
              RAM[2,5]:=false;
              if RAM[2,6]=false then
              begin
              RAM[2,6]:=true;
              goto lExit;
              end
              else
              begin
                RAM[2,6]:=false;
                if RAM[2,7]=false then
                begin
                RAM[2,7]:=true;
                goto lExit;
                end
                else
                begin

                RAM[2,7]:=false;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;

lExit:
//Вычисление дельты
MatrixRAM[2].delta:=true;
if tempPCL[0]<>RAM[2,0] then
  begin
    MatrixRAM[2].greenDelta:=false;
    MatrixRAM[2].deltabit[0]:=true;
  end;
if tempPCL[1]<>RAM[2,1] then
  begin
    MatrixRAM[2].greenDelta:=false;
    MatrixRAM[2].deltabit[1]:=true;
  end;
if tempPCL[2]<>RAM[2,2] then
  begin
    MatrixRAM[2].greenDelta:=false;
    MatrixRAM[2].deltabit[2]:=true;
  end;
if tempPCL[3]<>RAM[2,3] then
  begin
    MatrixRAM[2].greenDelta:=false;
    MatrixRAM[2].deltabit[3]:=true;
  end;
if tempPCL[4]<>RAM[2,4] then
  begin
    MatrixRAM[2].greenDelta:=false;
    MatrixRAM[2].deltabit[4]:=true;
  end;
if tempPCL[5]<>RAM[2,5] then
  begin
    MatrixRAM[2].greenDelta:=false;
    MatrixRAM[2].deltabit[5]:=true;
  end;
if tempPCL[6]<>RAM[2,6] then
  begin
    MatrixRAM[2].greenDelta:=false;
    MatrixRAM[2].deltabit[6]:=true;
  end;
if tempPCL[7]<>RAM[2,7] then
  begin
    MatrixRAM[2].greenDelta:=false;
    MatrixRAM[2].deltabit[7]:=true;
  end;
//Проверка на брекпоинт по дельте

if MatrixRAM[2].BreakPoint  then //Красный или зеленый брейк-поинт, не важно
  begin
   PIC10F.rtPause:=true;

  end;
end;

procedure ChangeRAMByte(); //Переменные ChangeAddr,ChangeData используются
var
temp:byte;
begin
//Проверка, а вообще используется ли этот байт
if MatrixRAM[ChangeAddr].Used  then  //Используется
  begin
  MatrixRAM[ChangeAddr].delta:=true;
  //Бэкап данных в матрице, чтобы можно было вычислить что именно изменилось
  {MatrixRAM[ChangeAddr].value[0]:=RAM[ChangeAddr,0];
  MatrixRAM[ChangeAddr].value[1]:=RAM[ChangeAddr,1];
  MatrixRAM[ChangeAddr].value[2]:=RAM[ChangeAddr,2];
  MatrixRAM[ChangeAddr].value[3]:=RAM[ChangeAddr,3];
  MatrixRAM[ChangeAddr].value[4]:=RAM[ChangeAddr,4];
  MatrixRAM[ChangeAddr].value[5]:=RAM[ChangeAddr,5];
  MatrixRAM[ChangeAddr].value[6]:=RAM[ChangeAddr,6];
  MatrixRAM[ChangeAddr].value[7]:=RAM[ChangeAddr,7]; }

  //Определение грин дельты  и изменившихся бит
  MatrixRAM[ChangeAddr].greenDelta:=true; //Для начала установим грин дельту, на всякий случай
  if СhangeData[0]<>RAM[ChangeAddr,0] then
    begin
    MatrixRAM[ChangeAddr].greenDelta:=false;
    MatrixRAM[ChangeAddr].deltabit[0]:=true;

    end;
  if СhangeData[1]<>RAM[ChangeAddr,1] then
    begin
    MatrixRAM[ChangeAddr].greenDelta:=false;
    MatrixRAM[ChangeAddr].deltabit[1]:=true;
    end;
  if СhangeData[2]<>RAM[ChangeAddr,2] then
    begin
    MatrixRAM[ChangeAddr].greenDelta:=false;
    MatrixRAM[ChangeAddr].deltabit[2]:=true;
    end;
  if СhangeData[3]<>RAM[ChangeAddr,3] then
    begin
    MatrixRAM[ChangeAddr].greenDelta:=false;
    MatrixRAM[ChangeAddr].deltabit[3]:=true;
    end;
  if СhangeData[4]<>RAM[ChangeAddr,4] then
    begin
    MatrixRAM[ChangeAddr].greenDelta:=false;
    MatrixRAM[ChangeAddr].deltabit[4]:=true;
    end;
  if СhangeData[5]<>RAM[ChangeAddr,5] then
    begin
    MatrixRAM[ChangeAddr].greenDelta:=false;
    MatrixRAM[ChangeAddr].deltabit[5]:=true;
    end;
  if СhangeData[6]<>RAM[ChangeAddr,6] then
    begin
    MatrixRAM[ChangeAddr].greenDelta:=false;
    MatrixRAM[ChangeAddr].deltabit[6]:=true;
    end;
  if СhangeData[7]<>RAM[ChangeAddr,7] then
    begin
    MatrixRAM[ChangeAddr].greenDelta:=false;
    MatrixRAM[ChangeAddr].deltabit[7]:=true;
    end;
  //Проверка на зеленый и красный  брейкпоинт
  if MatrixRAM[ChangeAddr].BreakPoint  then if MatrixRAM[ChangeAddr].GreenBP  then
    Begin //Зеленый брейк
    PIC10F.rtPause:=true;
    End
    else
    begin  //Красный брейк
    if not MatrixRAM[ChangeAddr].greenDelta then PIC10F.rtPause:=true;

    end;

//Проверка, вдруг что-то специальное изменяется
  if ChangeBitAddr=6 then //Регстр GPIO


//Доработать!!!!!!!!!!!!!!!
//!!!!!!!!!!!
//!!!!!!!!!!

  begin
  //Чтение
  {if RAM[regTRISGPIO,0] then //Если на вход
      RAM[ChangeBitAddr,0]:=RealGPIO[0];
  if RAM[regTRISGPIO,1] then //Если на вход
      RAM[ChangeBitAddr,1]:=RealGPIO[1];
  if RAM[regTRISGPIO,2] then //Если на вход
      RAM[ChangeBitAddr,2]:=RealGPIO[2];
  if RAM[regTRISGPIO,3] then //Если на вход
      RAM[ChangeBitAddr,3]:=RealGPIO[3];
  //Модификация
  RAM[ChangeBitAddr,ChangeBitNo]:=ChangeBitData;
  //Запись
  if not RAM[regTRISGPIO,ChangeBitNo]  then realGPIO[ChangeBitNo]:=ChangeBitData;
  exit;}
  end;

  if ChangeAddr=0 then //Регстр INDF
  begin
  par[0]:=RAM[4,0];
  par[1]:=RAM[4,1];
  par[2]:=RAM[4,2];
  par[3]:=RAM[4,3];
  par[4]:=RAM[4,4];
  par[5]:=false;
  par[6]:=false;
  par[7]:=false;
  par[8]:=false;
  temp:=BinToDec();
  ChangeAddr:=temp;
  if ChangeAddr<>0 then ChangeRAMByte();
  RAM[0,0]:=RAM[ChangeAddr,0];
  RAM[0,1]:=RAM[ChangeAddr,1];
  RAM[0,2]:=RAM[ChangeAddr,2];
  RAM[0,3]:=RAM[ChangeAddr,3];
  RAM[0,4]:=RAM[ChangeAddr,4];
  RAM[0,5]:=RAM[ChangeAddr,5];
  RAM[0,6]:=RAM[ChangeAddr,6];
  RAM[0,7]:=RAM[ChangeAddr,7];
  exit;
  end;

  if ChangeAddr=4 then //Регистр FSR
  Begin
  //Сама измена
  RAM[ChangeAddr,0]:=СhangeData[0];
  RAM[ChangeAddr,1]:=СhangeData[1];
  RAM[ChangeAddr,2]:=СhangeData[2];
  RAM[ChangeAddr,3]:=СhangeData[3];
  RAM[ChangeAddr,4]:=СhangeData[4];
{  RAM[ChangeAddr,5]:=СhangeData[5];
  RAM[ChangeAddr,6]:=СhangeData[6];
  RAM[ChangeAddr,7]:=СhangeData[7];}
  //Изменим IndF
  par[0]:=RAM[4,0];
  par[1]:=RAM[4,1];
  par[2]:=RAM[4,2];
  par[3]:=RAM[4,3];
  par[4]:=RAM[4,4];
  par[5]:=false;
  par[6]:=false;
  par[7]:=false;
  par[8]:=false;
  temp:=BinToDec();
  RAM[0,0]:=RAM[temp,0];
  RAM[0,1]:=RAM[temp,1];
  RAM[0,2]:=RAM[temp,2];
  RAM[0,3]:=RAM[temp,3];
  RAM[0,4]:=RAM[temp,4];
  RAM[0,5]:=RAM[temp,5];
  RAM[0,6]:=RAM[temp,6];
  RAM[0,7]:=RAM[temp,7];
  exit;
  End;

  //Сама измена
  RAM[ChangeAddr,0]:=СhangeData[0];
  RAM[ChangeAddr,1]:=СhangeData[1];
  RAM[ChangeAddr,2]:=СhangeData[2];
  RAM[ChangeAddr,3]:=СhangeData[3];
  RAM[ChangeAddr,4]:=СhangeData[4];
  RAM[ChangeAddr,5]:=СhangeData[5];
  RAM[ChangeAddr,6]:=СhangeData[6];
  RAM[ChangeAddr,7]:=СhangeData[7];

     //Проверка, из программы или внутр. механизмов все это вызвано
  if ChangeDataNotInstruction then
    begin
    //Из внутр. механизмов

    ChangeDataNotInstruction:=false;
    end
      else
    begin
    // Из польз. программы
    if ChangeAddr=1 then//TMR0
      begin
      par[0]:= RAM[ChangeAddr,0];
      par[1]:= RAM[ChangeAddr,1];
      par[2]:= RAM[ChangeAddr,2];
      par[3]:= RAM[ChangeAddr,3];
      par[4]:= RAM[ChangeAddr,4];
      par[5]:= RAM[ChangeAddr,5];
      par[6]:= RAM[ChangeAddr,6];
      par[7]:= RAM[ChangeAddr,7];
      par[8]:=false;
      rtTMR0:=BinToDec()*rtKTMR0;
      end;

    end;
  end
  else
  begin //Не используется  байт

  end;

end;

function ReadRAM(ByteNo:Integer; BitNo:Byte):boolean;
var
temp:byte;
begin
if ByteNo=0 then //INDF
  begin
  par[0]:=RAM[4,0];
  par[1]:=RAM[4,1];
  par[2]:=RAM[4,2];
  par[3]:=RAM[4,3];
  par[4]:=RAM[4,4];
  par[5]:=false;
  par[6]:=false;
  par[7]:=false;
  par[8]:=false;
  temp:=BinToDec();
  if temp<>0 then ReadRAM:=ReadRam(temp,BitNo) else ReadRAM:=false;
  exit;
  end;
if ByteNo=6 then //GPIO
  begin
  if RAM[regTRISGPIO,BitNo] then //На вход ли работает вывод?
    begin //Да
    //Считываем с реального порта
    ReadRam:=realGPIO[BitNo];
    exit;
    end;
  end;

ReadRAM:=RAM[ByteNo,BitNo];
end;

function readTSC:int64;
var ts:record
  case byte of
  1:(count:int64);
  2:(b,a:cardinal);
  end;
begin
  asm
    db $F;
    db $31;
    MOV [ts.a],edx;
    MOV [ts.b],eax;
  end;
  readTSC:=ts.count;
end;

function DimensionCPUCyclesPerSecond:int64;
var tmpA,tmpB,tmpC:array[0..9] of int64;
tmpD:int64;
J:byte;
begin
timebeginperiod(1); //Зададим высокую точность определения периода времени
sleep(10); //Работает почему-то после вызова слип
tmpD:=0;
for j := 0 to 9 do
  begin
   tmpA[J]:=readTSC;
   sleep(100);
   tmpB[J]:=readTSC;
   tmpC[J]:=tmpB[J]-tmpA[J];
   tmpC[J]:=tmpC[J]*10;
   tmpD:=tmpD+TMPC[J];
  end;
timeEndPeriod(1); //Восстановим точность
DimensionCPUCyclesPerSecond:=tmpD div 10;
end;


procedure CLRWDT(Sleep:boolean);
begin
//Сброс WDT
TaktsWDT:=0;
//Установим бит /TO
ChangeBitData:=true;
ChangeBitAddr:=3; //STATUS
ChangeBitNo:=4; // /TO
ChangeRAMBit;
if Sleep then
  begin //После SLEEP
    //Сбросим бит /PD
    ChangeBitData:=false;
    ChangeBitAddr:=3; //STATUS
    ChangeBitNo:=3; // /PD
    ChangeRAMBit;
  end
  else
  begin //После CLRWDT
    //Сбросим бит /PD
    ChangeBitData:=true;
    ChangeBitAddr:=3; //STATUS
    ChangeBitNo:=3; // /PD
    ChangeRAMBit;
  end;


end;


procedure TRun.Execute;
label 10,11,15,20, lINCFSZ1, lDECFSZ1,lINCF1,lDECF1;
var
// Временные переменные для различных ASM комманд, могут использоваться в любой, сперва обнулившись, если необходимо
tmpByte1,tmpByte2,tmpByte3:byte;
tmpAByte,tmpBByte:array[0..7] of boolean;
tmpW1,tmpW2:Word;
tmpWA:array [0..7] of byte;
tmpBit1,tmpBit2,tmpBit3:boolean;
First_End:boolean; //Сущность этой переменной в том, что если текущая команда - последняя, и выполняется в первый раз, то начать цикл заново (т.к. сперва в МК выполняется MOVLW 00h по адресу 255 для PIC10F200
Two_MC:boolean; //True, если выполненная инструкция исполняется за 2 м.ц.
tmpInt:integer;
begin
//! - не готова
//a - альфа, требует проверки (ни разу не проверялась)
//a! - ни разу не проверялась, требует особого контроля
//b - бета
//OK - готова

//Сброс счетчиков
First_End:=true;
Two_MC:=false;
I:=255;
IC:=0;
MC:=0;
UserTimer:=0;
//Сброс WDT
TaktsWDT:=0;
//Сброс Timer0
rtTMR0:=0;
//Отключение режима "сна"
SleepMode:=false;
//Для режима step-by-step
rtexStep:=true;
//Сброс стека
for tmpByte1 := 0 to stMax do St[tmpByte1]:=0;
StC:=0;
//Сброс процедур изменения данных
ChangeDataNotInstruction:=false;
//Задание счетчика синхронизации
rtSyncroTMP:=readTSC;
//Выполнение комманды


10:
//Код проверки BreakPoints по строке кода
if ROM_BP[I] then
  begin
  //Брякпойнт найден
   rtpause:=true;
  end;

11:
//а вообще запущено ли?
if not rtRunning then exit;

//Pause
if rtpause then
  begin
    sleep(10);
    //Задание счетчика синхронизации
    rtSyncroTMP:=readTSC;
    goto 11;
  end;
//В зависимости от режима
//Step-By-Step
if rtstepbystep then
  begin
    if not rtexStep then
      begin
        sleep(10);


        goto 11;
      end
      else
      if rtRefreshComplete then
      begin
      {if rtstepbystep then }rtRefreshComplete:=false;
      rtexStep:=false;
      end
      else goto 11;
  end;

//Delay
if rtWithDelay then
  begin
    sleep(rtDelayMS);
15:
    if not rtWithDelay then goto 11; //Все может измениться на ходу, чтобы не висело в процедуре

    sleep (1);
    if not rtRefreshComplete then goto 15 else rtRefreshComplete:=false;

  end;
//Синхронизация
if rtWithSyncro then
  begin
    if readTSC-pic10f.rtSyncroTMP<pic10f.rtCyclPerCycMK*pic10f.rtSyncro  then
      goto  11
      else
        begin
          pic10f.rtSyncroTMP:=trunc(pic10f.rtSyncroTMP+(pic10f.rtCyclPerCycMK/pic10f.rtSyncro)) ;

        end;

  end;
// WDT
if Config[2] then //WDT включен
begin
//Проверим, а подключен ли предделитель
if RAM[RegOption,3] then
begin //Предделитель подключен к WDT
//Вычисления коэффициента деления
rtKWDT:=1;
if RAM[RegOption,2] then rtKWDT:=rtKWDT*16;
if RAM[RegOption,1] then rtKWDT:=rtKWDT*4;
if RAM[RegOption,0] then rtKWDT:=rtKWDT*2;
//Прибавление WDT на 1 условный период (или 2, в зависимости от того за сколько м.ц. выполнялась инструкция)
if Two_MC then TaktsWDT:=TaktsWDT+(2/rtKWDT) else TaktsWDT:=TaktsWDT+(1/rtKWDT);
end
else
begin //Предделитель не подключен к WDT
//Прибавление WDT на 1 условный период (или 2, в зависимости от того за сколько м.ц. выполнялась инструкция)
if Two_MC then TaktsWDT:=TaktsWDT+2 else TaktsWDT:=TaktsWDT+1;
end;
//Проверка на переполнение WDT
if TaktsWDT>rtTaktsWDT then
begin //Произошло переполнение WDT
    //Сбросим бит /TO
    ChangeBitData:=false;
    ChangeBitAddr:=3; //STATUS
    ChangeBitNo:=4; // /TO
    ChangeRAMBit;
//Типа первый запуск - на самом деле после ресета
    First_End:=true;
    I:=255;
    SleepMode:=false;
    TaktsWDT:=0;
    goto 10;
end;
end;
//SleepMode
if SleepMode then
begin
  //Проверим, а включено ли "просыпание" по изменению на входах GP0,GP1,GP3? (Кстати, тут нет GP2)
  if RAM[regOption,7]=false then
  begin //Включено
    //Проверим, а не изменился ли кто-нибудь
    if (sleepRegGPIO[0]<>readRAM(6,0)) or (sleepRegGPIO[1]<>readRAM(6,1)) or (sleepRegGPIO[3]<>readRAM(6,3)) then
    begin //изменился
    //Установим бит GPWUF
    ChangeBitData:=true;
    ChangeBitAddr:=3; //STATUS
    ChangeBitNo:=7; //GPWUF
    ChangeRAMBit;
    SleepMode:=false;
    //Типа первый запуск - на самом деле после ресета
    First_End:=true;
    I:=255;
    goto 10;
    end;
  end;

goto 10;

end;
//Проверка, а не закончились ли комманды?
if I>(ROM_Size-1) then
begin
//А вдруг это первый запуск, и поэтому
if First_End then
begin
First_End:=false;
I:=0;
end
else
begin
//Здесь добавить код, который будет, если рабочая точка превысила кол-во ячеек ROM - однозначный выход, и...
I:=255; //Это, чтобы исключить ошибку показа следующей команды в главной форме
main.MainForm.StopSimulation; //Вернуть все кнопки в исходное положение
exit;
end;
end;

//Модуль таймера Timer0
//Добавить запись, что после записи из программы в TMR0 приращение запрещено 2 мц
//Проверим причину приращения таймера
if RAM[regOption,5]=false then
  //Приращение по тактовому сигналу
  begin
  //Инкремент счетчика таймера Timer0
  rtTMR0:=rtTMR0+1;
  //проверим, перед чем подключен предделитель
  if RAM[regOption,3]=false then
    //предделитель перед TMR0
    begin
    //Вычисления коэффициента деления
    rtKTMR0:=2;
    if RAM[RegOption,2] then rtKTMR0:=rtKTMR0*16;
    if RAM[RegOption,1] then rtKTMR0:=rtKTMR0*4;
    if RAM[RegOption,0] then rtKTMR0:=rtKTMR0*2;
    end;
  //Пишем значение в TMR0
  tmpInt:=rtTMR0 div  rtKTMR0;
  if tmpInt>255 then
    begin
      tmpInt:=0;
      rtTMR0:=0;
    end;
  ChangeAddr:=1;
  ByteToBinInCD(tmpInt);
  ChangeDataNotInstruction:=true; //Показывает процедуре, что из внутр. механизмов вызвано
  ChangeRamByte;


  end
  else
  //Приращение по внешнему сигналу
  begin

  end;



IC:=IC+1;
MC:=MC+1;
Two_MC:=false;


CurrentCommand[0]:=ROM[I,0];
CurrentCommand[1]:=ROM[I,1];
CurrentCommand[2]:=ROM[I,2];
CurrentCommand[3]:=ROM[I,3];
CurrentCommand[4]:=ROM[I,4];
CurrentCommand[5]:=ROM[I,5];
CurrentCommand[6]:=ROM[I,6];
CurrentCommand[7]:=ROM[I,7];
CurrentCommand[8]:=ROM[I,8];
CurrentCommand[9]:=ROM[I,9];
CurrentCommand[10]:=ROM[I,10];
CurrentCommand[11]:=ROM[I,11];
20: begin
//

  if CurrentCommand[11] then //1XXXXXXXXXXX
  begin
    if currentcommand[10]  then //11XXXXXXXXXX
    begin
      if currentcommand[9] then  //111XXXXXXXXX
      begin
        if currentcommand[8] then  //1111XXXXXXXX
        begin
//bXORLW

        ChangeBitData:=True; //Установка Z флага, на случай если рез-т операции будет равен 0
        // Далее идет операция XOR м-у константой и регистром W. Рез-т в W. Если Хоть один бит не равен 0, то сбрасывается флаг Z
        СhangeData[0]:=RAM[RegW,0] XOR currentcommand[0]; if СhangeData[0] then ChangeBitData:=false;
        СhangeData[1]:=RAM[RegW,1] XOR currentcommand[1]; if СhangeData[1] then ChangeBitData:=false;
        СhangeData[2]:=RAM[RegW,2] XOR currentcommand[2]; if СhangeData[2] then ChangeBitData:=false;
        СhangeData[3]:=RAM[RegW,3] XOR currentcommand[3]; if СhangeData[3] then ChangeBitData:=false;
        СhangeData[4]:=RAM[RegW,4] XOR currentcommand[4]; if СhangeData[4] then ChangeBitData:=false;
        СhangeData[5]:=RAM[RegW,5] XOR currentcommand[5]; if СhangeData[5] then ChangeBitData:=false;
        СhangeData[6]:=RAM[RegW,6] XOR currentcommand[6]; if СhangeData[6] then ChangeBitData:=false;
        СhangeData[7]:=RAM[RegW,7] XOR currentcommand[7]; if СhangeData[7] then ChangeBitData:=false;
        //Изменить RAM по адресу в соответствии с данными
        ChangeAddr:=RegW;
        ChangeRAMByte();
        //Изменить флаг Z в Status
        ChangeBitAddr:=3;
        ChangeBitNo:=2;
        ChangeRAMBit;
        //Прибавить счетчик комманд, и выполнить сл. комманду.
        I:=I+1;
        PCLpp();
        goto 10;
        end
        else //1110XXXXXXXX
        begin
//bANDLW
        ChangeBitData:=True; //Установка Z флага, на случай если рез-т операции будет равен 0
        // Далее идет операция AND м-у константой и регистром W. Рез-т в W. Если Хоть один бит не равен 0, то сбрасывается флаг Z
        СhangeData[0]:=RAM[RegW,0] AND currentcommand[0]; if СhangeData[0] then ChangeBitData:=false;
        СhangeData[1]:=RAM[RegW,1] AND currentcommand[1]; if СhangeData[1] then ChangeBitData:=false;
        СhangeData[2]:=RAM[RegW,2] AND currentcommand[2]; if СhangeData[2] then ChangeBitData:=false;
        СhangeData[3]:=RAM[RegW,3] AND currentcommand[3]; if СhangeData[3] then ChangeBitData:=false;
        СhangeData[4]:=RAM[RegW,4] AND currentcommand[4]; if СhangeData[4] then ChangeBitData:=false;
        СhangeData[5]:=RAM[RegW,5] AND currentcommand[5]; if СhangeData[5] then ChangeBitData:=false;
        СhangeData[6]:=RAM[RegW,6] AND currentcommand[6]; if СhangeData[6] then ChangeBitData:=false;
        СhangeData[7]:=RAM[RegW,7] AND currentcommand[7]; if СhangeData[7] then ChangeBitData:=false;
        //Изменить RAM по адресу в соответствии с данными
        ChangeAddr:=RegW;
        ChangeRAMByte();
        //Изменить флаг Z в Status
        ChangeBitAddr:=3;
        ChangeBitNo:=2;
        ChangeRAMBit;
        //Прибавить счетчик комманд, и выполнить сл. комманду.
        I:=I+1;
        PCLpp();
        goto 10;
        end;
      end
      else //110XXXXXXXXX
      begin
        if currentcommand[8] then //1101XXXXXXXX
        begin
//bIORLW
        ChangeBitData:=True; //Установка Z флага, на случай если рез-т операции будет равен 0
        // Далее идет операция OR м-у константой и регистром W. Рез-т в W. Если Хоть один бит не равен 0, то сбрасывается флаг Z
        СhangeData[0]:=RAM[RegW,0] OR currentcommand[0]; if СhangeData[0] then ChangeBitData:=false;
        СhangeData[1]:=RAM[RegW,1] OR currentcommand[1]; if СhangeData[1] then ChangeBitData:=false;
        СhangeData[2]:=RAM[RegW,2] OR currentcommand[2]; if СhangeData[2] then ChangeBitData:=false;
        СhangeData[3]:=RAM[RegW,3] OR currentcommand[3]; if СhangeData[3] then ChangeBitData:=false;
        СhangeData[4]:=RAM[RegW,4] OR currentcommand[4]; if СhangeData[4] then ChangeBitData:=false;
        СhangeData[5]:=RAM[RegW,5] OR currentcommand[5]; if СhangeData[5] then ChangeBitData:=false;
        СhangeData[6]:=RAM[RegW,6] OR currentcommand[6]; if СhangeData[6] then ChangeBitData:=false;
        СhangeData[7]:=RAM[RegW,7] OR currentcommand[7]; if СhangeData[7] then ChangeBitData:=false;
        //Изменить RAM по адресу в соответствии с данными
        ChangeAddr:=RegW;
        ChangeRAMByte();
        //Изменить флаг Z в Status
        ChangeBitAddr:=3;
        ChangeBitNo:=2;
        ChangeRAMBit;
        //Прибавить счетчик комманд, и выполнить сл. комманду.
        I:=I+1;
        PCLpp();
        goto 10;

        end
        else //1100XXXXXXXX
        begin
//bMOVLW
        СhangeData[0]:=currentcommand[0];
        СhangeData[1]:=currentcommand[1];
        СhangeData[2]:=currentcommand[2];
        СhangeData[3]:=currentcommand[3];
        СhangeData[4]:=currentcommand[4];
        СhangeData[5]:=currentcommand[5];
        СhangeData[6]:=currentcommand[6];
        СhangeData[7]:=currentcommand[7];
        //Изменить RAM по адресу в соответствии с данными
        ChangeAddr:=RegW;
        ChangeRAMByte();
        //Прибавить счетчик комманд, PCL и выполнить сл. комманду.
        I:=I+1;
        PCLpp();
        goto 10;
        end;

      end;
    end
    else //10XXXXXXXXXX
      if CurrentCommand[9] then //101XXXXXXXXX
      begin
//bGOTO
      //Задание позиции перехода по битам в константе
      I:=0;
      if CurrentCommand[0]=true then I:=I+1;
      if CurrentCommand[1]=true then I:=I+2;
      if CurrentCommand[2]=true then I:=I+4;
      if CurrentCommand[3]=true then I:=I+8;
      if CurrentCommand[4]=true then I:=I+16;
      if CurrentCommand[5]=true then I:=I+32;
      if CurrentCommand[6]=true then I:=I+64;
      if CurrentCommand[7]=true then I:=I+128;
      if CurrentCommand[8]=true then I:=I+256;
      //Тут  запись адреса в PCL
      СhangeData[0]:=currentcommand[0];
        СhangeData[1]:=currentcommand[1];
        СhangeData[2]:=currentcommand[2];
        СhangeData[3]:=currentcommand[3];
        СhangeData[4]:=currentcommand[4];
        СhangeData[5]:=currentcommand[5];
        СhangeData[6]:=currentcommand[6];
        СhangeData[7]:=currentcommand[7];
        //Изменить RAM по адресу в соответствии с данными
        ChangeAddr:=2;
        ChangeRAMByte();
      //т.к. Комманда выполняется за 2 м.ц., то прибавить 1 м.ц. к общему увиличению на 1
      pic10f.rtSyncroTMP:=trunc(pic10f.rtSyncroTMP+(pic10f.rtCyclPerCycMK / pic10f.rtSyncro));
      MC:=MC+1;
      Two_MC:=true;



      goto 10;

      end
      else //100XXXXXXXXX
      begin
        if CurrentCommand[8] then //1001XXXXXXXX
        begin
//bCALL
         //Задание позиции перехода по битам в константе
        if StC=2 then
        begin
//Вот сдесь можно встроить обработчик ошибок - переполнение стека, а так будет сл. код
        end;
        if StC=1 then
        begin
          StC:=StC+1;
        end;
        if StC=0 then
        begin
          StC:=StC+1;
        end;
         St[1]:=St[0];
          for tmpByte1:=0 to 7 do  bSt[1,tmpByte1]:=bSt[0,tmpByte1];
          PCLpp();
          bSt[0,0]:=RAM[2,0];
          bSt[0,1]:=RAM[2,1];
          bSt[0,2]:=RAM[2,2];
          bSt[0,3]:=RAM[2,3];
          bSt[0,4]:=RAM[2,4];
          bSt[0,5]:=RAM[2,5];
          bSt[0,6]:=RAM[2,6];
          bSt[0,7]:=RAM[2,7];
          St[0]:=I+1;
        I:=0;
        if CurrentCommand[0]=true then I:=I+1;
        if CurrentCommand[1]=true then I:=I+2;
        if CurrentCommand[2]=true then I:=I+4;
        if CurrentCommand[3]=true then I:=I+8;
        if CurrentCommand[4]=true then I:=I+16;
        if CurrentCommand[5]=true then I:=I+32;
        if CurrentCommand[6]=true then I:=I+64;
        if CurrentCommand[7]=true then I:=I+128;
        //Тут  запись адреса в PCL
        СhangeData[0]:=currentcommand[0];
        СhangeData[1]:=currentcommand[1];
        СhangeData[2]:=currentcommand[2];
        СhangeData[3]:=currentcommand[3];
        СhangeData[4]:=currentcommand[4];
        СhangeData[5]:=currentcommand[5];
        СhangeData[6]:=currentcommand[6];
        СhangeData[7]:=currentcommand[7];
        //Изменить RAM по адресу в соответствии с данными
        ChangeAddr:=2;
        ChangeRAMByte();
        //т.к. Комманда выполняется за 2 м.ц., то прибавить 1 м.ц. к общему увиличению на 1
        pic10f.rtSyncroTMP:=trunc(pic10f.rtSyncroTMP+(pic10f.rtCyclPerCycMK / pic10f.rtSyncro));
        MC:=MC+1;
        Two_MC:=true;
        goto 10

        end
        else
        begin   //1000XXXXXXXX
//bRETLW
        //Копирование константы в регистр W
        СhangeData[0]:=currentcommand[0];
        СhangeData[1]:=currentcommand[1];
        СhangeData[2]:=currentcommand[2];
        СhangeData[3]:=currentcommand[3];
        СhangeData[4]:=currentcommand[4];
        СhangeData[5]:=currentcommand[5];
        СhangeData[6]:=currentcommand[6];
        СhangeData[7]:=currentcommand[7];

        //Далее смотрим, на сколько занят стек, и переносим его содержимое в I
        if StC=0 then
        begin

        end;
        if StC=1  then
        begin
          StC:=0;

        end;
        if StC=2 then
        begin
          StC:=1;

        end;
        I:=St[0];
        СhangeData[0]:=bSt[0,0];
        СhangeData[1]:=bSt[0,1];
        СhangeData[2]:=bSt[0,2];
        СhangeData[3]:=bSt[0,3];
        СhangeData[4]:=bSt[0,4];
        СhangeData[5]:=bSt[0,5];
        СhangeData[6]:=bSt[0,6];
        СhangeData[7]:=bSt[0,7];
        //Изменить RAM по адресу в соответствии с данными
        ChangeAddr:=2;
        ChangeRAMByte();

          St[0]:=St[1];
          for tmpByte1 := 0 to 7 do bSt[0,tmpByte1]:=bSt[1,tmpByte1];

         //Изменить RAM по адресу в соответствии с данными
        ChangeAddr:=RegW;
        ChangeRAMByte();

        //т.к. Комманда выполняется за 2 м.ц., то прибавить 1 м.ц. к общему увиличению на 1
        pic10f.rtSyncroTMP:=trunc(pic10f.rtSyncroTMP+(pic10f.rtCyclPerCycMK / pic10f.rtSyncro));
        MC:=MC+1;
        Two_MC:=true;

        goto 10
        end;
      end;
  end
  else
  begin //0XXXXXXXXXXX
    if CurrentCommand[10] then
    begin //01XXXXXXXXXX
      if CurrentCommand[9] then
      begin //011XXXXXXXXX
        if CurrentCommand[8] then
        begin //0111XXXXXXXX
//bBTFSS  0111bbbfffff
        //Преобразование fffff в номер ячейки
        tmpByte1:=0;
        if currentcommand[0] then tmpByte1:=tmpByte1+1;
        if currentcommand[1] then tmpByte1:=tmpByte1+2;
        if currentcommand[2] then tmpByte1:=tmpByte1+4;
        if currentcommand[3] then tmpByte1:=tmpByte1+8;
        if currentcommand[4] then tmpByte1:=tmpByte1+16;
        //Преобразование bbb в номер бита
        tmpByte2:=0;
        if currentcommand[5] then tmpByte2:=tmpByte2+1;
        if currentcommand[6] then tmpByte2:=tmpByte2+2;
        if currentcommand[7] then tmpByte2:=tmpByte2+4;
//Х.З. - вот тут нужно встроить обработчик, а если будет обращение к неиспользуемым ячейкам или битам RAM
        if ReadRAM(tmpByte1,tmpByte2) then
          begin
          //Прибавить счетчик комманд, PCL и выполнить сл. комманду.
          I:=I+2;
          PCLpp();
          PCLpp();
          //т.к. Комманда выполняется за 2 м.ц., то прибавить 1 м.ц. к общему увиличению на 1
          pic10f.rtSyncroTMP:=trunc(pic10f.rtSyncroTMP+(pic10f.rtCyclPerCycMK / pic10f.rtSyncro));
          MC:=MC+1;
          Two_MC:=true;
          goto 10;
          end
          else
          begin
          I:=I+1;
          PCLpp();
          goto 10;
          end;


        end
        else
        begin //0110XXXXXXXX
//bBTFSC 0110bbbfffff
        //Преобразование fffff в номер ячейки
        tmpByte1:=0;
        if currentcommand[0] then tmpByte1:=tmpByte1+1;
        if currentcommand[1] then tmpByte1:=tmpByte1+2;
        if currentcommand[2] then tmpByte1:=tmpByte1+4;
        if currentcommand[3] then tmpByte1:=tmpByte1+8;
        if currentcommand[4] then tmpByte1:=tmpByte1+16;
        //Преобразование bbb в номер бита
        tmpByte2:=0;
        if currentcommand[5] then tmpByte2:=tmpByte2+1;
        if currentcommand[6] then tmpByte2:=tmpByte2+2;
        if currentcommand[7] then tmpByte2:=tmpByte2+4;
//Х.З. - вот тут нужно встроить обработчик, а если будет обращение к неиспользуемым ячейкам или битам RAM
        if ReadRAM(tmpByte1,tmpByte2) then
          begin
          //Прибавить счетчик комманд, PCL и выполнить сл. комманду.
          I:=I+1;
          PCLpp();
          goto 10;

          end
          else
          begin
          I:=I+2;
          PCLpp();
          PCLpp();
          //т.к. Комманда выполняется за 2 м.ц., то прибавить 1 м.ц. к общему увиличению на 1
          pic10f.rtSyncroTMP:=trunc(pic10f.rtSyncroTMP+(pic10f.rtCyclPerCycMK / pic10f.rtSyncro));
          MC:=MC+1;
          Two_MC:=true;
          goto 10;
          end;
        end;
      end
      else
      begin //010XXXXXXXXX
        if CurrentCommand[8] then
        begin //0101XXXXXXXX
//bBSF
        //Преобразование fffff в номер ячейки
        tmpByte1:=0;
        if currentcommand[0] then tmpByte1:=tmpByte1+1;
        if currentcommand[1] then tmpByte1:=tmpByte1+2;
        if currentcommand[2] then tmpByte1:=tmpByte1+4;
        if currentcommand[3] then tmpByte1:=tmpByte1+8;
        if currentcommand[4] then tmpByte1:=tmpByte1+16;
        //Преобразование bbb в номер бита
        tmpByte2:=0;
        if currentcommand[5] then tmpByte2:=tmpByte2+1;
        if currentcommand[6] then tmpByte2:=tmpByte2+2;
        if currentcommand[7] then tmpByte2:=tmpByte2+4;
//Х.З. - вот тут нужно встроить обработчик, а если будет обращение к неиспользуемым ячейкам или битам RAM
        //Основное действие комманды
        ChangeBitData:=true;
        //Изменить флаг
        ChangeBitAddr:=tmpByte1;
        ChangeBitNo:=tmpByte2;
        ChangeRAMBit;
        //Прибавить счетчик комманд, PCL и выполнить сл. комманду.
        I:=I+1;
        PCLpp();
        goto 10;
        end
        else
        begin  //0100XXXXXXXX
//bBCF
        //Преобразование fffff в номер ячейки
        tmpByte1:=0;
        if currentcommand[0] then tmpByte1:=tmpByte1+1;
        if currentcommand[1] then tmpByte1:=tmpByte1+2;
        if currentcommand[2] then tmpByte1:=tmpByte1+4;
        if currentcommand[3] then tmpByte1:=tmpByte1+8;
        if currentcommand[4] then tmpByte1:=tmpByte1+16;
        //Преобразование bbb в номер бита
        tmpByte2:=0;
        if currentcommand[5] then tmpByte2:=tmpByte2+1;
        if currentcommand[6] then tmpByte2:=tmpByte2+2;
        if currentcommand[7] then tmpByte2:=tmpByte2+4;
//Х.З. - вот тут нужно встроить обработчик, а если будет обращение к неиспользуемым ячейкам или битам RAM
        //Основное действие комманды
        ChangeBitData:=false;
        //Изменить флаг
        ChangeBitAddr:=tmpByte1;
        ChangeBitNo:=tmpByte2;
        ChangeRAMBit;
        //Прибавить счетчик комманд, PCL и выполнить сл. комманду.
        I:=I+1;
        PCLpp();
        goto 10;
        end;
      end;

    end
    else
    begin //00XXXXXXXXXX
      if CurrentCommand[9] then
      begin //001XXXXXXXXX
        if CurrentCommand[8] then
        begin //0011XXXXXXXX
          if CurrentCommand[7] then
          begin //00111XXXXXXX
            if CurrentCommand[6] then
            begin //001111XXXXXX
//bINCFSZ
            //Определимся с f
            //Преобразование fffff в номер ячейки
            tmpByte1:=0;
            if currentcommand[0] then tmpByte1:=tmpByte1+1;
            if currentcommand[1] then tmpByte1:=tmpByte1+2;
            if currentcommand[2] then tmpByte1:=tmpByte1+4;
            if currentcommand[3] then tmpByte1:=tmpByte1+8;
            if currentcommand[4] then tmpByte1:=tmpByte1+16;
            //Скопируем f во временный буффер
            tmpAByte[0]:=ReadRAM(tmpByte1,0);
            tmpAByte[1]:=ReadRAM(tmpByte1,1);
            tmpAByte[2]:=ReadRAM(tmpByte1,2);
            tmpAByte[3]:=ReadRAM(tmpByte1,3);
            tmpAByte[4]:=ReadRAM(tmpByte1,4);
            tmpAByte[5]:=ReadRAM(tmpByte1,5);
            tmpAByte[6]:=ReadRAM(tmpByte1,6);
            tmpAByte[7]:=ReadRAM(tmpByte1,7);
            //Инкрементируем временный буффер
                if tmpAByte[0]=false then
                begin
                tmpAByte[0]:=true;
                goto lINCFSZ1;
                end
                else
                begin
                tmpAByte[0]:=false;
                  if tmpAByte[1]=false then
                  begin
                  tmpAByte[1]:=true;
                  goto lINCFSZ1;
                  end
                  else
                  begin
                  tmpAByte[1]:=false;
                    if tmpAByte[2]=false then
                    begin
                    tmpAByte[2]:=true;
                    goto lINCFSZ1;
                    end
                    else
                    begin
                    tmpAByte[2]:=false;
                      if tmpAByte[3]=false then
                      begin
                      tmpAByte[3]:=true;
                      goto lINCFSZ1;
                      end
                      else
                      begin
                      tmpAByte[3]:=false;
                        if tmpAByte[4]=false then
                        begin
                        tmpAByte[4]:=true;
                        goto lINCFSZ1;
                        end
                        else
                        begin
                        tmpAByte[4]:=false;
                          if tmpAByte[5]=false then
                          begin
                          tmpAByte[5]:=true;
                          goto lINCFSZ1;
                          end
                          else
                          begin
                          tmpAByte[5]:=false;
                            if tmpAByte[6]=false then
                            begin
                            tmpAByte[6]:=true;
                            goto lINCFSZ1;
                            end
                            else
                            begin
                            tmpAByte[6]:=false;
                              if tmpAByte[7]=false then
                              begin
                              tmpAByte[7]:=true;
                              goto lINCFSZ1;
                              end
                              else
                              begin
                              tmpAByte[7]:=false;
                              //Вот тут уже получается так, что инкремент дошел опять до 0
                              //Соответственно, прибавляем все на 1 м.ц.(хотя надо 2 м.ц., но это уже после GOTO)
                              I:=I+1;
                                    //т.к. Комманда выполняется за 2 м.ц., то прибавить 1 м.ц. к общему увиличению на 1
                              pic10f.rtSyncroTMP:=trunc(pic10f.rtSyncroTMP+(pic10f.rtCyclPerCycMK / pic10f.rtSyncro));
                              MC:=MC+1;
                              Two_MC:=true;
                              PCLpp();
                              goto lINCFSZ1;
                              end;
                            end;
                          end;
                        end;
                      end;
                    end;
                  end;
                end;

            lINCFSZ1:
            //Копируем все в место назначения
            if currentcommand[5] then
            begin //Все пойдет в регистр f
            СhangeData[0]:=tmpAByte[0];
            СhangeData[1]:=tmpAByte[1];
            СhangeData[2]:=tmpAByte[2];
            СhangeData[3]:=tmpAByte[3];
            СhangeData[4]:=tmpAByte[4];
            СhangeData[5]:=tmpAByte[5];
            СhangeData[6]:=tmpAByte[6];
            СhangeData[7]:=tmpAByte[7];

            //Изменить RAM по адресу в соответствии с данными
            ChangeAddr:=tmpByte1;
            ChangeRAMByte();
            end
            else
            begin //Все пойдет в регистр W
             СhangeData[0]:=tmpAByte[0];
            СhangeData[1]:=tmpAByte[1];
            СhangeData[2]:=tmpAByte[2];
            СhangeData[3]:=tmpAByte[3];
            СhangeData[4]:=tmpAByte[4];
            СhangeData[5]:=tmpAByte[5];
            СhangeData[6]:=tmpAByte[6];
            СhangeData[7]:=tmpAByte[7];

            //Изменить RAM по адресу в соответствии с данными
            ChangeAddr:=RegW;
            ChangeRAMByte();
            end;
            // прибавляем (еще) все на 1 м.ц.
            I:=I+1;
            PCLpp();
            goto 10;

            end
            else
            begin //001110XXXXXX
//aSWAPF
             //Определимся с f
            //Преобразование fffff в номер ячейки
            tmpByte1:=0;
            if currentcommand[0] then tmpByte1:=tmpByte1+1;
            if currentcommand[1] then tmpByte1:=tmpByte1+2;
            if currentcommand[2] then tmpByte1:=tmpByte1+4;
            if currentcommand[3] then tmpByte1:=tmpByte1+8;
            if currentcommand[4] then tmpByte1:=tmpByte1+16;
            //Скопируем f во временный буффер
            tmpAByte[0]:=ReadRAM(tmpByte1,0);
            tmpAByte[1]:=ReadRAM(tmpByte1,1);
            tmpAByte[2]:=ReadRAM(tmpByte1,2);
            tmpAByte[3]:=ReadRAM(tmpByte1,3);
            tmpAByte[4]:=ReadRAM(tmpByte1,4);
            tmpAByte[5]:=ReadRAM(tmpByte1,5);
            tmpAByte[6]:=ReadRAM(tmpByte1,6);
            tmpAByte[7]:=ReadRAM(tmpByte1,7);
            //Собственно, сама суть процедуры (результат во временный буффер B)
            tmpBByte[0]:=tmpAByte[4];
            tmpBByte[1]:=tmpAByte[5];
            tmpBByte[2]:=tmpAByte[6];
            tmpBByte[3]:=tmpAByte[7];
            tmpBByte[4]:=tmpAByte[0];
            tmpBByte[5]:=tmpAByte[1];
            tmpBByte[6]:=tmpAByte[2];
            tmpBByte[7]:=tmpAByte[3];

            //Копируем все в место назначения
            if currentcommand[5] then
            begin //Все пойдет в регистр f
             СhangeData[0]:=tmpBByte[0];
            СhangeData[1]:=tmpBByte[1];
            СhangeData[2]:=tmpBByte[2];
            СhangeData[3]:=tmpBByte[3];
            СhangeData[4]:=tmpBByte[4];
            СhangeData[5]:=tmpBByte[5];
            СhangeData[6]:=tmpBByte[6];
            СhangeData[7]:=tmpBByte[7];

            //Изменить RAM по адресу в соответствии с данными
            ChangeAddr:=tmpByte1;
            ChangeRAMByte();
            end
            else
            begin //Все пойдет в регистр W
            СhangeData[0]:=tmpBByte[0];
            СhangeData[1]:=tmpBByte[1];
            СhangeData[2]:=tmpBByte[2];
            СhangeData[3]:=tmpBByte[3];
            СhangeData[4]:=tmpBByte[4];
            СhangeData[5]:=tmpBByte[5];
            СhangeData[6]:=tmpBByte[6];
            СhangeData[7]:=tmpBByte[7];

            //Изменить RAM по адресу в соответствии с данными
            ChangeAddr:=RegW;
            ChangeRAMByte();
            end;
            // прибавляем  все на 1 м.ц.
            I:=I+1;
            PCLpp();
            goto 10;

            end;

          end
          else
          begin //00110XXXXXXX
            if currentcommand[6] then
            begin //001101XXXXXX
//aRLF
            //Определимся с f
            //Преобразование fffff в номер ячейки
            tmpByte1:=0;
            if currentcommand[0] then tmpByte1:=tmpByte1+1;
            if currentcommand[1] then tmpByte1:=tmpByte1+2;
            if currentcommand[2] then tmpByte1:=tmpByte1+4;
            if currentcommand[3] then tmpByte1:=tmpByte1+8;
            if currentcommand[4] then tmpByte1:=tmpByte1+16;
            //Скопируем f во временный буффер
            tmpAByte[0]:=ReadRAM(tmpByte1,0);
            tmpAByte[1]:=ReadRAM(tmpByte1,1);
            tmpAByte[2]:=ReadRAM(tmpByte1,2);
            tmpAByte[3]:=ReadRAM(tmpByte1,3);
            tmpAByte[4]:=ReadRAM(tmpByte1,4);
            tmpAByte[5]:=ReadRAM(tmpByte1,5);
            tmpAByte[6]:=ReadRAM(tmpByte1,6);
            tmpAByte[7]:=ReadRAM(tmpByte1,7);
            //Собственно, сама суть процедуры (результат во временный буффер B и конечно же в STATUS,0 - флаг C)
            tmpBByte[0]:=RAM[3,0];
            tmpBByte[1]:=tmpAByte[0];
            tmpBByte[2]:=tmpAByte[1];
            tmpBByte[3]:=tmpAByte[2];
            tmpBByte[4]:=tmpAByte[3];
            tmpBByte[5]:=tmpAByte[4];
            tmpBByte[6]:=tmpAByte[5];
            tmpBByte[7]:=tmpAByte[6];
            ChangeBitData:=tmpAByte[7];
            //Копируем все в место назначения
            if currentcommand[5] then
            begin //Все пойдет в регистр f

            СhangeData[0]:=tmpBByte[0];
            СhangeData[1]:=tmpBByte[1];
            СhangeData[2]:=tmpBByte[2];
            СhangeData[3]:=tmpBByte[3];
            СhangeData[4]:=tmpBByte[4];
            СhangeData[5]:=tmpBByte[5];
            СhangeData[6]:=tmpBByte[6];
            СhangeData[7]:=tmpBByte[7];

            //Изменить RAM по адресу в соответствии с данными
            ChangeAddr:=tmpByte1;
            ChangeRAMByte();
            end
            else
            begin //Все пойдет в регистр W
            СhangeData[0]:=tmpBByte[0];
            СhangeData[1]:=tmpBByte[1];
            СhangeData[2]:=tmpBByte[2];
            СhangeData[3]:=tmpBByte[3];
            СhangeData[4]:=tmpBByte[4];
            СhangeData[5]:=tmpBByte[5];
            СhangeData[6]:=tmpBByte[6];
            СhangeData[7]:=tmpBByte[7];

            //Изменить RAM по адресу в соответствии с данными
            ChangeAddr:=RegW;
            ChangeRAMByte();
            end;
            //Изменить флаг C в Status
            ChangeBitAddr:=3;
            ChangeBitNo:=0;
            ChangeRAMBit;
            // прибавляем  все на 1 м.ц.
            I:=I+1;
            PCLpp();
            goto 10;
            end
            else
            begin  //001100XXXXXX
//aRRF
            //Определимся с f
            //Преобразование fffff в номер ячейки
            tmpByte1:=0;
            if currentcommand[0] then tmpByte1:=tmpByte1+1;
            if currentcommand[1] then tmpByte1:=tmpByte1+2;
            if currentcommand[2] then tmpByte1:=tmpByte1+4;
            if currentcommand[3] then tmpByte1:=tmpByte1+8;
            if currentcommand[4] then tmpByte1:=tmpByte1+16;
            //Скопируем f во временный буффер
             tmpAByte[0]:=ReadRAM(tmpByte1,0);
            tmpAByte[1]:=ReadRAM(tmpByte1,1);
            tmpAByte[2]:=ReadRAM(tmpByte1,2);
            tmpAByte[3]:=ReadRAM(tmpByte1,3);
            tmpAByte[4]:=ReadRAM(tmpByte1,4);
            tmpAByte[5]:=ReadRAM(tmpByte1,5);
            tmpAByte[6]:=ReadRAM(tmpByte1,6);
            tmpAByte[7]:=ReadRAM(tmpByte1,7);
            //Собственно, сама суть процедуры (результат во временный буффер B и конечно же в STATUS,0 - флаг C)
            tmpBByte[7]:=RAM[3,0];
            tmpBByte[6]:=tmpAByte[7];
            tmpBByte[5]:=tmpAByte[6];
            tmpBByte[4]:=tmpAByte[5];
            tmpBByte[3]:=tmpAByte[4];
            tmpBByte[2]:=tmpAByte[3];
            tmpBByte[1]:=tmpAByte[2];
            tmpBByte[0]:=tmpAByte[1];
            ChangeBitData:=tmpAByte[0];
            //Копируем все в место назначения
            if currentcommand[5] then
            begin //Все пойдет в регистр f
            СhangeData[0]:=tmpBByte[0];
            СhangeData[1]:=tmpBByte[1];
            СhangeData[2]:=tmpBByte[2];
            СhangeData[3]:=tmpBByte[3];
            СhangeData[4]:=tmpBByte[4];
            СhangeData[5]:=tmpBByte[5];
            СhangeData[6]:=tmpBByte[6];
            СhangeData[7]:=tmpBByte[7];

            //Изменить RAM по адресу в соответствии с данными
            ChangeAddr:=tmpByte1;
            ChangeRAMByte();;
            end
            else
            begin //Все пойдет в регистр W
            СhangeData[0]:=tmpBByte[0];
            СhangeData[1]:=tmpBByte[1];
            СhangeData[2]:=tmpBByte[2];
            СhangeData[3]:=tmpBByte[3];
            СhangeData[4]:=tmpBByte[4];
            СhangeData[5]:=tmpBByte[5];
            СhangeData[6]:=tmpBByte[6];
            СhangeData[7]:=tmpBByte[7];

            //Изменить RAM по адресу в соответствии с данными
            ChangeAddr:=regw;
            ChangeRAMByte();
            end;
            //Изменить флаг C в Status
            ChangeBitAddr:=3;
            ChangeBitNo:=0;
            ChangeRAMBit;
            // прибавляем  все на 1 м.ц.
            I:=I+1;
            PCLpp();
            goto 10;
            end;
          end;

        end
        else
        begin //0010XXXXXXXX
          if currentcommand[7] then
          begin //00101XXXXXXX
            if currentcommand[6] then
            begin //001011XXXXXX
//a!DECFSZ  - требует проверки алгоритма декрементации
             //Определимся с f
            //Преобразование fffff в номер ячейки
            tmpByte1:=0;
            if currentcommand[0] then tmpByte1:=tmpByte1+1;
            if currentcommand[1] then tmpByte1:=tmpByte1+2;
            if currentcommand[2] then tmpByte1:=tmpByte1+4;
            if currentcommand[3] then tmpByte1:=tmpByte1+8;
            if currentcommand[4] then tmpByte1:=tmpByte1+16;
            //Скопируем f во временный буффер
             tmpAByte[0]:=ReadRAM(tmpByte1,0);
            tmpAByte[1]:=ReadRAM(tmpByte1,1);
            tmpAByte[2]:=ReadRAM(tmpByte1,2);
            tmpAByte[3]:=ReadRAM(tmpByte1,3);
            tmpAByte[4]:=ReadRAM(tmpByte1,4);
            tmpAByte[5]:=ReadRAM(tmpByte1,5);
            tmpAByte[6]:=ReadRAM(tmpByte1,6);
            tmpAByte[7]:=ReadRAM(tmpByte1,7);

            //Декрементируем временный буффер
                if tmpAByte[0]=true then
                begin
                tmpAByte[0]:=false;
                goto lDECFSZ1;
                end
                else
                begin
                tmpAByte[0]:=true;

                  if tmpAByte[1]=true then
                  begin
                  tmpAByte[1]:=false;
                  goto lDECFSZ1;
                  end
                  else
                  begin
                  tmpAByte[1]:=true;

                    if tmpAByte[2]=true then
                    begin
                    tmpAByte[2]:=false;
                    goto lDECFSZ1;
                    end
                    else
                    begin
                    tmpAByte[2]:=true;

                      if tmpAByte[3]=true then
                      begin
                      tmpAByte[3]:=false;
                      goto lDECFSZ1;
                      end
                      else
                      begin
                      tmpAByte[3]:=true;

                        if tmpAByte[4]=true then
                        begin
                        tmpAByte[4]:=false;
                        goto lDECFSZ1;
                        end
                        else
                        begin
                        tmpAByte[4]:=true;

                          if tmpAByte[5]=true then
                          begin
                          tmpAByte[5]:=false;
                          goto lDECFSZ1;
                          end
                          else
                          begin
                          tmpAByte[5]:=true;

                            if tmpAByte[6]=true then
                            begin
                            tmpAByte[6]:=false;
                            goto lDECFSZ1;
                            end
                            else
                            begin
                            tmpAByte[6]:=true;

                              if tmpAByte[7]=true then
                              begin
                              tmpAByte[7]:=false;
                              goto lDECFSZ1;
                              end
                              else
                              begin
                              tmpAByte[7]:=true;

                              goto lDECFSZ1;
                              end;
                            end;
                          end;
                        end;
                      end;
                    end;
                  end;
                end;

            lDECFSZ1:

            //Копируем все в место назначения
            if currentcommand[5] then
            begin //Все пойдет в регистр f
             СhangeData[0]:=tmpAByte[0];
            СhangeData[1]:=tmpAByte[1];
            СhangeData[2]:=tmpAByte[2];
            СhangeData[3]:=tmpAByte[3];
            СhangeData[4]:=tmpAByte[4];
            СhangeData[5]:=tmpAByte[5];
            СhangeData[6]:=tmpAByte[6];
            СhangeData[7]:=tmpAByte[7];

            //Изменить RAM по адресу в соответствии с данными
            ChangeAddr:=tmpByte1;
            ChangeRAMByte();;
            end
            else
            begin //Все пойдет в регистр W
             СhangeData[0]:=tmpAByte[0];
            СhangeData[1]:=tmpAByte[1];
            СhangeData[2]:=tmpAByte[2];
            СhangeData[3]:=tmpAByte[3];
            СhangeData[4]:=tmpAByte[4];
            СhangeData[5]:=tmpAByte[5];
            СhangeData[6]:=tmpAByte[6];
            СhangeData[7]:=tmpAByte[7];

            //Изменить RAM по адресу в соответствии с данными
            ChangeAddr:=regW;
            ChangeRAMByte();
            end;
            //Проверяем, а не равен ли случайно результат нулю?
            if   not СhangeData[0] and not СhangeData[1] and not СhangeData[2] and not СhangeData[3] and not СhangeData[4] and not СhangeData[5] and not СhangeData[6] and not СhangeData[7] then
            begin
            //Вот тут уже получается так, что декремент дошел опять до 0
                              //Соответственно, прибавляем все на 1 м.ц.(хотя надо 2 м.ц., но это уже после GOTO)
                              I:=I+1;
                            //т.к. Комманда выполняется за 2 м.ц., то прибавить 1 м.ц. к общему увиличению на 1
                             pic10f.rtSyncroTMP:=trunc(pic10f.rtSyncroTMP+(pic10f.rtCyclPerCycMK / pic10f.rtSyncro));
                              MC:=MC+1;
                               Two_MC:=true;
                              PCLpp();
            end;
            // прибавляем (еще) все на 1 м.ц.
            I:=I+1;
            PCLpp();
            goto 10;
            end
            else
            begin //001010XXXXXX
//a!INCF   - обязательно проверить установку флага Z
            //Определимся с f
            //Преобразование fffff в номер ячейки
            tmpByte1:=0;
            if currentcommand[0] then tmpByte1:=tmpByte1+1;
            if currentcommand[1] then tmpByte1:=tmpByte1+2;
            if currentcommand[2] then tmpByte1:=tmpByte1+4;
            if currentcommand[3] then tmpByte1:=tmpByte1+8;
            if currentcommand[4] then tmpByte1:=tmpByte1+16;
            //Скопируем f во временный буффер
             tmpAByte[0]:=ReadRAM(tmpByte1,0);
            tmpAByte[1]:=ReadRAM(tmpByte1,1);
            tmpAByte[2]:=ReadRAM(tmpByte1,2);
            tmpAByte[3]:=ReadRAM(tmpByte1,3);
            tmpAByte[4]:=ReadRAM(tmpByte1,4);
            tmpAByte[5]:=ReadRAM(tmpByte1,5);
            tmpAByte[6]:=ReadRAM(tmpByte1,6);
            tmpAByte[7]:=ReadRAM(tmpByte1,7);
            ChangeBitData:=false; //Снятие Z флага, на случай если рез-т операции не будет равен 0
            //Инкрементируем временный буффер
                if tmpAByte[0]=false then
                begin
                tmpAByte[0]:=true;
                goto lINCF1;
                end
                else
                begin
                tmpAByte[0]:=false;
                  if tmpAByte[1]=false then
                  begin
                  tmpAByte[1]:=true;
                  goto lINCF1;
                  end
                  else
                  begin
                  tmpAByte[1]:=false;
                    if tmpAByte[2]=false then
                    begin
                    tmpAByte[2]:=true;
                    goto lINCF1;
                    end
                    else
                    begin
                    tmpAByte[2]:=false;
                      if tmpAByte[3]=false then
                      begin
                      tmpAByte[3]:=true;
                      goto lINCF1;
                      end
                      else
                      begin
                      tmpAByte[3]:=false;
                        if tmpAByte[4]=false then
                        begin
                        tmpAByte[4]:=true;
                        goto lINCF1;
                        end
                        else
                        begin
                        tmpAByte[4]:=false;
                          if tmpAByte[5]=false then
                          begin
                          tmpAByte[5]:=true;
                          goto lINCF1;
                          end
                          else
                          begin
                          tmpAByte[5]:=false;
                            if tmpAByte[6]=false then
                            begin
                            tmpAByte[6]:=true;
                            goto lINCF1;
                            end
                            else
                            begin
                            tmpAByte[6]:=false;
                              if tmpAByte[7]=false then
                              begin
                              tmpAByte[7]:=true;
                              goto lINCF1;
                              end
                              else
                              begin
                              tmpAByte[7]:=false;
                              //Вот тут уже получается так, что инкремент дошел опять до 0
                              //Устанавливаем флаг Z
                              ChangeBitData:=true;
                              goto lINCF1;
                              end;
                            end;
                          end;
                        end;
                      end;
                    end;
                  end;
                end;

            lINCF1:
            //Копируем все в место назначения
            if currentcommand[5] then
            begin //Все пойдет в регистр f
             СhangeData[0]:=tmpAByte[0];
            СhangeData[1]:=tmpAByte[1];
            СhangeData[2]:=tmpAByte[2];
            СhangeData[3]:=tmpAByte[3];
            СhangeData[4]:=tmpAByte[4];
            СhangeData[5]:=tmpAByte[5];
            СhangeData[6]:=tmpAByte[6];
            СhangeData[7]:=tmpAByte[7];

            //Изменить RAM по адресу в соответствии с данными
            ChangeAddr:=tmpByte1;
            ChangeRAMByte();;
            end
            else
            begin //Все пойдет в регистр W
            СhangeData[0]:=tmpAByte[0];
            СhangeData[1]:=tmpAByte[1];
            СhangeData[2]:=tmpAByte[2];
            СhangeData[3]:=tmpAByte[3];
            СhangeData[4]:=tmpAByte[4];
            СhangeData[5]:=tmpAByte[5];
            СhangeData[6]:=tmpAByte[6];
            СhangeData[7]:=tmpAByte[7];

            //Изменить RAM по адресу в соответствии с данными
            ChangeAddr:=regW;
            ChangeRAMByte();
            end;
              //Изменить флаг Z в Status
            ChangeBitAddr:=3;
            ChangeBitNo:=2;
            ChangeRAMBit;
            // Cледующая инструкция - по порядку следующая
            I:=I+1;
            PCLpp();
            goto 10;
            end
          end
          else
          begin //00100XXXXXXX
            if currentcommand[6] then
            begin //001001XXXXXX
//aCOMF
            //Определимся с f
            //Преобразование fffff в номер ячейки
            tmpByte1:=0;
            if currentcommand[0] then tmpByte1:=tmpByte1+1;
            if currentcommand[1] then tmpByte1:=tmpByte1+2;
            if currentcommand[2] then tmpByte1:=tmpByte1+4;
            if currentcommand[3] then tmpByte1:=tmpByte1+8;
            if currentcommand[4] then tmpByte1:=tmpByte1+16;
            //Скопируем f во временный буффер
             tmpAByte[0]:=ReadRAM(tmpByte1,0);
            tmpAByte[1]:=ReadRAM(tmpByte1,1);
            tmpAByte[2]:=ReadRAM(tmpByte1,2);
            tmpAByte[3]:=ReadRAM(tmpByte1,3);
            tmpAByte[4]:=ReadRAM(tmpByte1,4);
            tmpAByte[5]:=ReadRAM(tmpByte1,5);
            tmpAByte[6]:=ReadRAM(tmpByte1,6);
            tmpAByte[7]:=ReadRAM(tmpByte1,7);
            ChangeBitData:=true; //Установка Z флага, на случай если рез-т операции будет равен 0
            //Собственно, сама операция
            if tmpAByte[0] then
              begin
              tmpBByte[0]:=false;
              end
              else
              begin
              tmpBByte[0]:=true;
              ChangeBitData:=false; //Снятие Z флага
              end;
            if tmpAByte[1] then
              begin
              tmpBByte[1]:=false;
              end
              else
              begin
              tmpBByte[1]:=true;
              ChangeBitData:=false; //Снятие Z флага
              end;
            if tmpAByte[2] then
              begin
              tmpBByte[2]:=false;
              end
              else
              begin
              tmpBByte[2]:=true;
              ChangeBitData:=false; //Снятие Z флага
              end;
            if tmpAByte[3] then
              begin
              tmpBByte[3]:=false;
              end
              else
              begin
              tmpBByte[3]:=true;
              ChangeBitData:=false; //Снятие Z флага
              end;
            if tmpAByte[4] then
              begin
              tmpBByte[4]:=false;
              end
              else
              begin
              tmpBByte[4]:=true;
              ChangeBitData:=false; //Снятие Z флага
              end;
            if tmpAByte[5] then
              begin
              tmpBByte[5]:=false;
              end
              else
              begin
              tmpBByte[5]:=true;
              ChangeBitData:=false; //Снятие Z флага
              end;
            if tmpAByte[6] then
              begin
              tmpBByte[6]:=false;
              end
              else
              begin
              tmpBByte[6]:=true;
              ChangeBitData:=false; //Снятие Z флага
              end;
            if tmpAByte[7] then
              begin
              tmpBByte[7]:=false;
              end
              else
              begin
              tmpBByte[7]:=true;
              ChangeBitData:=false; //Снятие Z флага
              end;
            //Копируем все в место назначения
            if currentcommand[5] then
            begin //Все пойдет в регистр f
            //Все пойдет в регистр W
            СhangeData[0]:=tmpBByte[0];
            СhangeData[1]:=tmpBByte[1];
            СhangeData[2]:=tmpBByte[2];
            СhangeData[3]:=tmpBByte[3];
            СhangeData[4]:=tmpBByte[4];
            СhangeData[5]:=tmpBByte[5];
            СhangeData[6]:=tmpBByte[6];
            СhangeData[7]:=tmpBByte[7];

            //Изменить RAM по адресу в соответствии с данными
            ChangeAddr:=tmpbyte1;
            ChangeRAMByte();
            end
            else
            begin //Все пойдет в регистр W
            //Все пойдет в регистр W
            СhangeData[0]:=tmpBByte[0];
            СhangeData[1]:=tmpBByte[1];
            СhangeData[2]:=tmpBByte[2];
            СhangeData[3]:=tmpBByte[3];
            СhangeData[4]:=tmpBByte[4];
            СhangeData[5]:=tmpBByte[5];
            СhangeData[6]:=tmpBByte[6];
            СhangeData[7]:=tmpBByte[7];

            //Изменить RAM по адресу в соответствии с данными
            ChangeAddr:=regW;
            ChangeRAMByte();
            end;
            //Изменить флаг Z в Status
            ChangeBitAddr:=3;
            ChangeBitNo:=2;
            ChangeRAMBit;
            // прибавляем  все на 1 м.ц.
            I:=I+1;
            PCLpp();
            goto 10;

            end
            else
            begin //001000XXXXXX
//aMOVF
            //Определимся с f
            //Преобразование fffff в номер ячейки
            tmpByte1:=0;
            if currentcommand[0] then tmpByte1:=tmpByte1+1;
            if currentcommand[1] then tmpByte1:=tmpByte1+2;
            if currentcommand[2] then tmpByte1:=tmpByte1+4;
            if currentcommand[3] then tmpByte1:=tmpByte1+8;
            if currentcommand[4] then tmpByte1:=tmpByte1+16;
            //Скопируем f во временный буффер
             tmpAByte[0]:=ReadRAM(tmpByte1,0);
            tmpAByte[1]:=ReadRAM(tmpByte1,1);
            tmpAByte[2]:=ReadRAM(tmpByte1,2);
            tmpAByte[3]:=ReadRAM(tmpByte1,3);
            tmpAByte[4]:=ReadRAM(tmpByte1,4);
            tmpAByte[5]:=ReadRAM(tmpByte1,5);
            tmpAByte[6]:=ReadRAM(tmpByte1,6);
            tmpAByte[7]:=ReadRAM(tmpByte1,7);
            ChangeBitData:=true;; //Установка Z флага, на случай если рез-т операции будет равен 0
            //Проверка на флаг Z
            if tmpAByte[0]=true then ChangeBitData:=false;;
            if tmpAByte[1]=true then ChangeBitData:=false;;
            if tmpAByte[2]=true then ChangeBitData:=false;;
            if tmpAByte[3]=true then ChangeBitData:=false;;
            if tmpAByte[4]=true then ChangeBitData:=false;;
            if tmpAByte[5]=true then ChangeBitData:=false;;
            if tmpAByte[6]=true then ChangeBitData:=false;;
            if tmpAByte[7]=true then ChangeBitData:=false;;

            //Копируем все в место назначения
            if currentcommand[5] then
            begin //Все пойдет в регистр f
            СhangeData[0]:=tmpAByte[0];
            СhangeData[1]:=tmpAByte[1];
            СhangeData[2]:=tmpAByte[2];
            СhangeData[3]:=tmpAByte[3];
            СhangeData[4]:=tmpAByte[4];
            СhangeData[5]:=tmpAByte[5];
            СhangeData[6]:=tmpAByte[6];
            СhangeData[7]:=tmpAByte[7];

            //Изменить RAM по адресу в соответствии с данными
            ChangeAddr:=tmpbyte1;
            ChangeRAMByte();
            end
            else
            begin //Все пойдет в регистр W
            СhangeData[0]:=tmpAByte[0];
            СhangeData[1]:=tmpAByte[1];
            СhangeData[2]:=tmpAByte[2];
            СhangeData[3]:=tmpAByte[3];
            СhangeData[4]:=tmpAByte[4];
            СhangeData[5]:=tmpAByte[5];
            СhangeData[6]:=tmpAByte[6];
            СhangeData[7]:=tmpAByte[7];

            //Изменить RAM по адресу в соответствии с данными
            ChangeAddr:=regW;
            ChangeRAMByte();
            end;
            //Изменить флаг Z в Status
            ChangeBitAddr:=3;
            ChangeBitNo:=2;
            ChangeRAMBit;
            // прибавляем  все на 1 м.ц.
            I:=I+1;
            PCLpp();
            goto 10;

            end;
          end;
        end;

      end
      else
      begin //000XXXXXXXXX
        if currentcommand[8] then
        begin //0001XXXXXXXX
          if currentcommand[7] then
          begin  //00011XXXXXXX
            if currentcommand[6] then
            begin //000111XXXXXX
//aADDWF   - это есть сложение регистров W и f
             //Преобразование fffff в номер ячейки
            tmpByte1:=0;
            if currentcommand[0] then tmpByte1:=tmpByte1+1;
            if currentcommand[1] then tmpByte1:=tmpByte1+2;
            if currentcommand[2] then tmpByte1:=tmpByte1+4;
            if currentcommand[3] then tmpByte1:=tmpByte1+8;
            if currentcommand[4] then tmpByte1:=tmpByte1+16;
            //Сама процедура сложения
            tmpBit1:=true; //Установка Z флага, на случай если рез-т операции будет равен 0
            tmpByte2:=0;
            if RAM[RegW,0] then inc(tmpByte2);
            if readRAM(tmpByte1,0) then inc(tmpByte2);
            if tmpByte2=0 then
              begin
              tmpBByte[0]:=false;
              tmpAByte[0]:=false;
              end
              else
                if tmpByte2=1  then
                  begin
                    tmpBByte[0]:=true;
                    tmpAByte[0]:=false;
                    tmpBit1:=false;
                  end
                  else
                    if tmpByte2=2 then
                      begin
                        tmpBByte[0]:=false;
                        tmpAByte[0]:=true;
                      end
                      else
                      begin
                        tmpBByte[0]:=true;
                        tmpAByte[0]:=true;
                        tmpBit1:=false;
                      end;
            tmpByte2:=0;
            if RAM[RegW,1] then inc(tmpByte2);
            if readRAM(tmpByte1,1) then inc(tmpByte2);
            if tmpAByte[0] then inc(tmpByte2);
            if tmpByte2=0 then
              begin
              tmpBByte[1]:=false;
              tmpAByte[1]:=false;
              end
              else
                if tmpByte2=1  then
                  begin
                    tmpBByte[1]:=true;
                    tmpAByte[1]:=false;
                    tmpBit1:=false;
                  end
                  else
                    if tmpByte2=2 then
                      begin
                        tmpBByte[1]:=false;
                        tmpAByte[1]:=true;
                      end
                      else
                      begin
                        tmpBByte[1]:=true;
                        tmpAByte[1]:=true;
                        tmpBit1:=false;
                      end;
            tmpByte2:=0;
            if RAM[RegW,2] then inc(tmpByte2);
            if readRAM(tmpByte1,2) then inc(tmpByte2);
            if tmpAByte[1] then inc(tmpByte2);
            if tmpByte2=0 then
              begin
              tmpBByte[2]:=false;
              tmpAByte[2]:=false;
              end
              else
                if tmpByte2=1  then
                  begin
                    tmpBByte[2]:=true;
                    tmpAByte[2]:=false;
                    tmpBit1:=false;
                  end
                  else
                    if tmpByte2=2 then
                      begin
                        tmpBByte[2]:=false;
                        tmpAByte[2]:=true;
                      end
                      else
                      begin
                        tmpBByte[2]:=true;
                        tmpAByte[2]:=true;
                        tmpBit1:=false;
                      end;
            tmpByte2:=0;
            if RAM[RegW,3] then inc(tmpByte2);
            if readRAM(tmpByte1,3) then inc(tmpByte2);
            if tmpAByte[2] then inc(tmpByte2);
            if tmpByte2=0 then
              begin
              tmpBByte[3]:=false;
              tmpAByte[3]:=false;
              end
              else
                if tmpByte2=1  then
                  begin
                    tmpBByte[3]:=true;
                    tmpAByte[3]:=false;
                    tmpBit1:=false;
                  end
                  else
                    if tmpByte2=2 then
                      begin
                        tmpBByte[3]:=false;
                        tmpAByte[3]:=true;
                      end
                      else
                      begin
                        tmpBByte[3]:=true;
                        tmpAByte[3]:=true;
                        tmpBit1:=false;
                      end;
            tmpByte2:=0;
            if RAM[RegW,4] then inc(tmpByte2);
            if readRAM(tmpByte1,4) then inc(tmpByte2);
            if tmpAByte[3] then inc(tmpByte2);
            if tmpByte2=0 then
              begin
              tmpBByte[4]:=false;
              tmpAByte[4]:=false;
              end
              else
                if tmpByte2=1  then
                  begin
                    tmpBByte[4]:=true;
                    tmpAByte[4]:=false;
                    tmpBit1:=false;
                  end
                  else
                    if tmpByte2=2 then
                      begin
                        tmpBByte[4]:=false;
                        tmpAByte[4]:=true;
                      end
                      else
                      begin
                        tmpBByte[4]:=true;
                        tmpAByte[4]:=true;
                        tmpBit1:=false;
                      end;
            tmpByte2:=0;
            if RAM[RegW,5] then inc(tmpByte2);
            if readRAM(tmpByte1,5) then inc(tmpByte2);
            if tmpAByte[4] then inc(tmpByte2);
            if tmpByte2=0 then
              begin
              tmpBByte[5]:=false;
              tmpAByte[5]:=false;
              end
              else
                if tmpByte2=1  then
                  begin
                    tmpBByte[5]:=true;
                    tmpAByte[5]:=false;
                    tmpBit1:=false;
                  end
                  else
                    if tmpByte2=2 then
                      begin
                        tmpBByte[5]:=false;
                        tmpAByte[5]:=true;
                      end
                      else
                      begin
                        tmpBByte[5]:=true;
                        tmpAByte[5]:=true;
                        tmpBit1:=false;
                      end;
            tmpByte2:=0;
            if RAM[RegW,6] then inc(tmpByte2);
            if readRAM(tmpByte1,6) then inc(tmpByte2);
            if tmpAByte[5] then inc(tmpByte2);
            if tmpByte2=0 then
              begin
              tmpBByte[6]:=false;
              tmpAByte[6]:=false;
              end
              else
                if tmpByte2=1  then
                  begin
                    tmpBByte[6]:=true;
                    tmpAByte[6]:=false;
                    tmpBit1:=false;
                  end
                  else
                    if tmpByte2=2 then
                      begin
                        tmpBByte[6]:=false;
                        tmpAByte[6]:=true;
                      end
                      else
                      begin
                        tmpBByte[6]:=true;
                        tmpAByte[6]:=true;
                        tmpBit1:=false;
                      end;
            tmpByte2:=0;
            if RAM[RegW,7] then inc(tmpByte2);
            if readRAM(tmpByte1,7) then inc(tmpByte2);
            if tmpAByte[6] then inc(tmpByte2);
            if tmpByte2=0 then
              begin
              tmpBByte[7]:=false;
              tmpAByte[7]:=false;
              end
              else
                if tmpByte2=1  then
                  begin
                    tmpBByte[7]:=true;
                    tmpAByte[7]:=false;
                    tmpBit1:=false;
                  end
                  else
                    if tmpByte2=2 then
                      begin
                        tmpBByte[7]:=false;
                        tmpAByte[7]:=true;
                      end
                      else
                      begin
                        tmpBByte[7]:=true;
                        tmpAByte[7]:=true;
                        tmpBit1:=false;
                      end;

            //Процедура сложения закончилась, теперь перенесем флаги из битов переноса
            tmpBit2:=tmpAByte[7];//Перенос флага C
            tmpBit3:=tmpAByte[3]; //Перенос флага DC
            //Терерь перенесем результат
            if currentcommand[5] then
            begin //Все пойдет в регистр f
            СhangeData[0]:=tmpBByte[0];
            СhangeData[1]:=tmpBByte[1];
            СhangeData[2]:=tmpBByte[2];
            СhangeData[3]:=tmpBByte[3];
            СhangeData[4]:=tmpBByte[4];
            СhangeData[5]:=tmpBByte[5];
            СhangeData[6]:=tmpBByte[6];
            СhangeData[7]:=tmpBByte[7];

            //Изменить RAM по адресу в соответствии с данными
            ChangeAddr:=tmpByte1;
            ChangeRAMByte();
            end
            else
            begin //Все пойдет в регистр W
            СhangeData[0]:=tmpBByte[0];
            СhangeData[1]:=tmpBByte[1];
            СhangeData[2]:=tmpBByte[2];
            СhangeData[3]:=tmpBByte[3];
            СhangeData[4]:=tmpBByte[4];
            СhangeData[5]:=tmpBByte[5];
            СhangeData[6]:=tmpBByte[6];
            СhangeData[7]:=tmpBByte[7];

            //Изменить RAM по адресу в соответствии с данными
            ChangeAddr:=regw;
            ChangeRAMByte();
            end;
            //Изменим флаг Z
            ChangeBitData:=tmpBit1;
            ChangeBitAddr:=3;
            ChangeBitNo:=2;
            ChangeRAMBit;
            //Изменим флаг C
            ChangeBitData:=tmpBit2;
            ChangeBitAddr:=3;
            ChangeBitNo:=0;
            ChangeRAMBit;
            //Изменим флаг DC
            ChangeBitData:=tmpBit3;
            ChangeBitAddr:=3;
            ChangeBitNo:=1;
            ChangeRAMBit;
            // прибавляем  все на 1 м.ц.
            I:=I+1;
            PCLpp();
            goto 10;
            end
            else
            begin //000110XXXXXX
//aXORWF
            //Преобразование fffff в номер ячейки
            tmpByte1:=0;
            if currentcommand[0] then tmpByte1:=tmpByte1+1;
            if currentcommand[1] then tmpByte1:=tmpByte1+2;
            if currentcommand[2] then tmpByte1:=tmpByte1+4;
            if currentcommand[3] then tmpByte1:=tmpByte1+8;
            if currentcommand[4] then tmpByte1:=tmpByte1+16;
            ChangeBitData:=true; //Установка Z флага, на случай если рез-т операции будет равен 0
            // Далее идет операция XOR м-у регистром f и регистром W.  Если Хоть один бит не равен 0, то сбрасывается флаг Z
            tmpBByte[0]:=RAM[RegW,0] XOR readRAM(tmpByte1,0); if tmpBByte[0] then ChangeBitData:=false;
            tmpBByte[1]:=RAM[RegW,1] XOR readRAM(tmpByte1,1); if tmpBByte[1] then ChangeBitData:=false;
            tmpBByte[2]:=RAM[RegW,2] XOR readRAM(tmpByte1,2); if tmpBByte[2] then ChangeBitData:=false;
            tmpBByte[3]:=RAM[RegW,3] XOR readRAM(tmpByte1,3); if tmpBByte[3] then ChangeBitData:=false;
            tmpBByte[4]:=RAM[RegW,4] XOR readRAM(tmpByte1,4); if tmpBByte[4] then ChangeBitData:=false;
            tmpBByte[5]:=RAM[RegW,5] XOR readRAM(tmpByte1,5); if tmpBByte[5] then ChangeBitData:=false;
            tmpBByte[6]:=RAM[RegW,6] XOR readRAM(tmpByte1,6); if tmpBByte[6] then ChangeBitData:=false;
            tmpBByte[7]:=RAM[RegW,7] XOR readRAM(tmpByte1,7); if tmpBByte[7] then ChangeBitData:=false;
            //Терерь перенесем результат
            if currentcommand[5] then
            begin //Все пойдет в регистр f
            СhangeData[0]:=tmpBByte[0];
            СhangeData[1]:=tmpBByte[1];
            СhangeData[2]:=tmpBByte[2];
            СhangeData[3]:=tmpBByte[3];
            СhangeData[4]:=tmpBByte[4];
            СhangeData[5]:=tmpBByte[5];
            СhangeData[6]:=tmpBByte[6];
            СhangeData[7]:=tmpBByte[7];

            //Изменить RAM по адресу в соответствии с данными
            ChangeAddr:=tmpbyte1;
            ChangeRAMByte();
            end
            else
            begin //Все пойдет в регистр W
            СhangeData[0]:=tmpBByte[0];
            СhangeData[1]:=tmpBByte[1];
            СhangeData[2]:=tmpBByte[2];
            СhangeData[3]:=tmpBByte[3];
            СhangeData[4]:=tmpBByte[4];
            СhangeData[5]:=tmpBByte[5];
            СhangeData[6]:=tmpBByte[6];
            СhangeData[7]:=tmpBByte[7];

            //Изменить RAM по адресу в соответствии с данными
            ChangeAddr:=regW;
            ChangeRAMByte();
            end;
            //Изменить флаг Z в Status
            ChangeBitAddr:=3;
            ChangeBitNo:=2;
            ChangeRAMBit;
            //Прибавить счетчик комманд, и выполнить сл. комманду.
            I:=I+1;
            PCLpp();
            goto 10;
            end;
          end
          else
          begin  //00010XXXXXXX
          if currentcommand[6] then
            begin  //000101XXXXXX
//aANDWF
            //Преобразование fffff в номер ячейки
            tmpByte1:=0;
            if currentcommand[0] then tmpByte1:=tmpByte1+1;
            if currentcommand[1] then tmpByte1:=tmpByte1+2;
            if currentcommand[2] then tmpByte1:=tmpByte1+4;
            if currentcommand[3] then tmpByte1:=tmpByte1+8;
            if currentcommand[4] then tmpByte1:=tmpByte1+16;
            ChangeBitData:=true;; //Установка Z флага, на случай если рез-т операции будет равен 0
            // Далее идет операция XOR м-у регистром f и регистром W.  Если Хоть один бит не равен 0, то сбрасывается флаг Z
            tmpBByte[0]:=RAM[RegW,0] AND readRAM(tmpByte1,0); if tmpBByte[0] then ChangeBitData:=false;
            tmpBByte[1]:=RAM[RegW,1] AND readRAM(tmpByte1,1); if tmpBByte[1] then ChangeBitData:=false;
            tmpBByte[2]:=RAM[RegW,2] AND readRAM(tmpByte1,2); if tmpBByte[2] then ChangeBitData:=false;
            tmpBByte[3]:=RAM[RegW,3] AND readRAM(tmpByte1,3); if tmpBByte[3] then ChangeBitData:=false;
            tmpBByte[4]:=RAM[RegW,4] AND readRAM(tmpByte1,4); if tmpBByte[4] then ChangeBitData:=false;
            tmpBByte[5]:=RAM[RegW,5] AND readRAM(tmpByte1,5); if tmpBByte[5] then ChangeBitData:=false;
            tmpBByte[6]:=RAM[RegW,6] AND readRAM(tmpByte1,6); if tmpBByte[6] then ChangeBitData:=false;
            tmpBByte[7]:=RAM[RegW,7] AND readRAM(tmpByte1,7); if tmpBByte[7] then ChangeBitData:=false;
            //Терерь перенесем результат
            if currentcommand[5] then
            begin //Все пойдет в регистр f
            СhangeData[0]:=tmpBByte[0];
            СhangeData[1]:=tmpBByte[1];
            СhangeData[2]:=tmpBByte[2];
            СhangeData[3]:=tmpBByte[3];
            СhangeData[4]:=tmpBByte[4];
            СhangeData[5]:=tmpBByte[5];
            СhangeData[6]:=tmpBByte[6];
            СhangeData[7]:=tmpBByte[7];

            //Изменить RAM по адресу в соответствии с данными
            ChangeAddr:=tmpbyte1;
            ChangeRAMByte();
            end
            else
            begin //Все пойдет в регистр W
            СhangeData[0]:=tmpBByte[0];
            СhangeData[1]:=tmpBByte[1];
            СhangeData[2]:=tmpBByte[2];
            СhangeData[3]:=tmpBByte[3];
            СhangeData[4]:=tmpBByte[4];
            СhangeData[5]:=tmpBByte[5];
            СhangeData[6]:=tmpBByte[6];
            СhangeData[7]:=tmpBByte[7];

            //Изменить RAM по адресу в соответствии с данными
            ChangeAddr:=regW;
            ChangeRAMByte();
            end;
            //Изменить флаг Z в Status
            ChangeBitAddr:=3;
            ChangeBitNo:=2;
            ChangeRAMBit;
            //Прибавить счетчик комманд, и выполнить сл. комманду.
            I:=I+1;
            PCLpp();
            goto 10;
            end
            else
            begin  //000100XXXXXX
//aIORWF
            //Преобразование fffff в номер ячейки
            tmpByte1:=0;
            if currentcommand[0] then tmpByte1:=tmpByte1+1;
            if currentcommand[1] then tmpByte1:=tmpByte1+2;
            if currentcommand[2] then tmpByte1:=tmpByte1+4;
            if currentcommand[3] then tmpByte1:=tmpByte1+8;
            if currentcommand[4] then tmpByte1:=tmpByte1+16;
            ChangeBitData:=true; //Установка Z флага, на случай если рез-т операции будет равен 0
            // Далее идет операция XOR м-у регистром f и регистром W.  Если Хоть один бит не равен 0, то сбрасывается флаг Z
            tmpBByte[0]:=RAM[RegW,0] OR readRAM(tmpByte1,0); if tmpBByte[0] then ChangeBitData:=false;
            tmpBByte[1]:=RAM[RegW,1] OR readRAM(tmpByte1,1); if tmpBByte[1] then ChangeBitData:=false;
            tmpBByte[2]:=RAM[RegW,2] OR readRAM(tmpByte1,2); if tmpBByte[2] then ChangeBitData:=false;
            tmpBByte[3]:=RAM[RegW,3] OR readRAM(tmpByte1,3); if tmpBByte[3] then ChangeBitData:=false;
            tmpBByte[4]:=RAM[RegW,4] OR readRAM(tmpByte1,4); if tmpBByte[4] then ChangeBitData:=false;
            tmpBByte[5]:=RAM[RegW,5] OR readRAM(tmpByte1,5); if tmpBByte[5] then ChangeBitData:=false;
            tmpBByte[6]:=RAM[RegW,6] OR readRAM(tmpByte1,6); if tmpBByte[6] then ChangeBitData:=false;
            tmpBByte[7]:=RAM[RegW,7] OR readRAM(tmpByte1,7); if tmpBByte[7] then ChangeBitData:=false;
            //Терерь перенесем результат
            if currentcommand[5] then
            begin //Все пойдет в регистр f
            СhangeData[0]:=tmpBByte[0];
            СhangeData[1]:=tmpBByte[1];
            СhangeData[2]:=tmpBByte[2];
            СhangeData[3]:=tmpBByte[3];
            СhangeData[4]:=tmpBByte[4];
            СhangeData[5]:=tmpBByte[5];
            СhangeData[6]:=tmpBByte[6];
            СhangeData[7]:=tmpBByte[7];

            //Изменить RAM по адресу в соответствии с данными
            ChangeAddr:=tmpByte1;
            ChangeRAMByte();
            end
            else
            begin //Все пойдет в регистр W
            СhangeData[0]:=tmpBByte[0];
            СhangeData[1]:=tmpBByte[1];
            СhangeData[2]:=tmpBByte[2];
            СhangeData[3]:=tmpBByte[3];
            СhangeData[4]:=tmpBByte[4];
            СhangeData[5]:=tmpBByte[5];
            СhangeData[6]:=tmpBByte[6];
            СhangeData[7]:=tmpBByte[7];

            //Изменить RAM по адресу в соответствии с данными
            ChangeAddr:=regW;
            ChangeRAMByte();
            end;
            //Изменить флаг Z в Status
            ChangeBitAddr:=3;
            ChangeBitNo:=2;
            ChangeRAMBit;
            //Прибавить счетчик комманд, и выполнить сл. комманду.
            I:=I+1;
            PCLpp();
            goto 10;
            end;
          end;


        end
        else
        begin //0000XXXXXXXX
          if CurrentCommand[7] then
          begin //00001XXXXXXX
            if CurrentCommand[6] then
            begin //000011XXXXXX
//aDECF
            //Преобразование fffff в номер ячейки
            tmpByte1:=0;
            if currentcommand[0] then tmpByte1:=tmpByte1+1;
            if currentcommand[1] then tmpByte1:=tmpByte1+2;
            if currentcommand[2] then tmpByte1:=tmpByte1+4;
            if currentcommand[3] then tmpByte1:=tmpByte1+8;
            if currentcommand[4] then tmpByte1:=tmpByte1+16;
            //Сама процедура вычетания
            ChangeBitData:=true; //Установка Z флага, на случай если рез-т операции будет равен 0
            tmpByte2:=1;
            if readRAM(tmpByte1,0) then inc(tmpByte2);
                if tmpByte2=2  then
                  begin
                    tmpAByte[0]:=false;
                    tmpBByte[0]:=false;
                  end
                  else
                    if tmpByte2=1 then
                      begin
                        tmpBByte[0]:=true;
                        tmpAByte[0]:=true;
                        ChangeBitData:=false;
                      end;
            tmpByte2:=2;
            if readRAM(tmpByte1,1) then inc(tmpByte2);
            if tmpAByte[0] then DEC(tmpByte2);
            if tmpByte2=3 then
              begin
              tmpBByte[1]:=true;
              tmpAByte[1]:=false;
              ChangeBitData:=false;
              end
              else
                if tmpByte2=2  then
                  begin
                    tmpAByte[1]:=false;
                    tmpBByte[1]:=false;
                  end
                  else
                    if tmpByte2=1 then
                      begin
                        tmpBByte[1]:=true;
                        tmpAByte[1]:=true;
                        ChangeBitData:=false;
                      end;
            tmpByte2:=2;
            if readRAM(tmpByte1,2) then inc(tmpByte2);
            if tmpAByte[1] then DEC(tmpByte2);
            if tmpByte2=3 then
              begin
              tmpBByte[2]:=true;
              tmpAByte[2]:=false;
              ChangeBitData:=false;
              end
              else
                if tmpByte2=2  then
                  begin
                    tmpAByte[2]:=false;
                    tmpBByte[2]:=false;
                  end
                  else
                    if tmpByte2=1 then
                      begin
                        tmpBByte[2]:=true;
                        tmpAByte[2]:=true;
                        ChangeBitData:=false;
                      end;
            tmpByte2:=2;
            if readRAM(tmpByte1,3) then inc(tmpByte2);
            if tmpAByte[2] then DEC(tmpByte2);
            if tmpByte2=3 then
              begin
              tmpBByte[3]:=true;
              tmpAByte[3]:=false;
              ChangeBitData:=false;
              end
              else
                if tmpByte2=2  then
                  begin
                    tmpAByte[3]:=false;
                    tmpBByte[3]:=false;
                  end
                  else
                    if tmpByte2=1 then
                      begin
                        tmpBByte[3]:=true;
                        tmpAByte[3]:=true;
                        ChangeBitData:=false;
                      end;
            tmpByte2:=2;
            if readRAM(tmpByte1,4) then inc(tmpByte2);
            if tmpAByte[3] then DEC(tmpByte2);
            if tmpByte2=3 then
              begin
              tmpBByte[4]:=true;
              tmpAByte[4]:=false;
              ChangeBitData:=false;
              end
              else
                if tmpByte2=2  then
                  begin
                    tmpAByte[4]:=false;
                    tmpBByte[4]:=false;
                  end
                  else
                    if tmpByte2=1 then
                      begin
                        tmpBByte[4]:=true;
                        tmpAByte[4]:=true;
                        ChangeBitData:=false;
                      end;
            tmpByte2:=2;
            if readRAM(tmpByte1,5) then inc(tmpByte2);
            if tmpAByte[4] then DEC(tmpByte2);
            if tmpByte2=3 then
              begin
              tmpBByte[5]:=true;
              tmpAByte[5]:=false;
              ChangeBitData:=false;
              end
              else
                if tmpByte2=2  then
                  begin
                    tmpAByte[5]:=false;
                    tmpBByte[5]:=false;
                  end
                  else
                    if tmpByte2=1 then
                      begin
                        tmpBByte[5]:=true;
                        tmpAByte[5]:=true;
                        ChangeBitData:=false;
                      end;
            tmpByte2:=2;
            if readRAM(tmpByte1,6) then inc(tmpByte2);
            if tmpAByte[5] then DEC(tmpByte2);
            if tmpByte2=3 then
              begin
              tmpBByte[6]:=true;
              tmpAByte[6]:=false;
              ChangeBitData:=false;
              end
              else
                if tmpByte2=2  then
                  begin
                    tmpAByte[6]:=false;
                    tmpBByte[6]:=false;
                  end
                  else
                    if tmpByte2=1 then
                      begin
                        tmpBByte[6]:=true;
                        tmpAByte[6]:=true;
                        ChangeBitData:=false;
                      end;
            tmpByte2:=2;
            if readRAM(tmpByte1,7) then inc(tmpByte2);
            if tmpAByte[6] then DEC(tmpByte2);
            if tmpByte2=3 then
              begin
              tmpBByte[7]:=true;
              tmpAByte[7]:=false;
              ChangeBitData:=false;
              end
              else
                if tmpByte2=2  then
                  begin
                    tmpAByte[7]:=false;
                    tmpBByte[7]:=false;
                  end
                  else
                    if tmpByte2=1 then
                      begin
                        tmpBByte[7]:=true;
                        tmpAByte[7]:=true;
                        ChangeBitData:=false;
                      end;
            //Терерь перенесем результат
            if currentcommand[5] then
            begin //Все пойдет в регистр f
            СhangeData[0]:=tmpBByte[0];
            СhangeData[1]:=tmpBByte[1];
            СhangeData[2]:=tmpBByte[2];
            СhangeData[3]:=tmpBByte[3];
            СhangeData[4]:=tmpBByte[4];
            СhangeData[5]:=tmpBByte[5];
            СhangeData[6]:=tmpBByte[6];
            СhangeData[7]:=tmpBByte[7];

            //Изменить RAM по адресу в соответствии с данными
            ChangeAddr:=tmpbyte1;
            ChangeRAMByte();
            end
            else
            begin //Все пойдет в регистр W
            СhangeData[0]:=tmpBByte[0];
            СhangeData[1]:=tmpBByte[1];
            СhangeData[2]:=tmpBByte[2];
            СhangeData[3]:=tmpBByte[3];
            СhangeData[4]:=tmpBByte[4];
            СhangeData[5]:=tmpBByte[5];
            СhangeData[6]:=tmpBByte[6];
            СhangeData[7]:=tmpBByte[7];

            //Изменить RAM по адресу в соответствии с данными
            ChangeAddr:=regW;
            ChangeRAMByte();
            end;
            //Изменить флаг Z в Status
            ChangeBitAddr:=3;
            ChangeBitNo:=2;
            ChangeRAMBit;
            // прибавляем  все на 1 м.ц.
            I:=I+1;
            PCLpp();
            goto 10;
            end
            else
            begin //000010XXXXXX
//bSUBWF
            //Преобразование fffff в номер ячейки
            tmpByte1:=0;
            if currentcommand[0] then tmpByte1:=tmpByte1+1;
            if currentcommand[1] then tmpByte1:=tmpByte1+2;
            if currentcommand[2] then tmpByte1:=tmpByte1+4;
            if currentcommand[3] then tmpByte1:=tmpByte1+8;
            if currentcommand[4] then tmpByte1:=tmpByte1+16;
            //Сама процедура вычетания
            tmpbit1:=true; //Установка Z флага, на случай если рез-т операции будет равен 0
            tmpByte2:=2;
            if RAM[RegW,0] then DEC(tmpByte2);
            if readRAM(tmpByte1,0) then inc(tmpByte2);
            if tmpByte2=3 then
              begin
              tmpBByte[0]:=true;
              tmpAByte[0]:=false;
              tmpbit1:=false;
              end
              else
                if tmpByte2=2  then
                  begin
                    tmpAByte[0]:=false;
                    tmpBByte[0]:=false;
                  end
                  else
                    if tmpByte2=1 then
                      begin
                        tmpBByte[0]:=true;
                        tmpAByte[0]:=true;
                        tmpbit1:=false;
                      end
                      else
                      begin
                        tmpBByte[0]:=false;
                        tmpAByte[0]:=true;
                      end;
            tmpByte2:=2;
            if RAM[RegW,1] then DEC(tmpByte2);
            if readRAM(tmpByte1,1) then inc(tmpByte2);
            if tmpAByte[0] then DEC(tmpByte2);
            if tmpByte2=3 then
              begin
              tmpBByte[1]:=true;
              tmpAByte[1]:=false;
              tmpbit1:=false;
              end
              else
                if tmpByte2=2  then
                  begin
                    tmpAByte[1]:=false;
                    tmpBByte[1]:=false;
                  end
                  else
                    if tmpByte2=1 then
                      begin
                        tmpBByte[1]:=true;
                        tmpAByte[1]:=true;
                        tmpbit1:=false;
                      end
                      else
                      begin
                        tmpBByte[1]:=false;
                        tmpAByte[1]:=true;
                      end;
            tmpByte2:=2;
            if RAM[RegW,2] then DEC(tmpByte2);
            if readRAM(tmpByte1,2) then inc(tmpByte2);
            if tmpAByte[1] then DEC(tmpByte2);
            if tmpByte2=3 then
              begin
              tmpBByte[2]:=true;
              tmpAByte[2]:=false;
              tmpbit1:=false;
              end
              else
                if tmpByte2=2  then
                  begin
                    tmpAByte[2]:=false;
                    tmpBByte[2]:=false;
                  end
                  else
                    if tmpByte2=1 then
                      begin
                        tmpBByte[2]:=true;
                        tmpAByte[2]:=true;
                        tmpbit1:=false;
                      end
                      else
                      begin
                        tmpBByte[2]:=false;
                        tmpAByte[2]:=true;
                      end;
            tmpByte2:=2;
            if RAM[RegW,3] then DEC(tmpByte2);
            if readRAM(tmpByte1,3) then inc(tmpByte2);
            if tmpAByte[2] then DEC(tmpByte2);
            if tmpByte2=3 then
              begin
              tmpBByte[3]:=true;
              tmpAByte[3]:=false;
              tmpbit1:=false;
              end
              else
                if tmpByte2=2  then
                  begin
                    tmpAByte[3]:=false;
                    tmpBByte[3]:=false;
                  end
                  else
                    if tmpByte2=1 then
                      begin
                        tmpBByte[3]:=true;
                        tmpAByte[3]:=true;
                        tmpbit1:=false;
                      end
                      else
                      begin
                        tmpBByte[3]:=false;
                        tmpAByte[3]:=true;
                      end;
            tmpByte2:=2;
            if RAM[RegW,4] then DEC(tmpByte2);
            if readRAM(tmpByte1,4) then inc(tmpByte2);
            if tmpAByte[3] then DEC(tmpByte2);
            if tmpByte2=3 then
              begin
              tmpBByte[4]:=true;
              tmpAByte[4]:=false;
              tmpbit1:=false;
              end
              else
                if tmpByte2=2  then
                  begin
                    tmpAByte[4]:=false;
                    tmpBByte[4]:=false;
                  end
                  else
                    if tmpByte2=1 then
                      begin
                        tmpBByte[4]:=true;
                        tmpAByte[4]:=true;
                        tmpbit1:=false;
                      end
                      else
                      begin
                        tmpBByte[4]:=false;
                        tmpAByte[4]:=true;
                      end;
            tmpByte2:=2;
            if RAM[RegW,5] then DEC(tmpByte2);
            if readRAM(tmpByte1,5) then inc(tmpByte2);
            if tmpAByte[4] then DEC(tmpByte2);
            if tmpByte2=3 then
              begin
              tmpBByte[5]:=true;
              tmpAByte[5]:=false;
              tmpbit1:=false;
              end
              else
                if tmpByte2=2  then
                  begin
                    tmpAByte[5]:=false;
                    tmpBByte[5]:=false;
                  end
                  else
                    if tmpByte2=1 then
                      begin
                        tmpBByte[5]:=true;
                        tmpAByte[5]:=true;
                        tmpbit1:=false;
                      end
                      else
                      begin
                        tmpBByte[5]:=false;
                        tmpAByte[5]:=true;
                      end;
            tmpByte2:=2;
            if RAM[RegW,6] then DEC(tmpByte2);
            if readRAM(tmpByte1,6) then inc(tmpByte2);
            if tmpAByte[5] then DEC(tmpByte2);
            if tmpByte2=3 then
              begin
              tmpBByte[6]:=true;
              tmpAByte[6]:=false;
              tmpbit1:=false;
              end
              else
                if tmpByte2=2  then
                  begin
                    tmpAByte[6]:=false;
                    tmpBByte[6]:=false;
                  end
                  else
                    if tmpByte2=1 then
                      begin
                        tmpBByte[6]:=true;
                        tmpAByte[6]:=true;
                        tmpbit1:=false;
                      end
                      else
                      begin
                        tmpBByte[6]:=false;
                        tmpAByte[6]:=true;
                      end;
                        tmpByte2:=2;
            if RAM[RegW,7] then DEC(tmpByte2);
            if readRAM(tmpByte1,7) then inc(tmpByte2);
            if tmpAByte[6] then DEC(tmpByte2);
            if tmpByte2=3 then
              begin
              tmpBByte[7]:=true;
              tmpAByte[7]:=false;
              tmpbit1:=false;
              end
              else
                if tmpByte2=2  then
                  begin
                    tmpAByte[7]:=false;
                    tmpBByte[7]:=false;
                  end
                  else
                    if tmpByte2=1 then
                      begin
                        tmpBByte[7]:=true;
                        tmpAByte[7]:=true;
                        tmpbit1:=false;
                      end
                      else
                      begin
                        tmpBByte[7]:=false;
                        tmpAByte[7]:=true;
                      end;

            //Процедура вычета закончилась, теперь перенесем флаги из битов переноса
            tmpbit2:=not tmpAByte[7];//Перенос флага C
//ХЗ с битом DC
            tmpbit3:=not tmpAByte[3]; //Перенос флага DC
            //Терерь перенесем результат
            if currentcommand[5] then
            begin //Все пойдет в регистр f
            СhangeData[0]:=tmpBByte[0];
            СhangeData[1]:=tmpBByte[1];
            СhangeData[2]:=tmpBByte[2];
            СhangeData[3]:=tmpBByte[3];
            СhangeData[4]:=tmpBByte[4];
            СhangeData[5]:=tmpBByte[5];
            СhangeData[6]:=tmpBByte[6];
            СhangeData[7]:=tmpBByte[7];

            //Изменить RAM по адресу в соответствии с данными
            ChangeAddr:=tmpbyte1;
            ChangeRAMByte();
            end
            else
            begin //Все пойдет в регистр W
            СhangeData[0]:=tmpBByte[0];
            СhangeData[1]:=tmpBByte[1];
            СhangeData[2]:=tmpBByte[2];
            СhangeData[3]:=tmpBByte[3];
            СhangeData[4]:=tmpBByte[4];
            СhangeData[5]:=tmpBByte[5];
            СhangeData[6]:=tmpBByte[6];
            СhangeData[7]:=tmpBByte[7];

            //Изменить RAM по адресу в соответствии с данными
            ChangeAddr:=regW;
            ChangeRAMByte();
            end;
            //Изменить флаг Z в Status
            ChangeBitData:=tmpbit1;
            ChangeBitAddr:=3;
            ChangeBitNo:=2;
            ChangeRAMBit;
            //Изменить флаг C в Status
            ChangeBitData:=tmpbit2;
            ChangeBitAddr:=3;
            ChangeBitNo:=0;
            ChangeRAMBit;
            //Изменить флаг DC в Status
            ChangeBitData:=tmpbit3;
            ChangeBitAddr:=3;
            ChangeBitNo:=1;
            ChangeRAMBit;
            // прибавляем  все на 1 м.ц.
            I:=I+1;
            PCLpp();
            goto 10;
            end;


          end
          else
          begin //00000XXXXXXX
            if CurrentCommand[6] then
            begin //000001XXXXXX
              if CurrentCommand[5] then
              begin //0000011XXXXX
//aCLRF
              //Преобразование fffff в номер ячейки
              tmpByte1:=0;
              if currentcommand[0] then tmpByte1:=tmpByte1+1;
              if currentcommand[1] then tmpByte1:=tmpByte1+2;
              if currentcommand[2] then tmpByte1:=tmpByte1+4;
              if currentcommand[3] then tmpByte1:=tmpByte1+8;
              if currentcommand[4] then tmpByte1:=tmpByte1+16;
              //Сама процедура очистки
              ChangeBitData:=true; //Установка Z флага, всегда будет установлен в этой проц
              СhangeData[0]:=false;
              СhangeData[1]:=false;
              СhangeData[2]:=false;
              СhangeData[3]:=false;
              СhangeData[4]:=false;
              СhangeData[5]:=false;
              СhangeData[6]:=false;
              СhangeData[7]:=false;
              //Изменить RAM по адресу в соответствии с данными
              ChangeAddr:=tmpByte1;
              ChangeRAMByte();
              //Изменить флаг Z в Status
              ChangeBitAddr:=3;
              ChangeBitNo:=2;
              ChangeRAMBit;
              // прибавляем  все на 1 м.ц.
              I:=I+1;
              PCLpp();
              goto 10;
              end
              else
              begin //0000010XXXXX
//aCLRW
              ChangeBitData:=true; //Установка Z флага, всегда будет установлен в этой проц
              СhangeData[0]:=false;
              СhangeData[1]:=false;
              СhangeData[2]:=false;
              СhangeData[3]:=false;
              СhangeData[4]:=false;
              СhangeData[5]:=false;
              СhangeData[6]:=false;
              СhangeData[7]:=false;
              //Изменить RAM по адресу в соответствии с данными
              ChangeAddr:=regW;
              ChangeRAMByte();
              //Изменить флаг Z в Status
              ChangeBitAddr:=3;
              ChangeBitNo:=2;
              ChangeRAMBit;
               // прибавляем  все на 1 м.ц.
              I:=I+1;
              PCLpp();
              goto 10;
              end;
            end
            else
            begin //000000XXXXXX
              if CurrentCommand[5] then
              begin //0000001XXXXX
//aMOVWF
              //Преобразование fffff в номер ячейки
              tmpByte1:=0;
              if currentcommand[0] then tmpByte1:=tmpByte1+1;
              if currentcommand[1] then tmpByte1:=tmpByte1+2;
              if currentcommand[2] then tmpByte1:=tmpByte1+4;
              if currentcommand[3] then tmpByte1:=tmpByte1+8;
              if currentcommand[4] then tmpByte1:=tmpByte1+16;
              //Сама процедура переноса W->f
              СhangeData[0]:=RAM[RegW,0];
              СhangeData[1]:=RAM[RegW,1];
              СhangeData[2]:=RAM[RegW,2];
              СhangeData[3]:=RAM[RegW,3];
              СhangeData[4]:=RAM[RegW,4];
              СhangeData[5]:=RAM[RegW,5];
              СhangeData[6]:=RAM[RegW,6];
              СhangeData[7]:=RAM[RegW,7];
              //Изменить RAM по адресу в соответствии с данными
              ChangeAddr:=tmpByte1;
              ChangeRAMByte();
              // прибавляем  все на 1 м.ц.
              I:=I+1;
              PCLpp();
              goto 10;
              end
              else
              begin //0000000XXXXX
                if CurrentCommand[4] then
                begin //00000001XXXX
                //Unknow command
                end
                else
                begin //00000000XXXX
                  if CurrentCommand[3] then
                  begin //000000001XXX
                  //Unknow command
                  end
                  else
                  begin //000000000XXX
                    if CurrentCommand[2] then
                    begin //0000000001XX
                      if CurrentCommand[1] then
                      begin //00000000011X
                        if CurrentCommand[0] then
                          begin //000000000111
//!TRIS 7  - PORT?    //Unknow command
                        // прибавляем  все на 1 м.ц.
                           I:=I+1;
                            PCLpp();
                              goto 10;
                          end
                          else
                          begin  //000000000110
//aTRIS 6
                          tmpBit1:=RAM[RegW,0];
                          tmpBit2:=RAM[RegW,1];
                          tmpBit3:=RAM[RegW,2];
                          //Изменить флаги
                          ChangeBitData:=tmpBit1;
                          ChangeBitAddr:=regTRISGPIO;
                          ChangeBitNo:=0;
                          ChangeRAMBit;
                          ChangeBitData:=tmpBit2;
                          ChangeBitAddr:=regTRISGPIO;
                          ChangeBitNo:=1;
                          ChangeRAMBit;
                          ChangeBitData:=tmpBit3;
                          ChangeBitAddr:=regTRISGPIO;
                          ChangeBitNo:=2;
                          ChangeRAMBit;
                          // прибавляем  все на 1 м.ц.
                           I:=I+1;
                            PCLpp();
                              goto 10;
                          end;
                      end
                      else
                      begin //00000000010X
                        if CurrentCommand[0] then
                        begin //000000000101
//!TRIS 5 - PORT?    //Unknow command
                        // прибавляем  все на 1 м.ц.
                           I:=I+1;
                            PCLpp();
                              goto 10;
                        end
                        else
                        begin //000000000100
//!CLRWDT
                        //Очистить WDT
                        CLRWDT(false); //Не менять! Это вызываеться и при др. условиях

                        // прибавляем  все на 1 м.ц.
                        I:=I+1;
                        PCLpp();
                        goto 10;
                        end;




                      end;

                    end
                    else
                    begin //0000000000XX
                      if CurrentCommand[1] then
                      begin //00000000001X
                        if CurrentCommand[0] then
                        Begin //000000000011
//!Sleep
                        //Очистить WDT и установить флаги при SLEEP
                        CLRWDT(true);
                        //Включение режима "сна"
                        SleepMode:=true;
                        //Запомним состояние выводов GPIO
                        sleepRegGPIO[0]:=ReadRAM(6,0);
                        sleepRegGPIO[1]:=ReadRAM(6,1);
                        sleepRegGPIO[2]:=ReadRAM(6,2);
                        sleepRegGPIO[3]:=ReadRAM(6,3);
                        // прибавляем  все на 1 м.ц.
                        I:=I+1;
                        PCLpp();
                        goto 10;
                        End
                        else
                        begin //000000000010
//aOPTION
                        СhangeData[0]:=RAM[RegW,0];
                        СhangeData[1]:=RAM[RegW,1];
                        СhangeData[2]:=RAM[RegW,2];
                        СhangeData[3]:=RAM[RegW,3];
                        СhangeData[4]:=RAM[RegW,4];
                        СhangeData[5]:=RAM[RegW,5];
                        СhangeData[6]:=RAM[RegW,6];
                        СhangeData[7]:=RAM[RegW,7];
                         //Изменить RAM по адресу в соответствии с данными
                        ChangeAddr:=regoption;
                        ChangeRAMByte();
                         // прибавляем  все на 1 м.ц.
                           I:=I+1;
                            PCLpp();
                              goto 10;
                        end;

                      end
                      else
                      begin //00000000000X
                        if CurrentCommand[0] then
                        Begin //000000000001
                        //Unknow command
                        End
                        else
                        begin //000000000000
//aNOP
                        // прибавляем  все на 1 м.ц.
                           I:=I+1;
                            PCLpp();
                              goto 10;
                        end;
                      end;
                    end;
                  end;

                end;

              end;
            end;
          end;

        end;
      end;
    end;
  end;
end;

end;

Function BinToDec():integer;
var res:integer;
begin
res:=0;
if par[0] then res:=res+1;
if par[1] then res:=res+2;
if par[2] then res:=res+4;
if par[3] then res:=res+8;
if par[4] then res:=res+16;
if par[5] then res:=res+32;
if par[6] then res:=res+64;
if par[7] then res:=res+128;
if par[8] then res:=res+256;
result:=res;
end;

Function BinToHex():string;
var L,H:string[1];
begin
//LOW
  if par[0] then
  begin //XXX1
    if par[1] then
    begin //XX11
      if par[2] then
      begin //X111
        if par[3] then //1111
        L:='F'
        else  //0111
        L:='7';
      end
      else
      begin  //X011
         if par[3] then //1011
         L:='B'
         else //0011
         L:='3';
      end;
    end
    else
    begin //XX01
      if par[2] then
      begin //X101
        if par[3] then //1101
        L:='D'
        else  //0101
        L:='5';
      end
      else
      begin  //X001
         if par[3] then //1001
         L:='9'
         else //0001
         L:='1';
      end;
    end;
  end
  else
  begin //XXX0
  if par[1] then
    begin //XX10
      if par[2] then
      begin //X110
        if par[3] then //1110
        L:='E'
        else  //0110
        L:='6';
      end
      else
      begin  //X010
         if par[3] then //1010
         L:='A'
         else //0010
         L:='2';
      end;
    end
    else
    begin //XX00
      if par[2] then
      begin //X100
        if par[3] then //1100
        L:='C'
        else  //0100
        L:='4';
      end
      else
      begin  //X000
         if par[3] then //1000
         L:='8'
         else //0000
         L:='0';
      end;
    end;
  end;

  //HIGHT

   if par[4] then
  begin //XXX1
    if par[5] then
    begin //XX11
      if par[6] then
      begin //X111
        if par[7] then //1111
        H:='F'
        else  //0111
        H:='7';
      end
      else
      begin  //X011
         if par[7] then //1011
         H:='B'
         else //0011
         H:='3';
      end;
    end
    else
    begin //XX01
      if par[6] then
      begin //X101
        if par[7] then //1101
        H:='D'
        else  //0101
        H:='5';
      end
      else
      begin  //X001
         if par[7] then //1001
         H:='9'
         else //0001
         H:='1';
      end;
    end;
  end
  else
  begin //XXX0
  if par[5] then
    begin //XX10
      if par[6] then
      begin //X110
        if par[7] then //1110
        H:='E'
        else  //0110
        H:='6';
      end
      else
      begin  //X010
         if par[7] then //1010
         H:='A'
         else //0010
         H:='2';
      end;
    end
    else
    begin //XX00
      if par[6] then
      begin //X100
        if par[7] then //1100
        H:='C'
        else  //0100
        H:='4';
      end
      else
      begin  //X000
         if par[7] then //1000
         H:='8'
         else //0000
         H:='0';
      end;
    end;
  end;
if par[8] then result:='1'+H+L else result:=H+L;
end;

function GetInstruction():String;
var
tmpByte1:byte;
begin
//

  if parCommand[11] then //1XXXXXXXXXXX
  begin
    if parCommand[10]  then //11XXXXXXXXXX
    begin
      if parCommand[9] then  //111XXXXXXXXX
      begin
        if parCommand[8] then  //1111XXXXXXXX
        begin
//XORLW k(8)
        par[0]:=parCommand[0];
        par[1]:=parCommand[1];
        par[2]:=parCommand[2];
        par[3]:=parCommand[3];
        par[4]:=parCommand[4];
        par[5]:=parCommand[5];
        par[6]:=parCommand[6];
        par[7]:=parCommand[7];
        par[8]:=false;
        result:='XORLW ' + BinToHex() + 'h';
        end
        else //1110XXXXXXXX
        begin
//ANDLW k(8)
        par[0]:=parCommand[0];
        par[1]:=parCommand[1];
        par[2]:=parCommand[2];
        par[3]:=parCommand[3];
        par[4]:=parCommand[4];
        par[5]:=parCommand[5];
        par[6]:=parCommand[6];
        par[7]:=parCommand[7];
        par[8]:=false;
        result:='ANDLW ' + BinToHex() + 'h';
        end;
      end
      else //110XXXXXXXXX
      begin
        if parCommand[8] then //1101XXXXXXXX
        begin
//IORLW k(8)
        par[0]:=parCommand[0];
        par[1]:=parCommand[1];
        par[2]:=parCommand[2];
        par[3]:=parCommand[3];
        par[4]:=parCommand[4];
        par[5]:=parCommand[5];
        par[6]:=parCommand[6];
        par[7]:=parCommand[7];
        par[8]:=false;
        result:='IORLW ' + BinToHex() + 'h';
        end
        else //1100XXXXXXXX
        begin
//MOVLW k(8)
        par[0]:=parCommand[0];
        par[1]:=parCommand[1];
        par[2]:=parCommand[2];
        par[3]:=parCommand[3];
        par[4]:=parCommand[4];
        par[5]:=parCommand[5];
        par[6]:=parCommand[6];
        par[7]:=parCommand[7];
        par[8]:=false;
        result:='MOVLW ' + BinToHex() + 'h';
        end;
      end;
    end
    else //10XXXXXXXXXX
      if parCommand[9] then //101XXXXXXXXX
      begin
//GOTO k(9)
        par[0]:=parCommand[0];
        par[1]:=parCommand[1];
        par[2]:=parCommand[2];
        par[3]:=parCommand[3];
        par[4]:=parCommand[4];
        par[5]:=parCommand[5];
        par[6]:=parCommand[6];
        par[7]:=parCommand[7];
        par[8]:=parCommand[8];
        parGOTOaddr:= BinToDec();
        result:='GOTO ' + BinToHex() + 'h';

      end
      else //100XXXXXXXXX
      begin
        if parCommand[8] then //1001XXXXXXXX
        begin
//CALL k(8)
        par[0]:=parCommand[0];
        par[1]:=parCommand[1];
        par[2]:=parCommand[2];
        par[3]:=parCommand[3];
        par[4]:=parCommand[4];
        par[5]:=parCommand[5];
        par[6]:=parCommand[6];
        par[7]:=parCommand[7];
        par[8]:=false;
        parGOTOaddr:= BinToDec();
        result:='CALL ' + BinToHex() + 'h';
        end
        else
        begin   //1000XXXXXXXX
//RETLW k(8)
        par[0]:=parCommand[0];
        par[1]:=parCommand[1];
        par[2]:=parCommand[2];
        par[3]:=parCommand[3];
        par[4]:=parCommand[4];
        par[5]:=parCommand[5];
        par[6]:=parCommand[6];
        par[7]:=parCommand[7];
        par[8]:=false;
        result:='RETLW ' + BinToHex() + 'h';
        end;
      end;
  end
  else
  begin //0XXXXXXXXXXX
    if parCommand[10] then
    begin //01XXXXXXXXXX
      if parCommand[9] then
      begin //011XXXXXXXXX
        if parCommand[8] then
        begin //0111XXXXXXXX
//BTFSS f(5),b(3)  0111bbbfffff
        par[0]:=parCommand[0];
        par[1]:=parCommand[1];
        par[2]:=parCommand[2];
        par[3]:=parCommand[3];
        par[4]:=parCommand[4];
        par[5]:=false;
        par[6]:=false;
        par[7]:=false;
        par[8]:=false;
        tmpByte1:=0;
        if parCommand[5] then tmpByte1:=tmpByte1+1;
        if parCommand[6] then tmpByte1:=tmpByte1+2;
        if parCommand[7] then tmpByte1:=tmpByte1+4;

        result:='BTFSS ' + BinToHex() + 'h, ' + inttostr(tmpByte1);
        end
        else
        begin //0110XXXXXXXX
//BTFSC f(5),b(3)  0110bbbfffff
        par[0]:=parCommand[0];
        par[1]:=parCommand[1];
        par[2]:=parCommand[2];
        par[3]:=parCommand[3];
        par[4]:=parCommand[4];
        par[5]:=false;
        par[6]:=false;
        par[7]:=false;
        par[8]:=false;
        tmpByte1:=0;
        if parCommand[5] then tmpByte1:=tmpByte1+1;
        if parCommand[6] then tmpByte1:=tmpByte1+2;
        if parCommand[7] then tmpByte1:=tmpByte1+4;

        result:='BTFSC ' + BinToHex() + 'h, ' + inttostr(tmpByte1);
        end;
      end
      else
      begin //010XXXXXXXXX
        if parCommand[8] then
        begin //0101XXXXXXXX
//BSF  f(5),b(3)
        par[0]:=parCommand[0];
        par[1]:=parCommand[1];
        par[2]:=parCommand[2];
        par[3]:=parCommand[3];
        par[4]:=parCommand[4];
        par[5]:=false;
        par[6]:=false;
        par[7]:=false;
        par[8]:=false;
        tmpByte1:=0;
        if parCommand[5] then tmpByte1:=tmpByte1+1;
        if parCommand[6] then tmpByte1:=tmpByte1+2;
        if parCommand[7] then tmpByte1:=tmpByte1+4;

        result:='BSF ' + BinToHex() + 'h, ' + inttostr(tmpByte1);
        end
        else
        begin  //0100XXXXXXXX
//BCF  f(5),b(3)
        par[0]:=parCommand[0];
        par[1]:=parCommand[1];
        par[2]:=parCommand[2];
        par[3]:=parCommand[3];
        par[4]:=parCommand[4];
        par[5]:=false;
        par[6]:=false;
        par[7]:=false;
        par[8]:=false;
        tmpByte1:=0;
        if parCommand[5] then tmpByte1:=tmpByte1+1;
        if parCommand[6] then tmpByte1:=tmpByte1+2;
        if parCommand[7] then tmpByte1:=tmpByte1+4;

        result:='BCF ' + BinToHex() + 'h, ' + inttostr(tmpByte1);
        end;
      end;
    end
    else
    begin //00XXXXXXXXXX
      if parCommand[9] then
      begin //001XXXXXXXXX
        if parCommand[8] then
        begin //0011XXXXXXXX
          if parCommand[7] then
          begin //00111XXXXXXX
            if parCommand[6] then
            begin //001111XXXXXX
//INCFSZ f(5),d(1)
            par[0]:=parCommand[0];
            par[1]:=parCommand[1];
            par[2]:=parCommand[2];
            par[3]:=parCommand[3];
            par[4]:=parCommand[4];
            par[5]:=false;
            par[6]:=false;
            par[7]:=false;
            par[8]:=false;
            if parCommand[5] then
            result:='INCFSZ ' + BinToHex() + 'h, f'
            else
            result:='INCFSZ ' + BinToHex() + 'h, W';


            end
            else
            begin //001110XXXXXX
//SWAPF f(5),d(1)
            par[0]:=parCommand[0];
            par[1]:=parCommand[1];
            par[2]:=parCommand[2];
            par[3]:=parCommand[3];
            par[4]:=parCommand[4];
            par[5]:=false;
            par[6]:=false;
            par[7]:=false;
            par[8]:=false;
            if parCommand[5] then
            result:='SWAPF ' + BinToHex() + 'h, f'
            else
            result:='SWAPF ' + BinToHex() + 'h, W';
            end;

          end
          else
          begin //00110XXXXXXX
            if parCommand[6] then
            begin //001101XXXXXX
//RLF f(5),d(1)
            par[0]:=parCommand[0];
            par[1]:=parCommand[1];
            par[2]:=parCommand[2];
            par[3]:=parCommand[3];
            par[4]:=parCommand[4];
            par[5]:=false;
            par[6]:=false;
            par[7]:=false;
            par[8]:=false;
            if parCommand[5] then
            result:='RLF ' + BinToHex() + 'h, f'
            else
            result:='RLF ' + BinToHex() + 'h, W';

            end
            else
            begin  //001100XXXXXX
//RRF f(5),d(1)
            par[0]:=parCommand[0];
            par[1]:=parCommand[1];
            par[2]:=parCommand[2];
            par[3]:=parCommand[3];
            par[4]:=parCommand[4];
            par[5]:=false;
            par[6]:=false;
            par[7]:=false;
            par[8]:=false;
            if parCommand[5] then
            result:='RRF ' + BinToHex() + 'h, f'
            else
            result:='RRF ' + BinToHex() + 'h, W';

            end;
          end;

        end
        else
        begin //0010XXXXXXXX
          if parCommand[7] then
          begin //00101XXXXXXX
            if parCommand[6] then
            begin //001011XXXXXX
//DECFSZ  f(5),d(1)
            par[0]:=parCommand[0];
            par[1]:=parCommand[1];
            par[2]:=parCommand[2];
            par[3]:=parCommand[3];
            par[4]:=parCommand[4];
            par[5]:=false;
            par[6]:=false;
            par[7]:=false;
            par[8]:=false;
            if parCommand[5] then
            result:='DECFSZ ' + BinToHex() + 'h, f'
            else
            result:='DECFSZ ' + BinToHex() + 'h, W';

            end
            else
            begin //001010XXXXXX
//INCF f(5),d(1)
            par[0]:=parCommand[0];
            par[1]:=parCommand[1];
            par[2]:=parCommand[2];
            par[3]:=parCommand[3];
            par[4]:=parCommand[4];
            par[5]:=false;
            par[6]:=false;
            par[7]:=false;
            par[8]:=false;
            if parCommand[5] then
            result:='INCF ' + BinToHex() + 'h, f'
            else
            result:='INCF ' + BinToHex() + 'h, W';

            end
          end
          else
          begin //00100XXXXXXX
            if parCommand[6] then
            begin //001001XXXXXX
//COMF f(5),d(1)
            par[0]:=parCommand[0];
            par[1]:=parCommand[1];
            par[2]:=parCommand[2];
            par[3]:=parCommand[3];
            par[4]:=parCommand[4];
            par[5]:=false;
            par[6]:=false;
            par[7]:=false;
            par[8]:=false;
            if parCommand[5] then
            result:='COMF ' + BinToHex() + 'h, f'
            else
            result:='COMF ' + BinToHex() + 'h, W';

            end
            else
            begin //001000XXXXXX
//MOVF f(5),d(1)
            par[0]:=parCommand[0];
            par[1]:=parCommand[1];
            par[2]:=parCommand[2];
            par[3]:=parCommand[3];
            par[4]:=parCommand[4];
            par[5]:=false;
            par[6]:=false;
            par[7]:=false;
            par[8]:=false;
            if parCommand[5] then
            result:='MOVF ' + BinToHex() + 'h, f'
            else
            result:='MOVF ' + BinToHex() + 'h, W';

            end;
          end;
        end;

      end
      else
      begin //000XXXXXXXXX
        if parCommand[8] then
        begin //0001XXXXXXXX
          if parCommand[7] then
          begin  //00011XXXXXXX
            if parCommand[6] then
            begin //000111XXXXXX
//ADDWF f(5),d(1)  - это есть сложение регистров W и f
            par[0]:=parCommand[0];
            par[1]:=parCommand[1];
            par[2]:=parCommand[2];
            par[3]:=parCommand[3];
            par[4]:=parCommand[4];
            par[5]:=false;
            par[6]:=false;
            par[7]:=false;
            par[8]:=false;
            if parCommand[5] then
            result:='ADDWF ' + BinToHex() + 'h, f'
            else
            result:='ADDWF ' + BinToHex() + 'h, W';
            end
            else
            begin //000110XXXXXX
//XORWF  f(5),d(1)
            par[0]:=parCommand[0];
            par[1]:=parCommand[1];
            par[2]:=parCommand[2];
            par[3]:=parCommand[3];
            par[4]:=parCommand[4];
            par[5]:=false;
            par[6]:=false;
            par[7]:=false;
            par[8]:=false;
            if parCommand[5] then
            result:='XORWF ' + BinToHex() + 'h, f'
            else
            result:='XORWF ' + BinToHex() + 'h, W';
            end;
          end
          else
          begin  //00010XXXXXXX
          if parCommand[6] then
            begin  //000101XXXXXX
//ANDWF  f(5),d(1)
            par[0]:=parCommand[0];
            par[1]:=parCommand[1];
            par[2]:=parCommand[2];
            par[3]:=parCommand[3];
            par[4]:=parCommand[4];
            par[5]:=false;
            par[6]:=false;
            par[7]:=false;
            par[8]:=false;
            if parCommand[5] then
            result:='ANDWF ' + BinToHex() + 'h, f'
            else
            result:='ANDWF ' + BinToHex() + 'h, W';
            end
            else
            begin  //000100XXXXXX
//IORWF f(5),d(1)
            par[0]:=parCommand[0];
            par[1]:=parCommand[1];
            par[2]:=parCommand[2];
            par[3]:=parCommand[3];
            par[4]:=parCommand[4];
            par[5]:=false;
            par[6]:=false;
            par[7]:=false;
            par[8]:=false;
            if parCommand[5] then
            result:='IORWF ' + BinToHex() + 'h, f'
            else
            result:='IORWF ' + BinToHex() + 'h, W';
            end;
          end;


        end
        else
        begin //0000XXXXXXXX
          if parCommand[7] then
          begin //00001XXXXXXX
            if parCommand[6] then
            begin //000011XXXXXX
//DECF  f(5),d(1)
            par[0]:=parCommand[0];
            par[1]:=parCommand[1];
            par[2]:=parCommand[2];
            par[3]:=parCommand[3];
            par[4]:=parCommand[4];
            par[5]:=false;
            par[6]:=false;
            par[7]:=false;
            par[8]:=false;
            if parCommand[5] then
            result:='DECF ' + BinToHex() + 'h, f'
            else
            result:='DECF ' + BinToHex() + 'h, W';

            end
            else
            begin //000010XXXXXX
//SUBWF     f(5),d(1)
            par[0]:=parCommand[0];
            par[1]:=parCommand[1];
            par[2]:=parCommand[2];
            par[3]:=parCommand[3];
            par[4]:=parCommand[4];
            par[5]:=false;
            par[6]:=false;
            par[7]:=false;
            par[8]:=false;
            if parCommand[5] then
            result:='SUBWF ' + BinToHex() + 'h, f'
            else
            result:='SUBWF ' + BinToHex() + 'h, W';
            end;


          end
          else
          begin //00000XXXXXXX
            if parCommand[6] then
            begin //000001XXXXXX
              if parCommand[5] then
              begin //0000011XXXXX
//CLRF     f(5)
            par[0]:=parCommand[0];
            par[1]:=parCommand[1];
            par[2]:=parCommand[2];
            par[3]:=parCommand[3];
            par[4]:=parCommand[4];
            par[5]:=false;
            par[6]:=false;
            par[7]:=false;
            par[8]:=false;
            result:='CLRF ' + BinToHex() + 'h';
              end
              else
              begin //0000010XXXXX
//CLRW
              result:='CLRW'
              end;
            end
            else
            begin //000000XXXXXX
              if parCommand[5] then
              begin //0000001XXXXX
//MOVWF    f(5)
            par[0]:=parCommand[0];
            par[1]:=parCommand[1];
            par[2]:=parCommand[2];
            par[3]:=parCommand[3];
            par[4]:=parCommand[4];
            par[5]:=false;
            par[6]:=false;
            par[7]:=false;
            par[8]:=false;
            result:='MOVWF ' + BinToHex() + 'h';
              end
              else
              begin //0000000XXXXX
                if parCommand[4] then
                begin //00000001XXXX
                //Unknow command
                result:='unknown';
                end
                else
                begin //00000000XXXX
                  if parCommand[3] then
                  begin //000000001XXX
                  //Unknow command
                  result:='unknown';
                  end
                  else
                  begin //000000000XXX
                    if parCommand[2] then
                    begin //0000000001XX
                      if parCommand[1] then
                      begin //00000000011X
                        if parCommand[0] then
                          begin //000000000111
//!TRIS 7  - PORT?    //Unknow command
                          result:='TRIS 7';
                          end
                          else
                          begin  //000000000110
//aTRIS 6
                          result:='TRIS 6';
                          end;
                      end
                      else
                      begin //00000000010X
                        if parCommand[0] then
                        begin //000000000101
//!TRIS 5 - PORT?    //Unknow command
                        result:='TRIS 5';
                        end
                        else
                        begin //000000000100
//!CLRWDT
                        result:='CLRWDT';
                        end;




                      end;

                    end
                    else
                    begin //0000000000XX
                      if parCommand[1] then
                      begin //00000000001X
                        if parCommand[0] then
                        Begin //000000000011
//!Sleep
                        result:='SLEEP';
                        End
                        else
                        begin //000000000010
//aOPTION
                        result:='OPTION';

                        end;

                      end
                      else
                      begin //00000000000X
                        if parCommand[0] then
                        Begin //000000000001
                        //Unknow command
                        result:='unknown';
                        End
                        else
                        begin //000000000000
//aNOP
                        result:='NOP';

                        end;
                      end;
                    end;
                  end;

                end;

              end;
            end;
          end;

        end;
      end;
    end;
  end;
end;

function DecTo3Hex(Dec:cardinal):string;
var j:Cardinal;
a,b,c:byte;
res:string ;
begin
a:=0;
b:=0;
c:=0;
res:='';
for J := 1 to Dec do
  begin
    a:=a+1;
    if a=16 then
      begin
        a:=0;
        b:=b+1;
        if b=16  then
          begin
            b:=0;
            c:=c+1;
          end;
      end;
  end;

if C=0 then res:=res+'0';
if C=1 then res:=res+'1';
if C=2 then res:=res+'2';
if C=3 then res:=res+'3';
if C=4 then res:=res+'4';
if C=5 then res:=res+'5';
if C=6 then res:=res+'6';
if C=7 then res:=res+'7';
if C=8 then res:=res+'8';
if C=9 then res:=res+'9';
if C=10 then res:=res+'A';
if C=11 then res:=res+'B';
if C=12 then res:=res+'C';
if C=13 then res:=res+'D';
if C=14 then res:=res+'E';
if C=15 then res:=res+'F';

if B=0 then res:=res+'0';
if B=1 then res:=res+'1';
if B=2 then res:=res+'2';
if B=3 then res:=res+'3';
if B=4 then res:=res+'4';
if B=5 then res:=res+'5';
if B=6 then res:=res+'6';
if B=7 then res:=res+'7';
if B=8 then res:=res+'8';
if B=9 then res:=res+'9';
if B=10 then res:=res+'A';
if B=11 then res:=res+'B';
if B=12 then res:=res+'C';
if B=13 then res:=res+'D';
if B=14 then res:=res+'E';
if B=15 then res:=res+'F';

if A=0 then res:=res+'0';
if A=1 then res:=res+'1';
if A=2 then res:=res+'2';
if A=3 then res:=res+'3';
if A=4 then res:=res+'4';
if A=5 then res:=res+'5';
if A=6 then res:=res+'6';
if A=7 then res:=res+'7';
if A=8 then res:=res+'8';
if A=9 then res:=res+'9';
if A=10 then res:=res+'A';
if A=11 then res:=res+'B';
if A=12 then res:=res+'C';
if A=13 then res:=res+'D';
if A=14 then res:=res+'E';
if A=15 then res:=res+'F';
DecTo3Hex:=res;
end;
procedure resetRAM(Id:byte);

 //Здесь начальная инициализация RAM мк после сброса
Var Z:Word;
J:Byte;
begin
  if Id=0  then
  begin
  for Z := 0 to AllRAMSize do //PORT! Размер с вирт. регистрами - 35
    for j := 0 to 7 do
    begin
    RAM[Z,J]:=false; //Очистка всего
    end;
  //Установка PCL
  RAM[2,0]:=true;
  RAM[2,1]:=true;
  RAM[2,2]:=true;
  RAM[2,3]:=true;
  RAM[2,4]:=true;
  RAM[2,5]:=true;
  RAM[2,6]:=true;
  RAM[2,7]:=true;
  //Установка STATUS
  RAM[3,3]:=true;
  RAM[3,4]:=true;
  //Установка FSR
  RAM[4,7]:=true;
  RAM[4,6]:=true;
  RAM[4,5]:=true;
  //Установка OSCCAL
  RAM[5,1]:=true;
  RAM[5,2]:=true;
  RAM[5,3]:=true;
  RAM[5,4]:=true;
  RAM[5,5]:=true;
  RAM[5,6]:=true;
  RAM[5,7]:=true;
  //Установка OPTION
  RAM[regOPTION,0]:=true;
  RAM[regOPTION,1]:=true;
  RAM[regOPTION,2]:=true;
  RAM[regOPTION,3]:=true;
  RAM[regOPTION,4]:=true;
  RAM[regOPTION,5]:=true;
  RAM[regOPTION,6]:=true;
  RAM[regOPTION,7]:=true;
  //Установка TRISGPIO
  RAM[regTRISGPIO,0]:=true;
  RAM[regTRISGPIO,1]:=true;
  RAM[regTRISGPIO,2]:=true;
  RAM[regTRISGPIO,3]:=true;
  //Далее загрузка RAM в матрицу, чтобы можно было вычислить дельту, также очистка дельты
  for Z := 0 to AllRAMSize do
  begin
    matrixRAM[Z].delta:=false;
    for j := 0 to 7 do
    begin
    //MatrixRAM[Z].value[j]:=RAM[Z,J];
    MatrixRAM[Z].deltabit[j]:=false;
    end;
  end;
  end;
end;
procedure generateSimAdress();
var Z:integer;
begin
for Z := 0 to AllRAMSize do
    begin
    if MatrixRAM[Z].IDEaddres >-1 then
      begin
        MatrixRAM[MatrixRAM[Z].IDEaddres].SIMadress:=Z;
      end;
    end;
end;
procedure SelectMC(Id:byte); //Здесь все настраивается под мк конкретный
var
Z,J:integer;
begin
  if Id=0 then
  begin
//PIC10F200
  rtMCId:=0;
  ROM_Size:=256; //Количество ячеек ROM (0..255)
  SetLength(ROM,ROM_Size);
  SetLength(ROM_BP,ROM_Size+1);
  SetLength(ROM_Str_No,ROM_Size);
  SetLength(ROM_Str_No_from,ROM_Size);
  SetLength(ROM_Str_No_to,ROM_Size);
  //Биты конфигурации по-умолчанию
  Config[0]:=false;
  Config[1]:=false;
  Config[2]:=false;//Watchdog timer is disabled
  Config[3]:=true; //Code protection off
  Config[4]:=false; //GP3/\MCLR Pin function is GP3
  Config[5]:=false;
  Config[6]:=false;
  Config[7]:=false;
  Config[8]:=false;
  Config[9]:=false;
  Config[10]:=false;
  Config[11]:=false;
  //Параметры битов конфигурации
  setlength(ConfigBits,3);
  ConfigBitsCounter:=3;
  ConfigBits[0].Name:='Watchdog Timer';
  ConfigBits[0].Description:='Option enables or disables the watchdog timer';
  ConfigBits[0].No:=2;
  ConfigBits[0].Value0:='Disabled';
  ConfigBits[0].Value1:='Enabled';
  ConfigBits[1].Name:='Code Protection';
  ConfigBits[1].Description:='Option enables or disables the code protection';
  ConfigBits[1].No:=3;
  ConfigBits[1].Value0:='Enabled';
  ConfigBits[1].Value1:='Disabled';
  ConfigBits[2].Name:='GP3/\MCLR Pin function';
  ConfigBits[2].Description:='GP3/\MCLR Pin function';
  ConfigBits[2].No:=4;
  ConfigBits[2].Value0:='GP3';
  ConfigBits[2].Value1:='\MCLR';
  //8-битная система команд
  SystemCommandCounter:=33; //Количество команд ассемблера
  SetLength(SystemCommand,SystemCommandCounter);
  SystemCommand[0].CommandName:='XORLW';
  SystemCommand[1].CommandName:='ANDLW';
  SystemCommand[2].CommandName:='IORLW';
  SystemCommand[3].CommandName:='MOVLW';
  SystemCommand[4].CommandName:='GOTO';
  SystemCommand[5].CommandName:='CALL';
  SystemCommand[6].CommandName:='RETLW';
  SystemCommand[7].CommandName:='BTFSS';
  SystemCommand[8].CommandName:='BTFSC';
  SystemCommand[9].CommandName:='BSF';
  SystemCommand[10].CommandName:='BCF';
  SystemCommand[11].CommandName:='INCFSZ';
  SystemCommand[12].CommandName:='SWAPF';
  SystemCommand[13].CommandName:='RLF';
  SystemCommand[14].CommandName:='RRF';
  SystemCommand[15].CommandName:='DECFSZ';
  SystemCommand[16].CommandName:='INCF';
  SystemCommand[17].CommandName:='COMF';
  SystemCommand[18].CommandName:='MOVF';
  SystemCommand[19].CommandName:='ADDWF';
  SystemCommand[20].CommandName:='XORWF';
  SystemCommand[21].CommandName:='ANDWF';
  SystemCommand[22].CommandName:='IORWF';
  SystemCommand[23].CommandName:='DECF';
  SystemCommand[24].CommandName:='SUBWF';
  SystemCommand[25].CommandName:='CLRF';
  SystemCommand[26].CommandName:='CLRW';
  SystemCommand[27].CommandName:='MOVWF';
  SystemCommand[28].CommandName:='TRIS';
  SystemCommand[29].CommandName:='CLRWDT';
  SystemCommand[30].CommandName:='SLEEP';
  SystemCommand[31].CommandName:='OPTION';
  SystemCommand[32].CommandName:='NOP';

  // 2-ух уровневый стек
  stMax:=1;
  // Частота кварца по умолчанию
  rtCrystalFreq:=4000000; //4 Мгц
  // Кол-во тактов для переполнения WDT (без предделителя)
  rtTaktsWDT:=10000;
  //Общее кол-во GPR u SFR
  SFRCount:=11;
  GPRCount:=16;
  AllRAMSize:=35;
  //Задание размера RAM где 0..31 - GPR и SFR 32 - W,33 - OPTION,34=TRISGPI0,35-TMR0 Prescaler
  setlength(RAM,AllRAMSize+1,8);
  //Задание размера матрицы в/д
  setlength(MatrixRAM,AllRAMSize+1);
  //Задание адресов спец. виртуальных регистров
  regINDF:=0;
  regW:=32;
  regOPTION:=33;
  regTRISGPIO:=34;
  regTMR0P:=35;
  //По-умолчанию, каждый бит, даже в неиспользуемом регистре используется
  //А также, по-умолчанию имя бита равно пусто
  for Z := 0 to AllRAMSize do
    for j := 0 to 7 do
    begin
      MatrixRAM[Z].usedbit[j]:=true;
    //  MatrixRAM[Z].bitname[j]:='';
    end;
  //0 в RAM 1 в SFR
  //INDF
  MatrixRAM[0].Used:=true;
  MatrixRAM[0].SFR:=true;
  MatrixRAM[0].VirtSFR:=false;
  MatrixRAM[0].IDEName:='INDF';
  MatrixRAM[0].IDEHexaddres:='000';
  MatrixRAM[0].IDEaddres:=1;
  //1 в RAM 2 в SFR
  //TMR0
  MatrixRAM[1].Used:=true;
  MatrixRAM[1].SFR:=true;
  MatrixRAM[1].VirtSFR:=false;
  MatrixRAM[1].IDEName:='TMR0';
  MatrixRAM[1].IDEHexaddres:='001';
  MatrixRAM[1].IDEaddres:=2;

  //2 в RAM 3 в SFR
  //PCL
  MatrixRAM[2].Used:=true;
  MatrixRAM[2].SFR:=true;
  MatrixRAM[2].VirtSFR:=false;
  MatrixRAM[2].IDEName:='PCL';
  MatrixRAM[2].IDEHexaddres:='002';
  MatrixRAM[2].IDEaddres:=3;
  //3 в RAM 4 в SFR
  //STATUS
  MatrixRAM[3].Used:=true;
  MatrixRAM[3].usedbit[5]:=false;
  MatrixRAM[3].usedbit[6]:=false; //Port!
  MatrixRAM[3].SFR:=true;
  MatrixRAM[3].VirtSFR:=false;
  MatrixRAM[3].IDEName:='STATUS';
  MatrixRAM[3].IDEHexaddres:='003';
  MatrixRAM[3].IDEaddres:=4;
  MatrixRAM[3].bitname[7]:='GPWUF';
// Port!  MatrixRAM[3].bitname[6]:='CWUF';
  MatrixRAM[3].bitname[4]:='\TO';
  MatrixRAM[3].bitname[3]:='\PD';
  MatrixRAM[3].bitname[2]:='Z';
  MatrixRAM[3].bitname[1]:='DC';
  MatrixRAM[3].bitname[0]:='C';


  //4 в RAM 5 в SFR
  //FSR
  MatrixRAM[4].Used:=true;
  MatrixRAM[4].SFR:=true;
  MatrixRAM[4].VirtSFR:=false;
  MatrixRAM[4].IDEName:='FSR';
  MatrixRAM[4].IDEHexaddres:='004';
  MatrixRAM[4].IDEaddres:=5;
  //5 в RAM 6 в SFR
  //OSCCAL
  MatrixRAM[5].Used:=true;
  MatrixRAM[5].SFR:=true;
  MatrixRAM[5].VirtSFR:=false;
  MatrixRAM[5].IDEName:='OSCCAL';
  MatrixRAM[5].IDEHexaddres:='005';
  MatrixRAM[5].IDEaddres:=6;
  MatrixRAM[5].bitname[7]:='CAL6';
  MatrixRAM[5].bitname[6]:='CAL5';
  MatrixRAM[5].bitname[5]:='CAL4';
  MatrixRAM[5].bitname[4]:='CAL3';
  MatrixRAM[5].bitname[3]:='CAL2';
  MatrixRAM[5].bitname[2]:='CAL1';
  MatrixRAM[5].bitname[1]:='CAL0';
  MatrixRAM[5].bitname[0]:='FOSC4';
  //6 в RAM 7 в SFR
  //GPIO
  MatrixRAM[6].Used:=true;
  MatrixRAM[6].SFR:=true;
  MatrixRAM[6].VirtSFR:=false;
  MatrixRAM[6].IDEName:='GPIO';
  MatrixRAM[6].IDEHexaddres:='006';
  MatrixRAM[6].IDEaddres:=7;
  MatrixRAM[6].usedbit[7]:=false;
  MatrixRAM[6].usedbit[6]:=false;
  MatrixRAM[6].usedbit[5]:=false;
  MatrixRAM[6].usedbit[4]:=false;
  MatrixRAM[6].bitname[3]:='GP3';
  MatrixRAM[6].bitname[2]:='GP2';
  MatrixRAM[6].bitname[1]:='GP1';
  MatrixRAM[6].bitname[0]:='GP0';
  //7-15 в RAM Unimplemented
  for Z:= 7 to 15 do
    begin
     MatrixRAM[Z].Used:=false;
     MatrixRAM[Z].SFR:=false;
     MatrixRAM[Z].VirtSFR:=false;
     MatrixRAM[Z].IDEName:='';
     MatrixRAM[Z].IDEHexaddres:='';
     MatrixRAM[Z].IDEaddres:=-1;
    end;
  //16-31 В RAM GPR
  J:=-1;
  for Z := 16 to 31 do
    begin
    inc(J);
     MatrixRAM[Z].Used:=true;
     MatrixRAM[Z].SFR:=false;
     MatrixRAM[Z].VirtSFR:=false;
     MatrixRAM[Z].IDEName:='';
     MatrixRAM[Z].IDEHexaddres:=DecTo3Hex(Z);
     MatrixRAM[Z].IDEaddres:=11+J;
    end;

  //REGW (32) в RAM 0 в SFR

  MatrixRAM[REGW].Used:=true;
  MatrixRAM[REGW].SFR:=true;
  MatrixRAM[REGW].VirtSFR:=true;
  MatrixRAM[REGW].IDEName:='W';
  MatrixRAM[REGW].IDEHexaddres:='W';
  MatrixRAM[REGW].IDEaddres:=0;
  //regOPTION (33) в RAM 8 в SFR

  MatrixRAM[regOPTION].Used:=true;
  MatrixRAM[regOPTION].SFR:=true;
  MatrixRAM[regOPTION].VirtSFR:=true;
  MatrixRAM[regOPTION].IDEName:='OPTION';
  MatrixRAM[regOPTION].IDEHexaddres:='n/a';
  MatrixRAM[regOPTION].IDEaddres:=8;


  //regTRISGPIO (34) в RAM 9 в SFR

  MatrixRAM[regTRISGPIO].Used:=true;
  MatrixRAM[regTRISGPIO].SFR:=true;
  MatrixRAM[regTRISGPIO].VirtSFR:=true;
  MatrixRAM[regTRISGPIO].IDEName:='TRISGPIO';
  MatrixRAM[regTRISGPIO].IDEHexaddres:='n/a';
  MatrixRAM[regTRISGPIO].IDEaddres:=9;
  MatrixRAM[regTRISGPIO].usedbit[7]:=false;
  MatrixRAM[regTRISGPIO].usedbit[6]:=false;
  MatrixRAM[regTRISGPIO].usedbit[5]:=false;
  MatrixRAM[regTRISGPIO].usedbit[4]:=false;
  MatrixRAM[regTRISGPIO].usedbit[3]:=false;

  //TMR0 Prescaler (35) в RAM 9 в SFR

  MatrixRAM[regTMR0P].Used:=true;
  MatrixRAM[regTMR0P].SFR:=true;
  MatrixRAM[regTMR0P].VirtSFR:=true;
  MatrixRAM[regTMR0P].IDEName:='TMR0 Prescaler';
  MatrixRAM[regTMR0P].IDEHexaddres:='n/a';
  MatrixRAM[regTMR0P].IDEaddres:=10;


  end;
  if ID=1  then
  begin
//PIC10F202
  end;
  resetRAM(Id);
  generateSimAdress();
end;

procedure ByteToBinInCD(X:Byte);
var a1,a2,a3,a4,a5,a6,a7,y:byte;
begin
a7:=X div 128;
if a7=0 then   СhangeData[7]:=false else   СhangeData[7]:=true;
y:=X-(a7*128);

a6:= y div 64;
if a6=0 then   СhangeData[6]:=false else   СhangeData[6]:=true;
y:=y-(a6*64);

a5:= y div 32;
if a5=0 then   СhangeData[5]:=false else   СhangeData[5]:=true;
y:=y-(a5*32);

a4:= y div 16;
if a4=0 then   СhangeData[4]:=false else   СhangeData[4]:=true;
y:=y-(a4*16);

a3:= y div 8;
if a3=0 then   СhangeData[3]:=false else   СhangeData[3]:=true;
y:=y-(a3*8);

a2:= y div 4;
if a2=0 then   СhangeData[2]:=false else   СhangeData[2]:=true;
y:=y-(a2*4);

a1:= y div 2;
if a1=0 then   СhangeData[1]:=false else   СhangeData[1]:=true;
y:=y-(a1*2);

if y=0 then   СhangeData[0]:=false else   СhangeData[0]:=true;

end;
end.
