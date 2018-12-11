unit frmNodes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, unitRes, ChildComp, unitDev, Vcl.Grids,
  Vcl.ValEdit, Vcl.StdCtrls, unitClasses4Devices;

type
  TformNodes = class(TForm)
    list: TValueListEditor;
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure listKeyPress(Sender: TObject; var Key: Char);
    procedure listGetPickList(Sender: TObject; const KeyName: string;
      Values: TStrings);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  formNodes: TformNodes;

  myParentForm: TfrmChildComp;
  CurrentDevice: Integer;

implementation

{$R *.dfm}

procedure TformNodes.Button1Click(Sender: TObject);
begin
  self.Close;
end;

procedure TformNodes.Button2Click(Sender: TObject);
var
  I, J, Z, K, L: Integer; // Все для циклов
  tmpNode: TNode;
  tmpPorts: TRCPorts;
label lblZanovo;
begin
  for I := 1 to list.Strings.Count do
  begin
    // Найдем узел по списку справа
    tmpNode := nil;
    for J := Low(unitDev.Nodes) to High(unitDev.Nodes) do
      if unitDev.Nodes[J].Ports[0].PortName = list.Cells[1, I] then
        tmpNode := unitDev.Nodes[J];
    // Нашли, он в tmpNode
    // В порте сделаем ссыль на ноду
    unitDev.Devices[CurrentDevice].Port[I - 1].Node := tmpNode;
    // Во всех нодах удалим этот порт
  lblZanovo:
    for J := Low(Nodes) to High(Nodes) do
      for Z := Low(Nodes[J].Ports) to High(Nodes[J].Ports) do
        if Nodes[J].Ports[Z] = unitDev.Devices[CurrentDevice].Port[I - 1] then
        begin // Нашли текущий порт в какой-то ноде, удаляем
          SetLength(tmpPorts, 0);
          L := 0;
          SetLength(tmpPorts, High(Nodes[J].Ports));
          for K := 0 to High(Nodes[J].Ports) do
            if Z <> K then
            begin
              tmpPorts[L] := Nodes[J].Ports[K];
              L := L + 1;
            end;
          Nodes[J].Ports := tmpPorts;
          goto lblZanovo;
        end;

    // В нужную ноду добавим ссыль на порт (если нода найдена)
    if tmpNode = nil then
      continue;

    SetLength(tmpNode.Ports, high(tmpNode.Ports) + 2);
    tmpNode.Ports[high(tmpNode.Ports)] := unitDev.Devices[CurrentDevice]
      .Port[I - 1];
    // list.ItemProps[I-1].

  end;
  self.Close;
end;

procedure TformNodes.FormCreate(Sender: TObject);
begin
  caption := gettext(10);
  button1.Caption:=gettext(102);
  button2.Caption:=gettext(101);
  list.TitleCaptions[0]:=GetText(3120);
    list.TitleCaptions[1]:=GetText(3121);
end;

procedure TformNodes.FormShow(Sender: TObject);
var
  I: Integer;
  tmpNodeName: string;
begin
  // Очищаем от гомна
  for I := list.Strings.Count downto 1 do
    list.DeleteRow(I);
  // Создаем список (слева порты данного устройства, справа - его нода)
  for I := low(unitDev.Devices[CurrentDevice].Port)
    to High(unitDev.Devices[CurrentDevice].Port) do
  begin
    tmpNodeName := '[N/C]';
    if assigned(unitDev.Devices[CurrentDevice].Port[I].Node) then
      tmpNodeName := unitDev.Devices[CurrentDevice].Port[I].Node.Ports
        [0].PortName;
    list.InsertRow(unitDev.Devices[CurrentDevice].Port[I].PortName,
      tmpNodeName, true);
  end;
  for I := 0 to list.RowCount - 2 do
  begin
    list.ItemProps[I].EditStyle := esPickList; // esEllipsis
    // list.EditorMode
  end;

end;

procedure TformNodes.listGetPickList(Sender: TObject; const KeyName: string;
  Values: TStrings);
var
  I: Integer;
begin
  Values.Add('[N/C]');
  for I := Low(unitDev.Nodes) to High(unitDev.Nodes) do
    Values.Add(unitDev.Nodes[I].Ports[0].PortName);
end;

procedure TformNodes.listKeyPress(Sender: TObject; var Key: Char);
begin
  // Запрещает редактирование, но можно вырезать
  // key:=chr(0);

end;

end.
