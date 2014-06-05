// Описания структур и констант, нужных для WinAPI функции CallNtPowerInformation,
// Описания взяты из JwaWinNT.pas, которому нужны jwawintype.pas и jediapilib.inc
// Структура _SYSTEM_POWER_POLICY переобъявлена как packed record, иначе же,
// если она как в оригинале просто record, то CallNtPowerInformation вместо
// STATUS_SUCCESS выдаёт STATUS_INVALID_PARAMETER.

unit WinPwrTypes;

interface

uses unitConst;

const
  NUM_DISCHARGE_POLICIES = 4;
  {$EXTERNALSYM NUM_DISCHARGE_POLICIES}

type

  POWER_ACTION = (
    PowerActionNone,
    PowerActionReserved,
    PowerActionSleep,
    PowerActionHibernate,
    PowerActionShutdown,
    PowerActionShutdownReset,
    PowerActionShutdownOff,
    PowerActionWarmEject);
  {$EXTERNALSYM POWER_ACTION}
  PPOWER_ACTION = ^POWER_ACTION;
  {$EXTERNALSYM PPOWER_ACTION}
  TPowerAction = POWER_ACTION;
  PPowerAction = PPOWER_ACTION;

  POWER_INFORMATION_LEVEL = (
    SystemPowerPolicyAc,
    SystemPowerPolicyDc,
    VerifySystemPolicyAc,
    VerifySystemPolicyDc,
    SystemPowerCapabilities,
    SystemBatteryState,
    SystemPowerStateHandler,
    ProcessorStateHandler,
    SystemPowerPolicyCurrent,
    AdministratorPowerPolicy,
    SystemReserveHiberFile,
    ProcessorInformation,
    SystemPowerInformation,
    ProcessorStateHandler2,
    LastWakeTime,                                   // Compare with KeQueryInterruptTime()
    LastSleepTime,                                  // Compare with KeQueryInterruptTime()
    SystemExecutionState,
    SystemPowerStateNotifyHandler,
    ProcessorPowerPolicyAc,
    ProcessorPowerPolicyDc,
    VerifyProcessorPowerPolicyAc,
    VerifyProcessorPowerPolicyDc,
    ProcessorPowerPolicyCurrent,
    SystemPowerStateLogging,
    SystemPowerLoggingEntry);
  {$EXTERNALSYM POWER_INFORMATION_LEVEL}
  TPowerInformationLevel = POWER_INFORMATION_LEVEL;

  {$EXTERNALSYM PPOWER_ACTION_POLICY}
  POWER_ACTION_POLICY = packed record
    Action: POWER_ACTION;
    Flags: DWORD;
    EventCode: DWORD;
  end;
  {$EXTERNALSYM POWER_ACTION_POLICY}
  PPOWER_ACTION_POLICY = ^POWER_ACTION_POLICY;
  TPowerActionPolicy = POWER_ACTION_POLICY;
  PPowerActionPolicy = PPOWER_ACTION_POLICY;

  _SYSTEM_POWER_STATE = (
    PowerSystemUnspecified,
    PowerSystemWorking,
    PowerSystemSleeping1,
    PowerSystemSleeping2,
    PowerSystemSleeping3,
    PowerSystemHibernate,
    PowerSystemShutdown,
    PowerSystemMaximum);
  {$EXTERNALSYM _SYSTEM_POWER_STATE}
  SYSTEM_POWER_STATE = _SYSTEM_POWER_STATE;
  {$EXTERNALSYM SYSTEM_POWER_STATE}
  PSYSTEM_POWER_STATE = ^SYSTEM_POWER_STATE;
  {$EXTERNALSYM PSYSTEM_POWER_STATE}
  TSystemPowerState = SYSTEM_POWER_STATE;
  PSystemPowerState = PSYSTEM_POWER_STATE;

  {$EXTERNALSYM PSYSTEM_POWER_LEVEL}
  SYSTEM_POWER_LEVEL = packed record
    Enable: BOOLEAN;
    Spare: array [0..3 - 1] of BYTE;
    BatteryLevel: DWORD;
    PowerPolicy: POWER_ACTION_POLICY;
    MinSystemState: SYSTEM_POWER_STATE;
  end;
  {$EXTERNALSYM SYSTEM_POWER_LEVEL}
  TSystemPowerLevel = SYSTEM_POWER_LEVEL;
  PSYSTEM_POWER_LEVEL = ^SYSTEM_POWER_LEVEL;
  PSystemPowerLevel = PSYSTEM_POWER_LEVEL;

  PSYSTEM_POWER_POLICY = ^SYSTEM_POWER_POLICY;
  {$EXTERNALSYM PSYSTEM_POWER_POLICY}
  _SYSTEM_POWER_POLICY = packed record
    Revision: DWORD; // 1
    // events
    PowerButton: POWER_ACTION_POLICY;
    SleepButton: POWER_ACTION_POLICY;
    LidClose: POWER_ACTION_POLICY;
    LidOpenWake: SYSTEM_POWER_STATE;
    Reserved: DWORD;
    // "system idle" detection
    Idle: POWER_ACTION_POLICY;
    IdleTimeout: DWORD;
    IdleSensitivity: BYTE;
    // dynamic throttling policy
    //      PO_THROTTLE_NONE, PO_THROTTLE_CONSTANT, PO_THROTTLE_DEGRADE, or PO_THROTTLE_ADAPTIVE
    DynamicThrottle: BYTE;
    Spare2: array [0..1] of BYTE;
    // meaning of power action "sleep"
    MinSleep: SYSTEM_POWER_STATE;
    MaxSleep: SYSTEM_POWER_STATE;
    ReducedLatencySleep: SYSTEM_POWER_STATE;
    WinLogonFlags: DWORD;
    // parameters for dozing
    Spare3: DWORD;
    DozeS4Timeout: DWORD;
    // battery policies
    BroadcastCapacityResolution: DWORD;
    DischargePolicy: array [0..NUM_DISCHARGE_POLICIES - 1] of SYSTEM_POWER_LEVEL;
    // video policies
    VideoTimeout: DWORD;
    VideoDimDisplay: BOOLEAN;
    VideoReserved: array [0..2] of DWORD;
    // hard disk policies
    SpindownTimeout: DWORD;
    // processor policies
    OptimizeForPower: LongBool;
    FanThrottleTolerance: BYTE;
    ForcedThrottle: BYTE;
    MinThrottle: BYTE;
    OverThrottled: POWER_ACTION_POLICY;
  end;
  {$EXTERNALSYM _SYSTEM_POWER_POLICY}
  SYSTEM_POWER_POLICY = _SYSTEM_POWER_POLICY;
  {$EXTERNALSYM SYSTEM_POWER_POLICY}
  TSystemPowerPolicy = SYSTEM_POWER_POLICY;
  PSystemPowerPolicy = PSYSTEM_POWER_POLICY;


implementation


end.
