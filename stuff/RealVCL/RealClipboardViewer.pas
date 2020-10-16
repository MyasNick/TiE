// -----------------------------------------------------------
//
// RealClipboardViewer version 1.0 visual component
// (c) 2004 Nikolaj Masnikov
//
// -----------------------------------------------------------

unit RealClipboardViewer;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ClipBrd;

type
  TOnImage = procedure(Sender: TObject; Image: TBitmap) of object;
  TOnText = procedure(Sender: TObject; Text: string) of object;
  TRealClipboardViewer = class(TComponent)
  private
    FHandle: THandle;
    FNextCB: HWND;
    FOnText: TOnText;
    FOnImage: TOnImage;
    procedure UpdateClip(var Msg: TWMDrawClipBoard); message WM_DRAWCLIPBOARD;
    procedure WndProc(var Msg: TMessage);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    procedure EmptyClipboard;
    property OnImage: TOnImage read FOnImage write FOnImage;
    property OnText: TOnText read FOnText write FOnText;
  end;

procedure Register;

implementation

constructor TRealClipboardViewer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF COMPILER6_UP}
  FHandle := Classes.AllocateHWND(WndProc);
  {$ELSE}
  FHandle := AllocateHWND(WndProc);
  {$ENDIF}
  FNextCB := SetClipboardViewer(FHandle);
  // (rom) removed a SetClipboardViewer line here
end;

destructor TRealClipboardViewer.Destroy;
begin
  {$IFDEF COMPILER6_UP}
  Classes.DeallocateHWnd(FHandle);
  {$ELSE}
  DeallocateHWnd(FHandle);
  {$ENDIF}
  ChangeClipboardChain(FHandle, FNextCB);
  inherited Destroy;
end;

procedure TRealClipboardViewer.EmptyClipboard;
begin
  OpenClipboard(Application.Handle);
  // (rom) added Windows. to avoid recursion
  Windows.EmptyClipboard;
  CloseClipboard;
end;

procedure TRealClipboardViewer.UpdateClip(var Msg: TWMDrawClipBoard);
var
  Bitmap: TBitmap;
begin
  inherited;
  if Clipboard.HasFormat(CF_BITMAP) and Assigned(FOnImage) then
  begin
    Bitmap := nil;
    try
      Bitmap := TBitmap.Create;
      Bitmap.Assign(Clipboard);
      FOnImage(Self, Bitmap);
    finally
      Bitmap.Free;
    end;
  end
  else
  if (Clipboard.HasFormat(CF_TEXT)) and Assigned(FOnText) then
    FOnText(Self, ClipBoard.AsText);
  Msg.Result := 0;
end;

procedure TRealClipboardViewer.WndProc(var Msg: TMessage);
begin
  if Msg.Msg = WM_DRAWCLIPBOARD then
   begin
    UpdateClip(TWMDrawClipBoard(Msg));
    SendMessage(FNextCB,Msg.Msg,Msg.wParam, Msg.lParam)   // My part
   end
  else
    Msg.Result := DefWindowProc(FHandle, Msg.Msg, Msg.wParam, Msg.lParam);
end;

procedure Register;
begin
  RegisterComponents('Real', [TRealClipboardViewer]);
end;

end.