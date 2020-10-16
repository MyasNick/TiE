// -----------------------------------------------------------
//
// RealMultiPanel version 1.0 visual component
// (c) 2004 Nikolaj Masnikov
//
// -----------------------------------------------------------

unit RealMultiPanel;

interface

uses
  Classes, Controls, ExtCtrls, SysUtils;

const MaxPanels=256;

type
  TRealMultiPanel = class(TPanel)
  private
    FPanels : array [1..MaxPanels] of TPanel;
    FPanelsCount : integer;
    FPanelIndex : integer;
  protected
  public
    //property Panels;
    procedure   SetPanels (Value : integer);
    procedure   SetIndex  (Value : integer);
    constructor Create    (AOwner: TComponent); override;
    destructor  Destroy;                        override;
  published
    property PanelsCount : integer read FPanelsCount write SetPanels default 0;
    property PanelIndex  : integer read FPanelIndex  write SetIndex  default 0;
    //property CurrentPanel : TPanel read FPanels[FPanelIndex] write FPanels[FPanelIndex];
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Real', [TRealMultiPanel]);
end;

constructor TRealMultiPanel.Create(AOwner: TComponent);
begin
 inherited Create(AOwner);
end;

destructor TRealMultiPanel.Destroy;
begin
 inherited Destroy;
end;

procedure TRealMultiPanel.SetIndex (Value : integer);
var i : integer;
begin
 if Value = FPanelIndex then exit;
 if Value > FPanelsCount
    then FPanelIndex := FPanelsCount
    else FPanelIndex := Value;
 if FPanelIndex < 0 then FPanelIndex := 0;
 for i := 1 to FPanelsCount do
  begin
//   FPanels[i].Align:=alNone;
//   FPanels[i].Width:=0;
//   FPanels[i].Height:=0;
   FPanels[i].Hide;
  end;
 if FPanelIndex > 0 then
  begin
//   FPanels[i].Align:=alClient;
   FPanels[FPanelIndex].Show;
  end;
end;

procedure TRealMultiPanel.SetPanels (Value : integer);
var i, j : integer;
begin
 if (Value = FPanelsCount) or (Value < 0)  then exit;
 if Value > FPanelsCount
  then begin
   j := Value - FPanelsCount;
   for i := 1 to j do
    begin
     FPanels[FPanelsCount+i] := TPanel.Create(Self);
     FPanels[FPanelsCount+i].Parent := Self;
     FPanels[FPanelsCount+i].Name := 'MultiPanel' + IntToStr(FPanelsCount+i);
     FPanels[FPanelsCount+i].Width := 100;
     FPanels[FPanelsCount+i].Height := 100;
     //FPanels[FPanelsCount+i].Align := alClient;
     FPanels[FPanelsCount+i].Caption :=  'MultiPanel' + IntToStr(FPanelsCount+i);
     //FPanels[FPanelsCount+i].Color := 0;
     FPanels[FPanelsCount+i].Show;
    end;
  end
  else begin
   j := FPanelsCount - Value;
   for i := 1 to j do FPanels[Value+i].Free;
  end;
 FPanelsCount := Value;
 PanelIndex := FPanelsCount;
end;


end.
