unit frmDevices;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,unitres, Vcl.StdCtrls, Vcl.Grids,
  Vcl.ValEdit,ChildComp,unitDev;

type
  TformDevices = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  formDevices: TformDevices;


implementation

{$R *.dfm}

procedure TformDevices.FormCreate(Sender: TObject);
begin
caption:=gettext(9);
end;

end.
