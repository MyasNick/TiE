program TiE;

uses
  Forms,
  Windows,
  unitConst in 'unitConst.pas',
  unitAbout in 'unitAbout.pas' {frmAbout},
  unitKeyboard in 'unitKeyboard.pas' {frmKeyboard},
  unitOptions in 'unitOptions.pas' {frmOptions},
  unitKeySettings in 'unitKeySettings.pas' {frmKeySettings},
  unitFunctions in 'unitFunctions.pas',
  unitNewPreset in 'unitNewPreset.pas' {frmNewPreset},
  unitRU_RU in 'unitRU_RU.pas',
  unitEN_US in 'unitEN_US.pas',
  unitLang in 'unitLang.pas',
  unitHook in 'unitHook.pas',
  jwawinnt in 'jedi.inc.prj\jwawinnt.pas',
  jwawintype in 'jedi.inc.prj\jwawintype.pas',
  unitMakeMenuFromIni in 'unitMakeMenuFromIni.pas';

{$R *.res}
{$R images.res images.rc}

var
  MutexHandle: THandle;
  DoCloseAll: boolean;

const
  MutexName     = 'tie2_mutex';

begin
  isStartUp  := true;
  DoCloseAll := pos('closeall', CmdLine) <> 0;
  CM_TIE_ONEINST  := RegisterWindowMessage ('CM_TIE_ONEINST');
  CM_TIE_INFO     := RegisterWindowMessage ('CM_TIE_INFO');

  // Пробуем открыть Mutex по имени
  MutexHandle := OpenMutex (MUTEX_ALL_ACCESS, false, MutexName);
  if MutexHandle <> 0 then
  begin
    // Копия нашего приложения уже запущена - Mutex уже есть
    if DoCloseAll
      then SendMessage(HWND_BROADCAST, CM_TIE_ONEINST, 666, 1)  // WPARAM=666 => убить приложение
      else SendMessage(HWND_BROADCAST, CM_TIE_ONEINST,   2, 1);
    sleep(1000);
    CloseHandle(MutexHandle);
    Halt;
  end
  else if DoCloseAll then Halt;
  // Создание Mutex
  MutexHandle := CreateMutex (nil, true, MutexName);
  // Запуск приложения
  Application.Initialize;
  GetAllPathes;
  Application.MainFormOnTaskbar := false; // по идее должно быть TRUE, но для этого нужно научиться ручками прибивать кнопку главной формы в таскбаре
  Application.Title := 'Type it Easy Keyboard Manager';
  Application.CreateForm(TfrmKeyboard, frmKeyboard);
  Application.CreateForm(TfrmOptions, frmOptions);
  Application.CreateForm(TfrmAbout, frmAbout);
  Application.CreateForm(TfrmKeySettings, frmKeySettings);
  Application.CreateForm(TfrmNewPreset, frmNewPreset);
  Application.ShowMainForm := false;

  DoLang(CurrentLang);

  inc(StartCounter);
//  Попытки совсем убрать кнопку с таскбара
//  SetWindowLong(Application.Handle, GWL_EXSTYLE, GetWindowLong(Application.Handle,GWL_EXSTYLE) or WS_EX_TOOLWINDOW);
//  ShowWindow(Application.Handle, SW_HIDE);
  isStartUp  := false;
  Application.Run;
  // Уничтожаем наш Mutex при завершении приложения
  CloseHandle(MutexHandle);
end.
