unit frmOpen;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, DockTabSet, Tabs, StdCtrls;

type
  Tfrmopn = class(TForm)
    Button2: TButton;
    Button1: TButton;
    grpHexSelectMC: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    cbHexSelectFamily: TComboBox;
    cbHexSelectMC: TComboBox;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbHexSelectFamilyChange(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure cbHexSelectMCChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    var TypeOfCall:Byte; //Тип вызова, например 1 - New File 2 - Open ASM 3- Open Hex
    var NameOfImportFile:string;


  end;

var
  frmopn: Tfrmopn;

implementation
uses UnitRes,main,RVGetText,unitDev,unitformat;

{$R *.dfm}

procedure Tfrmopn.Button1Click(Sender: TObject);
var
  I: Integer;
  J: Integer;


begin
if cbHexSelectMC.Text ='' then
begin
SHOWMESSAGE(GetText(2010));
exit;
end;
button1.Enabled:=false; //Была проблема, что можно было нажать кнопку 2 раза и получить много окон, поэтому так
for I := Low(AInfoDevice) to High(AInfoDevice) do
  for J := Low(AInfoDevice[I].vSModel) to High(AInfoDevice[I].vSModel) do
   if  (AInfoDevice[I].vSModel[J]=cbHexSelectMC.Text) and (AInfoDevice[I].vSType+' '+AInfoDevice[I].vSFamily=cbHexSelectFamily.Text) then
   begin
   unitdev.CurrentDevice:=I;
   unitDev.CurrentSubDevice:=J;
   end;
   main.MainForm.LoadDllMC();



  //SD - ok!

  { create a new MDI child window }

    case TypeOfCall of
      1: //New File
        begin
        CreateNewASMWindow('');
        CreateDefaultMK(main.MainForm.CompChild);
        FormatAndSyntRVE();

        end;
      2: //ASM
        begin
        CreateNewASMWindow('');
        CreateDefaultMK(main.MainForm.CompChild);
        main.MainForm.AsmChild.rve.LoadText( NameOfImportFile,0,0,true );
        FormatAndSyntRVE();
        end;
      3: //HEX
        begin
        CreateNewASMWindow('');
        CreateDefaultMK(main.MainForm.CompChild);
        if not LoadHex(NameOfImportFile) then
          begin
           showmessage(ErrorText);
           main.MainForm.asmchild.Close;
           main.MainForm.asmchild.free;
           main.mainform.AsmWindowOpen:=false;
           exit;
          end;
        main.MainForm.AsmChild.DisAssembley;
        FormatAndSyntRVE();
        end;
      4://ATCSS
        begin

        end;
    end;



application.ProcessMessages;
EndRefresh:=true;
main.MainForm.ShowAllRegAndCounters;
//main.MainForm.tmrRefresh.Enabled:=true;
frmopn.Close;


end;

procedure Tfrmopn.Button2Click(Sender: TObject);
begin
self.Close;
end;

procedure Tfrmopn.cbHexSelectFamilyChange(Sender: TObject);
var
  I: Integer;
  J: Integer;
begin

cbHexSelectMC.Clear;
for I := Low(AInfoDevice) to High(AInfoDevice) do
begin
if (AInfoDevice[I].vSType+' '+AInfoDevice[I].vSFamily)=cbHexSelectFamily.Text then
  for J :=low(AInfoDevice[I].vSModel)  to High(AInfoDevice[I].vSModel) do  cbHexSelectMC.Items.Add (AInfoDevice[I].vSModel[J]);
end;
cbHexSelectMC.ItemIndex:=0;


end;

procedure Tfrmopn.cbHexSelectMCChange(Sender: TObject);
begin
if (cbhexselectmc.Text='PIC12F519') or (cbhexselectmc.Text='PIC16F505') or (cbhexselectmc.Text='PIC16F506') or (cbhexselectmc.Text='PIC16F526')  then
begin
  button1.Enabled:=false;
  label3.visible:=true;
end
else
begin
  button1.Enabled:=true;
  label3.visible:=false;
end;

end;

procedure Tfrmopn.FormActivate(Sender: TObject);
begin
button1.Enabled:=true;
end;

procedure Tfrmopn.FormCreate(Sender: TObject);
var i,j:integer;
CurFamily:shortstring;
tmpFlag:boolean;

begin
caption:=gettext(5);
button1.Caption:=gettext(101);
button2.Caption:=gettext(102);
grpHexSelectMC.Caption:=gettext(400);
label1.Caption:=gettext(401);
label2.Caption:=gettext(402);
label3.Caption:=gettext(403);
//Добавим все семейства которые есть, исключив повторы
for I := Low(AInfoDevice) to High(AInfoDevice) do
   if AInfoDevice[I].vType=0 then
   begin
     tmpFlag:=false; //false означает, что элемента, котор. мы хотим добавить в списке еще нет

     for j := 0 to  cbHexSelectFamily.Items.Count-1  do if cbHexSelectFamily.Items[j]=AInfoDevice[I].vSType+' '+AInfoDevice[I].vSFamily then tmpFlag:=true;
     if not tmpFlag then cbHexSelectFamily.Items.Add(AInfoDevice[I].vSType+' '+AInfoDevice[I].vSFamily );
   end;



cbHexSelectFamily.Sorted:=true;  //Сортируем
cbHexSelectFamily.ItemIndex:=0;  //Выделяем первый по списку
cbHexSelectFamily.OnChange(self.cbHexSelectFamily); //Вызовим событие onChange
cbHexSelectMC.OnChange(self.cbHexSelectMC);
end;

end.
