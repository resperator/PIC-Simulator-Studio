unit MAIN;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, Menus,
  StdCtrls, Dialogs, Buttons, Messages, ExtCtrls, ComCtrls, StdActns,
  ActnList, ToolWin, ImgList,PIC10F, UnitFormat;
type TPSfr = record
  imgBP:TImage;
  imgDelta:TImage;
  edtAddr:TEdit;
  edtName:TEdit;
  edtHex:TEdit;
  shpBin:array[0..7] of TShape;
  cbBin:array[0..7] of TCheckBox;
end;

type
  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    FileNewItem: TMenuItem;
    FileOpenItem: TMenuItem;
    FileCloseItem: TMenuItem;
    Window1: TMenuItem;
    Help1: TMenuItem;
    N1: TMenuItem;
    FileExitItem: TMenuItem;
    WindowCascadeItem: TMenuItem;
    WindowTileItem: TMenuItem;
    WindowArrangeItem: TMenuItem;
    HelpAboutItem: TMenuItem;
    OpenDialog: TOpenDialog;
    FileSaveItem: TMenuItem;
    FileSaveAsItem: TMenuItem;
    Edit1: TMenuItem;
    CutItem: TMenuItem;
    CopyItem: TMenuItem;
    PasteItem: TMenuItem;
    WindowMinimizeItem: TMenuItem;
    StatusBar: TStatusBar;
    ActionList1: TActionList;
    EditCut1: TEditCut;
    EditCopy1: TEditCopy;
    EditPaste1: TEditPaste;
    FileNew1: TAction;
    FileSave1: TAction;
    FileExit1: TAction;
    FileOpen1: TAction;
    FileSaveAs1: TAction;
    WindowCascade1: TWindowCascade;
    WindowTileHorizontal1: TWindowTileHorizontal;
    WindowArrangeAll1: TWindowArrange;
    WindowMinimizeAll1: TWindowMinimizeAll;
    HelpAbout1: TAction;
    FileClose1: TWindowClose;
    WindowTileVertical1: TWindowTileVertical;
    WindowTileItem2: TMenuItem;
    ToolBar2: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton9: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ImageList1: TImageList;
    ToolButton12: TToolButton;
    tlbRate: TToolButton;
    tlbRun: TToolButton;
    pnlSFR: TPanel;
    Shape1: TShape;
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    scrlSFR: TScrollBar;
    pnlGPR: TPanel;
    Shape3: TShape;
    Image3: TImage;
    Image4: TImage;
    Label2: TLabel;
    scrGPR: TScrollBar;
    Option1: TMenuItem;
    Microcontroller1: TMenuItem;
    PIC12bit1: TMenuItem;
    PIC10F2001: TMenuItem;
    tlbStep: TToolButton;
    pnlCounters: TPanel;
    Shape2: TShape;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    txtLast: TEdit;
    txtNext: TEdit;
    Label6: TLabel;
    txtPC: TEdit;
    txtIC: TEdit;
    Label7: TLabel;
    txtMC: TEdit;
    txtRT: TEdit;
    Label8: TLabel;
    Label9: TLabel;
    tlbPause: TToolButton;
    tlbStop: TToolButton;
    popupRate: TPopupMenu;
    mnuStepByStep: TMenuItem;
    mnuVerySlow: TMenuItem;
    mnuSlow: TMenuItem;
    mnuNormal: TMenuItem;
    mnuFast: TMenuItem;
    mnuVeryfast: TMenuItem;
    mnuRealTime: TMenuItem;
    mnuX2: TMenuItem;
    mnuUltimate: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    imgGreenBreackpoint: TImage;
    imgRedBreackpoint: TImage;
    imgGreenDelta: TImage;
    imgRedDelta: TImage;
    imgnil: TImage;
    procedure FileNew1Execute(Sender: TObject);
    procedure FileOpen1Execute(Sender: TObject);
    procedure HelpAbout1Execute(Sender: TObject);
    procedure FileExit1Execute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tlbRunClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure PIC10F2001Click(Sender: TObject);
    procedure tlbStepClick(Sender: TObject);
    procedure mnuStepByStepClick(Sender: TObject);
    procedure mnuVerySlowClick(Sender: TObject);
    procedure mnuSlowClick(Sender: TObject);
    procedure mnuNormalClick(Sender: TObject);
    procedure mnuFastClick(Sender: TObject);
    procedure mnuVeryfastClick(Sender: TObject);
    procedure mnuRealTimeClick(Sender: TObject);
    procedure mnuX2Click(Sender: TObject);
    procedure mnuUltimateClick(Sender: TObject);
    procedure tlbStopClick(Sender: TObject);
    procedure tlbPauseClick(Sender: TObject);
    procedure tlbRateMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tlbRateMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure scrlSFRChange(Sender: TObject);

  private
    { Private declarations }
    co:PIC10F.TRun;
    procedure CreateMDIChild(const Name: string);

  public
    { Public declarations }
    procedure BpSFRclick(Sender:TObject);

  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses CHILDWIN, about;
Var arrayPSfr: array of TPSfr;
NumberOfRowsinSFR:integer;
formLoad:boolean;//true когда форма закрыта

procedure TMainForm.BpSFRclick(Sender: TObject);
begin
//Timage(sender).Picture:=mainform.imgRedBreackpoint.Picture;
end;

procedure ShowAllRegAndCounters();
var i,z:integer;
begin
  z:=mainform.scrlSFR.Position;
  for I := 0 to NumberOfRowsinsfr-1 do
  begin
    //Адрес
    arrayPSfr[I].edtAddr.Text:=MatrixRAM[MatrixRAM[I+z].SIMadress].IDEHexaddres;
    //Имя
    arrayPSfr[I].edtname.Text:=MatrixRAM[MatrixRAM[I+z].SIMadress].IDEName;
    //Дельта
    if MatrixRAM[MatrixRAM[I+z].SIMadress].delta=true then
      if MatrixRAM[MatrixRAM[I+z].SIMadress].greenDelta=true then
        begin //Зеленая дельта
        arrayPSfr[I].imgDelta.Picture:=mainform.imgGreenDelta.Picture;
        MatrixRAM[MatrixRAM[I+z].SIMadress].delta:=false;
        MatrixRAM[MatrixRAM[I+z].SIMadress].greenDelta:=false;
        end
        else
        begin //Красная дельта
        arrayPSfr[I].imgDelta.Picture:=mainform.imgRedDelta.Picture;
        MatrixRAM[MatrixRAM[I+z].SIMadress].delta:=false;
        end
    else
    arrayPSfr[I].imgDelta.Picture:=mainform.imgnil.Picture;

    arrayPSfr[I].cbBin[0].Checked:=RAM[MatrixRAM[I+z].SIMadress,0];
    arrayPSfr[I].cbBin[1].Checked:=RAM[MatrixRAM[I+z].SIMadress,1];
    arrayPSfr[I].cbBin[2].Checked:=RAM[MatrixRAM[I+z].SIMadress,2];
    arrayPSfr[I].cbBin[3].Checked:=RAM[MatrixRAM[I+z].SIMadress,3];
    arrayPSfr[I].cbBin[4].Checked:=RAM[MatrixRAM[I+z].SIMadress,4];
    arrayPSfr[I].cbBin[5].Checked:=RAM[MatrixRAM[I+z].SIMadress,5];
    arrayPSfr[I].cbBin[6].Checked:=RAM[MatrixRAM[I+z].SIMadress,6];
    arrayPSfr[I].cbBin[7].Checked:=RAM[MatrixRAM[I+z].SIMadress,7];
    arrayPSfr[I].cbBin[0].Enabled:=MatrixRAM[MatrixRAM[I+z].SIMadress].usedbit[0];
    arrayPSfr[I].cbBin[1].Enabled:=MatrixRAM[MatrixRAM[I+z].SIMadress].usedbit[1];
    arrayPSfr[I].cbBin[2].Enabled:=MatrixRAM[MatrixRAM[I+z].SIMadress].usedbit[2];
    arrayPSfr[I].cbBin[3].Enabled:=MatrixRAM[MatrixRAM[I+z].SIMadress].usedbit[3];
    arrayPSfr[I].cbBin[4].Enabled:=MatrixRAM[MatrixRAM[I+z].SIMadress].usedbit[4];
    arrayPSfr[I].cbBin[5].Enabled:=MatrixRAM[MatrixRAM[I+z].SIMadress].usedbit[5];
    arrayPSfr[I].cbBin[6].Enabled:=MatrixRAM[MatrixRAM[I+z].SIMadress].usedbit[6];
    arrayPSfr[I].cbBin[7].Enabled:=MatrixRAM[MatrixRAM[I+z].SIMadress].usedbit[7];
    arrayPSfr[I].cbBin[0].hint:=MatrixRAM[MatrixRAM[I+z].SIMadress].bitname[0];
    arrayPSfr[I].cbBin[1].hint:=MatrixRAM[MatrixRAM[I+z].SIMadress].bitname[1];
    arrayPSfr[I].cbBin[2].hint:=MatrixRAM[MatrixRAM[I+z].SIMadress].bitname[2];
    arrayPSfr[I].cbBin[3].hint:=MatrixRAM[MatrixRAM[I+z].SIMadress].bitname[3];
    arrayPSfr[I].cbBin[4].hint:=MatrixRAM[MatrixRAM[I+z].SIMadress].bitname[4];
    arrayPSfr[I].cbBin[5].hint:=MatrixRAM[MatrixRAM[I+z].SIMadress].bitname[5];
    arrayPSfr[I].cbBin[6].hint:=MatrixRAM[MatrixRAM[I+z].SIMadress].bitname[6];
    arrayPSfr[I].cbBin[7].hint:=MatrixRAM[MatrixRAM[I+z].SIMadress].bitname[7];

    //Показ комманд - в другую процедуру
    PIC10F.parCommand[0]:=CurrentCommand[0];
    PIC10F.parCommand[1]:=CurrentCommand[1];
    PIC10F.parCommand[2]:=CurrentCommand[2];
    PIC10F.parCommand[3]:=CurrentCommand[3];
    PIC10F.parCommand[4]:=CurrentCommand[4];
    PIC10F.parCommand[5]:=CurrentCommand[5];
    PIC10F.parCommand[6]:=CurrentCommand[6];
    PIC10F.parCommand[7]:=CurrentCommand[7];
    PIC10F.parCommand[8]:=CurrentCommand[8];
    PIC10F.parCommand[9]:=CurrentCommand[9];
    PIC10F.parCommand[10]:=CurrentCommand[10];
    PIC10F.parCommand[11]:=CurrentCommand[11];
    mainform.txtLast.Text:=GetInstruction();
    PIC10F.parCommand[0]:=ROM[PIC10F.I,0];
    PIC10F.parCommand[1]:=ROM[PIC10F.I,1];
    PIC10F.parCommand[2]:=ROM[PIC10F.I,2];
    PIC10F.parCommand[3]:=ROM[PIC10F.I,3];
    PIC10F.parCommand[4]:=ROM[PIC10F.I,4];
    PIC10F.parCommand[5]:=ROM[PIC10F.I,5];
    PIC10F.parCommand[6]:=ROM[PIC10F.I,6];
    PIC10F.parCommand[7]:=ROM[PIC10F.I,7];
    PIC10F.parCommand[8]:=ROM[PIC10F.I,8];
    PIC10F.parCommand[9]:=ROM[PIC10F.I,9];
    PIC10F.parCommand[10]:=ROM[PIC10F.I,10];
    PIC10F.parCommand[11]:=ROM[PIC10F.I,11];
    mainform.txtNext.Text:=GetInstruction();

    //Показ счетчиков - в другую процедуру
    mainform.txtIC.Text:=InttoStr(PIC10F.IC);
    mainform.txtMC.Text:=inttostr(pic10f.MC);
    //Port!
    mainform.txtRT.Text:=FloatToStr( pic10f.MC/1000000)+ ' sec';

  end;

end;
procedure RedrawPSFR();
var i,j, NewNumberOfRows:integer;
const SpSF=70; //Стартовая, начальная позиция для группы из 8 флажков и Shape
begin
//Вычисляем, сколько должно быть колонок по длине
NewNumberOfRows:=mainform.pnlSFR.height div 20 -2 ;
//Если по длине колонок может быть больше, чем всего SFR то уменьшить соответственно
if NewNumberOfRows>SFRCount then NewNumberOfRows:=SFRCount;

if NumberOfRowsinsfr<NewNumberofrows then //Надо создать новые элементы
  begin
  Setlength(arrayPSfr,NewNumberOfRows);
  for I := NumberOfRowsinSFR to NewNumberOfRows-1 do
    begin
    //Создадим Image слева с брейкпоинтом
    arrayPSfr[I].imgBP:=TImage.Create(Application);
    arrayPSfr[I].imgBP.parent:=mainform.pnlSFR;
    arrayPSfr[I].imgBP.Width:=12;
    arrayPSfr[I].imgBP.Height:=20;
    arrayPSfr[I].imgBP.Left:=0;
    arrayPSfr[I].imgBP.Top:=i*20+40;
    arrayPSfr[I].imgBP.Center:=true;
    arrayPSfr[I].imgBP.OnClick:=mainform.BpSFRclick;
    arrayPSfr[I].imgBP.Hint:='Click to set breakpoint on change';
    //Создатим текстовое поле с адресом
    arrayPSfr[I].edtAddr:=TEdit.Create(Application);
    arrayPSfr[I].edtAddr.Parent:=mainform.pnlSFR;
    arrayPSfr[I].edtAddr.Width:=28;
    arrayPSfr[I].edtAddr.Height:=20;
    arrayPSfr[I].edtAddr.Left:=12;
    arrayPSfr[I].edtAddr.Top:=i*20+40;
    arrayPSfr[I].edtAddr.ReadOnly:=true;
    //Создадим текстовое поле с именем
    arrayPSfr[I].edtName:=TEdit.Create(Application);
    arrayPSfr[I].edtName.Parent:=mainform.pnlSFR;
    arrayPSfr[I].edtName.Width:=65;
    arrayPSfr[I].edtName.Height:=20;
    arrayPSfr[I].edtName.Left:=40;
    arrayPSfr[I].edtName.Top:=i*20+40;
    arrayPSfr[I].edtName.ReadOnly:=true;
      //Создадим текстовое поле с HEX-значением
    arrayPSfr[I].edtHEX:=TEdit.Create(Application);
    arrayPSfr[I].edtHEX.Parent:=mainform.pnlSFR;
    arrayPSfr[I].edtHEX.Width:=20;
    arrayPSfr[I].edtHEX.Height:=20;
    arrayPSfr[I].edtHEX.Left:=105;
    arrayPSfr[I].edtHEX.Top:=i*20+40;
    arrayPSfr[I].edtHEX.ReadOnly:=true;
    //Создадим флажки и фигуры для Bin-поля
    for j := 0 to 3 do
      begin //Флажки
        arrayPSfr[I].cbBin[j]:=TCheckBox.Create(Application);
        arrayPSfr[I].cbBin[j].Parent:=mainform.pnlSFR;
        arrayPSfr[I].cbBin[j].Width:=8;
        arrayPSfr[I].cbBin[j].Height:=10;
        arrayPSfr[I].cbBin[j].Left:=156-(J*10);
        arrayPSfr[I].cbBin[j].Top:=i*20+51;
        arrayPSfr[I].cbBin[j].state:=cbGrayed;
        arrayPSfr[I].cbBin[j].ShowHint:=true;
        //Low разряд  shape
        arrayPSfr[I].shpBin[j]:=TShape.Create(Application);
        arrayPSfr[I].shpBin[j].Parent:=mainform.pnlSFR;
        arrayPSfr[I].shpBin[j].Width:=10;
        arrayPSfr[I].shpBin[j].Height:=10;
        arrayPSfr[I].shpBin[j].Left:=155-(J*10);
        arrayPSfr[I].shpBin[j].Top:=i*20+50;
        arrayPSfr[I].shpBin[j].Visible:=false;
        arrayPSfr[I].shpBin[j].Brush.Style:=bsClear;
        arrayPSfr[I].shpBin[j].Pen.Color:=clRed;
        //Флажки
        arrayPSfr[I].cbBin[j+4]:=TCheckBox.Create(Application);
        arrayPSfr[I].cbBin[j+4].Parent:=mainform.pnlSFR;
        arrayPSfr[I].cbBin[j+4].Width:=8;
        arrayPSfr[I].cbBin[j+4].Height:=10;
        arrayPSfr[I].cbBin[j+4].Left:=156-(J*10);
        arrayPSfr[I].cbBin[j+4].Top:=i*20+41;
        arrayPSfr[I].cbBin[j+4].state:=cbGrayed;
        arrayPSfr[I].cbBin[j+4].ShowHint:=true;
        //Hight разряд  shape
        arrayPSfr[I].shpBin[j+4]:=TShape.Create(Application);
        arrayPSfr[I].shpBin[j+4].Parent:=mainform.pnlSFR;
        arrayPSfr[I].shpBin[j+4].Width:=10;
        arrayPSfr[I].shpBin[j+4].Height:=10;
        arrayPSfr[I].shpBin[j+4].Left:=155-(J*10);
        arrayPSfr[I].shpBin[j+4].Top:=i*20+40;
        //arrayPSfr[I].shpBin[j+4].Visible:=false;
        arrayPSfr[I].shpBin[j+4].Brush.Style:=bsClear;
        arrayPSfr[I].shpBin[j+4].Pen.Color:=clRed;

      end;
     //Создадим имадже с дельтой
      arrayPSfr[I].imgDelta:=TImage.Create(Application);
      arrayPSfr[I].imgDelta.parent:=mainform.pnlSFR;
      arrayPSfr[I].imgDelta.Width:=11;
      arrayPSfr[I].imgDelta.Height:=20;
      arrayPSfr[I].imgDelta.Left:=165;
      arrayPSfr[I].imgDelta.Top:=i*20+40;
      arrayPSfr[I].imgDelta.Center:=true;

      arrayPSfr[I].imgDelta.Hint:='Red Delta - on change value; Green - on write in register and not change value';

    end;
  end;

if NumberOfRowsinsfr>NewNumberofrows then //Надо удалить лишние элементы
  begin

  for I := NewNumberOfRows  to NumberOfRowsinSFR-1 do
    begin
    //Удалим Имадже с брейкпойнтом
    arrayPSfr[I].imgBP.Destroy;
    //удалим текстовое поле с адресом
    arrayPSfr[I].edtAddr.Destroy;
    //удалим текстовое поле с именем
    arrayPSfr[I].edtName.Destroy;
    //удалим текстовое поле с HEX
    arrayPSfr[I].edtHEX.Destroy;
    //удалим Bin поле
    for j := 0 to 7 do
      begin
      arrayPSfr[I].cbbin[j].Destroy;
      arrayPSfr[I].shpbin[j].Destroy;
      end;
    end;
    //Удалим дельту
    arrayPSfr[I].imgDelta.Destroy;
  Setlength(arrayPSfr,NewNumberOfRows);
  end;

NumberOfRowsinsfr:=NewNumberofrows;
//Настройка скроллера
mainform.scrlSFR.Max:=sfrcount-NumberOfRowsinsfr;
mainform.scrlSFR.LargeChange:=NumberOfRowsinsfr;
end;

procedure UncheckMKinMenu();
begin
//Снять все флажки с типа мк
mainform.PIC10F2001.Checked:=false;

end;
Procedure UnCheckRateMenu();
begin
mainform.mnuStepByStep.Checked:=false;
mainform.mnuVerySlow.Checked:=false;
mainform.mnuSlow.Checked:=false;
mainform.mnuNormal.Checked:=false;
mainform.mnuFast.Checked:=false;
mainform.mnuVeryfast.Checked:=false;
mainform.mnuRealTime.Checked:=false;
mainform.mnuX2.Checked:=false;
mainform.mnuUltimate.Checked:=false;
end;


procedure TMainForm.CreateMDIChild(const Name: string);
var
  Child: TMDIChild;
begin
  { create a new MDI child window }
  Child := TMDIChild.Create(Application);
  Child.Caption := Name;
  if FileExists(Name) then Child.Memo1.Lines.LoadFromFile(Name);
end;



procedure TMainForm.FileNew1Execute(Sender: TObject);
begin
  CreateMDIChild('NONAME' + IntToStr(MDIChildCount + 1));
end;

procedure TMainForm.FileOpen1Execute(Sender: TObject);
begin
  if OpenDialog.Execute then
    begin
    if LoadHex(OpenDialog.FileName) then   CreateMDIChild(OpenDialog.FileName);



    end;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
pic10f.rtRunning:=false;
sleep(400);



formLoad:=false;

end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
formLoad:=true;

//Начальная инициализация переменных
NumberOfRowsinSFR:=0;  //Количество строк в графе SFR
//Начальное отключение панелей
pnlSFR.Visible:=false;
//Создание потока
 co:=TRun.Create(true);

 pic10f.rtRunning:=false;

end;



procedure TMainForm.FormResize(Sender: TObject);
begin

if formLoad=false then exit; //Когда форма закрыта, процедура не актуальна - выйти, чтобы избежать ошибок
//Ресайз тулбара
toolbar2.Width:=mainform.Width;
//Ресайз статус бара
StatusBar.Width:=mainform.Width;
StatusBar.Top:=mainform.Height-statusbar.Height-54;
//Ресайз панели счетчиков
pnlCounters.Left:=0;
pnlCounters.Top:=30;
//Ресайз панели sfr
pnlSFR.Top:=PnlCounters.Top+pnlCounters.Height;
pnlSFR.Height:=Mainform.Height-100-pnlCounters.Height;
scrlSFR.Height:=pnlSFR.Height-43;
// Перерисовать панель SFR
RedrawPSFR;
pnlSFR.Visible:=true;
//Присвоить значения полей
ShowAllRegAndCounters();

//Ресайз панели sfr
pnlGPR.Height:=Mainform.Height-100;
pnlGPR.Left:=mainform.Width-pnlGPR.Width-8;
scrGPR.Height:=pnlSFR.Height-43;
// Перерисовать панель SFR
//RedrawPGPR;
pnlGPR.Visible:=true;
//Присвоить значения полей
//ShowNameAddrGPR();
end;

procedure TMainForm.HelpAbout1Execute(Sender: TObject);
begin
  AboutBox.ShowModal;
end;

procedure TMainForm.mnuFastClick(Sender: TObject);
begin
//Снимим со всех галки
UncheckRateMenu();
//Поставим нужную
mainform.mnufast.Checked:=true;
//Изменяем параметры
pic10f.rtStepByStep:=false;
end;

procedure TMainForm.mnuNormalClick(Sender: TObject);
begin
//Снимим со всех галки
UncheckRateMenu();
//Поставим нужную
mainform.mnunormal.Checked:=true;
//Изменяем параметры
pic10f.rtStepByStep:=false;
end;

procedure TMainForm.mnuRealTimeClick(Sender: TObject);
begin
//Снимим со всех галки
UncheckRateMenu();
//Поставим нужную
mainform.mnurealtime.Checked:=true;
//Изменяем параметры
pic10f.rtStepByStep:=false;
pic10f.rtWithDelay:=false;
pic10f.rtWithSyncro:=true;
pic10f.rtSyncro:=1;
end;

procedure TMainForm.mnuSlowClick(Sender: TObject);
begin
//Снимим со всех галки
UncheckRateMenu();
//Поставим нужную
mainform.mnuslow.Checked:=true;
//Изменяем параметры
pic10f.rtStepByStep:=false;
end;

procedure TMainForm.mnuStepByStepClick(Sender: TObject);
begin
//Снимим со всех галки
UncheckRateMenu();
//Поставим нужную
mainform.mnuStepByStep.Checked:=true;
//Изменяем параметры
pic10f.rtWithDelay:=false;
pic10f.rtWithSyncro:=false;
pic10f.rtPause:=false;
pic10f.rtStepByStep:=true;
pic10f.rtexStep:=false;

end;

procedure TMainForm.mnuUltimateClick(Sender: TObject);
begin
//Снимим со всех галки
UncheckRateMenu();
//Поставим нужную
mainform.mnuultimate.Checked:=true;
//Изменяем параметры
pic10f.rtStepByStep:=false;
end;

procedure TMainForm.mnuVeryfastClick(Sender: TObject);
begin
//Снимим со всех галки
UncheckRateMenu();
//Поставим нужную
mainform.mnuveryfast.Checked:=true;
//Изменяем параметры
pic10f.rtStepByStep:=false;
end;

procedure TMainForm.mnuVerySlowClick(Sender: TObject);
begin
//Снимим со всех галки
UncheckRateMenu();
//Поставим нужную
mainform.mnuveryslow.Checked:=true;
//Изменяем параметры
pic10f.rtWithDelay:=false;
pic10f.rtStepByStep:=false;
pic10f.rtPause:=false;
pic10f.rtWithDelay:=true;
pic10f.rtDelayMS:=1000;
end;

procedure TMainForm.mnuX2Click(Sender: TObject);
begin
//Снимим со всех галки
UncheckRateMenu();
//Поставим нужную
mainform.mnux2.Checked:=true;
//Изменяем параметры
pic10f.rtStepByStep:=false;
end;

procedure TMainForm.PIC10F2001Click(Sender: TObject);
begin
UncheckMKinMenu();
PIC10F2001.Checked:=true;
PIC10f.SelectMC(0);
RedrawPSFR;
ShowAllRegAndCounters;
end;

procedure TMainForm.scrlSFRChange(Sender: TObject);
begin
 ShowAllRegAndCounters;
end;

procedure TMainForm.tlbPauseClick(Sender: TObject);
begin
  pic10f.rtPause:=true;
 tlbpause.Enabled:=false;
 tlbrun.Enabled:=true;

end;

procedure TMainForm.tlbRateMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
//pic10f.rtPause:=true;
end;

procedure TMainForm.tlbRateMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
//pic10f.rtPause:=false;
end;

procedure TMainForm.tlbRunClick(Sender: TObject);
label ll;
begin
//При паузе
if pic10f.rtPause=true then
  begin
    pic10f.rtPause:=false;
    tlbrun.Enabled:=false;
    tlbpause.Enabled:=true;
    exit;
  end;

//При простом запуске;

//Определим кол-во тактов CPU в такте МК
pic10f.rtCyclPerCycMK:=pic10f.DimensionCPUCyclesPerSecond div (pic10f.rtCrystalFreq div 4);
pic10f.rtsyncroTMP:=0;



tlbrun.Enabled:=false;
pic10f.rtRunning:=true;
co.Resume;
 co.Priority:= tpNormal;
 sleep (10);
 ShowAllRegAndCounters();
if pic10f.rtStepByStep=true then exit;

ll: application.ProcessMessages;
sleep(100);
ShowAllRegAndCounters();
if pic10f.rtRunning=false then exit;

goto ll;
end;

procedure TMainForm.FileExit1Execute(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.tlbStepClick(Sender: TObject);
begin
if pic10f.rtStepByStep  then pic10f.rtexStep:=true;
sleep (10);
ShowAllRegAndCounters();
end;

procedure TMainForm.tlbStopClick(Sender: TObject);
begin
tlbRun.Enabled:=true;
pic10f.rtRunning:=false;
end;

end.
