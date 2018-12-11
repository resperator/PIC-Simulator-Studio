unit ChildComp;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ToolWin,
  Vcl.ComCtrls, Vcl.ImgList,  Vcl.Imaging.jpeg, Vcl.Menus;


type
  TRun = class(TThread)
  private
    { Private declarations }

  protected
    procedure Execute; override;
    procedure UpdateCaption;
  end;

type
  TfrmChildComp = class(TForm)
    imgButtons: TImageList;
    OpenDialog: TOpenDialog;
    PageScroller1: TPageScroller;
    tlb: TToolBar;
    btnPnlPointer: TToolButton;
    PopupMenu: TPopupMenu;
    PopupMenuTlb: TPopupMenu;
    mnuPopupDelete: TMenuItem;
    N1: TMenuItem;
    mnuPopupBringToFront: TMenuItem;
    mnuPopupSendToBack: TMenuItem;
    mnuPopupSetupPorts: TMenuItem;
    imgPopup: TImageList;
    mnuPopupSettings: TMenuItem;

    procedure btnPnlPointerClick(Sender: TObject);
    procedure ToolButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure mnuPopupBringToFrontClick(Sender: TObject);
    procedure mnuPopupSendToBackClick(Sender: TObject);
    procedure mnuPopupSetupPortsClick(Sender: TObject);
    procedure Image1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure mnuPopupDeleteClick(Sender: TObject);
    procedure mnuPopupSettingsClick(Sender: TObject);

  private
    { Private declarations }
    Procedure SelectTlbPointer;
    Procedure SelectTlbDev(Id:integer);
    Procedure CreateDev(mouseX,mouseY:integer);
      //Переменные
  var


  public
    { Public declarations }
    procedure RunRefresh();
  end;

var

  frmChildComp: TfrmChildComp;
  CO:Trun;

implementation
uses main,unitDev,unitRes,frmNodes;
{$R *.dfm}

Procedure TfrmChildComp.CreateDev(mouseX,mouseY:integer);
var
  I: Integer;
begin
  //Showmessage('click');
if unitdev.Devices[0].Image.Enabled=false then  //Не очень удачная проверка А не запущена ли симуляция?
  begin //Значит режим - рисование контролла
      for I := 0 to tlb.ButtonCount-1 do
        begin
          if tlb.Buttons[I].Down then
          break;
        end;
      Unitdev.Create_device(tlb.Buttons[I].Tag,self,mousex,mousey);
        main.MainForm.exchange:=true;
  end;
end;

Procedure TfrmChildComp.SelectTlbPointer;
var j:integer;
begin
btnpnlpointer.Down:=true;
//unitdev.Dev[0].Img.Enabled:=true;
for j := 0 to high(Devices) do Devices[j].image.Enabled:=true;
main.MainForm.CompChild.cursor:=crDefault;
end;

procedure TfrmChildComp.SelectTlbDev(Id:integer);
var j:integer;
begin
//unitdev.Dev[0].Img.Enabled:=false;
for j := 0 to high(Devices) do Devices[j].image.Enabled:=false;
main.MainForm.CompChild.cursor:=crcross;
end;

procedure TfrmChildComp.RunRefresh;
begin
  //Создание потока PIC10F200
co:=TRun.Create(true);
co.FreeOnTerminate:=false;
co.Priority:= tpNormal;
co.Start;

end;

procedure TfrmChildComp.ToolButtonClick(Sender: TObject);
begin
with (Sender as TToolButton) do
begin
if down=false then SelectTlbPointer
  else
    begin
    SelectTlbDev((Sender as TToolButton).ImageIndex);

    end;
end;

end;

procedure TRun.UpdateCaption;
var
vhDC:HDC;
  I: Integer;
begin
//vhDC:=C_Refresh(unitdev.Devices[0].Image);
for I := Low(Devices) to High(Devices) do
  begin
   Devices[I].DrawImage(true,0)
  end;
end;

procedure TRun.Execute;
label StartLoop;
var w,h:integer;

begin

StartLoop:



Synchronize(UpdateCaption);

application.ProcessMessages;
sleep(10);
application.ProcessMessages;

if main.Get_rtRunning() then goto StartLoop;

end;


procedure TfrmChildComp.btnPnlPointerClick(Sender: TObject);
begin
if not btnpnlpointer.Down then btnpnlpointer.Down:=true ;
SelectTlbPointer
end;





procedure TfrmChildComp.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//action:=cahide;
end;

procedure TfrmChildComp.FormCreate(Sender: TObject);
var
  I: Integer;
 vTIcon:TICON;
 ttB:TToolButton;
begin
//Загрузка ресурсов
btnPnlPointer.Caption:=GetText(100);
btnPnlPointer.Hint:=GetText(100);
mnuPopupSetupPorts.Caption:=GetText(120);
mnuPopupBringToFront.Caption:=GetText(121);
mnuPopupSendToBack.Caption:=GetText(122);
mnuPopupSettings.Caption:=GetText(123);
mnuPopupDelete.Caption:=GetText(103);

for I := Low(AInfoDevice) to High(AInfoDevice) do
  begin
  if aInfoDevice[I].vType=0 then break;

  vTIcon:=TIcon.Create();
  vTIcon.Handle  :=AInfoDevice[I].vIcon;

   imgbuttons.addicon(vTIcon);
   vTIcon.Free;
   ttb:=TToolButton.Create(tlb);
   ttb.Caption:=AInfoDevice[I].vSType+' '+AInfoDevice[I].vSFamily;
   ttb.hint:=AInfoDevice[I].vSDisplayName;
   ttb.Parent :=tlb;
   ttb.ImageIndex:=I+1;
   ttb.Tag:=I;
   ttb.OnClick:=self.ToolButtonClick;
   ttb.Left:=0;
   ttb.Grouped:=true;
   ttb.Style:=TToolbuttonstyle.tbsCheck;



  end;
 { for I := 0 to tlb.ButtonCount-1 do
  begin
    tlb.Buttons[I].Left:=0;
    tlb.Buttons[I].Top:=I*tlb.Buttons[I].Height;
  end; }
end;

procedure TfrmChildComp.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
//tlb.
if button=tmousebutton.mbLeft  then

  CreateDev(x,y);

  SelectTlbPointer;
end;





procedure TfrmChildComp.Image1ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
//Показывть ли "Подключить порты"
  if ((Sender as TImage).tag=0) or  main.Get_rtRunning() then
  begin
  mnuPopupSetupPorts.Enabled:=false;
  mnuPopupDelete.Enabled:=false;
  end
  else
  begin
  mnuPopupSetupPorts.Enabled:=true;
  mnuPopupDelete.Enabled:=true;
  end;
//Показывать ли "Настройки"
  if Devices[(Sender as TImage).tag].AssignedShowSettings then mnuPopupSettings.Enabled:=true else  mnuPopupSettings.Enabled:=false;
  IF  main.Get_rtRunning() THEN mnuPopupSettings.Enabled:=false;


end;

procedure TfrmChildComp.mnuPopupBringToFrontClick(Sender: TObject);
var
sn:TObject;
begin
tmpImage.BringToFront;
end;

procedure TfrmChildComp.mnuPopupDeleteClick(Sender: TObject);
var
  I: Integer;
begin
Devices[tmpImage.Tag].Image.Free;
Delete(Devices,tmpImage.Tag,1);
for I := Low(Devices) to High(Devices) do
begin
Devices[I].Image.Tag:=I;
end;
end;

procedure TfrmChildComp.mnuPopupSendToBackClick(Sender: TObject);
begin
tmpImage.SendToBack;
end;

procedure TfrmChildComp.mnuPopupSettingsClick(Sender: TObject);
begin
if main.Get_rtRunning() then exit;
if not assigned(tmpImage) then exit;
Devices[tmpImage.Tag].ShowSettings;
end;

procedure TfrmChildComp.mnuPopupSetupPortsClick(Sender: TObject);
begin
if main.Get_rtRunning() then exit;
if ( tmpImage ).Tag=0 then exit;
if unitDev.Devices[tmpimage.Tag].PortsCount=0 then exit;

 frmNodes.myParentForm:=self;
 frmNodes.CurrentDevice:=tmpimage.Tag;

 frmNodes.formNodes.ShowModal;

end;

end.
