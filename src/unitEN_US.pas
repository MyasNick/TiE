unit unitEN_US;

interface

procedure DoEN_US;

implementation

uses unitConst, unitKeyboard, unitLang;

procedure DoEN_US;
begin
  CurrentLangName   := constLangEN_US_str;
  KbdDefPresetFN    := '';
  //----------------------------------------------------
//  lngFrmKbdCaption  := 'Current keyboard preset is “%s”';
  lngFrmKbdCaption  := '%s';
  lngEnable         := 'Enable';
  lngShowKbd        := 'Show Keyboard';
  lngLearnMode      := 'Auto Popup Hint';
  lngBlockKbd       := 'Lock Keyboard';
  lngSettings       := 'Options';
  lngSettingsTiE    := '%s Options';
  lngSetsKbdPage    := 'Keyboard Settings';
  lngHelp           := 'Help';
  lngHelpTopics     := 'Help Topics';
  lngAbout          := 'About %s';
  lngHomePage       := '%s Home Page';
  lngFindUpdate     := 'Check for Updates';
  lngDonate         := 'Make a Donation';
  lngFrstStrtWzrd   := 'First Start Wizard';
  lngExit           := 'Exit';
  lngShowKeySets    := 'Customize Key';
  lngKbdClose       := 'Hide On-Screen Keyboard';
  lngKbdPresets     := 'Keyboard Presets';
  lngPresetUser     := 'User Defined';
  lngPresetDefault  := 'Application Default';
  lngPresetSaveNew  := 'Save As';
  lngPresetOpenFldr := 'Open Presets Folder';
  lngPresetDelete   := 'Delete Current';
  lngPresetCreate   := 'Create New';
  lngSetKeys        := 'Customize Keys';
  lngRestoreStdPresets := 'Restore Standard Presets';
  //----------------------------------------------------
  lngMsgAchtung     := 'Attention!';
  lngMsgOneInst     := 'The application is already running.';
  lngMsgActivated   := 'The application is activated.';
  lngMsgDeactivated := 'The application is deactivated.';
  lngMsgFirstStart  := 'The application is started for the first time. ' +
                       'To access its advanced features and settings, right-click the program icon below this message.';
  lngMsgKbdLocked   := 'The keyboard is locked.%sTo unlock it please uncheck “Lock Keyboard” menu item.';
  lngMsgKbdUnLocked := 'The keyboard is now unlocked.';
  lngMsgDelPreset   := 'Do you realy want to delete this preset: “%s”?';
  lngMsgOverWPreset := 'The preset “%s” already exists.%sDo you want to replace it?';
  lngMsgAnotherName := 'The word “%s” is reserved.%sPlease choose another name.';
  lngMsgPresetLoaded:= 'Current preset:';
  lngMsgResetFons   := 'Do really want to reset on-screen keyboard fonts?';
  lngMsgLoadDefPrst := 'Do you want to set default preset for English keyboard?';
  lngMsgToSetKey    := 'To customize a key right-click on it and choose “%s”';
  lngMsgAttentionWin:= 'The Win key is too “especial”.' + #13#10 + 'It''s not possible to provide permanent operability.' + #13#10;
  lngAttentionAltGr := '';
  lngMsgStdPresetsRestored := 'Standard presets were restored.';
  //-----------------------------------------------------------
  lngTxtEnterCodes  := 'To define characters for this key, please enter their hexadecimal codes without any special symbols in the form below. For example, hexadecimal code for euro sign (€) is 20AC.';
//  lngTxtFindCodes   := 'If you don''t know the code you need, you can find it <a href="http://www.unicode.org/charts/charindex.html">here</a> or <a href="http://theorem.ca/~mvcorks/code/charsets/auto.html">here</a>.';
  lngTxtFindCodes   := 'If you don''t know the code you need, you can find it using <a id="charmap.exe">Character Map</a> or in internet <a href="http://www.unicode.org/charts/charindex.html">here</a> and <a href="http://theorem.ca/~mvcorks/code/charsets/auto.html">there</a>.';
  lngTxtRestartApp  := 'To apply the settings for those applications where you are typing at the moment, you should restart them.';  {usually}
  lngTxtNewPrstName := 'Enter new preset name';
  lngTxtTopChar     := 'Alternative character';
  lngTxtBottomChar  := 'Main character';
  lngTxtNewPreset   := 'New Preset';
  //-----------------------------------------------------------
  lngErrMsgMapFile  := 'Error while creating map-file!';
  lngErrMsgDllFunc  := 'Can''t find the required DLL functions!';
  lngErrMsgNoDll    := 'DLL not found: %s!';
  //----------------------------------------------------
  lngLeftAlt        := 'Left Alt';
  lngRightGr        := 'Alt Gr'; //'Right Alt (AltGr)';
  lngLeftCtrl       := 'Left Ctrl';
  lngRightCtrl      := 'Right Ctrl';
  lngWin            := 'Win';
  lngLeftWin        := 'Left Win';
  lngRightWin       := 'Right Win';
  lngPopupMenu      := 'Menu Key'; // ?
  //----------------------------------------------------
  lngOptGeneral     := 'General';
  lngOptKeys        := 'Keyboard'; //'Keyboard && Symbols'; //'On-screen Keyboard';
  lngOptMisc        := 'Miscellaneous';
  lngOptGlbHotKeysGB:= 'Global hot keys';
  lngOptCtrlKeyGB   := 'Main control key';
  lngOptAddCtrlKeyGB:= 'Additional control key';
  lngOptHotKeyEnbl  := 'Enabling hot key';
  lngOptHotKeyLock  := 'Keyboard lock hot key';
  lngOptAppLang     := 'Application language';
  lngOptUseClrType  := 'Use ClearType® font smoothing';
  lngOptShowKbdShdw := 'Show on-screen keyboard shadow (please restart %s)';
  lngOptCharCode    := 'Character code';
  lngOptResetFonts  := 'Reset';
  lngOptResetFontsL := 'Reset on-screen keyboard fonts to default';
  lngOptBtnFont     := 'Set';
  lngOptLeftFont    := 'Font for common characters of keyboard';
  lngOptRightFont   := 'Font for characters added by %s';
  lngOptDiacritFont := 'Font for combining diacritical marks';
  lngOptShowPrstInf := 'Show preset info on the switching';
  lngOptDblClickMode:= 'Double click mode';
  lngAutoHintDelay  := 'Auto popup keyboard hint delay';
  //-----------------------------------------------------------
  lngOK             := 'OK';
  lngCancel         := 'Cancel';
  lngClearKey       := 'Clear';
  lngQuoteOpen      := '“';
  lngQuoteClose     := '”';
  //-----------------------------------------------------------
  lngKey            := 'Key';
  lngKeyScanCode    := 'Scan Code';
  lngKeyCopy        := 'Copy “%s”';
  lngKeyFuncPrefix  := 'F';
  lngKeyFuncHelp    := 'Hint';
  lngKeyEsc         := 'Esc';
  lngKeyTab         := 'Tab';
  lngKeyEnter       := 'Enter';
  lngKeyAlt         := 'Alt';
  lngKeyAltGr       := 'Alt Gr';
  lngKeyCtrl        := 'Ctrl';
  lngKeyWin         := 'Win';
  lngKeyMenu        := 'Menu';
  lngKeySpace       := 'Space';
  lngKeyBackspace   := 'Backspace';
  lngKeyCaps        := 'Caps Lock';
  lngKeyShift       := 'Shift';
  lngKeyBckspcArrow := '←'; //'Backspace';   //↓↑←
  lngKeyCapsArrow   := '↓'; //'Caps Lock';
  lngKeyShiftArrow  := '↑'; //'Shift';
  lngKeyNonbrSpace  := 'Non-breaking space';
  lngKeyAccent      := Char($0301);//'Accent';
  lngSetCharFont    := 'Set character font';
  lngResetCharFont  := 'Reset character font';
  //-----------------------------------------------------------
end;

end.
