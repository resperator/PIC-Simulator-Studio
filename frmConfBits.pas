unit frmConfBits;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls,unitres;

type
  TfrmConfigBits = class(TForm)
    RT: TRichEdit;
    btnCancel: TButton;
    Button1: TButton;
    scrl: TScrollBar;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  var
  aTxt:array[0..9] of TEdit;
  aCmb:array[0..9] of TCombobox;

  public
    { Public declarations }
  end;

var
  frmConfigBits: TfrmConfigBits;

implementation
uses main;
{$R *.dfm}

procedure TfrmConfigBits.btnCancelClick(Sender: TObject);
begin
frmConfigBits.Close;
end;

procedure TfrmConfigBits.Button1Click(Sender: TObject);
var
Z,Cbc:integer;
vName,vDescription,vValue0,vValue1:shortstring;
vNo:integer;
begin
Cbc:=Get_ConfigBitsCounter();
for Z := 1 to Cbc do
  begin
  Get_ConfigBits(Z-1,vName,vValue0,vValue1,vNo);
 if aCMB[Z-1].ItemIndex=0 then Set_Config(vNo,false) else Set_Config(vNo,true);
  end;

 frmConfigBits.Close;
end;

procedure TfrmConfigBits.FormActivate(Sender: TObject);
var Z,Cbc:integer;
vName,vDescription,vValue0,vValue1:shortstring;
vNo:integer;
begin
//Сперва очистим все поля
RT.Text:='';
for Z := 0 to 9 do
  begin
  aTXT[Z].Text:='';
  aCmb[Z].Items.Text:='';
  aCmb[Z].Text:='';
  aTXT[z].Enabled:=false;
  aCMB[z].Enabled:=false;
  end;
Cbc:=Get_configBitsCounter();
for Z := 1 to Cbc do
  begin
  Get_ConfigBits(Z-1,vName,vValue0,vValue1,vNo);
  aTXT[Z-1].Text:=vName;
  aTXT[z-1].Enabled:=true;
  aCMB[Z-1].Items.add(vValue0);
  aCMB[z-1].Items.add(vValue1);
  aCMB[z-1].Enabled:=true;
  if Get_Config(vNo)=true then aCMB[z-1].ItemIndex:=1 else aCMB[z-1].ItemIndex:=0  //aCMB[z-1].Text:=ConfigBits[Z-1].Value1 else aCMB[z-1].Text:=ConfigBits[Z-1].Value0;

  end;

end;

procedure TfrmConfigBits.FormCreate(Sender: TObject);
var Z:integer;
begin
caption:=Gettext(6);
button1.Caption:=gettext(101);
btncancel.Caption:=gettext(102);
for Z := 0 to 9 do
  begin
  aTxt[Z]:=TEdit.Create(frmConfigBits);
  aCmb[Z]:=TCombobox.Create(frmConfigBits);
  aTxt[Z].Left:=0;
  aTxt[Z].Width:=250;
  aTxt[Z].Height:=21;
  aTxt[Z].Top:=16+(Z*27);
  aTxt[Z].Parent:=frmConfigBits;
  aTxt[Z].Enabled:=false;
  aCmb[Z].Left:=256;
  aCmb[Z].Width:=178;
  aCmb[Z].Top:=16+(Z*27);
  aCmb[Z].Parent:=frmConfigBits;
  aCmb[Z].Enabled:=false;
  aCmb[Z].Style:=csOwnerDrawVariable;


  end;

end;

end.
