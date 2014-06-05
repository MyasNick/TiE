unit unitKeySettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  StdCtrls, Mask, ExtCtrls, Buttons, RealSpeedButton, RealKey,
  ImgList, Menus, IniFiles, Dialogs, ComCtrls;

type
  TfrmKeySettings = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    bvlKeySettings: TBevel;
    rkExample: TRealKey;
    shpAbout: TShape;
    editTopChar: TButtonedEdit;
    lblTopChar: TLabel;
    lblBottomChar: TLabel;
    ilEditBtns: TImageList;
    editBottomChar: TButtonedEdit;
    btnClear: TButton;
    llblFindCodesHere: TLinkLabel;
    lblEnterCodes: TLabel;
    dlgFont: TFontDialog;
    pmTopChar: TPopupMenu;
    pmTopCharFont: TMenuItem;
    pmTopCharFontReset: TMenuItem;
    N1: TMenuItem;
    pmBottomChar: TPopupMenu;
    pmBottomCharFont: TMenuItem;
    pmBottomCharFontReset: TMenuItem;
    N3: TMenuItem;
    ProgressBar: TProgressBar;
    procedure btnOKClick(Sender: TObject);
    procedure editTopCharChange(Sender: TObject);
    procedure GetCaptionStrings;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure llblFindCodesHereLinkClick(Sender: TObject; const Link: string; LinkType: TSysLinkType);
    procedure pmTopCharFontClick(Sender: TObject);
    procedure pmTopCharFontResetClick(Sender: TObject);
    procedure pmBottomCharFontClick(Sender: TObject);
    procedure pmBottomCharFontResetClick(Sender: TObject);
    procedure pmTopCharPopup(Sender: TObject);
    procedure MenuTopCharOnClick(Sender: TObject);
    procedure MenuBtmCharOnClick(Sender: TObject);
  private
    procedure SetFontForChar (Fnt: TFont; Txt: string);
    procedure ResetFontOfChar (Txt: string);
  public
    procedure ShowHide(DoShow: boolean);
  end;

var
  frmKeySettings: TfrmKeySettings;
  strTOP, strBOTTOM,
  strTOPold, strBOTTOMold: string;

implementation

uses unitAbout, unitKeyboard, unitConst, unitFunctions, unitLang;

{$R *.dfm}

// получаем символы из кодов в эдитах
procedure TfrmKeySettings.GetCaptionStrings;
var k: integer;
begin

  if editTopChar.Text <> '' then

    if (Length(editTopChar.Text) > 1) and TryStrToInt('$' + editTopChar.Text, k) then
      strTOP := Char(k)
    else
      strTOP := editTopChar.Text[1]

  else
    strTOP := '';

    

  if editBottomChar.Text <> '' then

    if (Length(editBottomChar.Text) > 1) and TryStrToInt('$' + editBottomChar.Text, k) then
      strBOTTOM := Char(k)
    else
      strBOTTOM := editBottomChar.Text[1]

  else
    strBOTTOM := '';

end;

// Пошли по ссылке искать коды
procedure TfrmKeySettings.llblFindCodesHereLinkClick(Sender: TObject; const Link: string; LinkType: TSysLinkType);
begin
  if LinkType = sltURL then
    GoOnline (link)
  else
    ExecuteFile (link);
end;

procedure TfrmKeySettings.MenuBtmCharOnClick(Sender: TObject);
begin
  editBottomChar.Text := IntToHex((Sender as TMenuItem).Tag,4);
end;

procedure TfrmKeySettings.MenuTopCharOnClick(Sender: TObject);
begin
  editTopChar.Text := IntToHex((Sender as TMenuItem).Tag,4);
end;

// Индивидуальные шрифты для отдельных символов...
procedure TfrmKeySettings.SetFontForChar (Fnt: TFont; Txt: string);
var FileOptions: TIniFile;
begin
  dlgFont.Font.Assign(Fnt);
  if dlgFont.Execute then
  begin
    Fnt.Assign(dlgFont.Font);
    try begin
      FileOptions   := TIniFile.Create (AppDataPath + SetsFileName);
      SaveFontToIni(dlgFont.Font, FileOptions, Txt);
      FileOptions.Free;
    end;
    except
    end;
  end;
end;

procedure TfrmKeySettings.ShowHide(DoShow: boolean);
begin
  bvlKeySettings.Visible    := DoShow;
  shpAbout.Visible          := DoShow;
  lblTopChar.Visible        := DoShow;
  lblBottomChar.Visible     := DoShow;
  lblEnterCodes.Visible     := DoShow;
  llblFindCodesHere.Visible := DoShow;
  rkExample.Visible         := DoShow;
  editTopChar.Visible       := DoShow;
  editBottomChar.Visible    := DoShow;
  btnOK.Visible             := DoShow;
  btnCancel.Visible         := DoShow;
  btnClear.Visible          := DoShow;
  ProgressBar.Visible       := not DoShow;

end;

// Индивидуальные шрифты для отдельных символов...
procedure TfrmKeySettings.pmTopCharFontClick(Sender: TObject);
begin
//  SetFontForChar(rkExample.FontTopRight, editTopChar.Text);
  SetFontForChar((frmKeyboard.pmKbd.PopupComponent as TRealKey).FontTopRight, editTopChar.Text);
  rkExample.FontTopRight.Assign((frmKeyboard.pmKbd.PopupComponent as TRealKey).FontTopRight);
  rkExample.FontTopRight.Size := constKeyFontSizeLargest;
  rkExample.Refresh;
end;
// Индивидуальные шрифты для отдельных символов...
procedure TfrmKeySettings.pmBottomCharFontClick(Sender: TObject);
begin
//  SetFontForChar(rkExample.FontBottomRight, editBottomChar.Text);
  SetFontForChar((frmKeyboard.pmKbd.PopupComponent as TRealKey).FontBottomRight, editBottomChar.Text);
  rkExample.FontBottomRight.Assign((frmKeyboard.pmKbd.PopupComponent as TRealKey).FontBottomRight);
  rkExample.FontBottomRight.Size := constKeyFontSizeLargest;
  rkExample.Refresh;
end;
// Индивидуальные шрифты для отдельных символов...
procedure TfrmKeySettings.ResetFontOfChar (Txt: string);
var FileOptions: TIniFile;
begin
  try begin
    FileOptions   := TIniFile.Create (AppDataPath + SetsFileName);
    FileOptions.DeleteKey('Fonts', Txt + '.Name');
    FileOptions.DeleteKey('Fonts', Txt + '.Size');
    FileOptions.DeleteKey('Fonts', Txt + '.Color');
    FileOptions.DeleteKey('Fonts', Txt + '.Bold');
    FileOptions.DeleteKey('Fonts', Txt + '.Italic');
    FileOptions.Free;
  end;
  except
  end;
  editTopCharChange(self);
end;

// Индивидуальные шрифты для отдельных символов...
procedure TfrmKeySettings.pmTopCharFontResetClick(Sender: TObject);
begin
  ResetFontOfChar (editTopChar.Text);
end;

// Индивидуальные шрифты для отдельных символов...
procedure TfrmKeySettings.pmTopCharPopup(Sender: TObject);
begin
  pmTopCharFont.Enabled         := editTopChar.Text <> '';
  pmTopCharFontReset.Enabled    := editTopChar.Text <> '';
  pmBottomCharFont.Enabled      := editBottomChar.Text <> '';
  pmBottomCharFontReset.Enabled := editBottomChar.Text <> '';
end;

// Индивидуальные шрифты для отдельных символов.
procedure TfrmKeySettings.pmBottomCharFontResetClick(Sender: TObject);
begin
  ResetFontOfChar (editBottomChar.Text);
end;

// нажимаем ОК, закрываем форму, запоминаем новые настройки
procedure TfrmKeySettings.btnOKClick(Sender: TObject);
begin
  GetCaptionStrings;
  SetKeyCaptions(frmKeyboard.pmKbd.PopupComponent as TRealKey, '~~', '~~', strTOP, strBOTTOM, '~~');
  if strBOTTOM <> ''
    then CharTable[true,(frmKeyboard.pmKbd.PopupComponent as TRealKey).Tag] := strBOTTOM[1]
    else CharTable[true,(frmKeyboard.pmKbd.PopupComponent as TRealKey).Tag] := #0;
  if strTOP <> ''
    then CharTable[false,(frmKeyboard.pmKbd.PopupComponent as TRealKey).Tag] := strTOP[1]
    else CharTable[false,(frmKeyboard.pmKbd.PopupComponent as TRealKey).Tag] := #0;
  if (strTOP <> strTOPold) or (strBOTTOM <> strBOTTOMold) then isKbdChanged := true;
  if isKbdChanged then
  begin
    SaveCharsToIni (KbdFileNameUser);
    frmKeyboard.SetUserPreset;
    isKbdChanged := false;
  end;
  frmKeyboard.CreateCaptionsScrKbd;
//  DoLang(CurrentLang);
  frmKeyboard.lblKbdCaptionPreset.Font.Color := constKeyFontColorNormal;
  frmKeyboard.lblKbdCaptionPreset.Caption := Format(lngFrmKbdCaption, [GetHumanizedPresetName(CurrentPreset)]);
end;

// задаем код нижнего основного и верхнего дополнительного (шифт-) символа
procedure TfrmKeySettings.editTopCharChange(Sender: TObject);
begin
  GetCaptionStrings;
  SetKeyCaptions (rkExample, '~~', '~~', strTOP, strBOTTOM, '~~');
  btnClear.Enabled := (strTOP<>'') or (strBOTTOM<>'');

  if ((GetIntFromStr('$'+editTopChar.Text)) - constPerdPrefix) in Perdyshki
        then rkExample.FontTopRight.Assign(fntDiacrit)
        else rkExample.FontTopRight.Assign(fntRightSide);

  if ((GetIntFromStr('$'+editBottomChar.Text)) - constPerdPrefix) in Perdyshki
        then rkExample.FontBottomRight.Assign(fntDiacrit)
        else rkExample.FontBottomRight.Assign(fntRightSide);

  rkExample.FontTopRight.Size := constKeyFontSizeLargest;
  rkExample.FontBottomRight.Size := constKeyFontSizeLargest;
  rkExample.Refresh;
end;

// создаем форму
procedure TfrmKeySettings.FormCreate(Sender: TObject);
begin
  with rkExample do
  begin
    FontTopLeft.Name   := constKeyFontName;
    FontTopLeft.Size   := constKeyFontSizeLargest;
    FontTopLeft.Color  := constKeyFontColorNormal;
    FontBottomLeft     := FontTopLeft;
    Font               := FontTopLeft;
    FontTopRight       := FontTopLeft;
    FontTopRight.Color := constKeyFontCustomChar;
    FontBottomRight    := FontTopRight;
  end;
end;

// показываем форму
procedure TfrmKeySettings.FormShow(Sender: TObject);
var s1, s2: string;
begin
  rkExample.FontTopLeft.Assign((frmKeyboard.pmKbd.PopupComponent as TRealKey).FontTopLeft);
  rkExample.FontBottomLeft.Assign((frmKeyboard.pmKbd.PopupComponent as TRealKey).FontBottomLeft);
  rkExample.FontTopRight.Assign((frmKeyboard.pmKbd.PopupComponent as TRealKey).FontTopRight);
  rkExample.FontBottomRight.Assign((frmKeyboard.pmKbd.PopupComponent as TRealKey).FontBottomRight);
  rkExample.FontTopLeft.Size      := constKeyFontSizeLargest;
  rkExample.FontBottomLeft.Size   := constKeyFontSizeLargest;
  rkExample.FontTopRight.Size     := constKeyFontSizeLargest;
  rkExample.FontBottomRight.Size  := constKeyFontSizeLargest;

  s1 := (frmKeyboard.pmKbd.PopupComponent as TRealKey).CaptionTopRight;
  s2 := (frmKeyboard.pmKbd.PopupComponent as TRealKey).CaptionBottomRight;
  btnClear.Enabled := (s1<>'') or (s2<>'');
  SetKeyCaptions (rkExample, '~~', '~~', s1, s2, '~~');
  // !!! далее используется двубайтовый тип WORD для получения юникода символа. Будет ли он двубайтовым на x64?
  if s1 <> ''
    then editTopChar.Text    := IntToHex(Word(s1[1]), 4)
    else editTopChar.Text    := s1;
  if s2 <> ''
    then editBottomChar.Text := IntToHex(Word(s2[1]), 4)
    else editBottomChar.Text := s2;
  strTOPold    := s1;
  strBOTTOMold := s2;

  editBottomChar.SetFocus;
end;

// чистим все эдиты
procedure TfrmKeySettings.btnClearClick(Sender: TObject);
begin
  editTopChar.Text := '';
  editBottomChar.Text := '';
end;

end.
