unit CHILDWIN;

interface

uses Windows, Classes, Graphics, Forms, Controls, StdCtrls, ComCtrls, PIC10F,SysUtils, Dialogs;

type TArrayOfLinks = record
  lnkNo:integer;
  lnkAddr:integer;
end;

type
  TMDIChild = class(TForm)
    RT: TRichEdit;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);

    procedure FormCreate(Sender: TObject);
    procedure RTChange(Sender: TObject);

  private

    { Private declarations }
  public
    { Public declarations }
  procedure DisAssembley();
  procedure CheckSyn();
  procedure CheckSynLine(str:String; StartPos:integer);
//  function IsCommand(Str:string):integer;
   var alload: boolean;
   tableofLinks:array of TArrayOfLinks;
   tablelinkscount:integer;
  end;


implementation

{$R *.dfm}
function IsCommand(Str:string):integer;  //Функция проверки на комманду
var tI:Integer;
begin
IsCommand:=-1;
  for tI:=1 to PIC10F.SystemCommandCounter do
      if PIC10F.SystemCommand[tI-1].CommandName=str then
        begin
          result:=tI-1;
          exit;
        end;
end;
function IsDirective(str:string):integer; //Функция проверки на директиву ассемблера
begin
  isDirective:=-1 ;
  if str='EQU' then result:=1;

end;
function IsDigth(str:string):integer; //Функция проверки на числовое значение
var len,tmpI,tmpOrd:integer;
label l1,l2,l3,l4;
begin
IsDigth:=-1;
len:=Length(STR);

//Проверка на шестнадцатиричность вида 0x1F
if len>2 then //Длина строки от 3-х сиволов т.е. напр. 0x1
  if str[1]='0' then //Первый должен быть 0
    if str[1]='X' then //Потом должен идти "икс"
    begin
    for tmpI := 2 to len-1 do
      begin
        tmpOrd:=ord(STR[I]);
         if not (((tmpOrd>47) and (tmpOrd<58)) or ((tmpOrd>64) and (tmpOrd<71))) then  //Проверка, а вдруг какой-нит символ не 0123456789ABCDEF
         goto l1; //Нет
      end;
      //Все решено это hex!!!
      result:=3;
      exit;
    end;
l1:
//Проверка на шестнадцатиричность вида F1Ah
if len>1 then //Длина строки от 2-х символов т.е. напр 1h
  if str[len-1]='H' then //Должно заканчиваться на символ "Аш"
  begin
    for tmpI := 0 to len-2 do
      begin
      if not (((tmpOrd>47) and (tmpOrd<58)) or ((tmpOrd>64) and (tmpOrd<71))) then  //Проверка, а вдруг какой-нит символ не 0123456789ABCDEF
      goto l2; //Нет
      end;
    //Все решено это hex!!!
    result:=3;
    exit;
  end;
l2:
//Проверка на десятичность вида 12953
 for tmpI := 0 to len-1 do
      begin
      if not (tmpOrd>47) and (tmpOrd<58)  then  //Проверка, а вдруг какой-нит символ не 0123456789
      goto l3; //Нет
      end;
    //Все решено это dec!!!
    result:=1;
    exit;
l3:
//Проверка на двоичность вида 011101b
if len>1 then //Длина строки от 2-х символов т.е. напр 1b
  if True then
    if str[len-1]='B' then //Должно заканчиваться на символ "Бэ"
    begin
    for tmpI := 0 to len-2 do
      begin
      if not (tmpOrd>47) and (tmpOrd<50)  then  //Проверка, а вдруг какой-нит символ не 0123456789ABCDEF
      goto l4; //Нет
      end;
    //Все решено это бин!!!
    result:=2;
    exit;
    end;
l4:


end;

procedure TMDIChild.CheckSynLine(str:String; StartPos:integer);
var pComment,pMet,LenStr,pPlus:integer;
tS:string[1];
tA:AnsiChar;
tI,tZ:integer;
aCaD: array of string;
aInd: integer;
label lMet,lOther, lOther2;
begin
LenStr:=Length(str); //В переменную длину строки
pPlus:=0; //Еще ничего с начала не удалили
//Снимаем все атрибуты у текста - цвет и жирность
RT.SelStart:=StartPos;
RT.SelLength:=LenStr;
RT.SelAttributes.Style:=[fsBold];
RT.SelAttributes.Color:=clBlack;

//Переведем все в верхний регистр
str:=AnsiUpperCase(str);
//Обработчик комментария
pComment:=pos(';',str); //Поиск комментария в строке
if pComment=0 then goto lMet; //Если нет, то перейти к поиску метки
RT.SelStart:=StartPos+pComment-1; //Начальная позиция для выделения
RT.SelLength:=LenStr-pComment+1; //Конечная позиция для выделения

RT.SelAttributes.Color:=clGreen; //Выделить зеленым цветом
Delete(Str,pComment,LenStr-pComment+1); //Удалить коммент из дальнейшей обработки
LenStr:=Length(str); //В переменную длину уже новой строки

//Обработчик метки
lMet:
if str='' then exit;//Проверка, а не пуста ли строка, а если да, то выходим
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
           //Некорректная метка - в составе есть еще что-то
            RT.SelStart:=StartPos+pPlus; //Начальная позиция для выделения
            RT.SelLength:=pMet; //Конечная позиция для выделения
            RT.SelAttributes.Color:=clRed; //Выделить кр цветом
            exit;
        end;
    end;
    //А вот тут корректная
      RT.SelStart:=StartPos+pPlus; //Начальная позиция для выделения
      RT.SelLength:=pMet; //Конечная позиция для выделения
      RT.SelAttributes.Style:=[fsUnderLine]+[fsBold]; //Выделить чертой
      Delete(str,1,pMet);
      LenStr:=Length(str); //В переменную длину уже новой строки
      pPlus:=pPlus+pMet;

  end
  else
  begin
  //Некорректная метка - в начале цифра или еще что-то
  RT.SelStart:=StartPos+pPlus; //Начальная позиция для выделения
  RT.SelLength:=pMet; //Конечная позиция для выделения
  RT.SelAttributes.Color:=clRed; //Выделить кр цветом
  exit;
  end;


//Поиск команд и директив ассемблера
lOther:
if (Copy(str,LenStr,1)<>#32) or (Copy(str,LenStr,1)<>#9) then Str:=Str+' ';//Добавление пробела в конец, если нету
LenStr:=Length(str); //В переменную длину уже новой строки
aInd:=0; //Инициализация массива данных, кот. будут разделены пробелами
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
    if (copy(str,tZ,1)=#9) or (copy(str,tZ,1)=#32)  then
      begin
      aInd:=aInd+1;
      SetLength(aCaD,aInd);
      aCad[aInd-1]:=Copy(str,1,tZ-1);
      //Проверка, что же это?
      if IsCommand(aCad[aInd-1])>-1 then //Проверка на команду
        begin
          RT.SelStart:=StartPos+pPlus; //Начальная позиция для выделения
          RT.SelLength:=tZ-1; //Конечная позиция для выделения
          //RT.SelAttributes.Style:=[fsUnderLine]+[fsBold]; //Выделить чертой
          RT.SelAttributes.Color:=clBlue;
        end
        else
        begin //Не команда
          if IsDirective(aCad[aInd-1])>-1 then //Проверка на директиву ассемблера
            begin
          RT.SelStart:=StartPos+pPlus; //Начальная позиция для выделения
          RT.SelLength:=tZ-1; //Конечная позиция для выделения
          //RT.SelAttributes.Style:=[fsUnderLine]+[fsBold]; //Выделить чертой
          RT.SelAttributes.Color:=clYellow;
            end
            else
            begin //Не директива
            case IsDigth(aCad[aInd-1]) of
            1:
              begin //Dec
                        RT.SelStart:=StartPos+pPlus; //Начальная позиция для выделения
          RT.SelLength:=tZ-1; //Конечная позиция для выделения
          //RT.SelAttributes.Style:=[fsUnderLine]+[fsBold]; //Выделить чертой
          RT.SelAttributes.Color:=clwhite;
              end;
            2:
              begin //Bin
                      RT.SelStart:=StartPos+pPlus; //Начальная позиция для выделения
          RT.SelLength:=tZ-1; //Конечная позиция для выделения
          //RT.SelAttributes.Style:=[fsUnderLine]+[fsBold]; //Выделить чертой
          RT.SelAttributes.Color:=clYellow;
              end;
            3:
              begin //Hex
                     RT.SelStart:=StartPos+pPlus; //Начальная позиция для выделения
          RT.SelLength:=tZ-1; //Конечная позиция для выделения
          //RT.SelAttributes.Style:=[fsUnderLine]+[fsBold]; //Выделить чертой
          RT.SelAttributes.Color:=clred;
              end
            else
              begin

              end;

            end;
            end;

        end;
      //Удаление и дальнейшая обработка
      Delete(str,1,tZ);
      pplus:=pplus+tZ;
      goto lOther;
      end;
  end;





end;

procedure TMDIChild.CheckSyn();
var Z,indx:Integer;
begin
indx:=0;
for Z := 0 to RT.Lines.Count-1 do
  begin
    CheckSynLine(rt.Lines[Z],indx);
    indx:=indx+1+length(rt.Lines[Z]);

  end;
end;
procedure TMDIChild.DisAssembley();
var G,H:integer;
Instr:string;
label lblEndCycle;
begin
rt.Text:='';
tablelinkscount:=0;
//txtlines.Text:='';
for G := 0 to 255 do
  begin
  PIC10F.parCommand[0]:=PIC10F.ROM[G,0];
  PIC10F.parCommand[1]:=PIC10F.ROM[G,1];
  PIC10F.parCommand[2]:=PIC10F.ROM[G,2];
  PIC10F.parCommand[3]:=PIC10F.ROM[G,3];
  PIC10F.parCommand[4]:=PIC10F.ROM[G,4];
  PIC10F.parCommand[5]:=PIC10F.ROM[G,5];
  PIC10F.parCommand[6]:=PIC10F.ROM[G,6];
  PIC10F.parCommand[7]:=PIC10F.ROM[G,7];
  PIC10F.parCommand[8]:=PIC10F.ROM[G,8];
  PIC10F.parCommand[9]:=PIC10F.ROM[G,9];
  PIC10F.parCommand[10]:=PIC10F.ROM[G,10];
  PIC10F.parCommand[11]:=PIC10F.ROM[G,11];
  //rt.Lines.Add(#9+PIC10F.GetInstruction());
  Instr:=PIC10F.GetInstruction();
//если есть гото, то занести в таблицу метку
  if Copy(Instr,1,4) = 'GOTO' then
    begin
      //Сперва проверим, а нет ли уже такой метки в таблице
      for H := 1 to tablelinkscount do
        begin
          if tableoflinks[H-1].lnkAddr=pic10f.parGOTOaddr then
            begin
              //Видимо, есть
              rt.Text:=rt.Text+#9+'GOTO lbl'+inttostr(tableoflinks[H-1].lnkno)+#13#10;
              goto lblEndCycle;
            end;

        end;
      //Видать, нет
      tablelinkscount:=tablelinkscount+1;
      SetLength(tableoflinks,tablelinkscount);
      tableoflinks[tablelinkscount-1].lnkNo:=tablelinkscount;
      tableoflinks[tablelinkscount-1].lnkAddr:=pic10f.parGOTOaddr;
      rt.Text:=rt.Text+#9+'GOTO lbl'+inttostr(tableoflinks[tablelinkscount-1].lnkno)+#13#10;
      goto lblEndCycle;
    end;
//если есть CALL, то занести в таблицу метку
  if Copy(Instr,1,4) = 'CALL' then
    begin
      //Сперва проверим, а нет ли уже такой метки в таблице
      for H := 1 to tablelinkscount do
        begin
          if tableoflinks[H-1].lnkAddr=pic10f.parGOTOaddr then
            begin
              //Видимо, есть
              rt.Text:=rt.Text+#9+'CALL lbl'+inttostr(tableoflinks[H-1].lnkno)+#13#10;
              goto lblEndCycle;
            end;

        end;
      //Видать, нет
      tablelinkscount:=tablelinkscount+1;
      SetLength(tableoflinks,tablelinkscount);
      tableoflinks[tablelinkscount-1].lnkNo:=tablelinkscount;
      tableoflinks[tablelinkscount-1].lnkAddr:=pic10f.parGOTOaddr;
      rt.Text:=rt.Text+#9+'CALL lbl'+inttostr(tableoflinks[tablelinkscount-1].lnkno)+#13#10;
      goto lblEndCycle;
    end;

  rt.text:=rt.text+#9+Instr+#13#10;
lblEndCycle:
  end;
 //Востановление таблицы ссылок
 for G := 1 to tablelinkscount do
 begin
 rt.Lines[tableoflinks[G-1].lnkAddr]:='lbl'+inttostr(tableoflinks[G-1].lnkNo)+':'+rt.Lines[tableoflinks[G-1].lnkAddr];
 end;
 //Удаление конечных NOP-ов
 for G := rt.Lines.Count  downto 1 do
   begin
     if rt.Lines[G-1]=#9+'NOP' then
          rt.Lines.Delete(G-1)
               else exit;

   end;

end;

procedure TMDIChild.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;

end;

procedure TMDIChild.FormCreate(Sender: TObject);
begin
rt.Width:=width-rt.left-8;
rt.Height:=height-rt.top-30;
rt.DoubleBuffered:=true;


end;

procedure TMDIChild.FormResize(Sender: TObject);
begin
rt.Width:=width-rt.left-8;
rt.Height:=height-rt.top-30;

end;

procedure TMDIChild.RTChange(Sender: TObject);
var tZ, tS:integer;
tp:TPoint;
begin
if not alload then exit;
tp:=rt.CaretPos;
tS:=0;
for tZ := 1 to rt.CaretPos.Y  do tS:=tS+length(rt.Lines[tZ-1])+1;

checkSynLine(rt.Lines[rt.CaretPos.Y],ts);
rt.CaretPos:=tp;

end;

end.
