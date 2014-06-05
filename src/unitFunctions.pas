unit unitFunctions;


interface

uses Windows, Forms, ShellAPI, ShlObj, SysUtils, unitConst, unitKeyboard, ExtCtrls, Menus,
     unitOptions, Messages, Classes, StrUtils, Graphics, IniFiles, JwaWinNT, WinErrorCodes;

// глобально-полезные функции  ↓
function  GetAppDataDir     (MySubDir: string; isLocal: boolean): string;
function  GetSys32Dir       : string;
function  GoOnline          (URL: string): boolean;
function  ExecuteFile       (FileName: string): boolean;
function  GetIntFromStr     (s: string): integer;
function  GetStrFromChr     (c: char): string;
function  GetNormalStringFromCaption (s: string): string;
function  GetHumanizedPresetName(PresetName: string):string;
function  CheckClassName    (hndl: HWND): boolean;
// глобально-полезные процедуры ↓
procedure SendCharToApp     (hndl: HWND; smbl: char);
procedure FindFiles         (Dir, Filter: string; FileList: TStringList);
procedure DoClearType       (Fontik: TFont; DoIt: boolean);
procedure DoClearTypeForAll (DoIt: boolean);
procedure LoadFontFromIni   (ResultFont: TFont; IniFile: TINIFile; IniKey, DefName: string; DefSize, DefColor: integer; DefBold, DefItalic: boolean);
procedure SaveFontToIni     (Fnt: TFont; IniFile: TINIFile; IniKey: string);
procedure RestoreStdPresets;
procedure FirstStart;
procedure GetAllPathes;
procedure BlockInput        (ABlockInput: boolean); stdcall; external 'USER32.DLL';
// free-lance.ru procedure ↓
procedure DoSendText        (const Text: string; simple: boolean);
// блокировка клавиши питания ↓
// в Дельфи нет определения нужных для управления питанием типов и структур,
// берём их из JwaWinNT.pas, но для _SYSTEM_POWER_POLICY пришлось поставить packed record, вместо просто record,  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// иначе CallNtPowerInformation вместо STATUS_SUCCESS выдаёт STATUS_INVALID_PARAMETER       !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
function CallNtPowerInformation(InformationLevel: POWER_INFORMATION_LEVEL; lpInputBuffer: Pointer; nInputBufferSize: ULONG; lpOutputBuffer: Pointer; nOutputBufferSize: ULONG): cardinal; stdcall; external 'PowrProf.dll';
procedure LockPowerKey;
procedure UnlockPowerKey;
// блокировка клавиши питания ↑


implementation

uses unitLang, unitKeySettings;

// Формируем все пути
procedure GetAllPathes;
begin
  AppPath       := ExtractFilePath (Application.Exename);
  AppDataPath   := GetAppDataDir (constProgramName, true);
  AppPresetPath := AppDataPath + PresetFolder;
  AppLocalsPath := AppPath + LocalsFolder;
  Sys32Path     := GetSys32Dir + '\';

  if not DirectoryExists (AppDataPath) then CreateDir (AppDataPath);
  if not DirectoryExists (AppPresetPath) then CreateDir (AppPresetPath);
end;

// Читаем/Сохраняем шрифт в инишник...
procedure LoadFontFromIni   (ResultFont: TFont; IniFile: TINIFile; IniKey, DefName: string; DefSize, DefColor: integer; DefBold, DefItalic: boolean);
begin
  with IniFile do
  begin
    ResultFont.Name  := ReadString  ('Fonts', IniKey + '.Name',  DefName);
    ResultFont.Size  := ReadInteger ('Fonts', IniKey + '.Size',  DefSize);
    ResultFont.Color := ReadInteger ('Fonts', IniKey + '.Color', DefColor);
    if ReadBool ('Fonts', IniKey + '.Bold', DefBold)
      then ResultFont.Style := ResultFont.Style + [fsBold];
    if ReadBool ('Fonts', IniKey + '.Italic', DefItalic)
      then ResultFont.Style := ResultFont.Style + [fsItalic];
    //fntLeftSide.Color := GetIntFromStr(ReadString  ('Fonts', 'ftnLeftSide.Color', IntToStr(constLeftFontColor)));
  end;
end;
// Читаем/Сохраняем шрифт в инишник.
procedure SaveFontToIni     (Fnt: TFont; IniFile: TINIFile; IniKey: string);
begin
  with IniFile do
  begin
    WriteString   ('Fonts', IniKey + '.Name',    Fnt.Name);
    WriteInteger  ('Fonts', IniKey + '.Size',    Fnt.Size);
    WriteInteger  ('Fonts', IniKey + '.Color',   Fnt.Color);
    WriteBool     ('Fonts', IniKey + '.Bold',    fsBold   in Fnt.Style);
    WriteBool     ('Fonts', IniKey + '.Italic',  fsItalic in Fnt.Style);
    //WriteString   ('Fonts', IniName + '.Color',   IntToHex(Fnt.Color, 6));
  end;
end;

// Обклиртайпливаем или разклиртайпливаем фонты...
procedure DoClearType (Fontik: TFont; DoIt: boolean);
var
  Fnt: TLogFont;
const
  ANTIALIASED_QUALITY = 4;
  CLEARTYPE_QUALITY = 5;
begin
  GetObject(Fontik.Handle, SizeOf(TLogFont), @Fnt);
  if DoIt
    then Fnt.lfQuality := CLEARTYPE_QUALITY
    else Fnt.lfQuality := ANTIALIASED_QUALITY;
  Fontik.Handle := CreateFontIndirect(Fnt);
end;
// Обклиртайпливаем или разклиртайпливаем фонты.
procedure DoClearTypeForAll (DoIt: boolean);
begin
  DoClearType (fntLeftSide,  DoIt);
  DoClearType (fntRightSide, DoIt);
  DoClearType (fntDiacrit,   DoIt);
end;

// убираем хуевы амперсанды из кэпшенов
function GetNormalStringFromCaption (s: string): string;
begin
  if Pos('&&',s) <> 0
    then s := ReplaceStr(s, '&&','~@#dvaampersanda$~');
  s := ReplaceStr(s, '&','');
  result := ReplaceStr(s, '~@#dvaampersanda$~','&');
end;

// Возвращаем нормальное название пресета на текущем языке
function GetHumanizedPresetName(PresetName: string): string;
begin
  result := PresetName;
  if CurrentPreset = KbdFileNameUser  then result := lngPresetUser;
  if CurrentPreset = KbdDefault       then result := lngPresetDefault;
end;

// находим директорию данных приложения текущего пользователя
function GetAppDataDir (MySubDir: string; isLocal: boolean): string;
var
  ItemList: PItemIDList;
  FullPath: array[0..MAX_PATH] of Char;
begin
  if isLocal
     then SHGetSpecialFolderLocation (0, CSIDL_APPDATA, ItemList)
     else SHGetSpecialFolderLocation (0, CSIDL_COMMON_APPDATA, ItemList);
  SHGetPathFromIDList (ItemList, FullPath);
  Result := string (FullPath);
  if Result = ''
     then Result := AppPath
     else Result := Result + '\' + MySubDir + '\';
end;

// находим директорию System32
function GetSys32Dir: string;
var
  dir: array [0..MAX_PATH] of Char;
begin
  GetSystemDirectory(dir, MAX_PATH);
  Result := StrPas(dir);
end;

// открыть ссылку в сети
function GoOnline (URL:string): boolean;
begin
  if pos('http://', URL) <> 0
    then ShellExecute(frmKeyboard.Handle, 'Open', PChar('"'+URL+'"'), nil, nil, SW_SHOWNORMAL)
    else ShellExecute(frmKeyboard.Handle, 'Open', PChar('"http://'+URL+'"'), nil, nil, SW_SHOWNORMAL);
  Result := true;
end;

// запуск на исполнение
function ExecuteFile (FileName: string): boolean;
begin
  if Pos(CharMapFileName, FileName) <> 0 then
    ShellExecute(frmKeyboard.Handle, 'Open', PChar('"'+ Sys32Path + CharMapFileName +'"'), nil, nil, SW_SHOWNORMAL)
  else
    ShellExecute(frmKeyboard.Handle, 'Open', PChar('"'+ FileName +'"'), nil, nil, SW_SHOWNORMAL);
  Result := true;
end;

// попытаться получить инт из строки (имеется в виду получить код символа http://oper.ru/и текста)
function GetIntFromStr (s: string): integer;
begin
  TryStrToInt(s,Result);
end;

// получаем строку из чара
function GetStrFromChr (c: char): string;
begin
  if c <> #0
    then result := c
    else result := '';
end;

// проверяем класс окна на предмет нетрадиционных, вроде Мозиллы
function CheckClassName(hndl: HWND): boolean;
var   ClassName: array[0..255] of Char;
begin
  GetClassName(hndl, ClassName, SizeOf(ClassName));
  if Pos('MozillaWindowClass', ClassName) = 0
    then Result := true
    else Result := false;
end;


// посылаем символ в приложение


// ****************** вариант фрилансера с free-lance.ru
// simple = true, значит просто посылаем sendinput
// simple = false, значит посылаем sendinput и контролируем нажатие системных клавиш
procedure DoSendText(const Text: string; simple: boolean);
type
  //  Эта запись преследует собой одну цель - затолкать всю информацию о клавишах в 4 байта, чтобы
  //  всю информацию можно было заюзать в TList без лишних извратов. А хранить клавиши в TList, на
  //  мой взгляд, гораздо удобнее при тех извратах, что пойдут дальше
  PKey = ^TKey;
  TKey = packed record
    Code : Word;
    Flags: Word;
   end;


  //  Все просто - процедурка добавляет клавишу в список. По умолчанию - в конец списка, но можно
  //  указать и любой другой индекс вставки
  procedure AddKey(List: TList; Code, Flags: Word; Index: Integer = -1);
   var
    Key: TKey;
   begin
    Key.Code:=Code;
    Key.Flags:=Flags;
    if Index=-1
     then   List.Add(Pointer(Key))
     else   List.Insert(Index, Pointer(Key))
   end;


  //  Процедура преобразует клавиши из списка List в массив, пригодный для SendInput. Ну и, собственно,
  //  вызывает эту самую SendInput
  procedure SendListKeys(List: TList);
   var
    Inputs: array of TInput;
    Step  : Integer;
   begin
    SetLength(Inputs, List.Count);
    for Step:=0 to List.Count-1
     do   begin
           Inputs[Step].Itype:=INPUT_KEYBOARD;   //  стандартно
           Inputs[Step].ki.time:=123;            //  х.з. почему тут это число, сам в шоке. но работает. будем считать за магию
           Inputs[Step].ki.dwExtraInfo:=0;       //  стандартно
           with TKey(List[Step])                 //  дальше показано как из 4 байт записи TKey можно
            do   begin                           //  получить массу полезной пинформации
                  if (Flags and KEYEVENTF_UNICODE)<>0
                   then   begin
                           Inputs[Step].ki.wVk:=0;
                           Inputs[Step].ki.wScan:=Code
                          end
                   else   begin
                           Inputs[Step].ki.wVk:=Code;
                           Inputs[Step].ki.wScan:=0
                          end;
                  Inputs[Step].ki.dwFlags:=Flags
                 end
          end;
    SendInput(List.Count, Inputs[0], SizeOf(TInput))  //  то, ради чего все затевалось
   end;


var
  Step  : Integer;
  Keys  ,           //  список, который призван эмулировать нажатие требуемого текста
  Start ,           //  список, который призван эмулировать отжатие функц. клавиш перед вставкой текста
  Finish: TList;    //  список, который призван эмулировать обратное нажатие функц. клавиш после вставки текста
begin
  Keys:=TList.Create;
  Start:=TList.Create;
  Finish:=TList.Create;
  try
    //----------------------------------------------------------------------------------------------
    //  Первый этап - простое копирование текста в основной список клавиш
    //----------------------------------------------------------------------------------------------
    for Step:=1 to Length(Text)
     do   begin
           AddKey(Keys, Word(Text[Step]), KEYEVENTF_UNICODE);
           AddKey(Keys, Word(Text[Step]), KEYEVENTF_UNICODE or KEYEVENTF_KEYUP);
          end;


    // *** моё ***
    // перед вводом символа нужно сэмулировать сначала отжатие контрольной клавиши, а потом её нажатие
    AddKey(Start,  ControlKey, KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP);
    AddKey(Finish, ControlKey, KEYEVENTF_EXTENDEDKEY);
    // /*** моё ***


    //----------------------------------------------------------------------------------------------
    //  Заключительный этап - вызываем SendInput
    //----------------------------------------------------------------------------------------------
    isMyKeyDownUp := true;

    if not simple then begin
      SendListKeys(Start);  //  Пытался экспериментировать с таймаутами мужду эмуляцей _отжатия_ функц. клавиш
      //Sleep(50);
      SendListKeys(Keys);   //  эмуляцией нажатия/отжатия основных клавиш
      //Sleep(50);
      SendListKeys(Finish); //  и эмуляцией _нажатия_ функц. клавиш.
                            //  Итог один - без таймаутов все работает лучше :-)
                            //  А вот единственный вызов SendListKeys (а не тройной, как сейчас) - наоборот, хуже
    end
    else begin
      SendListKeys(Keys);
    end;

    isMyKeyDownUp := false;

   finally
    FreeAndNil(Keys);
    FreeAndNil(Start);
    FreeAndNil(Finish)
   end

end;
// ****************** конец варианта фрилансера

// мой вариант
procedure SendCharToApp (hndl: HWND; smbl: char);
const KEYEVENTF_UNICODE = $0004;
begin

 // работающий кусок до версии 2.0.5
  if CheckClassName  (hndl) // IsWindowUnicode надобы это тоже проверять
    then PostMessage (hndl, WM_CHAR, Word(smbl), 1)
    else PostMessage (hndl, WM_IME_CHAR, Word(smbl), 1);
 // конец работающего куска

end;

// поиск файлов по шаблону
procedure FindFiles (Dir, Filter: string; FileList: TStringList);
var str:string;
    w32Data:WIN32_FIND_DATA;
    FindHandle:THandle;
begin
 str:=Dir+Filter;
 FindHandle:=Windows.FindFirstFile(PChar(str),w32Data);
 if FindHandle<>INVALID_HANDLE_VALUE then
  begin
   FileList.Append({Dir+}w32Data.cFileName);
   while Windows.FindNextFile(FindHandle,w32data) do
    FileList.Append({Dir+}w32Data.cFileName);
   Windows.FindClose(FindHandle);
   //FileList.SaveToFile('d:\files.txt');
  end;
end;

// восстановление стандартных пресетов
procedure RestoreStdPresets;
var i: integer;
    slPresetFiles : TStringList;
begin
  slPresetFiles := TStringList.Create;
  FindFiles(AppPath + PresetFolder, '*' + PresetFilesExt, slPresetFiles);
  for i := 0 to slPresetFiles.Count - 1 do
  begin
    CopyFile(PWideChar(AppPath + PresetFolder + slPresetFiles[i]), PWideChar(AppPresetPath + slPresetFiles[i]), false {overwrite!});
  end;
  slPresetFiles.Free;
end;

// первый запуск
procedure FirstStart;
begin
  // создаем файл с настройками
  Settings_Save;
  // копируем стандартные файлы пресетов в папку с настройками
  RestoreStdPresets;
end;

// блокировка клавиши питания ↓
procedure LockPowerKey;
begin
  ZeroMemory(@PowerKeyInfoBufAC,     sizeof(SYSTEM_POWER_POLICY));
  ZeroMemory(@PowerKeyInfoBufDC,     sizeof(SYSTEM_POWER_POLICY));
  ZeroMemory(@PowerKeyInfoBufLocked, sizeof(SYSTEM_POWER_POLICY));

  CallNtPowerInformation(SystemPowerPolicyAc,      nil, 0, @PowerKeyInfoBufAC,     sizeof(PowerKeyInfoBufAC));
  CallNtPowerInformation(SystemPowerPolicyDc,      nil, 0, @PowerKeyInfoBufDC,     sizeof(PowerKeyInfoBufDC));
  CallNtPowerInformation(SystemPowerPolicyCurrent, nil, 0, @PowerKeyInfoBufLocked, sizeof(PowerKeyInfoBufLocked));

  PowerKeyInfoBufLocked.PowerButton.Action    := PowerActionNone;
  PowerKeyInfoBufLocked.PowerButton.EventCode := POWER_FORCE_TRIGGER_RESET;

  CallNtPowerInformation(SystemPowerPolicyAc, @PowerKeyInfoBufLocked, sizeof(PowerKeyInfoBufLocked), nil, 0);
  CallNtPowerInformation(SystemPowerPolicyDc, @PowerKeyInfoBufLocked, sizeof(PowerKeyInfoBufLocked), nil, 0);
end;

procedure UnlockPowerKey;
begin
  CallNtPowerInformation(SystemPowerPolicyAc, @PowerKeyInfoBufAC, sizeof(PowerKeyInfoBufAC), nil, 0);
  CallNtPowerInformation(SystemPowerPolicyDc, @PowerKeyInfoBufDC, sizeof(PowerKeyInfoBufDC), nil, 0);
end;
// блокировка клавиши питания ↑

end.
