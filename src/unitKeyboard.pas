unit unitKeyboard;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Buttons, Menus, ExtCtrls, RealKey, jpeg,
  RealSpeedButton, StdCtrls, unitConst, IniFiles, ShellApi,
  ActnList, ImgList, StrUtils, RealStrings, ClipBrd, WinErrorCodes,
  JwaWinNT;

type

 // TCharEditMode = (cemHEX, cemDEC, cemSTR);

  TfrmKeyboard = class(TForm)
    pmKbd: TPopupMenu;
    pmKbdClose: TMenuItem;
    rsbExit: TRealSpeedButton;
    imgKbd: TImage;
    N1: TMenuItem;
    pmKeySettings: TMenuItem;
    TrayIcon: TTrayIcon;
    ilIcons: TImageList;
    ActList: TActionList;
    actExit: TAction;
    actAbout: TAction;
    actShowKbd: TAction;
    actEnable: TAction;
    actSettings: TAction;
    actLearnMode: TAction;
    actHelpTopics: TAction;
    actGoHomePage: TAction;
    actGoCheckUpd: TAction;
    actBlockKbd: TAction;
    actKbdClose: TAction;
    actShowKeySets: TAction;
    pmMain: TPopupMenu;
    pmEnable: TMenuItem;
    N3: TMenuItem;
    pmShowKeyboard: TMenuItem;
    pmLearnMode: TMenuItem;
    N2: TMenuItem;
    pmBlockKbd: TMenuItem;
    pmSettings: TMenuItem;
    N4: TMenuItem;
    pmHelp: TMenuItem;
    pmHelpTopics: TMenuItem;
    N5: TMenuItem;
    pmHomePage: TMenuItem;
    pmCheckUpdates: TMenuItem;
    N6: TMenuItem;
    pmAbout: TMenuItem;
    N7: TMenuItem;
    pmExit: TMenuItem;
    pmChoosePreset: TMenuItem;
    pmPresetUserDefined: TMenuItem;
    pmPresetDefault: TMenuItem;
    pmKbdOptions: TMenuItem;
    pmPresetSaveAs: TMenuItem;
    N8: TMenuItem;
    actGoDonate: TAction;
    pmDonate: TMenuItem;
    actSettingsKbdPage: TAction;
    pmOpenPresetFolder: TMenuItem;
    pmDeleteCurrentPreset: TMenuItem;
    actSaveNewPreset: TAction;
    actOpenPresetsFolder: TAction;
    slRegularKeysRU: TRealStrings;
    actLoadPresetUser: TAction;
    actLoadPresetDefault: TAction;
    N9: TMenuItem;
    slShiftKeysRU: TRealStrings;
    actDeleteCurPreset: TAction;
    N10: TMenuItem;
    pmTrayPresets: TMenuItem;
    pmTrayDeleteCurPreset: TMenuItem;
    N11: TMenuItem;
    pmTrayOpenPresetsFolder: TMenuItem;
    pmTraySaveNewPreset: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    pmTrayLoadPresetDefault: TMenuItem;
    pmTrayLoadPresetUser: TMenuItem;
    actCreateNewPreset: TAction;
    pmCreateNewPreset: TMenuItem;
    pmTrayCreateNewPreset: TMenuItem;
    slSpecialFonts: TRealStrings;
    slRegularKeysEN: TRealStrings;
    slShiftKeysEN: TRealStrings;
    actFirstStartWizard: TAction;
    N14: TMenuItem;
    mmFirstStartWizard: TMenuItem;
    lblKbdCaptionPreset: TLabel;
    N15: TMenuItem;
    pmKbdCopy: TMenuItem;
    pmKbdCopyAdd: TMenuItem;
    actKbdCopy: TAction;
    actKbdCopyAdd: TAction;
    pmSetKeys: TMenuItem;
    actSetKeys: TAction;
    N16: TMenuItem;
    tmrDelay: TTimer;
    tmrKbdFadeInOut: TTimer;
    N17: TMenuItem;
    pmTrayRestoreStdPresets: TMenuItem;
    actRestoreStdPresets: TAction;
    N18: TMenuItem;
    pmRestoreStdPresets: TMenuItem;
    procedure actExitExecute(Sender: TObject);
    procedure actAboutExecute(Sender: TObject);
    procedure actShowKbdExecute(Sender: TObject);
    procedure actEnableExecute(Sender: TObject);
    procedure actSettingsExecute(Sender: TObject);
    procedure actLearnModeExecute(Sender: TObject);
    procedure actGoHomePageExecute(Sender: TObject);
    procedure actHelpTopicsExecute(Sender: TObject);
    procedure actBlockKbdExecute(Sender: TObject);
    procedure actKbdCloseExecute(Sender: TObject);
    procedure TrayIconDblClick(Sender: TObject);
    procedure TrayIconMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure actShowKeySetsExecute(Sender: TObject);

    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure FormDblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure pmKbdPopup(Sender: TObject);
    procedure pmMainPopup(Sender: TObject);
    procedure actSettingsKbdPageExecute(Sender: TObject);
    procedure actSaveNewPresetExecute(Sender: TObject);
    procedure actOpenPresetsFolderExecute(Sender: TObject);
    procedure actLoadPresetUserExecute(Sender: TObject);
    procedure actLoadPresetDefaultExecute(Sender: TObject);
    procedure actDeleteCurPresetExecute(Sender: TObject);
    procedure actCreateNewPresetExecute(Sender: TObject);
    procedure actGoCheckUpdExecute(Sender: TObject);
    procedure actGoDonateExecute(Sender: TObject);
    procedure actFirstStartWizardExecute(Sender: TObject);
    procedure actKbdCopyExecute(Sender: TObject);
    procedure actKbdCopyAddExecute(Sender: TObject);
    procedure KbdKeyDown (Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure actSetKeysExecute(Sender: TObject);
    procedure tmrDelayTimer(Sender: TObject);
    procedure tmrKbdFadeInOutTimer(Sender: TObject);
    procedure actRestoreStdPresetsExecute(Sender: TObject);
  private
    // Startup Wizard
    {DLLWzrdHandle   : THandle;
    DLLWzrdFirstStartWizardClose,
    DLLWzrdFirstStartWizardFree,
    DLLWzrdFirstStartWizardShow: TTieProc;}
    procedure WM_HotKeyHandler (var Message: TMessage); message WM_HOTKEY;
  public
    procedure CreateScrKbd;
    procedure CreateCaptionsScrKbd;
    {procedure LoadWzrdDLL;}
    {procedure FirstStartWizard;}
    procedure ActivateHookAndKeys (doit: boolean);
    procedure DefaultHandler(var Message); override;
    procedure DoIcon (IconNumber: integer);
    procedure MakePresetMenu;
    procedure PresetClick(Sender: TObject);
    procedure SetUserPreset;
    procedure LoadCharFont (ResultFont,DefFont: TFont; CharCode: char);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  frmKeyboard: TfrmKeyboard;

  CM_TIE_ONEINST, CM_TIE_INFO    // CM_TIE_INFO  WPARAM = 1 активировать    actFirstStartWizard
  : DWORD;                       //                     = 2 деактивировать  actFirstStartWizard

  AppPath, AppDataPath, AppPresetPath, AppLocalsPath, Sys32Path, CurrentLangName, CurrentPreset: string;
  StartCounter, MinAlphaValue, KbdTop, KbdLeft, KbdAlphaBlendValue: integer;

  isStartUp {}, isShowPresetInfo,
  isActivated, isExtendedKey{Указывает левую клавищу из пары, напр левый контрол},
  isKbdShown, isAltF1Pressed,
  isControlKeyPressed, isMyKeyDownUp,
  isLeftBtn, isKbdShadow, isKbdDelayGone, isKbdDelay,
  isKbdChanged, isCreateOrSavePreset, // определяет, что мы хотим: создать новый пресет (true) или сохранить под другим названием пользовательский (false)
  isClearType: boolean;

  ControlKey,     {клавиша для печати символов, управляющая клавиша}
  AddControlKey,  {дополнительная клавиша печати символов, временное переключение раскладки}
  CurrentLang       : word;

//  PowerKeyInfoBufAC, PowerKeyInfoBufDC: array[0..1024] of char;
  PowerKeyInfoBufAC, PowerKeyInfoBufDC, PowerKeyInfoBufLocked: SYSTEM_POWER_POLICY;
//  PowerKeyInfoBufAC, PowerKeyInfoBufDC, PowerKeyInfoBufLocked: TSystemPowerPolicy;

  DblClickMode      : boolean; // true - activate/deactivate; false - show kbd

  // Hot keys
  hkEnable, hkSettings, hkBlockKbd: byte; // Global Atom Vars
  EnableHotKeyCode{,} {SettingsHotKeyCode,} {BlockKbdHotKeyCode}: word; {буква для горячей клавиши активации TiE}

//  CharEditModeBottom, CharEditModeTop: TCharEditMode;
  isCapture: boolean;
  MouseDownSpot: TPoint;
  keyNr, CurKeyScanCode: integer;
  ScrKeys:   array [0..constMaxRealKeys] of TRealKey; // кнопки экранной клавиатуры
  CharTable: array [boolean, 1..constMaxLogicKeys] of char; // таблица перевода скан кода (true - символ / false - shift-символ; 2-й индекс массива) в код символа (содержимое ячейки)
//  SystemKeys: TControlKeySet;

  fntLeftSide, fntRightSide, fntDiacrit: TFont;

// Глобальные функции: объявление
procedure CloseAppOnErr;
procedure ShowKeyboard (DoShowKbd: boolean);
function  AddGlobalWinHotKey(hotatom: byte; hotkey: word): boolean;
function  RemoveGlobalHotKey(hotatom: byte): boolean;
procedure Settings_Load;
procedure Settings_Save;
procedure LoadChars (fn: string);
procedure SaveCharsToIni   (fn: string);
procedure SetKeyCaptions   (Key: TRealKey; TL{Top-Left Caption}, BL{Bottom-Left}, TR{Top-Right}, BR{Bottom-Right}, CC{Regular Caption}: String); // используй ~~ чтобы оставить старый капшн
procedure TypeIt (sc: byte);
function  TypeItNew (sc: byte): boolean;
procedure ShowCurrentPreset;
procedure ChangeMainKey;
procedure DoBalloon(Flag: TBalloonFlags; Text: widestring);
procedure DoBalon(Text: widestring); // короткий вариант DoBalloon-a

implementation

uses unitKeySettings, unitOptions, unitAbout, unitFunctions, unitNewPreset, unitLang,
     unitHook, unitMakeMenuFromIni;

var MkMenuFromIni: TMakeMenuFromIniThread;


{$R *.dfm}


// вставка символа моей старой процедурой - нужно для отладки
procedure TypeIt (sc: byte);    // sc = ScanCode
 var
  Symbol: char;
  hFocusedControl, hForeWindow: HWND;
  dwForeThread: DWORD;
  ti: TGUIThreadInfo;
begin

  // Получаем доступ через Handle к контролу с кареткой
  hFocusedControl := GetFocus;
  if hFocusedControl = 0 then
  begin
    hForeWindow  := GetForegroundWindow;
    dwForeThread := GetWindowThreadProcessId(hForeWindow, nil);
    if dwForeThread <> 0 then
    begin
      ZeroMemory(@ti, sizeof (TGUITHREADINFO));
      ti.cbSize := sizeof (TGUITHREADINFO);
      GetGUIThreadInfo(dwForeThread, ti);
      hFocusedControl := ti.hwndFocus;
    end;
  end;
  // /Получаем доступ через Handle к контролу с кареткой

  case sc of
    {enter}28: Symbol := Char($0301); // ударение, комбинируемый акут // СДЕЛАТЬ ТОЛЬКО В РУССКОМ ЯЗЫКЕ!!!
    {space}57: Symbol := Char($00A0); // неразрывный пробел
        {←}75: Symbol := Char($2190);
        {↑}72: Symbol := Char($2191);
        {→}77: Symbol := Char($2192);
        {↓}80: Symbol := Char($2193);
  else
    if (GetKeyState(VK_SHIFT) and KF_UP) = 0    {--- Shift не нажат ---}
      then Symbol := CharTable[true, sc]
      else Symbol := CharTable[false, sc]
  end;

  // мой вариант вставки символа
  if Symbol <> #0 then
    SendCharToApp (hFocusedControl, Symbol);

end;

// вставка символа фрилансерской процедурой
function TypeItNew (sc: byte): boolean;    // sc = ScanCode
var
  Symbol: char;
begin
  case sc of
    {enter}28: Symbol := Char($0301); // ударение, комбинируемый акут // СДЕЛАТЬ ТОЛЬКО В РУССКОМ ЯЗЫКЕ!!!
    {space}57: Symbol := Char($00A0); // неразрывный пробел
        {←}75: Symbol := Char($2190);
        {↑}72: Symbol := Char($2191);
        {→}77: Symbol := Char($2192);
        {↓}80: Symbol := Char($2193);
  else
    if (GetKeyState(VK_SHIFT) and KF_UP) = 0    {--- Shift не нажат ---}
      then Symbol := CharTable[true, sc]
      else Symbol := CharTable[false, sc]
  end;

  // проба варианта фрилансера
  if Symbol <> #0 then
    DoSendText (string(Symbol), false);

  Result := Symbol <> #0;
//  DoBalloon(bfInfo, Symbol);

end;

procedure ShowCurrentPreset;
var prst: string;
begin
  if CurrentPreset = KbdFileNameUser
    then prst := lngPresetUser
    else if CurrentPreset = KbdDefault
           then prst := lngPresetDefault
           else prst := CurrentPreset;
  DoBalloon(bfInfo, lngMsgPresetLoaded + ' ' + prst);
end;

procedure ChangeMainKey;
begin
  isExtendedKey := true;
  case frmOptions.comboxMainKey.ItemIndex of
    0: ControlKey := VK_LCONTROL;
    1: ControlKey := VK_LWIN;
    2: ControlKey := VK_LMENU;
    3: ControlKey := VK_RMENU;
    4: ControlKey := VK_RWIN;
    5: ControlKey := VK_RCONTROL;
    //6: ControlKey := VK_POPUPMENU;
  end;

  if ControlKey in [VK_LCONTROL, VK_LWIN, VK_LMENU] then isExtendedKey := false;

  if (ControlKey = VK_RMENU) and (lngAttentionAltGr <> '') then
    frmOptions.SayAchtung (lngMsgAchtung,lngAttentionAltGr, pointComboxMainKey);

  if (ControlKey = VK_RWIN) or (ControlKey = VK_LWIN) then
    frmOptions.SayAchtung (lngMsgAchtung,lngMsgAttentionWin, pointComboxMainKey);

  {if not isExtendedKey  // левые упр. кнопки
    then begin
      for i := 0 to constMaxRealKeys do
//        case ScrKeys[i].Tag of
//        end;

    end
    else begin          // правые упр. кнопки

    end;}
  Settings_Save;
  // меняем текст в меню
  frmKeyboard.actShowKbd.Caption  := lngShowKbd  + constLongSpace + frmOptions.comboxMainKey.Items[frmOptions.comboxMainKey.ItemIndex] + '+' + constKbdHintKeyStr;
  frmKeyboard.actBlockKbd.Caption := lngBlockKbd + constLongSpace + frmOptions.comboxMainKey.Items[frmOptions.comboxMainKey.ItemIndex] + '+' + constKbdBlockKeyStr;
end;



// ===================== ХУК =======================

// отработка хука: блокировка/разблокировка клавы (ВИДИМО ПЕРЕДЕЛАТЬ)
procedure TfrmKeyboard.ActivateHookAndKeys(doit: boolean);
begin

  actEnable.Checked := doit;

  if actBlockKbd.Checked
    then if doit
      then DoIcon(5)
      else DoIcon(4)
    else if doit
      then DoIcon(1)
      else DoIcon(0);

  actBlockKbd.Enabled := doit;

//  if actBlockKbd.Checked then exit;
  if actBlockKbd.Checked then begin
    actBlockKbdExecute(Self);
  end;

  if doit
    then StartHook
    else StopHook;
end;


// ===================== HOT-KEYS =======================

// горячие клавиши приложения: добавить
function AddGlobalWinHotKey(hotatom: byte; hotkey: word): boolean;
begin            
  if hotkey <> 0 then
    try
      Result := RegisterHotKey(frmKeyboard.handle, hotatom, MOD_WIN, hotkey);
      if not Result then
//        DoBalloon(bfInfo, SysErrorMessage(GetLastError));
    except
//      DoBalloon(bfInfo, SysErrorMessage(GetLastError));
      Result := false;
    end
  else 
    Result := false;
end;

// горячие клавиши приложения: убрать
function RemoveGlobalHotKey(hotatom: byte): boolean;
begin
    try
      Result := UnregisterHotKey(frmKeyboard.Handle, hotatom);
      if not Result then begin
//        DoBalloon(bfInfo, SysErrorMessage(GetLastError));
      end
      else
        GlobalDeleteAtom(hotatom);
    except
//      DoBalloon(bfInfo, SysErrorMessage(GetLastError));
      Result := false;
    end
end;

// горячие клавиши приложения: обработчик
procedure TfrmKeyboard.WM_HotKeyHandler(var Message: TMessage);
var
  //idHotKey: integer; //идентификатор, но об этом - позже
  fuModifiers: word; //модификатор MOD_XX
  uVirtKey: word; //код виртуальной клавиши VK_XX
begin
  //idHotkey:= Message.wParam;
  fuModifiers:= LOWORD(Message.lParam);
  uVirtKey:= HIWORD(Message.lParam);
  if (fuModifiers = MOD_WIN) and (uVirtKey = EnableHotKeyCode) then begin
    actEnableExecute(Self);
    if isActivated then
      DoBalloon(bfInfo, Format(lngMsgActivated, [constProgramName]))
    else
      DoBalloon(bfInfo, Format(lngMsgDeactivated, [constProgramName]));
  end;
  inherited;
end;


// ===================== ПРИЛОЖЕНИЕ =======================

// параметры приложение: считать
procedure Settings_Load;
var FileOptions: TIniFile;
begin
  try with frmOptions, FileOptions do
    begin
      FileOptions   := TIniFile.Create (AppDataPath + SetsFileName);
      ControlKey    := ReadInteger ('Options', 'ControlKey', constControlKey);
      AddControlKey := ReadInteger ('Options', 'AddControlKey', constAdditionalKey);
//      CurrentLang   := ReadInteger ('Options', 'Language', constLangEN_US);
      CurrentLang   := ReadInteger ('Options', 'Language', GetUserDefaultLCID());
        CurrentLang := CheckLang(CurrentLang);
      isExtendedKey := ReadBool    ('Options', 'ExtendedKey', constExtendedKey);
      EnableHotKeyCode   := ReadInteger ('Options', 'EnableHotKey', constEnableHotKey);
      //BlockKbdHotKeyCode := ReadInteger ('Options', 'BlockKbdHotKey', constBlockKbdHotKey);
      StartCounter  := ReadInteger ('Options', 'Starts', constStartCounter);
      isActivated   := ReadBool    ('Options', 'Activated', constActivated);
      frmKeyboard.actLearnMode.Checked := ReadBool ('Options', 'LearnMode', constUseLearnMode);
      MinAlphaValue := ReadInteger ('Options', 'MinAlphaValue', MIN_ALPHA_VALUE);
      KbdAlphaBlendValue := ReadInteger ('Options', 'KbdAlphaBlendValue', 255);
        if KbdAlphaBlendValue < MinAlphaValue then KbdAlphaBlendValue := MinAlphaValue;

      KbdTop  := ReadInteger ('Options', 'KbdTop',  Screen.Height - frmKeyboard.imgKbd.Height - 40);
      KbdLeft := ReadInteger ('Options', 'KbdLeft', Screen.Width  - frmKeyboard.imgKbd.Width  - 10);

      isKbdShadow           := ReadBool   ('Options', 'KbdDropShadow',  constKbdDropShadow);
      CurrentPreset         := ReadString ('Options', 'CurrentPreset',  KbdDefault);
      isClearType           := ReadBool   ('Options', 'ClearType',      constIsUseClearType);
      isShowPresetInfo      := ReadBool   ('Options', 'ShowPresetInfo', true);
      DblClickMode          := ReadBool   ('Options', 'DblClickMode',   true);
      isKbdDelay            := ReadBool   ('Options', 'isKbdDelay',     true);
      // Грузим фонты...
      LoadFontFromIni(fntLeftSide,  FileOptions, 'fntLeftSide',  constLeftFontName, constLeftFontSize, constLeftFontColor, constLeftFontBold, constLeftFontItalic);
      LoadFontFromIni(fntRightSide, FileOptions, 'fntRightSide', constRightFontName, constRightFontSize, constRightFontColor, constRightFontBold, constRightFontItalic);
      LoadFontFromIni(fntDiacrit,   FileOptions, 'fntDiacrit',   constDiacritFontName, constDiacritFontSize, constDiacritFontColor, constDiacritFontBold, constDiacritFontItalic);
      // Грузим фонты.
      Free;
    end;
    except
    end;
  if ControlKey = 0 then ControlKey := constControlKey;
  if AddControlKey = 0 then AddControlKey := constAdditionalKey;
end;

// параметры приложение: записать
procedure Settings_Save;
var FileOptions: TIniFile;
    i: integer;
begin
  try with frmOptions, FileOptions do
    begin
      FileOptions   := TIniFile.Create (AppDataPath + SetsFileName);
      WriteBool     ('Options', 'Activated', isActivated);
      WriteInteger  ('Options', 'ControlKey', ControlKey);
      WriteInteger  ('Options', 'AddControlKey', AddControlKey);
      WriteInteger  ('Options', 'Language', CurrentLang);
      WriteBool     ('Options', 'ExtendedKey', isExtendedKey);
      WriteBool     ('Options', 'LearnMode', frmKeyboard.actLearnMode.Checked);
      WriteInteger  ('Options', 'EnableHotKey', EnableHotKeyCode);
      //WriteInteger  ('Options', 'BlockKbdHotKey', BlockKbdHotKeyCode);
      WriteInteger  ('Options', 'Starts', StartCounter);
      WriteInteger  ('Options', 'MinAlphaValue', MinAlphaValue);
      WriteInteger  ('Options', 'KbdAlphaBlendValue', frmKeyboard.AlphaBlendValue);
      WriteInteger  ('Options', 'KbdTop', frmKeyboard.Top);
      WriteInteger  ('Options', 'KbdLeft', frmKeyboard.Left);
      chboxKbdDropShadow.Checked := isKbdShadow;
      WriteBool     ('Options', 'KbdDropShadow', chboxKbdDropShadow.Checked);
      WriteString   ('Options', 'CurrentPreset', CurrentPreset);
      WriteBool     ('Options', 'ClearType', isClearType);
      WriteBool     ('Options', 'ShowPresetInfo', isShowPresetInfo);
      WriteBool     ('Options', 'DblClickMode', DblClickMode);
      WriteBool     ('Options', 'isKbdDelay', isKbdDelay);
      // Пишем фонты...
      SaveFontToIni (fntLeftSide,  FileOptions, 'fntLeftSide');
      SaveFontToIni (fntRightSide, FileOptions, 'fntRightSide');
      SaveFontToIni (fntDiacrit,   FileOptions, 'fntDiacrit');
        // пишем дефолтные фонты для спецсимволов, только при первом запуске
        if StartCounter = 0 then
          for i := 0 to frmKeyboard.slSpecialFonts.Count - 1 do
            FileOptions.WriteString('Fonts', frmKeyboard.slSpecialFonts.Strings.Names[i], frmKeyboard.slSpecialFonts.Strings.Values[frmKeyboard.slSpecialFonts.Strings.Names[i]]);
      // Пишем фонты.
      Free;
    end;
    except
    end;
end;

// считываем файлы пресетов и делаем меню
procedure TfrmKeyboard.MakePresetMenu;
var InsertPresetMenu, TrayPresetMenu :array [0..99] of TMenuItem;
//    aa: array [0..99] of byte; // для удаления пунктов меню
    slPresetFiles : TStringList;
    i,j,k : integer;
    s: string;
begin
  // REMOVE OLD ITEMS FIRST
  // Подсчитаем кол-во пунктов меню для удаления
  k := 0;
  for i := 0 to pmChoosePreset.Count - 1 do
    if pmChoosePreset[i].Tag = 666 then
      inc(k);
  // Удаляем все пункты, помеченные 666
  for i := 1 to k do
    for j := 0 to pmChoosePreset.Count - 1 do
      if pmChoosePreset[j].Tag = 666 then
      begin
        pmChoosePreset.Delete(j);
        pmTrayPresets.Delete(j);
        break;
      end;
  // Добавляем в меню пресеты
  k := 0;
  slPresetFiles := TStringList.Create;
  FindFiles(AppPresetPath, '*' + PresetFilesExt, slPresetFiles);
  for i := 0 to slPresetFiles.Count - 1 do
  begin
    s := ReplaceStr (slPresetFiles.Strings[i], PresetFilesExt, '');
    s := ReplaceStr (s, '&','&&');
    if (s <> KbdFileNameUser) and (s <> KbdDefault)
    then begin
      InsertPresetMenu[k] := TMenuItem.Create (pmChoosePreset);
      InsertPresetMenu[k].Caption := s;
      InsertPresetMenu[k].Tag := 666;
      InsertPresetMenu[k].GroupIndex := 1;
      InsertPresetMenu[k].OnClick := PresetClick;
      InsertPresetMenu[k].RadioItem := true;
      InsertPresetMenu[k].Checked := GetNormalStringFromCaption(s) = CurrentPreset;
      InsertPresetMenu[k].AutoCheck := true;

      TrayPresetMenu[k] := TMenuItem.Create (pmChoosePreset);
      TrayPresetMenu[k].Caption := s;
      TrayPresetMenu[k].Tag := 666;
      TrayPresetMenu[k].GroupIndex := 1;
      TrayPresetMenu[k].OnClick := PresetClick;
      TrayPresetMenu[k].RadioItem := true;
      TrayPresetMenu[k].Checked := GetNormalStringFromCaption(s) = CurrentPreset;
      TrayPresetMenu[k].AutoCheck := true;

      inc(k);
    end;
  end;
  for i := 0 to k - 1 do
  begin
    pmChoosePreset.Insert(i+3{после разделителя}, InsertPresetMenu[i]);
    pmTrayPresets.Insert(i+3{после разделителя},  TrayPresetMenu[i]);
  end;
  slPresetFiles.Free;

  actLoadPresetDefault.Checked := CurrentPreset = KbdDefault;
  actLoadPresetUser.Checked := CurrentPreset = KbdFileNameUser;

  actDeleteCurPreset.Enabled := (CurrentPreset <> KbdDefault) and (CurrentPreset <> KbdFileNameUser);
  actLoadPresetUser.Enabled  := FileExists(AppPresetPath + KbdFileNameUser + PresetFilesExt);

end;

// загузить другой пресет
procedure TfrmKeyboard.PresetClick(Sender: TObject);
begin
  LoadChars (GetNormalStringFromCaption((Sender as TMenuItem).Caption));
//  ShowCurrentPreset;
end;

// установить юзерский пресет
procedure TfrmKeyboard.SetUserPreset;
begin
  CurrentPreset := KbdFileNameUser;
  pmPresetUserDefined.Checked := true;
end;

procedure TfrmKeyboard.tmrDelayTimer(Sender: TObject);
begin
  isKbdDelayGone   := true;
  tmrDelay.Enabled := false;
end;

procedure TfrmKeyboard.tmrKbdFadeInOutTimer(Sender: TObject);
var delta: integer;
begin
//  DoBalloon(bfInfo, BoolToStr(isKbdShown, true));
  delta := round(KbdAlphaBlendValue/kbdAlphaSteps);
  if isKbdShown then begin
    if KbdAlphaBlendValue > (AlphaBlendValue + delta) then begin
      AlphaBlendValue := AlphaBlendValue + delta;
    end
    else begin
      tmrKbdFadeInOut.Enabled := false;
      AlphaBlendValue := KbdAlphaBlendValue;
    end
  end
  else begin
    if (AlphaBlendValue - delta) >= 0 then
      AlphaBlendValue := AlphaBlendValue - delta
    else begin
      AlphaBlendValue := 0;
      ShowWindow(frmKeyboard.Handle, SW_HIDE);
      UpdateWindow(frmKeyboard.Handle);
      AlphaBlendValue := KbdAlphaBlendValue;
      tmrKbdFadeInOut.Enabled := false;
//      DoBalloon(bfInfo, 'Hidden');
    end;
  end;
end;

// перехватчик сообщений по-умолчанию
procedure TfrmKeyboard.DefaultHandler(var Message);
begin
  with TMessage(Message) do
  begin
    if Msg = CM_TIE_ONEINST then
      if WPARAM = 666  // если сообщение CM_TIE_ONEINST и WPARAM=666, то прибить все экземпляры
        then actExitExecute(Self)
        else DoBalloon(bfInfo, lngMsgOneInst); // если сообщение CM_ONEINST, то показать, что уже запущено
//    if Msg = CM_TIE_INFO then
//      case WPARAM of
//        1: actFirstStartWizard.Enabled := true;
//        2: actFirstStartWizard.Enabled := false;
//      end;
  end;
  inherited DefaultHandler(TMessage(Message));
end;

// показывает балон-подсказку в трее
procedure DoBalloon(Flag: TBalloonFlags; Text: widestring);
begin
  with frmKeyboard.TrayIcon do
  begin
    BalloonFlags := bfNone;
    BalloonTitle := '';
    BalloonHint  := '';
    ShowBalloonHint;
    BalloonFlags := Flag;
    BalloonTitle := constProgramName;
    BalloonHint  := Text;
    //BalloonTimeout:= 1000;
    ShowBalloonHint;
  end;
end;
procedure DoBalon(Text: widestring); // короткий вариант DoBalloon-a
begin
  DoBalloon(bfInfo, Text);
end;

// устанавливает иконки в трее
procedure TfrmKeyboard.DoIcon (IconNumber: integer);
begin
  TrayIcon.IconIndex := IconNumber;
end;


// ===================== ЭКРАННАЯ КЛАВИАТУРА =======================

// экр.клава: показать-спрятать клаву
procedure ShowKeyboard (DoShowKbd: boolean);
begin
//  DoBalloon(bfInfo, BoolToStr(DoShowKbd, true));
  isKbdShown := DoShowKbd;
  with frmKeyboard do
  begin
    if DoShowKbd then begin
      CreateCaptionsScrKbd;
      AlphaBlendValue := 0;
      ShowWindow(frmKeyboard.Handle, SW_SHOWNOACTIVATE);
      UpdateWindow(frmKeyboard.Handle);
    end
    else begin
      rsbExit.Enabled := false;
      actKbdClose.Enabled := rsbExit.Enabled;
    end;
    tmrKbdFadeInOut.Interval := kbdFadingTick;
    tmrKbdFadeInOut.Enabled := true;
    actShowKbd.Checked := DoShowKbd;
  end;
//  DoBalloon(bfInfo, IntToStr(frmKeyboard.Top));
end;

// экр.клава: задать символы на клавише: вспомогательная функция
procedure SetKeyCaptions (Key: TRealKey; TL, BL, TR, BR, CC: String); // используй ~~ чтобы оставить старый капшн
begin

  if TL = '&' then TL := '&&';
  if BL = '&' then BL := '&&';
  if TR = '&' then TR := '&&';
  if BR = '&' then BR := '&&';
  if CC = '&' then CC := '&&';

  if TL <> '~~' then Key.CaptionTopLeft     := TL;
  if BL <> '~~' then Key.CaptionBottomLeft  := BL;
  if TR <> '~~' then Key.CaptionTopRight    := TR;
  if BR <> '~~' then Key.CaptionBottomRight := BR;
  if CC <> '~~' then Key.Caption := CC;

  Key.Refresh;
end;

// экр.клава: считать раскладку из файла
procedure LoadChars(fn: string);
var

  PresetDescr: string;

  procedure LoadPresetFromStringList (slRegular, slShift: TStringList);
  var
    i: integer;
    s1,s2: string;
  begin
    for i := 1 to constMaxLogicKeys do
    begin
      s1 := slRegular.Values[IntToStr(i)]; //ReadString('Regular Keys', IntToStr(i), '');
      s2 := slShift.Values[IntToStr(i)]; //ReadString('Shift Keys',   IntToStr(i), '');
      if s1 <> ''
        then CharTable[true,i] := char (GetIntFromStr ('$' + s1))
        else CharTable[true,i] := #0;
      if s2 <> ''
        then CharTable[false,i] := Char (GetIntFromStr ('$' + s2))
        else CharTable[false,i] := #0;
    end
  end;
  procedure LoadPresetFromFile (fln: string);
  var
    KbdIniFile: TIniFile;
    s1,s2: string;
    i: integer;
  begin
    try with KbdIniFile do
    begin
      KbdIniFile   := TIniFile.Create (AppPresetPath + fln + PresetFilesExt);

      PresetDescr  := ReadString('Info', IntToStr(CurrentLang), '');
      if PresetDescr = '' then PresetDescr := ReadString('Info', IntToStr(constLangEN_US), '');

      for i := 1 to constMaxLogicKeys do
      begin
        s1 := ReadString('Regular Keys', IntToStr(i), '');
        s2 := ReadString('Shift Keys',   IntToStr(i), '');

        if s1 <> ''
          then CharTable[true,i] := char (GetIntFromStr ('$' + s1))
          else CharTable[true,i] := #0;

        if s2 <> ''
          then CharTable[false,i] := Char (GetIntFromStr ('$' + s2))
          else CharTable[false,i] := #0;

      end;
      Free;
    end;
    except
    end;
  end;

begin
  PresetDescr := '';
  // а вдруг файл с пресетом по дороге прибили, значит грузим дефолтный
  if (fn <> KbdDefault) and not FileExists(AppPresetPath + fn + PresetFilesExt)
    then fn := KbdDefault;
  with frmKeyboard do
  begin
    if fn = KbdDefault
      then // Загружаем пресет по-умолчанию
        case CurrentLang of
          constLangEN_US: LoadPresetFromStringList(slRegularKeysEN.Strings, slShiftKeysEN.Strings);
          constLangRU_RU: LoadPresetFromStringList(slRegularKeysRU.Strings, slShiftKeysRU.Strings);
        else
          if KbdDefPresetFN <> ''
            then LoadPresetFromFile(KbdDefPresetFN)
            else LoadPresetFromStringList(slRegularKeysEN.Strings, slShiftKeysEN.Strings);
        end
      else LoadPresetFromFile(fn); // Загружаем пресет из файла
    CreateCaptionsScrKbd;
    CurrentPreset := fn;
  end;
  if (PresetDescr <> '') and not (isStartUp) and isShowPresetInfo then DoBalloon(bfInfo, PresetDescr);

  // выводим название пресета в капшене формы
//  frmKeyboard.lblKbdCaptionPreset.Caption := GetHumanizedPresetName(CurrentPreset);
  frmKeyboard.lblKbdCaptionPreset.Font.Color := constKeyFontColorNormal;
  frmKeyboard.lblKbdCaptionPreset.Caption := Format(lngFrmKbdCaption, [GetHumanizedPresetName(CurrentPreset)]);
end;

// экр.клава: записать раскладку в файл
procedure SaveCharsToIni(fn: string);
var KbdIniFile: TIniFile;
    i: integer;
begin
  try with KbdIniFile do
  begin
    KbdIniFile   := TIniFile.Create (AppPresetPath + fn + PresetFilesExt);
    for i := 1 to constMaxLogicKeys do
    begin

      // !!! далее используется двубайтовый тип WORD для получения юникода символа. Будет ли он двубайтовым на x64?

      if CharTable[true,i] <> #0
        then WriteString ('Regular Keys', IntToStr(i), IntToHex (Word(CharTable[true,i]), 4))
        else DeleteKey   ('Regular Keys', IntToStr(i));

      if CharTable[false,i] <> #0
        then WriteString ('Shift Keys', IntToStr(i), IntToHex (Word(CharTable[false,i]), 4))
        else DeleteKey   ('Shift Keys', IntToStr(i));

    end;
    Free;
  end;
  except
  end;
end;

// экр.клава: грузим индивидуальные шрифты
procedure TfrmKeyboard.LoadCharFont(ResultFont,DefFont: TFont; CharCode: char);
var FileOptions: TIniFile;
    IniKey: string;
begin
  try begin
    FileOptions := TIniFile.Create (AppDataPath + SetsFileName);
    IniKey := IntToHex (Word(CharCode), 4);
    if FileOptions.ValueExists('Fonts', IniKey+'.Name')
      then LoadFontFromIni(ResultFont,FileOptions,IniKey,DefFont.Name,DefFont.Size,DefFont.Color,(fsBold in DefFont.Style), (fsItalic in DefFont.Style));
    FileOptions.Free;
  end;
  except
  end;
  DoClearType(ResultFont,isClearType);
end;

// экр.клава: делаем подписи на кнопках
procedure TfrmKeyboard.CreateCaptionsScrKbd;
var   i: integer;
      hKeybLayout:  HKL;
      hForeWindow:  HWND;
      dwForeThread: DWORD;
begin
  hForeWindow  := GetForegroundWindow;
  dwForeThread := GetWindowThreadProcessId(hForeWindow, nil);
  hKeybLayout  := GetKeyboardLayout (dwForeThread);
  // устанавливаем соотв. шрифты
  DoClearTypeForAll (isClearType);
  for i := 0 to constMaxRealKeys - 1 do
  begin
//    ScrKeys[i].Font.Assign(fntLeftSide);
    ScrKeys[i].FontTopLeft.Assign(fntLeftSide);
    ScrKeys[i].FontBottomLeft.Assign(fntLeftSide);
      if (Word(CharTable[false,ScrKeys[i].Tag]) - constPerdPrefix) in Perdyshki
        then ScrKeys[i].FontTopRight.Assign(fntDiacrit)
        else ScrKeys[i].FontTopRight.Assign(fntRightSide);
      if (Word(CharTable[true,ScrKeys[i].Tag]) - constPerdPrefix) in Perdyshki
        then ScrKeys[i].FontBottomRight.Assign(fntDiacrit)
        else ScrKeys[i].FontBottomRight.Assign(fntRightSide);
    ScrKeys[i].Margins.Top    := constKeyMrgTop;
    ScrKeys[i].Margins.Left   := constKeyMrgLeft;
    ScrKeys[i].Margins.Bottom := constKeyMrgBottom;
    ScrKeys[i].Margins.Right  := constKeyMrgRight;
  end;

  keyNr   := 0;

  // Escape Key
  {
  ScrKeys[keyNr].FontTopLeft.Color := constKeyFontColorDisabled;
  ScrKeys[keyNr].CaptionTopLeft    := lngKeyEsc;
  inc (keyNr);

  // Functional Keys: F1..F12
  for i := 0 to 11 do
  begin
    ScrKeys[keyNr].CaptionTopLeft := lngKeyFuncPrefix + IntToStr(i + 1);
    if i = 0 then
    begin
      ScrKeys[keyNr].FontBottomRight.Size  := constKeyFontSizeSmallest;
      ScrKeys[keyNr].FontTopLeft.Color     := constKeyFontColorDisabled;
//      ScrKeys[keyNr].FontBottomRight.Color := constKeyFontColorDisabled;
//      ScrKeys[keyNr].CaptionBottomRight    := constKeyFuncHelp;
      ScrKeys[keyNr].FontBottomRight.Color := constKeyFontColorDisabled;
      ScrKeys[keyNr].CaptionBottomRight    := lngKeyFuncHelp;
    end;
    inc (keyNr);
  end;}

  // Number Keys: ~..=
  for i := 0 to 12 do
  begin
//    ScrKeys[keyNr].CaptionBottomLeft := WideChar(MapVirtualKeyEx(MapVirtualKeyEx (ScrKeys[keyNr].Tag, 1, hKeybLayout), 2, hKeybLayout));
    ScrKeys[keyNr].CaptionTopLeft := WideChar(MapVirtualKeyEx(MapVirtualKeyEx (ScrKeys[keyNr].Tag, 1, hKeybLayout), 2, hKeybLayout));
    inc (keyNr);
  end;

  // Backspace key
  ScrKeys[keyNr].FontTopLeft.Color := constKeyFontColorDisabled;
  ScrKeys[keyNr].CaptionTopLeft    := lngKeyBckspcArrow;
  inc (keyNr);

  // Tab key
  ScrKeys[keyNr].FontTopLeft.Color := constKeyFontColorDisabled;
  ScrKeys[keyNr].CaptionTopLeft    := lngKeyTab;
  inc (keyNr);

  // 1-st Alphabetic Row: Q..\
  for i := 0 to 12 do
  begin
    ScrKeys[keyNr].CaptionTopLeft := WideChar(MapVirtualKeyEx(MapVirtualKeyEx (ScrKeys[keyNr].Tag, 1, hKeybLayout), 2, hKeybLayout));
    inc (keyNr);
  end;

  // Caps key
  ScrKeys[keyNr].FontTopLeft.Color := constKeyFontColorDisabled;
  ScrKeys[keyNr].CaptionTopLeft    := lngKeyCapsArrow;
  inc (keyNr);

  // 2-nd Alphabetic Row: A..\
  for i := 0 to 10 do
  begin
    ScrKeys[keyNr].CaptionTopLeft := WideChar(MapVirtualKeyEx(MapVirtualKeyEx (ScrKeys[keyNr].Tag, 1, hKeybLayout), 2, hKeybLayout));
    inc (keyNr);
  end;

  // Enter key
  ScrKeys[keyNr].CaptionTopLeft       := lngKeyEnter;
//  ScrKeys[keyNr].FontBottomRight.Size := constKeyFontSizeSmallest;
  ScrKeys[keyNr].CaptionBottomRight   := lngKeyAccent;
  ScrKeys[keyNr].FontBottomRight.Assign(fntDiacrit);
  ScrKeys[keyNr].FontBottomRight.Size := constKeyFontSizeSmallest;
  inc (keyNr);

  // Left Shift key
  ScrKeys[keyNr].FontTopLeft.Color := constKeyFontColorDisabled;
  ScrKeys[keyNr].CaptionTopLeft    := lngKeyShiftArrow;
  inc (keyNr);

  // 3-rd Alphabetic Row: Z../
  for i := 0 to 9 do
  begin
    ScrKeys[keyNr].CaptionTopLeft := WideChar(MapVirtualKeyEx(MapVirtualKeyEx (ScrKeys[keyNr].Tag, 1, hKeybLayout), 2, hKeybLayout));
    inc (keyNr);
  end;

  // Right Shift key
  ScrKeys[keyNr].FontTopLeft.Color := constKeyFontColorDisabled;
  ScrKeys[keyNr].CaptionTopLeft    := lngKeyShiftArrow;
  inc (keyNr);

  // Left Ctrl
  ScrKeys[keyNr].FontTopLeft.Color := constKeyFontColorDisabled;
  ScrKeys[keyNr].CaptionTopLeft    := lngKeyCtrl;
  inc (keyNr);

  // Left Win
  ScrKeys[keyNr].FontTopLeft.Color := constKeyFontColorDisabled;
  ScrKeys[keyNr].CaptionTopLeft    := lngKeyWin;
  inc (keyNr);

  // Left Alt
  ScrKeys[keyNr].FontTopLeft.Color := constKeyFontColorDisabled;
  ScrKeys[keyNr].CaptionTopLeft    := lngKeyAlt;
  inc (keyNr);

  // Space
//  ScrKeys[keyNr].FontBottomRight.Size := constKeyFontSizeSmallest;
  ScrKeys[keyNr].Font.Assign(fntLeftSide);
  ScrKeys[keyNr].Caption           := lngKeyNonbrSpace;
  inc (keyNr);

  // Right Alt
  ScrKeys[keyNr].FontTopLeft.Color := constKeyFontColorDisabled;
  ScrKeys[keyNr].CaptionTopLeft    := lngKeyAltGr;
//  ScrKeys[keyNr].FontTopLeft.Style := [fsBold];
  inc (keyNr);

  (*// Right Popup Menu
//  ScrKeys[keyNr].FontTopLeft.Color := constKeyFontColorDisabled;
  ScrKeys[keyNr].CaptionTopLeft    := lngKeyMenu;
  inc (keyNr);*)

  // Right Win
  ScrKeys[keyNr].FontTopLeft.Color := constKeyFontColorDisabled;
  ScrKeys[keyNr].CaptionTopLeft    := lngKeyWin;
  inc (keyNr);

  // Right Ctrl
  ScrKeys[keyNr].FontTopLeft.Color := constKeyFontColorDisabled;
  ScrKeys[keyNr].CaptionTopLeft    := lngKeyCtrl;

  // Misc Text Stuff
//  if frmOptions.vleKeys.RowCount > 0 then
//    for i := 1 to frmOptions.vleKeys.RowCount - 1 do
//      frmOptions.vleKeys.Strings.Clear;

  for i := 0 to keyNr do
  begin
    if (ScrKeys[i].Tag <> 28 {enter}) and (ScrKeys[i].Tag <> 59 {F1}) then
    begin
      //ScrKeys[i].CaptionTopLeft := UpperCase(ScrKeys[i].CaptionTopLeft);
      SetKeyCaptions (ScrKeys[i], '~~', '~~', GetStrFromChr(CharTable[false,ScrKeys[i].Tag]), GetStrFromChr(CharTable[true, ScrKeys[i].Tag]), '~~');
    end;

    // Установим индивидуальные шрифты
    LoadCharFont(ScrKeys[i].FontTopRight,   fntRightSide,CharTable[false,ScrKeys[i].Tag]);
    LoadCharFont(ScrKeys[i].FontBottomRight,fntRightSide,CharTable[true,ScrKeys[i].Tag]);
//    if (Word(CharTable[false,ScrKeys[i].Tag]) - constPerdPrefix) in Perdyshki
//      then ScrKeys[i].FontTopRight.Assign(fntDiacrit);
//    if (Word(CharTable[true,ScrKeys[i].Tag]) - constPerdPrefix) in Perdyshki
//      then ScrKeys[i].FontBottomRight.Assign(fntDiacrit);

    // убрать после отладки
//    ScrKeys[i].Hint := IntToStr(ScrKeys[i].Tag);
//    ScrKeys[i].ShowHint := true;

    ScrKeys[i].Refresh;
  end;

end;

// экр.клава: рисуем клавиатуру
procedure TfrmKeyboard.CreateScrKbd;
const ButtonSize = 33;
      ButtonBigSize = 51;
      ButtonEnterSize = 59;
      ButtonLeftShiftSize = 77;
      ButtonRightShiftSize = 75;
      ButtonSpaceSize = 181;
      BorderSize    = 15;
      BorderTopSize = 21;
      isFlat = false;
var   i, keyLeft, keyTop: integer;
begin

  // из-за этих кнопок глючит сохранение позиции формы клавы
  // при выходе из приложения, приходится сохранять настройки
  // при уничтожении не главной формы

  for i := 0 to constMaxRealKeys - 1 do
  begin
    ScrKeys[i]        := TRealKey.Create(frmKeyboard);
    ScrKeys[i].Parent := frmKeyboard;
    ScrKeys[i].Style       := bsCool;
    ScrKeys[i].Flat        := isFlat;
    ScrKeys[i].ParentFont  := true;
    ScrKeys[i].Transparent := false;
    ScrKeys[i].Height      := ButtonSize;
    ScrKeys[i].OnMouseDown := KbdKeyDown;
//    ScrKeys[i].OnMouseEnter:= KeyClick;
//    ScrKeys[i].OnMouseDown := FormMouseDown;
//    ScrKeys[i].OnMouseMove := FormMouseMove;
//    ScrKeys[i].OnMouseUp   := FormMouseUp;
//    ScrKeys[i].OnClick  := actShowKeySetsExecute;
    ScrKeys[i].AlignWithMargins := false;
    ScrKeys[i].PopupMenu := pmKbd;
  end;

  keyNr   := 0;

  // Escape Key
  {keyTop  := BorderTopSize;
  keyLeft := BorderSize;
  ScrKeys[keyNr].Left  := keyLeft + 1;
  ScrKeys[keyNr].Top   := keyTop  + 1;
  ScrKeys[keyNr].Width := ButtonSize;
  ScrKeys[keyNr].Tag  := 1;
  ScrKeys[keyNr].Enabled  := false;
  ScrKeys[keyNr].BmpNormal.LoadFromResourceName   (Hinstance,'KeyNormal');
  ScrKeys[keyNr].BmpActive.LoadFromResourceName   (Hinstance,'KeyActive');
  ScrKeys[keyNr].BmpDown.LoadFromResourceName     (Hinstance,'KeyDown');
  ScrKeys[keyNr].BmpDisable.LoadFromResourceName  (Hinstance,'KeyDisable');
  inc (keyNr);

  // Functional Keys: F1..F12
  keyLeft := ButtonSize + BorderSize + 2;
  for i := 0 to 11 do
  begin
    ScrKeys[keyNr].Width  := ButtonSize;
    if i in [4, 8]
      then keyLeft := keyLeft + 3 + ButtonSize + BorderSize div 2
      else keyLeft := keyLeft + ButtonSize + 1;
    ScrKeys[keyNr].Left := keyLeft;
    ScrKeys[keyNr].Top  := keyTop + 1;
    ScrKeys[keyNr].Tag := 59 + i;
    if i >= 10 then ScrKeys[keyNr].Tag := 77 + i;
    ScrKeys[keyNr].BmpNormal.LoadFromResourceName   (Hinstance,'KeyNormal');
    ScrKeys[keyNr].BmpActive.LoadFromResourceName   (Hinstance,'KeyActive');
    ScrKeys[keyNr].BmpDown.LoadFromResourceName     (Hinstance,'KeyDown');
    if i = 0 then
    begin
      ScrKeys[keyNr].BmpDisable.LoadFromResourceName     (Hinstance,'KeyDisable');
      ScrKeys[keyNr].Enabled := false;
    end;
    inc (keyNr);
  end; }


  // Number Keys: ~..=
  keyTop  := BorderSize + 10;//keyTop + 4 + ButtonSize + BorderSize div 2{round(ButtonSize/3)};
  keyLeft := BorderSize + 1;
  for i := 0 to 12 do
  begin
    ScrKeys[keyNr].Width  := ButtonSize;
    ScrKeys[keyNr].Left   := keyLeft + i;
    keyLeft := ButtonSize + keyLeft;
    ScrKeys[keyNr].Top  := keyTop;
    ScrKeys[keyNr].Tag := 1 + i;
    if i = 0 then ScrKeys[keyNr].Tag := 41;
    ScrKeys[keyNr].BmpNormal.LoadFromResourceName   (Hinstance,'KeyNormal');
    ScrKeys[keyNr].BmpActive.LoadFromResourceName   (Hinstance,'KeyActive');
    ScrKeys[keyNr].BmpDown.LoadFromResourceName     (Hinstance,'KeyDown');
    inc (keyNr);
  end;


  // Backspace key
  ScrKeys[keyNr].Width  := ButtonBigSize;
  ScrKeys[keyNr].Left := ScrKeys[keyNr-1].Left + ButtonSize + 1;
  ScrKeys[keyNr].Top  := keyTop;
  ScrKeys[keyNr].Tag  := 14;
  ScrKeys[keyNr].Enabled := false;
  ScrKeys[keyNr].BmpNormal.LoadFromResourceName   (Hinstance,'KeyBigNormal');
  ScrKeys[keyNr].BmpActive.LoadFromResourceName   (Hinstance,'KeyBigActive');
  ScrKeys[keyNr].BmpDown.LoadFromResourceName     (Hinstance,'KeyBigDown');
  ScrKeys[keyNr].BmpDisable.LoadFromResourceName  (Hinstance,'KeyBigDisable');
  inc (keyNr);


  // Tab key
  keyTop  := keyTop + ButtonSize + 1;
  keyLeft := BorderSize + 1;
  ScrKeys[keyNr].Width  := ButtonBigSize;
  ScrKeys[keyNr].Left := keyLeft;
  ScrKeys[keyNr].Top  := keyTop;
  ScrKeys[keyNr].Tag  := 15;
  ScrKeys[keyNr].Enabled := false;
  ScrKeys[keyNr].BmpNormal.LoadFromResourceName   (Hinstance,'KeyBigNormal');
  ScrKeys[keyNr].BmpActive.LoadFromResourceName   (Hinstance,'KeyBigActive');
  ScrKeys[keyNr].BmpDown.LoadFromResourceName     (Hinstance,'KeyBigDown');
  ScrKeys[keyNr].BmpDisable.LoadFromResourceName  (Hinstance,'KeyBigDisable');
  inc (keyNr);

  // 1-st Alphabetic Row: Q..\
  keyLeft := ScrKeys[keyNr-1].Left + ButtonBigSize + 1;
  for i := 0 to 12 do
  begin
    ScrKeys[keyNr].Width  := ButtonSize;
    ScrKeys[keyNr].Left   := keyLeft;
    keyLeft := ButtonSize + keyLeft + 1;
    ScrKeys[keyNr].Top  := keyTop;
    ScrKeys[keyNr].Tag := 16 + i;
    if i = 12 then ScrKeys[keyNr].Tag := 43;
    ScrKeys[keyNr].BmpNormal.LoadFromResourceName   (Hinstance,'KeyNormal');
    ScrKeys[keyNr].BmpActive.LoadFromResourceName   (Hinstance,'KeyActive');
    ScrKeys[keyNr].BmpDown.LoadFromResourceName     (Hinstance,'KeyDown');
    inc (keyNr);
  end;

  // Caps key
  keyTop  := keyTop + ButtonSize + 1;
  keyLeft := BorderSize + 1;
  ScrKeys[keyNr].Width  := ButtonEnterSize;
  ScrKeys[keyNr].Left := keyLeft;
  ScrKeys[keyNr].Top  := keyTop;
  ScrKeys[keyNr].Tag  := 58;
  ScrKeys[keyNr].Enabled := false;
  ScrKeys[keyNr].BmpNormal.LoadFromResourceName   (Hinstance,'KeyEnterNormal');
  ScrKeys[keyNr].BmpActive.LoadFromResourceName   (Hinstance,'KeyEnterActive');
  ScrKeys[keyNr].BmpDown.LoadFromResourceName     (Hinstance,'KeyEnterDown');
  ScrKeys[keyNr].BmpDisable.LoadFromResourceName  (Hinstance,'KeyEnterDisable');
  inc (keyNr);

  // 2-nd Alphabetic Row: A..\
  keyLeft := ScrKeys[keyNr-1].Left + ButtonEnterSize + 1;
  for i := 0 to 10 do
  begin
    ScrKeys[keyNr].Width  := ButtonSize;
    ScrKeys[keyNr].Left   := keyLeft;
    keyLeft := ButtonSize + keyLeft + 1;
    ScrKeys[keyNr].Top := keyTop;
    ScrKeys[keyNr].Tag := 30 + i;
    ScrKeys[keyNr].BmpNormal.LoadFromResourceName   (Hinstance,'KeyNormal');
    ScrKeys[keyNr].BmpActive.LoadFromResourceName   (Hinstance,'KeyActive');
    ScrKeys[keyNr].BmpDown.LoadFromResourceName     (Hinstance,'KeyDown');
    inc (keyNr);
  end;

 // Enter key
  ScrKeys[keyNr].Width  := ButtonEnterSize;
  ScrKeys[keyNr].Left   := keyLeft;
  ScrKeys[keyNr].Top    := keyTop;
  ScrKeys[keyNr].Tag    := 28;
//  ScrKeys[keyNr].Enabled := false;
  ScrKeys[keyNr].BmpNormal.LoadFromResourceName   (Hinstance,'KeyEnterNormal');
  ScrKeys[keyNr].BmpActive.LoadFromResourceName   (Hinstance,'KeyEnterActive');
  ScrKeys[keyNr].BmpDown.LoadFromResourceName     (Hinstance,'KeyEnterDown');
//  ScrKeys[keyNr].BmpDisable.LoadFromResourceName  (Hinstance,'KeyEnterDisable');
  inc (keyNr);

   // Left Shift key
  keyTop  := keyTop + ButtonSize + 1;
  keyLeft := BorderSize + 1;
  ScrKeys[keyNr].Width  := ButtonLeftShiftSize;
  ScrKeys[keyNr].Left := keyLeft;
  ScrKeys[keyNr].Top  := keyTop;
  ScrKeys[keyNr].Tag  := 42;
  ScrKeys[keyNr].Enabled := false;
  ScrKeys[keyNr].BmpNormal.LoadFromResourceName   (Hinstance,'KeyLeftShiftNormal');
  ScrKeys[keyNr].BmpActive.LoadFromResourceName   (Hinstance,'KeyLeftShiftActive');
  ScrKeys[keyNr].BmpDown.LoadFromResourceName     (Hinstance,'KeyLeftShiftDown');
  ScrKeys[keyNr].BmpDisable.LoadFromResourceName  (Hinstance,'KeyLeftShiftDisable');
  //ScrKeys[keyNr].BmpTurnOn.LoadFromResourceName  (Hinstance,'KeyLeftShiftTurnOn');
  inc (keyNr);

  // 3-rd Alphabetic Row: Z../
  keyLeft := ScrKeys[keyNr-1].Left + ButtonLeftShiftSize + 1;
  for i := 0 to 9 do
  begin
    ScrKeys[keyNr].Width  := ButtonSize;
    ScrKeys[keyNr].Left   := keyLeft;
    keyLeft := ButtonSize + keyLeft + 1;
    ScrKeys[keyNr].Top  := keyTop;
    ScrKeys[keyNr].Tag  := 44 + i;
    ScrKeys[keyNr].BmpNormal.LoadFromResourceName   (Hinstance,'KeyNormal');
    ScrKeys[keyNr].BmpActive.LoadFromResourceName   (Hinstance,'KeyActive');
    ScrKeys[keyNr].BmpDown.LoadFromResourceName     (Hinstance,'KeyDown');
    inc (keyNr);
  end;

  // Right Shift key
  ScrKeys[keyNr].Width  := ButtonRightShiftSize;
  ScrKeys[keyNr].Left := keyLeft;
  ScrKeys[keyNr].Top  := keyTop;
  ScrKeys[keyNr].Tag  := 54;
  ScrKeys[keyNr].Enabled := false;
  ScrKeys[keyNr].BmpNormal.LoadFromResourceName   (Hinstance,'KeyRightShiftNormal');
  ScrKeys[keyNr].BmpActive.LoadFromResourceName   (Hinstance,'KeyRightShiftActive');
  ScrKeys[keyNr].BmpDown.LoadFromResourceName     (Hinstance,'KeyRightShiftDown');
  ScrKeys[keyNr].BmpDisable.LoadFromResourceName  (Hinstance,'KeyRightShiftDisable');
  //ScrKeys[keyNr].BmpTurnOn.LoadFromResourceName  (Hinstance,'KeyRightShiftTurnOn');
  inc (keyNr);

  // Left Ctrl
  keyTop  := keyTop + ButtonSize + 1;
  keyLeft := BorderSize + 1;
  ScrKeys[keyNr].Width  := ButtonBigSize;
  ScrKeys[keyNr].Left := keyLeft;
  ScrKeys[keyNr].Top  := keyTop;
  ScrKeys[keyNr].Tag  := 29;
  ScrKeys[keyNr].Enabled := false;
  ScrKeys[keyNr].BmpNormal.LoadFromResourceName   (Hinstance,'KeyBigNormal');
  ScrKeys[keyNr].BmpActive.LoadFromResourceName   (Hinstance,'KeyBigActive');
  ScrKeys[keyNr].BmpDown.LoadFromResourceName     (Hinstance,'KeyBigDown');
  ScrKeys[keyNr].BmpDisable.LoadFromResourceName  (Hinstance,'KeyBigDisable');
  //ScrKeys[keyNr].BmpTurnOn.LoadFromResourceName  (Hinstance,'KeyBigTurnOn');
  inc (keyNr);

  // Left Win
  ScrKeys[keyNr].Width  := ButtonBigSize;
  ScrKeys[keyNr].Left := ScrKeys[keyNr-1].Left + ScrKeys[keyNr-1].Width + 1;
  ScrKeys[keyNr].Top  := keyTop;
  ScrKeys[keyNr].Tag  := 91;
  ScrKeys[keyNr].Enabled := false;
  ScrKeys[keyNr].BmpNormal.LoadFromResourceName   (Hinstance,'KeyBigNormal');
  ScrKeys[keyNr].BmpActive.LoadFromResourceName   (Hinstance,'KeyBigActive');
  ScrKeys[keyNr].BmpDown.LoadFromResourceName     (Hinstance,'KeyBigDown');
  ScrKeys[keyNr].BmpDisable.LoadFromResourceName  (Hinstance,'KeyBigDisable');
  //ScrKeys[keyNr].BmpTurnOn.LoadFromResourceName  (Hinstance,'KeyBigTurnOn');
  inc (keyNr);

  // Left Alt
  ScrKeys[keyNr].Width  := ButtonBigSize;
  ScrKeys[keyNr].Left := ScrKeys[keyNr-1].Left + ScrKeys[keyNr-1].Width + 1;
  ScrKeys[keyNr].Top  := keyTop;
  ScrKeys[keyNr].Tag  := 56;
  ScrKeys[keyNr].Enabled := false;
  ScrKeys[keyNr].BmpNormal.LoadFromResourceName   (Hinstance,'KeyBigNormal');
  ScrKeys[keyNr].BmpActive.LoadFromResourceName   (Hinstance,'KeyBigActive');
  ScrKeys[keyNr].BmpDown.LoadFromResourceName     (Hinstance,'KeyBigDown');
  ScrKeys[keyNr].BmpDisable.LoadFromResourceName  (Hinstance,'KeyBigDisable');
  //ScrKeys[keyNr].BmpTurnOn.LoadFromResourceName  (Hinstance,'KeyBigTurnOn');
  inc (keyNr);

  // Space
  ScrKeys[keyNr].Width  := ButtonSpaceSize;
  ScrKeys[keyNr].Left := ScrKeys[keyNr-1].Left + ScrKeys[keyNr-1].Width + 1;
  ScrKeys[keyNr].Top  := keyTop;
  ScrKeys[keyNr].Tag  := 57;
  ScrKeys[keyNr].BmpNormal.LoadFromResourceName   (Hinstance,'KeySpaceNormal');
  ScrKeys[keyNr].BmpActive.LoadFromResourceName   (Hinstance,'KeySpaceActive');
  ScrKeys[keyNr].BmpDown.LoadFromResourceName     (Hinstance,'KeySpaceDown');
//  ScrKeys[keyNr].BmpDisable.LoadFromResourceName  (Hinstance,'KeySpaceDisable');
  inc (keyNr);

  // Right Alt Gr
  ScrKeys[keyNr].Width  := ButtonBigSize;
  ScrKeys[keyNr].Left := ScrKeys[keyNr-1].Left + ScrKeys[keyNr-1].Width + 1;
  ScrKeys[keyNr].Top  := keyTop;
  ScrKeys[keyNr].Tag  := 56;
  ScrKeys[keyNr].Enabled := false;
  ScrKeys[keyNr].BmpNormal.LoadFromResourceName   (Hinstance,'KeyBigNormal');
//  ScrKeys[keyNr].BmpNormal.LoadFromResourceName   (Hinstance,'KeyBigTurnOn');
  ScrKeys[keyNr].BmpActive.LoadFromResourceName   (Hinstance,'KeyBigActive');
  ScrKeys[keyNr].BmpDown.LoadFromResourceName     (Hinstance,'KeyBigDown');
  ScrKeys[keyNr].BmpDisable.LoadFromResourceName  (Hinstance,'KeyBigDisable');
  //ScrKeys[keyNr].BmpTurnOn.LoadFromResourceName  (Hinstance,'KeyBigTurnOn');
  inc (keyNr);

  (*// Right Popup Menu
  ScrKeys[keyNr].Width  := ButtonBigSize;
  ScrKeys[keyNr].Left := ScrKeys[keyNr-1].Left + ScrKeys[keyNr-1].Width + 1;
  ScrKeys[keyNr].Top  := keyTop;
  ScrKeys[keyNr].Tag  := 93;
//  ScrKeys[keyNr].Enabled := false;
  ScrKeys[keyNr].BmpNormal.LoadFromResourceName   (Hinstance,'KeyBigNormal');
  ScrKeys[keyNr].BmpActive.LoadFromResourceName   (Hinstance,'KeyBigActive');
  ScrKeys[keyNr].BmpDown.LoadFromResourceName     (Hinstance,'KeyBigDown');
//  ScrKeys[keyNr].BmpDisable.LoadFromResourceName  (Hinstance,'KeyBigDisable');
  //ScrKeys[keyNr].BmpTurnOn.LoadFromResourceName  (Hinstance,'KeyBigTurnOn');
  inc (keyNr);*)

  // Right Win
  ScrKeys[keyNr].Width  := ButtonBigSize;
  ScrKeys[keyNr].Left := ScrKeys[keyNr-1].Left + ScrKeys[keyNr-1].Width + 1;
  ScrKeys[keyNr].Top  := keyTop;
  ScrKeys[keyNr].Tag  := 91;
  ScrKeys[keyNr].Enabled := false;
  ScrKeys[keyNr].BmpNormal.LoadFromResourceName   (Hinstance,'KeyBigNormal');
  ScrKeys[keyNr].BmpActive.LoadFromResourceName   (Hinstance,'KeyBigActive');
  ScrKeys[keyNr].BmpDown.LoadFromResourceName     (Hinstance,'KeyBigDown');
  ScrKeys[keyNr].BmpDisable.LoadFromResourceName  (Hinstance,'KeyBigDisable');
  //ScrKeys[keyNr].BmpTurnOn.LoadFromResourceName  (Hinstance,'KeyBigTurnOn');
  inc (keyNr);

  // Right Ctrl
  ScrKeys[keyNr].Width  := ButtonBigSize;
  ScrKeys[keyNr].Left := ScrKeys[keyNr-1].Left + ScrKeys[keyNr-1].Width + 1;
  ScrKeys[keyNr].Top  := keyTop;
  ScrKeys[keyNr].Tag  := 29;
  ScrKeys[keyNr].Enabled := false;
  ScrKeys[keyNr].BmpNormal.LoadFromResourceName   (Hinstance,'KeyBigNormal');
  ScrKeys[keyNr].BmpActive.LoadFromResourceName   (Hinstance,'KeyBigActive');
  ScrKeys[keyNr].BmpDown.LoadFromResourceName     (Hinstance,'KeyBigDown');
  ScrKeys[keyNr].BmpDisable.LoadFromResourceName  (Hinstance,'KeyBigDisable');
  //ScrKeys[keyNr].BmpTurnOn.LoadFromResourceName  (Hinstance,'KeyBigTurnOn');

  CreateCaptionsScrKbd;
end;


// ===================== АКЦИИ: функционал, видимый из интерфейса =======================

// акция ЭБАУТ
procedure TfrmKeyboard.actAboutExecute(Sender: TObject);
begin
  frmAbout.Show;
end;

// акция ВЫХОД из проги
procedure TfrmKeyboard.actExitExecute(Sender: TObject);
begin
  //Application.Terminate;
  Close;
end;

// акция ЗАПУСК МАСТЕРА первого старта
procedure TfrmKeyboard.actFirstStartWizardExecute(Sender: TObject);
begin
//  if DLLWzrdHandle <> 0 then FreeLibrary(DLLWzrdHandle);
  {FirstStartWizard;} // <<< !!!
end;

// акция ХЭЛП!
procedure TfrmKeyboard.actHelpTopicsExecute(Sender: TObject);
begin
  if FileExists (AppLocalsPath + 'help.' + CurrentLangName + '.chm')
    then ShellExecute(Handle, 'Open', PChar(AppLocalsPath + 'help.' + CurrentLangName + '.chm'), nil, nil, SW_SHOWNORMAL)
    else  ShellExecute(Handle, 'Open', PChar(AppLocalsPath + 'help.' + constLangEN_US_str + '.chm'), nil, nil, SW_SHOWNORMAL);
end;

// акция АПДЭЙТ
procedure TfrmKeyboard.actGoCheckUpdExecute(Sender: TObject);
begin
  GoOnline (lngProgramUpdate);
end;

// акция ДОНЭЙТ
procedure TfrmKeyboard.actGoDonateExecute(Sender: TObject);
begin
  GoOnline (lngProgramDonate);
end;

// акция ХОУМПЭЙДЖ
procedure TfrmKeyboard.actGoHomePageExecute(Sender: TObject);
begin
  GoOnline (lngProgramSite);
end;

// акция БЛОК КЛАВЫ
procedure TfrmKeyboard.actBlockKbdExecute(Sender: TObject);
begin
  actBlockKbd.Checked := not actBlockKbd.Checked;
  if actBlockKbd.Checked then
    DoBalloon(bfInfo, Format(lngMsgKbdLocked,[' '{#10#13}]))
  else
    DoBalloon(bfInfo, lngMsgKbdUnLocked);

  if actBlockKbd.Checked
    then if isActivated
      then DoIcon(5)
      else DoIcon(4)
    else if isActivated
      then DoIcon(1)
      else DoIcon(0);

  if actBlockKbd.Checked then
    LockPowerKey
  else
    UnlockPowerKey;

end;

// акция СОЗДАЕМ НОВЫЙ ЧИСТЫЙ ПРЕСЕТ
procedure TfrmKeyboard.actCreateNewPresetExecute(Sender: TObject);
//var i: integer;
begin
//  case MessageBoxEx(Handle, PChar(constTxtCleanKeys),PChar(constProgramName),MB_OKCANCEL or MB_ICONQUESTION or MB_APPLMODAL, 0) of
//    IDOK: begin
//      for i := 1 to constMaxLogicKeys do
//      begin
//        CharTable[false,i] := #0;
//        CharTable[true,i]  := #0;
//      end;
//      CreateCaptionsScrKbd;
//      CurrentPreset := KbdFileNameUser;
//      SaveCharsToIni (KbdFileNameUser);
//    end;
//    IDCANCEL: exit;
//  end;
  isCreateOrSavePreset := true;
  frmNewPreset.Show;
end;

// акция АКТИВИРОВАТЬ/ДЕАКТИВИРОВАТЬ
procedure TfrmKeyboard.actEnableExecute(Sender: TObject);
begin
  isActivated := not isActivated;
  ActivateHookAndKeys (isActivated);
end;

// акция ПОКАЗАТЬ НАСТРОЙКИ
procedure TfrmKeyboard.actSettingsExecute(Sender: TObject);
begin
  frmOptions.Visible := not frmOptions.Visible;
end;

// акция ПОКАЗАТЬ КЛАВУ И СООБЩИТЬ, КАК ЕЁ НАСТРАИВАТЬ
procedure TfrmKeyboard.actSetKeysExecute(Sender: TObject);
begin
  lblKbdCaptionPreset.Caption := Format(lngMsgToSetKey, [lngShowKeySets]);
  lblKbdCaptionPreset.Font.Color := clMaroon;
  if not isKbdShown then begin
    rsbExit.Enabled := true;
    actKbdClose.Enabled := frmKeyboard.rsbExit.Enabled;
    ShowKeyboard (true);
    isAltF1Pressed := true;
  end;
end;

// акция ПОКАЗАТЬ НАСТРОЙКИ НА СТРАНИЦЕ КЛАВИАТУРЫ
procedure TfrmKeyboard.actSettingsKbdPageExecute(Sender: TObject);
begin
  with frmOptions do
  begin
    pcOptions.ActivePageIndex := 1;
//    CatBtns.SelectedItem := CatBtns.Categories[0].Items[1];
//    ntbSettings.PageIndex := CatBtns.SelectedItem.Index;
    Show;
  end;
end;

// акция Вкл/Выкл АВТО ПОКАЗАТЬ ХИНТ
procedure TfrmKeyboard.actKbdCloseExecute(Sender: TObject);
begin
  {if isAltF1Pressed then} actShowKbdExecute(self);
end;

// акция ПОКАЗАТЬ ФОРМУ НАСТРОЙКИ КЛАВИШИ
procedure TfrmKeyboard.actShowKeySetsExecute(Sender: TObject);
begin
  // Формируем кнопку примера на frmKeySettings и меню символов
  with frmKeyboard, frmKeySettings, frmKeySettings.rkExample do
  begin
    CaptionTopLeft     := (pmKbd.PopupComponent as TRealKey).CaptionTopLeft;
    CaptionBottomLeft  := (pmKbd.PopupComponent as TRealKey).CaptionBottomLeft;
    CaptionTopRight    := (pmKbd.PopupComponent as TRealKey).CaptionTopRight;
    CaptionBottomRight := (pmKbd.PopupComponent as TRealKey).CaptionBottomRight;
    Refresh;
    frmKeySettings.Caption := lngKey + ': ' + CaptionTopLeft + '     ' + lngKeyScanCode + ': ' + IntToStr(CurKeyScanCode);

    if pmTopChar.Items.Count <= 3 then begin
      MkMenuFromIni := TMakeMenuFromIniThread.Create(true);
      MkMenuFromIni.Priority := tpHigher;
      MkMenuFromIni.Resume;
    end;

  end;
  frmKeySettings.ShowModal;
end;

// акция КОПИРОВАТЬ ВЕРХНИЙ СИМВОЛ В БУФЕР ОБМЕНА
procedure TfrmKeyboard.actKbdCopyAddExecute(Sender: TObject);
begin
  Clipboard.AsText := (pmKbd.PopupComponent as TRealKey).CaptionTopRight;
end;

// акция КОПИРОВАТЬ НИЖНИЙ СИМВОЛ В БУФЕР ОБМЕНА
procedure TfrmKeyboard.actKbdCopyExecute(Sender: TObject);
begin
  Clipboard.AsText := (pmKbd.PopupComponent as TRealKey).CaptionBottomRight;
end;

// акция ВКЛ/ВЫКЛ АВТО РЕЖИМА ПОДСКАЗКИ
procedure TfrmKeyboard.actLearnModeExecute(Sender: TObject);
begin
  actLearnMode.Checked := not actLearnMode.Checked;
end;

// акция ЗАГРУЗИТЬ ПРЕСЕТ ПО-УМОЛЧАНИЮ
procedure TfrmKeyboard.actLoadPresetDefaultExecute(Sender: TObject);
begin
  LoadChars(KbdDefault);
//  ShowCurrentPreset;
end;

// акция ЗАГРУЗИТЬ ПОЛЬЗОВАТЕЛЬСКИЙ ПРЕСЕТ
procedure TfrmKeyboard.actLoadPresetUserExecute(Sender: TObject);
begin
  LoadChars(KbdFileNameUser);
//  ShowCurrentPreset;
end;

// акция ПРИБИТЬ ТЕКУЩИЙ ПРЕСЕТ И ВКЛЮЧИТЬ ДЕФОЛТНЫЙ
procedure TfrmKeyboard.actDeleteCurPresetExecute(Sender: TObject);
var
  PresetFile: TextFile;
begin
  case MessageBoxEx(Handle, PChar(Format(lngMsgDelPreset,[CurrentPreset])),PChar(constProgramName),MB_OKCANCEL or MB_ICONQUESTION or MB_APPLMODAL, 0) of
    IDOK: begin
            AssignFile(PresetFile, AppPresetPath + CurrentPreset + PresetFilesExt);
            Erase(PresetFile);
            actLoadPresetDefaultExecute(Self);
          end;
    IDCANCEL:exit;
  end;
end;

// акция ОТКРЫТЬ ПАПКУ С ПРЕСЕТАМИ
procedure TfrmKeyboard.actOpenPresetsFolderExecute(Sender: TObject);
begin
  ShellExecute(Self.Handle, 'Open', PChar(AppPresetPath), nil, nil, SW_SHOWNORMAL);
end;

// акция ВОССТАНОВИТЬ СТАНДАРТНЫЕ ПРЕСЕТЫ
procedure TfrmKeyboard.actRestoreStdPresetsExecute(Sender: TObject);
begin
  RestoreStdPresets;
  DoBalloon(bfInfo, lngMsgStdPresetsRestored);
end;

// акция ОТКРЫТЬ ОКНО СОХРАНЕНИЯ ПРЕСЕТА
procedure TfrmKeyboard.actSaveNewPresetExecute(Sender: TObject);
begin
  isCreateOrSavePreset := false;
  frmNewPreset.Show;
end;

// акция ПОКАЗАТЬ ЭКР.КЛАВУ
procedure TfrmKeyboard.actShowKbdExecute(Sender: TObject);
begin
  lblKbdCaptionPreset.Font.Color := constKeyFontColorNormal;
  lblKbdCaptionPreset.Caption := Format(lngFrmKbdCaption, [GetHumanizedPresetName(CurrentPreset)]);
  rsbExit.Enabled := true;
  actKbdClose.Enabled := frmKeyboard.rsbExit.Enabled;
  ShowKeyboard (not isKbdShown);
  isAltF1Pressed := not isAltF1Pressed;
//  actLearnMode.Enabled := not isAltF1Pressed;
end;


// ===================== РАЗНОЕ =======================

// форма: создание
procedure TfrmKeyboard.FormCreate(Sender: TObject);
begin
  Application.Title := constProgramName;
  Caption     := Application.Title;
//  CharEditModeTop    := cemHEX;
//  CharEditModeBottom := cemHEX;
  isKbdChanged := false; // клавиатуру не перенастраивали
//  StartHook;
  ActivateHookAndKeys (isActivated);
  {MakeMapFile;
  LoadHookDLL (AppPath + HookDllName);
  }
  // Устанавливаем скан-коды системных клавишь
//  SystemKeys := [0{0},1{esc},14{backspace},15{tab},28{enter},58{caps},42{lshift},54{rshift},29{ctrl},91{win},56{alt},93{menu},57{space}];
//  SystemKeys := [0{0},1{esc},14{backspace},15{tab},58{caps},42{lshift},54{rshift},29{ctrl},91{win},56{alt},93{menu}];
  //rsbExit.BmpNormal.LoadFromResourceName  (Hinstance,'ExitNormal'); // уже загружен в дизайнере
  rsbExit.BmpActive.LoadFromResourceName  (Hinstance,'ExitActive');
  rsbExit.BmpDown.LoadFromResourceName    (Hinstance,'ExitDown');
  rsbExit.BmpDisable.LoadFromResourceName (Hinstance,'ExitDisable');
//  Нужно, чтобы показывались другие контролы на форме, иначе глючит ShowWindow + SW_SHOWNOACTIVATE
//  Top    := 0;
//  Left   := 0;
//  Width  := 0;
//  Height := 0;
//  Visible := true;  // Собственно, нужно только это, остальное, чтобы это не бросалось в глаза
//  Visible := false; // Можно сделать Show;Hide; но так лучше // из-за этого мигает кнопка на таскбаре при запуске
  Width  := imgKbd.Width;
  Height := imgKbd.Height;
  // Нужно, чтобы показывались другие контролы на форме, иначе глючит ShowWindow + SW_SHOWNOACTIVATE
  if KbdTop  > Screen.DesktopHeight then KbdTop  := Screen.DesktopHeight - Height;
  if KbdLeft > Screen.DesktopWidth  then KbdLeft := Screen.DesktopWidth  - Width;
  Top  := KbdTop;
  Left := KbdLeft;
  AlphaBlendValue := KbdAlphaBlendValue;
  rsbExit.Enabled := false;
  actKbdClose.Enabled := rsbExit.Enabled;
  lblKbdCaptionPreset.Font.Color := constKeyFontColorNormal;
  // CreateScrKbd и LoadKeysFromIni вызываются в TfrmOptions.FormCreate потому что здесь слишком рано
end;

// форма: считываем настройки приложения, прикручиваем тень
procedure TfrmKeyboard.CreateParams(var Params: TCreateParams);
begin
  inherited;

  fntLeftSide   := TFont.Create;
  fntRightSide  := TFont.Create;
  fntDiacrit    := TFont.Create;

  Settings_Load;
  if isKbdShadow then
    Params.WindowClass.Style := Params.WindowClass.Style or CS_DROPSHADOW;
end;

// форма: прячем по двойному клику
procedure TfrmKeyboard.FormDblClick(Sender: TObject);
begin
  if not actLearnMode.Checked
    then ShowKeyboard(false)
    else if isAltF1Pressed then
    begin
//      ShowKeyboard(false);
//      isAltF1Pressed := not isAltF1Pressed;
      actShowKbdExecute(frmOptions);
    end;
end;

//todo: визард первого запуска: стартуем
{procedure TfrmKeyboard.FirstStartWizard;       //<<<!!!
begin
  (*if DLLWzrdHandle = 0
    then LoadWzrdDLL;
  DLLWzrdFirstStartWizardShow;*)
end;}

// форма: попытка закрытия
procedure TfrmKeyboard.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
//  CanClose := false;
  Hide;
end;

// форма: убиваем форму
procedure TfrmKeyboard.FormDestroy(Sender: TObject);
var i : integer;
begin
  fntLeftSide.Free;
  fntRightSide.Free;
  fntDiacrit.Free;
  StopHook;
  RemoveGlobalHotKey(hkEnable);
  //возвращаем настройки кнопки питания
  UnlockPowerKey;
  for i := 0 to constMaxRealKeys - 1 do ScrKeys[i].Free;
end;

// форма: ловим нажатия клавиатуры над формой. Esc - прячем форму.
procedure TfrmKeyboard.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_ESCAPE then ShowKeyboard(false);
end;

// форма: секретный сброс шрифтов по Ctrl+Shift+R
procedure TfrmKeyboard.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = 82{R}) and (ssCtrl in Shift) and (ssShift in Shift) then
  begin
    constLeftFontName     := constKeyFontNameCalibri;
    constLeftFontSize     := 10;
    constRightFontName    := constKeyFontNameCalibri;
    constRightFontSize    := 11;
    constDiacritFontName  := constKeyFontNameCalibri;
    constDiacritFontSize  := 13;
    SetAllFonts;
  end;
//  isClearType := false;
end;

// форма: всплывающее меню формы, прячем пункт настройки клавиши, если нажали не на клавише
procedure TfrmKeyboard.pmKbdPopup(Sender: TObject);
begin
  MakePresetMenu;
  actShowKeySets.Enabled := false;
  actKbdCopy.Visible     := false;
  actKbdCopyAdd.Visible  := false;

  if pmKbd.PopupComponent is TRealKey
  then begin
    CurKeyScanCode := pmKbd.PopupComponent.Tag;
    if (not (CurKeyScanCode in SystemKeys)) and (CurKeyScanCode <> 28{enter}) and (CurKeyScanCode <> 57{space}) then begin
      actShowKeySets.Enabled := true;
      if (pmKbd.PopupComponent as TRealKey).CaptionTopRight <> '' then begin
        actKbdCopyAdd.Caption := '&' + Format(lngKeyCopy, [(pmKbd.PopupComponent as TRealKey).CaptionTopRight]);
        actKbdCopyAdd.Visible := true;
//        DoBalloon(bfInfo, actKbdCopyAdd.Caption);
      end;
      if (pmKbd.PopupComponent as TRealKey).CaptionBottomRight <> '' then begin
        actKbdCopy.Caption    := '&' + Format(lngKeyCopy, [(pmKbd.PopupComponent as TRealKey).CaptionBottomRight]) + constLongSpace;
        actKbdCopy.Visible    := true;
//        DoBalloon(bfInfo, Format(lngKeyCopy, [(pmKbd.PopupComponent as TRealKey).CaptionBottomRight]) + ' - ' + actKbdCopyAdd.Caption + ' - ' + lngKeyCopy);
      end;
    end;
  end;
end;

// форма: главное меню в трее
procedure TfrmKeyboard.pmMainPopup(Sender: TObject);
begin
  MakePresetMenu;
  actHelpTopics.Enabled := not (not FileExists (AppLocalsPath + 'help.' + CurrentLangName + '.chm') and not FileExists (AppLocalsPath + 'help.' + constLangEN_US_str + '.chm'));
  pmEnable.Default       := DblClickMode;
  pmShowKeyboard.Default := not DblClickMode;
//  actHelpTopics.Enabled := false;
//  actFirstStartWizard.Enabled := not DLLWzrdGetFirstStartWizardVisible;
end;


// форма: отключаем двойной клик правой кнопки
procedure TfrmKeyboard.TrayIconMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft
    then isLeftBtn := true
    else isLeftBtn := false;
end;

// форма: активация/деактивация на иконке в трее
procedure TfrmKeyboard.TrayIconDblClick(Sender: TObject);
begin
  if DblClickMode then begin
    actEnableExecute(Self);
  end
  else begin
    actShowKbdExecute(Self);
  end;
//  if not isLeftBtn then exit;
end;

// форма: таскаем форму за любое место...
procedure TfrmKeyboard.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (isCapture) or (Button <> mbLeft) then exit;
  SetCapture(Handle);
  isCapture := true;
  MouseDownSpot.X := X;
  MouseDownSpot.Y := Y;
end;

// форма: таскаем форму за любое место...
procedure TfrmKeyboard.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
 if isCapture then
  begin
    Left := Left - (MouseDownSpot.x - x);
    Top  := Top  - (MouseDownSpot.y - y);
  end;
end;

// форма: таскаем форму за любое место.
procedure TfrmKeyboard.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
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

// форма: меняем прозрачность формы
procedure TfrmKeyboard.FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  if (WheelDelta < 0) and (AlphaBlendValue+round(WheelDelta/10) <= MinAlphaValue)
    then begin
      AlphaBlendValue := MinAlphaValue;
      KbdAlphaBlendValue := AlphaBlendValue;
      exit;
    end;

  if (WheelDelta > 0) and (AlphaBlendValue+round(WheelDelta/10) >= 255)
    then begin
      AlphaBlendValue := 255;
      KbdAlphaBlendValue := AlphaBlendValue;
      exit;
    end;

  try
    AlphaBlendValue :=  (AlphaBlendValue + round(WheelDelta/10));
    KbdAlphaBlendValue := AlphaBlendValue;
  except
  end;
end;

// форма: работаем как экранная клавиатура
procedure TfrmKeyboard.KbdKeyDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var hTargetWin  : THandle;
    KbdPos      : TPoint;
    Smbl        : string;
begin

  if Button <> mbLeft then exit;

  Smbl := '';

  if not (ssShift in Shift) then
    if (Sender as TRealKey).Tag = 57 then // если пробел, то
      Smbl := Char(constNBSP) // неразрывный пробел
    else
      Smbl := (Sender as TRealKey).CaptionBottomRight // не пробел
  else
    Smbl := (Sender as TRealKey).CaptionTopRight;

  if Smbl <> '' then begin
    // получаем окно под нами и передаём ему фокус
    KbdPos.X   := frmKeyboard.Left - 1;
    KbdPos.Y   := frmKeyboard.Top - 1;
    hTargetWin := WindowFromPoint(KbdPos);
    SetForegroundWindow(hTargetWin);
    DoSendText(Smbl, true);
  end;

end;

// закрываемся из-за фатальной ошибки, в перспективе делать здесь что-то более разумное, доброе, вечное...
procedure CloseAppOnErr;
begin
  Application.Terminate; // в перспективе делать здесь что-то более разумное, доброе, вечное...
end;

// визард первого запуска: загражаем длл-ку
(*procedure TfrmKeyboard.LoadWzrdDLL;
begin
  DLLWzrdHandle := LoadLibrary (PChar(AppPath + WzrdDllName));
  if DLLWzrdHandle = 0 then
  begin
    raise Exception.Create(Format(lngErrMsgNoDll, [WzrdDllName]));
    CloseAppOnErr;
  end;
  @DLLWzrdFirstStartWizardClose       := GetProcAddress (DLLWzrdHandle, 'FirstStartWizardClose');
  @DLLWzrdFirstStartWizardFree        := GetProcAddress (DLLWzrdHandle, 'FirstStartWizardFree');
  @DLLWzrdFirstStartWizardShow        := GetProcAddress (DLLWzrdHandle, 'FirstStartWizardShow');
end;*)


end.
