unit frmSplash;

interface

uses
  Vcl.Imaging.pngimage, System.Classes, Vcl.Controls, Vcl.ExtCtrls, Vcl.forms,
  Vcl.dialogs, SysUtils, main, unitDev, IOUtils, UnitRegistry,
  unitres, Vcl.StdCtrls, frmShareware;

type
  TformSplash = class(TForm)
    Image1: TImage;
    Memo: TMemo;
    tmrClose: TTimer;
    X: TButton;
    procedure Image1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure tmrCloseTimer(Sender: TObject);
    procedure XClick(Sender: TObject);
    procedure MemoChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  formSplash: TformSplash;

implementation

{$R *.dfm}

var
  isRun: boolean = false;
  vErr: boolean = false;

procedure TformSplash.FormActivate(Sender: TObject);
var
  i: integer;
var
  dy, dm, dd: word;
label lblterm;
begin
  // Для предотвращения повторного запуска этого кода (процедуры)
  if isRun then
    exit;
  isRun := true;
  // Начальная инициализация
  Memo.Lines.Add(GetText(2000));
  application.processmessages;
  // проверка регистрации
  Memo.Lines.Add(GetText(2001));
  application.processmessages;
  DecodeDate(SysUtils.Date, dy, dm, dd);
 { if dy > 2016 then
  begin

    frmShareware.formShareware.ShowModal;
    //
    application.Terminate;

  end;}

  // Поиск и загрузка всех необходимых устройств
  FindAndLoadDevices(Memo, ExtractFilePath(application.ExeName));

  // showmessage(ExtractFilePath(Application.ExeName ));
  // showmessage(TPath.GetRandomFileName);

  // UnitRegistry.SearchFiles(TPath.GetTempPath(),'*.tmp',true);
  if ParamCount = 0 then
    tmrClose.Interval := 1000;

  tmrClose.Enabled := true;

end;

procedure TformSplash.Image1Click(Sender: TObject);
begin
  // main.mainform.show();
  // DevLibCount:=100;
  tmrClose.Enabled := not tmrClose.Enabled;
  if not tmrClose.Enabled then
    X.Visible := true
  else
    X.Visible := false;

end;

procedure TformSplash.MemoChange(Sender: TObject);
var
  tp: string;
begin
  if vErr then
    exit;
  tp := TPath.GetTempPath();
  if Copy(tp, length(tp), 1) <> '\' then
    tp := tp + '\';
  tp := tp + 'AT-Control.com Simulator PIC Baseline edition';

  // ExtractFilePath(Application.ExeName ) - было вместо TPath.Get..., но нужны права
  if tdirectory.Exists(tp, false) = false then
    tdirectory.CreateDirectory(tp);
  tp := tp + '\CrashLog.txt';
  try
    Memo.Lines.SaveToFile(tp);
  except
    vErr := true;
    Memo.Lines.Add(GetText(1011) + ' ' + tp);
  end;

end;

procedure TformSplash.tmrCloseTimer(Sender: TObject);
begin
  tmrClose.Enabled := false;
  self.Close;
end;

procedure TformSplash.XClick(Sender: TObject);
begin
  Image1Click(Sender);
end;

end.
