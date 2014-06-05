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

  // ������� ������� Mutex �� �����
  MutexHandle := OpenMutex (MUTEX_ALL_ACCESS, false, MutexName);
  if MutexHandle <> 0 then
  begin
    // ����� ������ ���������� ��� �������� - Mutex ��� ����
    if DoCloseAll
      then SendMessage(HWND_BROADCAST, CM_TIE_ONEINST, 666, 1)  // WPARAM=666 => ����� ����������
      else SendMessage(HWND_BROADCAST, CM_TIE_ONEINST,   2, 1);
    sleep(1000);
    CloseHandle(MutexHandle);
    Halt;
  end
  else if DoCloseAll then Halt;
  // �������� Mutex
  MutexHandle := CreateMutex (nil, true, MutexName);
  // ������ ����������
  Application.Initialize;
  GetAllPathes;
  Application.MainFormOnTaskbar := false; // �� ���� ������ ���� TRUE, �� ��� ����� ����� ��������� ������� ��������� ������ ������� ����� � ��������
  Application.Title := 'Type it Easy Keyboard Manager';
  Application.CreateForm(TfrmKeyboard, frmKeyboard);
  Application.CreateForm(TfrmOptions, frmOptions);
  Application.CreateForm(TfrmAbout, frmAbout);
  Application.CreateForm(TfrmKeySettings, frmKeySettings);
  Application.CreateForm(TfrmNewPreset, frmNewPreset);
  Application.ShowMainForm := false;

  DoLang(CurrentLang);

  inc(StartCounter);
//  ������� ������ ������ ������ � ��������
//  SetWindowLong(Application.Handle, GWL_EXSTYLE, GetWindowLong(Application.Handle,GWL_EXSTYLE) or WS_EX_TOOLWINDOW);
//  ShowWindow(Application.Handle, SW_HIDE);
  isStartUp  := false;
  Application.Run;
  // ���������� ��� Mutex ��� ���������� ����������
  CloseHandle(MutexHandle);
end.
