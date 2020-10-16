// -----------------------------------------------------------
//
// RealKey version 1.1 (2009.03.25) visual component
// RealSpeedButton with 4+1 captions
// © 2009 Nikolaj Masnikov
//
// -----------------------------------------------------------

unit RealKey;

interface

uses
  SysUtils, Classes, Controls, Buttons, RealSpeedButton, Graphics, Windows;

type
  TRealKey = class(TRealSpeedButton)
  private
    FCaptionTopLeft:     WideString;
    FCaptionTopRight:    WideString;
    FCaptionBottomLeft:  WideString;
    FCaptionBottomRight: WideString;
    FFontTopLeft:     TFont;
    FFontTopRight:    TFont;
    FFontBottomLeft:  TFont;
    FFontBottomRight: TFont;
    procedure SetFontTopLeft     (const Value: TFont);
    procedure SetFontTopRight    (const Value: TFont);
    procedure SetFontBottomLeft  (const Value: TFont);
    procedure SetFontBottomRight (const Value: TFont);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property CaptionTopLeft:     WideString read FCaptionTopLeft     write FCaptionTopLeft;
    property CaptionTopRight:    WideString read FCaptionTopRight    write FCaptionTopRight;
    property CaptionBottomLeft:  WideString read FCaptionBottomLeft  write FCaptionBottomLeft;
    property CaptionBottomRight: WideString read FCaptionBottomRight write FCaptionBottomRight;
    property FontTopLeft:     TFont read FFontTopLeft     write SetFontTopLeft;
    property FontTopRight:    TFont read FFontTopRight    write SetFontTopRight;
    property FontBottomLeft:  TFont read FFontBottomLeft  write SetFontBottomLeft;
    property FontBottomRight: TFont read FFontBottomRight write SetFontBottomRight;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Real', [TRealKey]);
end;

{ TRealKey }

constructor TRealKey.Create(AOwner: TComponent);
begin
  inherited;
  FFontTopLeft     := TFont.Create;
  FFontTopRight    := TFont.Create;
  FFontBottomLeft  := TFont.Create;
  FFontBottomRight := TFont.Create;
end;

destructor TRealKey.Destroy;
begin
  FFontTopLeft.Free;
  FFontTopRight.Free;
  FFontBottomLeft.Free;
  FFontBottomRight.Free;
  inherited;
end;

procedure TRealKey.Paint;
var KeyRect : TRect;
begin
  inherited;
  KeyRect.Left   := ClientRect.Left   + Margins.Left;
  KeyRect.Top    := ClientRect.Top    + Margins.Top;
  KeyRect.Right  := ClientRect.Right  - Margins.Right;
  KeyRect.Bottom := ClientRect.Bottom - Margins.Bottom;

  with Canvas do
  begin
    Brush.Style := bsClear;
    if CaptionTopLeft <> '' then
    begin
      Font := Self.FontTopLeft;
      Windows.DrawTextW (Canvas.Handle, PWideChar(CaptionTopLeft), Length(CaptionTopLeft), KeyRect, DT_LEFT or DT_TOP);
    end;
    if CaptionTopRight <> '' then
    begin
      Font := Self.FontTopRight;
      Windows.DrawTextW (Canvas.Handle, PWideChar(CaptionTopRight), Length(CaptionTopRight), KeyRect, DT_RIGHT or DT_TOP);
    end;
    if CaptionBottomLeft <> '' then
    begin
      Font := Self.FontBottomLeft;
      Windows.DrawTextW (Canvas.Handle, PWideChar(CaptionBottomLeft), Length(CaptionBottomLeft), KeyRect, DT_LEFT or DT_BOTTOM or DT_SINGLELINE);
    end;
    if CaptionBottomRight <> '' then
    begin
      Font := Self.FontBottomRight;
      Windows.DrawTextW (Canvas.Handle, PWideChar(CaptionBottomRight), Length(CaptionBottomRight), KeyRect, DT_RIGHT or DT_BOTTOM or DT_SINGLELINE);
    end;
    if Caption <> '' then
    begin
      Font := Self.Font;
      Windows.DrawText (Canvas.Handle, PChar(Caption), Length(Caption), KeyRect, DT_CENTER or DT_VCENTER or DT_SINGLELINE);
    end;
  end;
end;

procedure TRealKey.SetFontBottomLeft(const Value: TFont);
begin
  FFontBottomLeft.Assign(Value);
//  Refresh;
end;

procedure TRealKey.SetFontBottomRight(const Value: TFont);
begin
  FFontBottomRight.Assign(Value);
//  Refresh;
end;

procedure TRealKey.SetFontTopLeft(const Value: TFont);
begin
  FFontTopLeft.Assign(Value);
//  Refresh;
end;

procedure TRealKey.SetFontTopRight(const Value: TFont);
begin
  FFontTopRight.Assign(Value);
//  Refresh;
end;

end.
