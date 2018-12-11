unit frmSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, unitClasses4Devices, unitRes,
  Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.ExtCtrls, Data.Bind.EngExt, Vcl.Bind.DBEngExt, System.Rtti,
  System.Bindings.Outputs, Vcl.Bind.Editors, Data.Bind.Components;

type
  TConfigBits = record
    Name: string;
    DescriptionId: integer;
    No: integer;
    Value0Id: integer;
    Value1Id: integer;
  end;

type
  TArrayConfigBits = array of TConfigBits;

type
  TformSettings = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    pnlCfg20x: TPanel;
    lbl20xMCLR: TLabel;
    cmb20xMCLR: TComboBox;
    TAB: TPageControl;
    tabCB: TTabSheet;
    tabO: TTabSheet;
    cmb20xCP: TComboBox;
    lbl20xCP: TLabel;
    cmb20xWDTE: TComboBox;
    lbl20xWDTE: TLabel;
    pnlCfg22x: TPanel;
    lbl22xMCLRE: TLabel;
    lbl22xCP: TLabel;
    lbl22xWDTE: TLabel;
    cmb22xMCLRE: TComboBox;
    cmb22xCP: TComboBox;
    cmb22xWDTE: TComboBox;
    cmb22xMCPU: TComboBox;
    cmb22xIOSCFS: TComboBox;
    lbl22xMCPU: TLabel;
    lbl22xIOSCFS: TLabel;
    gbCF: TGroupBox;
    chkDCF: TCheckBox;
    edtF: TEdit;
    lblTCF: TLabel;
    lblHZ: TLabel;
    gbGetXValue: TGroupBox;
    rbXB0: TRadioButton;
    rbXB1: TRadioButton;
    rbXBr: TRadioButton;
    pnlCfg12F: TPanel;
    lbl12FMCLRE: TLabel;
    lbl12FCP: TLabel;
    lbl12FWDTE: TLabel;
    lbl12FFosc1: TLabel;
    lbl12FFosc0: TLabel;
    cmb12FMCLRE: TComboBox;
    cmb12FCP: TComboBox;
    cmb12FWDTE: TComboBox;
    cmb12FFosc1: TComboBox;
    cmb12FFosc0: TComboBox;
    lbl12FCPDF: TLabel;
    cmb12FCPDF: TComboBox;
    lbl12FIOSCFS: TLabel;
    cmb12FIOSCFS: TComboBox;
    lbldcf: TLabel;
    pnlCfg5X: TPanel;
    cmb5xCP: TComboBox;
    cmb5xWDTE: TComboBox;
    cmb5xFosc1: TComboBox;
    cmb5xFosc0: TComboBox;
    lbl5xCP: TLabel;
    lbl5xWDTE: TLabel;
    lbl5xFosc1: TLabel;
    lbl5xFosc0: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure chkDCFClick(Sender: TObject);
    procedure cmb22xIOSCFSChange(Sender: TObject);
    procedure cmb12FFosc1Change(Sender: TObject);
    procedure cmb12FIOSCFSChange(Sender: TObject);
    procedure cmb5xFosc1Change(Sender: TObject);
    procedure cmb5xFosc0Change(Sender: TObject);

  private
    { Private declarations }
    procedure SetDefaultFreq();
    procedure ChangeFrqBit12F();
    procedure ChangeFrqBit5x();

  public
    { Public declarations }
    OrigHandle: THandle;
    // Application.handle, кот. необходимо восстановить при выходе
    InternalIndex: integer;
    // Внутренний индекс в рамках данного семейства радиодеталей
    Device: TDevice;
    // Ссылка на экземпляр класса TDevice, для кот. вызвано окно

    Config: array [0 .. 11] of boolean;
    ConfigBits: TArrayConfigBits;
    rtCrystalFreq: integer;
  end;

var
  formSettings: TformSettings;

implementation

{$R *.dfm}

procedure TformSettings.btnCancelClick(Sender: TObject);
begin
  self.Close;
end;

procedure TformSettings.SetDefaultFreq();
var
  Freq: integer;
begin
  if self.chkDCF.Checked then
    exit;

  Freq := 4000000; // Верно для PIC10F200/202/204/206, PIC12F508/509
  if (Device.RCModel = 'PIC10F220') or (Device.RCModel = 'PIC10F222') then
  // Для PIC10F220/222
  begin
    if self.cmb22xIOSCFS.ItemIndex = 0 then
      Freq := 4000000
    else
      Freq := 8000000;

  end;

    if (Device.RCModel = 'PIC12F510') or (Device.RCModel = 'PIC12F519') then
  // Для PIC12F510/PIC12F519
  begin
    if self.cmb12FIOSCFS.ItemIndex = 0 then
      Freq := 4000000
    else
      Freq := 8000000;

  end;

  self.edtF.Text := Inttostr(Freq);
  // rtCrystalFreq:=Freq;
end;
procedure TformSettings.ChangeFrqBit5x();
begin
  lbldcf.Caption := Gettext(209);
  if (self.cmb5xFosc1.ItemIndex = 0) and (self.cmb5xFosc0.ItemIndex = 0) then
  begin
    lbldcf.Caption := lbldcf.Caption + Gettext(210);
    chkDCF.Checked:=true;
  end;
  if (self.cmb5xFosc1.ItemIndex = 0) and (self.cmb5xFosc0.ItemIndex = 1) then
  begin
    lbldcf.Caption := lbldcf.Caption + Gettext(211);
    chkDCF.Checked:=true;
  end;
  if (self.cmb5xFosc1.ItemIndex = 1) and (self.cmb5xFosc0.ItemIndex = 0) then
  begin
      lbldcf.Caption := lbldcf.Caption + Gettext(215);
    chkDCF.Checked:=true;
  end;
  if (self.cmb5xFosc1.ItemIndex = 1) and (self.cmb5xFosc0.ItemIndex = 1) then
  begin
    lbldcf.Caption := lbldcf.Caption + Gettext(214);
    chkDCF.Checked:=true;
  end;
end;

procedure TformSettings.ChangeFrqBit12F();
begin
  lbldcf.Caption := Gettext(209);
  if (self.cmb12FFosc1.ItemIndex = 0) and (self.cmb12FFosc0.ItemIndex = 0) then
  begin
    lbldcf.Caption := lbldcf.Caption + Gettext(210);
    chkDCF.Checked:=true;
  end;
  if (self.cmb12FFosc1.ItemIndex = 0) and (self.cmb12FFosc0.ItemIndex = 1) then
  begin
    lbldcf.Caption := lbldcf.Caption + Gettext(211);
    chkDCF.Checked:=true;
  end;
  if (self.cmb12FFosc1.ItemIndex = 1) and (self.cmb12FFosc0.ItemIndex = 0) then
  begin
    if (Device.RCModel = 'PIC12F510') or (Device.RCModel = 'PIC12F519') then
    begin
      if self.cmb12FIOSCFS.ItemIndex = 0 then
        lbldcf.Caption := lbldcf.Caption + Gettext(212)
      else
        lbldcf.Caption := lbldcf.Caption + Gettext(213);
    chkDCF.Checked:=false;
    end
    else
    begin
      lbldcf.Caption := lbldcf.Caption + Gettext(212);
      chkDCF.Checked:=false;
    end;
  end;
  if (self.cmb12FFosc1.ItemIndex = 1) and (self.cmb12FFosc0.ItemIndex = 1) then
  begin
    lbldcf.Caption := lbldcf.Caption + Gettext(214);
    chkDCF.Checked:=true;
  end;
end;

procedure TformSettings.btnOkClick(Sender: TObject);
var
  k: integer;
begin
  // Общее для всех

  if self.chkDCF.Checked then // Выбрал ли пользователь кастомную частоту?
  begin // Да
    if (length(edtF.Text) > 9) or (strtoint(edtF.Text) < 100) then
    begin
      MessageDlg(Gettext(100), mtError, [mbOk], 0);
      exit;
    end;
  end
  else
  begin // Нет

  end;
  // PIC10F200/202/204/206
  if (Device.RCModel = 'PIC10F200') or (Device.RCModel = 'PIC10F202') or
    (Device.RCModel = 'PIC10F204') or (Device.RCModel = 'PIC10F206') then
  begin
    if self.cmb20xWDTE.ItemIndex = 0 then
      Config[ConfigBits[0].No] := false
    else
      Config[ConfigBits[0].No] := true;
    if self.cmb20xCP.ItemIndex = 0 then
      Config[ConfigBits[1].No] := false
    else
      Config[ConfigBits[1].No] := true;
    if self.cmb20xMCLR.ItemIndex = 0 then
      Config[ConfigBits[2].No] := false
    else
      Config[ConfigBits[2].No] := true;

  end;
  // PIC10F220/222
  if (Device.RCModel = 'PIC10F220') or (Device.RCModel = 'PIC10F222') then
  begin
    if self.cmb22xWDTE.ItemIndex = 0 then
      Config[ConfigBits[2].No] := false
    else
      Config[ConfigBits[2].No] := true;
    if self.cmb22xCP.ItemIndex = 0 then
      Config[ConfigBits[3].No] := false
    else
      Config[ConfigBits[3].No] := true;
    if self.cmb22xMCLRE.ItemIndex = 0 then
      Config[ConfigBits[4].No] := false
    else
      Config[ConfigBits[4].No] := true;
    if self.cmb22xIOSCFS.ItemIndex = 0 then
      Config[ConfigBits[0].No] := false
    else
      Config[ConfigBits[0].No] := true;
    if self.cmb22xMCPU.ItemIndex = 0 then
      Config[ConfigBits[1].No] := false
    else
      Config[ConfigBits[1].No] := true;
  end;

    // PIC12F508, PIC12F509, PIC12F510, PIC12F519
  if (Device.RCModel = 'PIC12F508') or (Device.RCModel = 'PIC12F509') or
    (Device.RCModel = 'PIC12F510') or (Device.RCModel = 'PIC12F519') then
  begin
    if self.cmb12ffosc0.ItemIndex = 1 then
      Config[ConfigBits[0].No] := true
    else
      Config[ConfigBits[0].No] := false;
    if self.cmb12ffosc1.ItemIndex = 1 then
      Config[ConfigBits[1].No] := true
    else
      Config[ConfigBits[1].No] := false;
    if self.cmb12fwdte.ItemIndex = 1 then
      Config[ConfigBits[2].No] := true
    else
      Config[ConfigBits[2].No] := false;
    if self.cmb12fcp.ItemIndex = 1 then
      Config[ConfigBits[3].No] := true
    else
      Config[ConfigBits[3].No] := false;
    if self.cmb12fmclre.ItemIndex = 1 then
      Config[ConfigBits[4].No] := true
    else
      Config[ConfigBits[4].No] := false;
    if ((Device.RCModel = 'PIC12F510') or (Device.RCModel = 'PIC12F519'))  then if (self.cmb12fioscfs.ItemIndex = 1)   then
      Config[ConfigBits[5].No] := true
    else
      Config[ConfigBits[5].No] := false;
    if (Device.RCModel = 'PIC12F519')  then if (self.cmb12fcpdf.ItemIndex = 1)  then
      Config[ConfigBits[6].No] := true
    else
      Config[ConfigBits[6].No] := false;
  end;
      // PIC16F54,16F57,1659
  if (Device.RCModel = 'PIC16F54') or (Device.RCModel = 'PIC16F57') or
    (Device.RCModel = 'PIC16F59')  then
  begin
    if self.cmb12ffosc0.ItemIndex = 1 then
      Config[ConfigBits[0].No] := true
    else
      Config[ConfigBits[0].No] := false;
    if self.cmb12ffosc1.ItemIndex = 1 then
      Config[ConfigBits[1].No] := true
    else
      Config[ConfigBits[1].No] := false;
    if self.cmb12fwdte.ItemIndex = 1 then
      Config[ConfigBits[2].No] := true
    else
      Config[ConfigBits[2].No] := false;
    if self.cmb12fcp.ItemIndex = 1 then
      Config[ConfigBits[3].No] := true
    else
      Config[ConfigBits[3].No] := false;

  end;

  // Сохраним в массив для сохранения ATCSS
  for k := 0 to 11 do
    if Config[k] = true then
      Device.savedata[k] := '1'
    else
      Device.savedata[k] := '0';
  if self.chkDCF.Checked then
  begin
    Device.savedata[12] := '1';
    for k := 1 to 9 - length(edtF.Text) do
      Device.savedata[12 + k] := '0';
    // Забивка нулями все перед первой цифрой числа
    for k := 9 - length(edtF.Text) + 1 to 9 do
    begin
      Device.savedata[12 + k] :=
        ansichar(copy(edtF.Text, length(edtF.Text) - 9 + k, 1)[1]);
      // забивка цифрами
    end;
  end
  else
    Device.savedata[12] := '0';
  // Установка нужной частоты для симуляции
  k := strtoint(edtF.Text);
  rtCrystalFreq := k;
  // Сохраним значение GetXValue
  if self.rbXB0.Checked then
    Device.savedata[22] := '0';
  if self.rbXB1.Checked then
    Device.savedata[22] := '1';
  if self.rbXBr.Checked then
    Device.savedata[22] := 'R';

  self.Close;
end;

procedure TformSettings.chkDCFClick(Sender: TObject);
var
  tmpBool: boolean;
  tmpStr: string;
  k: integer;
begin
  if chkDCF.Checked then
  begin // Поставили галку
    // if Device.savedata[12]='1' then
    // begin
    tmpBool := false;
    tmpStr := '';
    for k := 13 to 21 do
    begin
      if Device.savedata[k] <> '0' then
        tmpBool := true;
      if tmpBool then
        tmpStr := tmpStr + Device.savedata[k];
    end;
    // end;
    self.edtF.Text := tmpStr;
    // rtCrystalFreq:=strtoint(tmpstr);
    edtF.ReadOnly := false;
  end
  else
  begin // сняли
    SetDefaultFreq;
    edtF.ReadOnly := true;
  end;
end;

procedure TformSettings.cmb12FFosc1Change(Sender: TObject);
begin
ChangeFrqBit12F;
end;

procedure TformSettings.cmb12FIOSCFSChange(Sender: TObject);
begin
ChangeFrqBit12F;
end;

procedure TformSettings.cmb22xIOSCFSChange(Sender: TObject);
begin
ChangeFrqBit12F;
end;

procedure TformSettings.cmb5xFosc0Change(Sender: TObject);
begin
ChangeFrqBit5x;
end;

procedure TformSettings.cmb5xFosc1Change(Sender: TObject);
begin
ChangeFrqBit5x;
end;

procedure TformSettings.FormActivate(Sender: TObject);
var
  tmpBool: boolean;
  tmpStr: string;
  k: integer;
begin
  self.Caption := Gettext(3) + ': ' + Gettext(0) + ' (' +
    Inttostr(InternalIndex) + ')';
  // Сброс видимости всех панелей
  pnlCfg20x.Visible := false;
  pnlCfg22x.Visible := false;
  pnlCfg12F.Visible := false;
  pnlCfg5x.Visible := false;

  // Откл битов конфигурации (По коду ниже - включаться, если соотв. МК)
  self.lbl12FCPDF.Enabled := false;
  self.lbl12FIOSCFS.Enabled := false;
  self.cmb12FCPDF.Enabled := false;
  self.cmb12FIOSCFS.Enabled := false;

  // Для всех одинаковые
  btnOk.Caption := Gettext(1);
  btnCancel.Caption := Gettext(2);
  tabCB.Caption := Gettext(10);
  tabO.Caption := Gettext(11);

  self.chkDCF.Caption := Gettext(200);
  self.gbCF.Caption := Gettext(201);
  self.lblTCF.Caption := Gettext(202);
  self.lblHZ.Caption := Gettext(203);

  chkDCF.Visible := true;
  lbldcf.Visible := false;

  self.gbGetXValue.Caption := Gettext(204);
  self.rbXB0.Caption := Gettext(205);
  self.rbXB1.Caption := Gettext(206);
  self.rbXBr.Caption := Gettext(207);

  // Загрузка частоты кварца в поле
  self.edtF.Text := Inttostr(rtCrystalFreq);
  if Device.savedata[12] = '1' then
  begin
    tmpBool := false;
    tmpStr := '';
    for k := 13 to 21 do
    begin
      if Device.savedata[k] <> '0' then
        tmpBool := true;
      if tmpBool then
        tmpStr := tmpStr + Device.savedata[k];
    end;
    self.edtF.Text := tmpStr;
    self.chkDCF.Checked := true;
    edtF.ReadOnly := false;

  end;

  // Загрузка параметра работы функции GetXValue
  case Device.savedata[22] of
    '0':
      self.rbXB0.Checked := true;
    '1':
      self.rbXB1.Checked := true;
  else
    self.rbXBr.Checked := true;
  end;

  // PIC10F200/202/204/206
  if (Device.RCModel = 'PIC10F200') or (Device.RCModel = 'PIC10F202') or
    (Device.RCModel = 'PIC10F204') or (Device.RCModel = 'PIC10F206') then
    {$REGION 'PIC10F200/202/204/206'}
  begin

    // БИТЫ КОНФИГУРАЦИИ
    pnlCfg20x.Visible := true;
    // Хинты для полей
    self.lbl20xWDTE.Hint := Gettext(20);
    self.lbl20xCP.Hint := Gettext(21);
    self.lbl20xMCLR.Hint := Gettext(22);
    self.cmb20xWDTE.Hint := Gettext(20);
    self.cmb20xCP.Hint := Gettext(21);
    self.cmb20xMCLR.Hint := Gettext(22);
    // Значения полей
    self.cmb20xWDTE.Items[0] := Gettext(ConfigBits[0].Value0Id);
    self.cmb20xWDTE.Items[1] := Gettext(ConfigBits[0].Value1Id);
    if Config[ConfigBits[0].No] then
      self.cmb20xWDTE.ItemIndex := 1
    else
      self.cmb20xWDTE.ItemIndex := 0;
    self.cmb20xCP.Items[0] := Gettext(ConfigBits[1].Value0Id);
    self.cmb20xCP.Items[1] := Gettext(ConfigBits[1].Value1Id);
    if Config[ConfigBits[1].No] then
      self.cmb20xCP.ItemIndex := 1
    else
      self.cmb20xCP.ItemIndex := 0;
    self.cmb20xMCLR.Items[0] := Gettext(ConfigBits[2].Value0Id);
    self.cmb20xMCLR.Items[1] := Gettext(ConfigBits[2].Value1Id);
    if Config[ConfigBits[2].No] then
      self.cmb20xMCLR.ItemIndex := 1
    else
      self.cmb20xMCLR.ItemIndex := 0;
  end;
  {$ENDREGION}
  // PIC10F220/222
  if (Device.RCModel = 'PIC10F220') or (Device.RCModel = 'PIC10F222') then
  {$REGION 'PIC10F220/222'}
  begin

    // БИТЫ КОНФИГУРАЦИИ
    pnlCfg22x.Visible := true;
    // Хинты для полей
    self.lbl22xWDTE.Hint := Gettext(20);
    self.lbl22xCP.Hint := Gettext(21);
    self.lbl22xMCLRE.Hint := Gettext(22);
    self.cmb22xWDTE.Hint := Gettext(20);
    self.cmb22xCP.Hint := Gettext(21);
    self.cmb22xMCLRE.Hint := Gettext(22);
    // Значения полей
    self.cmb22xWDTE.Items[0] := Gettext(ConfigBits[2].Value0Id);
    self.cmb22xWDTE.Items[1] := Gettext(ConfigBits[2].Value1Id);
    if Config[ConfigBits[2].No] then
      self.cmb22xWDTE.ItemIndex := 1
    else
      self.cmb22xWDTE.ItemIndex := 0;

    self.cmb22xCP.Items[0] := Gettext(ConfigBits[3].Value0Id);
    self.cmb22xCP.Items[1] := Gettext(ConfigBits[3].Value1Id);
    if Config[ConfigBits[3].No] then
      self.cmb22xCP.ItemIndex := 1
    else
      self.cmb22xCP.ItemIndex := 0;

    self.cmb22xMCLRE.Items[0] := Gettext(ConfigBits[4].Value0Id);
    self.cmb22xMCLRE.Items[1] := Gettext(ConfigBits[4].Value1Id);
    if Config[ConfigBits[4].No] then
      self.cmb22xMCLRE.ItemIndex := 1
    else
      self.cmb22xMCLRE.ItemIndex := 0;

    self.cmb22xMCPU.Items[0] := Gettext(ConfigBits[1].Value0Id);
    self.cmb22xMCPU.Items[1] := Gettext(ConfigBits[1].Value1Id);
    if Config[ConfigBits[1].No] then
      self.cmb22xMCPU.ItemIndex := 1
    else
      self.cmb22xMCPU.ItemIndex := 0;

    self.cmb22xIOSCFS.Items[0] := Gettext(ConfigBits[0].Value0Id);
    self.cmb22xIOSCFS.Items[1] := Gettext(ConfigBits[0].Value1Id);
    if Config[ConfigBits[0].No] then
      self.cmb22xIOSCFS.ItemIndex := 1
    else
      self.cmb22xIOSCFS.ItemIndex := 0;
  end;
  {$ENDREGION}
  // PIC12Fххх
  {$REGION 'PIC12Fххх'}
  if (Device.RCModel = 'PIC12F508') or (Device.RCModel = 'PIC12F509') or
    (Device.RCModel = 'PIC12F510') or (Device.RCModel = 'PIC12F519') then
  begin

    // Включить видимость некоторых битов конфигурации для некоторых моделей МК
    if (Device.RCModel = 'PIC12F510') or (Device.RCModel = 'PIC12F519') then
    begin
      self.lbl12FIOSCFS.Enabled := true;
      self.cmb12FIOSCFS.Enabled := true;
    end;
    if (Device.RCModel = 'PIC12F519') then
    begin
      self.lbl12FCPDF.Enabled := true;
      self.cmb12FCPDF.Enabled := true;
    end;
    // Особенности панели "расширенные настройки тактовой частоты"
    lblTCF.Caption := Gettext(208);
    chkDCF.Visible := false;
    lbldcf.Visible := true;
    // БИТЫ КОНФИГУРАЦИИ
    pnlCfg12F.Visible := true;
    // Хинты для полей
    self.lbl12FCPDF.Hint := Gettext(26);
    self.lbl12FIOSCFS.Hint := Gettext(23);
    self.lbl12FMCLRE.Hint := Gettext(22);
    self.lbl12FCP.Hint := Gettext(21);
    self.lbl12FWDTE.Hint := Gettext(20);
    self.lbl12FFosc1.Hint := Gettext(25);
    self.lbl12FFosc0.Hint := Gettext(25);

    self.cmb12FCPDF.Hint := Gettext(26);
    self.cmb12FIOSCFS.Hint := Gettext(23);
    self.cmb12FMCLRE.Hint := Gettext(22);
    self.cmb12FCP.Hint := Gettext(21);
    self.cmb12FWDTE.Hint := Gettext(20);
    self.cmb12FFosc1.Hint := Gettext(25);
    self.cmb12FFosc0.Hint := Gettext(25);

    // Значения полей
    self.cmb12FCPDF.Items[0] := Gettext(ConfigBits[6].Value0Id);
    self.cmb12FCPDF.Items[1] := Gettext(ConfigBits[6].Value1Id);
    if Config[ConfigBits[6].No] then
      self.cmb12FCPDF.ItemIndex := 1
    else
      self.cmb12FCPDF.ItemIndex := 0;

    self.cmb12FIOSCFS.Items[0] := Gettext(ConfigBits[5].Value0Id);
    self.cmb12FIOSCFS.Items[1] := Gettext(ConfigBits[5].Value1Id);
    if Config[ConfigBits[5].No] then
      self.cmb12FIOSCFS.ItemIndex := 1
    else
      self.cmb12FIOSCFS.ItemIndex := 0;

    self.cmb12FMCLRE.Items[0] := Gettext(ConfigBits[4].Value0Id);
    self.cmb12FMCLRE.Items[1] := Gettext(ConfigBits[4].Value1Id);
    if Config[ConfigBits[4].No] then
      self.cmb12FMCLRE.ItemIndex := 1
    else
      self.cmb12FMCLRE.ItemIndex := 0;

    self.cmb12FCP.Items[0] := Gettext(ConfigBits[3].Value0Id);
    self.cmb12FCP.Items[1] := Gettext(ConfigBits[3].Value1Id);
    if Config[ConfigBits[3].No] then
      self.cmb12FCP.ItemIndex := 1
    else
      self.cmb12FCP.ItemIndex := 0;

    self.cmb12FWDTE.Items[0] := Gettext(ConfigBits[2].Value0Id);
    self.cmb12FWDTE.Items[1] := Gettext(ConfigBits[2].Value1Id);
    if Config[ConfigBits[2].No] then
      self.cmb12FWDTE.ItemIndex := 1
    else
      self.cmb12FWDTE.ItemIndex := 0;

    self.cmb12FFosc1.Items[0] := Gettext(ConfigBits[1].Value0Id);
    self.cmb12FFosc1.Items[1] := Gettext(ConfigBits[1].Value1Id);
    if Config[ConfigBits[1].No] then
      self.cmb12FFosc1.ItemIndex := 1
    else
      self.cmb12FFosc1.ItemIndex := 0;

    self.cmb12FFosc0.Items[0] := Gettext(ConfigBits[0].Value0Id);
    self.cmb12FFosc0.Items[1] := Gettext(ConfigBits[0].Value1Id);
    if Config[ConfigBits[0].No] then
      self.cmb12FFosc0.ItemIndex := 1
    else
      self.cmb12FFosc0.ItemIndex := 0;
    // Чтобы изменилось "результирующее" поле, где указан источник тактового сигнала
    ChangeFrqBit12F;

  end;
  {$ENDREGION}
 // PIC16F5x
  {$REGION 'PIC16F5x'}
  if (Device.RCModel = 'PIC16F54') or (Device.RCModel = 'PIC16F57') or
    (Device.RCModel = 'PIC16F59') then
  begin


    // Особенности панели "расширенные настройки тактовой частоты"
    lblTCF.Caption := Gettext(208);
    chkDCF.Visible := false;
    lbldcf.Visible := true;
    // БИТЫ КОНФИГУРАЦИИ
    pnlCfg5x.Visible := true;
    // Хинты для полей
    self.lbl5xCP.Hint := Gettext(21);
    self.lbl12FWDTE.Hint := Gettext(20);
    self.lbl12FFosc1.Hint := Gettext(27);
    self.lbl12FFosc0.Hint := Gettext(27);


    self.cmb5xCP.Hint := Gettext(21);
    self.cmb5xWDTE.Hint := Gettext(20);
    self.cmb5xFosc1.Hint := Gettext(27);
    self.cmb5xFosc0.Hint := Gettext(27);

    // Значения полей

    self.cmb5xCP.Items[0] := Gettext(ConfigBits[3].Value0Id);
    self.cmb5xCP.Items[1] := Gettext(ConfigBits[3].Value1Id);
    if Config[ConfigBits[3].No] then
      self.cmb5xCP.ItemIndex := 1
    else
      self.cmb5xCP.ItemIndex := 0;

    self.cmb5xWDTE.Items[0] := Gettext(ConfigBits[2].Value0Id);
    self.cmb5xWDTE.Items[1] := Gettext(ConfigBits[2].Value1Id);
    if Config[ConfigBits[2].No] then
      self.cmb5xWDTE.ItemIndex := 1
    else
      self.cmb5xWDTE.ItemIndex := 0;

    self.cmb5xFosc1.Items[0] := Gettext(ConfigBits[1].Value0Id);
    self.cmb5xFosc1.Items[1] := Gettext(ConfigBits[1].Value1Id);
    if Config[ConfigBits[1].No] then
      self.cmb5xFosc1.ItemIndex := 1
    else
      self.cmb5xFosc1.ItemIndex := 0;

    self.cmb5xFosc0.Items[0] := Gettext(ConfigBits[0].Value0Id);
    self.cmb5xFosc0.Items[1] := Gettext(ConfigBits[0].Value1Id);
    if Config[ConfigBits[0].No] then
      self.cmb5xFosc0.ItemIndex := 1
    else
      self.cmb5xFosc0.ItemIndex := 0;
    // Чтобы изменилось "результирующее" поле, где указан источник тактового сигнала
    ChangeFrqBit5x;

  end;
  {$ENDREGION}




end;


procedure TformSettings.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Handle := OrigHandle;
end;

end.
