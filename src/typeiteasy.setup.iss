[Setup]
AppName=Type it Easy
AppVerName=Type it Easy 2.2.6 beta
AppPublisher=Nikolaj Masnikov
AppPublisherURL=http://type-it-easy.com
AppSupportURL=http://type-it-easy.com/feedback/
AppUpdatesURL=http://type-it-easy.com/news/
DefaultDirName={pf}\Type it Easy
DefaultGroupName=Type it Easy
AllowNoIcons=true
LicenseFile=Locales\License.en_US.txt
OutputBaseFilename=typeiteasy.setup
Compression=lzma2/Ultra64
SolidCompression=true
DisableStartupPrompt=true
ShowLanguageDialog=yes
WizardImageFile=D:\Nick\Work\Type it Easy\media.prj\install\WizModernImage-IS.bmp
WizardSmallImageFile=D:\Nick\Work\Type it Easy\media.prj\install\typeasy-my-55.bmp
WizardImageStretch=true
AllowRootDirectory=false
AppCopyright=© Nikolaj Masnikov, 2008-2011
InternalCompressLevel=Ultra64
OutputDir=D:\Nick\Work\Type it Easy
;PrivilegesRequired=admin
SetupIconFile=D:\Nick\Work\Type it Easy\media.prj\install\install-new.ico
VersionInfoCompany=Nikolaj Masnikov
VersionInfoCopyright=© Nikolaj Masnikov, 2008-2011
ShowUndisplayableLanguages=true
VersionInfoProductName=Type it Easy
VersionInfoProductVersion=2

[CustomMessages]
en.CreateStartUpIcon=Run on Windows startup
en.UninstallIcon=Uninstall
ru.CreateStartUpIcon=Запускать вместе с Windows
ru.UninstallIcon=Удалить
;de.CreateStartUpIcon=Mit Windows starten
;de.UninstallIcon=Entfernen


[Languages]
Name: en; MessagesFile: compiler:Default.isl
Name: ru; MessagesFile: compiler:Languages\Russian.isl; LicenseFile: Locales\License.ru_RU.txt
;Name: de; MessagesFile: compiler:Languages\German.isl

[Tasks]
Name: startupicon; Description: {cm:CreateStartUpIcon}
Name: desktopicon; Description: {cm:CreateDesktopIcon}; GroupDescription: {cm:AdditionalIcons}; Flags: unchecked
;Name: quicklaunchicon; Description: {cm:CreateQuickLaunchIcon}; GroupDescription: {cm:AdditionalIcons}; Flags: unchecked

[Files]
Source: TiE.exe; DestDir: {app}; Flags: ignoreversion restartreplace
;Source: TiExyk.dll; DestDir: {app}; Flags: ignoreversion restartreplace
;Source: TiEsuw.dll; DestDir: {app}; Flags: ignoreversion restartreplace
Source: file_id.diz; DestDir: {app}; Flags: ignoreversion restartreplace
Source: readme.txt; DestDir: {app}; Flags: ignoreversion restartreplace
Source: license.txt; DestDir: {app}; Flags: ignoreversion restartreplace
Source: Presets\*.kbd; DestDir: {app}\Presets; Flags: ignoreversion restartreplace
Source: Locales\*.lng; DestDir: {app}\Locales; Flags: ignoreversion restartreplace
Source: Locales\*.chm; DestDir: {app}\Locales; Flags: ignoreversion restartreplace
Source: Locales\*.txt; DestDir: {app}\Locales; Flags: ignoreversion restartreplace
; NOTE: Don't use "Flags: ignoreversion" on any shared system files
; isreadme

[Icons]
Name: {group}\Type it Easy; Filename: {app}\TiE.exe
;Name: {group}\{cm:UninstallProgram,Type it Easy}; Filename: {uninstallexe}
Name: {group}\{cm:UninstallIcon} Type it Easy; Filename: {uninstallexe}
;IconFilename: D:\Nick\Work\Typeasy\media.prj\install\uninstall.ico
Name: {commondesktop}\Type it Easy; Filename: {app}\TiE.exe; Tasks: desktopicon
;Name: {userappdata}\Microsoft\Internet Explorer\Quick Launch\Type it Easy; Filename: {app}\TiE.exe; Tasks: quicklaunchicon
Name: {userstartup}\Type it Easy; Filename: {app}\TiE.exe; WorkingDir: {app}; IconFilename: {app}\TiE.exe; IconIndex: 0; Tasks: startupicon

[Run]
Filename: {app}\TiE.exe; Description: {cm:LaunchProgram,Type it Easy}; Flags: nowait postinstall skipifsilent runasoriginaluser

[Registry]
Root: HKLM; Subkey: Software\Masnikov; Flags: uninsdeletekeyifempty
Root: HKLM; Subkey: Software\Masnikov\Type it Easy\2.0; Flags: uninsdeletekey
Root: HKLM; Subkey: Software\Masnikov\Type it Easy\2.0; Flags: uninsdeletekey; ValueType: string; ValueName: Path; ValueData: {app}


[UninstallDelete]
;по идее спрашивать: хошь, мол, настройки свои оставить?
;Name: {userappdata}\Type it Easy; Type: filesandordirs


[Code]
function NextButtonClick(CurPageID: Integer): Boolean;
var
	ResultCode: Integer;
	ResultStr: String;
begin
	case CurPageID of
			wpReady:
				begin
					RegQueryStringValue(HKLM, 'Software\MyasNick\Type it Easy', 'Path', ResultStr);
					if ResultStr <> '' then
						if FileExists(ResultStr+'\typeasy.exe') then
							Exec (ResultStr+'\typeasy.exe', '/closeall', '', SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode);
					ResultStr := '';
					RegQueryStringValue(HKLM, 'Software\Masnikov\Type it Easy', 'Path', ResultStr);
					if ResultStr <> '' then
						if FileExists(ResultStr+'\typeasy.exe') then
							Exec (ResultStr+'\typeasy.exe', '/closeall', '', SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode);
					// --- удаляю следы старого инсталлятора
					// »»» ВМЕСТО ЭТОГО, ДЕЛАТЬ ЗАПРОС НА ДЕИНСТАЛЛЯЦИЮ! «««
					//DeleteFile (ExpandConstant('{commonstartup}\Type it Easy.lnk'));
					//RegDeleteKeyIncludingSubkeys (HKLM, 'Software\MyasNick\Type it Easy');
					//RegDeleteKeyIncludingSubkeys (HKLM, 'Software\Masnikov\Type it Easy');
					// --- /удаляю следы старого инсталлятора
					Sleep (500);
				end;
	end;
	Result := true;
end;

procedure CancelButtonClick(CurPageID: Integer; var Cancel, Confirm: Boolean);
begin
	if CurPageID <> wpInstalling then Confirm := false;
end;

procedure InitializeUninstallProgressForm();
var
	ResultCode: Integer;
begin
	Exec (ExpandConstant ('{app}\TiE.exe'), '/closeall', '', SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode);
	Sleep (500);
end;

