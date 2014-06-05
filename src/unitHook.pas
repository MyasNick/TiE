// Integrated keyboard hook as alternative
// to my external keboard hook in dll.

unit unitHook;

interface

uses Windows, Messages, ExtCtrls, SysUtils, unitKeyboard, unitFunctions, Forms;

var
  FKeyboardHook: HHOOK;

function  HookProc(Code: Integer; wParam: WPARAM; lParam: LPARAM): Longint; stdcall;
procedure StartHook;
procedure StopHook;


implementation

uses unitConst;


function HookProc(Code: Integer; wParam: WPARAM; lParam: LPARAM): Longint; stdcall;

  type
    PKbDllHookStruct = ^TKbDllHookStruct;
    TKbDllHookStruct = record
      vkCode      : DWORD;
      scanCode    : DWORD;
      flags       : DWORD;
      time        : DWORD;
      dwExtraInfo : ULONG_PTR
    end;

  var
    VirtKey:  integer;
    ScanCode: byte;
    MyResult: boolean;

  procedure ShowAutoHint(doit: boolean);
  begin
    with frmKeyboard do
      if actLearnMode.Checked then
        if doit then begin
          // Timer
          if isKbdDelay then
            if not tmrDelay.Enabled then begin
              tmrDelay.Interval := kbdDelay;
              tmrDelay.Enabled  := true
            end
            else
          else
            isKbdDelayGone := true;
          // -----
          pmKbd.AutoPopup := false;
//          DoBalloon(bfInfo,BoolToStr(isKbdShown));
          if not isKbdShown and isKbdDelayGone then ShowKeyboard(true);
        end
        else begin
          // Timer
          tmrDelay.Enabled := false;
          isKbdDelayGone   := false;
          // -----
          pmKbd.AutoPopup := true;
          if isKbdShown and not isAltF1Pressed then ShowKeyboard(false);
        end;
    end;
begin

  VirtKey  := PKbDllHookStruct(lParam).vkCode;
  ScanCode := PKbDllHookStruct(lParam).scanCode;  //ScanCode := LOBYTE(HIWORD(lParam)); //LOBYTE(Message.LParamHi);

  if Code in [HC_ACTION, HC_NOREMOVE] then begin  // так нужно по правилам, но может выбросить нафик

    // если нажали ТОЛЬКО упр. кнопку
    if VirtKey = ControlKey then begin
      // ↓ вкл/выкл автоподсказки
      if ((wParam=WM_SYSKEYUP) or (wParam=WM_KEYUP)) then begin
        if not isMyKeyDownUp then begin // проверяем, не происходит ли виртуальное отжатие/нажатие, нужное для правильной вставки символов
          ShowAutoHint(false);
          MyResult := false;
        end
        else begin
          MyResult := false;
        end;
      end
      else begin
        ShowAutoHint(true);
        MyResult := true;
      end
      // ↑ вкл/выкл автоподсказки
    end
    else if isControlKeyPressed then begin // если нажали какую-то клавишу + упр. кнопка
           if (wParam=WM_SYSKEYUP) or (wParam=WM_KEYUP) then begin
              // вкл/выкл подсказки по F1
              if VirtKey = constKbdHintKey then begin
                if not frmKeyboard.actLearnMode.Checked
                  then ShowKeyboard(not isKbdShown)
                  else isAltF1Pressed := not isAltF1Pressed;
                frmKeyboard.rsbExit.Enabled := true;
                frmKeyboard.actKbdClose.Enabled := frmKeyboard.rsbExit.Enabled;
              end;
            end
            else begin
              // пока печатаем, вырубаем таймер клавиатуры
              isKbdDelayGone := false;
              frmKeyboard.tmrDelay.Enabled := false;
              TypeItNew(ScanCode);
            end;
            MyResult := true;
         end
         else begin
           MyResult := false;
         end;
    isControlKeyPressed := MyResult;
  end
  else MyResult := false;

  // блокировка клавиатуры, если нужно
  if MyResult then
    Result := 1
  else
  // собственно, сама блокировка
    if frmKeyboard.actBlockKbd.Checked then
      Result := 1
    else
      Result := CallNextHookEx(FKeyboardHook, Code, wParam, lParam);

  // индикатор блокировки клавиатуры
  if (VirtKey = constKbdBlockKey) and isControlKeyPressed and ((wParam=WM_SYSKEYUP) or (wParam=WM_KEYUP)) then begin
    frmKeyboard.actBlockKbdExecute(frmKeyboard);
  end;

end;


procedure StartHook;
begin
  //  Ставим хук
  FKeyboardHook := SetWindowsHookEx(WH_KEYBOARD_LL, HookProc, GetModuleHandle(nil), 0);    //GetModuleHandle(nil) если просто 0, то в XP бывает проблема и хук не навешивается
  if FKeyboardHook = 0
    then begin
      DoBalloon(bfInfo, SysErrorMessage(GetLastError));
//      Halt;
    end;
end;


procedure StopHook;
begin
  //  Снимаем хук
  if FKeyboardHook <> 0 then
    if UnhookWindowsHookEx(FKeyboardHook)
      then
        FKeyboardHook := 0
      else
        DoBalloon(bfInfo, SysErrorMessage(GetLastError));
end;


// РАЗНЫЕ ТИПА ПОЛЕЗНОСТИ:
// if (word(getkeystate(ControlKey))) > 0 then begin  // это проверка, переключалась ли клавиша
//        DoBalloon(bfInfo, IntToStr(VirtKey));
//        DoBalloon(bfInfo, 'Hallo!');
//        DoBalloon(bfInfo, 'Here we go!');
// not boolean(PKbDllHookStruct(lParam).flags and LLKHF_UP) // это проверка на нажатие в лоулевел клавиатурном хуке
// if (word(GetKeyState(ControlKey)) shr 8) > 0 then begin  // проверка на прижатость системной клавиши №1
// if (GetKeyState(ControlKey) and KF_UP) <> 0 then begin   // проверка на прижатость системной клавиши №2
// Result := CallNextHookEx(FKeyboardHook, Code, wParam, lParam);
// if (wParam=WM_SYSKEYDOWN) or (wParam=WM_KEYDOWN) then
// GetAsyncKeyState(VK_RCONTROL)<>0


end.
