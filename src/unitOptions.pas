unit unitOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Forms, ExtCtrls, ShellApi, StdCtrls, ComCtrls, Buttons, Dialogs;

{$R manifest.res}

type
  TfrmOptions = class(TForm)
    btnOK: TButton;
    pcOptions: TPageControl;
    tsOptionsGeneral: TTabSheet;
    tsOptionsKeys: TTabSheet;
    tsOptionsMisc: TTabSheet;
    gbGlobalHotKeys: TGroupBox;
    lblHotKeyEnable: TLabel;
    editHotKeyEnable: TEdit;
    bvlOptMiscA: TBevel;
    lblRestart: TLabel;
    comboxMainKey: TComboBox;
    lblOptMainKey: TLabel;
    bvlOptGeneralA: TBevel;
    comboxLang: TComboBox;
    lblOptLang: TLabel;
    dlgFont: TFontDialog;
    bvlOptKeysA: TBevel;
    lblFontLeftSide: TLabel;
    btnLeftSideFont: TButton;
    btnRightSideFont: TButton;
    btnDiacritFont: TButton;
    lblFontRightSide: TLabel;
    lblFontDiacrit: TLabel;
    chboxKbdDropShadow: TCheckBox;
    chboxUseClearType: TCheckBox;
    btnResetKbdFonts: TButton;
    lblResetFonts: TLabel;
    chboxShowPresetInfo: TCheckBox;
    Bevel1: TBevel;
    comboxDblClickMode: TComboBox;
    lblOptDblClickMode: TLabel;
    chboxKbdDelay: TCheckBox;
    optBalloonHint: TBalloonHint;
    procedure FormShow(Sender: TObject);
//    procedure rgMainKeyClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure editHotKeyEnableChange(Sender: TObject);
    procedure editHotKeyEnableKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
//    procedure editHotKeySettingsChange(Sender: TObject);
    procedure editHotKeyBlockKbdChange(Sender: TObject);
    procedure editHotKeyBlockKbdKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
//    procedure rgAddKeyClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure chboxUseClearTypeClick(Sender: TObject);
    procedure comboxMainKeyClick(Sender: TObject);
    procedure comboxLangClick(Sender: TObject);
    procedure btnLeftSideFontClick(Sender: TObject);
    procedure btnResetKbdFontsClick(Sender: TObject);
    procedure btnRightSideFontClick(Sender: TObject);
    procedure btnDiacritFontClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure chboxShowPresetInfoClick(Sender: TObject);
    procedure comboxDblClickModeChange(Sender: TObject);
    procedure chboxKbdDelayClick(Sender: TObject);
    procedure chboxKbdDropShadowClick(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure comboxMainKeyEnter(Sender: TObject);
    procedure SayAchtung(Title,Descr: string; Place: TPoint);
    procedure FormCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
  private
  public
  end;

var
  frmOptions: TfrmOptions;
  pointComboxMainKey: TPoint;

procedure SetAllFonts;

implementation

uses unitConst, unitAbout, unitKeyboard, unitKeySettings, unitFunctions, unitLang;


{$R *.dfm}


// ================== ФОРМА НАСТРОЕК ==================

procedure TfrmOptions.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
  // ↓ Точка вывода баллонного хинта на комбобоксе
  pointComboxMainKey := comboxMainKey.ClientOrigin;
  pointComboxMainKey.X := pointComboxMainKey.X + comboxMainKey.Width;
  pointComboxMainKey.Y := pointComboxMainKey.Y + comboxMainKey.Height;
  // ↑ Точка вывода баллонного хинта на комбобоксе
end;

procedure TfrmOptions.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//  frmKeyboard.DoBalloon(bfInfo, constMsgRestartApp);
//  isKbdShadow := chboxKbdDropShadow.Checked;
  optBalloonHint.HideHint;
  Settings_Save;
end;

procedure TfrmOptions.FormCreate(Sender: TObject);
begin
  // ↓ Проверка возможности установки глобального хоткея и его установка
  if EnableHotKeyCode <> 0 then
    if EnableHotKeyCode in [65..90] then begin
      hkEnable := GlobalAddAtom('Type it Easy Enable Hotkey'); // создаем «уникальный» атом
      if not AddGlobalWinHotKey(hkEnable, EnableHotKeyCode) then
        EnableHotKeyCode := 0;
    end;
  editHotKeyEnableChange(self);
  // ↑ Проверка возможности установки глобального хоткея и его установка

  pcOptions.ActivePageIndex := 0;
  frmKeyboard.CreateScrKbd;
  frmKeyboard.MakePresetMenu;
  LoadChars(CurrentPreset);
  if StartCounter = 0 then FirstStart;
end;

procedure TfrmOptions.FormShow(Sender: TObject);
begin
//  CatBtns.SelectedItem := CatBtns.Categories[0].Items[0];
//  ntbSettings.PageIndex := CatBtns.SelectedItem.Index;
  case ControlKey of
    VK_LCONTROL:  comboxMainKey.ItemIndex := 0;
    VK_LWIN:      comboxMainKey.ItemIndex := 1;
    VK_LMENU:     comboxMainKey.ItemIndex := 2;
    VK_RMENU:     comboxMainKey.ItemIndex := 3;
    VK_RWIN:      comboxMainKey.ItemIndex := 4;
    VK_RCONTROL:  comboxMainKey.ItemIndex := 5;
    //VK_POPUPMENU: rgMainKey.ItemIndex := 6;
  end;
//  case CurrentLang of
//    constLangEN_US:  comboxLang.ItemIndex := 0;
//    constLangRU_RU:  comboxLang.ItemIndex := 1;
//  end;
  EditHotKeyEnable.Text   := ' ' + chr(EnableHotKeyCode);
  //EditHotKeySettings.Text := ' ' + chr(SettingsHotKeyCode);
//  EditHotKeyBlockKbd.Text := ' ' + chr(BlockKbdHotKeyCode);
  chboxKbdDropShadow.Checked  := isKbdShadow;
  chboxUseClearType.Checked   := isClearType;
  chboxShowPresetInfo.Checked := isShowPresetInfo;
  chboxKbdDelay.Checked       := isKbdDelay;
  if DblClickMode then
    comboxDblClickMode.ItemIndex := 0
  else
    comboxDblClickMode.ItemIndex := 1;

//  frmKeyboard.CreateCaptionsScrKbd;
  //cbHotKey.ItemIndex := 0;
end;

procedure TfrmOptions.SayAchtung(Title, Descr: string; Place: TPoint);
begin
  optBalloonHint.Title := Title;
  optBalloonHint.Description := Descr;
  optBalloonHint.ShowHint(Place);
end;

procedure TfrmOptions.FormDeactivate(Sender: TObject);
begin
  optBalloonHint.HideHint;
end;

procedure TfrmOptions.FormDestroy(Sender: TObject);
begin
  Settings_Save;
  RemoveGlobalHotKey(hkEnable);
end;


// ================== НАСТРОЙКИ ПРОГРАММЫ ==================

// Выбор шрифтов экранной клавиатуры...
procedure SetAllFonts;
begin
  fntLeftSide.Name  := constLeftFontName;
  fntLeftSide.Size  := constLeftFontSize;
  fntLeftSide.Color := constLeftFontColor;
  if constLeftFontBold
    then fntLeftSide.Style := fntLeftSide.Style + [fsBold]
    else fntLeftSide.Style := fntLeftSide.Style - [fsBold];
  if constLeftFontItalic
    then fntLeftSide.Style := fntLeftSide.Style + [fsItalic]
    else fntLeftSide.Style := fntLeftSide.Style - [fsItalic];

  fntRightSide.Name  := constRightFontName;
  fntRightSide.Size  := constRightFontSize;
  fntRightSide.Color := constRightFontColor;
  if constRightFontBold
    then fntRightSide.Style := fntRightSide.Style + [fsBold]
    else fntRightSide.Style := fntRightSide.Style - [fsBold];
  if constRightFontItalic
    then fntRightSide.Style := fntRightSide.Style + [fsItalic]
    else fntRightSide.Style := fntRightSide.Style - [fsItalic];

  fntDiacrit.Name  := constDiacritFontName;
  fntDiacrit.Size  := constDiacritFontSize;
  fntDiacrit.Color := constDiacritFontColor;
  if constDiacritFontBold
    then fntDiacrit.Style := fntDiacrit.Style + [fsBold]
    else fntDiacrit.Style := fntDiacrit.Style - [fsBold];
  if constDiacritFontItalic
    then fntDiacrit.Style := fntDiacrit.Style + [fsItalic]
    else fntDiacrit.Style := fntDiacrit.Style - [fsItalic];

  frmKeyboard.CreateCaptionsScrKbd;
end;

procedure TfrmOptions.btnResetKbdFontsClick(Sender: TObject);
begin
  case MessageBoxEx(Handle, PChar(lngMsgResetFons),PChar(constProgramName),MB_OKCANCEL or MB_ICONQUESTION or MB_APPLMODAL, 0) of
    IDOK:     SetAllFonts;
    IDCANCEL: exit;
  end;
end;

// Выбор шрифтов экранной клавиатуры...
procedure TfrmOptions.btnLeftSideFontClick(Sender: TObject);
begin
  dlgFont.Font.Assign(fntLeftSide);
  if dlgFont.Execute
    then fntLeftSide.Assign(dlgFont.Font);
  frmKeyboard.CreateCaptionsScrKbd;
end;
// Выбор шрифтов экранной клавиатуры...
procedure TfrmOptions.btnRightSideFontClick(Sender: TObject);
begin
  dlgFont.Font.Assign(fntRightSide);
  if dlgFont.Execute
    then fntRightSide.Assign(dlgFont.Font);
  frmKeyboard.CreateCaptionsScrKbd;
end;
// Выбор шрифтов экранной клавиатуры.
procedure TfrmOptions.btnDiacritFontClick(Sender: TObject);
begin
  dlgFont.Font.Assign(fntDiacrit);
  if dlgFont.Execute
    then fntDiacrit.Assign(dlgFont.Font);
  frmKeyboard.CreateCaptionsScrKbd;
end;

// Спрятать форму настроек.
procedure TfrmOptions.btnOKClick(Sender: TObject);
begin
  Close;
end;

// Выбор режима КлирТайп.
procedure TfrmOptions.chboxKbdDelayClick(Sender: TObject);
begin
  isKbdDelay := chboxKbdDelay.Checked;
end;


procedure TfrmOptions.chboxKbdDropShadowClick(Sender: TObject);
begin
  isKbdShadow := chboxKbdDropShadow.Checked;
end;

procedure TfrmOptions.chboxShowPresetInfoClick(Sender: TObject);
begin
  isShowPresetInfo := chboxShowPresetInfo.Checked;
end;

procedure TfrmOptions.chboxUseClearTypeClick(Sender: TObject);
begin
  isClearType := chboxUseClearType.Checked;
  frmKeyboard.CreateCaptionsScrKbd;
end;

// Выбор языка.
procedure TfrmOptions.comboxDblClickModeChange(Sender: TObject);
begin
  DblClickMode := comboxDblClickMode.ItemIndex = 0;
end;

procedure TfrmOptions.comboxLangClick(Sender: TObject);
begin
  CurrentLang := GetLangCode(comboxLang.Items[comboxLang.ItemIndex]);
  DoLang(CurrentLang);
  if (lngAttentionAltGr <> '') and (ControlKey = VK_RMENU) then
    SayAchtung (lngMsgAchtung,lngAttentionAltGr, pointComboxMainKey);
end;



// Выбор основной кнопки.
procedure TfrmOptions.comboxMainKeyClick(Sender: TObject);
begin
  optBalloonHint.HideHint;
  ChangeMainKey;
end;

procedure TfrmOptions.comboxMainKeyEnter(Sender: TObject);
begin
  optBalloonHint.HideHint;
end;

// Выбор кнопки блокировки...
procedure TfrmOptions.editHotKeyBlockKbdChange(Sender: TObject);
begin
//  frmOptions.EditHotKeyBlockKbd.Text := ' ' + chr(BlockKbdHotKeyCode);
//  frmKeyboard.actBlockKbd.Caption   := lngBlockKbd + constLongSpace + {constOpenQuote +} lngWin + '+' + WideChar(Chr(BlockKbdHotKeyCode)){ + constCloseQuote};
//  Settings_Save;
//  RemoveHotKey;
//  AddHotKey;
end;

// Выбор кнопки блокировки.
procedure TfrmOptions.editHotKeyBlockKbdKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
//  BlockKbdHotKeyCode := Key;
end;

// Выбор кнопки активирования...
procedure TfrmOptions.editHotKeyEnableChange(Sender: TObject);
begin
  if (editHotKeyEnable.Text = '') or (editHotKeyEnable.Text = ' ') then EnableHotKeyCode := 0;
  if EnableHotKeyCode <> 0 then begin
    frmKeyboard.actEnable.Caption   := lngEnable + constLongSpace + {constOpenQuote +} lngWin + '+' + WideChar(Chr(EnableHotKeyCode)){ + constCloseQuote};
    EditHotKeyEnable.Text := ' ' + chr(EnableHotKeyCode)
  end
  else begin
    EditHotKeyEnable.Text := '';
    frmKeyboard.actEnable.Caption := lngEnable;
  end;
end;

// Выбор кнопки активирования.
procedure TfrmOptions.editHotKeyEnableKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if EnableHotKeyCode <> Key then
    if Key in [65..90] then begin
      RemoveGlobalHotKey(hkEnable);
      hkEnable := GlobalAddAtom('Type it Easy Enable Hotkey'); {--- создаем «уникальный» атом ---}
      if not AddGlobalWinHotKey(hkEnable, Key) then begin
        AddGlobalWinHotKey(hkEnable, EnableHotKeyCode);  // если не получилось назначить новый хоткей, то возвращаем предыдущий
        DoBalloon(bfInfo, SysErrorMessage(GetLastError))
      end
      else EnableHotKeyCode := Key
    end;
end;


// Выбор главной управляющей кнопки.
//procedure TfrmOptions.rgMainKeyClick(Sender: TObject);
//begin
//  isExtendedKey := true;
//  case frmOptions.comboxMainKey.ItemIndex of
//    0: ControlKey := VK_LCONTROL;
//    1: ControlKey := VK_LWIN;
//    2: ControlKey := VK_LMENU;
//    3: ControlKey := VK_RMENU;
//    4: ControlKey := VK_RWIN;
//    5: ControlKey := VK_RCONTROL;
    //    6: ControlKey := VK_POPUPMENU;
//  end;
//  if ControlKey in [VK_LCONTROL, VK_LWIN, VK_LMENU] then isExtendedKey := false;
//  Settings_Save;
//  frmKeyboard.actShowKbd.Caption := lngShowKbd + constLongSpace + {constOpenQuote +} comboxMainKey.Items[comboxMainKey.ItemIndex] + '+F1'{ + constCloseQuote};
    //  frmKeyboard.ReloadSettings;
//  frmKeyboard.RestartDll;
//end;

// Выбор дополнительной управляющей кнопки.
//procedure TfrmOptions.rgAddKeyClick(Sender: TObject);
//begin
//  isExtendedKey := true;   // Make with isExtendedAddKey!!!!!!!!!!!!!!!!!!!!!!!!!!!
//  case frmOptions.rgAddKey.ItemIndex of
//    0: AddControlKey := VK_LMENU;
//    1: AddControlKey := VK_RMENU;
//    2: AddControlKey := VK_LCONTROL;
//    3: AddControlKey := VK_RCONTROL;
//    4: AddControlKey := VK_LWIN;
//    5: AddControlKey := VK_RWIN;
//    6: AddControlKey := VK_POPUPMENU;
//  end;
//  if AddControlKey in [VK_LCONTROL, VK_LWIN, VK_LMENU] then isExtendedKey := false;
//  frmOptions.Settings_Save;
//  frmOptions.ReloadSettings;
//end;

end.
