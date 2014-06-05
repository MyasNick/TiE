В Дельфи нет определения многих нужных типов и структур WinAPI для NT.

Эти определения есть в файлах от JEDI Project: JwaWinNT.pas, jwawintype.pas и jediapilib.inc, но для структуы _SYSTEM_POWER_POLICY пришлось поставить packed record, вместо просто record, иначе CallNtPowerInformation вместо STATUS_SUCCESS выдаёт STATUS_INVALID_PARAMETER.