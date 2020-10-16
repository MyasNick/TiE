// -----------------------------------------------------------
//
// RealKeyState version 1.0 visual component
// (c) 2004 Nikolaj Masnikov
//
//  Properties:
//    NumLock      - State of NumLock key
//    ScrollLock   - State of ScrollLock key
//    CapsLock     - State of CapsLock key
//    Insert       - State of Insert key
//  Methods:
//    SaveState    - Save full key state
//    RestoreState - Restore full key state
// -----------------------------------------------------------

unit RealKeyState;

interface

uses Windows, Classes, Forms, Messages;

type
  TRealKeyState = class(TComponent)
  private
    RealKeyState      : TKeyboardState;
    SavedRealKeyState : TKeyboardState;

    FOnOldAppMessage : TMessageEvent;
    FOnOldActive  : TNotifyEvent;
    FOnNumLock    : TNotifyEvent;
    FOnScrollLock : TNotifyEvent;
    FOnCapsLock   : TNotifyEvent;
    FOnInsert     : TNotifyEvent;

    procedure SetState(Ctrl: Word; stOn: Boolean);
    procedure SetNumLock(stOn: Boolean);
    function  GetNumLock : boolean;
    procedure SetScrollLock(stOn: Boolean);
    function  GetScrollLock : boolean;
    procedure SetCapsLock(stOn: Boolean);
    function  GetCapsLock : boolean;
    procedure SetInsert(stOn: Boolean);
    function  GetInsert : boolean;
    procedure AppMessage(var Msg: TMsg; var Handled: Boolean);
    procedure AppActive(Sender : TObject);
    function IsNT : boolean;
    function State(Ctrl : Word) : boolean;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure Init;
    procedure SaveState;
    procedure RestoreState;
    property NumLock    : Boolean read GetNumLock write SetNumLock;
    property ScrollLock : Boolean read GetScrollLock write SetScrollLock;
    property CapsLock   : Boolean read GetCapsLock write SetCapsLock;
    property Insert     : Boolean read GetInsert write SetInsert;
  published
    property OnNumLock  : TNotifyEvent read FOnNumLock write FOnNumLock;
    property OnScrollLock  : TNotifyEvent read FOnScrollLock write FOnScrollLock;
    property OnCapsLock  : TNotifyEvent read FOnCapsLock write FOnCapsLock;
    property OnInsert  : TNotifyEvent read FOnInsert write FOnInsert;
  end;

procedure Register;

implementation

constructor TRealKeyState.Create(AOwner : TComponent);
begin
  inherited;
  FillChar(RealKeyState, SizeOf(TKeyboardState), 0); {Initialize}
  if not (csDesigning in ComponentState) then
  begin
    { Save the old MessageHandler }
    FOnOldAppMessage:=Application.OnMessage;
    FOnOldActive:=Application.OnActivate;
    { Set the new MessageHandler }
    Application.OnMessage:=AppMessage;
    Application.OnActivate:=AppActive;
  end;
end;

destructor TRealKeyState.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    { Restore the old MessageHandler }
    Application.OnMessage:=FOnOldAppMessage;
    Application.OnActivate:=FOnOldActive;
  end;
  inherited;
end;

function TRealKeyState.IsNT : boolean;
begin
  Result:=(GetVersion<$80000000);
end;

function TRealKeyState.State(Ctrl : Word) : boolean;
begin
  Result:=((RealKeyState[ctrl] and 1)=1);
end;

procedure TRealKeyState.SetState(Ctrl : word; stOn : boolean);
begin
  GetKeyboardState(RealKeyState);
  { Toggle RealKeyState if changed }
  if (State(ctrl) or stOn) then
  begin
    { Toggle RealKeyState SystemWide }
    keybd_event(Ctrl, 0, 0, 0);
    keybd_event(Ctrl, 0, KEYEVENTF_KEYUP, 0);
  end;
  { if not Windows NT this has to be done. }
  if not IsNT then
  begin
    Application.ProcessMessages; { Has to be here. Otherwise Win95 lose control. }
    { Set RealKeyState }
    RealKeyState[Ctrl]:=Byte(stOn);
    SetKeyboardState(RealKeyState);
  end;
end;

procedure TRealKeyState.SetNumLock(stOn: Boolean);
begin
  SetState(vk_NumLock, stOn);
end;

function TRealKeyState.GetNumLock : boolean;
begin
  GetKeyboardState(RealKeyState);
  Result:=State(vk_NumLock);
end;

procedure TRealKeyState.SetScrollLock(stOn: Boolean);
begin
  SetState(vk_Scroll, stOn);
end;

function TRealKeyState.GetScrollLock : boolean;
begin
  GetKeyboardState(RealKeyState);
  Result:=State(vk_Scroll);
end;

procedure TRealKeyState.SetCapsLock(stOn: Boolean);
begin
  SetState(vk_Capital, stOn);
end;

function TRealKeyState.GetCapsLock : boolean;
begin
  GetKeyboardState(RealKeyState);
  Result:=State(vk_Capital);
end;

procedure TRealKeyState.SetInsert(stOn: Boolean);
begin
  SetState(vk_Insert,stOn);
end;

function TRealKeyState.GetInsert : boolean;
begin
  GetKeyboardState(RealKeyState);
  Result:=State(vk_Insert);
end;

procedure TRealKeyState.SaveState;
begin
  GetKeyboardState(SavedRealKeyState);
end;

procedure TRealKeyState.RestoreState;
begin
  SetKeyboardState(SavedRealKeyState);
end;

procedure TRealKeyState.AppMessage(var Msg: TMsg; var Handled: Boolean);
begin
  if Msg.message = WM_KEYDOWN then
  begin
    if not (csDesigning in ComponentState) then
    begin
      { Call the EventHandlers }
      case Msg.wParam of
        vk_NumLock : if Assigned(OnNumLock) then OnNumLock(self);
        vk_Scroll  : if Assigned(OnScrollLock) then OnScrollLock(self);
        vk_Capital : if Assigned(OnCapsLock) then OnCapsLock(self);
        vk_Insert  : if Assigned(OnInsert) then OnInsert(self);
      end;
      { Call the old MessageHandler }
      if Assigned(FOnOldAppMessage) then FOnOldAppMessage(Msg, Handled)
    end;
  end;
end;

procedure TRealKeyState.AppActive(Sender : TObject);
begin
  Init;
end;

procedure TRealKeyState.Init;
begin
  if not (csDesigning in ComponentState) then
  begin
    { Call all the EventHandlers }
    if Assigned(OnNumLock) then OnNumLock(self);
    if Assigned(OnScrollLock) then OnScrollLock(self);
    if Assigned(OnCapsLock) then OnCapsLock(self);
    if Assigned(OnInsert) then OnInsert(self);
  end;
end;

procedure Register;
begin
  RegisterComponents('Real', [TRealKeyState]);
end;

end.
