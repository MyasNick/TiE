unit unitAbout;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  jpeg, ExtCtrls, StdCtrls, RealLabel, Buttons, RealSpeedButton, RealKey;

type
  TfrmAbout = class(TForm)
    lblMadeInGrey: TLabel;
    lblMadeInWhite: TLabel;
    lblProgramName: TLabel;
    lblVersion: TLabel;
    lblHomePage: TRealLabel;
    lblCopyright: TRealLabel;
    imgAboutBack: TImage;
    btnOK: TRealKey;
    rsbExit: TRealSpeedButton;
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  frmAbout: TfrmAbout;
  isCapture: boolean;
  MouseDownSpot: TPoint;

implementation

{$R *.dfm}

procedure TfrmAbout.btnOKClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAbout.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.WindowClass.Style := Params.WindowClass.Style or CS_DROPSHADOW;
end;

procedure TfrmAbout.FormCreate(Sender: TObject);
begin
  //rsbExit.BmpNormal.LoadFromResourceName  (Hinstance,'ExitNormal'); // уже загружен в дизайнере
  rsbExit.BmpActive.LoadFromResourceName  (Hinstance,'ExitActive');
  rsbExit.BmpDown.LoadFromResourceName    (Hinstance,'ExitDown');
  rsbExit.BmpDisable.LoadFromResourceName (Hinstance,'ExitDisable');
  btnOK.Style := bsCool;
  btnOK.BmpNormal.LoadFromResourceName   (Hinstance,'StdBtnNormal');
  btnOK.BmpActive.LoadFromResourceName   (Hinstance,'StdBtnActive');
  btnOK.BmpDown.LoadFromResourceName     (Hinstance,'StdBtnDown');
  btnOK.BmpDisable.LoadFromResourceName  (Hinstance,'StdBtnDisable');
end;

procedure TfrmAbout.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_ESCAPE then Close;
end;

procedure TfrmAbout.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (isCapture) or (Button <> mbLeft) then exit;
  SetCapture(Handle);
  isCapture := true;
  MouseDownSpot.X := X;
  MouseDownSpot.Y := Y;
end;

procedure TfrmAbout.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
 if isCapture then
  begin
    Left := Left - (MouseDownSpot.x - x);
    Top  := Top  - (MouseDownSpot.y - y);
  end;
end;

procedure TfrmAbout.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if isCapture then
  begin
    ReleaseCapture;
    isCapture := false;
    Left := Left - (MouseDownSpot.x - x);
    Top := Top - (MouseDownSpot.y - y);
  end;
  isCapture := false;
end;

end.
