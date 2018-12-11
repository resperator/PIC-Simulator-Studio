unit frmSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, unitClasses4Devices, unitRes,
  Vcl.StdCtrls,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls;

type
  TformSettings = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    gbColor: TGroupBox;
    rbRed: TRadioButton;
    rbGreen: TRadioButton;
    rbBlue: TRadioButton;
    rbYellow: TRadioButton;
    rbGray: TRadioButton;
    gbEquivalentCircuit: TGroupBox;
    gbPreview: TGroupBox;
    img0: TImage;
    img1: TImage;
    gbType: TGroupBox;
    rbSPST: TRadioButton;
    rbPTM: TRadioButton;
    rbPTB: TRadioButton;
    chkHLSWP: TCheckBox;
    imgPTBHI: TImage;
    ImgPTBLO: TImage;
    imgPTMHI: TImage;
    imgPTMLO: TImage;
    imgSPSTHI: TImage;
    imgSPSTLO: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure rbRedClick(Sender: TObject);
    procedure rbGreenClick(Sender: TObject);
    procedure rbBlueClick(Sender: TObject);
    procedure rbYellowClick(Sender: TObject);
    procedure rbGrayClick(Sender: TObject);
    procedure rbSPSTClick(Sender: TObject);
    procedure rbPTMClick(Sender: TObject);
    procedure rbPTBClick(Sender: TObject);
    procedure chkHLSWPClick(Sender: TObject);
  private
    { Private declarations }
    Procedure redrawForm();
  public
    { Public declarations }
    OrigHandle: THandle;
    // Application.handle, кот. необходимо восстановить при выходе
    InternalIndex: integer;
    // Внутренний индекс в рамках данного семейства радиодеталей
    Device: TDevice;
    // Ссылка на экземпляр класса TDevice, для кот. вызвано окно
  end;

var
  formSettings: TformSettings;
  bmp_0,bmp_1: array of TBitmap; //Картинки "горит" и "не горит"
  bmp0,bmp1:TBitmap; //Картинки "горит" и "не горит" в предпросмотре
  tmpType:integer;
  tmpHI:boolean;
  Color:char;
  aHI:array of boolean;
  aType:array of integer;

implementation

{$R *.dfm}
Procedure SetColor(Id,No:integer);
begin
bmp0.Free;
bmp1.Free;
case No of
0: //Red
begin
  Bmp0:=TBitmap.Create;
  Bmp0.Handle:=LoadBitmap(HInstance,'Red0');
  Bmp1:=TBitmap.Create;
  Bmp1.Handle:=LoadBitmap(HInstance,'Red1');
  Color:='R';
end;
1: //Green
begin
    Bmp0:=TBitmap.Create;
  Bmp0.Handle:=LoadBitmap(HInstance,'Green0');
  Bmp1:=TBitmap.Create;
  Bmp1.Handle:=LoadBitmap(HInstance,'Green1');
  Color:='G';
end;
2: //Blue
begin
    Bmp0:=TBitmap.Create;
  Bmp0.Handle:=LoadBitmap(HInstance,'Blue0');
  Bmp1:=TBitmap.Create;
  Bmp1.Handle:=LoadBitmap(HInstance,'Blue1');
  Color:='B';
end;
3: //Yellow
begin
     Bmp0:=TBitmap.Create;
  Bmp0.Handle:=LoadBitmap(HInstance,'Yellow0');
  Bmp1:=TBitmap.Create;
  Bmp1.Handle:=LoadBitmap(HInstance,'Yellow1');
  Color:='Y';
end;
4: //Gray
begin
     Bmp0:=TBitmap.Create;
  Bmp0.Handle:=LoadBitmap(HInstance,'Gray0');
  Bmp1:=TBitmap.Create;
  Bmp1.Handle:=LoadBitmap(HInstance,'Gray1');
  Color:='W';
end;
end;
end;


Procedure TformSettings.redrawForm();
begin
  img0.Canvas.Draw(0, 0, bmp0);
  img1.Canvas.Draw(0, 0, bmp1);

  imgSPSTLO.visible:=false;
  imgSPSTHI.visible:=false;
  imgPTMLO.visible:=false;
  imgPTMHI.visible:=false;
  imgPTBLO.visible:=false;
  imgPTBHI.visible:=false;

  if tmpHI then
  begin
  chkHLSWP.Checked:=true;
    case tmpType of
      0: imgSPSTHI.visible:=true;
      1: imgPTMHI.visible:=true;
      2: imgPTBHI.visible:=true;
    end;
  end
  else
  begin
  chkHLSWP.Checked:=false;
      case tmpType of
      0: imgSPSTLO.visible:=true;
      1: imgPTMLO.visible:=true;
      2: imgPTBLO.visible:=true;
    end;
  end;
end;

procedure TformSettings.btnCancelClick(Sender: TObject);
begin
  self.Close;
end;

procedure TformSettings.btnOkClick(Sender: TObject);
begin
  Device.LenSaveData := 3;
  if rbRed.Checked then
    Device.Savedata[0] := 'R';
  if rbGreen.Checked then
    Device.Savedata[0] := 'G';
  if rbBlue.Checked then
    Device.Savedata[0] := 'B';
  if rbYellow.Checked then
    Device.Savedata[0] := 'Y';
  if rbGray.Checked then
    Device.Savedata[0] := 'W';

  if rbSPST.Checked then
    Device.Savedata[1] := 'S';
  if rbPTM.Checked then
    Device.Savedata[1] := 'M';
  if rbPTB.Checked then
    Device.Savedata[1] := 'B';

  if chkHLSWP.Checked then
    Device.Savedata[2] := 'H'
  else
    Device.Savedata[2] := 'L';

  Device.ApplySettings;
  self.Close;
end;

procedure TformSettings.chkHLSWPClick(Sender: TObject);
begin
tmpHi:=chkhlswp.Checked;
redrawForm;
end;

procedure TformSettings.FormActivate(Sender: TObject);
begin
  self.Caption := GetText(3) + ': ' + GetText(0) + ' (' +
    inttostr(InternalIndex) + ')';
  case Device.Savedata[0] of
    'R':
      begin
        rbRed.Checked := true;
        rbRedClick(Sender);
      end;
    'G':
      begin
        rbGreen.Checked := true;
        rbGreenClick(Sender);
      end;
    'B':
      begin
        rbBlue.Checked := true;
        rbBlueClick(Sender);
      end;
    'Y':
      begin
        rbYellow.Checked := true;
        rbYellowClick(Sender);
      end;
    'W':
      begin
        rbGray.Checked := true;
        rbGrayClick(Sender);
      end;
  end;

  case Device.Savedata[1] of
    'S':
      begin
        rbSPST.Checked := true;
        rbspstclick(Sender);
      end;
    'M':
      begin
        rbPTM.Checked := true;
        rbPTMclick(Sender);
      end;
    'B':
      begin
        rbPTB.Checked := true;
        rbPTBclick(Sender);
      end;
  end;

  case Device.Savedata[2] of
    'H':
      begin
        chkHLSWP.Checked := true;
        chkHLSWPclick(Sender);
      end;
    'L':
      begin
        chkHLSWP.Checked := false;
        chkHLSWPclick(Sender);
      end;
  end;

end;

procedure TformSettings.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Handle := OrigHandle;
end;

procedure TformSettings.FormCreate(Sender: TObject);
begin

  btnOk.Caption := GetText(1);
  btnCancel.Caption := GetText(2);

  gbColor.Caption := GetText(20);
  gbType.Caption := GetText(21);
  gbEquivalentCircuit.Caption := GetText(22);
  rbRed.Caption := GetText(10);
  rbGreen.Caption := GetText(11);
  rbBlue.Caption := GetText(12);
  rbYellow.Caption := GetText(13);
  rbGray.Caption := GetText(14);
  rbSPST.Caption := GetText(4);
  rbPTM.Caption := GetText(5);
  rbPTB.Caption := GetText(6);
  chkHLSWP.Caption := GetText(7);
  gbPreview.Caption := GetText(23);

  redrawForm();

end;

procedure TformSettings.rbBlueClick(Sender: TObject);
begin
  setcolor(InternalIndex, 2);
  redrawForm;
end;

procedure TformSettings.rbGrayClick(Sender: TObject);
begin
  setcolor(InternalIndex, 4);
  redrawForm;
end;

procedure TformSettings.rbGreenClick(Sender: TObject);
begin
  setcolor(InternalIndex, 1);
  redrawForm;
end;

procedure TformSettings.rbPTBClick(Sender: TObject);
begin
tmpType:=2;
redrawForm;
end;

procedure TformSettings.rbPTMClick(Sender: TObject);
begin
tmpType:=1;
redrawForm;
end;

procedure TformSettings.rbRedClick(Sender: TObject);
begin
  setcolor(InternalIndex, 0);
  redrawForm;
end;

procedure TformSettings.rbSPSTClick(Sender: TObject);
begin
tmpType:=0;
redrawForm;

end;

procedure TformSettings.rbYellowClick(Sender: TObject);
begin
  setcolor(InternalIndex, 3);
  redrawForm;
end;

end.
