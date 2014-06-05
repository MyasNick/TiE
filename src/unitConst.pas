unit unitConst;

{$J+}    // нужно для правильное работы типизированных констант. если без этого, то им нифига нельзя присвоить новое значение

interface

uses Windows, Graphics, Messages;

const
  //Виндовсные извращения
  KEYEVENTF_UNICODE   = $0004;
  //-----------------------------------------------------------
  SystemKeys    = [0{0},1{esc},14{backspace},15{tab},58{caps},42{lshift},54{rshift},29{ctrl},91{win},56{alt},93{menu}];
  ControlKeys   = [29{ctrl},91{win},56{alt},93{menu}];
  Perdyshki     = [$00..$6F]; //constPerdPrefix / $0300 + ...
  RusCompatible = '$0423{Belorus},$0422{Ukraina},$043f{Kazak},$046d{Bashkir},$0440{Kyrgiz},$0843,$0443{both Uzbek},$0442{Turkmen},$0428{Tajik},$0444{Tatar},$0485{Yakut}';
  //ArrowKeys  = [75{←},72{↑},77{→},80{↓}];
  //-----------------------------------------------------------
  constProgramName    = 'Type it Easy';
  constProgramVersion = '2.2';
  constProgramFullVer = '2.2.6 βeta';
  //-----------------------------------------------------------
  lngProgramDate:     string = 'January 7, 2011';
  lngProgramSite:     string = 'http://type-it-easy.com';
  lngProgramUpdate:   string = 'type-it-easy.com/update/';
  lngProgramDonate:   string = 'type-it-easy.com/donate/';
  lngCopyright:       string = '© Nikolaj Masnikov, 2008-2011';
  lngMasnikovSite:    string = 'masnikov.com';
  lngBranding:        string = 'Made in Germany, assembled in Berlin';
  lngVersion:         string = 'Version';
  //-----------------------------------------------------------
//  HookDllName         = 'TiExyk.dll';
  WzrdDllName         = 'TiEsuw.dll';
  SetsFileName        = 'TiE.ini';
  CharsFileName       = 'TiE.additional.chars.ini';
    CharsTables       = 'Tables';
    UnicodePrefix     = 'U+';
//    CombineDiacrits   = 'Combining Diacritical Marks';
    CombineDiacrits   = 'Combining';
  CharMapFileName     = 'charmap.exe';
  KbdFileNameUser     = 'user';
  KbdDefault          = 'default';
  KbdDefPresetFN:     string = '';
  PresetFilesExt      = '.kbd';
  PresetFolder        = 'Presets\';
  LocalsFolder        = 'Locales\';
  VK_POPUPMENU        = 249;
  constControlKey     = VK_RMENU;
  constAdditionalKey  = VK_RCONTROL; //VK_POPUPMENU;
  constKbdHintKey     = VK_F1;
  constKbdHintKeyStr  = 'F1';
  constKbdBlockKey    = VK_F12;
  constKbdBlockKeyStr = 'F12';
  constExtendedKey    = true;
  constActivated      = true;
  constUseLearnMode   = true;
  constIsUseClearType = true;
  constEnableHotKey   = ord('Z');
  constNBSP           = $00A0;
//  constEnableHotKey   = ord('X');
  //constBlockKbdHotKey = ord('K');
  constStartCounter   = 0;
  MIN_ALPHA_VALUE     = 100;
  kbdAlphaSteps       = 10;
  kbdSlipTime         = 5;
  kbdFadingTick       = 5;  // как часто должен срабатывать таймер фэдинга клавы
//  kbdFadingTime       = 100; // за сколько клава должна проявиться
  kbdDelay:           integer = 1000;
  constLongSpace      = #9;  //  constLongSpace      = '     ';
  constTriTochki      = '...';
  constDveTochki      = ':';
  constPerdPrefix     = $0300;
  constKbdDropShadow  = false;
  //-----------------------------------------------------------
  constLangEN_US      = $0409;  //constLangEN_US    = 1033;
  constLangEN_US_str  = 'en_US';
  constLangEN_US_name = 'English (US)';
  constLangRU_RU      = $0419;  //constLangRU_RU    = 1049;
  constLangRU_RU_str  = 'ru_RU';
  constLangRU_RU_name = 'Русский';
  constLangFileExt    = '.lng';
  //-----------------------------------------------------------
  CS_DROPSHADOW             = $00020000;
  constMaxRealKeys          = 73;        // количество кнопок на клаве
  constMaxLogicKeys         = 256;       // количество сканкодов
  constKeyFontColorDisabled = $F1C199;   // RGB(153,193,241);
  constKeyFontColorNormal   = $E39151;   // RGB(153,193,241);
  constKeyFontCustomChar    = $965000;   // $A67236;   //RGB( 54,114,166);
  constKeyFontNameCalibri   = 'Calibri';
  constKeyFontNameTahoma    = 'Tahoma';
  constKeyFontNameArial     = 'Arial';
  constKeyFontNameArialUMS  = 'Arial Unicode MS';
  constKeyFontNameTimesNR   = 'Times New Roman';
  constKeyFontNameVerdana   = 'Verdana';
  constKeyFontNameLucidaSU  = 'Lucida Sans Unicode';  // <<<
  constKeyFontSizeSmallest  = 7;
  constKeyFontSizeSmall     = 9;
  constKeyFontSizeNormal    = 10;
  constKeyFontSizeLarge     = 15;
  constKeyFontSizeLargest   = 20;

  constLeftFontName:    string  = 'Lucida Sans Unicode';
  constLeftFontSize:    integer = 8;
  constLeftFontColor:   integer = $E39151;   // RGB(153,193,241);
  constLeftFontBold:    boolean = false;
  constLeftFontItalic:  boolean = false;

  constRightFontName:   string  = 'Lucida Sans Unicode';
  constRightFontSize:   integer = 10;
  constRightFontColor:  integer = $965000;  //clNavy;  // $A67236;   //RGB(54,114,166);
  constRightFontBold:   boolean = false;
  constRightFontItalic: boolean = false;

  constDiacritFontName:   string  = 'Lucida Sans Unicode';
  constDiacritFontSize:   integer = 12;
  constDiacritFontColor:  integer = clMaroon;  //$ec008c;   //RGB(236,0,140);
  constDiacritFontBold:   boolean = false;
  constDiacritFontItalic: boolean = false;

  //-----------------------------------------------------------
  constKeyMrgTop:   integer = 1;
  constKeyMrgLeft:  integer = 3;
  constKeyMrgBottom:integer = 1;
  constKeyMrgRight: integer = 3;
  constKeyFontSize: integer = constKeyFontSizeNormal;
  constKeyFontName: string  = constKeyFontNameLucidaSU;
  //-----------------------------------------------------------

implementation

end.
