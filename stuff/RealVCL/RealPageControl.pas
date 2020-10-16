// -----------------------------------------------------------
//
// RealPageControl version 1.0 visual component
// (c) 2004 Nikolaj Masnikov
//
// -----------------------------------------------------------

unit RealPageControl;

interface

uses
  Windows, Messages, Classes, ComCtrls, CommCtrl;

type
  TRealPageControl=class(TPageControl)
  protected
    procedure WndProc(var Message:TMessage); override;
  private
    { Private declarations }
  public
    { Public declarations }
  published
    { Published declarations }
  end;

procedure Register;

implementation

procedure TRealPageControl.WndProc(var Message:TMessage);
begin
  if(Message.Msg=TCM_ADJUSTRECT) then begin
    Inherited WndProc(Message);
    PRect(Message.LParam)^.Left:=0;
    PRect(Message.LParam)^.Right:=ClientWidth;
    PRect(Message.LParam)^.Top:=PRect(Message.LParam)^.Top-4;
    PRect(Message.LParam)^.Bottom:=ClientHeight;
  end else Inherited WndProc(Message);
end;

procedure Register;
begin
  RegisterComponents('Real', [TRealPageControl]);
end;

end.
