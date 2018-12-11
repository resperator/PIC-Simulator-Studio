unit CHILDWIN;

interface

uses Windows, Classes, Graphics, Forms, Controls, StdCtrls, ComCtrls, SysUtils, Dialogs,UnitFormat,
  RVStyle, RVScroll, RichView, RVEdit, Vcl.ImgList, Vcl.ExtCtrls,theadRefresh,RVTypes,unitres,
  Vcl.Menus;

type TArrayOfLinks = record   //Для дизассемблера
  lnkNo:integer;
  lnkAddr:integer;
end;
type TArrayOfBP = record //Для Break Points
  possiblyBP: boolean; //Возможна ли вообще тут брякпоинт
  BP: boolean ; //Установлена ли BP сдесь?
end;
type TArrayOfCaD = record    //Для компилятора
   str:string;
   isLabel:boolean; //Метка (но не после GOTO и т.п.)
   isDigit:boolean; //Число
   isInstruction:boolean; //Инструкция
   isDirective:boolean;  //Директива ассемблера
   isCorrectVarOrLabel:boolean; //Корректная запись, для метки или переменной перед EQU
   isFN:boolean; //Флаг назначения после запятой
   isNoBit:boolean; //Номер бита после запятой
   isError:boolean; //Ошибка
   TypeDigth:integer; //Тип числа
   txtStart:integer; //Стартовая позиция - устар.
   txtLong:integer; //Продолжительность  - устар.
   ItemNo:integer; //Номер Итемы  - новое
   DigitDecValue:integer; //Десятичное значения (для числа)
end;
type TArrayOfLabels = record
  Name:string;
  Addr:integer;
end;
type TArrayOfLinkLinker = record //Для линкера
  Tupe:integer; //0 - GOTO; 1-CALL
  Addr:integer;
  Name:string;
  item:integer; //Итема параметра
  pParStart:integer; //Начальная позиция для выделения параметра
  pParLen:integer; //Протяженность параметра
end;
type TArrayOfEQUs = record //Массив X EQU Y
  Name:string;
  DecVal:integer;
end;
type
  TMDIChild = class(TForm)
    RVE: TRichViewEdit;
    RVS_RVE: TRVStyle;
    RV: TRichView;
    RVS_RV: TRVStyle;
    RVbp: TRichView;
    IL_Bullet: TImageList;
    TmrRefresh: TTimer;
    TimerSyntax: TTimer;
    ppmAsmEditor: TPopupMenu;
    Cut1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);

    procedure FormCreate(Sender: TObject);

    procedure RVEChange(Sender: TObject);
    procedure RVEVScrolled(Sender: TObject);
    procedure RVbpClick(Sender: TObject);
    procedure RVClick(Sender: TObject);
    procedure RVbpRVMouseUp(Sender: TCustomRichView; Button: TMouseButton;
      Shift: TShiftState; ItemNo, X, Y: Integer);
    procedure RVbpRVMouseDown(Sender: TCustomRichView; Button: TMouseButton;
      Shift: TShiftState; ItemNo, X, Y: Integer);
    procedure TmrRefreshTimer(Sender: TObject);
    procedure TimerSyntaxTimer(Sender: TObject);
    procedure RVEPaste(Sender: TCustomRichViewEdit; var DoDefault: Boolean);
    procedure RVEKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure RVEKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);



  private
    function IsDigth(str:string):integer;
    { Private declarations }
  public
    { Public declarations }
  procedure MarkAllLine(item:integer; checkAutoCheck:boolean); //Промаркировать всю строку
  procedure DisAssembley(); //Дизассемблировать ROM?
  procedure CheckSyn();// Проверить синтаксис всей проги
  procedure CheckSynLine(ItemNo:Integer; vMark:boolean=true;vMarkError:boolean=false;vErrStart:integer=-1;vErrLen:integer=-1); //Проверить синтаксис строки
  Function CompileAll():boolean; //Компилировать все
  function LinkAll():boolean; //Линковать все
  function AssembleyInstruction(indx:integer):boolean; //Ассемблерировать инструкцию
  procedure MarkTextInRT(Start:integer;Len:integer;CheckAutoCheck:boolean;TypeTXT:byte);//Пометить текст, в соответствии с тем, что это
  procedure OnResize; //Вызывается, чтобы выравнять RV & RVE
  procedure OnType(Paste:boolean=false;StartLine:integer=-1;EndLine:integer=-1); //Вызывается при вводе
  procedure SyncCountRowsAndBP; //Синхронизировать слева номера строк и брякпоинтов
//  function IsCommand(Str:string):integer;
   var ProgramSizeInWord:integer;
   varPaste:boolean;
   varPasteLn:integer;
   alload: boolean;
   markmask:string;
   tableofLinks:array of TArrayOfLinks;  //Для дизассемблера
   tablelinkscount:integer;

   aCaD: array of TArrayOfCaD;  //Для ассемблера (компилятора)
   aInd: integer;

   possiblyBP:boolean; //Для CheckLineSyn

   itmMD:integer; //на каую итему нажали мышкой в поле BP

//   aBP: array of TArrayOfBP;
//   aBPind: integer;

   Can_Restore_img_in_BP:boolean;
   img_ind_BP:integer;
   item_to_rest_BP:integer;

   TimerSyntaxStart:boolean;

   aDecVal: integer;
   aLbls: array of TArrayOfLabels;
   aLblsCount :integer;
   aLL: array of TArrayOfLinkLinker;  //Для линкера
   aLLCount: integer;
   CurCom:array[0..11] of boolean; //Текущая команда для компилятора
   autoCheck:boolean; //Автоматическая проверка синтаксиса, по изменению текста
   aEquS:array of TArrayOfEQUs; //Массив переменных в EQU
   aEquSCount:integer; //Счетчик для массива переменных в EQU

   aAddres:integer; //Во время компиляции - адрес текущей компилируемой команды, после - конечный адрес
  end;

//const DebugTextEditor:boolean=true;


implementation
uses main;
{$R *.dfm}




procedure TMDIChild.MarkAllLine(item:integer; checkAutoCheck:boolean);
label lblOtbrNachalo,lblexit;

var I,Z,J,Ln:integer;
LastSel,ItemCout,tmp:integer;
//
sI,eI,LineNo,Loffs,Itm,FirstLen,popr,tI:integer;
//
lc:string[1];
begin
if checkAutoCheck and not autocheck then exit;
alload:=false; //чтобы не вызывало еще раз событие
popr:=0;
Ln:=Length(markmask)+1;
ItemCout:=rve.ItemCount;
if ln=1  then goto lblexit;
//
GetAllLineFromItem(rve,item,0,sI,eI,LineNo,Loffs);
//
lc:=markmask[Ln-1];
LastSel:=Ln;

// Если первый - таб или простая пустая строка, отметим его и удалим из обработки
Item:=eI;
lblOtbrNachalo:
//
if Item<sI then goto lblexit;

//
if rve.GetItemText(item)='' then
  begin
 // rve.setit
  item:=item-1;

  goto lblOtbrNachalo;
  end;

for J := eI downto sI do
  begin
  tI:=Length(rve.GetItemText(J));
  if rve.GetItemStyle(J)=rvsTab then Ln:=Ln-1;

    for Z :=tI  downto 1 do
      begin
      Ln:=Ln-1;
      if ln=0 then
goto lblexit;
      if lc<>markmask[Ln]  then
        begin
          rve.SetSelectionBounds( J,Z+1,J,tI+1);
          rve.ApplyTextStyle(ord(lc[1]));
          tI:=Z; //I+1
          lc:=markmask[Ln];
        end;
      end;
  if tI>=1 then
  begin
   rve.SetSelectionBounds( J,1,J,tI+1);
   rve.ApplyTextStyle(ord(lc[1]));
  end;
  end;


{
FirstLen:=length(rve.GetItemText(item));
for I := Ln downto 1 do
  begin
  if I=(X-1) then ItemCout:=rve.ItemCount;

  if lc<>markmask[I] then
    begin
      rve.SetSelectionBounds( Item,I+1,Item,LastSel+1);
      rve.ApplyTextStyle(ord(lc[1]));
      LastSel:=I; //I+1
      lc:=markmask[I];
      if FirstLen<=Ln-I-popr  then
      begin
      popr:= length(rve.GetItemText(item));
      item:=item-2;
      FirstLen:=length(rve.GetItemText(item));

      end;

    end;
  end;

if LastSel>1 then
  begin
   rve.SetSelectionBounds( Item,1,Item,LastSel+1);
      rve.ApplyTextStyle(ord(lc[1]));
  end;  }
lblexit:
  {if RestoreCursorPos then
  begin
   tmp:=ItemCout-rve.ItemCount;
//   if tmp<0 then tmp:=0 ;

   for I := item to item-tmp-1 do X:=X-Length(rve.GetItemText(I));

   rve.setSelectionBounds(Item-tmp,X,Item-tmp,X);
  end;   }

{itmPP:=0;
if ln=0 then exit;
lc:=markmask[1];
lcI:=0;
for I := 1 to Ln do
  begin
  if Lc<>markmask[I] then
    begin
    rve.SetSelectionBounds(Item+itmPP,0,Item+itmPP,I-lci+1);
    rve.ApplyTextStyle(ord(lc[1]));
    if I<=Ln then lc:=markmask[I];
    itmPP:=itmPP+1;
    lcI:=i;
    rve.Format;
    end;

  end; }

AlLoad:=true;
end;

procedure TMDIChild.OnResize;

begin
  rvbp.Left:=-4;
  rvbp.Top:=0;
  rv.Left:=0;
  rv.Top:=0;

  rve.Height:=clientheight;
  rve.Width:=clientwidth-rve.Left;
  rvbp.VScrollPos:=rve.VScrollPos;
  rv.VScrollPos:=rve.VScrollPos;
  rv.ClientHeight:=rve.ClientHeight; //На случай, если горизонтальный ScrollBar появиться
  rvbp.ClientHeight:=rv.ClientHeight; //-
end;

procedure TMDIChild.OnType(Paste:boolean=false;StartLine:integer=-1;EndLine:integer=-1);
var
sIt,I:integer;

vScrollPos,hScrollPos:integer; //Положение скроллеров на начало проверки

begin

alload:=false;



vScrollPos:=rve.VScrollPos;
hScrollPos:=rve.hScrollPos;
main.MainForm.AsmChild.RVE.BeginUpdate;

//Слева синхронизируем все
SyncCountRowsAndBP;

//ItemFromLine:=Find_Item_From_Line(main.MainForm.AsmChild.RVE,LineToCheck);
//Происходит проверка строки
sIt:=main.MainForm.AsmChild.RVE.CurItemNo;
RememberCursorPos();

if not Paste then
  begin
  main.MainForm.AsmChild.CheckSynLine( sIt);
  end
else
  begin
  for I := StartLine to EndLine do
    begin
      main.MainForm.AsmChild.CheckSynLine(Find_Item_From_Line(rve,I));
    end;
  end;
//Восстановим курсор
RestoreCursorPos();



//RVE.Format;

rve.VScrollPos:=vScrollPos;
rve.hScrollPos:=hScrollPos;
rv.VScrollPos:=vScrollPos;
rvbp.VScrollPos:=vScrollPos;

RVE.EndUpdate;
alload:=true;

end;

procedure TMDIChild.MarkTextInRT(Start:integer;Len:integer;CheckAutoCheck:boolean;TypeTXT:byte);
var
  New_markmask:string;
  I,Ln:integer;
begin
  if checkAutoCheck and not autocheck then exit;
  New_markmask:=copy(markmask,1,Start);
  for I := 1 to len do New_markmask:=New_markmask+chr(TypeTXT);
  Ln:=Length(markmask);
  New_markmask:=New_markmask+copy(markmask,Start+Len+1,ln-Start-Len);
  markmask:=New_markmask;
end;

function GetAllLineFromItem(RV:TCustomRichView; Item:integer; var StartItem,EndItem,LineNo:integer):string;
label
lblToRight, LblToLeft, lblToRightStart, LblGotText;
var tmpLineNo, tmpI, MaxItem:integer;
ResultS:string;
begin
//Определим строку данной итемы
LineNo:=RV.GetLineNo(Item,0);
//Будем искать еще итемы на данной строке
//Сперва на убывание
tmpI:=Item;
lblToLeft:
StartItem:=tmpI;
tmpI:=tmpI-1;
if tmpI<0 then goto lblToRightStart;
if rv.getlineno(tmpI,0)=LineNo then goto lblToLeft;
//Теперь ищем на возрастание
lblToRightStart:
MaxItem:=rv.ItemCount-1;
tmpI:=item;
lblToRight:
EndItem:=tmpI;

tmpI:=tmpI+1;
if tmpI>MaxItem then goto LblGotText;
if rv.getlineno(tmpI,0)=LineNo then goto lblToRight;
//Теперь соберем текст
LblGotText:
resultS:='';
for tmpI := StartItem to EndItem do
  begin
   Results:=ResultS+rv.GetItemText(tmpI);
   if rv.GetItemStyle(tmpI)=rvsTab  then Results:=ResultS+#9;

  end;
result:=results;



end;

function IsCommand(Str:string):integer;  //Функция проверки на комманду
var tI,Scc:Integer;
CurCom:shortstring;
begin
IsCommand:=-1;
Scc:=Get_SystemCommandCounter();
  for tI:=1 to Scc do
  begin
    CurCom:=Get_SystemCommand_CommandName(tI-1);
      if CurCom=str then
        begin
          result:=tI-1;
          exit;
        end;
  end;
end;
function IsDirective(str:string):integer; //Функция проверки на директиву ассемблера
begin
  isDirective:=-1 ;
  if str='EQU' then result:=1;

end;

function isFlagDest(str:string):integer;
 //Функция проверки на флаг назначения
var tI:integer;
begin
  isFlagDest:=-1;
//Удалим все пробелы
for tI := 1 to Length(str) do if (str[tI]=#9) or (str[tI]=#32) then delete(str,tI,1);

str:=AnsiUpperCase(str); //Переведем строку в верхний регистр
if length(str)=1 then //Размер должен быть равен 1
  begin
  if (str[1]='F') or (str[1]='1') then
    begin
      result:=1;
      exit;
    end;
  if (str[1]='W') or (str[1]='0')  then
    begin
       result:=0;
       exit;
    end;


  end;

end;

function isNoBit(str:string):boolean;
 //Функция проверки на бит назначения
var tI:integer;
tA:AnsiChar;
tS:string[1];
begin
  isNoBit:=false;
//Удалим все пробелы
for tI := 1 to Length(str) do if (str[tI]=#9) or (str[tI]=#32) then delete(str,tI,1);

str:=AnsiUpperCase(str); //Переведем строку в верхний регистр
if length(str)=1 then //Размер должен быть равен 1
  begin
  ts:=copy(str,1,1); //Копируем начальный символ
  ta:=ts[1];
  tI:=ord(tA);
  if ((tI>47) and (tI<56)) then result:=true;


  end;

end;

function IsCorrectVarOrLabel(str:string):boolean;
var
tS:string[1];
tA:AnsiChar;
tZ,tI:integer;
begin
tS:=copy(str,1,1); //Метка должна начинаться с буквы
tA:=tS[1];
tI:=ord(tA);
result:=false;
if ((tI>64) and (tI<91)) or ((tI>96) and (tI<123)) or ((tI>192) and (tI<256))  then
  begin
  for tZ := 2 to length(str) do
    begin
      tS:=copy(str,tZ,1); //Метка должна продолжаться буквой или цифрой
      tA:=tS[1];
      tI:=ord(tA);
      if ((tI>64) and (tI<91))
      or ((tI>96) and (tI<123))
      or ((tI>192) and (tI<256))
      or  ((tI>47) and (tI<58))
      then
        else
        begin
           //Некорректная метка - в составе есть еще что-то (выделяем)
          result:=false;
          exit;
        end;
    end;
    result:=true; //А вот тут, корректная
  end;
end;
function TMDIChild.IsDigth(str:string):integer; //Функция проверки на числовое значение
var len,tmpI,tmpOrd:integer;
label l1,l2,l3,l4;
begin
IsDigth:=-1;
len:=Length(STR);
aDecVal:=0;
//Проверка на шестнадцатиричность вида 0x1F
if (len>2) and (len<9) then //Длина строки от 3-х сиволов т.е. напр. 0x1 ну и не более 8, напр 0xFFFFFF
  if str[1]='0' then //Первый должен быть 0
    if str[2]='X' then //Потом должен идти "икс"
    begin
    for tmpI := len downto 3 do
      begin
        tmpOrd:=ord(STR[tmpI]);
         if not (((tmpOrd>47) and (tmpOrd<58)) or ((tmpOrd>64) and (tmpOrd<71))) then  //Проверка, а вдруг какой-нит символ не 0123456789ABCDEF
         goto l1 //Нет
      end;
      //Все решено это hex!!!
      aDecVal:=HexToInt(copy(str,3,len-2));

      result:=3;
      exit;
    end;
l1:

//Проверка на шестнадцатиричность вида F1Ah
if (len>1) and (len<8) then //Длина строки от 2-х сиволов т.е. напр. 1h ну и не более 7, напр FFFFFFh
  if str[len]='H' then //Должно заканчиваться на символ "Аш"
  begin
    for tmpI := 1 to len-1 do
      begin
      tmpOrd:=Ord(Str[tmpI]);
      if not (((tmpOrd>47) and (tmpOrd<58)) or ((tmpOrd>64) and (tmpOrd<71))) then  //Проверка, а вдруг какой-нит символ не 0123456789ABCDEF
      goto l2 //Нет
      end;
    //Все решено это hex!!!
    aDecVal:=HexToInt(copy(str,1,len-1));
    result:=3;
    exit;
  end;
l2:
//Проверка на десятичность вида 12953
if (len<7) then //Длина строки  не более 7
begin
 for tmpI := 1 to len do
      begin
      tmpOrd:=Ord(Str[tmpI]);
      if not ((tmpOrd>47) and (tmpOrd<58))  then  //Проверка, а вдруг какой-нит символ не 0123456789
      goto l3; //Нет
      end;
    //Все решено это dec!!!
    aDecVal:=strToInt(copy(str,1,len));
    result:=1;
    exit;
end;

l3:
//Проверка на двоичность вида 011101b
if (len>1) and (len<21) then //Длина строки от 2-х символов т.е. напр 1b и не более 20
  if True then
    if str[len]='B' then //Должно заканчиваться на символ "Бэ"
    begin
    for tmpI := 1 to len-1 do
      begin
      tmpOrd:=Ord(Str[tmpI]);
      if not ((tmpOrd>47) and (tmpOrd<50))  then  //Проверка, а вдруг какой-нит символ не 0123456789ABCDEF
      goto l4; //Нет
      end;
    //Все решено это бин!!!
    aDecVal:=BinToInt(copy(str,1,len-1));

    result:=2;
    exit;
    end;
l4:


end;

//procedure TMDIChild.CheckSynLine(str:String; StartPos:integer);
procedure TMDIChild.CheckSynLine(ItemNo:Integer; vMark:boolean=true;vMarkError:boolean=false;vErrStart:integer=-1;vErrLen:integer=-1);
var pComment,pMet,LenStr,pPlus:integer;
tS:string[1];
tA:AnsiChar;
tI,tZ:integer;
zpt:boolean;
StartItem,EndItem,LineNo:integer;
ItemOffs:integer;//Смещение Item
str:string; //Строка для обработки
label lMet,lOther, lOther2,lblSex,lblExit;  //Метки
begin
//if vMark then alload:=false; //чтобы не вызывало еще раз событие
possiblyBP:=false; //Возможна ли брякпоинт - на всякий случай, нет!
Str:=GetAllLineFromItem(rve,ItemNo,StartItem,EndItem,LineNo); //Получим строку и начальную и конечную итему

LenStr:=Length(str); //В переменную длину строки
//Задание начальной маски
if vMark then
begin
markmask:='';
for tI := 1 to LenStr do markmask:=markmask+chr(1);
end;

pPlus:=0; //Еще ничего с начала не удалили
setlength(acad,0);
aind:=0;

//Снимаем все атрибуты у текста, объединяем всю строку в одну итему
//MarkTextInRT(
//rve.SetSelectionBounds(StartItem,0,EndItem,rve.GetOffsAfterItem(EndItem));
//rve.ApplyTextStyle(1);

//Переведем все в верхний регистр
str:=AnsiUpperCase(str);
//Обработчик комментария
pComment:=pos(';',str); //Поиск комментария в строке
if pComment=0 then goto lMet; //Если нет, то перейти к поиску метки
//Выделим комент
if vMark then MarkTextInRT( pComment-1,LenStr-pComment+1,true,2);

Delete(Str,pComment,LenStr-pComment+1); //Удалить коммент из дальнейшей обработки
LenStr:=Length(str); //В переменную длину уже новой строки

//Обработчик метки
lMet:
if str='' then goto lblExit;//Проверка, а не пуста ли строка, а если да, то выходим
ts:=copy(str,1,1); //Копируем начальный символ
if (ts=#9) or (ts=#32) then //Проверяем, а не пробел или не таб ли это,
    begin
    delete(str,1,1); //если да - то удалим нах
    pPlus:=pPlus+1;     //Приплюсуем добавочную поправку
    goto lMet;            //И повторим проверку
    end;
pMet:=pos(':',str); //Поиск метки в строке
if pMet=0 then goto lOther; //Если нет, то перейти к поиску остального
tS:=copy(str,1,1); //Метка должна начинаться с буквы
tA:=tS[1];
tI:=ord(tA);
if ((tI>64) and (tI<91)) or ((tI>96) and (tI<123)) or ((tI>192) and (tI<256))  then
  begin
  for tZ := 2 to pMet-1 do
    begin
      tS:=copy(str,tZ,1); //Метка должна продолжаться буквой или цифрой
      tA:=tS[1];
      tI:=ord(tA);
      if ((tI>64) and (tI<91))
      or ((tI>96) and (tI<123))
      or ((tI>192) and (tI<256))
      or  ((tI>47) and (tI<58))
      then
        else
        begin
           //Некорректная метка - в составе есть еще что-то (выделяем)
           aInd:=aInd+1;
            SetLength(aCaD,aInd);
            aCad[aInd-1].str:=Copy(str,1,pMet);
            aCad[aInd-1].isError :=true;
            aCad[aInd-1].isLabel:=true;
            aCad[aInd-1].txtStart:=pPlus; //Начальная позиция для выделения
            aCad[aInd-1].txtLong:=pMet;  //Конечная позиция для выделения
      //Выделяем
        if vMark then MarkTextInRT(aCad[aInd-1].txtStart,aCad[aInd-1].txtLong,true,3);

        end;
    end;
    //А вот тут корректная
      //Занесем в "протокол"
      aInd:=aInd+1;
      SetLength(aCaD,aInd);
      aCad[aInd-1].str:=Copy(str,1,pMet);
      aCad[aInd-1].isLabel:=true;
      aCad[aInd-1].txtStart:=pPlus; //Начальная позиция для выделения
      aCad[aInd-1].txtLong:=pMet;  //Конечная позиция для выделения
      //Выделяем

      if vMark then MarkTextInRT(aCad[aInd-1].txtStart,aCad[aInd-1].txtLong,true,3);



      Delete(str,1,pMet);
      LenStr:=Length(str); //В переменную длину уже новой строки
      pPlus:=pPlus+pMet;


  end
  else
  begin
  //Некорректная метка - в начале цифра или еще что-то
    if vMark then MarkTextInRT(pPlus,pMet,true,0);
    goto lblexit;
  end;


//Поиск команд,директив ассемблера а также чисел
lOther:

if (Copy(str,LenStr,1)<>#32) and (Copy(str,LenStr,1)<>#9) then Str:=Str+' ';//Добавление пробела в конец, если нету
LenStr:=Length(str); //В переменную длину уже новой строки

lOther2:
 // Удаление пробелов с начала, если есть
if (copy(str,1,1)=#9) or (copy(str,1,1)=#32) then
  begin
    Delete(Str,1,1);
    pPlus:=pPlus+1;
    goto lOther2;
  end;

for tZ := 1 to LenStr do
  begin
  ts:=copy(str,tZ,1);


    if (ts=#9) or (ts=#32) or (ts=#44)   then // Поиск таба или пробела или запятой
      begin
      aInd:=aInd+1;
      SetLength(aCaD,aInd);
      aCad[aInd-1].str:=Copy(str,1,tZ-1);
      aCad[aInd-1].ItemNo:=ItemNo; //#Add
      //Проверка, что же это?
      if zpt=true then //Проверка на флаг назначения и номер бита, если в пред. была запятая
        begin
          zpt:=false;
           aCad[aInd-1].isNoBit:=isNoBit(aCad[aInd-1].str);
           if isFlagDest(aCad[aInd-1].str)>-1 then
            begin   //Да, это есть флаг назначения
            aCad[aInd-1].isFN:=true;
            aCad[aInd-1].txtStart:=pPlus;  //Начальная позиция для выделения
            aCad[aInd-1].txtLong:=tZ-1;//Конечная позиция для выделения
            if vMark then MarkTextInRT(aCad[aInd-1].txtStart,aCad[aInd-1].txtLong,true,4);



            goto lblSex;
            end
            else
            begin  //Нет, это ерунда какая-то
            //Но может все-таки ранее определили за номер бита?
            if not aCad[aInd-1].isNoBit then
            begin
            aCad[aInd-1].isError:=true;
            aCad[aInd-1].txtStart:=pPlus;  //Начальная позиция для выделения
            aCad[aInd-1].txtLong:=tZ-1;//Конечная позиция для выделения
            if vMark then MarkTextInRT(aCad[aInd-1].txtStart,aCad[aInd-1].txtLong,true,0);

            goto lblsex;
            end;
            end;
        end;

      if IsCommand(aCad[aInd-1].str)>-1 then //Проверка на команду
        begin //Да, команда
         aCad[aInd-1].isInstruction:=true;
         aCad[aInd-1].txtStart:=pPlus;  //Начальная позиция для выделения
         aCad[aInd-1].txtLong:=tZ-1;//Конечная позиция для выделения
         if vMark then MarkTextInRT(aCad[aInd-1].txtStart,aCad[aInd-1].txtLong,true,5);
         possiblyBP:=true; //Тут можно и BreackPoint поставить


        end
        else
        begin //Не команда
          if IsDirective(aCad[aInd-1].str)>-1 then //Проверка на директиву ассемблера
            begin //Да, директива
            aCad[aInd-1].isDirective:=true;
            aCad[aInd-1].txtStart:=pPlus;  //Начальная позиция для выделения
            aCad[aInd-1].txtLong:=tZ-1;//Конечная позиция для выделения
            if vMark then MarkTextInRT(aCad[aInd-1].txtStart,aCad[aInd-1].txtLong,true,6);


            end
            else
            begin //Не директива
            case IsDigth(aCad[aInd-1].str) of
            1:
              begin //Dec
              aCad[aInd-1].isDigit:=true;
              aCad[aInd-1].TypeDigth:=1;
              aCad[aInd-1].txtStart:=pPlus;  //Начальная позиция для выделения
              aCad[aInd-1].txtLong:=tZ-1;//Конечная позиция для выделения
              aCad[aInd-1].DigitDecValue:=aDecVal; //Десятичное значение
              if vMark then MarkTextInRT(aCad[aInd-1].txtStart,aCad[aInd-1].txtLong,true,7);



              end;
            2:
              begin //Bin
              aCad[aInd-1].isDigit:=true;
              aCad[aInd-1].TypeDigth:=2;
              aCad[aInd-1].txtStart:=pPlus;  //Начальная позиция для выделения
              aCad[aInd-1].txtLong:=tZ-1;//Конечная позиция для выделения
              aCad[aInd-1].DigitDecValue:=aDecVal; //Десятичное значениеN
              if vMark then MarkTextInRT(aCad[aInd-1].txtStart,aCad[aInd-1].txtLong,true,8);


              end;
            3:
              begin //Hex
              aCad[aInd-1].isDigit:=true;
              aCad[aInd-1].TypeDigth:=3;
              aCad[aInd-1].txtStart:=pPlus;  //Начальная позиция для выделения
              aCad[aInd-1].txtLong:=tZ-1;//Конечная позиция для выделения
              aCad[aInd-1].DigitDecValue:=aDecVal; //Десятичное значениеN
              if vMark then MarkTextInRT(aCad[aInd-1].txtStart,aCad[aInd-1].txtLong,true,9);



              end
            else
              begin // и не число
              //Чет какая-то хрень ниже была, я не понял, если че - вернуть
                {if isFlagDest(aCad[aInd-1].str)>-1 then //Проверка на флаг назначения
                  begin


                  //Совсем непонятно что, красным выделить её
                  aCad[aInd-1].isError:=true;
                  aCad[aInd-1].txtStart:=StartPos+pPlus;  //Начальная позиция для выделения
                  aCad[aInd-1].txtLong:=tZ-1;//Конечная позиция для выделения
                  MarkTextInRT(aCad[aInd-1].txtStart,aCad[aInd-1].txtLong,true,0);



                  end
                  else
                  begin //Флаг назначения

                  end;    }
               if IsCorrectVarOrLabel(aCad[aInd-1].str) then //Проверка на корректность названия переменной (но не факт, что такая есть)
                  begin //Так-то подходит под название переменной или метки
                  aCad[aInd-1].isCorrectVarOrLabel  :=true;
                  aCad[aInd-1].txtStart:=pPlus;  //Начальная позиция для выделения
                  aCad[aInd-1].txtLong:=tZ-1;//Конечная позиция для выделения
                  end
                  else
                  begin //Вообще непонятно, что это такое
                  aCad[aInd-1].isError:=true;
                  aCad[aInd-1].txtStart:=pPlus;  //Начальная позиция для выделения
                  aCad[aInd-1].txtLong:=tZ-1;//Конечная позиция для выделения
                  if vMark then MarkTextInRT(aCad[aInd-1].txtStart,aCad[aInd-1].txtLong,true,0);
                  end;



              end;

            end;
            end;

        end;
lblSex:
      //Удаление и дальнейшая обработка
      if ts=#44 then zpt:=true;  //поиск запятой
      Delete(str,1,tZ);
      pplus:=pplus+tZ;
      goto lOther2;
      end;
  end;

lblExit:
if vMarkError then
  begin
    MarkTextInRT(vErrStart,vErrLen,false,0);
    MarkAllLine(StartItem,FALSE);
  end;
if vMark then MarkAllLine(StartItem,true);//Пометим всю строку
//rve.Format;
end;

procedure TMDIChild.SyncCountRowsAndBP();
label lPP,lblDelAg;
var
lc,rv_width,lcl,I:integer;
tmplc:real;
begin
//Происходит проверка двух левых RichView
//Временный код, здесь идет перебор, кот необходимо заменить на более рациональный код
    //showmessage(aInd.ToString());
    lc:=rve.GetLineNo(rve.ItemCount-1,0);
        //Ресайз RV и RVE в зависимости от рассчитанного значения кол-ва строк
    tmplc:=lc;
    rv_width:=28;

lPP:
    rv_width:=rv_width+8;
    tmplc:=tmplc / 10;
    if tmplc>=1 then goto lPP;

    rv.Width:=rv_width; //соответственно изменим параметры в зав-ти от rv_width
    rve.Left:=rv_width;
    rve.Width:=clientwidth-rve.Left;

    lcl:=rv.GetLineNo(rv.ItemCount-1,0);
    if lcl=lc then  exit; //Если не изменилось кол-во строк
    //В общем, здесь изменилось кол-во строк

    if lcl<lc then
   begin //Стало больше строк
    for I:=lcl+1 to lc do
      begin
         main.MainForm.AsmChild.rvbp.AddNL('',0,0);
          main.MainForm.AsmChild.rvbp.AddBulletEx( '',3,main.MainForm.AsmChild.il_bullet,-1);
            //добавление #строки
      if ((i=1) or ((i mod 10)=0)) then main.MainForm.AsmChild.rv.AddNL(inttostr(I),0,0)
        else
          if ((i mod 5)=0) then main.MainForm.AsmChild.rv.AddNL('-',0,0)
            else  main.MainForm.AsmChild.rv.AddNL ('•',0,0);
      end;
    end
    else //Стало меньше строк
    begin
      for I := lc+1 to lcl   do main.MainForm.AsmChild.rvbp.DeleteItems((main.MainForm.AsmChild.rve.GetLineNo(main.MainForm.AsmChild.rve.ItemCount-1 ,0) *2),2);
         lblDelAg:
         main.MainForm.AsmChild.rv.DeleteItems(main.MainForm.AsmChild.rv.ItemCount-1,1);
         if main.MainForm.AsmChild.rv.GetLineNo(main.MainForm.AsmChild.rv.ItemCount-1,0)>lc then goto lblDelAg;



    end;
     main.MainForm.AsmChild.rvbp.Format;
    main.MainForm.AsmChild.rv.Format;
    //Запустим поток проверки соответствия брякпоинтов
    ChkSyntax_termThread;
    TimerSyntaxStart:=true;
    //TimerSyntax.Enabled:=true;

end;

procedure TMDIChild.CheckSyn();
label lblnext;
var Z,indx,StartP,lcbp,I,ICount,LineCount:Integer;
av_BP,is_BP:boolean;
label lblZanovo;
begin
//ChkSyntax_init;
z:=-1;
StartP:=0;
rve.BeginUpdate;
ICount:=rve.ItemCount-1;
LineCount:=RVE.GetLineNo(ICount,0);
lblZanovo:
for Z := 1 to LineCount do
  begin
   CheckSynLine( Find_Item_From_Line(RVE,Z));
   //application.ProcessMessages;
   //rve.Format;
  end;

{for indx :=ICount  downto StartP do  //Перебор всех индексов



 if Z<>rve.GetLineNo(indx,0) then //Если номер строки отличается от пред (найдена новая строка)
  begin
    Z:=rve.GetLineNo(indx,0);
    CheckSynLine(indx );
    lcbp:=((rvbp.ItemCount+1) div 2); }
    {if lcbp<Z  then //Не хватает строк в брякпоинтах
      begin //Добавим

       //добавление #строки
      if ((Z=1) or ((Z mod 10)=0)) then rv.AddNL(inttostr(Z),0,0)
        else
          if ((Z mod 5)=0) then rv.AddNL('-',0,0)
            else  rv.AddNL ('•',0,0);

        rvbp.AddNL('',0,0);
        av_BP:=false;
        for I := 0 to aInd-1 do
          if aCad[I].isInstruction then
            begin
              av_BP:=true;
              if rve.GetItemTag(aCad[I].ItemNo)='B' then is_BP:=true else is_BP:=false;
              goto lblNext;
            end;
lblNext:
        if av_bp then
          begin
          if is_BP then
            begin
              rvbp.AddBulletEx( '',0,il_bullet,-1);
            end
            else
            begin
              rvbp.AddBulletEx( '',2,il_bullet,-1);
            end;
          end
          else
          begin

           rvbp.AddBulletEx( '',3,il_bullet,-1);
          end;

      end; }

 // end;



{StartP:=Indx-1;
if StartP<rve.ItemCount-1 then goto lblZanovo;
   }
//Слева синхронизируем все
SyncCountRowsAndBP;

//rvbp.Format;
//rv.Format;
rve.endupdate;
rve.formatall;
end;
procedure TMDIChild.DisAssembley();
var G,H:integer;
Instr:string;
label lblEndCycle;
begin
autocheck:=false;
rve.Clear;
tablelinkscount:=0;
//txtlines.Text:='';
//Очистка памяти

for G := 0 to Get_ROM_Size-2 do   //ROMsize - 2 потому что последнюю команду MOVLW 00h не нужно дизассемблерировать
  begin
  RomToParCommand(G);

  //rt.Lines.Add(#9+PIC10F.GetInstruction());
  Instr:=GetInstruction();
//если есть гото, то занести в таблицу метку
  if Copy(Instr,1,4) = 'GOTO' then
    begin
      //Сперва проверим, а нет ли уже такой метки в таблице
      for H := 1 to tablelinkscount do
        begin
          if tableoflinks[H-1].lnkAddr=Get_parGOTOaddr() then
            begin
              //Видимо, есть
              //rt.Text:=rt.Text+#9+'GOTO lbl'+inttostr(tableoflinks[H-1].lnkno)+#13#10;
              rve.AddNL( #9+'GOTO lbl'+inttostr(tableoflinks[H-1].lnkno),0,0 );
              goto lblEndCycle;
            end;

        end;
      //Видать, нет
      tablelinkscount:=tablelinkscount+1;
      SetLength(tableoflinks,tablelinkscount);
      tableoflinks[tablelinkscount-1].lnkNo:=tablelinkscount;
      tableoflinks[tablelinkscount-1].lnkAddr:=Get_parGOTOaddr();
      //rt.Text:=rt.Text+#9+'GOTO lbl'+inttostr(tableoflinks[tablelinkscount-1].lnkno)+#13#10;
      rve.AddNL(#9+'GOTO lbl'+inttostr(tableoflinks[tablelinkscount-1].lnkno) ,0,0 );
      goto lblEndCycle;
    end;
//если есть CALL, то занести в таблицу метку
  if Copy(Instr,1,4) = 'CALL' then
    begin
      //Сперва проверим, а нет ли уже такой метки в таблице
      for H := 1 to tablelinkscount do
        begin
          if tableoflinks[H-1].lnkAddr=Get_parGOTOaddr() then
            begin
              //Видимо, есть
              //rt.Text:=rt.Text+#9+'CALL lbl'+inttostr(tableoflinks[H-1].lnkno)+#13#10;
              rve.AddNL( #9+'CALL lbl'+inttostr(tableoflinks[H-1].lnkno),0,0 );
              goto lblEndCycle;
            end;

        end;
      //Видать, нет
      tablelinkscount:=tablelinkscount+1;
      SetLength(tableoflinks,tablelinkscount);
      tableoflinks[tablelinkscount-1].lnkNo:=tablelinkscount;
      tableoflinks[tablelinkscount-1].lnkAddr:=Get_parGOTOaddr();
      //rt.Text:=rt.Text+#9+'CALL lbl'+inttostr(tableoflinks[tablelinkscount-1].lnkno)+#13#10;
      rve.AddNL( #9+'CALL lbl'+inttostr(tableoflinks[tablelinkscount-1].lnkno),0,0 );
      goto lblEndCycle;
    end;

  //rt.text:=rt.text+#9+Instr+#13#10;
  rve.AddNL(#9+Instr ,0,0 );
lblEndCycle:
  end;
 ////Создание массива строк(значения которого=первой в строке итеме)
 //Востановление таблицы ссылок
 rve.FormatAll;
 G:=rve.ItemCount;
 for G := 1 to tablelinkscount do
 begin
 rve.SetSelectionBounds(tableoflinks[G-1].lnkAddr,0,tableoflinks[G-1].lnkAddr,0);
 rve.InsertText('lbl'+inttostr(tableoflinks[G-1].lnkNo)+':');
 //rt.Lines[tableoflinks[G-1].lnkAddr]:='lbl'+inttostr(tableoflinks[G-1].lnkNo)+':'+rt.Lines[tableoflinks[G-1].lnkAddr];
 end;
 //Удаление конечных NOP-ов
 for G := rve.ItemCount-1  downto 0 do
   begin
     if rve.GetItemText(G)='NOP' then
          rve.DeleteItems(G,1)
               else exit;

   end;
   rve.FormatAll;

   //autocheck:=true;  тут это так было
end;

procedure TMDIChild.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//  Action := caFree;

end;

procedure TMDIChild.FormCreate(Sender: TObject);
begin
{rt.Width:=width-rt.left-8;
rt.Height:=height-rt.top-30;
rt.DoubleBuffered:=true;
      }
 OnResize;


end;

procedure TMDIChild.FormResize(Sender: TObject);
begin
{rt.Width:=width-rt.left-8;
rt.Height:=height-rt.top-30;
   }
OnResize;

end;



procedure TMDIChild.RVbpClick(Sender: TObject);
begin
rve.SetFocus;
end;

procedure TMDIChild.RVbpRVMouseDown(Sender: TCustomRichView;
  Button: TMouseButton; Shift: TShiftState; ItemNo, X, Y: Integer);
begin
itmMD:=itemNo;
end;

procedure TMDIChild.RVbpRVMouseUp(Sender: TCustomRichView; Button: TMouseButton;
  Shift: TShiftState; ItemNo, X, Y: Integer);
label lblNext,lblexit;
  var
  ln:integer; //# строки
  it:integer;
  I: Integer; //Какая-нибудь итема
  av_BP:boolean; //Возможна ли тут Брякпоинта
  is_BP:boolean; //Есть ли тут брякпоинт
  itmNo,itmOff:integer; //Для восстановления курсора
 // SI,EI:integer; //Начальная и конечная итема для поиска
begin
if itemNo=-1 then exit; //Если кликнули по пустому месту
if rvbp.GetItemStyle(ItemNo)<>-6 then exit;  //Если кликнули не по буллету - то тоже выйдем
if itmMD<>ItemNo then exit; //Если нажали и подняли кнопку мыши не на этой итеме

itmNo:=rve.CurItemNo;
itmoff:=rve.OffsetInCurItem;
rve.BeginUpdate;

ln:=(ItemNo+1) div 2;//Определим строку, по которой кликнули
it:=Find_Item_From_Line(rve, ln); //Далее, найдем какую-нибудь итему из этой строки
//GetAllLineFromItem(rve,it,SI,EI,ln);
CheckSynLine(it);
av_BP:=false;
for I := 0 to aInd-1 do
    if aCad[I].isInstruction then
      begin
        av_BP:=true;
        if rve.GetItemTag(aCad[I].ItemNo)='B' then is_BP:=false else is_BP:=true;
        goto lblNext;
      end;
lblNext:
if not av_BP then goto lblexit;

if is_BP then
  begin
  rve.SetItemTag(aCad[I].ItemNo,'B');
  rvbp.SetBulletInfo(ItemNo,'',0,nil,'')
  end
  else
  begin
  rve.SetItemTag(aCad[I].ItemNo,'');
  rvbp.SetBulletInfo(ItemNo,'',2,nil,'')
  end;


{#old code
if aBP[ln].BP then aBP[ln].BP:=false else aBP[ln].BP:=true;
         if aBP[ln].BP then
            if aBP[ln].possiblyBP then rvbp.SetBulletInfo(ItemNo,'',0,nil,'') else rvbp.SetBulletInfo(ItemNo,'',1,nil,'')
              else
                if aBP[ln].possiblyBP then rvbp.SetBulletInfo(ItemNo,'',2,nil,'') else rvbp.SetBulletInfo(ItemNo,'',3,nil,'');
//showmessage(ItemNo.ToString() );
//rvbp.SetBulletInfo( ItemNo,'1',0,nil,'1');  }
lblexit:
rve.SetSelectionBounds(itmNo,itmOff,itmNo,itmOff);
rve.EndUpdate;
rvbp.Format;
end;

procedure TMDIChild.RVClick(Sender: TObject);
begin
rve.SetFocus;
end;

procedure TMDIChild.RVEChange(Sender: TObject);
begin
if not alload then exit;
if varPaste then
  begin
    OnType(true,varPasteLn,rve.GetLineNo(rve.CurItemNo,rve.OffsetInCurItem));
    varPaste:=false;
  end
else
  begin
    OnType;
  end;

//tp:=rt.CaretPos;
//tS:=0;
//for tZ := 1 to rt.CaretPos.Y  do tS:=tS+length(rt.Lines[tZ-1])+1;
//rve.BeginUpdate;

//rt.CaretPos:=tp;
// }

//ChkSyntax_termThread;
//TimerSyntax.Enabled:=true;

//ChkSyntax_start;


//rve.EndUpdate;
end;

procedure TMDIChild.RVEKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
main.MainForm.exchange:=true;
end;

procedure TMDIChild.RVEKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
j,ln,lo:integer;
begin
{if DebugTextEditor then
begin
theadrefresh.GetAllLineFromItem( rve,rve.CurItemNo,rve.OffsetInCurItem,j,j,ln,lo);
  self.Caption:='Item ' + inttostr(rve.CurItemNo);
  self.Caption:=self.Caption+' Offset ' + inttostr(rve.OffsetInCurItem);
  self.Caption:=self.Caption+' ln ' + inttostr(ln);
  self.Caption:=self.Caption+' lo ' + inttostr(lo);

end;    }
end;

procedure TMDIChild.RVEPaste(Sender: TCustomRichViewEdit;
  var DoDefault: Boolean);
begin
varPaste:=true;
varPasteLn:=rve.GetLineNo(rve.CurItemNo,rve.OffsetInCurItem);
DoDefault:=true;
main.MainForm.exchange:=true;
end;

procedure TMDIChild.RVEVScrolled(Sender: TObject);
begin
if not alload then exit;

//if rv.VScrollPos<>rve.VScrollPos then
rv.VScrollPos:=rve.VScrollPos;
//if rvbp.VScrollPos<>rve.VScrollPos then
rvbp.VScrollPos:=rve.VScrollPos;
end;

procedure TMDIChild.TimerSyntaxTimer(Sender: TObject);
begin
if not TimerSyntaxStart then exit;
if ChkSyntax_start() then
  begin
  TimerSyntaxStart:=false;
   // TimerSyntax.Enabled:=false;
  end;
end;

procedure TMDIChild.TmrRefreshTimer(Sender: TObject);
var NowI:Integer;
itNo,vImgInd:integer;
vName:TRVAnsiString;
vTag:TRVTag;
vImgList:TCustomImageList;
//Внимание! Таймер выполняет функцию показа следующей выполняемой инструкции
begin

if Can_Restore_img_in_BP then
  begin
  rvbp.SetBulletInfo(item_to_rest_BP ,'',img_ind_BP,nil,'');
  Can_Restore_img_in_BP:=false;
  RVBP.Format;
  end;

if get_rtRunning()=false then exit;

NowI:=get_I;
if nowI>=Get_ROM_Size-1 then NowI:=0;
itNo:=rve.GetLineNo(Get_ROM_Str_No_from(NowI),0)*2-1;
rvbp.GetBulletInfo(itNo,vName,vImgInd,vImgList,vTag);
if vImgInd=0 then
  BEGIN
  rvbp.SetBulletInfo(itNo ,'',4,nil,'');
  item_to_rest_BP:=itNo;
  img_ind_BP:=0;
  Can_Restore_img_in_BP:=true;
  END;
if vImgInd=2 then
  BEGIN
  rvbp.SetBulletInfo(itNo ,'',5,nil,'');
  item_to_rest_BP:=itNo;
  img_ind_BP:=2;
  Can_Restore_img_in_BP:=true;
  END;
rvbp.Format;
 //rve.SetSelectionBounds( Get_ROM_Str_No_from(NowI),0,Get_ROM_Str_No_to(NowI),rve.GetOffsafterItem(Get_ROM_Str_No_to(NowI)));
//rve.FormatTail;

end;

function TMDIChild.AssembleyInstruction(indx:integer):boolean;
var J:integer;
begin

//Сперва без аргументов

//CLRW

 if aCaD[indx].str= 'CLRW' then
    begin
      if indx+1=aInd then
        begin //Больше параметров нет - хорошо
          CurCom[0]:=false;
          CurCom[1]:=false;
          CurCom[2]:=false;
          CurCom[3]:=false;
          CurCom[4]:=false;
          CurCom[5]:=false;
          CurCom[6]:=true;
          CurCom[7]:=false;
          CurCom[8]:=false;
          CurCom[9]:=false;
          CurCom[10]:=false;
          CurCom[11]:=false;
          result:=true;
          exit;
        end
      else
        begin //Что-то еще там есть - ошибка
            MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
            showmessage(Gettext(1020));
            result:=false;
            exit;
        end;
    end;

//NOP

  if aCaD[indx].str= 'NOP' then
    begin
      if indx+1=aInd then
        begin //Больше параметров нет - хорошо
          CurCom[0]:=false;
          CurCom[1]:=false;
          CurCom[2]:=false;
          CurCom[3]:=false;
          CurCom[4]:=false;
          CurCom[5]:=false;
          CurCom[6]:=false;
          CurCom[7]:=false;
          CurCom[8]:=false;
          CurCom[9]:=false;
          CurCom[10]:=false;
          CurCom[11]:=false;
          result:=true;
          exit;
        end
      else
        begin //Что-то еще там есть - ошибка
            MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
            showmessage(GetText(1020));
            result:=false;
            exit;
        end;
    end;


//OPTION


  if aCaD[indx].str= 'OPTION' then
    begin
       if indx+1=aInd then
        begin //Больше параметров нет - хорошо
          CurCom[0]:=false;
          CurCom[1]:=true;
          CurCom[2]:=false;
          CurCom[3]:=false;
          CurCom[4]:=false;
          CurCom[5]:=false;
          CurCom[6]:=false;
          CurCom[7]:=false;
          CurCom[8]:=false;
          CurCom[9]:=false;
          CurCom[10]:=false;
          CurCom[11]:=false;
          result:=true;
          exit;
        end
      else
        begin //Что-то еще там есть - ошибка
            MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
            showmessage(GetText(1020));
            result:=false;
            exit;
        end;
    end;


//SLEEP


  if aCaD[indx].str= 'SLEEP' then
    begin
       if indx+1=aInd then
        begin //Больше параметров нет - хорошо
          CurCom[0]:=true;
          CurCom[1]:=true;
          CurCom[2]:=false;
          CurCom[3]:=false;
          CurCom[4]:=false;
          CurCom[5]:=false;
          CurCom[6]:=false;
          CurCom[7]:=false;
          CurCom[8]:=false;
          CurCom[9]:=false;
          CurCom[10]:=false;
          CurCom[11]:=false;
          result:=true;
          exit;
        end
      else
        begin //Что-то еще там есть - ошибка
            MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
            showmessage(GetText(1020));
            result:=false;
            exit;
        end;
    end;



//CLRWDT


  if aCaD[indx].str= 'CLRWDT' then
    begin
       if indx+1=aInd then
        begin //Больше параметров нет - хорошо
          CurCom[0]:=false;
          CurCom[1]:=false;
          CurCom[2]:=true;
          CurCom[3]:=false;
          CurCom[4]:=false;
          CurCom[5]:=false;
          CurCom[6]:=false;
          CurCom[7]:=false;
          CurCom[8]:=false;
          CurCom[9]:=false;
          CurCom[10]:=false;
          CurCom[11]:=false;
          result:=true;
          exit;
        end
      else
        begin //Что-то еще там есть - ошибка
            MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
            showmessage(GetText(1020));
            result:=false;
            exit;
        end;
    end;
//С параметром - 8 битной константой


//XORLW k



if aCaD[indx].str= 'XORLW' then
  begin
    if indx+1=aInd then
      begin //Больше параметров нет - не хорошо
        MarkTextInRT( aCaD[indx].txtStart,aCaD[indx].txtLong,false,0);
        showmessage(GetText(1021));
        result:=false;
        exit;
      end;
    if indx+2=aind then
      begin //Есть еще параметр - уже лучше
        if aCaD[indx+1].isDigit then
          begin //Параметр - цифра
            if (aCad[indx+1].DigitDecValue >=0) and (aCad[indx+1].DigitDecValue <=255)  then
              begin //Входит в диапазон 0..255
              DecToParBin(aCad[indx+1].DigitDecValue);
          CurCom[0]:=parBin[0];
          CurCom[1]:=parBin[1];
          CurCom[2]:=parBin[2];
          CurCom[3]:=parBin[3];
          CurCom[4]:=parBin[4];
          CurCom[5]:=parBin[5];
          CurCom[6]:=parBin[6];
          CurCom[7]:=parBin[7];
          CurCom[8]:=true;
          CurCom[9]:=true;
          CurCom[10]:=true;
          CurCom[11]:=true;
          result:=true;
          exit;
              end
              else
              begin //Не входит в диапазон 0..255
              MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1022));
              result:=false;
              exit;

              end;
          end
          else
          begin //Параметр не цифра
            //Проверим на переменную из EQU
            if aCaD[indx+1].isCorrectVarOrLabel then
              begin
                for J := 0 to aEquSCount-1 do
                if aEquS[J].Name=aCaD[indx+1].str then
                  begin //Да, тут объявленая "переменная" далее
                    DecToParBin(aEquS[J].DecVal);
                    CurCom[0]:=parBin[0];
                    CurCom[1]:=parBin[1];
                    CurCom[2]:=parBin[2];
                    CurCom[3]:=parBin[3];
                    CurCom[4]:=parBin[4];
                    CurCom[5]:=parBin[5];
                    CurCom[6]:=parBin[6];
                    CurCom[7]:=parBin[7];
                    CurCom[8]:=true;
                    CurCom[9]:=true;
                    CurCom[10]:=true;
                    CurCom[11]:=true;
                    result:=true;
                    exit;
                  end;
                //Вот здесь необъявленная переменная
                MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1023));
              result:=false;
              exit;
              end
            else
              begin //Вообще что-то неправильное далее, ошибка
               MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1024));
              result:=false;
              exit;
              end;

          end;
      end
    else
      begin //Что-то еще там есть - ошибка
        MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
        showmessage(GetText(1020));
        result:=false;
        exit;
      end;

  end;



//ANDLW k



  if aCaD[indx].str= 'ANDLW' then
  begin
    if indx+1=aInd then
      begin //Больше параметров нет - не хорошо
        MarkTextInRT( aCaD[indx].txtStart,aCaD[indx].txtLong,false,0);
        showmessage(GetText(1021));
        result:=false;
        exit;
      end;
    if indx+2=aind then
      begin //Есть еще параметр - уже лучше
        if aCaD[indx+1].isDigit then
          begin //Параметр - цифра
            if (aCad[indx+1].DigitDecValue >=0) and (aCad[indx+1].DigitDecValue <=255)  then
              begin //Входит в диапазон 0..255
              DecToParBin(aCad[indx+1].DigitDecValue);
          CurCom[0]:=parBin[0];
          CurCom[1]:=parBin[1];
          CurCom[2]:=parBin[2];
          CurCom[3]:=parBin[3];
          CurCom[4]:=parBin[4];
          CurCom[5]:=parBin[5];
          CurCom[6]:=parBin[6];
          CurCom[7]:=parBin[7];
          CurCom[8]:=false;
          CurCom[9]:=true;
          CurCom[10]:=true;
          CurCom[11]:=true;
          result:=true;
          exit;
              end
              else
              begin //Не входит в диапазон 0..255
              MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1022));
              result:=false;
              exit;

              end;
          end
          else
          begin //Параметр не цифра
            //Проверим на переменную из EQU
            if aCaD[indx+1].isCorrectVarOrLabel then
              begin
                for J := 0 to aEquSCount-1 do
                if aEquS[J].Name=aCaD[indx+1].str then
                  begin //Да, тут объявленая "переменная" далее
                    DecToParBin(aEquS[J].DecVal);
                    CurCom[0]:=parBin[0];
                    CurCom[1]:=parBin[1];
                    CurCom[2]:=parBin[2];
                    CurCom[3]:=parBin[3];
                    CurCom[4]:=parBin[4];
                    CurCom[5]:=parBin[5];
                    CurCom[6]:=parBin[6];
                    CurCom[7]:=parBin[7];
                    CurCom[8]:=false;
                    CurCom[9]:=true;
                    CurCom[10]:=true;
                    CurCom[11]:=true;
                    result:=true;
                    exit;
                  end;
                //Вот здесь необъявленная переменная
                MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1023));
              result:=false;
              exit;
              end
            else
              begin //Вообще что-то неправильное далее, ошибка
               MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1024));
              result:=false;
              exit;
              end;

          end;
      end
    else
      begin //Что-то еще там есть - ошибка
        MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
        showmessage(GetText(1020));
        result:=false;
        exit;
      end;

  end;



//IORLW k


  if aCaD[indx].str= 'IORLW' then
  begin
    if indx+1=aInd then
      begin //Больше параметров нет - не хорошо
        MarkTextInRT( aCaD[indx].txtStart,aCaD[indx].txtLong,false,0);
        showmessage(GetText(1021));
        result:=false;
        exit;
      end;
    if indx+2=aind then
      begin //Есть еще параметр - уже лучше
        if aCaD[indx+1].isDigit then
          begin //Параметр - цифра
            if (aCad[indx+1].DigitDecValue >=0) and (aCad[indx+1].DigitDecValue <=255)  then
              begin //Входит в диапазон 0..255
              DecToParBin(aCad[indx+1].DigitDecValue);
          CurCom[0]:=parBin[0];
          CurCom[1]:=parBin[1];
          CurCom[2]:=parBin[2];
          CurCom[3]:=parBin[3];
          CurCom[4]:=parBin[4];
          CurCom[5]:=parBin[5];
          CurCom[6]:=parBin[6];
          CurCom[7]:=parBin[7];
          CurCom[8]:=true;
          CurCom[9]:=false;
          CurCom[10]:=true;
          CurCom[11]:=true;
          result:=true;
          exit;
              end
              else
              begin //Не входит в диапазон 0..255
              MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1022));
              result:=false;
              exit;

              end;
          end
          else
          begin //Параметр не цифра
            //Проверим на переменную из EQU
            if aCaD[indx+1].isCorrectVarOrLabel then
              begin
                for J := 0 to aEquSCount-1 do
                if aEquS[J].Name=aCaD[indx+1].str then
                  begin //Да, тут объявленая "переменная" далее
                    DecToParBin(aEquS[J].DecVal);
                    CurCom[0]:=parBin[0];
                    CurCom[1]:=parBin[1];
                    CurCom[2]:=parBin[2];
                    CurCom[3]:=parBin[3];
                    CurCom[4]:=parBin[4];
                    CurCom[5]:=parBin[5];
                    CurCom[6]:=parBin[6];
                    CurCom[7]:=parBin[7];
                    CurCom[8]:=true;
                    CurCom[9]:=false;
                    CurCom[10]:=true;
                    CurCom[11]:=true;
                    result:=true;
                    exit;
                  end;
                //Вот здесь необъявленная переменная
                MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1023));
              result:=false;
              exit;
              end
            else
              begin //Вообще что-то неправильное далее, ошибка
               MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1024));
              result:=false;
              exit;
              end;

          end;
      end
    else
      begin //Что-то еще там есть - ошибка
        MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
        showmessage(GetText(1020));
        result:=false;
        exit;
      end;

  end;


// MOWLW k

  if aCaD[indx].str= 'MOVLW' then
  begin
    if indx+1=aInd then
      begin //Больше параметров нет - не хорошо
        MarkTextInRT( aCaD[indx].txtStart,aCaD[indx].txtLong,false,0);
        showmessage(GetText(1021));
        result:=false;
        exit;
      end;
    if indx+2=aind then
      begin //Есть еще параметр - уже лучше
        if aCaD[indx+1].isDigit then
          begin //Параметр - цифра
            if (aCad[indx+1].DigitDecValue >=0) and (aCad[indx+1].DigitDecValue <=255)  then
              begin //Входит в диапазон 0..255
              DecToParBin(aCad[indx+1].DigitDecValue);
          CurCom[0]:=parBin[0];
          CurCom[1]:=parBin[1];
          CurCom[2]:=parBin[2];
          CurCom[3]:=parBin[3];
          CurCom[4]:=parBin[4];
          CurCom[5]:=parBin[5];
          CurCom[6]:=parBin[6];
          CurCom[7]:=parBin[7];
          CurCom[8]:=false;
          CurCom[9]:=false;
          CurCom[10]:=true;
          CurCom[11]:=true;
          result:=true;
          exit;
              end
              else
              begin //Не входит в диапазон 0..255
              MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1022));
              result:=false;
              exit;

              end;
          end
          else
          begin //Параметр не цифра
            //Проверим на переменную из EQU
            if aCaD[indx+1].isCorrectVarOrLabel then
              begin
                for J := 0 to aEquSCount-1 do
                if aEquS[J].Name=aCaD[indx+1].str then
                  begin //Да, тут объявленая "переменная" далее
                    DecToParBin(aEquS[J].DecVal);
                    CurCom[0]:=parBin[0];
                    CurCom[1]:=parBin[1];
                    CurCom[2]:=parBin[2];
                    CurCom[3]:=parBin[3];
                    CurCom[4]:=parBin[4];
                    CurCom[5]:=parBin[5];
                    CurCom[6]:=parBin[6];
                    CurCom[7]:=parBin[7];
                    CurCom[8]:=false;
                    CurCom[9]:=false;
                    CurCom[10]:=true;
                    CurCom[11]:=true;
                    result:=true;
                    exit;
                  end;
                //Вот здесь необъявленная переменная
                MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(Gettext(1023));
              result:=false;
              exit;
              end
            else
              begin //Вообще что-то неправильное далее, ошибка
               MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(Gettext(1024));
              result:=false;
              exit;
              end;

          end;
      end
    else
      begin //Что-то еще там есть - ошибка
        MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
        showmessage(Gettext(1020));
        result:=false;
        exit;
      end;

  end;



// RETLW k

  if aCaD[indx].str= 'RETLW' then
  begin
    if indx+1=aInd then
      begin //Больше параметров нет - не хорошо
        MarkTextInRT( aCaD[indx].txtStart,aCaD[indx].txtLong,false,0);
        showmessage(Gettext(1021));
        result:=false;
        exit;
      end;
    if indx+2=aind then
      begin //Есть еще параметр - уже лучше
        if aCaD[indx+1].isDigit then
          begin //Параметр - цифра
            if (aCad[indx+1].DigitDecValue >=0) and (aCad[indx+1].DigitDecValue <=255)  then
              begin //Входит в диапазон 0..255
              DecToParBin(aCad[indx+1].DigitDecValue);
          CurCom[0]:=parBin[0];
          CurCom[1]:=parBin[1];
          CurCom[2]:=parBin[2];
          CurCom[3]:=parBin[3];
          CurCom[4]:=parBin[4];
          CurCom[5]:=parBin[5];
          CurCom[6]:=parBin[6];
          CurCom[7]:=parBin[7];
          CurCom[8]:=false;
          CurCom[9]:=false;
          CurCom[10]:=false;
          CurCom[11]:=true;
          result:=true;
          exit;
              end
              else
              begin //Не входит в диапазон 0..255
              MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(Gettext(1022));
              result:=false;
              exit;

              end;
          end
          else
          begin //Параметр не цифра
            //Проверим на переменную из EQU
            if aCaD[indx+1].isCorrectVarOrLabel then
              begin
                for J := 0 to aEquSCount-1 do
                if aEquS[J].Name=aCaD[indx+1].str then
                  begin //Да, тут объявленая "переменная" далее
                    DecToParBin(aEquS[J].DecVal);
                    CurCom[0]:=parBin[0];
                    CurCom[1]:=parBin[1];
                    CurCom[2]:=parBin[2];
                    CurCom[3]:=parBin[3];
                    CurCom[4]:=parBin[4];
                    CurCom[5]:=parBin[5];
                    CurCom[6]:=parBin[6];
                    CurCom[7]:=parBin[7];
                    CurCom[8]:=false;
                    CurCom[9]:=false;
                    CurCom[10]:=false;
                    CurCom[11]:=true;
                    result:=true;
                    exit;
                  end;
                //Вот здесь необъявленная переменная
                MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(Gettext(1023));
              result:=false;
              exit;
              end
            else
              begin //Вообще что-то неправильное далее, ошибка
               MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(Gettext(1024));
              result:=false;
              exit;
              end;

          end;
      end
    else
      begin //Что-то еще там есть - ошибка
        MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
        showmessage(Gettext(1020));
        result:=false;
        exit;
      end;

  end;



//С параметрами - 5-битным №регистра, и пункт назначения W(f) или 0(1) - тут таких большинство


//INCFSZ

  if aCaD[indx].str= 'INCFSZ' then
  begin
    if (indx+1=aInd)  then
      begin //Больше параметров нет - не хорошо
        MarkTextInRT( aCaD[indx].txtStart,aCaD[indx].txtLong,false,0);
        showmessage(Gettext(1021));
        result:=false;
        exit;
      end;
    //Сначала обработаем флаг назначения (если есть)
    CurCom[5]:=false;  //А вдруг - нет, тогда по-умолчанию 0 или W
    if indx+3=aind then
      if aCad[indx+2].isFN then
      begin
      if (aCad[indx+2].str='1') or (aCad[indx+2].str='F')  then CurCom[5]:=true;
      end
      else
      begin //А вот тут ошибка, т.к. 3-й параметр какая-то фигня
      MarkTextInRT( aCaD[indx+2].txtStart,aCaD[indx+2].txtLong,false,0);
      showmessage(Gettext(1024));
      result:=false;
      exit;
      end;


    if (indx+2=aind) or (indx+3=aind) then
      begin //Есть еще параметр или два - уже лучше (по-умолчанию назначение в регистр W (0) если параметр один
        if aCaD[indx+1].isDigit then
          begin //Параметр - цифра
            if (aCad[indx+1].DigitDecValue >=0) and (aCad[indx+1].DigitDecValue <=4095)  then
              begin //Входит в диапазон 0..4095 для совсем мощной совместимости с PIC18
              DecToParBin(aCad[indx+1].DigitDecValue);
          CurCom[0]:=parBin[0];
          CurCom[1]:=parBin[1];
          CurCom[2]:=parBin[2];
          CurCom[3]:=parBin[3];
          CurCom[4]:=parBin[4];
          //CurCom[5]:=parBin[5]; //А вот его мы определили выше
          CurCom[6]:=true;
          CurCom[7]:=true;
          CurCom[8]:=true;
          CurCom[9]:=true;
          CurCom[10]:=false;
          CurCom[11]:=false;
          result:=true;
          exit;
              end
              else
              begin //Не входит в диапазон 0..4095
              MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1025));
              result:=false;
              exit;

              end;
          end
          else
          begin //Параметр не цифра
            //Проверим на переменную из EQU
            if aCaD[indx+1].isCorrectVarOrLabel then
              begin
                for J := 0 to aEquSCount-1 do
                if aEquS[J].Name=aCaD[indx+1].str then
                  begin //Да, тут объявленая "переменная" далее
                    DecToParBin(aEquS[J].DecVal);
                    CurCom[0]:=parBin[0];
                    CurCom[1]:=parBin[1];
                    CurCom[2]:=parBin[2];
                    CurCom[3]:=parBin[3];
                    CurCom[4]:=parBin[4];
                    //CurCom[5]:=parBin[5];
                    CurCom[6]:=true;
                    CurCom[7]:=true;
                    CurCom[8]:=true;
                    CurCom[9]:=true;
                    CurCom[10]:=false;
                    CurCom[11]:=false;
                    result:=true;
                    exit;
                  end;
                //Вот здесь необъявленная переменная
                MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(Gettext(1023));
              result:=false;
              exit;
              end
            else
              begin //Вообще что-то неправильное далее, ошибка
               MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(Gettext(1024));
              result:=false;
              exit;
              end;

          end;
      end
    else
      begin //Что-то еще там есть - ошибка
        MarkTextInRT( aCaD[indx+3].txtStart,aCaD[indx+3].txtLong,false,0);
        showmessage(Gettext(1020));
        result:=false;
        exit;
      end;

  end;



//SWAPF


 if aCaD[indx].str= 'SWAPF' then
  begin
    if (indx+1=aInd)  then
      begin //Больше параметров нет - не хорошо
        MarkTextInRT( aCaD[indx].txtStart,aCaD[indx].txtLong,false,0);
        showmessage(Gettext(1021));
        result:=false;
        exit;
      end;
    //Сначала обработаем флаг назначения (если есть)
    CurCom[5]:=false;  //А вдруг - нет, тогда по-умолчанию 0 или W
    if indx+3=aind then
      if aCad[indx+2].isFN then
      begin
      if (aCad[indx+2].str='1') or (aCad[indx+2].str='F')  then CurCom[5]:=true;
      end
      else
      begin //А вот тут ошибка, т.к. 3-й параметр какая-то фигня
      MarkTextInRT( aCaD[indx+2].txtStart,aCaD[indx+2].txtLong,false,0);
      showmessage(Gettext(1024));
      result:=false;
      exit;
      end;


    if (indx+2=aind) or (indx+3=aind) then
      begin //Есть еще параметр или два - уже лучше (по-умолчанию назначение в регистр W (0) если параметр один
        if aCaD[indx+1].isDigit then
          begin //Параметр - цифра
            if (aCad[indx+1].DigitDecValue >=0) and (aCad[indx+1].DigitDecValue <=4095)  then
              begin //Входит в диапазон 0..4095 для совсем мощной совместимости с PIC18
              DecToParBin(aCad[indx+1].DigitDecValue);
          CurCom[0]:=parBin[0];
          CurCom[1]:=parBin[1];
          CurCom[2]:=parBin[2];
          CurCom[3]:=parBin[3];
          CurCom[4]:=parBin[4];
          //CurCom[5]:=parBin[5]; //А вот его мы определили выше
          CurCom[6]:=false;
          CurCom[7]:=true;
          CurCom[8]:=true;
          CurCom[9]:=true;
          CurCom[10]:=false;
          CurCom[11]:=false;
          result:=true;
          exit;
              end
              else
              begin //Не входит в диапазон 0..4095
              MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1025));
              result:=false;
              exit;

              end;
          end
          else
          begin //Параметр не цифра
            //Проверим на переменную из EQU
            if aCaD[indx+1].isCorrectVarOrLabel then
              begin
                for J := 0 to aEquSCount-1 do
                if aEquS[J].Name=aCaD[indx+1].str then
                  begin //Да, тут объявленая "переменная" далее
                    DecToParBin(aEquS[J].DecVal);
                    CurCom[0]:=parBin[0];
                    CurCom[1]:=parBin[1];
                    CurCom[2]:=parBin[2];
                    CurCom[3]:=parBin[3];
                    CurCom[4]:=parBin[4];
                    //CurCom[5]:=parBin[5];
                    CurCom[6]:=false;
                    CurCom[7]:=true;
                    CurCom[8]:=true;
                    CurCom[9]:=true;
                    CurCom[10]:=false;
                    CurCom[11]:=false;
                    result:=true;
                    exit;
                  end;
                //Вот здесь необъявленная переменная
                MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(Gettext(1023));
              result:=false;
              exit;
              end
            else
              begin //Вообще что-то неправильное далее, ошибка
               MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(Gettext(1024));
              result:=false;
              exit;
              end;

          end;
      end
    else
      begin //Что-то еще там есть - ошибка
        MarkTextInRT( aCaD[indx+3].txtStart,aCaD[indx+3].txtLong,false,0);
        showmessage(Gettext(1020));
        result:=false;
        exit;
      end;

  end;



//RLF

  if aCaD[indx].str= 'RLF' then
  begin
    if (indx+1=aInd)  then
      begin //Больше параметров нет - не хорошо
        MarkTextInRT( aCaD[indx].txtStart,aCaD[indx].txtLong,false,0);
        showmessage(Gettext(1021));
        result:=false;
        exit;
      end;
    //Сначала обработаем флаг назначения (если есть)
    CurCom[5]:=false;  //А вдруг - нет, тогда по-умолчанию 0 или W
    if indx+3=aind then
      if aCad[indx+2].isFN then
      begin
      if (aCad[indx+2].str='1') or (aCad[indx+2].str='F')  then CurCom[5]:=true;
      end
      else
      begin //А вот тут ошибка, т.к. 3-й параметр какая-то фигня
      MarkTextInRT( aCaD[indx+2].txtStart,aCaD[indx+2].txtLong,false,0);
      showmessage(Gettext(1024));
      result:=false;
      exit;
      end;


    if (indx+2=aind) or (indx+3=aind) then
      begin //Есть еще параметр или два - уже лучше (по-умолчанию назначение в регистр W (0) если параметр один
        if aCaD[indx+1].isDigit then
          begin //Параметр - цифра
            if (aCad[indx+1].DigitDecValue >=0) and (aCad[indx+1].DigitDecValue <=4095)  then
              begin //Входит в диапазон 0..4095 для совсем мощной совместимости с PIC18
              DecToParBin(aCad[indx+1].DigitDecValue);
          CurCom[0]:=parBin[0];
          CurCom[1]:=parBin[1];
          CurCom[2]:=parBin[2];
          CurCom[3]:=parBin[3];
          CurCom[4]:=parBin[4];
          //CurCom[5]:=parBin[5]; //А вот его мы определили выше
          CurCom[6]:=true;
          CurCom[7]:=false;
          CurCom[8]:=true;
          CurCom[9]:=true;
          CurCom[10]:=false;
          CurCom[11]:=false;
          result:=true;
          exit;
              end
              else
              begin //Не входит в диапазон 0..4095
              MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1025));
              result:=false;
              exit;

              end;
          end
          else
          begin //Параметр не цифра
            //Проверим на переменную из EQU
            if aCaD[indx+1].isCorrectVarOrLabel then
              begin
                for J := 0 to aEquSCount-1 do
                if aEquS[J].Name=aCaD[indx+1].str then
                  begin //Да, тут объявленая "переменная" далее
                    DecToParBin(aEquS[J].DecVal);
                    CurCom[0]:=parBin[0];
                    CurCom[1]:=parBin[1];
                    CurCom[2]:=parBin[2];
                    CurCom[3]:=parBin[3];
                    CurCom[4]:=parBin[4];
                    //CurCom[5]:=parBin[5];
                    CurCom[6]:=true;
                    CurCom[7]:=false;
                    CurCom[8]:=true;
                    CurCom[9]:=true;
                    CurCom[10]:=false;
                    CurCom[11]:=false;
                    result:=true;
                    exit;
                  end;
                //Вот здесь необъявленная переменная
                MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1023));
              result:=false;
              exit;
              end
            else
              begin //Вообще что-то неправильное далее, ошибка
               MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1024));
              result:=false;
              exit;
              end;

          end;
      end
    else
      begin //Что-то еще там есть - ошибка
        MarkTextInRT( aCaD[indx+3].txtStart,aCaD[indx+3].txtLong,false,0);
        showmessage(GetText(1020));
        result:=false;
        exit;
      end;

  end;

//RRF

  if aCaD[indx].str= 'RRF' then
  begin
    if (indx+1=aInd)  then
      begin //Больше параметров нет - не хорошо
        MarkTextInRT( aCaD[indx].txtStart,aCaD[indx].txtLong,false,0);
        showmessage(GetText(1021));
        result:=false;
        exit;
      end;
    //Сначала обработаем флаг назначения (если есть)
    CurCom[5]:=false;  //А вдруг - нет, тогда по-умолчанию 0 или W
    if indx+3=aind then
      if aCad[indx+2].isFN then
      begin
      if (aCad[indx+2].str='1') or (aCad[indx+2].str='F')  then CurCom[5]:=true;
      end
      else
      begin //А вот тут ошибка, т.к. 3-й параметр какая-то фигня
      MarkTextInRT( aCaD[indx+2].txtStart,aCaD[indx+2].txtLong,false,0);
      showmessage(GetText(1024));
      result:=false;
      exit;
      end;


    if (indx+2=aind) or (indx+3=aind) then
      begin //Есть еще параметр или два - уже лучше (по-умолчанию назначение в регистр W (0) если параметр один
        if aCaD[indx+1].isDigit then
          begin //Параметр - цифра
            if (aCad[indx+1].DigitDecValue >=0) and (aCad[indx+1].DigitDecValue <=4095)  then
              begin //Входит в диапазон 0..4095 для совсем мощной совместимости с PIC18
              DecToParBin(aCad[indx+1].DigitDecValue);
          CurCom[0]:=parBin[0];
          CurCom[1]:=parBin[1];
          CurCom[2]:=parBin[2];
          CurCom[3]:=parBin[3];
          CurCom[4]:=parBin[4];
          //CurCom[5]:=parBin[5]; //А вот его мы определили выше
          CurCom[6]:=false;
          CurCom[7]:=false;
          CurCom[8]:=true;
          CurCom[9]:=true;
          CurCom[10]:=false;
          CurCom[11]:=false;
          result:=true;
          exit;
              end
              else
              begin //Не входит в диапазон 0..4095
              MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1025));
              result:=false;
              exit;

              end;
          end
          else
          begin //Параметр не цифра
            //Проверим на переменную из EQU
            if aCaD[indx+1].isCorrectVarOrLabel then
              begin
                for J := 0 to aEquSCount-1 do
                if aEquS[J].Name=aCaD[indx+1].str then
                  begin //Да, тут объявленая "переменная" далее
                    DecToParBin(aEquS[J].DecVal);
                    CurCom[0]:=parBin[0];
                    CurCom[1]:=parBin[1];
                    CurCom[2]:=parBin[2];
                    CurCom[3]:=parBin[3];
                    CurCom[4]:=parBin[4];
                    //CurCom[5]:=parBin[5];
                    CurCom[6]:=false;
                    CurCom[7]:=false;
                    CurCom[8]:=true;
                    CurCom[9]:=true;
                    CurCom[10]:=false;
                    CurCom[11]:=false;
                    result:=true;
                    exit;
                  end;
                //Вот здесь необъявленная переменная
                MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1023));
              result:=false;
              exit;
              end
            else
              begin //Вообще что-то неправильное далее, ошибка
               MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1024));
              result:=false;
              exit;
              end;

          end;
      end
    else
      begin //Что-то еще там есть - ошибка
        MarkTextInRT( aCaD[indx+3].txtStart,aCaD[indx+3].txtLong,false,0);
        showmessage(GetText(1020));
        result:=false;
        exit;
      end;

  end;




//DECFSZ


  if aCaD[indx].str= 'DECFSZ' then
  begin
    if (indx+1=aInd)  then
      begin //Больше параметров нет - не хорошо
        MarkTextInRT( aCaD[indx].txtStart,aCaD[indx].txtLong,false,0);
        showmessage(GetText(1021));
        result:=false;
        exit;
      end;
    //Сначала обработаем флаг назначения (если есть)
    CurCom[5]:=false;  //А вдруг - нет, тогда по-умолчанию 0 или W
    if indx+3=aind then
      if aCad[indx+2].isFN then
      begin
      if (aCad[indx+2].str='1') or (aCad[indx+2].str='F')  then CurCom[5]:=true;
      end
      else
      begin //А вот тут ошибка, т.к. 3-й параметр какая-то фигня
      MarkTextInRT( aCaD[indx+2].txtStart,aCaD[indx+2].txtLong,false,0);
      showmessage(GetText(1024));
      result:=false;
      exit;
      end;


    if (indx+2=aind) or (indx+3=aind) then
      begin //Есть еще параметр или два - уже лучше (по-умолчанию назначение в регистр W (0) если параметр один
        if aCaD[indx+1].isDigit then
          begin //Параметр - цифра
            if (aCad[indx+1].DigitDecValue >=0) and (aCad[indx+1].DigitDecValue <=4095)  then
              begin //Входит в диапазон 0..4095 для совсем мощной совместимости с PIC18
              DecToParBin(aCad[indx+1].DigitDecValue);
          CurCom[0]:=parBin[0];
          CurCom[1]:=parBin[1];
          CurCom[2]:=parBin[2];
          CurCom[3]:=parBin[3];
          CurCom[4]:=parBin[4];
          //CurCom[5]:=parBin[5]; //А вот его мы определили выше
          CurCom[6]:=true;
          CurCom[7]:=true;
          CurCom[8]:=false;
          CurCom[9]:=true;
          CurCom[10]:=false;
          CurCom[11]:=false;
          result:=true;
          exit;
              end
              else
              begin //Не входит в диапазон 0..4095
              MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1025));
              result:=false;
              exit;

              end;
          end
          else
          begin //Параметр не цифра
            //Проверим на переменную из EQU
            if aCaD[indx+1].isCorrectVarOrLabel then
              begin
                for J := 0 to aEquSCount-1 do
                if aEquS[J].Name=aCaD[indx+1].str then
                  begin //Да, тут объявленая "переменная" далее
                    DecToParBin(aEquS[J].DecVal);
                    CurCom[0]:=parBin[0];
                    CurCom[1]:=parBin[1];
                    CurCom[2]:=parBin[2];
                    CurCom[3]:=parBin[3];
                    CurCom[4]:=parBin[4];
                    //CurCom[5]:=parBin[5];
                    CurCom[6]:=true;
                    CurCom[7]:=true;
                    CurCom[8]:=false;
                    CurCom[9]:=true;
                    CurCom[10]:=false;
                    CurCom[11]:=false;
                    result:=true;
                    exit;
                  end;
                //Вот здесь необъявленная переменная
                MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1023));
              result:=false;
              exit;
              end
            else
              begin //Вообще что-то неправильное далее, ошибка
               MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1024));
              result:=false;
              exit;
              end;

          end;
      end
    else
      begin //Что-то еще там есть - ошибка
        MarkTextInRT( aCaD[indx+3].txtStart,aCaD[indx+3].txtLong,false,0);
        showmessage(GetText(1020));
        result:=false;
        exit;
      end;

  end;

//INCF



  if aCaD[indx].str= 'INCF' then
  begin
    if (indx+1=aInd)  then
      begin //Больше параметров нет - не хорошо
        MarkTextInRT( aCaD[indx].txtStart,aCaD[indx].txtLong,false,0);
        showmessage(GetText(1021));
        result:=false;
        exit;
      end;
    //Сначала обработаем флаг назначения (если есть)
    CurCom[5]:=false;  //А вдруг - нет, тогда по-умолчанию 0 или W
    if indx+3=aind then
      if aCad[indx+2].isFN then
      begin
      if (aCad[indx+2].str='1') or (aCad[indx+2].str='F')  then CurCom[5]:=true;
      end
      else
      begin //А вот тут ошибка, т.к. 3-й параметр какая-то фигня
      MarkTextInRT( aCaD[indx+2].txtStart,aCaD[indx+2].txtLong,false,0);
      showmessage(GetText(1024));
      result:=false;
      exit;
      end;


    if (indx+2=aind) or (indx+3=aind) then
      begin //Есть еще параметр или два - уже лучше (по-умолчанию назначение в регистр W (0) если параметр один
        if aCaD[indx+1].isDigit then
          begin //Параметр - цифра
            if (aCad[indx+1].DigitDecValue >=0) and (aCad[indx+1].DigitDecValue <=4095)  then
              begin //Входит в диапазон 0..4095 для совсем мощной совместимости с PIC18
              DecToParBin(aCad[indx+1].DigitDecValue);
          CurCom[0]:=parBin[0];
          CurCom[1]:=parBin[1];
          CurCom[2]:=parBin[2];
          CurCom[3]:=parBin[3];
          CurCom[4]:=parBin[4];
          //CurCom[5]:=parBin[5]; //А вот его мы определили выше
          CurCom[6]:=false;
          CurCom[7]:=true;
          CurCom[8]:=false;
          CurCom[9]:=true;
          CurCom[10]:=false;
          CurCom[11]:=false;
          result:=true;
          exit;
              end
              else
              begin //Не входит в диапазон 0..4095
              MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1025));
              result:=false;
              exit;

              end;
          end
          else
          begin //Параметр не цифра
            //Проверим на переменную из EQU
            if aCaD[indx+1].isCorrectVarOrLabel then
              begin
                for J := 0 to aEquSCount-1 do
                if aEquS[J].Name=aCaD[indx+1].str then
                  begin //Да, тут объявленая "переменная" далее
                    DecToParBin(aEquS[J].DecVal);
                    CurCom[0]:=parBin[0];
                    CurCom[1]:=parBin[1];
                    CurCom[2]:=parBin[2];
                    CurCom[3]:=parBin[3];
                    CurCom[4]:=parBin[4];
                    //CurCom[5]:=parBin[5];
                    CurCom[6]:=false;
                    CurCom[7]:=true;
                    CurCom[8]:=false;
                    CurCom[9]:=true;
                    CurCom[10]:=false;
                    CurCom[11]:=false;
                    result:=true;
                    exit;
                  end;
                //Вот здесь необъявленная переменная
                MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1023));
              result:=false;
              exit;
              end
            else
              begin //Вообще что-то неправильное далее, ошибка
               MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1024));
              result:=false;
              exit;
              end;

          end;
      end
    else
      begin //Что-то еще там есть - ошибка
        MarkTextInRT( aCaD[indx+3].txtStart,aCaD[indx+3].txtLong,false,0);
        showmessage(GetText(1020));
        result:=false;
        exit;
      end;

  end;



//COMF




  if aCaD[indx].str= 'COMF' then
  begin
    if (indx+1=aInd)  then
      begin //Больше параметров нет - не хорошо
        MarkTextInRT( aCaD[indx].txtStart,aCaD[indx].txtLong,false,0);
        showmessage(GetText(1021));
        result:=false;
        exit;
      end;
    //Сначала обработаем флаг назначения (если есть)
    CurCom[5]:=false;  //А вдруг - нет, тогда по-умолчанию 0 или W
    if indx+3=aind then
      if aCad[indx+2].isFN then
      begin
      if (aCad[indx+2].str='1') or (aCad[indx+2].str='F')  then CurCom[5]:=true;
      end
      else
      begin //А вот тут ошибка, т.к. 3-й параметр какая-то фигня
      MarkTextInRT( aCaD[indx+2].txtStart,aCaD[indx+2].txtLong,false,0);
      showmessage(GetText(1024));
      result:=false;
      exit;
      end;


    if (indx+2=aind) or (indx+3=aind) then
      begin //Есть еще параметр или два - уже лучше (по-умолчанию назначение в регистр W (0) если параметр один
        if aCaD[indx+1].isDigit then
          begin //Параметр - цифра
            if (aCad[indx+1].DigitDecValue >=0) and (aCad[indx+1].DigitDecValue <=4095)  then
              begin //Входит в диапазон 0..4095 для совсем мощной совместимости с PIC18
              DecToParBin(aCad[indx+1].DigitDecValue);
          CurCom[0]:=parBin[0];
          CurCom[1]:=parBin[1];
          CurCom[2]:=parBin[2];
          CurCom[3]:=parBin[3];
          CurCom[4]:=parBin[4];
          //CurCom[5]:=parBin[5]; //А вот его мы определили выше
          CurCom[6]:=true;
          CurCom[7]:=false;
          CurCom[8]:=false;
          CurCom[9]:=true;
          CurCom[10]:=false;
          CurCom[11]:=false;
          result:=true;
          exit;
              end
              else
              begin //Не входит в диапазон 0..4095
              MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1025));
              result:=false;
              exit;

              end;
          end
          else
          begin //Параметр не цифра
            //Проверим на переменную из EQU
            if aCaD[indx+1].isCorrectVarOrLabel then
              begin
                for J := 0 to aEquSCount-1 do
                if aEquS[J].Name=aCaD[indx+1].str then
                  begin //Да, тут объявленая "переменная" далее
                    DecToParBin(aEquS[J].DecVal);
                    CurCom[0]:=parBin[0];
                    CurCom[1]:=parBin[1];
                    CurCom[2]:=parBin[2];
                    CurCom[3]:=parBin[3];
                    CurCom[4]:=parBin[4];
                    //CurCom[5]:=parBin[5];
                    CurCom[6]:=true;
                    CurCom[7]:=false;
                    CurCom[8]:=false;
                    CurCom[9]:=true;
                    CurCom[10]:=false;
                    CurCom[11]:=false;
                    result:=true;
                    exit;
                  end;
                //Вот здесь необъявленная переменная
                MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1023));
              result:=false;
              exit;
              end
            else
              begin //Вообще что-то неправильное далее, ошибка
               MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1024));
              result:=false;
              exit;
              end;

          end;
      end
    else
      begin //Что-то еще там есть - ошибка
        MarkTextInRT( aCaD[indx+3].txtStart,aCaD[indx+3].txtLong,false,0);
        showmessage(GetText(1020));
        result:=false;
        exit;
      end;

  end;





//MOVF




  if aCaD[indx].str= 'MOVF' then
  begin
    if (indx+1=aInd)  then
      begin //Больше параметров нет - не хорошо
        MarkTextInRT( aCaD[indx].txtStart,aCaD[indx].txtLong,false,0);
        showmessage(GetText(1021));
        result:=false;
        exit;
      end;
    //Сначала обработаем флаг назначения (если есть)
    CurCom[5]:=false;  //А вдруг - нет, тогда по-умолчанию 0 или W
    if indx+3=aind then
      if aCad[indx+2].isFN then
      begin
      if (aCad[indx+2].str='1') or (aCad[indx+2].str='F')  then CurCom[5]:=true;
      end
      else
      begin //А вот тут ошибка, т.к. 3-й параметр какая-то фигня
      MarkTextInRT( aCaD[indx+2].txtStart,aCaD[indx+2].txtLong,false,0);
      showmessage(GetText(1024));
      result:=false;
      exit;
      end;


    if (indx+2=aind) or (indx+3=aind) then
      begin //Есть еще параметр или два - уже лучше (по-умолчанию назначение в регистр W (0) если параметр один
        if aCaD[indx+1].isDigit then
          begin //Параметр - цифра
            if (aCad[indx+1].DigitDecValue >=0) and (aCad[indx+1].DigitDecValue <=4095)  then
              begin //Входит в диапазон 0..4095 для совсем мощной совместимости с PIC18
              DecToParBin(aCad[indx+1].DigitDecValue);
          CurCom[0]:=parBin[0];
          CurCom[1]:=parBin[1];
          CurCom[2]:=parBin[2];
          CurCom[3]:=parBin[3];
          CurCom[4]:=parBin[4];
          //CurCom[5]:=parBin[5]; //А вот его мы определили выше
          CurCom[6]:=false;
          CurCom[7]:=false;
          CurCom[8]:=false;
          CurCom[9]:=true;
          CurCom[10]:=false;
          CurCom[11]:=false;
          result:=true;
          exit;
              end
              else
              begin //Не входит в диапазон 0..4095
              MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1025));
              result:=false;
              exit;

              end;
          end
          else
          begin //Параметр не цифра
            //Проверим на переменную из EQU
            if aCaD[indx+1].isCorrectVarOrLabel then
              begin
                for J := 0 to aEquSCount-1 do
                if aEquS[J].Name=aCaD[indx+1].str then
                  begin //Да, тут объявленая "переменная" далее
                    DecToParBin(aEquS[J].DecVal);
                    CurCom[0]:=parBin[0];
                    CurCom[1]:=parBin[1];
                    CurCom[2]:=parBin[2];
                    CurCom[3]:=parBin[3];
                    CurCom[4]:=parBin[4];
                    //CurCom[5]:=parBin[5];
                    CurCom[6]:=false;
                    CurCom[7]:=false;
                    CurCom[8]:=false;
                    CurCom[9]:=true;
                    CurCom[10]:=false;
                    CurCom[11]:=false;
                    result:=true;
                    exit;
                  end;
                //Вот здесь необъявленная переменная
                MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1023));
              result:=false;
              exit;
              end
            else
              begin //Вообще что-то неправильное далее, ошибка
               MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1024));
              result:=false;
              exit;
              end;

          end;
      end
    else
      begin //Что-то еще там есть - ошибка
        MarkTextInRT( aCaD[indx+3].txtStart,aCaD[indx+3].txtLong,false,0);
        showmessage(GetText(1020));
        result:=false;
        exit;
      end;

  end;







//ADDWF




  if aCaD[indx].str= 'ADDWF' then
  begin
    if (indx+1=aInd)  then
      begin //Больше параметров нет - не хорошо
        MarkTextInRT( aCaD[indx].txtStart,aCaD[indx].txtLong,false,0);
        showmessage(GetText(1021));
        result:=false;
        exit;
      end;
    //Сначала обработаем флаг назначения (если есть)
    CurCom[5]:=false;  //А вдруг - нет, тогда по-умолчанию 0 или W
    if indx+3=aind then
      if aCad[indx+2].isFN then
      begin
      if (aCad[indx+2].str='1') or (aCad[indx+2].str='F')  then CurCom[5]:=true;
      end
      else
      begin //А вот тут ошибка, т.к. 3-й параметр какая-то фигня
      MarkTextInRT( aCaD[indx+2].txtStart,aCaD[indx+2].txtLong,false,0);
      showmessage(GetText(1024));
      result:=false;
      exit;
      end;


    if (indx+2=aind) or (indx+3=aind) then
      begin //Есть еще параметр или два - уже лучше (по-умолчанию назначение в регистр W (0) если параметр один
        if aCaD[indx+1].isDigit then
          begin //Параметр - цифра
            if (aCad[indx+1].DigitDecValue >=0) and (aCad[indx+1].DigitDecValue <=4095)  then
              begin //Входит в диапазон 0..4095 для совсем мощной совместимости с PIC18
              DecToParBin(aCad[indx+1].DigitDecValue);
          CurCom[0]:=parBin[0];
          CurCom[1]:=parBin[1];
          CurCom[2]:=parBin[2];
          CurCom[3]:=parBin[3];
          CurCom[4]:=parBin[4];
          //CurCom[5]:=parBin[5]; //А вот его мы определили выше
          CurCom[6]:=true;
          CurCom[7]:=true;
          CurCom[8]:=true;
          CurCom[9]:=false;
          CurCom[10]:=false;
          CurCom[11]:=false;
          result:=true;
          exit;
              end
              else
              begin //Не входит в диапазон 0..4095
              MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1025));
              result:=false;
              exit;

              end;
          end
          else
          begin //Параметр не цифра
            //Проверим на переменную из EQU
            if aCaD[indx+1].isCorrectVarOrLabel then
              begin
                for J := 0 to aEquSCount-1 do
                if aEquS[J].Name=aCaD[indx+1].str then
                  begin //Да, тут объявленая "переменная" далее
                    DecToParBin(aEquS[J].DecVal);
                    CurCom[0]:=parBin[0];
                    CurCom[1]:=parBin[1];
                    CurCom[2]:=parBin[2];
                    CurCom[3]:=parBin[3];
                    CurCom[4]:=parBin[4];
                    //CurCom[5]:=parBin[5];
                    CurCom[6]:=true;
                    CurCom[7]:=true;
                    CurCom[8]:=true;
                    CurCom[9]:=false;
                    CurCom[10]:=false;
                    CurCom[11]:=false;
                    result:=true;
                    exit;
                  end;
                //Вот здесь необъявленная переменная
                MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1023));
              result:=false;
              exit;
              end
            else
              begin //Вообще что-то неправильное далее, ошибка
               MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1024));
              result:=false;
              exit;
              end;

          end;
      end
    else
      begin //Что-то еще там есть - ошибка
        MarkTextInRT( aCaD[indx+3].txtStart,aCaD[indx+3].txtLong,false,0);
        showmessage(GetText(1020));
        result:=false;
        exit;
      end;

  end;





//XORWF




  if aCaD[indx].str= 'XORWF' then
  begin
    if (indx+1=aInd)  then
      begin //Больше параметров нет - не хорошо
        MarkTextInRT( aCaD[indx].txtStart,aCaD[indx].txtLong,false,0);
        showmessage(GetText(1021));
        result:=false;
        exit;
      end;
    //Сначала обработаем флаг назначения (если есть)
    CurCom[5]:=false;  //А вдруг - нет, тогда по-умолчанию 0 или W
    if indx+3=aind then
      if aCad[indx+2].isFN then
      begin
      if (aCad[indx+2].str='1') or (aCad[indx+2].str='F')  then CurCom[5]:=true;
      end
      else
      begin //А вот тут ошибка, т.к. 3-й параметр какая-то фигня
      MarkTextInRT( aCaD[indx+2].txtStart,aCaD[indx+2].txtLong,false,0);
      showmessage(GetText(1024));
      result:=false;
      exit;
      end;


    if (indx+2=aind) or (indx+3=aind) then
      begin //Есть еще параметр или два - уже лучше (по-умолчанию назначение в регистр W (0) если параметр один
        if aCaD[indx+1].isDigit then
          begin //Параметр - цифра
            if (aCad[indx+1].DigitDecValue >=0) and (aCad[indx+1].DigitDecValue <=4095)  then
              begin //Входит в диапазон 0..4095 для совсем мощной совместимости с PIC18
              DecToParBin(aCad[indx+1].DigitDecValue);
          CurCom[0]:=parBin[0];
          CurCom[1]:=parBin[1];
          CurCom[2]:=parBin[2];
          CurCom[3]:=parBin[3];
          CurCom[4]:=parBin[4];
          //CurCom[5]:=parBin[5]; //А вот его мы определили выше
          CurCom[6]:=false;
          CurCom[7]:=true;
          CurCom[8]:=true;
          CurCom[9]:=false;
          CurCom[10]:=false;
          CurCom[11]:=false;
          result:=true;
          exit;
              end
              else
              begin //Не входит в диапазон 0..4095
              MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1025));
              result:=false;
              exit;

              end;
          end
          else
          begin //Параметр не цифра
            //Проверим на переменную из EQU
            if aCaD[indx+1].isCorrectVarOrLabel then
              begin
                for J := 0 to aEquSCount-1 do
                if aEquS[J].Name=aCaD[indx+1].str then
                  begin //Да, тут объявленая "переменная" далее
                    DecToParBin(aEquS[J].DecVal);
                    CurCom[0]:=parBin[0];
                    CurCom[1]:=parBin[1];
                    CurCom[2]:=parBin[2];
                    CurCom[3]:=parBin[3];
                    CurCom[4]:=parBin[4];
                    //CurCom[5]:=parBin[5];
                    CurCom[6]:=false;
                    CurCom[7]:=true;
                    CurCom[8]:=true;
                    CurCom[9]:=false;
                    CurCom[10]:=false;
                    CurCom[11]:=false;
                    result:=true;
                    exit;
                  end;
                //Вот здесь необъявленная переменная
                MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1023));
              result:=false;
              exit;
              end
            else
              begin //Вообще что-то неправильное далее, ошибка
               MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1024));
              result:=false;
              exit;
              end;

          end;
      end
    else
      begin //Что-то еще там есть - ошибка
        MarkTextInRT( aCaD[indx+3].txtStart,aCaD[indx+3].txtLong,false,0);
        showmessage(GetText(1020));
        result:=false;
        exit;
      end;

  end;





//ANDWF




  if aCaD[indx].str= 'ANDWF' then
  begin
    if (indx+1=aInd)  then
      begin //Больше параметров нет - не хорошо
        MarkTextInRT( aCaD[indx].txtStart,aCaD[indx].txtLong,false,0);
        showmessage(GetText(1021));
        result:=false;
        exit;
      end;
    //Сначала обработаем флаг назначения (если есть)
    CurCom[5]:=false;  //А вдруг - нет, тогда по-умолчанию 0 или W
    if indx+3=aind then
      if aCad[indx+2].isFN then
      begin
      if (aCad[indx+2].str='1') or (aCad[indx+2].str='F')  then CurCom[5]:=true;
      end
      else
      begin //А вот тут ошибка, т.к. 3-й параметр какая-то фигня
      MarkTextInRT( aCaD[indx+2].txtStart,aCaD[indx+2].txtLong,false,0);
      showmessage(GetText(1024));
      result:=false;
      exit;
      end;


    if (indx+2=aind) or (indx+3=aind) then
      begin //Есть еще параметр или два - уже лучше (по-умолчанию назначение в регистр W (0) если параметр один
        if aCaD[indx+1].isDigit then
          begin //Параметр - цифра
            if (aCad[indx+1].DigitDecValue >=0) and (aCad[indx+1].DigitDecValue <=4095)  then
              begin //Входит в диапазон 0..4095 для совсем мощной совместимости с PIC18
              DecToParBin(aCad[indx+1].DigitDecValue);
          CurCom[0]:=parBin[0];
          CurCom[1]:=parBin[1];
          CurCom[2]:=parBin[2];
          CurCom[3]:=parBin[3];
          CurCom[4]:=parBin[4];
          //CurCom[5]:=parBin[5]; //А вот его мы определили выше
          CurCom[6]:=true;
          CurCom[7]:=false;
          CurCom[8]:=true;
          CurCom[9]:=false;
          CurCom[10]:=false;
          CurCom[11]:=false;
          result:=true;
          exit;
              end
              else
              begin //Не входит в диапазон 0..4095
              MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1025));
              result:=false;
              exit;

              end;
          end
          else
          begin //Параметр не цифра
            //Проверим на переменную из EQU
            if aCaD[indx+1].isCorrectVarOrLabel then
              begin
                for J := 0 to aEquSCount-1 do
                if aEquS[J].Name=aCaD[indx+1].str then
                  begin //Да, тут объявленая "переменная" далее
                    DecToParBin(aEquS[J].DecVal);
                    CurCom[0]:=parBin[0];
                    CurCom[1]:=parBin[1];
                    CurCom[2]:=parBin[2];
                    CurCom[3]:=parBin[3];
                    CurCom[4]:=parBin[4];
                    //CurCom[5]:=parBin[5];
                    CurCom[6]:=true;
                    CurCom[7]:=false;
                    CurCom[8]:=true;
                    CurCom[9]:=false;
                    CurCom[10]:=false;
                    CurCom[11]:=false;
                    result:=true;
                    exit;
                  end;
                //Вот здесь необъявленная переменная
                MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1023));
              result:=false;
              exit;
              end
            else
              begin //Вообще что-то неправильное далее, ошибка
               MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1024));
              result:=false;
              exit;
              end;

          end;
      end
    else
      begin //Что-то еще там есть - ошибка
        MarkTextInRT( aCaD[indx+3].txtStart,aCaD[indx+3].txtLong,false,0);
        showmessage(GetText(1020));
        result:=false;
        exit;
      end;

  end;





//IORWF




  if aCaD[indx].str= 'IORWF' then
  begin
    if (indx+1=aInd)  then
      begin //Больше параметров нет - не хорошо
        MarkTextInRT( aCaD[indx].txtStart,aCaD[indx].txtLong,false,0);
        showmessage(GetText(1021));
        result:=false;
        exit;
      end;
    //Сначала обработаем флаг назначения (если есть)
    CurCom[5]:=false;  //А вдруг - нет, тогда по-умолчанию 0 или W
    if indx+3=aind then
      if aCad[indx+2].isFN then
      begin
      if (aCad[indx+2].str='1') or (aCad[indx+2].str='F')  then CurCom[5]:=true;
      end
      else
      begin //А вот тут ошибка, т.к. 3-й параметр какая-то фигня
      MarkTextInRT( aCaD[indx+2].txtStart,aCaD[indx+2].txtLong,false,0);
      showmessage(GetText(1024));
      result:=false;
      exit;
      end;


    if (indx+2=aind) or (indx+3=aind) then
      begin //Есть еще параметр или два - уже лучше (по-умолчанию назначение в регистр W (0) если параметр один
        if aCaD[indx+1].isDigit then
          begin //Параметр - цифра
            if (aCad[indx+1].DigitDecValue >=0) and (aCad[indx+1].DigitDecValue <=4095)  then
              begin //Входит в диапазон 0..4095 для совсем мощной совместимости с PIC18
              DecToParBin(aCad[indx+1].DigitDecValue);
          CurCom[0]:=parBin[0];
          CurCom[1]:=parBin[1];
          CurCom[2]:=parBin[2];
          CurCom[3]:=parBin[3];
          CurCom[4]:=parBin[4];
          //CurCom[5]:=parBin[5]; //А вот его мы определили выше
          CurCom[6]:=false;
          CurCom[7]:=false;
          CurCom[8]:=true;
          CurCom[9]:=false;
          CurCom[10]:=false;
          CurCom[11]:=false;
          result:=true;
          exit;
              end
              else
              begin //Не входит в диапазон 0..4095
              MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1025));
              result:=false;
              exit;

              end;
          end
          else
          begin //Параметр не цифра
            //Проверим на переменную из EQU
            if aCaD[indx+1].isCorrectVarOrLabel then
              begin
                for J := 0 to aEquSCount-1 do
                if aEquS[J].Name=aCaD[indx+1].str then
                  begin //Да, тут объявленая "переменная" далее
                    DecToParBin(aEquS[J].DecVal);
                    CurCom[0]:=parBin[0];
                    CurCom[1]:=parBin[1];
                    CurCom[2]:=parBin[2];
                    CurCom[3]:=parBin[3];
                    CurCom[4]:=parBin[4];
                    //CurCom[5]:=parBin[5];
                    CurCom[6]:=false;
                    CurCom[7]:=false;
                    CurCom[8]:=true;
                    CurCom[9]:=false;
                    CurCom[10]:=false;
                    CurCom[11]:=false;
                    result:=true;
                    exit;
                  end;
                //Вот здесь необъявленная переменная
                MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1023));
              result:=false;
              exit;
              end
            else
              begin //Вообще что-то неправильное далее, ошибка
               MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1024));
              result:=false;
              exit;
              end;

          end;
      end
    else
      begin //Что-то еще там есть - ошибка
        MarkTextInRT( aCaD[indx+3].txtStart,aCaD[indx+3].txtLong,false,0);
        showmessage(GetText(1020));
        result:=false;
        exit;
      end;

  end;





//DECF




  if aCaD[indx].str= 'DECF' then
  begin
    if (indx+1=aInd)  then
      begin //Больше параметров нет - не хорошо
        MarkTextInRT( aCaD[indx].txtStart,aCaD[indx].txtLong,false,0);
        showmessage(GetText(1021));
        result:=false;
        exit;
      end;
    //Сначала обработаем флаг назначения (если есть)
    CurCom[5]:=false;  //А вдруг - нет, тогда по-умолчанию 0 или W
    if indx+3=aind then
      if aCad[indx+2].isFN then
      begin
      if (aCad[indx+2].str='1') or (aCad[indx+2].str='F')  then CurCom[5]:=true;
      end
      else
      begin //А вот тут ошибка, т.к. 3-й параметр какая-то фигня
      MarkTextInRT( aCaD[indx+2].txtStart,aCaD[indx+2].txtLong,false,0);
      showmessage(GetText(1024));
      result:=false;
      exit;
      end;


    if (indx+2=aind) or (indx+3=aind) then
      begin //Есть еще параметр или два - уже лучше (по-умолчанию назначение в регистр W (0) если параметр один
        if aCaD[indx+1].isDigit then
          begin //Параметр - цифра
            if (aCad[indx+1].DigitDecValue >=0) and (aCad[indx+1].DigitDecValue <=4095)  then
              begin //Входит в диапазон 0..4095 для совсем мощной совместимости с PIC18
              DecToParBin(aCad[indx+1].DigitDecValue);
          CurCom[0]:=parBin[0];
          CurCom[1]:=parBin[1];
          CurCom[2]:=parBin[2];
          CurCom[3]:=parBin[3];
          CurCom[4]:=parBin[4];
          //CurCom[5]:=parBin[5]; //А вот его мы определили выше
          CurCom[6]:=true;
          CurCom[7]:=true;
          CurCom[8]:=false;
          CurCom[9]:=false;
          CurCom[10]:=false;
          CurCom[11]:=false;
          result:=true;
          exit;
              end
              else
              begin //Не входит в диапазон 0..4095
              MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1025));
              result:=false;
              exit;

              end;
          end
          else
          begin //Параметр не цифра
            //Проверим на переменную из EQU
            if aCaD[indx+1].isCorrectVarOrLabel then
              begin
                for J := 0 to aEquSCount-1 do
                if aEquS[J].Name=aCaD[indx+1].str then
                  begin //Да, тут объявленая "переменная" далее
                    DecToParBin(aEquS[J].DecVal);
                    CurCom[0]:=parBin[0];
                    CurCom[1]:=parBin[1];
                    CurCom[2]:=parBin[2];
                    CurCom[3]:=parBin[3];
                    CurCom[4]:=parBin[4];
                    //CurCom[5]:=parBin[5];
                    CurCom[6]:=true;
                    CurCom[7]:=true;
                    CurCom[8]:=false;
                    CurCom[9]:=false;
                    CurCom[10]:=false;
                    CurCom[11]:=false;
                    result:=true;
                    exit;
                  end;
                //Вот здесь необъявленная переменная
                MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1023));
              result:=false;
              exit;
              end
            else
              begin //Вообще что-то неправильное далее, ошибка
               MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1024));
              result:=false;
              exit;
              end;

          end;
      end
    else
      begin //Что-то еще там есть - ошибка
        MarkTextInRT( aCaD[indx+3].txtStart,aCaD[indx+3].txtLong,false,0);
        showmessage(GetText(1020));
        result:=false;
        exit;
      end;

  end;


//SUBWF




  if aCaD[indx].str= 'SUBWF' then
  begin
    if (indx+1=aInd)  then
      begin //Больше параметров нет - не хорошо
        MarkTextInRT( aCaD[indx].txtStart,aCaD[indx].txtLong,false,0);
        showmessage(GetText(1021));
        result:=false;
        exit;
      end;
    //Сначала обработаем флаг назначения (если есть)
    CurCom[5]:=false;  //А вдруг - нет, тогда по-умолчанию 0 или W
    if indx+3=aind then
      if aCad[indx+2].isFN then
      begin
      if (aCad[indx+2].str='1') or (aCad[indx+2].str='F')  then CurCom[5]:=true;
      end
      else
      begin //А вот тут ошибка, т.к. 3-й параметр какая-то фигня
      MarkTextInRT( aCaD[indx+2].txtStart,aCaD[indx+2].txtLong,false,0);
      showmessage(GetText(1024));
      result:=false;
      exit;
      end;


    if (indx+2=aind) or (indx+3=aind) then
      begin //Есть еще параметр или два - уже лучше (по-умолчанию назначение в регистр W (0) если параметр один
        if aCaD[indx+1].isDigit then
          begin //Параметр - цифра
            if (aCad[indx+1].DigitDecValue >=0) and (aCad[indx+1].DigitDecValue <=4095)  then
              begin //Входит в диапазон 0..4095 для совсем мощной совместимости с PIC18
              DecToParBin(aCad[indx+1].DigitDecValue);
          CurCom[0]:=parBin[0];
          CurCom[1]:=parBin[1];
          CurCom[2]:=parBin[2];
          CurCom[3]:=parBin[3];
          CurCom[4]:=parBin[4];
          //CurCom[5]:=parBin[5]; //А вот его мы определили выше
          CurCom[6]:=false;
          CurCom[7]:=true;
          CurCom[8]:=false;
          CurCom[9]:=false;
          CurCom[10]:=false;
          CurCom[11]:=false;
          result:=true;
          exit;
              end
              else
              begin //Не входит в диапазон 0..4095
              MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1025));
              result:=false;
              exit;

              end;
          end
          else
          begin //Параметр не цифра
            //Проверим на переменную из EQU
            if aCaD[indx+1].isCorrectVarOrLabel then
              begin
                for J := 0 to aEquSCount-1 do
                if aEquS[J].Name=aCaD[indx+1].str then
                  begin //Да, тут объявленая "переменная" далее
                    DecToParBin(aEquS[J].DecVal);
                    CurCom[0]:=parBin[0];
                    CurCom[1]:=parBin[1];
                    CurCom[2]:=parBin[2];
                    CurCom[3]:=parBin[3];
                    CurCom[4]:=parBin[4];
                    //CurCom[5]:=parBin[5];
                    CurCom[6]:=false;
                    CurCom[7]:=true;
                    CurCom[8]:=false;
                    CurCom[9]:=false;
                    CurCom[10]:=false;
                    CurCom[11]:=false;
                    result:=true;
                    exit;
                  end;
                //Вот здесь необъявленная переменная
                MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1023));
              result:=false;
              exit;
              end
            else
              begin //Вообще что-то неправильное далее, ошибка
               MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1024));
              result:=false;
              exit;
              end;

          end;
      end
    else
      begin //Что-то еще там есть - ошибка
        MarkTextInRT( aCaD[indx+3].txtStart,aCaD[indx+3].txtLong,false,0);
        showmessage(GetText(1020));
        result:=false;
        exit;
      end;

  end;



//Далее идут команды, где указываеться только регистр



//CLRF




  if aCaD[indx].str= 'CLRF' then
  begin
    if (indx+1=aInd)  then
      begin //Больше параметров нет - не хорошо
        MarkTextInRT( aCaD[indx].txtStart,aCaD[indx].txtLong,false,0);
        showmessage(GetText(1021));
        result:=false;
        exit;
      end;



    if (indx+2=aind) then
      begin //Есть еще параметр  - уже лучше
        if aCaD[indx+1].isDigit then
          begin //Параметр - цифра
            if (aCad[indx+1].DigitDecValue >=0) and (aCad[indx+1].DigitDecValue <=4095)  then
              begin //Входит в диапазон 0..4095 для совсем мощной совместимости с PIC18
              DecToParBin(aCad[indx+1].DigitDecValue);
          CurCom[0]:=parBin[0];
          CurCom[1]:=parBin[1];
          CurCom[2]:=parBin[2];
          CurCom[3]:=parBin[3];
          CurCom[4]:=parBin[4];
          CurCom[5]:=true;
          CurCom[6]:=true;
          CurCom[7]:=false;
          CurCom[8]:=false;
          CurCom[9]:=false;
          CurCom[10]:=false;
          CurCom[11]:=false;
          result:=true;
          exit;
              end
              else
              begin //Не входит в диапазон 0..4095
              MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1025));
              result:=false;
              exit;

              end;
          end
          else
          begin //Параметр не цифра
            //Проверим на переменную из EQU
            if aCaD[indx+1].isCorrectVarOrLabel then
              begin
                for J := 0 to aEquSCount-1 do
                if aEquS[J].Name=aCaD[indx+1].str then
                  begin //Да, тут объявленая "переменная" далее
                    DecToParBin(aEquS[J].DecVal);
          CurCom[0]:=parBin[0];
          CurCom[1]:=parBin[1];
          CurCom[2]:=parBin[2];
          CurCom[3]:=parBin[3];
          CurCom[4]:=parBin[4];
          CurCom[5]:=true;
          CurCom[6]:=true;
          CurCom[7]:=false;
          CurCom[8]:=false;
          CurCom[9]:=false;
          CurCom[10]:=false;
          CurCom[11]:=false;
                    result:=true;
                    exit;
                  end;
                //Вот здесь необъявленная переменная
                MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1023));
              result:=false;
              exit;
              end
            else
              begin //Вообще что-то неправильное далее, ошибка
               MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1024));
              result:=false;
              exit;
              end;

          end;
      end
    else
      begin //Что-то еще там есть - ошибка
        MarkTextInRT( aCaD[indx+2].txtStart,aCaD[indx+2].txtLong,false,0);
        showmessage(GetText(1020));
        result:=false;
        exit;
      end;

  end;





//MOVWF





  if aCaD[indx].str= 'MOVWF' then
  begin
    if (indx+1=aInd)  then
      begin //Больше параметров нет - не хорошо
        MarkTextInRT( aCaD[indx].txtStart,aCaD[indx].txtLong,false,0);
        showmessage(GetText(1021));
        result:=false;
        exit;
      end;



    if (indx+2=aind) then
      begin //Есть еще параметр  - уже лучше
        if aCaD[indx+1].isDigit then
          begin //Параметр - цифра
            if (aCad[indx+1].DigitDecValue >=0) and (aCad[indx+1].DigitDecValue <=4095)  then
              begin //Входит в диапазон 0..4095 для совсем мощной совместимости с PIC18
              DecToParBin(aCad[indx+1].DigitDecValue);
          CurCom[0]:=parBin[0];
          CurCom[1]:=parBin[1];
          CurCom[2]:=parBin[2];
          CurCom[3]:=parBin[3];
          CurCom[4]:=parBin[4];
          CurCom[5]:=true;
          CurCom[6]:=false;
          CurCom[7]:=false;
          CurCom[8]:=false;
          CurCom[9]:=false;
          CurCom[10]:=false;
          CurCom[11]:=false;
          result:=true;
          exit;
              end
              else
              begin //Не входит в диапазон 0..4095
              MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1025));
              result:=false;
              exit;

              end;
          end
          else
          begin //Параметр не цифра
            //Проверим на переменную из EQU
            if aCaD[indx+1].isCorrectVarOrLabel then
              begin
                for J := 0 to aEquSCount-1 do
                if aEquS[J].Name=aCaD[indx+1].str then
                  begin //Да, тут объявленая "переменная" далее
                    DecToParBin(aEquS[J].DecVal);
          CurCom[0]:=parBin[0];
          CurCom[1]:=parBin[1];
          CurCom[2]:=parBin[2];
          CurCom[3]:=parBin[3];
          CurCom[4]:=parBin[4];
          CurCom[5]:=true;
          CurCom[6]:=false;
          CurCom[7]:=false;
          CurCom[8]:=false;
          CurCom[9]:=false;
          CurCom[10]:=false;
          CurCom[11]:=false;
                    result:=true;
                    exit;
                  end;
                //Вот здесь необъявленная переменная
                MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1023));
              result:=false;
              exit;
              end
            else
              begin //Вообще что-то неправильное далее, ошибка
               MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1024));
              result:=false;
              exit;
              end;

          end;
      end
    else
      begin //Что-то еще там есть - ошибка
        MarkTextInRT( aCaD[indx+2].txtStart,aCaD[indx+2].txtLong,false,0);
        showmessage(GetText(1020));
        result:=false;
        exit;
      end;

  end;

//Далее блок из одной -единственной однотипной команды TRIS 5,6 or 7


  if aCaD[indx].str= 'TRIS' then
  begin
    if (indx+1=aInd)  then
      begin //Больше параметров нет - не хорошо
        MarkTextInRT( aCaD[indx].txtStart,aCaD[indx].txtLong,false,0);
        showmessage(GetText(1021));
        result:=false;
        exit;
      end;



    if (indx+2=aind) then
      begin //Есть еще параметр  - уже лучше
        if aCaD[indx+1].isDigit then
          begin //Параметр - цифра
            if (aCad[indx+1].DigitDecValue >=5) and (aCad[indx+1].DigitDecValue <=9)  then
              begin //Входит в диапазон 5..9

              DecToParBin(aCad[indx+1].DigitDecValue);
          CurCom[0]:=parBin[0];
          CurCom[1]:=parBin[1];
          CurCom[2]:=parBin[2];
          CurCom[3]:=parBin[3];
          CurCom[4]:=false;
          CurCom[5]:=false;
          CurCom[6]:=false;
          CurCom[7]:=false;
          CurCom[8]:=false;
          CurCom[9]:=false;
          CurCom[10]:=false;
          CurCom[11]:=false;
          result:=true;
          exit;
              end
              else
              begin //Не входит в диапазон 5..9
              MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1025));
              result:=false;
              exit;

              end;
          end
          else
          begin //Параметр не цифра

               MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1024));
              result:=false;
              exit;


          end;
      end
    else
      begin //Что-то еще там есть - ошибка
        MarkTextInRT( aCaD[indx+2].txtStart,aCaD[indx+2].txtLong,false,0);
        showmessage(GetText(1020));
        result:=false;
        exit;
      end;

  end;



//Далее блок команд, где нужно указать сначала регистр, затем бит


//BTFSS



 if aCaD[indx].str= 'BTFSS' then
  begin
    if (indx+1=aInd)  then
      begin //Больше параметров нет - не хорошо
        MarkTextInRT( aCaD[indx].txtStart,aCaD[indx].txtLong,false,0);
        showmessage(GetText(1021));
        result:=false;
        exit;
      end;
    //Сначала обработаем флаг назначения (если есть)
    CurCom[5]:=false;  //А вдруг - нет, тогда по-умолчанию 0
    CurCom[6]:=false;
    CurCom[7]:=false;
    if indx+3=aind then //А вот тут значит, что если есть еще 2 параметра кроме команды
      if aCad[indx+2].isNoBit then
      begin
      DecToParBin(StrToInt(aCad[indx+2].str));
      CurCom[5]:=parBin[0];
      CurCom[6]:=parBin[1];
      CurCom[7]:=parBin[2];
      end
      else
      begin //А вот тут ошибка, т.к. 3-й параметр какая-то фигня
      MarkTextInRT( aCaD[indx+2].txtStart,aCaD[indx+2].txtLong,false,0);
      showmessage(GetText(1024));
      result:=false;
      exit;
      end;


    if (indx+2=aind) or (indx+3=aind) then
      begin //Есть еще параметр или два - уже лучше (по-умолчанию назначение в регистр W (0) если параметр один
        if aCaD[indx+1].isDigit then
          begin //Параметр - цифра
            if (aCad[indx+1].DigitDecValue >=0) and (aCad[indx+1].DigitDecValue <=4095)  then
              begin //Входит в диапазон 0..4095 для совсем мощной совместимости с PIC18
              DecToParBin(aCad[indx+1].DigitDecValue);
          CurCom[0]:=parBin[0];
          CurCom[1]:=parBin[1];
          CurCom[2]:=parBin[2];
          CurCom[3]:=parBin[3];
          CurCom[4]:=parBin[4];
          //CurCom[5]:=parBin[5]; //А вот его мы определили выше
          //CurCom[6]:=false;
          //CurCom[7]:=true;
          CurCom[8]:=true;
          CurCom[9]:=true;
          CurCom[10]:=true;
          CurCom[11]:=false;
          result:=true;
          exit;
              end
              else
              begin //Не входит в диапазон 0..4095
              MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1025));
              result:=false;
              exit;

              end;
          end
          else
          begin //Параметр не цифра
            //Проверим на переменную из EQU
            if aCaD[indx+1].isCorrectVarOrLabel then
              begin
                for J := 0 to aEquSCount-1 do
                if aEquS[J].Name=aCaD[indx+1].str then
                  begin //Да, тут объявленая "переменная" далее
                    DecToParBin(aEquS[J].DecVal);
                    CurCom[0]:=parBin[0];
                    CurCom[1]:=parBin[1];
                    CurCom[2]:=parBin[2];
                    CurCom[3]:=parBin[3];
                    CurCom[4]:=parBin[4];
                    //CurCom[5]:=parBin[5];
                    //CurCom[6]:=false;
                    //CurCom[7]:=true;
                    CurCom[8]:=true;
                    CurCom[9]:=true;
                    CurCom[10]:=true;
                    CurCom[11]:=false;
                    result:=true;
                    exit;
                  end;
                //Вот здесь необъявленная переменная
                MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1023));
              result:=false;
              exit;
              end
            else
              begin //Вообще что-то неправильное далее, ошибка
               MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1024));
              result:=false;
              exit;
              end;

          end;
      end
    else
      begin //Что-то еще там есть - ошибка
        MarkTextInRT( aCaD[indx+3].txtStart,aCaD[indx+3].txtLong,false,0);
        showmessage(GetText(1020));
        result:=false;
        exit;
      end;

  end;



  //BTFSC



 if aCaD[indx].str= 'BTFSC' then
  begin
    if (indx+1=aInd)  then
      begin //Больше параметров нет - не хорошо
        MarkTextInRT( aCaD[indx].txtStart,aCaD[indx].txtLong,false,0);
        showmessage(GetText(1021));
        result:=false;
        exit;
      end;
    //Сначала обработаем флаг назначения (если есть)
    CurCom[5]:=false;  //А вдруг - нет, тогда по-умолчанию 0
    CurCom[6]:=false;
    CurCom[7]:=false;
    if indx+3=aind then //А вот тут значит, что если есть еще 2 параметра кроме команды
      if aCad[indx+2].isNoBit then
      begin
      DecToParBin(StrToInt(aCad[indx+2].str));
      CurCom[5]:=parBin[0];
      CurCom[6]:=parBin[1];
      CurCom[7]:=parBin[2];
      end
      else
      begin //А вот тут ошибка, т.к. 3-й параметр какая-то фигня
      MarkTextInRT( aCaD[indx+2].txtStart,aCaD[indx+2].txtLong,false,0);
      showmessage(GetText(1024));
      result:=false;
      exit;
      end;


    if (indx+2=aind) or (indx+3=aind) then
      begin //Есть еще параметр или два - уже лучше (по-умолчанию назначение в регистр W (0) если параметр один
        if aCaD[indx+1].isDigit then
          begin //Параметр - цифра
            if (aCad[indx+1].DigitDecValue >=0) and (aCad[indx+1].DigitDecValue <=4095)  then
              begin //Входит в диапазон 0..4095 для совсем мощной совместимости с PIC18
              DecToParBin(aCad[indx+1].DigitDecValue);
          CurCom[0]:=parBin[0];
          CurCom[1]:=parBin[1];
          CurCom[2]:=parBin[2];
          CurCom[3]:=parBin[3];
          CurCom[4]:=parBin[4];
          //CurCom[5]:=parBin[5]; //А вот его мы определили выше
          //CurCom[6]:=false;
          //CurCom[7]:=true;
          CurCom[8]:=false;
          CurCom[9]:=true;
          CurCom[10]:=true;
          CurCom[11]:=false;
          result:=true;
          exit;
              end
              else
              begin //Не входит в диапазон 0..4095
              MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1025));
              result:=false;
              exit;

              end;
          end
          else
          begin //Параметр не цифра
            //Проверим на переменную из EQU
            if aCaD[indx+1].isCorrectVarOrLabel then
              begin
                for J := 0 to aEquSCount-1 do
                if aEquS[J].Name=aCaD[indx+1].str then
                  begin //Да, тут объявленая "переменная" далее
                    DecToParBin(aEquS[J].DecVal);
                    CurCom[0]:=parBin[0];
                    CurCom[1]:=parBin[1];
                    CurCom[2]:=parBin[2];
                    CurCom[3]:=parBin[3];
                    CurCom[4]:=parBin[4];
                    //CurCom[5]:=parBin[5];
                    //CurCom[6]:=false;
                    //CurCom[7]:=true;
                    CurCom[8]:=false;
                    CurCom[9]:=true;
                    CurCom[10]:=true;
                    CurCom[11]:=false;
                    result:=true;
                    exit;
                  end;
                //Вот здесь необъявленная переменная
                MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1023));
              result:=false;
              exit;
              end
            else
              begin //Вообще что-то неправильное далее, ошибка
               MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1024));
              result:=false;
              exit;
              end;

          end;
      end
    else
      begin //Что-то еще там есть - ошибка
        MarkTextInRT( aCaD[indx+3].txtStart,aCaD[indx+3].txtLong,false,0);
        showmessage(GetText(1020));
        result:=false;
        exit;
      end;

  end;





  //BSF



 if aCaD[indx].str= 'BSF' then
  begin
    if (indx+1=aInd)  then
      begin //Больше параметров нет - не хорошо
        MarkTextInRT( aCaD[indx].txtStart,aCaD[indx].txtLong,false,0);
        showmessage(GetText(1021));
        result:=false;
        exit;
      end;
    //Сначала обработаем флаг назначения (если есть)
    CurCom[5]:=false;  //А вдруг - нет, тогда по-умолчанию 0
    CurCom[6]:=false;
    CurCom[7]:=false;
    if indx+3=aind then //А вот тут значит, что если есть еще 2 параметра кроме команды
      if aCad[indx+2].isNoBit then
      begin
      DecToParBin(StrToInt(aCad[indx+2].str));
      CurCom[5]:=parBin[0];
      CurCom[6]:=parBin[1];
      CurCom[7]:=parBin[2];
      end
      else
      begin //А вот тут ошибка, т.к. 3-й параметр какая-то фигня
      MarkTextInRT( aCaD[indx+2].txtStart,aCaD[indx+2].txtLong,false,0);
      showmessage(GetText(1024));
      result:=false;
      exit;
      end;


    if (indx+2=aind) or (indx+3=aind) then
      begin //Есть еще параметр или два - уже лучше (по-умолчанию назначение в регистр W (0) если параметр один
        if aCaD[indx+1].isDigit then
          begin //Параметр - цифра
            if (aCad[indx+1].DigitDecValue >=0) and (aCad[indx+1].DigitDecValue <=4095)  then
              begin //Входит в диапазон 0..4095 для совсем мощной совместимости с PIC18
              DecToParBin(aCad[indx+1].DigitDecValue);
          CurCom[0]:=parBin[0];
          CurCom[1]:=parBin[1];
          CurCom[2]:=parBin[2];
          CurCom[3]:=parBin[3];
          CurCom[4]:=parBin[4];
          //CurCom[5]:=parBin[5]; //А вот его мы определили выше
          //CurCom[6]:=false;
          //CurCom[7]:=true;
          CurCom[8]:=true;
          CurCom[9]:=false;
          CurCom[10]:=true;
          CurCom[11]:=false;
          result:=true;
          exit;
              end
              else
              begin //Не входит в диапазон 0..4095
              MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1025));
              result:=false;
              exit;

              end;
          end
          else
          begin //Параметр не цифра
            //Проверим на переменную из EQU
            if aCaD[indx+1].isCorrectVarOrLabel then
              begin
                for J := 0 to aEquSCount-1 do
                if aEquS[J].Name=aCaD[indx+1].str then
                  begin //Да, тут объявленая "переменная" далее
                    DecToParBin(aEquS[J].DecVal);
                    CurCom[0]:=parBin[0];
                    CurCom[1]:=parBin[1];
                    CurCom[2]:=parBin[2];
                    CurCom[3]:=parBin[3];
                    CurCom[4]:=parBin[4];
                    //CurCom[5]:=parBin[5];
                    //CurCom[6]:=false;
                    //CurCom[7]:=true;
                    CurCom[8]:=true;
                    CurCom[9]:=false;
                    CurCom[10]:=true;
                    CurCom[11]:=false;
                    result:=true;
                    exit;
                  end;
                //Вот здесь необъявленная переменная
                CheckSynLine(aCad[indx+1].ItemNo,true,true,aCaD[indx+1].txtStart,aCaD[indx+1].txtLong);
                //MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
                //MarkAllLine(aCad[indx+1].ItemNo,false);
              showmessage(GetText(1023));
              result:=false;
              exit;
              end
            else
              begin //Вообще что-то неправильное далее, ошибка
               MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1024));
              result:=false;
              exit;
              end;

          end;
      end
    else
      begin //Что-то еще там есть - ошибка
        MarkTextInRT( aCaD[indx+3].txtStart,aCaD[indx+3].txtLong,false,0);
        showmessage(GetText(1020));
        result:=false;
        exit;
      end;

  end;





  //BCF


 if aCaD[indx].str= 'BCF' then
  begin
    if (indx+1=aInd)  then
      begin //Больше параметров нет - не хорошо
        MarkTextInRT( aCaD[indx].txtStart,aCaD[indx].txtLong,false,0);
        showmessage(GetText(1021));
        result:=false;
        exit;
      end;
    //Сначала обработаем флаг назначения (если есть)
    CurCom[5]:=false;  //А вдруг - нет, тогда по-умолчанию 0
    CurCom[6]:=false;
    CurCom[7]:=false;
    if indx+3=aind then //А вот тут значит, что если есть еще 2 параметра кроме команды
      if aCad[indx+2].isNoBit then
      begin
      DecToParBin(StrToInt(aCad[indx+2].str));
      CurCom[5]:=parBin[0];
      CurCom[6]:=parBin[1];
      CurCom[7]:=parBin[2];
      end
      else
      begin //А вот тут ошибка, т.к. 3-й параметр какая-то фигня
      MarkTextInRT( aCaD[indx+2].txtStart,aCaD[indx+2].txtLong,false,0);
      showmessage(GetText(1024));
      result:=false;
      exit;
      end;


    if (indx+2=aind) or (indx+3=aind) then
      begin //Есть еще параметр или два - уже лучше (по-умолчанию назначение в регистр W (0) если параметр один
        if aCaD[indx+1].isDigit then
          begin //Параметр - цифра
            if (aCad[indx+1].DigitDecValue >=0) and (aCad[indx+1].DigitDecValue <=4095)  then
              begin //Входит в диапазон 0..4095 для совсем мощной совместимости с PIC18
              DecToParBin(aCad[indx+1].DigitDecValue);
          CurCom[0]:=parBin[0];
          CurCom[1]:=parBin[1];
          CurCom[2]:=parBin[2];
          CurCom[3]:=parBin[3];
          CurCom[4]:=parBin[4];
          //CurCom[5]:=parBin[5]; //А вот его мы определили выше
          //CurCom[6]:=false;
          //CurCom[7]:=true;
          CurCom[8]:=false;
          CurCom[9]:=false;
          CurCom[10]:=true;
          CurCom[11]:=false;
          result:=true;
          exit;
              end
              else
              begin //Не входит в диапазон 0..4095
              MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1025));
              result:=false;
              exit;

              end;
          end
          else
          begin //Параметр не цифра
            //Проверим на переменную из EQU
            if aCaD[indx+1].isCorrectVarOrLabel then
              begin
                for J := 0 to aEquSCount-1 do
                if aEquS[J].Name=aCaD[indx+1].str then
                  begin //Да, тут объявленая "переменная" далее
                    DecToParBin(aEquS[J].DecVal);
                    CurCom[0]:=parBin[0];
                    CurCom[1]:=parBin[1];
                    CurCom[2]:=parBin[2];
                    CurCom[3]:=parBin[3];
                    CurCom[4]:=parBin[4];
                    //CurCom[5]:=parBin[5];
                    //CurCom[6]:=false;
                    //CurCom[7]:=true;
                    CurCom[8]:=false;
                    CurCom[9]:=false;
                    CurCom[10]:=true;
                    CurCom[11]:=false;
                    result:=true;
                    exit;
                  end;
                //Вот здесь необъявленная переменная
                MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1023));
              result:=false;
              exit;
              end
            else
              begin //Вообще что-то неправильное далее, ошибка
               MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1024));
              result:=false;
              exit;
              end;

          end;
      end
    else
      begin //Что-то еще там есть - ошибка
        MarkTextInRT( aCaD[indx+3].txtStart,aCaD[indx+3].txtLong,false,0);
        showmessage(GetText(1020));
        result:=false;
        exit;
      end;

  end;

//А теперь - операторы безусловного перехода
//Особенность этого блока в том, что мы не знаем, куда он хочет перейти до полного компилирования

//GOTO <label>



if aCaD[indx].str= 'GOTO' then
  begin
    if indx+1=aInd then
      begin //Больше параметров нет - не хорошо
        MarkTextInRT( aCaD[indx].txtStart,aCaD[indx].txtLong,false,0);
        showmessage(GetText(1021));
        result:=false;
        exit;
      end;
    if indx+2=aind then
      begin //Есть еще параметр - уже лучше
        if aCaD[indx+1].isDigit then
          begin //Параметр - цифра (долго думал, а нужно ли это извращение тут, но рещил оставить
            if (aCad[indx+1].DigitDecValue >=0) and (aCad[indx+1].DigitDecValue <=131071)  then
              begin //Входит в диапазон 0..131071 - тоже для жесткой совместимости с PIC18 старших моделей
              DecToParBin(aCad[indx+1].DigitDecValue);
          CurCom[0]:=parBin[0];
          CurCom[1]:=parBin[1];
          CurCom[2]:=parBin[2];
          CurCom[3]:=parBin[3];
          CurCom[4]:=parBin[4];
          CurCom[5]:=parBin[5];
          CurCom[6]:=parBin[6];
          CurCom[7]:=parBin[7];
          CurCom[8]:=parBin[8];
          CurCom[9]:=true;
          CurCom[10]:=false;
          CurCom[11]:=true;
          result:=true;
          exit;
              end
              else
              begin //Не входит в диапазон ....
              MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1025));
              result:=false;
              exit;

              end;
          end
          else
          begin //Параметр не цифра
            //Проверим на корректность метки
            if aCaD[indx+1].isCorrectVarOrLabel then
              begin  //Корректная, заносим в табл, а дальше пусть уже линкер разбирается
              aLLCount:=aLLCount+1;
              setlength(aLL,aLLCount);
               All[aLLCount-1].Tupe:=0; //Тип 0 - GOTO
               All[aLLCount-1].Name:=aCaD[indx+1].str;
               All[aLLCount-1].pParStart:=aCaD[indx+1].txtStart;
               All[aLLCount-1].pParLen:=aCaD[indx+1].txtLong;
               All[aLLCount-1].item:=aCaD[indx+1].ItemNo;
               all[AllCount-1].Addr:=aAddres;
               result:=true;
               exit;


              end
            else
              begin //Вообще что-то неправильное далее, ошибка
               MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1024));
              result:=false;
              exit;
              end;

          end;
      end
    else
      begin //Что-то еще там есть - ошибка
        MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
        showmessage(GetText(1020));
        result:=false;
        exit;
      end;

  end;



//CALL <label>



if aCaD[indx].str= 'CALL' then
  begin
    if indx+1=aInd then
      begin //Больше параметров нет - не хорошо
        MarkTextInRT( aCaD[indx].txtStart,aCaD[indx].txtLong,false,0);
        showmessage(GetText(1021));
        result:=false;
        exit;
      end;
    if indx+2=aind then
      begin //Есть еще параметр - уже лучше
        if aCaD[indx+1].isDigit then
          begin //Параметр - цифра (долго думал, а нужно ли это извращение тут, но рещил оставить
            if (aCad[indx+1].DigitDecValue >=0) and (aCad[indx+1].DigitDecValue <=131071)  then
              begin //Входит в диапазон 0..131071 - тоже для жесткой совместимости с PIC18 старших моделей
              DecToParBin(aCad[indx+1].DigitDecValue);
          CurCom[0]:=parBin[0];
          CurCom[1]:=parBin[1];
          CurCom[2]:=parBin[2];
          CurCom[3]:=parBin[3];
          CurCom[4]:=parBin[4];
          CurCom[5]:=parBin[5];
          CurCom[6]:=parBin[6];
          CurCom[7]:=parBin[7];
          CurCom[8]:=true;
          CurCom[9]:=false;
          CurCom[10]:=false;
          CurCom[11]:=true;
          result:=true;
          exit;
              end
              else
              begin //Не входит в диапазон ....
              MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(1025));
              result:=false;
              exit;

              end;
          end
          else
          begin //Параметр не цифра
            //Проверим на корректность метки
            if aCaD[indx+1].isCorrectVarOrLabel then
              begin  //Корректная, заносим в табл, а дальше пусть уже линкер разбирается
              aLLCount:=aLLCount+1;
              setlength(aLL,aLLCount);
               All[aLLCount-1].Tupe:=1; //Тип 0 - CALL
               All[aLLCount-1].Name:=aCaD[indx+1].str;
               All[aLLCount-1].pParStart:=aCaD[indx+1].txtStart;
               All[aLLCount-1].pParLen:=aCaD[indx+1].txtLong;
               All[aLLCount-1].item:=aCaD[indx+1].ItemNo;
               all[AllCount-1].Addr:=aAddres;
               result:=true;
               exit;


              end
            else
              begin //Вообще что-то неправильное далее, ошибка
               MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
              showmessage(GetText(10245));
              result:=false;
              exit;
              end;

          end;
      end
    else
      begin //Что-то еще там есть - ошибка
        MarkTextInRT( aCaD[indx+1].txtStart,aCaD[indx+1].txtLong,false,0);
        showmessage(GetText(1020));
        result:=false;
        exit;
      end;

  end;


end;

Function TMDIChild.CompileAll():boolean; //Функция компиляции всего текста
var Z,J,K,indx,tmpZ,it,I:Integer;
GtmpI,Lc:integer;
IsLabel,av_BP,is_BP:boolean; //Есть ли метка?
StrZ:string; //Строка Z
PoslStr:boolean; //Последняя ли это строка для обработки?
Str_No_From,Str_No_to,Str_No:integer;
label lblExit, EndLoop, lblKpp,lblKend,lblKend1,lblNext;
begin
PoslStr:=false;
autocheck:=false;
indx:=0;
aAddres:=0; //Начальный адрес, куда будет заливаться программа
aLblsCount:=0; //Счетчик меток
aLLCount:=0; //Счетчик линкера
aEquSCount:=0; //Счетчик массива EQU
setlength(aEquS,0);//Сброс массивов
setlength(aLL,0);
setlength(aLbls,0);
IsLabel:=false;
K:=-1;
Lc:= RVE.GetLineNo(RVE.ItemCount-1,RVE.GetOffsAfterItem(rve.ItemCount-1)-1);
for Z := 1 to Lc  do
  begin
  //Соберем строку Z
  if PoslStr=true then    goto lblKend;
  StrZ:='';
lblKpp:
  K:=K+1;
  if K>=rve.ItemCount then
  begin
  PoslStr:=true;
  K:=K-1;
  goto lblkend1;
   //goto lblKend;
  end;

  if RVE.GetLineNo(K,0)=Z then
    begin
    StrZ:=StrZ+RVE.GetItemText(K)  ;
    goto lblKpp;
    end
  else K:=K-1;




lblkend1:
    GtmpI:=0; //Сброс маркера метки

    CheckSynLine(K);
    //Проверка вообще на ошибочную запись какой-либо части записи в строке
    for tmpZ := 1 to aInd do
      if aCad[tmpZ-1].isError then
      if not acad[tmpZ-1].isLabel  then
      begin
      MarkTextInRT( aCaD[tmpZ-1].txtStart,aCaD[tmpZ-1].txtLong,false,0);
      MarkAllLine(aCaD[tmpZ-1].ItemNo,false);
      showmessage(gettext(1026));
      result:=false;
      exit;
      end
      else
      begin
      MarkTextInRT( aCaD[tmpZ-1].txtStart,aCaD[tmpZ-1].txtLong,false,0);
      MarkAllLine(aCaD[tmpZ-1].ItemNo,false);
      showmessage(gettext(1027));
      result:=false;
      exit;
      end;

    indx:=indx+1+length(StrZ);
    if aInd>0 then if aCaD[0].isLabel  then
      begin //Значит сперва метка идет
        isLabel:=true;
        GtmpI:=1;
        aLblsCount:=aLblsCount+1;
        SetLength(aLbls,aLblsCount);
        aLbls[aLblsCount-1].Name:=aCaD[0].str;
        aLbls[aLblsCount-1].Addr:=aAddres;
      end;
    case (aind-GtmpI) of
    0:
      begin  //Значит, ничего тут нет (кроме, возможно комментария или метки)
      goto EndLoop;
      end;
    else //Значит, что-то тут есть такое
      begin
        if aCaD[0+GtmpI].isInstruction then  //Проверка на инструкцию
          begin //Да, инструкция
            if AssembleyInstruction(0+GtmpI) then //Ассемблерируем её
              begin //Успешно
              if aAddres>get_ROM_Size-2 then
              begin
               showmessage(gettext(1028) );
                result:=false;
                exit;
              end;
               for J:=0 to 11 do
                  Set_ROM(aAddres,J,CurCom[J]); // результат дизассемблера забивался в ROM
               //ROM_Str_No[aAddres]:=rve.GetLineNo(K,0);

            GetAllLineFromItem( rve,k,Str_No_From,Str_No_to,Str_No);
               Set_ROM_Str_No_from(aAddres,Str_No_From);
               Set_ROM_Str_No_to(aAddres,Str_No_to);
               Set_ROM_Str_No(aAddres,Str_No);
                it:=Find_Item_From_Line(rve, Get_ROM_Str_No(aAddres)); //Далее, найдем какую-нибудь итему из этой строки
                CheckSynLine(it);
                av_BP:=false;
                for I := 0 to aInd-1 do
                if aCad[I].isInstruction then
                begin
                av_BP:=true;
                if rve.GetItemTag(aCad[I].ItemNo)='B' then is_BP:=true else is_BP:=false;
                goto lblNext;
                end;
lblNext:
               if is_BP then Set_ROM_BP(aAddres,true) else Set_ROM_BP(aAddres,false);
                aAddres:=aAddres+1;
                goto EndLoop;
              end
            else
              begin //Ошибка ассемблерирования - прекратить
                result:=false;
                goto lblExit;
              end;

          end
        else
          begin //Нет, не инструкция
            //if aCad[0+GtmpI]. then //Может быть это метка перед оператором EQU
           //showmessage('');
           //Проверка на конструкцию <var> EQU <Digit>
           if ((aInd-GtmpI)=3) then if (aCaD[0+GtmpI].isCorrectVarOrLabel) then if (aCad[1+GtmpI].isDirective) then if (aCad[1+GtmpI].str='EQU') then if (aCad[2+GtmpI].isDigit) then
            begin //Да, это EQU
            //Найдем, а вдруг эта EQU уже объявлена
            for J := 0 to aEquSCount-1 do
              if aEquS[J].Name=aCad[0+GtmpI].str then
                begin
                MarkTextInRT( aCaD[0+GtmpI].txtStart,aCaD[0+GtmpI].txtLong,false,0);
                showmessage(GetText(1029)+' '+ aCad[0+GtmpI].str);
                result:=false;
                exit;
                end;
            //Не, не объявлена
            aEquSCount:=aEquSCount+1; //Счетчик массива EQU
            setlength(aEquS,aEquSCount);//Увеличение массива EQU
            aEquS[aEquSCount-1].Name:=aCad[0+GtmpI].str;
            aEquS[aEquSCount-1].DecVal:=aCad[2+GtmpI].DigitDecValue;
            goto EndLoop;
            end
            else
            begin
            //Значит в конце не цифра
              MarkTextInRT( aCaD[2+GtmpI].txtStart,aCaD[2+GtmpI].txtLong,false,0);
              MarkAllLine(aCaD[tmpZ-1].ItemNo,false);
              showmessage(GetText(1030));
              result:=false;
              exit;
            end;

          end;

      end;


    end;
//Здесь все проверки на нормальные инструкции, команды и метки прошли - не то!


for tmpZ := GtmpI to aInd-1 do
begin
MarkTextInRT( aCaD[tmpZ].txtStart,aCaD[tmpZ].txtLong,false,0);
MarkAllLine(aCaD[tmpZ].ItemNo,false);
end;
showmessage(GetText(1027));
result:=false;
exit;
EndLoop:
  end;
lblKend:
//Забивка NOP-ами остатка
for Z:=aAddres to get_ROM_Size-2 do
  begin
   set_ROM(Z,0,false);
   set_ROM(Z,1,false);
   set_ROM(Z,2,false);
   set_ROM(Z,3,false);
   set_ROM(Z,4,false);
   set_ROM(Z,5,false);
   set_ROM(Z,6,false);
   set_ROM(Z,7,false);
   set_ROM(Z,8,false);
   set_ROM(Z,9,false);
   set_ROM(Z,10,false);
   set_ROM(Z,11,false);
{
   pic10F.ROM[Z,1]:=false;
   pic10F.ROM[Z,2]:=false;
   pic10F.ROM[Z,3]:=false;
   pic10F.ROM[Z,4]:=false;
   pic10F.ROM[Z,5]:=false;
   pic10F.ROM[Z,6]:=false;
   pic10F.ROM[Z,7]:=false;
   pic10F.ROM[Z,8]:=false;
   pic10F.ROM[Z,9]:=false;
   pic10F.ROM[Z,10]:=false;
   pic10F.ROM[Z,11]:=false;  }
  end;
// Загрузка самой первой и последней инструкции - MOVLW 00h
Set_ROM(get_ROM_Size-1,11,true);
Set_ROM(get_ROM_Size-1,10,true);
Set_ROM(get_ROM_Size-1,9,false);
Set_ROM(get_ROM_Size-1,8,false);
Set_ROM(get_ROM_Size-1,7,false);
Set_ROM(get_ROM_Size-1,6,false);
Set_ROM(get_ROM_Size-1,5,false);
Set_ROM(get_ROM_Size-1,4,false);
Set_ROM(get_ROM_Size-1,3,false);
Set_ROM(get_ROM_Size-1,2,false);
Set_ROM(get_ROM_Size-1,1,false);
Set_ROM(get_ROM_Size-1,0,false);
{pic10F.ROM[get_ROM_Size-1,10]:=true;
pic10F.ROM[get_ROM_Size-1,9]:=false;
pic10F.ROM[get_ROM_Size-1,8]:=false;
pic10F.ROM[get_ROM_Size-1,7]:=false;
pic10F.ROM[get_ROM_Size-1,6]:=false;
pic10F.ROM[get_ROM_Size-1,5]:=false;
pic10F.ROM[get_ROM_Size-1,4]:=false;
pic10F.ROM[get_ROM_Size-1,3]:=false;
pic10F.ROM[get_ROM_Size-1,2]:=false;
pic10F.ROM[get_ROM_Size-1,1]:=false;
pic10F.ROM[get_ROM_Size-1,0]:=false;  }
ProgramSizeInWord:=aAddres;
result:=LinkAll;
lblExit:
autocheck:=true;
end;

function TMDIChild.LinkAll():boolean;
var cI,cJ:integer;
label lblNext;
begin
for cI := 1 to aLLCount do
  begin
  for cJ := 1 to aLblsCount do
    begin
    if AnsiUpperCase(aLL[cI-1].Name+':')=AnsiUpperCase(aLbls[cJ-1].Name) then
      begin
      DecToParBin(aLbls[cJ-1].Addr );
        case aLL[cI-1].Tupe of
        0: //GOTO
          begin

           set_ROM(aLL[cI-1].Addr,0,parBin[0]);
           set_ROM(aLL[cI-1].Addr,1,parBin[1]);
           set_ROM(aLL[cI-1].Addr,2,parBin[2]);
           set_ROM(aLL[cI-1].Addr,3,parBin[3]);
           set_ROM(aLL[cI-1].Addr,4,parBin[4]);
           set_ROM(aLL[cI-1].Addr,5,parBin[5]);
           set_ROM(aLL[cI-1].Addr,6,parBin[6]);
           set_ROM(aLL[cI-1].Addr,7,parBin[7]);
           set_ROM(aLL[cI-1].Addr,8,parBin[8]);
           set_ROM(aLL[cI-1].Addr,9,true);
           set_ROM(aLL[cI-1].Addr,10,false);
           set_ROM(aLL[cI-1].Addr,11,true);

           {PIC10F.ROM[aLL[cI-1].Addr,1]:=parBin[1];
           PIC10F.ROM[aLL[cI-1].Addr,2]:=parBin[2];
           PIC10F.ROM[aLL[cI-1].Addr,3]:=parBin[3];
           PIC10F.ROM[aLL[cI-1].Addr,4]:=parBin[4];
           PIC10F.ROM[aLL[cI-1].Addr,5]:=parBin[5];
           PIC10F.ROM[aLL[cI-1].Addr,6]:=parBin[6];
           PIC10F.ROM[aLL[cI-1].Addr,7]:=parBin[7];
           PIC10F.ROM[aLL[cI-1].Addr,8]:=parBin[8];
           PIC10F.ROM[aLL[cI-1].Addr,9]:=true;
           PIC10F.ROM[aLL[cI-1].Addr,10]:=false;
           PIC10F.ROM[aLL[cI-1].Addr,11]:=true;   }
           goto lblNext;
          end;
        1: //CALL
          begin
           set_ROM(aLL[cI-1].Addr,0,parBin[0]);
           set_ROM(aLL[cI-1].Addr,1,parBin[1]);
           set_ROM(aLL[cI-1].Addr,2,parBin[2]);
           set_ROM(aLL[cI-1].Addr,3,parBin[3]);
           set_ROM(aLL[cI-1].Addr,4,parBin[4]);
           set_ROM(aLL[cI-1].Addr,5,parBin[5]);
           set_ROM(aLL[cI-1].Addr,6,parBin[6]);
           set_ROM(aLL[cI-1].Addr,7,parBin[7]);
           set_ROM(aLL[cI-1].Addr,8,true);
           set_ROM(aLL[cI-1].Addr,9,false);
           set_ROM(aLL[cI-1].Addr,10,false);
           set_ROM(aLL[cI-1].Addr,11,true);

           {PIC10F.ROM[aLL[cI-1].Addr,0]:=parBin[0];
           PIC10F.ROM[aLL[cI-1].Addr,1]:=parBin[1];
           PIC10F.ROM[aLL[cI-1].Addr,2]:=parBin[2];
           PIC10F.ROM[aLL[cI-1].Addr,3]:=parBin[3];
           PIC10F.ROM[aLL[cI-1].Addr,4]:=parBin[4];
           PIC10F.ROM[aLL[cI-1].Addr,5]:=parBin[5];
           PIC10F.ROM[aLL[cI-1].Addr,6]:=parBin[6];
           PIC10F.ROM[aLL[cI-1].Addr,7]:=parBin[7];
           PIC10F.ROM[aLL[cI-1].Addr,8]:=true;
           PIC10F.ROM[aLL[cI-1].Addr,9]:=false;
           PIC10F.ROM[aLL[cI-1].Addr,10]:=false;
           PIC10F.ROM[aLL[cI-1].Addr,11]:=true;  }
           goto lblNext;
          end;
        end;
      end;

    end;
    MarkTextInRT( aLL[cI-1].pParStart,aLL[cI-1].pParLen,false,0);
    MarkAllLine(aLL[cI-1].item,false);
    showmessage(GetText(1031));
    result:=false;
    exit;
    lblNext:
  end;
 result:=true;
end;
end.

