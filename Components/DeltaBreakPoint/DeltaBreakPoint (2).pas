unit DeltaBreakPoint;

interface

uses
  SysUtils, Classes, Controls, ExtCtrls,Graphics;

type
  TDeltaBreakPoint = class(TImage)
  private
    { Private declarations }
    FBPDelta:boolean;
    FBPGreenDelta:Boolean;
    FBPinWork:boolean;
    FAddr:Integer;
    function GetBPDelta:boolean;
    procedure SetBPDelta(value:boolean);
    function GetBPGreenDelta:boolean;
    procedure SetBPGreenDelta(value:boolean);
    function GetBPinWork:boolean;
    procedure SetBPinWork(value:boolean);
    function GetAddr:integer;
    procedure SetAddr(value:integer);

    procedure ReDRAW();

  protected
    { Protected declarations }
    procedure Click;override;
  public
    { Public declarations }
  published
    { Published declarations }
    constructor Create(AOwner:TComponent); override;
    property BPDelta:boolean
              read GetBPDelta
              write SetBPDelta
              default false;
    property BPGreenDelta:boolean
              read GetBPGreenDelta
              write SetBPGreenDelta
              default false;
    property BPinWork:boolean
              read GetBPinWork
              write SetBPinWork
              default false;
    Property ByteAddres:integer
              read GetAddr
              write SetAddr;

  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TDeltaBreakPoint]);
end;
constructor TDeltaBreakPoint.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  FBPDelta:=false;
  FBPGreenDelta:=False;
  FBPinWork:=false;
  FAddr:=0;

end;

function TDeltaBreakPoint.GetAddr:integer;
begin
  result:=FAddr;
end;
procedure TDeltaBreakPoint.SetAddr(value:integer);
begin
  Faddr:=value;
end;

function TDeltaBreakPoint.GetBPDelta:boolean;
begin
  result:=FBPDelta;
end;
procedure TDeltaBreakPoint.SetBPDelta(value:boolean);
begin
   FBPDelta:=value;
   ReDRAW;
end;
function TDeltaBreakPoint.GetBPGreenDelta:boolean;
begin
  result:=FBPGreenDelta;
end;
procedure TDeltaBreakPoint.SetBPGreenDelta(value:boolean);
begin
  FBPGreenDelta:=value;
   ReDRAW;
end;
function TDeltaBreakPoint.GetBPinWork:boolean;
begin
  result:=FBPinWork;
end;
procedure TDeltaBreakPoint.setBPinWork(value:boolean);
begin
  FBPinWork:=value;
  ReDRAW;
end;
procedure TDeltaBreakPoint.Click;
begin
if FBPDelta then
  begin
    if FBPGreenDelta then
    begin
      FBPDelta:=false;
      FBPGreenDelta:=false;
    end
    else
    begin
      FBPDelta:=true;
      FBPGreenDelta:=true;
    end;
  end
  else
  begin
     FBPDelta:=true;
     FBPGreenDelta:=false;
  end;
inherited click;
ReDRAW;


end;

procedure TDeltaBreakPoint.ReDRAW();
begin
if FBPDelta then
  begin
    if FBPGreenDelta then
    begin
     //Зеленый кружок
     canvas.Pen.Color:=clwhite;
     canvas.Brush.Color:=clgreen;
     canvas.Ellipse(0,5,Width,Width+5);
    end
    else
    begin
     //Красный кружок
     canvas.Pen.Color:=clwhite;
     canvas.Brush.Color:=clred;
     canvas.Ellipse(0,5,Width,Width+5);
    end;
  end
  else
  begin
     //Очистить
     canvas.Pen.Color:= clwhite;
     canvas.Brush.Color:=clwhite;
     canvas.Ellipse(0,5,Width,Width+5);
  end;
end;

end.
