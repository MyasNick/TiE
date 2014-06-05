unit unitLang;

interface

uses unitAbout, unitKeyboard, unitOptions, unitKeySettings, unitNewPreset,
     unitRU_RU, unitEN_US, unitConst, unitFunctions, Windows, SysUtils,
     ExtCtrls, Graphics, Classes, INIFiles;

var
  //---------------------- LANG STRING ------------------------
  lngEnable, lngShowKbd,  lngLearnMode, lngBlockKbd, lngSettings, lngSettingsTiE,
  lngSetsKbdPage, lngHelp, lngHelpTopics, lngAbout, lngHomePage, lngFindUpdate, lngFrstStrtWzrd,
  lngDonate, lngExit, lngShowKeySets, lngKbdClose, lngKbdPresets, lngPresetUser, lngSetKeys,
  lngPresetDefault, lngPresetSaveNew, lngPresetOpenFldr, lngPresetDelete, lngPresetCreate,
  lngRestoreStdPresets,
  {constTools,}
  //-----------------------------------------------------------
  lngMsgOneInst, lngMsgFirstStart, lngMsgKbdLocked, lngMsgKbdUnLocked, lngMsgDelPreset, lngMsgAchtung,
  lngMsgOverWPreset, lngMsgAnotherName, lngMsgPresetLoaded, lngMsgResetFons, lngMsgLoadDefPrst,
  lngMsgActivated, lngMsgDeactivated, lngMsgToSetKey, lngMsgStdPresetsRestored,
  lngAttentionAltGr, lngMsgAttentionWin,
  //-----------------------------------------------------------
  lngTxtEnterCodes, lngTxtFindCodes, lngTxtRestartApp, lngTxtNewPrstName, lngTxtTopChar,
  lngTxtBottomChar, lngTxtNewPreset,
  //-----------------------------------------------------------
  lngErrMsgMapFile, lngErrMsgDllFunc, lngErrMsgNoDll,
  //-----------------------------------------------------------
  lngLeftAlt, lngRightGr, lngLeftCtrl, lngRightCtrl, lngWin, lngLeftWin, lngRightWin, lngPopupMenu,
  //-----------------------------------------------------------
  lngOptGeneral, lngOptKeys, lngOptMisc, lngOptGlbHotKeysGB, lngOptCtrlKeyGB, lngOptAddCtrlKeyGB,
  lngOptHotKeyEnbl, lngOptHotKeyLock, lngOptAppLang, lngOptUseClrType, lngOptShowKbdShdw,
  lngOptCharCode, lngOptResetFonts, lngOptResetFontsL, lngOptBtnFont, lngOptLeftFont, lngOptRightFont,
  lngOptDiacritFont, lngOptShowPrstInf, lngOptDblClickMode, lngAutoHintDelay,
  {constOptLocks, constOptHotKeys,}
  //-----------------------------------------------------------
  lngOK, lngCancel, lngClearKey, lngQuoteOpen, lngQuoteClose,
  lngSetCharFont, lngResetCharFont,
  //-----------------------------------------------------------
  lngKey, lngKeyScanCode, lngKeyCopy, lngKeyFuncPrefix, lngKeyFuncHelp, lngKeyEsc, lngKeyTab,
  lngKeyEnter, lngKeyAlt, lngKeyAltGr, lngKeyCtrl, lngKeyWin, lngKeyMenu, lngKeySpace,
  lngKeyBackspace, lngKeyCaps, lngKeyShift, lngKeyBckspcArrow, lngKeyCapsArrow,
  lngKeyShiftArrow, lngKeyNonbrSpace, lngKeyAccent,
  //-----------------------------------------------------------
  lngFrmKbdCaption: string;
  //-----------------------------------------------------------


function  GetLangName(Lang: word): string;
function  GetLangCode(LangName: string): word;
function  CheckLang (Lang: word): word;
procedure DoLang (Lang: word);
procedure GetLanguages (sl: TStringList; IsFileName: boolean); // true = file name list, false = language name list
procedure LoadLangFromINI (LangCode: Word);



implementation

// Проверяем наличие языкового файла и если нужно переключаем язык на совместимый
function  CheckLang (Lang: word): word;
var
  sl: TStringList;
  LangINI: TINIFile;
begin

  if (Lang = constLangEN_US) or (Lang = constLangRU_RU) then begin
    Result := Lang;
    Exit;
  end
  else
    if Pos(LowerCase(IntToHex(Lang,4)), RusCompatible) <> 0 then begin
      Result := constLangRU_RU;
      Exit;
    end
    else begin
      sl := TStringList.Create;
      GetLanguages(sl,true);
      if sl.Values[IntToStr(Lang)] <> '' then begin
        if FileExists(AppLocalsPath + sl.Values[IntToStr(Lang)]) then begin
          try
            LangINI := TIniFile.Create (AppLocalsPath + sl.Values[IntToStr(Lang)]);
            Result  := LangINI.ReadInteger('Locale', 'LocaleID', constLangEN_US); // если мы при первом запуске получили совместимую локаль, то здесь язык переключится на тот, с чем совместим
            LangINI.Free;
          except
            Result := constLangEN_US;
          end;
        end
        else
          Result := constLangEN_US;
      end
      else // не нашли ни основного ни совместимого языка
        Result := constLangEN_US;
      sl.Free;
    end;
// По уму, тут нунж сделать игнорирование совместимости, если для совместимого языка есть отдельный файл
// По хорошему сюда нужно ещё проверку корректности языкового файла добавить
end;

// Добываем самоназвание языка
function  GetLangName(Lang: word): string;
var
  sl: TStringList;
begin
  case Lang of
    constLangEN_US: Result := constLangEN_US_name;
    constLangRU_RU: Result := constLangRU_RU_name;
  else
    sl := TStringList.Create;
    GetLanguages(sl,false);
    Result := sl.Values[IntToStr(Lang)];
    sl.Free;
  end;
end;

// Добываем код языка из его самоназвания
function  GetLangCode(LangName: string): word;
var
  sl: TStringList;
  i:  integer;
begin
  Result := constLangEN_US;

  if LangName = constLangEN_US_name
    then Result := constLangEN_US
    else if LangName = constLangRU_RU_name
           then Result := constLangRU_RU
           else begin
             sl := TStringList.Create;
             GetLanguages(sl,false);
             for i := 0 to sl.Count - 1 do
               if sl.Values[sl.Names[i]] = LangName
                  then Result := StrToInt(sl.Names[i]);
             sl.Free;
           end;
end;

// Добываем список доступных языков  true = file name list, false = language name list
procedure GetLanguages (sl: TStringList; IsFileName: boolean);
var
  LangINI: TINIFile;
  i,j: integer;
  slCompatible, slFiles: TStringList;
begin
  slFiles := TStringList.Create;
  sl.Clear;

  FindFiles(AppLocalsPath, '*' + constLangFileExt, slFiles);

  if slFiles.IndexOf(constLangEN_US_str + '.lng')<>-1
    then slFiles.Delete(slFiles.IndexOf(constLangEN_US_str + constLangFileExt));

  for i := 0 to slFiles.Count - 1 do
    try
      LangINI := TIniFile.Create (AppLocalsPath + slFiles[i]);
      if IsFileName then begin // заполняем стринглист строками вида 1033=en_US.lng
        sl.Append(LangINI.ReadString('Locale', 'LocaleID', '') + '=' + slFiles[i]);
        slCompatible := TStringList.Create;
        LangINI.ReadSection('Сompatible', slCompatible as TStrings);
        for j := 0 to slCompatible.Count - 1 do sl.Append(slCompatible[j] + '=' + slFiles[i]);
//        slCompatible.SaveToFile('d:\nick\downloads\lang.compatible.list.txt');
        slCompatible.Free;
//        doballoon(bfInfo,'!');
      end
      else                // заполняем стринглист строками вида 1033=English (US)
        sl.Append(LangINI.ReadString('Locale', 'LocaleID', '') + '=' + LangINI.ReadString('Locale', 'LocaleDescription', ''));
      LangINI.Free;
    except
    end;
  slFiles.Free;
//  sl.SaveToFile('d:\nick\downloads\lang.list.txt');
end;

// Считываем язык из файла
procedure LoadLangFromINI (LangCode: Word);
var
  LangINI: TINIFile;
  sl: TStringList;
  LangFileName: string;
begin
  sl := TStringList.Create;
  GetLanguages (sl, true);

  if sl.Count > 0
//    then if sl[0] <> ''
      then LangFileName := AppLocalsPath + sl.Values[IntToStr(LangCode)];
//  DoBalloon (bfInfo, LangFileName);
//  sl.SaveToFile('d:\nick\downloads\lang.list.txt');

  if FileExists(LangFileName) then
    with LangINI do
    try
      LangINI           := TIniFile.Create (LangFileName);
      //----------------------------------------------------
      CurrentLangName   := ReadString('Locale',      'LocaleStr',         CurrentLangName);
      KbdDefPresetFN    := ReadString('Locale',      'Preset',            '');
      //----------------------------------------------------
      lngFrmKbdCaption  := ReadString('Translation', 'lngFrmKbdCaption',  lngFrmKbdCaption);
      lngEnable         := ReadString('Translation', 'lngEnable',         lngEnable);
      lngShowKbd        := ReadString('Translation', 'lngShowKbd',        lngShowKbd);
      lngLearnMode      := ReadString('Translation', 'lngLearnMode',      lngLearnMode);
      lngBlockKbd       := ReadString('Translation', 'lngBlockKbd',       lngBlockKbd);
      lngSettings       := ReadString('Translation', 'lngSettings',       lngSettings);
      lngSettingsTiE    := ReadString('Translation', 'lngSettingsTiE',    lngSettingsTiE);
      lngSetsKbdPage    := ReadString('Translation', 'lngSetsKbdPage',    lngSetsKbdPage);
      lngHelp           := ReadString('Translation', 'lngHelp',           lngHelp);
      lngHelpTopics     := ReadString('Translation', 'lngHelpTopics',     lngHelpTopics);
      lngAbout          := ReadString('Translation', 'lngAbout',          lngAbout);
      lngHomePage       := ReadString('Translation', 'lngHomePage',       lngHomePage);
      lngFindUpdate     := ReadString('Translation', 'lngFindUpdate',     lngFindUpdate);
      lngDonate         := ReadString('Translation', 'lngDonate',         lngDonate);
      lngFrstStrtWzrd   := ReadString('Translation', 'lngFrstStrtWzrd',   lngFrstStrtWzrd);
      lngExit           := ReadString('Translation', 'lngExit',           lngExit);
      lngShowKeySets    := ReadString('Translation', 'lngShowKeySets',    lngShowKeySets);
      lngKbdClose       := ReadString('Translation', 'lngKbdClose',       lngKbdClose);
      lngKbdPresets     := ReadString('Translation', 'lngKbdPresets',     lngKbdPresets);
      lngPresetUser     := ReadString('Translation', 'lngPresetUser',     lngPresetUser);
      lngPresetDefault  := ReadString('Translation', 'lngPresetDefault',  lngPresetDefault);
      lngPresetSaveNew  := ReadString('Translation', 'lngPresetSaveNew',  lngPresetSaveNew);
      lngPresetOpenFldr := ReadString('Translation', 'lngPresetOpenFldr', lngPresetOpenFldr);
      lngPresetDelete   := ReadString('Translation', 'lngPresetDelete',   lngPresetDelete);
      lngPresetCreate   := ReadString('Translation', 'lngPresetCreate',   lngPresetCreate);
      lngSetKeys        := ReadString('Translation', 'lngSetKeys',        lngSetKeys);
      lngRestoreStdPresets := ReadString('Translation', 'lngRestoreStdPresets', lngRestoreStdPresets);
      //----------------------------------------------------
      lngOptGeneral     := ReadString('Translation', 'lngOptGeneral',     lngOptGeneral);
      lngOptKeys        := ReadString('Translation', 'lngOptKeys',        lngOptKeys);
      lngOptMisc        := ReadString('Translation', 'lngOptMisc',        lngOptMisc);
      lngOptGlbHotKeysGB:= ReadString('Translation', 'lngOptGlbHotKeysGB',lngOptGlbHotKeysGB);
      lngOptCtrlKeyGB   := ReadString('Translation', 'lngOptCtrlKeyGB',   lngOptCtrlKeyGB);
      lngOptAddCtrlKeyGB:= ReadString('Translation', 'lngOptAddCtrlKeyGB',lngOptAddCtrlKeyGB);
      lngOptHotKeyEnbl  := ReadString('Translation', 'lngOptHotKeyEnbl',  lngOptHotKeyEnbl);
      lngOptHotKeyLock  := ReadString('Translation', 'lngOptHotKeyLock',  lngOptHotKeyLock);
      lngOptUseClrType  := ReadString('Translation', 'lngOptUseClrType',  lngOptUseClrType);
      lngOptShowKbdShdw := ReadString('Translation', 'lngOptShowKbdShdw', lngOptShowKbdShdw);
      lngOptAppLang     := ReadString('Translation', 'lngOptAppLang',     lngOptAppLang);
      lngOptCharCode    := ReadString('Translation', 'lngOptCharCode',    lngOptCharCode);
      lngOptResetFonts  := ReadString('Translation', 'lngOptResetFonts',  lngOptResetFonts);
      lngOptResetFontsL := ReadString('Translation', 'lngOptResetFontsL', lngOptResetFontsL);
      lngOptBtnFont     := ReadString('Translation', 'lngOptBtnFont',     lngOptBtnFont);
      lngOptLeftFont    := ReadString('Translation', 'lngOptLeftFont',    lngOptLeftFont);
      lngOptRightFont   := ReadString('Translation', 'lngOptRightFont',   lngOptRightFont);
      lngOptDiacritFont := ReadString('Translation', 'lngOptDiacritFont', lngOptDiacritFont);
      lngOptShowPrstInf := ReadString('Translation', 'lngOptShowPrstInf', lngOptShowPrstInf);
      lngOptDblClickMode:= ReadString('Translation', 'lngOptDblClickMode',lngOptDblClickMode);
      lngAutoHintDelay  := ReadString('Translation', 'lngAutoHintDelay',  lngAutoHintDelay);
      //----------------------------------------------------
      lngOK             := ReadString('Translation', 'lngOK',             lngOK);
      lngCancel         := ReadString('Translation', 'lngCancel',         lngCancel);
      lngClearKey       := ReadString('Translation', 'lngClearKey',       lngClearKey);
      lngQuoteOpen      := ReadString('Translation', 'lngQuoteOpen',      lngQuoteOpen);
      lngQuoteClose     := ReadString('Translation', 'lngQuoteClose',     lngQuoteClose);
      //-----------------------------------------------------------
      lngKey            := ReadString('Translation', 'lngKey',            lngKey);
      lngKeyScanCode    := ReadString('Translation', 'lngKeyScanCode',    lngKeyScanCode);
      lngKeyCopy        := ReadString('Translation', 'lngKeyCopy',        lngKeyCopy);
      lngKeyFuncPrefix  := ReadString('Translation', 'lngKeyFuncPrefix',  lngKeyFuncPrefix);
      lngKeyFuncHelp    := ReadString('Translation', 'lngKeyFuncHelp',    lngKeyFuncHelp);
      lngKeyEsc         := ReadString('Translation', 'lngKeyEsc',         lngKeyEsc);
      lngKeyTab         := ReadString('Translation', 'lngKeyTab',         lngKeyTab);
      lngKeyEnter       := ReadString('Translation', 'lngKeyEnter',       lngKeyEnter);
      lngKeyAlt         := ReadString('Translation', 'lngKeyAlt',         lngKeyAlt);
      lngKeyAltGr       := ReadString('Translation', 'lngKeyAltGr',       lngKeyAltGr);
      lngKeyCtrl        := ReadString('Translation', 'lngKeyCtrl',        lngKeyCtrl);
      lngKeyWin         := ReadString('Translation', 'lngKeyWin',         lngKeyWin);
      lngKeyMenu        := ReadString('Translation', 'lngKeyMenu',        lngKeyMenu);
      lngKeySpace       := ReadString('Translation', 'lngKeySpace',       lngKeySpace);
      lngKeyBackspace   := ReadString('Translation', 'lngKeyBackspace',   lngKeyBackspace);
      lngKeyCaps        := ReadString('Translation', 'lngKeyCaps',        lngKeyCaps);
      lngKeyShift       := ReadString('Translation', 'lngKeyShift',       lngKeyShift);
      lngKeyBckspcArrow := ReadString('Translation', 'lngKeyBckspcArrow', lngKeyBckspcArrow);
      lngKeyCapsArrow   := ReadString('Translation', 'lngKeyCapsArrow',   lngKeyCapsArrow);
      lngKeyShiftArrow  := ReadString('Translation', 'lngKeyShiftArrow',  lngKeyShiftArrow);
      lngKeyNonbrSpace  := ReadString('Translation', 'lngKeyNonbrSpace',  lngKeyNonbrSpace);
      lngKeyAccent      := ReadString('Translation', 'lngKeyAccent',      lngKeyAccent);
      lngSetCharFont    := ReadString('Translation', 'lngSetCharFont',    lngSetCharFont);
      lngResetCharFont  := ReadString('Translation', 'lngResetCharFont',  lngResetCharFont);
      //-----------------------------------------------------------
      lngLeftAlt        := ReadString('Translation', 'lngLeftAlt',        lngLeftAlt);
      lngRightGr        := ReadString('Translation', 'lngRightGr',        lngRightGr);
      lngLeftCtrl       := ReadString('Translation', 'lngLeftCtrl',       lngLeftCtrl);
      lngRightCtrl      := ReadString('Translation', 'lngRightCtrl',      lngRightCtrl);
      lngWin            := ReadString('Translation', 'lngWin',            lngWin);
      lngLeftWin        := ReadString('Translation', 'lngLeftWin',        lngLeftWin);
      lngRightWin       := ReadString('Translation', 'lngRightWin',       lngRightWin);
      lngPopupMenu      := ReadString('Translation', 'lngPopupMenu',      lngPopupMenu);
      //----------------------------------------------------
      lngErrMsgMapFile  := ReadString('Translation', 'lngEnable',         lngEnable);
      lngErrMsgDllFunc  := ReadString('Translation', 'lngEnable',         lngEnable);
      lngErrMsgNoDll    := ReadString('Translation', 'lngEnable',         lngEnable);
      //----------------------------------------------------
      lngTxtEnterCodes  := ReadString('Translation', 'lngTxtEnterCodes',  lngTxtEnterCodes);
      lngTxtFindCodes   := ReadString('Translation', 'lngTxtFindCodes',   lngTxtFindCodes);
      lngTxtRestartApp  := ReadString('Translation', 'lngTxtRestartApp',  lngTxtRestartApp);
      lngTxtNewPrstName := ReadString('Translation', 'lngTxtNewPrstName', lngTxtNewPrstName);
      lngTxtTopChar     := ReadString('Translation', 'lngTxtTopChar',     lngTxtTopChar);
      lngTxtBottomChar  := ReadString('Translation', 'lngTxtBottomChar',  lngTxtBottomChar);
      lngTxtNewPreset   := ReadString('Translation', 'lngTxtNewPreset',   lngTxtNewPreset);
      //-----------------------------------------------------------
      lngMsgAchtung     := ReadString('Translation', 'lngMsgAchtung',     lngMsgAchtung);
      lngMsgOneInst     := ReadString('Translation', 'lngMsgOneInst',     lngMsgOneInst);
      lngMsgActivated   := ReadString('Translation', 'lngMsgActivated',   lngMsgActivated);
      lngMsgDeactivated := ReadString('Translation', 'lngMsgDeactivated', lngMsgDeactivated);
      lngMsgFirstStart  := ReadString('Translation', 'lngMsgFirstStart',  lngMsgFirstStart);
      lngMsgKbdLocked   := ReadString('Translation', 'lngMsgKbdLocked',   lngMsgKbdLocked);
      lngMsgKbdUnLocked := ReadString('Translation', 'lngMsgKbdUnLocked', lngMsgKbdUnLocked);
      lngMsgDelPreset   := ReadString('Translation', 'lngMsgDelPreset',   lngMsgDelPreset);
      lngMsgOverWPreset := ReadString('Translation', 'lngMsgOverWPreset', lngMsgOverWPreset);
      lngMsgAnotherName := ReadString('Translation', 'lngMsgAnotherName', lngMsgAnotherName);
      lngMsgPresetLoaded:= ReadString('Translation', 'lngMsgPresetLoaded',lngMsgPresetLoaded);
      lngMsgResetFons   := ReadString('Translation', 'lngMsgResetFons',   lngMsgResetFons);
      lngMsgLoadDefPrst := ReadString('Translation', 'lngMsgLoadDefPrst', lngMsgLoadDefPrst);
      lngMsgToSetKey    := ReadString('Translation', 'lngMsgToSetKey',    lngMsgToSetKey);
      lngMsgAttentionWin:= ReadString('Translation', 'lngMsgAttentionWin',lngMsgAttentionWin);
      lngMsgStdPresetsRestored := ReadString('Translation', 'lngMsgStdPresetsRestored',    lngMsgStdPresetsRestored);
      //-----------------------------------------------------------
      lngAttentionAltGr := ReadString('Info', 'AttentionAltGr',    lngAttentionAltGr);
      //-----------------------------------------------------------
      LangINI.Free;
    except
    end;
  sl.Free;
end;

// задает и настраивает текущий язык приложения
procedure DoLang (Lang: word);
var
  sl: TStringList;
  i: integer;
begin

  DoEN_US;                            //  English (US)

  if Lang = constLangRU_RU
    then DoRU_RU                      //  Russian
    else
      if Lang <> constLangEN_US
        then LoadLangFromINI(Lang);


  with frmOptions do
  begin
    frmOptions.Caption          := Format(lngSettingsTiE,[constProgramName]);
    btnOK.Caption               := lngOK;
    pcOptions.Pages[0].Caption  := lngOptGeneral;
    pcOptions.Pages[1].Caption  := lngOptKeys;
    pcOptions.Pages[2].Caption  := lngOptMisc;
    lblOptMainKey.Caption       := lngOptCtrlKeyGB;

    with comboxMainKey do
    begin
      Items.Clear;
      Items.Add(lngLeftCtrl);
      Items.Add(lngLeftWin);
      Items.Add(lngLeftAlt);
      Items.Add(lngRightGr);
      Items.Add(lngRightWin);
      Items.Add(lngRightCtrl);
      //Items.Add(constPopupMenu);
    end;

    with comboxLang do
    begin
      sl := TStringList.Create;
      GetLanguages(sl, false); // false = lang names list
      Items.Clear;
      Items.Add(constLangEN_US_name);
      Items.Add(constLangRU_RU_name);
      for i := 0 to sl.Count - 1 do
         Items.Add(sl.Values[sl.Names[i]]);
//      case CurrentLang of
//        constLangEN_US:  comboxLang.ItemIndex := comboxLang.Items.IndexOf(constLangEN_US_name);
//        constLangRU_RU:  comboxLang.ItemIndex := comboxLang.Items.IndexOf(constLangRU_RU_name);
//      end;
      comboxLang.ItemIndex := comboxLang.Items.IndexOf(GetLangName(CurrentLang));
      sl.Free;
    end;
//    vleKeys.TitleCaptions[0] := ' ' + lngKey;
//    vleKeys.TitleCaptions[1] := ' ' + lngOptCharCode;
    lblRestart.Caption          := lngTxtRestartApp;
    lblOptLang.Caption          := lngOptAppLang + constDveTochki;
    gbGlobalHotKeys.Caption     := ' ' + lngOptGlbHotKeysGB + ' ';
    lblHotKeyEnable.Caption     := lngOptHotKeyEnbl + ':  ' + lngLeftWin + ' +';
//    lblHotKeyLock.Caption       := lngOptHotKeyLock + ':  ' + lngLeftWin + ' +';
    chboxUseClearType.Caption   := lngOptUseClrType;
    chboxKbdDropShadow.Caption  := Format(lngOptShowKbdShdw,[constProgramName]);
    chboxShowPresetInfo.Caption := lngOptShowPrstInf;
    btnResetKbdFonts.Caption    := lngOptResetFonts;
    lblResetFonts.Caption       := lngOptResetFontsL;
    btnLeftSideFont.Caption     := lngOptBtnFont;
    lblFontLeftSide.Caption     := lngOptLeftFont;
    btnRightSideFont.Caption    := lngOptBtnFont;
//    lblFontRightSide.Caption    := lngOptRightFont;
    lblFontRightSide.Caption    := Format(lngOptRightFont,[constProgramName]);
    btnDiacritFont.Caption      := lngOptBtnFont;
    lblFontDiacrit.Caption      := lngOptDiacritFont;

    lblOptDblClickMode.Caption  := lngOptDblClickMode;
    chboxKbdDelay.Caption       := lngAutoHintDelay;
    with comboxDblClickMode do
    begin
      Items.Clear;
      Items.Add(lngEnable + ' ' + constProgramName);
      Items.Add(lngShowKbd);
      if DblClickMode then
        ItemIndex := 0
      else
        ItemIndex := 1;
    end;
end;

  with frmKeyboard do
  begin
    //lblKbdCaptionPreset.Caption := lngFrmKbdCaption;
    lblKbdCaptionPreset.Caption := Format(lngFrmKbdCaption, [GetHumanizedPresetName(CurrentPreset)]);
    TrayIcon.Hint          := constProgramName + ' ' + constProgramVersion;
    if EnableHotKeyCode <> 0
      then actEnable.Caption   := lngEnable + constLongSpace + {constOpenQuote +} lngWin + '+' + WideChar(Chr(EnableHotKeyCode)){ + constCloseQuote}
      else actEnable.Caption   := lngEnable;
//    actEnable.Caption      := lngEnable + constLongSpace + {constOpenQuote +} lngWin + '+' + WideChar(Chr(EnableHotKeyCode)){ + constCloseQuote};
    actSettings.Caption    := lngSettings + constTriTochki + constLongSpace; (*+ {constOpenQuote +} constWin + '+' + WideChar(Chr(SettingsHotKeyCode)){ + constCloseQuote}; *)
    actSettingsKbdPage.Caption := lngSetsKbdPage + constTriTochki;
//    actBlockKbd.Caption    := lngBlockKbd + constLongSpace + {constOpenQuote +} lngWin + '+' + WideChar(Chr(BlockKbdHotKeyCode)){ + constCloseQuote};
    actBlockKbd.Caption    := lngBlockKbd;
    actExit.Caption        := lngExit;
//    actAbout.Caption       := lngAbout + constMenuTriTochki;
    actAbout.Caption       := Format(lngAbout,[constProgramName]) + constTriTochki;
    actGoHomePage.Caption  := Format(lngHomePage,[constProgramName]);
    actGoCheckUpd.Caption  := lngFindUpdate;
    actGoDonate.Caption    := lngDonate;
    actFirstStartWizard.Caption := lngFrstStrtWzrd + constTriTochki;
    actHelpTopics.Caption  := lngHelpTopics + constTriTochki;
    actLearnMode.Caption   := lngLearnMode;
    actShowKeySets.Caption := lngShowKeySets + constTriTochki;
    actKbdClose.Caption    := lngKbdClose;
    //actBlockKbd.Caption   := constBlockKbd;
    //actSettings.Caption   := constSettings + constMenuTriTochki;
    pmHelp.Caption         := lngHelp;
    pmChoosePreset.Caption := lngKbdPresets;
    pmTrayPresets.Caption  := lngKbdPresets;
    actLoadPresetUser.Caption     := lngPresetUser;
    actLoadPresetDefault.Caption  := lngPresetDefault;
    actSaveNewPreset.Caption      := lngPresetSaveNew + constTriTochki;
    actOpenPresetsFolder.Caption  := lngPresetOpenFldr;
    actCreateNewPreset.Caption    := lngPresetCreate + constTriTochki;
    actDeleteCurPreset.Caption    := lngPresetDelete;
    actSetKeys.Caption            := lngSetKeys + constTriTochki;
    actRestoreStdPresets.Caption  := lngRestoreStdPresets;
    case ControlKey of
      VK_LMENU:     actShowKbd.Caption := lngShowKbd + constLongSpace + lngLeftAlt   + '+' + constKbdHintKeyStr;
      VK_RMENU:     actShowKbd.Caption := lngShowKbd + constLongSpace + lngRightGr   + '+' + constKbdHintKeyStr;
      VK_LCONTROL:  actShowKbd.Caption := lngShowKbd + constLongSpace + lngLeftCtrl  + '+' + constKbdHintKeyStr;
      VK_RCONTROL:  actShowKbd.Caption := lngShowKbd + constLongSpace + lngRightCtrl + '+' + constKbdHintKeyStr;
      VK_LWIN:      actShowKbd.Caption := lngShowKbd + constLongSpace + lngLeftWin   + '+' + constKbdHintKeyStr;
      VK_RWIN:      actShowKbd.Caption := lngShowKbd + constLongSpace + lngRightWin  + '+' + constKbdHintKeyStr;
      //  VK_RWIN:      actShowKbd.Caption := constShowKbd + '  ' + constOpenQuote + constRightWin + '+F1' + constCloseQuote;
    end;
    case ControlKey of
      VK_LMENU:     actBlockKbd.Caption := lngBlockKbd + constLongSpace + lngLeftAlt   + '+' + constKbdBlockKeyStr;
      VK_RMENU:     actBlockKbd.Caption := lngBlockKbd + constLongSpace + lngRightGr   + '+' + constKbdBlockKeyStr;
      VK_LCONTROL:  actBlockKbd.Caption := lngBlockKbd + constLongSpace + lngLeftCtrl  + '+' + constKbdBlockKeyStr;
      VK_RCONTROL:  actBlockKbd.Caption := lngBlockKbd + constLongSpace + lngRightCtrl + '+' + constKbdBlockKeyStr;
      VK_LWIN:      actBlockKbd.Caption := lngBlockKbd + constLongSpace + lngLeftWin   + '+' + constKbdBlockKeyStr;
      VK_RWIN:      actBlockKbd.Caption := lngBlockKbd + constLongSpace + lngRightWin  + '+' + constKbdBlockKeyStr;
      //  VK_RWIN:      actShowKbd.Caption := constShowKbd + '  ' + constOpenQuote + constRightWin + '+F1' + constCloseQuote;
    end;
  end;

  with frmKeySettings do
  begin
    Caption                       := lngKey + ': ' + frmKeySettings.rkExample.CaptionTopLeft + '     ' + lngKeyScanCode + ': ' + IntToStr(CurKeyScanCode);
    btnOK.Caption                 := lngOK;
    btnCancel.Caption             := lngCancel;
    btnClear.Caption              := lngClearKey;
    lblEnterCodes.Caption         := lngTxtEnterCodes;
    llblFindCodesHere.Caption     := lngTxtFindCodes;
    lblTopChar.Caption            := lngTxtTopChar + constDveTochki;
    lblBottomChar.Caption         := lngTxtBottomChar + constDveTochki;
    pmTopCharFont.Caption         := lngSetCharFont + constTriTochki;
    pmTopCharFontReset.Caption    := lngResetCharFont;
    pmBottomCharFont.Caption      := lngSetCharFont + constTriTochki;
    pmBottomCharFontReset.Caption := lngResetCharFont;
  end;

  with frmNewPreset do
  begin
    frmNewPreset.Caption := constProgramName;
    editNewPresetName.EditLabel.Caption := lngTxtNewPrstName + constDveTochki;
    btnOK.Caption := lngOK;
    btnCancel.Caption := lngCancel;
  end;

  with frmAbout do
  begin
    frmAbout.Caption        := constProgramName;
    lblProgramName.Caption  := constProgramName + ' ' + constProgramVersion;
    lblMadeInGrey.Caption   := lngBranding;
    lblMadeInWhite.Caption  := lngBranding;
    lblVersion.Caption      := lngVersion + ': ' + constProgramFullVer + '  (' + lngProgramDate + ')';
    lblCopyright.Caption    := lngCopyright;
    {if pos('http://', lngMasnikovSite) <> 0
      then lblCopyright.URL := lngMasnikovSite
      else lblCopyright.URL := 'http://'+lngMasnikovSite;}
    btnOK.Caption           := lngOK;
    lblHomePage.Caption     := lngProgramSite;
    if pos('http://', lngProgramSite) <> 0
      then lblHomePage.URL  := lngProgramSite
      else lblHomePage.URL  := 'http://'+lngProgramSite;
  end;

  if StartCounter = 0
  then begin
    DoBalloon (bfInfo, lngMsgFirstStart);
    frmKeyboard.actFirstStartWizardExecute(frmKeyboard);
  end;

  if not isStartUp then
    case MessageBoxEx(frmOptions.Handle, PChar(lngMsgLoadDefPrst),PChar(constProgramName),MB_YESNO or MB_ICONQUESTION or MB_APPLMODAL, 0) of
      IDYES: LoadChars(KbdDefault);
    end;

  frmKeyboard.CreateCaptionsScrKbd;
  frmKeyboard.lblKbdCaptionPreset.Font.Color := constKeyFontColorNormal;

end;


end.
