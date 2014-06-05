unit unitNewPreset;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  StdCtrls, ExtCtrls, Dialogs;

type
  TfrmNewPreset = class(TForm)
    shpAbout: TShape;
    bvlKeySettings: TBevel;
    btnOK: TButton;
    btnCancel: TButton;
    editNewPresetName: TLabeledEdit;
    dlgSavePreset: TSaveDialog;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmNewPreset: TfrmNewPreset;

implementation

uses unitConst, unitKeyboard, unitFunctions, unitLang;

{$R *.dfm}

procedure TfrmNewPreset.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmNewPreset.btnOKClick(Sender: TObject);

  procedure SaveNClose;
  begin
    SaveCharsToIni(editNewPresetName.Text);
    CurrentPreset := editNewPresetName.Text;
    frmKeyboard.MakePresetMenu;
    Close;
  end;

  procedure CreateNClose;
  var i: integer;
  begin
    for i := 1 to constMaxLogicKeys do
    begin
      CharTable[false,i] := #0;
      CharTable[true,i]  := #0;
    end;
    frmKeyboard.CreateCaptionsScrKbd;
    SaveNClose;
  end;

begin

  if editNewPresetName.Text = KbdFileNameUser
  then begin
    MessageBoxEx(Handle, PChar(Format(lngMsgAnotherName,[KbdFileNameUser, #10#13])),PChar(constProgramName),MB_OK or MB_ICONINFORMATION or MB_APPLMODAL, 0);
    exit;
  end;

  if isCreateOrSavePreset  // создаем новый пустой пресет
  then begin
    if not FileExists(AppPresetPath + editNewPresetName.Text + PresetFilesExt)
      then CreateNClose
      else case MessageBoxEx(Handle, PChar(Format(lngMsgOverWPreset,[editNewPresetName.Text,#10#13])),PChar(constProgramName),MB_OKCANCEL or MB_ICONQUESTION or MB_APPLMODAL, 0) of
        IDOK:     CreateNClose;
        IDCANCEL: exit;
      end;
  end
  else begin               // сохраняем готовый пользовательский пресет
    if not FileExists(AppPresetPath + editNewPresetName.Text + PresetFilesExt)
      then SaveNClose
      else case MessageBoxEx(Handle, PChar(Format(lngMsgOverWPreset,[editNewPresetName.Text,#10#13])),PChar(constProgramName),MB_OKCANCEL or MB_ICONQUESTION or MB_APPLMODAL, 0) of
        IDOK:     SaveNClose;
        IDCANCEL: exit;
      end;
  end;

  frmKeyboard.lblKbdCaptionPreset.Caption := Format(lngFrmKbdCaption, [GetHumanizedPresetName(CurrentPreset)]);

end;

procedure TfrmNewPreset.FormShow(Sender: TObject);
begin
  if (CurrentPreset <> KbdFileNameUser) and (CurrentPreset <> KbdDefault)
    then editNewPresetName.Text := CurrentPreset + ' 1'
    else editNewPresetName.Text := lngTxtNewPreset;
  editNewPresetName.SetFocus;
  editNewPresetName.SelectAll;
end;

end.
