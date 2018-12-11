unit MAIN;

interface
uses vcl.graphics, Windows, SysUtils, Classes,  Forms, Controls, Menus,
  StdCtrls, Dialogs, Buttons, Messages, ExtCtrls, ComCtrls, StdActns,
  ActnList, ToolWin, ImgList, UnitFormat,BinaryFlag,DeltaBreakPoint,frmopen, theadRefresh,
  Gauges, System.Actions,unitweb, frmBugReport, frmCheckUpdates,CHILDWIN,ChildComp,frmOptions,shellapi,unitClasses4Devices, RVTypes, RVStyle;
var
EndRefresh:boolean;
//4 Dll
ELibHandle:THandle;
Get_family_mc:function():PChar;stdcall;
Get_SystemCommandCounter:Function():integer;stdcall;
//Get_ConfigBitsCounter:Function():integer;stdcall;
//Get_ConfigBitsHI:Function():integer;stdcall;
Get_rtRunning:Function():boolean;stdcall;
Set_rtRunning:Procedure(val:boolean);stdcall;
Get_UserTimer:Function():extended;stdcall;
Set_UserTimer:Procedure(val:extended);stdcall;
Get_MCandCF:procedure(var vMC:int64;var vCF:integer);stdcall;
Get_RAM:Function(val1,val2:integer):boolean;stdcall;
Set_RAM:Procedure(val1,val2:integer;val3:boolean);stdcall;
Get_ROM:Function(val1,val2:integer):boolean;stdcall;
Set_ROM:Procedure(val1,val2:integer;val3:boolean);stdcall;
Get_SFRcount:function():word;stdcall;
CurrentToParCommand:procedure;stdcall;
RomToParCommand:procedure(val:integer);stdcall;
GetInstruction:function():shortstring;stdcall;
Get_I:function():integer;stdcall;
Get_ROM_Size:function():integer;stdcall;
Get_rtRefreshComplete:function():boolean;stdcall;
Set_rtRefreshComplete:procedure(val:boolean);stdcall;
Get_GPRCount:function():integer;stdcall;
Get_rtPause:function():boolean;stdcall;
Set_rtPause:procedure(val:boolean);stdcall;
Set_RT_parametrs:procedure(WithSyncro,StepByStep,WithDelay:boolean;delayMS:integer;Syncro:real);stdcall;
Calculate_CuclPerCycMK_AndRun:procedure(ReturnCallback_stop:pointer;Devices:TDevices);stdcall;

Get_MatrixRAM_ToClearDelta:Function(val1:integer):boolean;stdcall;
Set_MatrixRAM_ToClearDelta:Procedure(val1:integer;val2:boolean);stdcall;
Get_MatrixRAM_SIMadress:Function(val1:integer):word;stdcall;
Set_MatrixRAM_SIMadress:Procedure(val1:integer;val2:word);stdcall;
Get_MatrixRAM_BreakPoint:Function(val1:integer):boolean;stdcall;
Set_MatrixRAM_BreakPoint:Procedure(val1:integer;val2:boolean);stdcall;
Get_MatrixRAM_GreenBP:Function(val1:integer):boolean;stdcall;
Set_MatrixRAM_GreenBP:Procedure(val1:integer;val2:boolean);stdcall;
Get_MatrixRAM_IDEHexaddres:Function(val1:integer):shortstring;stdcall;
Get_MatrixRAM_IDEName:Function(val1:integer):shortstring;stdcall;
Get_MatrixRAM_delta:Function(val1:integer):boolean;stdcall;
Set_MatrixRAM_delta:Procedure(val1:integer;val2:boolean);stdcall;
Get_MatrixRAM_greenDelta:Function(val1:integer):boolean;stdcall;
Set_MatrixRAM_greenDelta:Procedure(val1:integer;val2:boolean);stdcall;
Get_MatrixRAM_deltabit:Function(val1:integer;val2:byte):boolean;stdcall;
Set_MatrixRAM_deltabit:Procedure(val1:integer;val2:byte;val3:boolean);stdcall;
Get_MatrixRAM_usedbit:Function(val1:integer;val2:byte):boolean;stdcall;
Set_MatrixRAM_usedbit:Procedure(val1:integer;val2:byte;val3:boolean);stdcall;
Get_MatrixRAM_bitname:Function(val1:integer;val2:byte):shortstring;stdcall;
Set_MatrixRAM_bitname:Procedure(val1:integer;val2:byte;shortstring:boolean);stdcall;

Get_StackCounter:function():byte;stdcall;
Get_IC:function():int64;stdcall;
Get_stack:function(val:byte):TResStack; stdcall;
Get_PC:function():TResStack; stdcall;
Get_TaktsWDT:procedure(var valTaktsWDT,valrtTaktsWDT:real);stdcall;
Get_StackMax:function():byte;stdcall;



SelectMC:procedure(id:byte);stdcall;

Get_SystemCommand_CommandName:function(val:integer):shortstring;stdcall;

Get_parGOTOaddr:function():integer;stdcall;
Get_config:function(val:integer):boolean;stdcall;
Set_config:procedure(val:integer;val1:boolean);stdcall;

Get_RT_parametrs:procedure(var WithSyncro,StepByStep,WithDelay:boolean;var delayMS:integer;var Syncro:real);stdcall;
Set_rtexStep:procedure(val:boolean);stdcall;
Get_ROM_Str_No_from:function(val:integer):integer;stdcall;
Get_ROM_Str_No_to:function(val:integer):integer;stdcall;
Get_ROM_Str_No:function(val:integer):Integer;stdcall;
Set_ROM_Str_No_from:procedure(val:integer;val2:integer);stdcall;
Set_ROM_Str_No_to:procedure(val:integer;var2:integer);stdcall;
Set_ROM_Str_No:procedure(val:integer;var2:integer);stdcall;

Set_ROM_BP:procedure(val:integer;val2:boolean);stdcall;
Get_PC_Len:function():integer;stdcall;

//Get_ConfigBits:procedure(val:integer;var Name,value0,value1:shortstring;var No:integer);stdcall;

Destroy_CO:procedure();stdcall;
//Процедуры Designera
//C_init:Function(Canva:TImage;var width,height:integer):HDC;stdcall;
//C_free:Procedure();stdcall;

procedure StopSimulation();STDCALL;
Procedure SetRate(ModeNO:integer);



type TPSfr = record
  imgBP:TDeltaBreakPoint;
  imgDelta:TImage;
  edtAddr:TEdit;
  edtName:TEdit;
  edtHex:TEdit;
  bfBin:array[0..7] of TBinaryFlag;

end;
type TPStack = record
  edtLvl:TEdit;
  edtHex:TEdit;
  bfBin:array  of TBinaryFlag;
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
    scrlGPR: TScrollBar;
    Option1: TMenuItem;
    tlbStep: TToolButton;
    pnlCounters: TPanel;
    Shape2: TShape;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    txtLast: TEdit;
    txtNext: TEdit;
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
    pnlStack: TPanel;
    Shape4: TShape;
    Label10: TLabel;
    Label11: TLabel;
    txtStackCounter: TEdit;
    scrlStack: TScrollBar;
    Image5: TImage;
    Label6: TLabel;
    txtRTSpeed: TEdit;
    TmrRTS: TTimer;
    N4: TMenuItem;
    FileExportAsmItem: TMenuItem;
    FileExportHexItem: TMenuItem;
    dlgExportASM: TSaveDialog;
    mnuConfigBits: TMenuItem;
    prgWDT: TGauge;
    txtUserTimer: TEdit;
    Label12: TLabel;
    btnClear: TButton;
    dlgExportHex: TSaveDialog;
    tmrRefresh: TTimer;
    iHelpChkUpdItem: TMenuItem;
    iBugReportItem: TMenuItem;
    Label13: TLabel;
    SD: TSaveDialog;
    ImageList2: TImageList;
    FileExportAsm1: TAction;
    FileExportHex1: TAction;
    OptionConfigBits1: TAction;
    WindowArrange1: TWindowArrange;
    ActionRate: TAction;
    WindowArrange2: TWindowArrange;
    ActionRun: TAction;
    Run1: TMenuItem;
    ActionRate1: TMenuItem;
    ActionRun1: TMenuItem;
    ActionPause: TAction;
    ActionStop: TAction;
    ActionStep: TAction;
    Pause1: TMenuItem;
    Stop1: TMenuItem;
    Step1: TMenuItem;
    ActionRateSBS: TAction;
    ActionRateVS: TAction;
    ActionRateSlow: TAction;
    ActionRateNormal: TAction;
    ActionRateFast: TAction;
    ActionRateVF: TAction;
    ActionRateRT: TAction;
    ActionRateX2: TAction;
    ActionRateUL: TAction;
    StepByStep1: TMenuItem;
    N5: TMenuItem;
    VerySlow1: TMenuItem;
    Slow1: TMenuItem;
    Normal1: TMenuItem;
    Fast1: TMenuItem;
    VeryFast1: TMenuItem;
    N6: TMenuItem;
    RealTime1: TMenuItem;
    VerySlow2: TMenuItem;
    Ultimate1: TMenuItem;
    HelpChkUpdItem: TAction;
    BugReportItem: TAction;
    ActionOptions: TAction;
    Action11: TMenuItem;
    HelpDonateItem: TMenuItem;
    Label14: TLabel;
    txtPChex: TEdit;
    ActionClearBP: TAction;
    ActionClearBP1: TMenuItem;
    HelpHelp: TAction;
    HelpHelp1: TMenuItem;
    procedure FileNew1Execute(Sender: TObject);
    procedure FileOpen1Execute(Sender: TObject);
    procedure HelpAbout1Execute(Sender: TObject);
    procedure FileExit1Execute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
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
    procedure tlbPauseClick(Sender: TObject);
    procedure tlbRateMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tlbRateMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure scrlSFRChange(Sender: TObject);
    procedure TmrRTSTimer(Sender: TObject);
    procedure FileExportAsmItemClick(Sender: TObject);
    procedure FileExportHexItemClick(Sender: TObject);
    procedure mnuConfigBitsClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure tmrRefreshTimer(Sender: TObject);
    procedure iHelpChkUpdItemClick(Sender: TObject);
    procedure iBugReportItemClick(Sender: TObject);
    procedure FileSave1Execute(Sender: TObject);
    procedure tlbStopClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FileClose1Execute(Sender: TObject);
    procedure FileSaveAs1Execute(Sender: TObject);
    procedure FileClose1Update(Sender: TObject);
    procedure FileSaveAs1Update(Sender: TObject);
    procedure FileSave1Update(Sender: TObject);
    procedure FileExportHex1Update(Sender: TObject);
    procedure FileExportAsm1Update(Sender: TObject);
    procedure OptionConfigBits1Update(Sender: TObject);
    procedure WindowArrangeAll1Execute(Sender: TObject);
    procedure scrlGPRChange(Sender: TObject);
    procedure ActionRateUpdate(Sender: TObject);
    procedure ActionRunUpdate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ActionRateExecute(Sender: TObject);
    procedure ActionOptionsExecute(Sender: TObject);
    procedure scrlGPRScroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure HelpDonateItemClick(Sender: TObject);
    procedure ActionClearBPUpdate(Sender: TObject);
    procedure ActionClearBPExecute(Sender: TObject);
    procedure HelpHelpExecute(Sender: TObject);




  private
    { Private declarations }

    procedure CreateMDIChild(const Name: string;TypeCall:Byte);

  public
    { Public declarations }
    procedure BpSFRclick(Sender:TObject);
    procedure BfSFRclick(Sender:TObject);
    procedure BpGPRclick(Sender:TObject);
    procedure BfGPRclick(Sender:TObject);

    procedure ShowAllRegAndCounters();
    procedure CreateAllChild();
    Procedure LoadDllMC();
    var AsmWindowOpen:boolean; //Открытое окно ассемблера
    AsmChild: TMDIChild; //Окно ассемблера
    CompChild:TfrmChildComp; //Окно конструктора
    ProjectFileName:string; //имя файла-проекта)
    MCULibLoaded:boolean; //Загружена ли в память Dll-ка c микроконтроллером
    exchange:boolean; //Сделаны ли изменения в файл

  end;

var
  MainForm: TMainForm;
  formLoad:boolean;//true когда форма открыта
  MustClose:boolean; //False, когда ФОРМА НЕ ДОЛЖНА БЫТЬ ЗАКРЫТА (пользователь в диалоге о сохр. перед закр. нажал отменва)
  prjSaved:boolean; //False, когда проект по каким-то причинам не сохр.
implementation

{$R *.dfm}

uses  about, unitRes, unitDev;
Var arrayPSfr: array of TPSfr;
arrayPGPR: array of TPSfr;
arrayPStack:array of TPStack;
PC:array  of TBinaryFlag;
PCLen:integer;
NumberOfRowsinSFR:integer;
NumberOfRowsinGPR:integer;
NumberOfRowsInStack:integer = 0;

predMC:int64; //Для расчета скорости в %
{GPRScrollPos:integer=0; //Позиция скролбара GPR (костыль);
SFRScrollPos:integer=0; //Позиция скролбара SFR (костыль); } //УДАЛИТЬ за ненадобностью, если увидишь!
//Тут в зависимости от того, в каком режиме запущена прога (Debug, run) устанавливаются папки к отдельным библиотекам
{$IFOPT D+}
  //Debug
  const DebugMode=1;
{$ELSE}
  //Run
  const DebugMode=0;
{$ENDIF}

Procedure TMainForm.LoadDllMC();
var tmpStr:string;
begin
  //#hoi
//Модифицировать код
//Загрузка библиотеки dll




  sleep(1);
 // application.ProcessMessages; //Убрал, потомучто выдает ошибку, связанную с таймером при откладке
  sleep(200);
  tmpStr:=AInfoDevice[unitdev.CurrentDevice].evFileName;
    ELibHandle:=LoadLibrary(PChar(tmpStr));
    Win32Check(ELibHandle <> 0);


  begin
  @Get_family_mc:=GetProcAddress(ELibHandle,'Get_family_mc');
  @Get_SystemCommandCounter:=GetProcAddress(ELibHandle,'Get_SystemCommandCounter');
//  @Get_ConfigBitsCounter:=GetProcAddress(ELibHandle,'Get_ConfigBitsCounter');
//  @Get_ConfigBitsHI:=GetProcAddress(ELibHandle,'Get_ConfigBitsHI');
  @Get_rtRunning:=GetProcAddress(ELibHandle,'Get_rtRunning');
  @Set_rtRunning:=GetProcAddress(ELibHandle,'Set_rtRunning');
  @Get_UserTimer:=GetProcAddress(ELibHandle,'Get_UserTimer');
  @Set_UserTimer:=GetProcAddress(ELibHandle,'Set_UserTimer');
  @Get_MCandCF:=GetProcAddress(ELibHandle,'Get_MCandCF');
  @Get_RAM:=GetProcAddress(ELibHandle,'Get_RAM');
  @Set_RAM:=GetProcAddress(ELibHandle,'Set_RAM');
  @Get_ROM:=GetProcAddress(ELibHandle,'Get_ROM');
  @Set_ROM:=GetProcAddress(ELibHandle,'Set_ROM');
  @Get_SFRcount:=GetProcAddress(ELibHandle,'Get_SFRcount');
  @CurrentToParCommand:=GetProcAddress(ELibHandle,'CurrentToParCommand');
  @RomToParCommand:=GetProcAddress(ELibHandle,'RomToParCommand');
  @GetInstruction:=GetProcAddress(ELibHandle,'GetInstruction');
  @Get_I:=GetProcAddress(ELibHandle,'Get_I');
  @Get_ROM_Size:=GetProcAddress(ELibHandle,'Get_ROM_Size');
  @Get_rtRefreshComplete:=GetProcAddress(ELibHandle,'Get_rtRefreshComplete');
  @Set_rtRefreshComplete:=GetProcAddress(ELibHandle,'Set_rtRefreshComplete');
  @Get_GPRCount:=GetProcAddress(ELibHandle,'Get_GPRCount');
  @Get_rtPause:=GetProcAddress(ELibHandle,'Get_rtPause');
  @Set_rtPause:=GetProcAddress(ELibHandle,'Set_rtPause');
  @Set_RT_parametrs:=GetProcAddress(ELibHandle,'Set_RT_parametrs');

  @Get_MatrixRAM_ToClearDelta:=GetProcAddress(ELibHandle,'Get_MatrixRAM_ToClearDelta');
  @Set_MatrixRAM_ToClearDelta:=GetProcAddress(ELibHandle,'Set_MatrixRAM_ToClearDelta');
  @Get_MatrixRAM_SIMadress:=GetProcAddress(ELibHandle,'Get_MatrixRAM_SIMadress');
  @Set_MatrixRAM_SIMadress:=GetProcAddress(ELibHandle,'Set_MatrixRAM_SIMadress');
  @Get_MatrixRAM_BreakPoint:=GetProcAddress(ELibHandle,'Get_MatrixRAM_BreakPoint');
  @Set_MatrixRAM_BreakPoint:=GetProcAddress(ELibHandle,'Set_MatrixRAM_BreakPoint');
  @Get_MatrixRAM_GreenBP:=GetProcAddress(ELibHandle,'Get_MatrixRAM_GreenBP');
  @Set_MatrixRAM_GreenBP:=GetProcAddress(ELibHandle,'Set_MatrixRAM_GreenBP');
  @Get_MatrixRAM_IDEHexaddres:=GetProcAddress(ELibHandle,'Get_MatrixRAM_IDEHexaddres');
  @Get_MatrixRAM_IDEName:=GetProcAddress(ELibHandle,'Get_MatrixRAM_IDEName');
  @Get_MatrixRAM_delta:=GetProcAddress(ELibHandle,'Get_MatrixRAM_delta');
  @Set_MatrixRAM_delta:=GetProcAddress(ELibHandle,'Set_MatrixRAM_delta');
  @Get_MatrixRAM_greenDelta:=GetProcAddress(ELibHandle,'Get_MatrixRAM_greenDelta');
  @Set_MatrixRAM_greenDelta:=GetProcAddress(ELibHandle,'Set_MatrixRAM_greenDelta');
  @Get_MatrixRAM_deltabit:=GetProcAddress(ELibHandle,'Get_MatrixRAM_deltabit');
  @Set_MatrixRAM_deltabit:=GetProcAddress(ELibHandle,'Set_MatrixRAM_deltabit');
  @Get_MatrixRAM_usedbit:=GetProcAddress(ELibHandle,'Get_MatrixRAM_usedbit');
  @Set_MatrixRAM_usedbit:=GetProcAddress(ELibHandle,'Set_MatrixRAM_usedbit');
  @Get_MatrixRAM_bitname:=GetProcAddress(ELibHandle,'Get_MatrixRAM_bitname');
  @Set_MatrixRAM_bitname:=GetProcAddress(ELibHandle,'Set_MatrixRAM_bitname');

  @Get_StackCounter:=GetProcAddress(ELibHandle,'Get_StackCounter');
  @Get_IC:=GetProcAddress(ELibHandle,'Get_IC');
  @Get_stack:=GetProcAddress(ELibHandle,'Get_stack');
  @Get_PC:=GetProcAddress(ELibHandle,'Get_PC');
  @Get_TaktsWDT:=GetProcAddress(ELibHandle,'Get_TaktsWDT');
  @Get_StackMax:=GetProcAddress(ELibHandle,'Get_StackMax');

  @Calculate_CuclPerCycMK_AndRun:=GetProcAddress(ELibHandle,'Calculate_CuclPerCycMK');

  @SelectMC:=GetProcAddress(ELibHandle,'SelectMC');



  @Get_SystemCommand_CommandName:=GetProcAddress(ELibHandle,'Get_SystemCommand_CommandName');
  @Get_parGOTOaddr:=GetProcAddress(ELibHandle,'Get_parGOTOaddr');

  @Get_config:=GetProcAddress(ELibHandle,'Get_config');
  @Set_config:=GetProcAddress(ELibHandle,'Set_config');
  @Get_RT_parametrs:=GetProcAddress(ELibHandle,'Get_RT_parametrs');
  @Set_rtexStep:= GetProcAddress(ELibHandle,'Set_rtexStep');
  @Get_ROM_Str_No_from:=GetProcAddress(ELibHandle,'Get_ROM_Str_No_from');
  @Get_ROM_Str_No_to:=GetProcAddress(ELibHandle,'Get_ROM_Str_No_to');
  @Get_ROM_Str_No:= GetProcAddress(ELibHandle,'Get_ROM_Str_No');
  @Set_ROM_Str_No_from:=GetProcAddress(ELibHandle,'Set_ROM_Str_No_from');
  @Set_ROM_Str_No_to:=GetProcAddress(ELibHandle,'Set_ROM_Str_No_to');
  @Set_ROM_Str_No:= GetProcAddress(ELibHandle,'Set_ROM_Str_No');
  @Set_ROM_BP:= GetProcAddress(ELibHandle,'Set_ROM_BP');
  @Get_PC_Len:= GetProcAddress(ELibHandle,'Get_PC_Len');
//  @Get_ConfigBits:=GetProcAddress(ELibHandle,'Get_ConfigBits');

  @Destroy_CO:=GetProcAddress(ELibHandle,'Destroy_CO');
  //@C_init:=GetProcAddress(ELibHandle,'C_init');
  //@C_free:=GetProcAddress(ELibHandle,'C_free');
  //if @Get_family_mc<>nil then
    //showmessage(StrPas(Get_family_mc()));
  end;

MCULibLoaded:=true;
//Задание скорости работы
SetRate(100);
//Выбор МК
{
UncheckMKinMenu();
PIC10F2001.Checked:=true;}
SelectMC(unitdev.CurrentSubDevice);
FormResize(Self);

end;
procedure TMainForm.CreateAllChild();
begin
  {if main.MainForm.AsmChild<>nil then main.MainForm.AsmChild.Destroy;
  if main.MainForm.CompChild<>nil then main.MainForm.CompChild.Destroy;   }

   main.MainForm.AsmChild:= TMDIChild.Create(application);
   main.MainForm.CompChild:=TfrmChildComp.Create(application );


end;

procedure StopSimulation();stdcaLL;
begin

if main.MainForm.MCULibLoaded then set_rtRunning(false);
end;

procedure TMainForm.BpSFRclick(Sender: TObject);
begin
//клик по Брякпоинту


Set_MatrixRAM_BreakPoint(TDeltaBreakPoint(sender).ByteAddres,TDeltaBreakPoint(sender).BPDelta);
Set_MatrixRAM_GreenBP(TDeltaBreakPoint(sender).ByteAddres,TDeltaBreakPoint(sender).BPGreenDelta);
end;

procedure TMainForm.btnClearClick(Sender: TObject);
var vMC:int64;
vCF:integer;
begin
Get_MCandCF(vMC,vCF);
set_UserTimer(vMC/1000000);
mainform.txtUserTimer.Text:=FloatToStrF( (vMC/1000000)-get_UserTimer(),ffFixed,12,7)+' '+ GetText(2020);

end;

procedure TMainForm.iBugReportItemClick(Sender: TObject);
begin
FormBugReport.ShowModal;
end;



procedure TMainForm.BfSFRclick(Sender: TObject);
begin
Set_RAM( TBinaryFlag(sender).ByteAddres,TBinaryFlag(sender).BitAddres,TBinaryFlag(sender).value);
end;

procedure TMainForm.BpGPRclick(Sender: TObject);
begin
//клик по Брякпоинту


Set_MatrixRAM_BreakPoint(TDeltaBreakPoint(sender).ByteAddres,TDeltaBreakPoint(sender).BPDelta);
Set_MatrixRAM_GreenBP(TDeltaBreakPoint(sender).ByteAddres,TDeltaBreakPoint(sender).BPGreenDelta);
end;

procedure TMainForm.HelpHelpExecute(Sender: TObject);
begin
ShellExecute(handle,'open','http://at-control.com/help.html',nil,nil,SW_SHOWNORMAL);

end;

procedure TMainForm.ActionClearBPExecute(Sender: TObject);
var RS,JJ:integer;
itNo,vImgInd:integer;
vName:TRVAnsiString;
vTag:TRVTag;
vImgList:TCustomImageList;
begin
RS:=Get_ROM_Size()+1;
for JJ := 0 to RS do Set_ROM_BP(JJ,False);
FOR JJ:=1 to self.AsmChild.RVbp.ItemCount  do
if JJ mod 2 <> 0 then
begin
self.AsmChild.RVbp.GetBulletInfo(JJ,vName,vImgInd,vImgList,vTag);
if vImgInd=0 then  self.AsmChild.RVbp.SetBulletInfo(JJ,vName,2,vImgList,vTag);
if vImgInd=1 then  self.AsmChild.RVbp.SetBulletInfo(JJ,vName,3,vImgList,vTag);
if vImgInd=4 then  self.AsmChild.RVbp.SetBulletInfo(JJ,vName,2,vImgList,vTag);
if vImgInd=5 then  self.AsmChild.RVbp.SetBulletInfo(JJ,vName,2,vImgList,vTag);
end;
self.AsmChild.RVbp.Format;


end;

procedure TMainForm.ActionClearBPUpdate(Sender: TObject);
begin
 ActionClearBP.Enabled:=AsmWindowOpen;
end;

procedure TMainForm.ActionOptionsExecute(Sender: TObject);
begin
  formOptions:=TformOptions.Create(application);
  formOptions.ShowModal;
  formOptions.Free;
end;

procedure TMainForm.ActionRateExecute(Sender: TObject);
begin
ActionRate.Enabled:=AsmWindowOpen;
end;

procedure TMainForm.ActionRateUpdate(Sender: TObject);
begin
ActionRate.Enabled:=AsmWindowOpen;
end;

procedure TMainForm.ActionRunUpdate(Sender: TObject);
begin
ActionRun.Enabled:=AsmWindowOpen;


end;

procedure TMainForm.BfGPRclick(Sender: TObject);
begin
Set_RAM(TBinaryFlag(sender).ByteAddres,TBinaryFlag(sender).BitAddres,TBinaryFlag(sender).value);

end;
procedure TMainForm.ShowAllRegAndCounters();
var i,gI,z,tmp,tI:integer;
SFRcount:word;
   StC:byte;
   bSt0,bSt1,bSt2,bSt3,bSt4,bSt5,bSt6,bSt7:boolean;
   valTaktsWDT,valrtTaktsWDT:Real;
   cf:integer;
var vSt,vPC:TResStack;
var vMC:int64;
vCF:integer;
begin
if not formLoad then exit;
if not EndRefresh  then exit;
SFRcount:=Get_SFRcount;
gI:=Get_I();
EndRefresh:=false;
application.ProcessMessages;
//SFR
  z:=mainform.scrlSFR.Position;
  for I := 0 to NumberOfRowsinsfr-1 do
  begin
  application.ProcessMessages;
  //Очистить дельту
    if Get_MatrixRAM_ToClearDelta(Get_MatrixRAM_SIMadress(I+z))   then
      begin
        Set_MatrixRAM_ToClearDelta(Get_MatrixRAM_SIMadress(I+z),false);

        //arrayPSfr[I].imgDelta.Picture:=mainform.imgnil.Picture;
        arrayPSfr[I].bfBin[0].Delta:=false;  //11.08.2015 убрал везде arrayPSfr[I+z], если косяк, то попробовать добавить +z
        arrayPSfr[I].bfBin[1].Delta:=false;
        arrayPSfr[I].bfBin[2].Delta:=false;
        arrayPSfr[I].bfBin[3].Delta:=false;
        arrayPSfr[I].bfBin[4].Delta:=false;
        arrayPSfr[I].bfBin[5].Delta:=false;
        arrayPSfr[I].bfBin[6].Delta:=false;
        arrayPSfr[I].bfBin[7].Delta:=false;
      end;
    //Адрес
    arrayPSfr[I].edtAddr.Text:=Get_MatrixRAM_IDEHexaddres(Get_MatrixRAM_SIMadress(I+z));
    //Имя
    arrayPSfr[I].edtname.Text:=Get_MatrixRAM_IDEName(Get_MatrixRAM_SIMadress(I+z));
    //Hex-addr
      par[0]:=Get_RAM(Get_MatrixRAM_SIMadress(I+z),0);
      par[1]:=Get_RAM(Get_MatrixRAM_SIMadress(I+z),1);
      par[2]:=Get_RAM(Get_MatrixRAM_SIMadress(I+z),2);
      par[3]:=Get_RAM(Get_MatrixRAM_SIMadress(I+z),3);
      par[4]:=Get_RAM(Get_MatrixRAM_SIMadress(I+z),4);
      par[5]:=Get_RAM(Get_MatrixRAM_SIMadress(I+z),5);
      par[6]:=Get_RAM(Get_MatrixRAM_SIMadress(I+z),6);
      par[7]:=Get_RAM(Get_MatrixRAM_SIMadress(I+z),7);
      par[8]:=false;
      arrayPSfr[I].edtHex.Text:= BinToHex();

    //Дельта

    if Get_MatrixRAM_delta(Get_MatrixRAM_SIMadress(I+z))=true then
      if Get_MatrixRAM_greenDelta(Get_MatrixRAM_SIMadress(I+z))=true then
        begin //Зеленая дельта
        arrayPSfr[I].imgDelta.Picture:=mainform.imgGreenDelta.Picture;
        Set_MatrixRAM_delta(Get_MatrixRAM_SIMadress(I+z),false);
        Set_MatrixRAM_greenDelta(Get_MatrixRAM_SIMadress(I+z),true);
        end
        else
        begin //Красная дельта
        arrayPSfr[I].imgDelta.Picture:=mainform.imgRedDelta.Picture;
        Set_MatrixRAM_delta(Get_MatrixRAM_SIMadress(I+z),false);
        Set_MatrixRAM_greenDelta(Get_MatrixRAM_SIMadress(I+z),true);
        Set_MatrixRAM_ToClearDelta(Get_MatrixRAM_SIMadress(I+z),true);
       // if  (rtWithDelay or rtStepByStep) then    //Показ квадратов дельты только в режиме задержки или шаг за шагом
       //begin

        if Get_MatrixRAM_deltabit(Get_MatrixRAM_SIMadress(I+z),0) then
        begin
        arrayPSfr[I].bfBin[0].Delta:=true;
        Set_MatrixRAM_deltabit(Get_MatrixRAM_SIMadress(I+z),0,false);
        end;
        if Get_MatrixRAM_deltabit(Get_MatrixRAM_SIMadress(I+z),1) then
        begin
        arrayPSfr[I].bfBin[1].Delta:=true;
        Set_MatrixRAM_deltabit(Get_MatrixRAM_SIMadress(I+z),1,false);
        end;
        if Get_MatrixRAM_deltabit(Get_MatrixRAM_SIMadress(I+z),2) then
        begin
        arrayPSfr[I].bfBin[2].Delta:=true;
        Set_MatrixRAM_deltabit(Get_MatrixRAM_SIMadress(I+z),2,false);
        end;
        if Get_MatrixRAM_deltabit(Get_MatrixRAM_SIMadress(I+z),3) then
        begin
        arrayPSfr[I].bfBin[3].Delta:=true;
        Set_MatrixRAM_deltabit(Get_MatrixRAM_SIMadress(I+z),3,false);
        end;
        if Get_MatrixRAM_deltabit(Get_MatrixRAM_SIMadress(I+z),4) then
        begin
        arrayPSfr[I].bfBin[4].Delta:=true;
        Set_MatrixRAM_deltabit(Get_MatrixRAM_SIMadress(I+z),4,false);
        end;
        if Get_MatrixRAM_deltabit(Get_MatrixRAM_SIMadress(I+z),5) then
        begin
        arrayPSfr[I].bfBin[5].Delta:=true;
        Set_MatrixRAM_deltabit(Get_MatrixRAM_SIMadress(I+z),5,false);
        end;
        if Get_MatrixRAM_deltabit(Get_MatrixRAM_SIMadress(I+z),6) then
        begin
        arrayPSfr[I].bfBin[6].Delta:=true;
        Set_MatrixRAM_deltabit(Get_MatrixRAM_SIMadress(I+z),6,false);
        end;
        if Get_MatrixRAM_deltabit(Get_MatrixRAM_SIMadress(I+z),7) then
        begin
        arrayPSfr[I].bfBin[7].Delta:=true;
        Set_MatrixRAM_deltabit(Get_MatrixRAM_SIMadress(I+z),7,false);
        end;

        //end;
        end
    else
    arrayPSfr[I].imgDelta.Picture:=mainform.imgnil.Picture;

    arrayPSfr[I].bfBin[0].ReadOnl:=Get_MatrixRAM_usedbit(Get_MatrixRAM_SIMadress(I+z),0);
    arrayPSfr[I].bfBin[1].ReadOnl:=Get_MatrixRAM_usedbit(Get_MatrixRAM_SIMadress(I+z),1);
    arrayPSfr[I].bfBin[2].ReadOnl:=Get_MatrixRAM_usedbit(Get_MatrixRAM_SIMadress(I+z),2);
    arrayPSfr[I].bfBin[3].ReadOnl:=Get_MatrixRAM_usedbit(Get_MatrixRAM_SIMadress(I+z),3);
    arrayPSfr[I].bfBin[4].ReadOnl:=Get_MatrixRAM_usedbit(Get_MatrixRAM_SIMadress(I+z),4);
    arrayPSfr[I].bfBin[5].ReadOnl:=Get_MatrixRAM_usedbit(Get_MatrixRAM_SIMadress(I+z),5);
    arrayPSfr[I].bfBin[6].ReadOnl:=Get_MatrixRAM_usedbit(Get_MatrixRAM_SIMadress(I+z),6);
    arrayPSfr[I].bfBin[7].ReadOnl:=Get_MatrixRAM_usedbit(Get_MatrixRAM_SIMadress(I+z),7);
    arrayPSfr[I].bfBin[0].value:=Get_RAM(Get_MatrixRAM_SIMadress(I+z),0);
    arrayPSfr[I].bfBin[1].value:=Get_RAM(Get_MatrixRAM_SIMadress(I+z),1);
    arrayPSfr[I].bfBin[2].value:=Get_RAM(Get_MatrixRAM_SIMadress(I+z),2);
    arrayPSfr[I].bfBin[3].value:=Get_RAM(Get_MatrixRAM_SIMadress(I+z),3);
    arrayPSfr[I].bfBin[4].value:=Get_RAM(Get_MatrixRAM_SIMadress(I+z),4);
    arrayPSfr[I].bfBin[5].value:=Get_RAM(Get_MatrixRAM_SIMadress(I+z),5);
    arrayPSfr[I].bfBin[6].value:=Get_RAM(Get_MatrixRAM_SIMadress(I+z),6);
    arrayPSfr[I].bfBin[7].value:=Get_RAM(Get_MatrixRAM_SIMadress(I+z),7);

    arrayPSfr[I].bfBin[0].hint:=Get_MatrixRAM_bitname(Get_MatrixRAM_SIMadress(I+z),0);
    arrayPSfr[I].bfBin[1].hint:=Get_MatrixRAM_bitname(Get_MatrixRAM_SIMadress(I+z),1);
    arrayPSfr[I].bfBin[2].hint:=Get_MatrixRAM_bitname(Get_MatrixRAM_SIMadress(I+z),2);
    arrayPSfr[I].bfBin[3].hint:=Get_MatrixRAM_bitname(Get_MatrixRAM_SIMadress(I+z),3);
    arrayPSfr[I].bfBin[4].hint:=Get_MatrixRAM_bitname(Get_MatrixRAM_SIMadress(I+z),4);
    arrayPSfr[I].bfBin[5].hint:=Get_MatrixRAM_bitname(Get_MatrixRAM_SIMadress(I+z),5);
    arrayPSfr[I].bfBin[6].hint:=Get_MatrixRAM_bitname(Get_MatrixRAM_SIMadress(I+z),6);
    arrayPSfr[I].bfBin[7].hint:=Get_MatrixRAM_bitname(Get_MatrixRAM_SIMadress(I+z),7);

    arrayPSfr[I].bfBin[0].ByteAddres:=Get_MatrixRAM_SIMadress(I+z);
    arrayPSfr[I].bfBin[1].ByteAddres:=Get_MatrixRAM_SIMadress(I+z);
    arrayPSfr[I].bfBin[2].ByteAddres:=Get_MatrixRAM_SIMadress(I+z);
    arrayPSfr[I].bfBin[3].ByteAddres:=Get_MatrixRAM_SIMadress(I+z);
    arrayPSfr[I].bfBin[4].ByteAddres:=Get_MatrixRAM_SIMadress(I+z);
    arrayPSfr[I].bfBin[5].ByteAddres:=Get_MatrixRAM_SIMadress(I+z);
    arrayPSfr[I].bfBin[6].ByteAddres:=Get_MatrixRAM_SIMadress(I+z);
    arrayPSfr[I].bfBin[7].ByteAddres:=Get_MatrixRAM_SIMadress(I+z);

    arrayPSfr[I].bfBin[0].BitAddres:=0;
    arrayPSfr[I].bfBin[1].BitAddres:=1;
    arrayPSfr[I].bfBin[2].BitAddres:=2;
    arrayPSfr[I].bfBin[3].BitAddres:=3;
    arrayPSfr[I].bfBin[4].BitAddres:=4;
    arrayPSfr[I].bfBin[5].BitAddres:=5;
    arrayPSfr[I].bfBin[6].BitAddres:=6;
    arrayPSfr[I].bfBin[7].BitAddres:=7;
    //Брякпоинт
    arrayPSfr[I].imgBP.ByteAddres:=Get_MatrixRAM_SIMadress(I+z);
     arrayPSfr[I].imgBP.BPDelta:=Get_MatrixRAM_BreakPoint(Get_MatrixRAM_SIMadress(I+z));
    arrayPSfr[I].imgBP.BPGreenDelta:=Get_MatrixRAM_GreenBP(Get_MatrixRAM_SIMadress(I+z));
    end;
//GPR
  z:=mainform.scrlGPR.Position;
  for I := 0 to NumberOfRowsinGPR-1 do
  begin
  application.ProcessMessages;
  //Очистить дельту
    if Get_MatrixRAM_ToClearDelta(Get_MatrixRAM_SIMadress(I+z+SFRcount))   then
      begin
        Set_MatrixRAM_ToClearDelta(Get_MatrixRAM_SIMadress(I+z+SFRcount),false);

        //arrayPSfr[I].imgDelta.Picture:=mainform.imgnil.Picture;
        arrayPGPR[I].bfBin[0].Delta:=false;
        arrayPGPR[I].bfBin[1].Delta:=false;
        arrayPGPR[I].bfBin[2].Delta:=false;
        arrayPGPR[I].bfBin[3].Delta:=false;
        arrayPGPR[I].bfBin[4].Delta:=false;
        arrayPGPR[I].bfBin[5].Delta:=false;
        arrayPGPR[I].bfBin[6].Delta:=false;
        arrayPGPR[I].bfBin[7].Delta:=false;
      end;
    //Адрес
     arrayPGPR[I].edtAddr.Text:=Get_MatrixRAM_IDEHexaddres(Get_MatrixRAM_SIMadress(I+z+SFRcount));
    //Имя
     arrayPGPR[I].edtname.Text:=Get_MatrixRAM_IDEName(Get_MatrixRAM_SIMadress(I+z+SFRcount));
    //Hex-addr
      par[0]:=Get_RAM(Get_MatrixRAM_SIMadress(I+z+SFRcount),0);
      par[1]:=Get_RAM(Get_MatrixRAM_SIMadress(I+z+SFRcount),1);
      par[2]:=Get_RAM(Get_MatrixRAM_SIMadress(I+z+SFRcount),2);
      par[3]:=Get_RAM(Get_MatrixRAM_SIMadress(I+z+SFRcount),3);
      par[4]:=Get_RAM(Get_MatrixRAM_SIMadress(I+z+SFRcount),4);
      par[5]:=Get_RAM(Get_MatrixRAM_SIMadress(I+z+SFRcount),5);
      par[6]:=Get_RAM(Get_MatrixRAM_SIMadress(I+z+SFRcount),6);
      par[7]:=Get_RAM(Get_MatrixRAM_SIMadress(I+z+SFRcount),7);
      par[8]:=false;
      arrayPGPR[I].edtHex.Text:= BinToHex();

    //Дельта

    if Get_MatrixRAM_delta(Get_MatrixRAM_SIMadress(I+z+SFRcount))=true then
      if Get_MatrixRAM_greenDelta(Get_MatrixRAM_SIMadress(I+z+SFRcount))=true then
        begin //Зеленая дельта
        arrayPGpr[I].imgDelta.Picture:=mainform.imgGreenDelta.Picture;
        Set_MatrixRAM_delta(Get_MatrixRAM_SIMadress(I+z+SFRcount),false);
        Set_MatrixRAM_greenDelta(Get_MatrixRAM_SIMadress(I+z+SFRcount),true);
        end
        else
        begin //Красная дельта
        arrayPgpr[I].imgDelta.Picture:=mainform.imgRedDelta.Picture;
        Set_MatrixRAM_delta(Get_MatrixRAM_SIMadress(I+z+SFRcount),false);
        Set_MatrixRAM_greenDelta(Get_MatrixRAM_SIMadress(I+z+SFRcount),true);
        Set_MatrixRAM_ToClearDelta(Get_MatrixRAM_SIMadress(I+z+SFRcount),true);
       // if  (rtWithDelay or rtStepByStep) then    //Показ квадратов дельты только в режиме задержки или шаг за шагом
       //begin
        if Get_MatrixRAM_deltabit(Get_MatrixRAM_SIMadress(I+z+SFRcount),0) then
        begin
        arrayPgpr[I].bfBin[0].Delta:=true;
        Set_MatrixRAM_deltabit(Get_MatrixRAM_SIMadress(I+z+SFRcount),0,false);
        end;
        if Get_MatrixRAM_deltabit(Get_MatrixRAM_SIMadress(I+z+SFRcount),1) then
        begin
        arrayPgpr[I].bfBin[1].Delta:=true;
        Set_MatrixRAM_deltabit(Get_MatrixRAM_SIMadress(I+z+SFRcount),1,false);
        end;
        if Get_MatrixRAM_deltabit(Get_MatrixRAM_SIMadress(I+z+SFRcount),2) then
        begin
        arrayPgpr[I].bfBin[2].Delta:=true;
        Set_MatrixRAM_deltabit(Get_MatrixRAM_SIMadress(I+z+SFRcount),2,false);
        end;
        if Get_MatrixRAM_deltabit(Get_MatrixRAM_SIMadress(I+z+SFRcount),3) then
        begin
        arrayPgpr[I].bfBin[3].Delta:=true;
        Set_MatrixRAM_deltabit(Get_MatrixRAM_SIMadress(I+z+SFRcount),3,false);
        end;
        if Get_MatrixRAM_deltabit(Get_MatrixRAM_SIMadress(I+z+SFRcount),4) then
        begin
        arrayPgpr[I].bfBin[4].Delta:=true;
        Set_MatrixRAM_deltabit(Get_MatrixRAM_SIMadress(I+z+SFRcount),4,false);
        end;
        if Get_MatrixRAM_deltabit(Get_MatrixRAM_SIMadress(I+z+SFRcount),5) then
        begin
        arrayPgpr[I].bfBin[5].Delta:=true;
        Set_MatrixRAM_deltabit(Get_MatrixRAM_SIMadress(I+z+SFRcount),5,false);
        end;
        if Get_MatrixRAM_deltabit(Get_MatrixRAM_SIMadress(I+z+SFRcount),6) then
        begin
        arrayPgpr[I].bfBin[6].Delta:=true;
        Set_MatrixRAM_deltabit(Get_MatrixRAM_SIMadress(I+z+SFRcount),6,false);
        end;
        if Get_MatrixRAM_deltabit(Get_MatrixRAM_SIMadress(I+z+SFRcount),7) then
        begin
        arrayPgpr[I].bfBin[7].Delta:=true;
        Set_MatrixRAM_deltabit(Get_MatrixRAM_SIMadress(I+z+SFRcount),7,false);
        end;
        //end;
        end
    else
    arrayPgpr[I].imgDelta.Picture:=mainform.imgnil.Picture;
    arrayPgpr[I].bfBin[0].ReadOnl:=Get_MatrixRAM_usedbit(Get_MatrixRAM_SIMadress(I+z+SFRcount),0);
    arrayPgpr[I].bfBin[1].ReadOnl:=Get_MatrixRAM_usedbit(Get_MatrixRAM_SIMadress(I+z+SFRcount),1);
    arrayPgpr[I].bfBin[2].ReadOnl:=Get_MatrixRAM_usedbit(Get_MatrixRAM_SIMadress(I+z+SFRcount),2);
    arrayPgpr[I].bfBin[3].ReadOnl:=Get_MatrixRAM_usedbit(Get_MatrixRAM_SIMadress(I+z+SFRcount),3);
    arrayPgpr[I].bfBin[4].ReadOnl:=Get_MatrixRAM_usedbit(Get_MatrixRAM_SIMadress(I+z+SFRcount),4);
    arrayPgpr[I].bfBin[5].ReadOnl:=Get_MatrixRAM_usedbit(Get_MatrixRAM_SIMadress(I+z+SFRcount),5);
    arrayPgpr[I].bfBin[6].ReadOnl:=Get_MatrixRAM_usedbit(Get_MatrixRAM_SIMadress(I+z+SFRcount),6);
    arrayPgpr[I].bfBin[7].ReadOnl:=Get_MatrixRAM_usedbit(Get_MatrixRAM_SIMadress(I+z+SFRcount),7);
    arrayPgpr[I].bfBin[0].value:=Get_RAM(Get_MatrixRAM_SIMadress(I+z+SFRcount),0);
    arrayPgpr[I].bfBin[1].value:=Get_RAM(Get_MatrixRAM_SIMadress(I+z+SFRcount),1);
    arrayPgpr[I].bfBin[2].value:=Get_RAM(Get_MatrixRAM_SIMadress(I+z+SFRcount),2);
    arrayPgpr[I].bfBin[3].value:=Get_RAM(Get_MatrixRAM_SIMadress(I+z+SFRcount),3);
    arrayPgpr[I].bfBin[4].value:=Get_RAM(Get_MatrixRAM_SIMadress(I+z+SFRcount),4);
    arrayPgpr[I].bfBin[5].value:=Get_RAM(Get_MatrixRAM_SIMadress(I+z+SFRcount),5);
    arrayPgpr[I].bfBin[6].value:=Get_RAM(Get_MatrixRAM_SIMadress(I+z+SFRcount),6);
    arrayPgpr[I].bfBin[7].value:=Get_RAM(Get_MatrixRAM_SIMadress(I+z+SFRcount),7);

    arrayPgpr[I].bfBin[0].hint:=Get_MatrixRAM_bitname(Get_MatrixRAM_SIMadress(I+z+SFRcount),0);
    arrayPgpr[I].bfBin[1].hint:=Get_MatrixRAM_bitname(Get_MatrixRAM_SIMadress(I+z+SFRcount),1);
    arrayPgpr[I].bfBin[2].hint:=Get_MatrixRAM_bitname(Get_MatrixRAM_SIMadress(I+z+SFRcount),2);
    arrayPgpr[I].bfBin[3].hint:=Get_MatrixRAM_bitname(Get_MatrixRAM_SIMadress(I+z+SFRcount),3);
    arrayPgpr[I].bfBin[4].hint:=Get_MatrixRAM_bitname(Get_MatrixRAM_SIMadress(I+z+SFRcount),4);
    arrayPgpr[I].bfBin[5].hint:=Get_MatrixRAM_bitname(Get_MatrixRAM_SIMadress(I+z+SFRcount),5);
    arrayPgpr[I].bfBin[6].hint:=Get_MatrixRAM_bitname(Get_MatrixRAM_SIMadress(I+z+SFRcount),6);
    arrayPgpr[I].bfBin[7].hint:=Get_MatrixRAM_bitname(Get_MatrixRAM_SIMadress(I+z+SFRcount),7);

    arrayPgpr[I].bfBin[0].ByteAddres:=Get_MatrixRAM_SIMadress(I+z+SFRcount);
    arrayPgpr[I].bfBin[1].ByteAddres:=Get_MatrixRAM_SIMadress(I+z+SFRcount);
    arrayPgpr[I].bfBin[2].ByteAddres:=Get_MatrixRAM_SIMadress(I+z+SFRcount);
    arrayPgpr[I].bfBin[3].ByteAddres:=Get_MatrixRAM_SIMadress(I+z+SFRcount);
    arrayPgpr[I].bfBin[4].ByteAddres:=Get_MatrixRAM_SIMadress(I+z+SFRcount);
    arrayPgpr[I].bfBin[5].ByteAddres:=Get_MatrixRAM_SIMadress(I+z+SFRcount);
    arrayPgpr[I].bfBin[6].ByteAddres:=Get_MatrixRAM_SIMadress(I+z+SFRcount);
    arrayPgpr[I].bfBin[7].ByteAddres:=Get_MatrixRAM_SIMadress(I+z+SFRcount);

    arrayPgpr[I].bfBin[0].BitAddres:=0;
    arrayPgpr[I].bfBin[1].BitAddres:=1;
    arrayPgpr[I].bfBin[2].BitAddres:=2;
    arrayPgpr[I].bfBin[3].BitAddres:=3;
    arrayPgpr[I].bfBin[4].BitAddres:=4;
    arrayPgpr[I].bfBin[5].BitAddres:=5;
    arrayPgpr[I].bfBin[6].BitAddres:=6;
    arrayPgpr[I].bfBin[7].BitAddres:=7;
    //Брякпоинт
    arrayPgpr[I].imgBP.ByteAddres:=Get_MatrixRAM_SIMadress(I+z+SFRcount);

    arrayPgpr[I].imgBP.BPDelta:=Get_MatrixRAM_BreakPoint(Get_MatrixRAM_SIMadress(I+z+SFRcount));
    arrayPgpr[I].imgBP.BPGreenDelta:=Get_MatrixRAM_GreenBP(Get_MatrixRAM_SIMadress(I+z+SFRcount));

    application.ProcessMessages;

    //Показ комманд - в другую процедуру
  CurrentToParCommand();
    mainform.txtLast.Text:=GetInstruction();
    if gI>=(Get_ROM_Size-1)  then tmp:=0 else tmp:=gI;

    RomToParCommand(tmp);

    mainform.txtNext.Text:=GetInstruction();
    end;

    application.ProcessMessages;



//Показ счетчиков - в другую процедуру
    StC:=Get_StackCounter();
    mainform.txtIC.Text:=InttoStr(Get_IC());
    Get_MCandCF(vMC,vCF);
    mainform.txtMC.Text:=inttostr(vMC);
    //Port! - уже нет
    cf:=vCF;
    cf:=cf div 4;
    mainform.txtRT.Text:=FloatToStrF( (vMC/cf), ffFixed,12,7)+' '+ GetText(2020);
    mainform.txtUserTimer.Text:=FloatToStrF( (vMC/cf)-get_UserTimer(),ffFixed,12,7)+' '+ GetText(2020);
    //Панель стека
    //PC
     vPc:=Get_PC();
     for z := Low(PC) to High(PC) do PC[z].value:=vPC[z];

     //Hex-addr
      for tI := 0 to 8 do par[tI]:=false;
      for tI := 8 to High(PC) do par[tI-8]:=vPc[tI];
      txtPCHex.Text:= BinToHex();
      par[0]:=vPc[0];
      par[1]:=vPc[1];
      par[2]:=vPc[2];
      par[3]:=vPc[3];
      par[4]:=vPc[4];
      par[5]:=vPc[5];
      par[6]:=vPc[6];
      par[7]:=vPc[7];
      par[8]:=false;
      txtPCHex.Text:=txtPCHex.Text+ BinToHex();
    //Счетчик стека
    MainForm.txtStackCounter.Text:=IntToStr(StC);
    //содержимое стека
    for z := 1 to StC do
      begin
      vSt:=Get_stack(z-1);
      for tI := low(arrayPStack[z-1].bfBin) to High(arrayPStack[z-1].bfBin) do
       arrayPStack[z-1].bfBin[tI].value:=vSt[tI];

       //Hex-addr
      for tI := 0 to 8 do par[tI]:=false;
      for tI := 8 to High(arrayPStack[z-1].bfBin) do par[tI-8]:=vSt[tI];
      arrayPStack[z-1].edtHex.Text:= BinToHex();
      par[0]:=vSt[0];
      par[1]:=vSt[1];
      par[2]:=vSt[2];
      par[3]:=vSt[3];
      par[4]:=vSt[4];
      par[5]:=vSt[5];
      par[6]:=vSt[6];
      par[7]:=vSt[7];
      par[8]:=false;
      arrayPStack[z-1].edtHex.Text:=arrayPStack[z-1].edtHex.Text+ BinToHex();
      end;

    //Таймер WDT
    Get_TaktsWDT(valTaktsWDT,valrtTaktsWDT);
    Mainform.prgWDT.Progress:= trunc(valTaktsWDT);
    Mainform.prgWDT.MaxValue:=trunc(valrtTaktsWDT);

    //Чтобы не обновляло тысячу раз
    Set_rtRefreshComplete(true);

    application.ProcessMessages;
    EndRefresh:=true;


end;
procedure RedrawPSFR();
var i,j, NewNumberOfRows:integer;
SFRCount:word;
const SpSF=70; //Стартовая, начальная позиция для группы из 8 флажков и Shape
begin
SFRCount:=Get_SFRCount();
//Вычисляем, сколько должно быть колонок по длине
NewNumberOfRows:=mainform.pnlSFR.height div 21 -2 ;
//Если по длине колонок может быть больше, чем всего SFR то уменьшить соответственно
if NewNumberOfRows>SFRCount then NewNumberOfRows:=SFRCount;

if NumberOfRowsinsfr<NewNumberofrows then //Надо создать новые элементы
  begin
  Setlength(arrayPSfr,NewNumberOfRows+1);
  for I := NumberOfRowsinSFR to NewNumberOfRows-1 do
    begin
    //Создадим Image слева с брейкпоинтом
    arrayPSfr[I].imgBP:=TDeltaBreakPoint.Create(Application);
    arrayPSfr[I].imgBP.parent:=mainform.pnlSFR;
    arrayPSfr[I].imgBP.Width:=11;
    arrayPSfr[I].imgBP.Height:=20;
    arrayPSfr[I].imgBP.Left:=0;
    arrayPSfr[I].imgBP.Top:=i*21+40;
    arrayPSfr[I].imgBP.Center:=true;
    arrayPSfr[I].imgBP.OnClick:=mainform.BpSFRclick;
    arrayPSfr[I].imgBP.Transparent:=true;
    arrayPSfr[I].imgBP.Hint:=Gettext(2025);
    //Создатим текстовое поле с адресом
    arrayPSfr[I].edtAddr:=TEdit.Create(Application);
    arrayPSfr[I].edtAddr.Parent:=mainform.pnlSFR;
    arrayPSfr[I].edtAddr.Width:=28;
    arrayPSfr[I].edtAddr.Height:=20;
    arrayPSfr[I].edtAddr.Left:=12;
    arrayPSfr[I].edtAddr.Top:=i*21+40;
    arrayPSfr[I].edtAddr.ReadOnly:=true;
    //Создадим текстовое поле с именем
    arrayPSfr[I].edtName:=TEdit.Create(Application);
    arrayPSfr[I].edtName.Parent:=mainform.pnlSFR;
    arrayPSfr[I].edtName.Width:=65;
    arrayPSfr[I].edtName.Height:=20;
    arrayPSfr[I].edtName.Left:=40;
    arrayPSfr[I].edtName.Top:=i*21+40;
    arrayPSfr[I].edtName.ReadOnly:=true;
      //Создадим текстовое поле с HEX-значением
    arrayPSfr[I].edtHEX:=TEdit.Create(Application);
    arrayPSfr[I].edtHEX.Parent:=mainform.pnlSFR;
    arrayPSfr[I].edtHEX.Width:=20;
    arrayPSfr[I].edtHEX.Height:=20;
    arrayPSfr[I].edtHEX.Left:=105;
    arrayPSfr[I].edtHEX.Top:=i*21+40;
    arrayPSfr[I].edtHEX.ReadOnly:=true;
    //Создадим флажки и фигуры для Bin-поля
    for j := 0 to 3 do
      begin //Флажки LOW
        arrayPSfr[I].bfBin[j]:=TBinaryFlag.Create(Application);
        arrayPSfr[I].bfBin[j].Parent:=mainform.pnlSFR;
        arrayPSfr[I].bfBin[j].Width:=10;
        arrayPSfr[I].bfBin[j].Height:=10;
        arrayPSfr[I].bfBin[j].Left:=155-(J*10);
        arrayPSfr[I].bfBin[j].Top:=i*21+50;
        arrayPSfr[I].bfBin[j].ShowHint:=true;
        arrayPSfr[I].bfBin[j].Delta:=false;
        arrayPSfr[I].bfBin[j].OnClick:=mainform.BfSFRclick;
        //Флажки HI
        arrayPSfr[I].bfBin[j+4]:=TBinaryFlag.Create(Application);
        arrayPSfr[I].bfBin[j+4].Parent:=mainform.pnlSFR;
        arrayPSfr[I].bfBin[j+4].Width:=10;
        arrayPSfr[I].bfBin[j+4].Height:=10;
        arrayPSfr[I].bfBin[j+4].Left:=155-(J*10);
        arrayPSfr[I].bfBin[j+4].Top:=i*21+40;
        arrayPSfr[I].bfBin[j+4].ShowHint:=true;
        arrayPSfr[I].bfBin[j+4].Delta:=false;
        arrayPSfr[I].bfBin[j+4].OnClick:=mainform.BfSFRclick;


      end;
     //Создадим имадже с дельтой
      arrayPSfr[I].imgDelta:=TImage.Create(Application);
      arrayPSfr[I].imgDelta.parent:=mainform.pnlSFR;
      arrayPSfr[I].imgDelta.Width:=11;
      arrayPSfr[I].imgDelta.Height:=20;
      arrayPSfr[I].imgDelta.Left:=165;
      arrayPSfr[I].imgDelta.Top:=i*21+40;
      arrayPSfr[I].imgDelta.Center:=true;


      arrayPSfr[I].imgDelta.Hint:=GetText(2026);

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
    for j := 0 to 7 do  arrayPSfr[I].bfbin[j].Destroy;
     //Удалим дельту
    arrayPSfr[I].imgDelta.Destroy;
    end;

  Setlength(arrayPSfr,NewNumberOfRows+1);
  end;

NumberOfRowsinsfr:=NewNumberofrows;
//Настройка скроллера
mainform.scrlSFR.Max:=sfrcount-NumberOfRowsinsfr;
if NumberOfRowsinsfr<>0 then mainform.scrlSFR.LargeChange:=NumberOfRowsinsfr;
end;

procedure RedrawPGPR();
var i,j, NewNumberOfRows:integer;
GPRCount:integer;
const SpSF=70; //Стартовая, начальная позиция для группы из 8 флажков и Shape
begin
GPRCount:=Get_GPRCount();
//Вычисляем, сколько должно быть колонок по длине
NewNumberOfRows:=mainform.pnlGPR.height div 21 -2 ;
//Если по длине колонок может быть больше, чем всего gpr то уменьшить соответственно
if NewNumberOfRows>GPRCount then NewNumberOfRows:=GPRCount;

if NumberOfRowsinGPR<NewNumberofrows then //Надо создать новые элементы
  begin
  Setlength(arrayPGPR,NewNumberOfRows+1);
  for I := NumberOfRowsinGPR to NewNumberOfRows-1 do
    begin
    //Создадим Image слева с брейкпоинтом
    arrayPGPR[I].imgBP:=TDeltaBreakPoint.Create(Application);
    arrayPGPR[I].imgBP.parent:=mainform.pnlGPR;
    arrayPGPR[I].imgBP.Width:=11;
    arrayPGPR[I].imgBP.Height:=20;
    arrayPGPR[I].imgBP.Left:=0;
    arrayPGPR[I].imgBP.Top:=i*21+40;
    arrayPGPR[I].imgBP.Center:=true;
    arrayPGPR[I].imgBP.OnClick:=mainform.BpGPRclick;
    arrayPGPR[I].imgBP.Transparent:=true;
    arrayPGPR[I].imgBP.Hint:=GetText(2025);
    //Создатим текстовое поле с адресом
    arrayPGPR[I].edtAddr:=TEdit.Create(Application);
    arrayPGPR[I].edtAddr.Parent:=mainform.pnlGPR;
    arrayPGPR[I].edtAddr.Width:=28;
    arrayPGPR[I].edtAddr.Height:=20;
    arrayPGPR[I].edtAddr.Left:=12;
    arrayPGPR[I].edtAddr.Top:=i*21+40;
    arrayPGPR[I].edtAddr.ReadOnly:=true;
    //Создадим текстовое поле с именем
    arrayPGPR[I].edtName:=TEdit.Create(Application);
    arrayPGPR[I].edtName.Parent:=mainform.pnlGPR;
    arrayPGPR[I].edtName.Width:=65;
    arrayPGPR[I].edtName.Height:=20;
    arrayPGPR[I].edtName.Left:=40;
    arrayPGPR[I].edtName.Top:=i*21+40;
    arrayPGPR[I].edtName.ReadOnly:=true;
      //Создадим текстовое поле с HEX-значением
    arrayPGPR[I].edtHEX:=TEdit.Create(Application);
    arrayPGPR[I].edtHEX.Parent:=mainform.pnlGPR;
    arrayPGPR[I].edtHEX.Width:=20;
    arrayPGPR[I].edtHEX.Height:=20;
    arrayPGPR[I].edtHEX.Left:=105;
    arrayPGPR[I].edtHEX.Top:=i*21+40;
    arrayPGPR[I].edtHEX.ReadOnly:=true;
    //Создадим флажки и фигуры для Bin-поля
    for j := 0 to 3 do
      begin //Флажки LOW
        arrayPGPR[I].bfBin[j]:=TBinaryFlag.Create(Application);
        arrayPGPR[I].bfBin[j].Parent:=mainform.pnlGPR;
        arrayPGPR[I].bfBin[j].Width:=10;
        arrayPGPR[I].bfBin[j].Height:=10;
        arrayPGPR[I].bfBin[j].Left:=155-(J*10);
        arrayPGPR[I].bfBin[j].Top:=i*21+50;
        arrayPGPR[I].bfBin[j].ShowHint:=true;
        arrayPGPR[I].bfBin[j].Delta:=false;
        arrayPGPR[I].bfBin[j].OnClick:=mainform.BfGPRclick;
        //Флажки HI
        arrayPGPR[I].bfBin[j+4]:=TBinaryFlag.Create(Application);
        arrayPGPR[I].bfBin[j+4].Parent:=mainform.pnlGPR;
        arrayPGPR[I].bfBin[j+4].Width:=10;
        arrayPGPR[I].bfBin[j+4].Height:=10;
        arrayPGPR[I].bfBin[j+4].Left:=155-(J*10);
        arrayPGPR[I].bfBin[j+4].Top:=i*21+40;
        arrayPGPR[I].bfBin[j+4].ShowHint:=true;
        arrayPGPR[I].bfBin[j+4].Delta:=false;
        arrayPGPR[I].bfBin[j+4].OnClick:=mainform.BfGPRclick;


      end;
     //Создадим имадже с дельтой
      arrayPGPR[I].imgDelta:=TImage.Create(Application);
      arrayPGPR[I].imgDelta.parent:=mainform.pnlGPR;
      arrayPGPR[I].imgDelta.Width:=11;
      arrayPGPR[I].imgDelta.Height:=20;
      arrayPGPR[I].imgDelta.Left:=165;
      arrayPGPR[I].imgDelta.Top:=i*21+40;
      arrayPGPR[I].imgDelta.Center:=true;


      arrayPGPR[I].imgDelta.Hint:=GetText(2026);

    end;
  end;

if NumberOfRowsinGPR>NewNumberofrows then //Надо удалить лишние элементы
  begin

  for I := NewNumberOfRows  to NumberOfRowsinGPR-1 do
    begin
    //Удалим Имадже с брейкпойнтом
    arrayPGPR[I].imgBP.Destroy;
    //удалим текстовое поле с адресом
    arrayPGPR[I].edtAddr.Destroy;
    //удалим текстовое поле с именем
    arrayPGPR[I].edtName.Destroy;
    //удалим текстовое поле с HEX
    arrayPGPR[I].edtHEX.Destroy;
    //удалим Bin поле
    for j := 0 to 7 do  arrayPGPR[I].bfbin[j].Destroy;
     //Удалим дельту
    arrayPGPR[I].imgDelta.Destroy;
    end;

  Setlength(arrayPGPR,NewNumberOfRows+1);
  end;

NumberOfRowsinGPR:=NewNumberofrows;
//Настройка скроллера
mainform.scrlGPR.Max:=gprcount-NumberOfRowsingpr;
if NumberOfRowsinsfr<>0 then mainform.scrlgpR.LargeChange:=NumberOfRowsingpr;
end;
procedure RedrawPStack();
var J,Z:integer;
stMax,pcMax:integer;
const FirstLeft=1; //Самая левая начальная точка на панели
const FirstTop=87; //Самая верхняя точка на панели
const FirstRight=163;

begin
//PC
pcMax:=Get_PC_Len();
SetLength(PC,pcMax);
for Z := pcMax-1 downto 0 do
  begin
    PC[Z].Free;
    PC[Z]:=TBinaryFlag.Create(Application);
    PC[Z].Parent:=mainform.pnlStack;
    PC[Z].Width:=10;
    PC[Z].Height:=10;
    PC[Z].Top:=mainform.txtPChex.top+5;
    PC[Z].Left:=FirstRight-(z*10);
    PC[Z].ShowHint:=true;
    PC[Z].Hint:=inttostr(Z);
    PC[Z].Delta:=false;
    PC[Z].Enabled:=false;
  end;
//Stack
stMax:=Get_StackMax();
 //if (NumberOfRowsInStack<stMax) and (NumberOfRowsInStack<=5) then
  begin //Ноебходимо создать новые строки
  NumberOfRowsInStack:=stMax;
  Setlength(arrayPStack,NumberOfRowsInStack+1);

  for Z := 0 to stMax  do
    begin
    //Создатим текстовое поле с уровнем
    arrayPStack[Z].edtLvl.Free;
    arrayPStack[Z].edtLvl:=TEdit.Create(Application);
    arrayPStack[Z].edtLvl.Parent:=mainform.pnlStack;
    arrayPStack[Z].edtLvl.Width:=19;
    arrayPStack[Z].edtLvl.Height:=20;
    arrayPStack[Z].edtLvl.Left:=FirstLeft;
    arrayPStack[Z].edtLvl.Top:=Z*21+FirstTop;
    arrayPStack[Z].edtLvl.ReadOnly:=true;
    arrayPStack[Z].edtLvl.Text:=inttostr(Z+1);

    //Создадим текстовое поле с HEX-значением
    arrayPStack[Z].edtHex.Free;
    arrayPStack[Z].edtHEX:=TEdit.Create(Application);
    arrayPStack[Z].edtHEX.Parent:=mainform.pnlStack;
    arrayPStack[Z].edtHEX.Width:=mainform.txtpchex.width;
    arrayPStack[Z].edtHEX.Height:=20;
    arrayPStack[Z].edtHEX.Left:=FirstLeft+20;
    arrayPStack[Z].edtHEX.Top:=Z*21+FirstTop;
    arrayPStack[Z].edtHEX.ReadOnly:=true;
    //Создадим флажки и фигуры для Bin-поля
    SetLength(arrayPStack[Z].bfBin,pcMax);
    for j := 0 to pcMax-1 do
      begin //Флажки
        arrayPStack[Z].bfBin[j].Free;
        arrayPStack[Z].bfBin[j]:=TBinaryFlag.Create(Application);
        arrayPStack[Z].bfBin[j].Parent:=mainform.pnlStack;
        arrayPStack[Z].bfBin[j].Width:=10;
        arrayPStack[Z].bfBin[j].Height:=10;
        arrayPStack[Z].bfBin[j].Left:=FirstRight-(J*10);
        arrayPStack[Z].bfBin[j].Top:=Z*21+FirstTop+5;
        arrayPStack[Z].bfBin[j].Hint:=inttostr(j);
        arrayPStack[Z].bfBin[j].ShowHint:=true;
        arrayPStack[Z].bfBin[j].Delta:=false;
        arrayPStack[Z].bfBin[j].Enabled:=false;
      end;

    end;



  end;


end;
procedure UncheckMKinMenu();
begin
//Снять все флажки с типа мк
//mainform.PIC10F2001.Checked:=false;

end;
Procedure SetRate(ModeNO:integer);
var tmppause:boolean;
begin
//Снимим все галки с меню
mainform.mnuStepByStep.Checked:=false;
mainform.mnuVerySlow.Checked:=false;
mainform.mnuSlow.Checked:=false;
mainform.mnuNormal.Checked:=false;
mainform.mnuFast.Checked:=false;
mainform.mnuVeryfast.Checked:=false;
mainform.mnuRealTime.Checked:=false;
mainform.mnuX2.Checked:=false;
mainform.mnuUltimate.Checked:=false;

// Поставим паузу
tmppause:=Get_rtPause();
Set_rtPause(false);

// Выбор режима
case ModeNO of
//Step-by-step
0:  begin
    //Поставим нужную
    mainform.mnuStepByStep.Checked:=true;
    //Изменяем параметры
    Set_RT_parametrs(false,true,false,100,1);
    {pic10f.rtWithDelay:=false;
    pic10f.rtWithSyncro:=false;
    pic10f.rtStepByStep:=true;
    pic10f.rtexStep:=false;}

    end;
// Very slow
1:  begin
    //Поставим нужную
    mainform.mnuveryslow.Checked:=true;
    //Изменяем параметры
    Set_RT_parametrs(false,false,true,2000,1);
    {pic10f.rtWithSyncro:=false;
    pic10f.rtStepByStep:=false;
    pic10f.rtDelayMS:=2000;
    pic10f.rtWithDelay:=true;}

    end;
//  slow
2:  begin
    //Поставим нужную
    mainform.mnuslow.Checked:=true;
    //Изменяем параметры
    Set_RT_parametrs(false,false,true,1000,1);
    {
    pic10f.rtWithSyncro:=false;
    pic10f.rtStepByStep:=false;
    pic10f.rtDelayMS:=1000;
    pic10f.rtWithDelay:=true;    }
    end;
// Normal
3:  begin
    //Поставим нужную
    mainform.mnunormal.Checked:=true;
    //Изменяем параметры
    Set_RT_parametrs(false,false,true,500,1);
    {pic10f.rtWithSyncro:=false;
    pic10f.rtStepByStep:=false;
    pic10f.rtDelayMS:=500;
    pic10f.rtWithDelay:=true; }
    end;
// Fast
4:  begin
    //Поставим нужную
    mainform.mnufast.Checked:=true;
    //Изменяем параметры
    Set_RT_parametrs(false,false,true,100,1);
    {pic10f.rtWithSyncro:=false;
    pic10f.rtStepByStep:=false;
    pic10f.rtDelayMS:=100;
    pic10f.rtWithDelay:=true;}
    //Set_rtRefreshComplete(true);
    end;
// Very fast
5:  begin
    //Поставим нужную
    mainform.mnuveryfast.Checked:=true;
    //Изменяем параметры
    Set_RT_parametrs(false,false,true,10,1);

    {pic10f.rtWithSyncro:=false;
    pic10f.rtStepByStep:=false;
    pic10f.rtDelayMS:=10;
    pic10f.rtWithDelay:=true;  }
    end;
// RealTime
100:  begin
    //Поставим нужную
    mainform.mnurealtime.Checked:=true;
    //Изменяем параметры
    Set_RT_parametrs(true,false,false,1000,1);
    {
    pic10f.rtStepByStep:=false;
    pic10f.rtWithDelay:=false;
    pic10f.rtSyncro:=1;
    pic10f.rtWithSyncro:=true;  }

    end;
// X2
200:  begin
        //Поставим нужную
    mainform.mnux2.Checked:=true;
    //Изменяем параметры
    Set_RT_parametrs(true,false,false,1000,2);

    {pic10f.rtStepByStep:=false;
    pic10f.rtWithDelay:=false;
    pic10f.rtSyncro:=2;
    pic10f.rtWithSyncro:=true;}
    end;
// Ultimate
else begin
    //Поставим нужную
    mainform.mnuultimate.Checked:=true;
    //Изменяем параметры
    Set_RT_parametrs(false,false,false,1000,1);
    {pic10f.rtStepByStep:=false;
    pic10f.rtWithDelay:=false;
    pic10f.rtWithSyncro:=false; }
    end;

end;
// Снимим, если нужно паузу
Set_rtPause(true); //добавлены 3 строки (с этой) 4.02.2015 криво, но нужно чтобы избежать ошибки 15 из синего ту-ду
sleep(10);
application.ProcessMessages;
Set_rtPause(tmppause);
end;


procedure TMainForm.CreateMDIChild(const Name: string;TypeCall:Byte);
var
   ext:string;

label lblZanovo;
begin
lblZanovo:
 if AsmWindowOpen=false then
begin
exchange:=false;
if (TypeCall<>1) and (not FileExists(Name)) then exit;


 // if FileExists(Name) then Child.txt.Lines.LoadFromFile(Name);

 frmopen.frmopn.TypeOfCall:=1;
 if TypeCall<>1 then
 begin
    ext:=AnsiUpperCase(copy(OpenDialog.FileName,length(OpenDialog.FileName)-3,4));
      if ext='.HEX' then
        begin
        frmopen.frmopn.TypeOfCall:=3;
        frmopn.NameOfImportFile:=OpenDialog.FileName;
        end;
      if ext='.ASM' then
        begin
         frmopen.frmopn.TypeOfCall:=2;
         frmopn.NameOfImportFile:=OpenDialog.FileName;
        end;
     if frmopen.frmopn.TypeOfCall=1 then
       if length(OpenDialog.FileName)>6 then
         begin
         ext:=AnsiUpperCase(copy(OpenDialog.FileName,length(OpenDialog.FileName)-5,6));
         if ext='.ATCSS' then
            begin
            //frmopen.frmopn.TypeOfCall:=3;
            //frmopn.NameOfImportFile:=OpenDialog.FileName;
            if not LoadATCSS(OpenDialog.FileName) then showmessage(GetText(1010));
            FormatAndSyntRVE();
            {frmopen.frmopn.TypeOfCall:=1;
         frmopn.NameOfImportFile:=OpenDialog.FileName;
         frmOpen.frmopn.ShowModal;} //добавил 10.11.2014 но лучше было бы без него
         application.ProcessMessages;
EndRefresh:=true;
main.MainForm.ShowAllRegAndCounters;
            exit;
            end;
         end;

 end;

frmOpen.frmopn.ShowModal;




end
else
  begin

MustClose:=true;
FileClose1.Execute;
if not MustClose then exit;

    goto lblZanovo;
  end;

end;



procedure TMainForm.FileNew1Execute(Sender: TObject);
begin

   CreateMDIChild('',1);
end;

procedure TMainForm.FileOpen1Execute(Sender: TObject);
begin
  if OpenDialog.Execute then CreateMDIChild(OpenDialog.FileName,2);

end;

procedure TMainForm.FileSave1Execute(Sender: TObject);
begin
prjSaved:=false;
IF ProjectFileName<>'' THEN
prjSaved:=SaveATCSS(ProjectFileName) ELSE FileSaveAs1Execute(Sender) ;
if prjSaved then
begin
Main.MainForm.Caption:=unitRes.GetText(1)+' - ['+ProjectFileName+']';
statusbar.SimpleText  :=GetText(2027);
end;
end;

procedure TMainForm.FileSave1Update(Sender: TObject);
begin
filesave1.Enabled:=AsmWindowOpen;
end;

procedure TMainForm.FileSaveAs1Execute(Sender: TObject);
begin
 BEGIN
 prjSaved:=false;
  if NOT SD.Execute() then EXIT;
  ProjectFileName:=sd.FileName;
  prjSaved:=SaveATCSS(ProjectFileName);
  END;
Main.MainForm.Caption:=unitRes.GetText(1)+' - ['+ProjectFileName+']';
statusbar.SimpleText  :=GetText(2027);
end;

procedure TMainForm.FileSaveAs1Update(Sender: TObject);
begin
filesaveas1.Enabled:=AsmWindowOpen;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin


formLoad:=false;
application.ProcessMessages;
StopSimulation();
{application.ProcessMessages;
EndRefresh:=false;
application.ProcessMessages;
tmrRefresh.enabled:=false;
application.ProcessMessages;
EndRefresh:=false;
application.ProcessMessages;
//endrefresh:=true;
tmrrts.Destroy;
tmrrefresh.Destroy;
asmchild.TmrRefresh.Destroy;
frmcheckupdates.formCheckUpdates.tmrCanShow.Destroy;

{TmrRTS.Enabled:=false;
tmrRefresh.enabled:=false;
asmchild.TmrRefresh.Enabled:=false;}
//endrefresh:=true;
{application.ProcessMessages;
sleep(400);
application.ProcessMessages;    }
//StopSimulation();
//application.ProcessMessages;



//co.Destroy;
//tr.Destroy;





end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
MustClose:=true;
FileClose1.Execute;
if not MustClose then canClose:=false else canClose:=true;

end;

procedure TMainForm.FormCreate(Sender: TObject);

begin
bmpSFR:=vcl.graphics.TBitmap.Create;
bmpGPR:=vcl.graphics.TBitmap.Create;
bmpStack:=vcl.graphics.TBitmap.Create;
 unitres.ApplyLangToMainForm();

formLoad:=true;
MCULibLoaded:=false;


//Начальная инициализация переменных
NumberOfRowsinSFR:=0;  //Количество строк в графе SFR
//Начальное отключение панелей
pnlSFR.Visible:=false;



end;



procedure TMainForm.FormDestroy(Sender: TObject);
begin
FreeLibrary(ELibHandle);
end;

procedure TMainForm.FormResize(Sender: TObject);
begin

if formLoad=false then exit; //Когда форма закрыта, процедура не актуальна - выйти, чтобы избежать ошибок
//Ресайз тулбара
toolbar2.Width:=mainform.Width;

//Ресайз панели счетчиков
pnlCounters.Left:=0;
pnlCounters.Top:=toolbar2.Height;
//Ресайз панели sfr
pnlSFR.Top:=PnlCounters.Top+pnlCounters.Height;
pnlSFR.Height:=Mainform.ClientHeight-pnlCounters.Height-toolbar2.Height-statusbar.Height;
scrlSFR.Height:=pnlSFR.Height-50;
//Ресайз панели стека
pnlStack.Left:=pnlsfr.Width+pnlsfr.Left;
pnlstack.Top:=toolbar2.Height;
//Ресайз панели GPR
pnlGPR.Top:=pnlstack.Top+pnlstack.Height;
pnlGPR.Height:=Mainform.ClientHeight-pnlStack.Height-toolbar2.Height-statusbar.Height;
pnlGPR.Left:=pnlSFR.Width+pnlSFR.Left;
scrlGPR.Height:=pnlGPR.Height-50;
// Перерисовать панель SFR
if MCULibLoaded then RedrawPSFR;
pnlSFR.Visible:=true;
// Перерисовать панель GPR
if MCULibLoaded then RedrawPGPR;
pnlGPR.Visible:=true;
//Перерисовать панель Stack
if MCULibLoaded then RedrawPStack;
//Присвоить значения полей
if MCULibLoaded then ShowAllRegAndCounters();



//Присвоить значения полей
//ShowNameAddrGPR();
//Ресайз статус бара
StatusBar.Width:=mainform.Width;
StatusBar.Top:=mainform.clientHeight-statusbar.Height;
end;

procedure TMainForm.HelpAbout1Execute(Sender: TObject);
begin
  AboutBox.ShowModal;
end;



procedure TMainForm.HelpDonateItemClick(Sender: TObject);
begin
ShellExecute(handle,'open','http://at-control.com/donate.html',nil,nil,SW_SHOWNORMAL);
end;

procedure TMainForm.iHelpChkUpdItemClick(Sender: TObject);
begin
formCheckUpdates.Show;
end;

procedure TMainForm.mnuConfigBitsClick(Sender: TObject);
begin
Devices[0].ShowSettings;

end;

procedure TMainForm.mnuFastClick(Sender: TObject);
begin
SetRate(4);
end;

procedure TMainForm.mnuNormalClick(Sender: TObject);
begin
SetRate(3);
end;

procedure TMainForm.mnuRealTimeClick(Sender: TObject);
begin
SetRate(100);
//Снимим со всех галки


end;

procedure TMainForm.mnuSlowClick(Sender: TObject);
begin
SetRate(2);
end;

procedure TMainForm.mnuStepByStepClick(Sender: TObject);
begin

SetRate(0);


end;

procedure TMainForm.mnuUltimateClick(Sender: TObject);
begin

SetRate(255);

end;

procedure TMainForm.mnuVeryfastClick(Sender: TObject);
begin
SetRate(5);
end;

procedure TMainForm.mnuVerySlowClick(Sender: TObject);
begin

SetRate(1);

end;

procedure TMainForm.mnuX2Click(Sender: TObject);
begin
SetRate(200);
end;

procedure TMainForm.OptionConfigBits1Update(Sender: TObject);
begin
OptionConfigBits1.Enabled:=AsmWindowOpen;
end;

procedure TMainForm.PIC10F2001Click(Sender: TObject);
begin
{UncheckMKinMenu();
PIC10F2001.Checked:=true;
SelectMC(0);
RedrawPSFR;
RedrawPGPR;
ShowAllRegAndCounters; }
end;

procedure TMainForm.scrlGPRChange(Sender: TObject);
var i :integer;
begin
//RedrawPGPR;

//Добавил 11.08.2015 с целью, чтобы при скроллинге очищалась дельта (квадратиком)
//А то, при скролле дельта оказывалась на другой ячейке памяти
  for I := 0 to NumberOfRowsingpr-1 do
  begin
  application.ProcessMessages;
  //Очистить дельту

        arrayPgpr[I].bfBin[0].Delta:=false;
        arrayPgpr[I].bfBin[1].Delta:=false;
        arrayPgpr[I].bfBin[2].Delta:=false;
        arrayPgpr[I].bfBin[3].Delta:=false;
        arrayPgpr[I].bfBin[4].Delta:=false;
        arrayPgpr[I].bfBin[5].Delta:=false;
        arrayPgpr[I].bfBin[6].Delta:=false;
        arrayPgpr[I].bfBin[7].Delta:=false;
      end;
ShowAllRegAndCounters;
end;

procedure TMainForm.scrlGPRScroll(Sender: TObject; ScrollCode: TScrollCode;
  var ScrollPos: Integer);
var tmpScrlPOS:integer;
begin
//Этот мега-костыль нужен для того, чтобы дельта в квадратике тухла при прокрутке
{if GPRScrollPos<>ScrollPos then
begin
tmpScrlPOS:=ScrollPos;
ScrollPos:=GPRScrollPos;
end;
ShowAllRegAndCounters;
GPRScrollPos:=ScrollPos;
ScrollPos:=tmpScrlPOS;

 }
end;

procedure TMainForm.scrlSFRChange(Sender: TObject);
var I:integer;
begin
//Добавил 11.08.2015 по аналогии. см. scrlGPRChange
  for I := 0 to NumberOfRowsinsfr-1 do
  begin
  application.ProcessMessages;
  //Очистить дельту

        arrayPsfr[I].bfBin[0].Delta:=false;
        arrayPsfr[I].bfBin[1].Delta:=false;
        arrayPsfr[I].bfBin[2].Delta:=false;
        arrayPsfr[I].bfBin[3].Delta:=false;
        arrayPsfr[I].bfBin[4].Delta:=false;
        arrayPsfr[I].bfBin[5].Delta:=false;
        arrayPsfr[I].bfBin[6].Delta:=false;
        arrayPsfr[I].bfBin[7].Delta:=false;
      end;
 ShowAllRegAndCounters;
end;

procedure TMainForm.tlbPauseClick(Sender: TObject);
begin
  set_rtPause(true);
 actionpause.Enabled:=false;
 actionrun.Enabled:=true;

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
var
WSb,SbSb,WDb:boolean;
DmsI:integer;
SR:real;
label ll;
begin
mainform.TmrRTS.enabled:=true;
EndRefresh:=true;
//При паузе
if get_rtPause=true then
  begin
    set_rtPause(false);
    //actionrun.Enabled:=false;
    //actionpause.Enabled:=true;
    exit;
  end;
//При запуске, требующем компиляцию
if AsmWindowOpen then
begin
// mainform.statusbar.panels[1].text:='compiling...';
 application.processmessages;
 asmchild.autoCheck:=false;
 if AsmChild.compileAll then
  begin //Компиляция прошла успешно
//    mainform.statusbar.panels[0].text:='compilation completed.';
     application.processmessages;
     asmchild.autoCheck:=true;
  end
 else
  begin //Компиляция провалена
//    mainform.statusbar.panels[0].text:='compilation failed.';
     application.processmessages;
     asmchild.autoCheck:=true;
    exit;
  end;
end;
//При простом запуске;

//Определим кол-во тактов CPU в такте МК и запустим МК
Calculate_CuclPerCycMK_AndRun(@stopsimulation,Devices);
//Если шаг за шагом, то "нажать" шаг
application.ProcessMessages;
Get_RT_parametrs(WSb,SbSb,WDb,DmsI,SR);
if SbSb  then
begin
//Set_rtexStep(true);
Set_rtRefreshComplete(true);
application.ProcessMessages;
sleep (10);
ShowAllRegAndCounters();
end;
//Set_rtexStep(true);
//Запустим обновление Component Editor
CompChild.RunRefresh();

actionrun.Enabled:=false;
//создание потока обновления панелей
{tr:=theadRefresh.TRun.Create(true);
tr.Resume;
tr.Priority:=tpNormal;}
tmrRefresh.Enabled:=true;

actionstop.Enabled:=true;

end;

procedure TMainForm.FileClose1Execute(Sender: TObject);
label
lblNext;
begin
if exchange=true then
begin //Были сделаны какие-то изменения
     case MessageDlg(GetText(1100),mtConfirmation,[mbYes,mbno,mbCancel],0 ) of
     mrYes:
     begin
     FileSave1.Execute;
     if not prjSaved then mustClose:=false;
     exit;
     end;
     mrNo: goto lblNext;
     mrCancel:
     begin
     MustClose:=false;
     exit;
     end;

     end;

end;

lblNext:
stopsimulation();

unitdev.Reset();
 AsmWindowOpen:=false; //Открытое окно ассемблера
    AsmChild.Free; //Окно ассемблера
    CompChild.Free; //Окно конструктора
    ProjectFileName:=''; //имя файла-проекта)
    //if asmchild.FreeOnRelease then
 exchange:=false;

end;

procedure TMainForm.FileClose1Update(Sender: TObject);
begin
fileclose1.Enabled:=AsmWindowOpen;
end;

procedure TMainForm.FileExit1Execute(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.FileExportAsm1Update(Sender: TObject);
begin
FileExportAsm1.Enabled:=AsmWindowOpen;
end;

procedure TMainForm.FileExportAsmItemClick(Sender: TObject);
begin
if dlgExportAsm.Execute then
  AsmChild.RVE.SaveText (dlgExportAsm.FileName,0);//Добавить ошибку если не сохр
end;

procedure TMainForm.FileExportHex1Update(Sender: TObject);
begin
FileExportHex1.Enabled:=AsmWindowOpen;
end;

procedure TMainForm.FileExportHexItemClick(Sender: TObject);
begin
// mainform.statusbar.panels[1].text:='compiling...';
 application.processmessages;
 asmchild.autoCheck:=false;
 if AsmChild.compileAll then
  begin //Компиляция прошла успешно
//    mainform.statusbar.panels[0].text:='compilation completed.';
     application.processmessages;
     asmchild.autoCheck:=true;
  if dlgExportHex.Execute  then
  begin
  UnitFormat.SaveHex(dlgExportHex.FileName,asmchild.ProgramSizeInWord-1);
  end;
  end
 else
  begin //Компиляция провалена
//    mainform.statusbar.panels[0].text:='compilation failed.';
     application.processmessages;
     asmchild.autoCheck:=true;
    exit;
  end;

end;

procedure TMainForm.tlbStepClick(Sender: TObject);
var
WSb,SbSb,WDb:boolean;
DmsI:integer;
SR:Real;
begin
Get_RT_parametrs(WSb,SbSb,WDb,DmsI,SR);
if SbSb  then
begin
Set_rtexStep(true);
Set_rtRefreshComplete(true);
end;
application.ProcessMessages;
sleep (10);
//tmrRefresh.Enabled:=true;
ShowAllRegAndCounters();
end;

procedure TMainForm.tlbStopClick(Sender: TObject);
begin
stopsimulation();
end;

procedure TMainForm.tmrRefreshTimer(Sender: TObject);
label l1,Lh;
var
WSb,SbSb,WDb:boolean;
DmsI:integer;
SR:Real;
begin
tmrrefresh.Enabled:=false;
l1:
application.ProcessMessages;
sleep(10);
//Определим, а вообще запущено ли?

if get_rtRunning()=false then
begin //Остановили
//Synchronize(
//      procedure
//      begin
      application.ProcessMessages;
      main.MainForm.ShowAllRegAndCounters();
//      end
//      );
main.MainForm.actionStep.Enabled:=false;
main.MainForm.actionPause.Enabled:=false;
main.MainForm.actionStop.Enabled:=false;
main.MainForm.actionRun.Enabled:=true;

if assigned(self.AsmChild.RVE) then self.AsmChild.RVE.ReadOnly:=false;

exit;
end
else
begin
  if assigned(self.AsmChild.RVE) then self.AsmChild.RVE.ReadOnly:=true;
end;
//Определим, какие кнопки нужно оставить в главной форме
if Get_rtPause  then //Пауза
  begin
  main.MainForm.actionRun.Enabled:=true;
  main.MainForm.actionPause.Enabled:=false;
  end
else
  begin //Пуск
  main.MainForm.actionRun.Enabled:=false;
  Get_RT_parametrs(WSb,SbSb,WDb,DmsI,SR);
  if SbSb=true then
    begin
    main.MainForm.actionPause.Enabled:=false;
    main.MainForm.actionStep.Enabled:=true;
    end
    else
    begin
    main.MainForm.actionPause.Enabled:=true;
    main.MainForm.actionStep.Enabled:=false;
     end;

  end;
Get_RT_parametrs(WSb,SbSb,WDb,DmsI,SR);
 if SbSb=true then //Step-By-Step
  begin
  application.ProcessMessages;
  sleep(10);
  goto l1;
  end;
if not Get_rtRefreshComplete() then
begin
//Synchronize(
//      procedure
//      begin
      application.ProcessMessages;
      main.MainForm.ShowAllRegAndCounters();
//      end
//      );

lh:
 application.ProcessMessages;

if not endrefresh then goto lh;


end;

   Get_RT_parametrs(WSb,SbSb,WDb,DmsI,SR);
  if  not (SbSb or WDb ) then
   Set_rtRefreshComplete(false);
goto l1;

end;

procedure TMainForm.TmrRTSTimer(Sender: TObject);
var vMC:int64;
vCF:integer;
begin



Get_MCandCF(vMC,vCF);
txtRTSpeed.Text:=FloatToStr((( vMC- predMC)/vCF)*400) +' %';
predMC:=vMC;

end;

procedure TMainForm.WindowArrangeAll1Execute(Sender: TObject);
begin
self.AsmChild.WindowState:=Twindowstate.wsNormal;
self.CompChild.WindowState:=TWindowstate.wsNormal;
end;

end.
