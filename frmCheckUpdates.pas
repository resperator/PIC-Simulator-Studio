unit frmCheckUpdates;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, unitWeb, Vcl.ComCtrls, IdHTTP, IdComponent, UnitRegistry, ShellApi,
  Vcl.ExtCtrls,unitres, Wininet;
Const MY_MESS = WM_USER + 100;
var CanShow, CHK_Complite:boolean;
type
  TformCheckUpdates = class(TForm)
    Memo1: TMemo;
    ChkDontCheck: TCheckBox;
    btnDownNInst: TButton;
    btnCancel: TButton;
    ProgressBar1: TProgressBar;
    SaveDialog1: TSaveDialog;
    tmrCanShow: TTimer;
    procedure FormActivate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnDownNInstClick(Sender: TObject);
    procedure ChkDontCheckClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tmrCanShowTimer(Sender: TObject);
  private
    { Private declarations }
    co:unitWeb.ThreadWebUpd;
  public
    { Public declarations }
    procedure thrTerminate(Sender:TObject);
    procedure MyProgress(var msg:TMessage);message MY_MESS;
  end;

var
  formCheckUpdates: TformCheckUpdates;

implementation
var dwn_from, dwn_to:string;

{$R *.dfm}
type
  TDownLoader = class(TThread)
  private
    FToFolder: string;
    FURL: string;
    protected
      procedure Execute;override;
    public
      property URL:string read FURL write FURL;
      property ToFolder:string read FToFolder write FToFolder;
      procedure IdHTTP1Work(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCount: Int64);
      procedure IdHTTP1WorkBegin(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCountMax: Int64);
    procedure IdHTTP1WorkEnd(ASender: TObject; AWorkMode: TWorkMode);
  end;

procedure TformCheckUpdates.btnCancelClick(Sender: TObject);
begin
formCheckUpdates.Close;
end;

procedure TformCheckUpdates.btnDownNInstClick(Sender: TObject);
var S,Sm:string;
d:TDownLoader;
begin
ShellExecute(handle,'open','http://at-control.com/downloads.html',nil,nil,SW_SHOWNORMAL);
exit;
//Код ниже был для скачки в автоматическом режиме
S:=GetLastLink();
Sm:=Copy(S,1,2);
if Sm='e0' then
  begin
    showmessage(gettext(2051));
    exit;
  end;
if Sm='e1' then
  begin
    showmessage(gettext(2053));
    exit;
  end;
if Sm='e2' then
  begin
    showmessage(gettext(2054));
    exit;
  end;
if Sm='ln' then
  begin
  dwn_from:=copy(S,3,Length(S)-2);
  SaveDialog1.FileName:=copy(dwn_from,LastDelimiter('\/',dwn_from)+1,maxint);
  if SaveDialog1.Execute then
  begin
     dwn_to:=SaveDialog1.FileName;
    //Создадим класс потока.
  //Поток для начала будет остановлен
  btnDownNInst.Visible:=false;
  d:=TDownLoader.Create(true);
  //Передадим параметры потоку
  d.URL:=dwn_from;
  d.ToFolder:=dwn_to;
  //Поток должен удалить себя по завершению своей работы
  d.FreeOnTerminate:=true;
  d.OnTerminate:=thrTerminate;
  //И запустим его на закачку.
  d.start;
  //Теперь с процедуры мы выйдем, но поток работает
  //и живёт своей жизней
  end;
  end;

end;

procedure TformCheckUpdates.ChkDontCheckClick(Sender: TObject);
begin
UnitRegistry.WriteBool(10,chkdontCheck.Checked);
end;

procedure TformCheckUpdates.FormActivate(Sender: TObject);

begin
//formcheckupdates.btnDownNInst.Enabled:=false;
if CHK_Complite then exit;

co:=unitWeb.ThreadWebUpd.Create(true);
co.FreeOnTerminate:=true; //Добавил 23.04.2014
co.Start;

end;

procedure TformCheckUpdates.FormCreate(Sender: TObject);
begin
caption:=Gettext(8);
btnDownNInst.caption:=gettext(107);
btnCancel.Caption:=Gettext(106);
ChkDontCheck.Caption:=Gettext(3150);
formCheckUpdates.ChkDontCheck.Checked:=Unitregistry.readbool(10);
if formCheckUpdates.ChkDontCheck.Checked=true  then
  begin
  CanShow:=false;
  co:=unitWeb.ThreadWebUpd.Create(true);
co.FreeOnTerminate:=true; //Добавил 23.04.2014
co.Start;
tmrCanshow.Enabled:=true;

  end;
end;

procedure TformCheckUpdates.MyProgress(var msg: TMessage);
begin
  case msg.WParam of
  0:begin ProgressBar1.Max:=msg.LParam;ProgressBar1.Position:=0; end;
  1:ProgressBar1.Position:=msg.LParam;
  end;
end;

procedure TformCheckUpdates.thrTerminate(Sender: TObject);
var cod:byte;
h: hwnd;
begin
cod:=ShellExecute(h,'Open',PWideChar(dwn_to), nil, nil, SW_SHOW);
if cod<32 then
begin
  cod:=WinExec(PAnsiChar(dwn_to), SW_Restore);
  case cod of
  0: ShowMessage(gettext(2059)); //Не хватает ресурсов
  2: ShowMessage(gettext(2060)); //Файл не найден
  3: ShowMessage(gettext(2061)); // Путь не найден
  end;
end;
btnDownNInst.Visible:=true;
end;

procedure TformCheckUpdates.tmrCanShowTimer(Sender: TObject);
begin
if CanShow=true then
begin
  canShow:=false;
  tmrCanShow.Enabled:=false;
  if not formCheckUpdates.Showing then formCheckUpdates.Show;
end;
end;

procedure TDownLoader.Execute;
const
  BufferSize = 1024;
var
  hSession, hURL: HInternet;
  Buffer: array[1..BufferSize] of Byte;
  BufferLen: DWORD;
  f: file;
  sAppName: string;
begin
//  Result := False;


  sAppName := ExtractFileName(Application.ExeName);
  hSession := InternetOpen(PChar(sAppName),
  INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  try
    hURL := InternetOpenURL(hSession, PChar(URL), nil, 0, 0, 0);
    try
      AssignFile(f, ToFolder);
      Rewrite(f,1);
      repeat
        InternetReadFile(hURL, @Buffer, SizeOf(Buffer), BufferLen);
        BlockWrite(f, Buffer, BufferLen);


      until
        BufferLen = 0;
      CloseFile(f);
      //Result := True;
    finally
      InternetCloseHandle(hURL);
    end;
  finally
    InternetCloseHandle(hSession);
  end;

//Ниже - старая версия загрузчика, работала гуд, но че-то возникла как-то проблемма ошибка 403, можно вернуть - удалить все выше
//до названия ф-ии (исключая его), а снизу убрать фигурнные скобки
//Код выше заместо нижнего был вставлен 09.02.2015
{  var http:TIdHTTP;
      str:TFileStream;

begin
  //Создим класс для закачки
  http:=TIdHTTP.Create(nil);
  http.OnWork:=IdHTTP1Work;
  http.OnWorkBegin:=IdHTTP1WorkBegin;
  http.OnWorkEnd:=IdHTTP1WorkEnd;
  //каталог, куда файл положить
  ForceDirectories(ExtractFileDir(ToFolder));
  //Поток для сохранения
  str:=TFileStream.Create(ToFolder, fmCreate);
  try
    //Качаем
    http.Get(url,str);
  finally
    //Нас учили чистить за собой
    http.Free;
    str.Free;
  end;}
end;



procedure TDownLoader.IdHTTP1Work(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
begin
  PostMessage(formCheckUpdates.Handle,MY_MESS,1,AWorkCount);
end;

procedure TDownLoader.IdHTTP1WorkBegin(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCountMax: Int64);
begin
  PostMessage(formCheckUpdates.Handle,MY_MESS,0,AWorkCountMax);
end;

procedure TDownLoader.IdHTTP1WorkEnd(ASender: TObject; AWorkMode: TWorkMode);
begin
//
end;


end.
