// -----------------------------------------------------------
//
// RealLabel version 1.0 visual component
// (c) 2004 Nikolaj Masnikov
//
// Features:
// HotTrack     : boolean      - when true component changes Font to FontHotTrack and back on rollover
// FontHotTrack : TFont
// Subject      : string       - Subject field for "mailto:" command
// URL          : string       - URL in format: "mailto:..." or "http://" or "ftp://" or "file://" etc.
// OnMouseEnter : TNotifyEvent
// OnMouseLeave : TNotifyEvent
//
// -----------------------------------------------------------

unit RealLabel;

interface

uses
  Windows, SysUtils, Classes, Controls, StdCtrls, Graphics,
  Messages, ShellAPI;

type
  TLabelStyle = (lsNormal,bsURL);
  TRealLabel = class(TLabel)
  private
    FURL: string;
    FSubject: string;
    FHotTrack: boolean;
    FFontHotTrack: TFont;
    FFontSave: TFont;
    FOnMouseEnter: TNotifyEvent;
    FOnMouseLeave: TNotifyEvent;
    procedure SetFontHotTrack(Value: TFont);
  protected
    procedure CMMouseEnter(var Msg: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Msg: TMessage); message CM_MOUSELEAVE;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Click; override;
  published
    property HotTrack: boolean read FHotTrack write FHotTrack default false;
    property URL: string read FURL write FURL;
    property Subject: string read FSubject write FSubject;
    property FontHotTrack: TFont read FFontHotTrack write SetFontHotTrack;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Real', [TRealLabel]);
end;

constructor TRealLabel.Create(AOwner: TComponent);
begin
 inherited Create(AOwner);
 FHotTrack := false;
 FFontHotTrack := TFont.Create;
 FFontSave := TFont.Create;
 ControlStyle := ControlStyle;// + [csOpaque]} + [csReplicatable];
end;

destructor TRealLabel.Destroy;
begin
 FFontHotTrack.Free;
 FFontSave.Free;
 inherited Destroy;
end;

procedure TRealLabel.Click;
begin
 if FURL<>'' then
  if (FSubject<>'') and (Pos('@',FURL)<>0)
   then ShellExecute(HInstance,'Open',PCHAR(FURL+'?Subject='+FSubject),nil,nil,SW_SHOWNORMAL)
   else ShellExecute(HInstance,'Open',PCHAR(FURL),nil,nil,SW_SHOWNORMAL);
 inherited Click;
end;

procedure TRealLabel.CMMouseEnter(var Msg: TMessage);
begin
 if csDesigning in ComponentState then exit;
 inherited;
 if FHotTrack then
  begin
   FFontSave.Assign(Font);
   Font.Assign(FFontHotTrack);
  end;
 if Assigned(FOnMouseEnter) then FOnMouseEnter(Self);
end;

procedure TRealLabel.CMMouseLeave(var Msg: TMessage);
begin
 if csDesigning in ComponentState then exit;
 inherited;
 if FHotTrack then
  begin
   //FFontSave.Assign(Font);
   Font.Assign(FFontSave);
  end;
 if Assigned(FOnMouseLeave) then FOnMouseLeave(Self);
end;

procedure TRealLabel.SetFontHotTrack( Value: TFont);
begin
 FFontHotTrack.Assign(Value);
end;

end.
