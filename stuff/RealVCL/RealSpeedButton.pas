// -----------------------------------------------------------
//
// RealSpeedButton version 1.1 visual component
// (c) 2003-2004 Nikolaj Masnikov
//
// -----------------------------------------------------------

unit RealSpeedButton;

interface

uses
  Windows, Messages, Classes, Graphics,
  Controls, Forms, Buttons, Menus;

type
  TBmpFlag=(bfNormal,bfDown,bfActive,bfDisable);
  TButtonStyle = (bsSpeed,bsCool);

  TRealSpeedButton = class(TSpeedButton)
  private
    // --- COOL BUTTON ---
    FOnPaint: TNotifyEvent;
       //FOnChange: TCoolChange;
    FAutoSize: boolean;
    FNormBmp:TBitmap;
    FDownBmp:TBitmap;
    FActvBmp:TBitmap;
    FDsblBmp:TBitmap;
    Fbit:TBitmap;
    FMouseInControl:Boolean;
    FTransparent:Boolean;
    FFlag:TBmpFlag;
    FOnDown:TNotifyEvent;
    FStyle: TButtonStyle;
    // --- SPEED BUTTON ---
    FOnMouseEnter: TNotifyEvent;
    FOnMouseLeave: TNotifyEvent;
    FOnParentColorChanged: TNotifyEvent;
    FSaved: TColor;
    FHintColor: TColor;
    FOver: Boolean;
    FHotGlyph: TBitmap;
    FOldGlyph: TBitmap;
    FDropDownMenu: TPopupMenu;
    FModalResult: TModalResult;
    FHotTrack: Boolean;
    FFontHotTrack: TFont;
    FFontSave: TFont;
    // --- COOL BUTTON ---
    procedure SetNormBmp(Value:TBitmap);
    procedure SetDownBmp(Value:TBitmap);
    procedure SetActvBmp(Value:TBitmap);
    procedure SetDsblBmp(Value:TBitmap);
    procedure SetFlag(Value: TBmpFlag);
    procedure SetStyle(Value: tButtonStyle);
    //procedure SetTransparent(Value: Boolean);
    // --- SPEED BUTTON ---
    procedure SetGlyph(Value: TBitmap);
    procedure SetFontHotTrack(const Value: TFont);
  protected
    // --- COOL BUTTON ---
    property  MouseInControl: Boolean read FMouseInControl;
    property  Flag:TBmpFlag read FFlag write SetFlag;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X,  Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
    procedure SetEnabled(Value: Boolean); override;
    procedure Loaded; override;
    // --- SPEED BUTTON ---
    procedure CMMouseEnter(var Msg: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Msg: TMessage); message CM_MOUSELEAVE;
    procedure CMParentColorChanged(var Msg: TMessage); message CM_PARENTCOLORCHANGED;
  public
    // --- COOL BUTTON ---
    property Canvas;
    // --- SPEED BUTTON ---
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Click; override;
  published
    // --- COOL BUTTON ---
    property Style: TButtonStyle read FStyle write SetStyle default bsSpeed;
    property BmpNormal : TBitmap read FNormBmp write SetNormBmp;
    property BmpDown   : TBitmap read FDownBmp write SetDownBmp;
    property BmpActive : TBitmap read FActvBmp write SetActvBmp;
    property BmpDisable: TBitmap read FDsblBmp write SetDsblBmp;
    property OnDown:TNotifyEvent read FOnDown write FOnDown;
    property OnPaint: TNotifyEvent read FOnPaint write FOnPaint;
    property Transparent: Boolean read FTransparent write FTransparent default true;
    property AutoSize: boolean read FAutoSize write FAutoSize default false;
    // --- SPEED BUTTON ---
    property HotTrack: Boolean read FHotTrack write FHotTrack default False;
    property FontHotTrack: TFont read FFontHotTrack write SetFontHotTrack;
    property HotGlyph: TBitmap read FHotGlyph write SetGlyph;
    property HintColor: TColor read FHintColor write FHintColor default clInfoBk;
    property DropDownMenu: TPopupMenu read FDropDownMenu write FDropDownMenu;
    property ModalResult: TModalResult read FModalResult write FModalResult default mrNone;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
    property OnParentColorChange: TNotifyEvent read FOnParentColorChanged write FOnParentColorChanged;
  end;
procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Real', [TRealSpeedButton]);
end;

constructor TRealSpeedButton.Create(AOwner: TComponent);
begin
 inherited Create(AOwner);
 // --- SPEED BUTTON ---
 FStyle := bsSpeed;
 Flag:=bfNormal;
 FHotTrack := False;
 FFontHotTrack := TFont.Create;
 FFontSave := TFont.Create;
 FHintColor := clInfoBk;
 FOver := False;
 FHotGlyph := TBitmap.Create;
 FOldGlyph := TBitmap.Create;
 FModalResult := mrNone;
 // --- COOL BUTTON ---
 ControlStyle := ControlStyle {+ [csOpaque]} - [csDoubleClicks] {+ [csReplicatable]};
 Width := 25;
 Height := 25;
 FNormBmp:=TBitmap.Create;
 FDownBmp:=TBitmap.Create;
 FActvBmp:=TBitmap.Create;
 FDsblBmp:=TBitmap.Create;
 Fbit:=TBitmap.Create;
end;

destructor TRealSpeedButton.Destroy;
begin
 // --- COOL BUTTON ---
 FNormBmp.Free;
 FDownBmp.Free;
 FActvBmp.Free;
 FDsblBmp.Free;
 Fbit.Free;
 // --- SPEED BUTTON ---
 FHotGlyph.Free;
 FOldGlyph.Free;
 FFontHotTrack.Free;
 FFontSave.Free;
 inherited Destroy;
end;

procedure TRealSpeedButton.Loaded;
begin
 // --- COOL BUTTON ---
// FNormBmp.Transparent:=FTransparent;
// FDownBmp.Transparent:=FTransparent;
// FActvBmp.Transparent:=FTransparent;
// FDsblBmp.Transparent:=FTransparent;
 Fbit.Width:=Width;
 Fbit.Height:=Height;
 Fbit.Canvas.CopyRect(ClientRect,Canvas,ClientRect);
end;

procedure TRealSpeedButton.Click;
var Form: TForm;
begin
 // --- SPEED BUTTON ---
 inherited Click;
 if FModalResult <> mrNone then
 begin
   Form := TForm(GetParentForm(Self));
   if Form <> nil then
     Form.ModalResult := FModalResult;
 end
 else
 if FDropDownMenu <> nil then
 begin
   FDropDownMenu.Popup(GetClientOrigin.X, GetClientOrigin.Y + Height);
   Perform(CM_MOUSELEAVE, 0, 0);
 end;
end;

procedure TRealSpeedButton.SetEnabled(Value: Boolean);
begin
 // --- COOL BUTTON ---
 inherited SetEnabled(Value);
 if FStyle=bsCool then
  begin
   if Value
    then {if MouseInControl then Flag:=bfActive else} Flag:=bfNormal
    else Flag:=bfDisable;
   Refresh;
  end;
end;

procedure TRealSpeedButton.Paint;
//var RRect:TRect;
begin
 if FStyle=bsCool then
  begin
   // --- COOL BUTTON ---
{ Canvas.Font := Font;
 Canvas.Brush.Color := Color;
 if csDesigning in ComponentState then
   with Canvas do
   begin
     Pen.Style := psDash;
     Brush.Style := bsClear;
     Rectangle(0, 0, Width, Height);
   end;}
 Fbit.Width:=Width;
 Fbit.Height:=Height;
 Fbit.Canvas.CopyRect(ClientRect,Canvas,ClientRect);
 if Enabled then with Fbit do
  case FFlag of
   bfNormal:
      begin
       Canvas.Draw(0,0,FNormBmp);
      end;
   bfDown:
      begin
       Canvas.Draw(0,0,FDownBmp);
      end;
   bfActive:
      begin
       if FActvBmp.Empty
        then Canvas.Draw(0,0,FNormBmp)
        else Canvas.Draw(0,0,FActvBmp);
      end;
  end else
   //if FFlag=bfDisable
   {then} FBit.Canvas.Draw(0,0,FDsblBmp);

 Canvas.Draw(0,0,Fbit);
{ if Caption<>'' then
  with Canvas do
   begin
    Brush.Style := bsClear;
//    RRect:=Canvas.ClipRect;  //can distort draw when other window overlap button
    RRect:=ClientRect;
    DrawText(Handle, PChar(Caption), Length(Caption),
             RRect,DT_CENTER or DT_VCENTER or DT_SINGLELINE);
   end;}
  end;
  if FStyle = bsSpeed then inherited;
 if Assigned(FOnPaint) then FOnPaint(Self);
end;

procedure TRealSpeedButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
 inherited MouseDown(Button, Shift, X, Y);
 // --- COOL BUTTON ---
 if FStyle = bsCool then
  begin
   if (Button=mbRight) or (Button=mbMiddle) then exit;
   //if {(FNormBmp.Canvas.Pixels[x,y]<>FNormBmp.Canvas.Pixels[0,0]) or} not FTransparent //!!
    //then begin
    Flag:=bfDown; Refresh; //end;
   if not FMouseInControl then FMouseInControl:=true;
  end;
end;

procedure TRealSpeedButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 inherited MouseUp(Button, Shift, X, Y);
 // --- COOL BUTTON ---
 if FStyle = bsCool then
  begin
   if FMouseInControl then
  {  if (FNormBmp.Canvas.Pixels[x,y]=FNormBmp.Canvas.Pixels[0,0]) and FTransparent //!!
     then begin  Flag:=bfNormal; Refresh; end
     else} begin Flag:=bfActive; Refresh; end;
  end;
end;

procedure TRealSpeedButton.MouseMove(Shift: TShiftState; X,  Y: Integer);
begin
 // --- COOL BUTTON ---
 inherited MouseMove(Shift, X, Y);
 if FStyle = bsCool then
  begin
{ if (FNormBmp.Canvas.Pixels[x,y]=FNormBmp.Canvas.Pixels[0,0]) and FTransparent //!!
  then begin if Flag<>bfNormal then begin Flag:=bfNormal; Refresh; end; end
  else} if (Flag<>bfActive) and (Flag<>bfDown) and FMouseInControl then
   begin Flag:=bfActive; Refresh; end;
// FMouseInControl:=PtInRect(BoundsRect,Point(x,y));
 end;
end;

procedure TRealSpeedButton.CMParentColorChanged(var Msg: TMessage);
begin
 // --- SPEED BUTTON ---
 inherited;
 if Assigned(FOnParentColorChanged) then
   FOnParentColorChanged(Self);
end;

procedure TRealSpeedButton.SetGlyph(Value: TBitmap);
begin
 // --- SPEED BUTTON ---
 FHotGlyph.Assign(Value);
end;

procedure TRealSpeedButton.CMMouseEnter(var Msg: TMessage);
begin
 inherited;
 // for D7...
 if csDesigning in ComponentState then Exit;

 // --- COOL BUTTON ---
 if FStyle = bsCool then
  begin
   if not Enabled then exit;
   FMouseInControl:=True;
  { if Assigned(FOnChange) then
    if Flag=bfActive then FOnChange(self,true)
                      else FOnChange(self,false);}
  end else
 if FStyle = bsSpeed then
 // --- SPEED BUTTON ---
 if not FOver then
  begin
   FSaved := Application.HintColor;
   Application.HintColor := FHintColor;
   if not FHotGlyph.Empty then
   begin
     FOldGlyph.Assign(Glyph);
     Glyph.Assign(FHotGlyph);
   end;
   if FHotTrack then
   begin
     FFontSave.Assign(Font);
     Font.Assign(FFontHotTrack);
   end;
   FOver := True;
  end;
 if Assigned(FOnMouseEnter) then FOnMouseEnter(Self);
end;

procedure TRealSpeedButton.CMMouseLeave(var Msg: TMessage);
begin
 inherited;
 // for D7...
 if csDesigning in ComponentState then Exit;
 // --- COOL BUTTON ---
 if FStyle = bsCool then
  begin
   if not Enabled then exit;
   FMouseInControl:=False;
   Flag:=bfNormal;
   Refresh;
  end else
 if FStyle = bsSpeed then
 // --- SPEED BUTTON ---
 if FOver then
  begin
   Application.HintColor := FSaved;
   if not FOldGlyph.Empty then
     Glyph.Assign(FOldGlyph);
   if FHotTrack then
     Font.Assign(FFontSave);
   FOver := False;
  end;
 if Assigned(FOnMouseLeave) then FOnMouseLeave(Self);
end;

procedure TRealSpeedButton.SetFontHotTrack(const Value: TFont);
begin
 // --- SPEED BUTTON ---
 FFontHotTrack.Assign(Value);
end;

procedure TRealSpeedButton.SetNormBmp (Value:TBitmap);
begin
 // --- COOL BUTTON ---
 FNormBmp.Assign(Value);
 if Value<>nil then
  begin
   if FAutoSize then
    begin
     Width:=Value.Width;
     Height:=Value.Height;
    end; 
//   FNormBmp.Transparent:=FTransparent;
  end;
 Parent.Invalidate;
 //Refresh;
end;

procedure TRealSpeedButton.SetDownBmp (Value:TBitmap);
begin
 // --- COOL BUTTON ---
 FDownBmp.Assign(Value);
// FDownBmp.Transparent:=FTransparent;
 Refresh;
end;

procedure TRealSpeedButton.SetActvBmp (Value:TBitmap);
begin
 // --- COOL BUTTON ---
 FActvBmp.Assign(Value);
// FActvBmp.Transparent:=FTransparent;
 Refresh;
end;

procedure TRealSpeedButton.SetDsblBmp (Value:TBitmap);
begin
 // --- COOL BUTTON ---
 FDsblBmp.Assign(Value);
// FDsblBmp.Transparent:=FTransparent;
 Parent.Invalidate;
end;

{procedure TRealSpeedButton.SetTransparent (Value:Boolean);
begin
 // --- COOL BUTTON ---
 if FTransparent=Value then exit;
 inherited;
 FTransparent:=Value;
 FNormBmp.Transparent:=FTransparent;
 FDownBmp.Transparent:=FTransparent;
 FActvBmp.Transparent:=FTransparent;
 FDsblBmp.Transparent:=FTransparent;
 Parent.Invalidate;
end; }

procedure TRealSpeedButton.SetFlag(Value: TBmpFlag);
//var b:boolean;
begin
 // --- COOL BUTTON ---
{ if FFlag<>Value then FFlag:=Value;
 if FFlag=bfDown then if Assigned(OnClick) then OnClick(Self);}
 if FFlag=Value then exit;
 //b:=(FFlag=bfDown) and (Value=bfActive);
 FFlag:=Value;
{ if Assigned(FOnChange) then
  if Value=bfActive then FOnChange(self,true)
                    else FOnChange(self,false);}

 {if b then
  if Assigned(OnClick) then OnClick(Self);

 if FFlag=bfDown then
  if Assigned(OnDown) then OnDown(Self);}
end;

procedure TRealSpeedButton.SetStyle(Value: tButtonStyle);
begin
 if FStyle = Value then Exit;
 FStyle := Value;
 {if FNormBmp.Width>0 then
  begin
   Width  := FNormBmp.Width;
   Height := FNormBmp.Height;
  end;}
 Refresh;
 //Paint;
end;


end.

