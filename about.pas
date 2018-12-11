unit about;

interface

uses Windows, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls,unitres, Vcl.Imaging.pngimage,shellapi,unitweb,sysutils;

type
  TAboutBox = class(TForm)
    OKButton: TButton;
    Image2: TImage;
    Image3: TImage;
    Label1: TLabel;
    Shape1: TShape;
    Image4: TImage;
    lblPrgVer: TLabel;
    lblCopyright: TLabel;
    Label3: TLabel;
    memoLic: TMemo;
    lblLink: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure lblLinkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutBox: TAboutBox;

implementation

{$R *.dfm}

procedure TAboutBox.FormCreate(Sender: TObject);
var v1,v2,v3,v4:byte;
begin
//Загрузка текстовых ресурсов
caption:=unitres.GetText(2);
unitweb.GetVersion(v1,v2,v3,v4);
lbllink.Caption:=Gettext(0);
self.lblPrgVer.Caption:=unitres.GetText(1)+ ' '+Gettext(3500)+' '+ inttostr(v1)+'.'+inttostr(v2)+'.'+inttostr(v3) ;
end;

procedure TAboutBox.lblLinkClick(Sender: TObject);
begin
ShellExecute(handle,'open','http://at-control.com',nil,nil,SW_SHOWNORMAL);
end;

end.

