// -----------------------------------------------------------
//
// RealSysInfo version 1.1 visual component
// (c) 2003-2004 Nikolaj Masnikov
//
// -----------------------------------------------------------

unit RealSysInfo;

interface

uses  Messages, SysUtils, Classes, Windows, Registry, ShellApi;

type
  TRealSysInfo = class(TComponent)
   private
      // --- Universal ---
      FIsWinNT: boolean;
      FResolution:string;
      FDirectXVer:string;
      FCPUIdentifier:string;
      FCPUVendor:string;
      FComputerName:string;
      FPhysMemory:integer;
      // --- OS Depended ---
      FUserName:string;
      FProductName:string;
      FWinVer:string;
      FWinVerNo:string;
      FBuildNo:string;
      FPrinter:string;
      function GetPhysMemory:    integer;
      function GetWinType:       boolean;
      function GetResolution:    string;
      function GetDirectXVer:    string;
      function GetCPUIdentifier: string;
      function GetCPUVendor:     string;
      function GetComputerName:  string;
      // --- OS Depended ---
      function GetUserName:      string;
      function GetWinVer:        string;
      function GetWinVerNo:      string;
      function GetBuildNo:       string;
      function GetProductName:   string;
      function GetPrinter:       string;
   public
      constructor Create(AOwner: TComponent); override;
      destructor  Destroy; override;
   published
      // --- Universal ---
      property IsWinNT:       boolean read GetWinType write FIsWinNT;
      property PhysMemory:   integer read GetPhysMemory write FPhysMemory;
      property Resolution:    string read GetResolution write FResolution;
      property DirectXVer:    string read GetDirectXVer write FDirectXVer;
      property CPUIdentifier: string read GetCPUIdentifier write FCPUIdentifier;
      property CPUVendor:     string read GetCPUVendor write FCPUVendor;
      property ComputerName:  string read GetComputerName write FComputerName;
      // --- OS Depended ---
      property UserName:      string read GetUsername write FUserName;
      property WinVer:        string read GetWinVer write FWinVer;
      property WinVerNo:      string read GetWinVerNo write FWinVerNo;
      property BuildNo:       string read GetBuildNo write FBuildNo;
      property ProductName:   string read GetProductName write FProductName;
      property Printer:       string read GetPrinter write FPrinter;
end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Real', [TRealSysInfo]);
end;

{ TInfoCtrl }

constructor TRealSysInfo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TRealSysInfo.Destroy;
begin
  inherited Destroy;
end;

// --- Universal ---

function TRealSysInfo.GetWinType:boolean;
var OSVersionInfo: TOSVersionInfo;
begin
 OSVersionInfo.dwOSVersionInfoSize := sizeof(OSVersionInfo);
 GetVersionEx(OSVersionInfo);
 if OSVersionInfo.dwPlatformId = VER_PLATFORM_WIN32_NT
  then Result:=true
  else Result:=false;
  {if OSVersionInfo.dwPlatformId = VER_PLATFORM_WIN32_WINDOWS then Result:=false;}
end;

function TRealSysInfo.GetResolution: string;
begin
  Result := IntToStr(GetSystemMetrics(SM_CXSCREEN))+' x '+IntToStr(GetSystemMetrics(SM_CYSCREEN));
end;

function TRealSysInfo.GetDirectXVer: string;
 var Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  Reg.OpenKey('\Software\Microsoft\DirectX', True);
  Result := Reg.ReadString('Version');
end;

function TRealSysInfo.GetCPUIdentifier: string;
 var Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  Reg.OpenKey('\Hardware\Description\System\CentralProcessor\0', True);
  Result := Reg.ReadString('Identifier');
end;

function TRealSysInfo.GetCPUVendor: string;
 var Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  Reg.OpenKey('\Hardware\Description\System\CentralProcessor\0', True);
  Result := Reg.ReadString('VendorIdentifier');
end;

function TRealSysInfo.GetComputerName: string;
 var Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  Reg.OpenKey('\System\CurrentControlSet\Control\ComputerName\ComputerName', True);
  Result := Reg.ReadString('ComputerName');
end;


function TRealSysInfo.GetPhysMemory: integer;
var gms: MEMORYSTATUS;
begin
  GlobalMemoryStatus(gms);
  Result := gms.dwTotalPhys;
end;



// --- OS Depended ---

function UsName:string;
var //Buffer:array [0..256] of Char;
    nSize:DWORD;
    Buff: PChar;
begin
// Result := 'noname';
// nSize:=SizeOF(Buffer);
// if GetUserName(@Buffer, nSize) then Result:=StrPas(@Buffer);
 Result := 'noname';
 nSize:=SizeOF(Buff);
 if GetUserName(Buff, nSize) then Result:=StrPas(Buff);
end;

function TRealSysInfo.GetUserName: string;
begin
 Result := UsName;
end;

function TRealSysInfo.GetWinVer: string;
 var Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  if not IsWinNT then
    begin
     Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion', True);
     Result := Reg.ReadString('Version');
    end
   else
    begin
     Reg.OpenKey('\Software\Microsoft\Windows NT\CurrentVersion', True);
     Result := Reg.ReadString('CurrentVersion');
    end;
end;

function TRealSysInfo.GetWinVerNo: string;
 var Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion', True);
  Result := Reg.ReadString('VersionNumber');
end;

function TRealSysInfo.GetBuildNo: string;
 var Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  if not IsWinNT then
    begin
     Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion', True);
     Result := Reg.ReadString('CurrentBuildNumber');
    end
   else
    begin
     Reg.OpenKey('\Software\Microsoft\Windows NT\CurrentVersion', True);
     Result := Reg.ReadString('CurrentBuildNumber');
    end;
end;

function TRealSysInfo.GetProductName: string;
 var Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  if not IsWinNT then
    begin
     Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion', True);
     Result := Reg.ReadString('ProductName');
    end
   else
    begin
     Reg.OpenKey('\Software\Microsoft\Windows NT\CurrentVersion', True);
     Result := Reg.ReadString('ProductName');
    end;
end;

function TRealSysInfo.GetPrinter: string;
 var Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_CURRENT_CONFIG;
  Reg.OpenKey('\System\CurrentControlSet\Control\Print\Printers', True);
  Result := Reg.ReadString('Default');
end;

end.

