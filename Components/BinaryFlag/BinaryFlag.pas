unit BinaryFlag;

interface

uses
  SysUtils, Classes, Controls, ExtCtrls,Graphics;

type
  TBinaryFlag = class(TImage)
  private
    { Private declarations }
    FValue:boolean;
    FReadOnly:Boolean;
    FDelta:boolean;
    FAddr:Integer;
    FBit:byte;
    function GetVal:boolean;
    procedure SetVal(value:boolean);
    function GetRO:boolean;
    procedure SetRO(value:boolean);
    function GetDelta:boolean;
    procedure SetDelta(value:boolean);
    function GetAddr:integer;
    procedure SetAddr(value:integer);
    function GetBit:byte;
    procedure SetBit(value:byte);
  protected
    { Protected declarations }
    procedure Click;override;
  public
    { Public declarations }
  published
    { Published declarations }
    constructor Create(AOwner:TComponent); override;
    property value:boolean
              read GetVal
              write SetVal
              default false;
    property ReadOnl:boolean
              read GetRO
              write SetRO
              default false;
    property Delta:boolean
              read GetDelta
              write SetDelta
              default false;
    Property ByteAddres:integer
              read GetAddr
              write SetAddr;
    property BitAddres:byte
              read GetBit
              write SetBit;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TBinaryFlag]);
end;
constructor TBinaryFlag.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  FValue:=false;
  FReadOnly:=False;
  FDelta:=false;
  FAddr:=0;
  FBit:=0;
end;

function TBinaryFlag.GetAddr:integer;
begin
  result:=FAddr;
end;
procedure TBinaryFlag.SetAddr(value:integer);
begin
  Faddr:=value;
end;
function TBinaryFlag.GetBit:byte;
begin
  result:=FBit;
end;
procedure TBinaryFlag.SetBit(value:byte);
begin
  FBit:=value;
end;
function TBinaryFlag.GetVal:boolean;
begin
  result:=FValue;
end;
procedure TBinaryFlag.SetVal(value:boolean);
begin
  Fvalue:=value;
 //Стандартная прорисовка
  if  Fdelta then
    canvas.Pen.Color:=clRed
    else
    if not FReadOnly then canvas.Pen.Color:=clGray else canvas.Pen.Color:=clltGray;
  if not FReadOnly then
    if FValue then canvas.Brush.Color:=2631720 else canvas.Brush.Color:=15132390
  else
    if FValue then canvas.Brush.Color:=clblack else canvas.Brush.Color:=clwhite;
    canvas.Rectangle(0,0,Width,Height);
end;
function TBinaryFlag.GetRO:boolean;
begin
  result:=FReadOnly;
end;
procedure TBinaryFlag.SetRO(value:boolean);
begin
  FReadOnly:=value;
  
end;
function TBinaryFlag.GetDelta:boolean;
begin
  result:=FDelta;
end;
procedure TBinaryFlag.SetDelta(value:boolean);
begin
  FDelta:=value;
  //Стандартная прорисовка
  if  Fdelta then
    canvas.Pen.Color:=clRed
    else
    if not FReadOnly then canvas.Pen.Color:=clGray else canvas.Pen.Color:=clltGray;
  if not FReadOnly then
    if FValue then canvas.Brush.Color:=2631720 else canvas.Brush.Color:=15132390
  else
    if FValue then canvas.Brush.Color:=clblack else canvas.Brush.Color:=clwhite;
    canvas.Rectangle(0,0,Width,Height);
end;
procedure TBinaryFlag.Click;
begin
if  FReadOnly then if Fvalue then Fvalue:=false else Fvalue:=true;

 //Стандартная прорисовка
  if  Fdelta then
    canvas.Pen.Color:=clRed
    else
    if not FReadOnly then canvas.Pen.Color:=clGray else canvas.Pen.Color:=clltGray;
  if not FReadOnly then
    if FValue then canvas.Brush.Color:=2631720 else canvas.Brush.Color:=15132390
  else
    if FValue then canvas.Brush.Color:=clblack else canvas.Brush.Color:=clwhite;
    canvas.Rectangle(0,0,Width,Height);
if  FReadOnly then inherited click;


end;



end.
