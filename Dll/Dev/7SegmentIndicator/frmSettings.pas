unit frmSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, unitClasses4Devices, unitRes,
  Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Imaging.pngimage, Vcl.ComCtrls;

type
  TformSettings = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    gbEquivalentCircuit: TGroupBox;
    rbLow: TRadioButton;
    rbHigh: TRadioButton;
    gbColor: TGroupBox;
    rbRed: TRadioButton;
    rbGreen: TRadioButton;
    rbBlue: TRadioButton;
    rbYellow: TRadioButton;
    gbOperateSignal: TGroupBox;
    gbImagePresistence: TGroupBox;
    TBPeriod: TTrackBar;
    lblPeriod: TLabel;
    lblPRPer: TLabel;
    lblDC: TLabel;
    TBMinDC: TTrackBar;
    lblPRDC: TLabel;
    gbENLevel: TGroupBox;
    rbAlwaysOn: TRadioButton;
    rbENHigh: TRadioButton;
    rbENLow: TRadioButton;
    ImgHD: TImage;
    ImgHH: TImage;
    ImgHL: TImage;
    ImgLD: TImage;
    ImgLH: TImage;
    ImgLL: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure rbRedClick(Sender: TObject);
    procedure rbGreenClick(Sender: TObject);
    procedure rbBlueClick(Sender: TObject);
    procedure rbYellowClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure rbHighClick(Sender: TObject);
    procedure rbLowClick(Sender: TObject);
    procedure TBPeriodChange(Sender: TObject);
    procedure TBMinDCChange(Sender: TObject);
    procedure rbAlwaysOnClick(Sender: TObject);
    procedure rbENHighClick(Sender: TObject);
    procedure rbENLowClick(Sender: TObject);
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
  bmp: array of TBitmap; // Картинки

  Color: char;
  Invert: array of boolean;
  PrPeriod: array of integer;
  PrDC: array of integer;
  InvertEN: array of boolean;
  EN: array of boolean;
  Seg_a_EN: array of boolean;
  Seg_b_EN: array of boolean;
  Seg_c_EN: array of boolean;
  Seg_d_EN: array of boolean;
  Seg_e_EN: array of boolean;
  Seg_f_EN: array of boolean;
  Seg_g_EN: array of boolean;
  Seg_DP_EN: array of boolean;
  Seg_EN_EN: array of boolean;
  Seg_a_CN: array of integer;
  Seg_b_CN: array of integer;
  Seg_c_CN: array of integer;
  Seg_d_CN: array of integer;
  Seg_e_CN: array of integer;
  Seg_f_CN: array of integer;
  Seg_g_CN: array of integer;
  Seg_DP_CN: array of integer;
  Seg_a_Glow: array of boolean;
  Seg_b_Glow: array of boolean;
  Seg_c_Glow: array of boolean;
  Seg_d_Glow: array of boolean;
  Seg_e_Glow: array of boolean;
  Seg_f_Glow: array of boolean;
  Seg_g_Glow: array of boolean;
  Seg_DP_Glow: array of boolean;
  Ii: array of boolean;
  RefreshTact: array of int64;
  DeltaRefreshTact: array of int64;

implementation

{$R *.dfm}



procedure TformSettings.rbAlwaysOnClick(Sender: TObject);
begin
redrawForm;
end;

procedure TformSettings.rbBlueClick(Sender: TObject);
begin
  redrawForm;
end;

procedure TformSettings.rbENHighClick(Sender: TObject);
begin
redrawForm;
end;

procedure TformSettings.rbENLowClick(Sender: TObject);
begin
redrawForm;
end;

procedure TformSettings.rbGreenClick(Sender: TObject);
begin
  redrawForm;
end;

procedure TformSettings.rbHighClick(Sender: TObject);
begin
  redrawForm;
end;

procedure TformSettings.rbLowClick(Sender: TObject);
begin
  redrawForm;
end;

procedure TformSettings.rbRedClick(Sender: TObject);
begin
  redrawForm;
end;

procedure TformSettings.rbYellowClick(Sender: TObject);
begin
  redrawForm;
end;

Procedure TformSettings.redrawForm();
begin
  ImgHD.Visible:=false;
  ImgHH.Visible:=False;
  ImgHL.Visible:=false;
  ImgLD.Visible:=false;
  ImgLH.Visible:=false;
  ImgLL.Visible:=false;
  if rbHigh.Checked=true then
    begin
      if rbAlwaysOn.Checked=true then imgHD.Visible:=true;
      if rbENHigh.Checked=true then imgHH.Visible:=true;
      if rbENLow.Checked=true then imgHL.Visible:=true;
    end;
  if rbLow.Checked=true then
    begin
      if rbAlwaysOn.Checked=true then imgLD.Visible:=true;
      if rbENHigh.Checked=true then imgLH.Visible:=true;
      if rbENLow.Checked=true then imgLL.Visible:=true;
    end;
end;

procedure TformSettings.TBMinDCChange(Sender: TObject);
begin
  lblPRDC.Caption := inttostr(TBMinDC.Position) + ' %';
end;

procedure TformSettings.TBPeriodChange(Sender: TObject);
begin
  lblPRPer.Caption := '1/' + inttostr(TBPeriod.Position) + ' ' +
    unitRes.GetText(6);
end;

procedure TformSettings.btnCancelClick(Sender: TObject);
begin
  self.Close;
end;

procedure TformSettings.btnOkClick(Sender: TObject);
var str:Ansistring;
begin
  Device.LenSaveData := 5;
  if rbRed.Checked then
    Device.Savedata[0] := 'R';
  if rbGreen.Checked then
    Device.Savedata[0] := 'G';
  if rbBlue.Checked then
    Device.Savedata[0] := 'B';
  if rbYellow.Checked then
    Device.Savedata[0] := 'Y';

  if rbHigh.Checked then
    Device.Savedata[1] := 'H'
  else
    Device.Savedata[1] := 'L';

  if rbENHigh.Checked then
    Device.Savedata[2] := 'H';
  if rbENLow.Checked then
    Device.Savedata[2] := 'L' ;
  if rbAlwaysOn.Checked then
    Device.Savedata[2] := 'D'  ;

  Device.SaveData[3]:=AnsiChar(TBPeriod.Position);

  Device.SaveData[4]:=AnsiChar(TBMinDC.Position);

  Device.ApplySettings;
  self.Close;
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

  end;
  if Device.Savedata[1] = 'H' then
  BEGIN
    rbHigh.Checked := true;
    rbHighClick(Sender);
  END
  ELSE
  BEGIN
    rbLow.Checked := true;
    rbLowClick(Sender);
  END;

  case device.SaveData[2] of
  'H':
  begin
    rbENHigh.Checked:=true;
    rbENHighClick(Sender);
  end;
  'L':
  begin
    rbENLow.Checked:=true;
    rbENLowClick(Sender);
  end;
  'D':
  begin
    rbAlwaysOn.Checked:=true;
    rbAlwaysOnClick(Sender);
  end;
  end;
  TBPeriod.Position:=ord(device.SaveData[3]);
  TBMinDC.Position:=Ord(device.SaveData[4]);
    TBMinDCChange(Sender);
    TBPeriodChange(Sender);
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
  gbOperateSignal.Caption := GetText(21);
  gbEquivalentCircuit.Caption := GetText(22);
  rbRed.Caption := GetText(10);
  rbGreen.Caption := GetText(11);
  rbBlue.Caption := GetText(12);
  rbYellow.Caption := GetText(13);
  lblPeriod.Caption:=gettext(14);
  lblDC.Caption:=gettext(15);
  rbHigh.Caption := GetText(4);
  rbLow.Caption := GetText(5);
  gbImagePresistence.Caption:=gettext(23);
  gbENLevel.Caption:=gettext(24);
  rbAlwaysOn.Caption:=gettext(25);
  rbENHigh.Caption:=gettext(4);
  rbENLow.Caption:=gettext(5);


  redrawForm();

end;

end.
