unit unitRU_RU;

interface

procedure DoRU_RU;

implementation

uses unitConst, unitKeyboard, unitLang;

procedure DoRU_RU;
begin
  CurrentLangName   := constLangRU_RU_str;
  KbdDefPresetFN    := '';
  //----------------------------------------------------
  lngProgramDate    := '7 января 2011 г.';
  lngProgramSite    := 'http://myasnick.com/soft/typeiteasy';
  lngProgramUpdate  := 'myasnick.com/category/tie/';
  lngProgramDonate  := 'myasnick.com/soft/typeiteasy/#donate';
  lngCopyright      := '© Николай Мясников, 2008-2011';
  lngMasnikovSite   := 'myasnick.com';
  lngBranding       := 'Made in Germany. Assembled in Berlin';
  lngVersion        := 'версия';
  //----------------------------------------------------
//  lngFrmKbdCaption  := 'Текущий пресет клавиатуры: «%s»';
  lngFrmKbdCaption  := '%s';
  lngEnable         := 'Активировать';
  lngShowKbd        := 'Показать клавиатуру';
  lngLearnMode      := 'Автоподсказка';
  lngBlockKbd       := 'Блокировка клавиатуры';  //'Заблокировать клавиатуру';
  lngSettings       := 'Параметры';
  lngSettingsTiE    := 'Параметры %s';
  lngSetsKbdPage    := 'Параметры клавиатуры';
  lngHelp           := 'Справка';
  lngHelpTopics     := 'Справочная система';
  lngAbout          := 'О программе';
  lngHomePage       := 'Сайт %s';
  lngFindUpdate     := 'Проверить обновления';
  lngDonate         := 'Поддержать разработку';
  lngFrstStrtWzrd   := 'Мастер первоначальной настройки';
  lngExit           := 'Выход';
  lngShowKeySets    := 'Настроить клавишу';
  lngKbdClose       := 'Спрятать клавиатуру';
  lngKbdPresets     := 'Пресеты';
  lngPresetUser     := 'Пользовательский';
  lngPresetDefault  := 'По умолчанию';
  lngPresetSaveNew  := 'Сохранить как';
  lngPresetOpenFldr := 'Открыть папку пресетов';
  lngPresetDelete   := 'Удалить текущий';
  lngPresetCreate   := 'Создать новый';
  lngSetKeys        := 'Настроить клавиши';
  lngRestoreStdPresets := 'Восстановить стандартные пресеты';
  //----------------------------------------------------
  lngOptGeneral     := 'Общие';
  lngOptKeys        := 'Клавиатура'; //'Клавиатура и символы'; //'Экранная клавиатура';
  lngOptMisc        := 'Разное';
  lngOptGlbHotKeysGB:= 'Глобальные горячие клавиши';
  lngOptCtrlKeyGB   := 'Управляющая клавиша';
  lngOptAddCtrlKeyGB:= 'Дополнительная клавиша';
  lngOptHotKeyEnbl  := 'Активация программы';
  lngOptHotKeyLock  := 'Блокировка клавиатуры';
  lngOptUseClrType  := 'Использовать сглаживание шрифтов ClearType®';
  lngOptShowKbdShdw := 'Отбросить тень от экранной клавиатуры (перезапустите %s)';
  lngOptAppLang     := 'Язык программы';
  lngOptCharCode    := 'Код символа';
  lngOptResetFonts  := 'Сброс';
  lngOptResetFontsL := 'Установить стандартные шрифты для экр. клавиатуры';
  lngOptBtnFont     := 'Выбрать';
  lngOptLeftFont    := 'Шрифт стандартных символов клавиатуры';
  lngOptRightFont   := 'Шрифт символов, добавленных %s';
  lngOptDiacritFont := 'Шрифт комбинируемых диактрических знаков';
  lngOptShowPrstInf := 'Показывать информацию о пресете при его включении';
  lngOptDblClickMode:= 'Режим двойного щелчка мышью';
  lngAutoHintDelay  := 'Задержка автоподсказки';
  //----------------------------------------------------
  lngOK             := 'OK';
  lngCancel         := 'Отмена';
  lngClearKey       := 'Очистить';
  lngQuoteOpen      := '«';
  lngQuoteClose     := '»';
  //-----------------------------------------------------------
  lngKey            := 'Клавиша';
  lngKeyScanCode    := 'Скан-код';
  lngKeyCopy        := 'Копировать «%s»';
  lngKeyFuncPrefix  := 'F';
  lngKeyFuncHelp    := 'Хинт';
  lngKeyEsc         := 'Esc';
  lngKeyTab         := 'Tab';
  lngKeyEnter       := 'Enter';
  lngKeyAlt         := 'Alt';
  lngKeyAltGr       := 'Alt Gr';
  lngKeyCtrl        := 'Ctrl';
  lngKeyWin         := 'Win';
  lngKeyMenu        := 'Menu';
  lngKeySpace       := 'Пробел';
  lngKeyBackspace   := 'Backspace';
  lngKeyCaps        := 'Caps Lock';
  lngKeyShift       := 'Shift';
  lngKeyBckspcArrow := '←'; //'Backspace';   //↓↑←
  lngKeyCapsArrow   := '↓'; //'Caps Lock';
  lngKeyShiftArrow  := '↑'; //'Shift';
  lngKeyNonbrSpace  := 'Неразрывный пробел';
  lngKeyAccent      := 'Ударе́ние';
  lngSetCharFont    := 'Установить шрифт символа';
  lngResetCharFont  := 'Сбросить шрифт символа';
  //-----------------------------------------------------------
  lngLeftAlt        := 'Левый Alt';
  lngRightGr        := 'Alt Gr'; //'Правый Alt (Alt Gr)';
  lngLeftCtrl       := 'Левый Ctrl';
  lngRightCtrl      := 'Правый Ctrl';
  lngWin            := 'Win';
  lngLeftWin        := 'Левый Win';
  lngRightWin       := 'Правый Win';
  lngPopupMenu      := 'Клавиша Menu'; // ?
  //----------------------------------------------------
  lngErrMsgMapFile  := 'Произошла ошибка при создании map-файла!';
  lngErrMsgDllFunc  := 'Не могу найти необходимую функцию в DLL!';
  lngErrMsgNoDll    := 'Библиотека не найдена: %s!';
  //----------------------------------------------------
  lngTxtEnterCodes  := 'Чтобы определить символы для данной клавиши, укажите их шестнадцатеричные коды без дополнительных символов. Например, шестнадцатеричный код для знака евро (€) — 20AC.';
  lngTxtFindCodes   := 'Если вы не знаете нужные вам коды, вы можете найти их в <a id="charmap.exe">Таблице символов</a> или в интернете <a href="http://www.unicode.org/charts/charindex.html">здесь</a> и вот <a href="http://theorem.ca/~mvcorks/code/charsets/auto.html">здесь</a>.';
  lngTxtRestartApp  := 'Чтобы изменения вступили в силу, перезапустите приложения, в которых вы печатаете в настоящий момент.';
  lngTxtNewPrstName := 'Укажите название нового пресета';
  lngTxtTopChar     := 'Альтернативный символ';
  lngTxtBottomChar  := 'Основной символ';
  lngTxtNewPreset   := 'Новый пресет';
  //-----------------------------------------------------------
  lngMsgAchtung     := 'Внимание!';
  lngMsgOneInst     := 'Программа уже запущена.';
  lngMsgActivated   := 'Программа включена.';
  lngMsgDeactivated := 'Программа отключена.';
  lngMsgFirstStart  := 'Вы запустили программу первый раз. ' +
                       'Чтобы получить доступ к её функциям и параметрам, щёлкните правой кнопкой мыши на значке программы под данным сообщением.';
  lngMsgKbdLocked   := 'Клавиатура заблокирована.%sЧтобы разблокировать её, снимите отметку с пункта меню «' + lngBlockKbd + '»';
  lngMsgKbdUnLocked := 'Клавиатура разблокирована.';
  lngMsgDelPreset   := 'Вы действительно хотите удалить пресет «%s»?';
  lngMsgOverWPreset := 'Пресет «%s» уже существует.%sХотите заменить его?';
  lngMsgAnotherName := 'Слово «%s» зарезервировано.%sПожалуйста, выберите другое название.';
  lngMsgPresetLoaded:= 'Текущий пресет:';
  lngMsgResetFons   := 'Вы действительно хотите сбросить шрифты экранной клавиатуры?';
  lngMsgLoadDefPrst := 'Хотите установить пресет по умолчанию для русской клавиатуры?';
  lngMsgToSetKey    := 'Щёлкните правой кнопкой мыши на нужной клавише и выберите «%s»';
  lngMsgAttentionWin:= 'Клавиша Win слишком «особенная».'+ #13#10 + 'Невозможно гарантировать её полную работоспособность.' + #13#10;
  lngAttentionAltGr := '';
  lngMsgStdPresetsRestored := 'Стандартные пресеты были восстановлены.';
  //-----------------------------------------------------------
end;

end.
