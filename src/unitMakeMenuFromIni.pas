unit unitMakeMenuFromIni;

interface

uses
  Classes, IniFiles, SysUtils, Menus, unitConst, unitFunctions, unitKeySettings, unitKeyboard;

type
  TMakeMenuFromIniThread = class(TThread)
  protected
    procedure MakeMenuFromIni;
    procedure Execute; override;
  end;

implementation


// ѕереписать этот поток так, чтобы “ќЋ№ ќ обращени€ к визуальным компонентам были внутри Synchronize!
// »наче особого толка от потока нету.

procedure TMakeMenuFromIniThread.Execute;
begin
  FreeOnTerminate := true;
  Synchronize(MakeMenuFromIni);
end;

procedure TMakeMenuFromIniThread.MakeMenuFromIni;
var IniFile: TIniFile;
    Tables, Records: TStringList;
    i,j, Delta: integer;
    arrMenuItemsTop, arrMenuItemsBtm, arrSubMenuItemsTop, arrSubMenuItemsBtm: array of TMenuItem;
begin
  if FileExists (AppPath + CharsFileName) then
    try

      frmKeySettings.ShowHide(false);

      IniFile := TIniFile.Create (AppPath + CharsFileName);
      Tables  := TStringList.Create;
      Records := TStringList.Create;

      while frmKeySettings.pmTopChar.Items.Count > 3 do
      begin
        frmKeySettings.pmTopChar.Items.Delete(3);
        frmKeySettings.pmBottomChar.Items.Delete(3);
      end;

      IniFile.ReadSection(CharsTables, Tables);

      SetLength(arrMenuItemsTop, Tables.Count);
      SetLength(arrMenuItemsBtm, Tables.Count);

      Delta := 100 mod Tables.Count;

      for i := 0 to  Tables.Count - 1 do begin

        arrMenuItemsTop[i] := TMenuItem.Create (frmKeySettings.pmTopChar.Items);
        arrMenuItemsTop[i].Caption := Tables.Strings[i];
        frmKeySettings.pmTopChar.Items.Add(arrMenuItemsTop[i]);

        arrMenuItemsBtm[i] := TMenuItem.Create (frmKeySettings.pmBottomChar.Items);
        arrMenuItemsBtm[i].Caption := Tables.Strings[i];
        frmKeySettings.pmBottomChar.Items.Add(arrMenuItemsBtm[i]);

        Records.Clear;
        IniFile.ReadSection(Tables.Strings[i], Records);

        SetLength(arrSubMenuItemsTop, Records.Count);
        SetLength(arrSubMenuItemsBtm, Records.Count);

        for j := 0 to Records.Count - 1 do begin
          arrSubMenuItemsTop[j] := TMenuItem.Create (arrMenuItemsTop[i]);
          if Pos(CombineDiacrits, Tables.Strings[i]) = 0
            then arrSubMenuItemsTop[j].Caption := ' &' + char (GetIntFromStr ('$' + Records.Strings[j])) + constLongSpace + IniFile.ReadString(Tables.Strings[i], Records.Strings[j],'') + ' (U+' + Records.Strings[j] + ')'
            else arrSubMenuItemsTop[j].Caption := ' A' + char (GetIntFromStr ('$' + Records.Strings[j])) + constLongSpace + IniFile.ReadString(Tables.Strings[i], Records.Strings[j],'') + ' (U+' + Records.Strings[j] + ')';
          arrSubMenuItemsTop[j].Tag := GetIntFromStr ('$' + Records.Strings[j]);
          arrSubMenuItemsTop[j].OnClick := frmKeySettings.MenuTopCharOnClick;
          arrMenuItemsTop[i].Add(arrSubMenuItemsTop[j]);

          arrSubMenuItemsBtm[j] := TMenuItem.Create (arrMenuItemsBtm[i]);
          if Pos(CombineDiacrits, Tables.Strings[i]) = 0
            then arrSubMenuItemsBtm[j].Caption := ' &' + char (GetIntFromStr ('$' + Records.Strings[j])) + constLongSpace + IniFile.ReadString(Tables.Strings[i], Records.Strings[j],'') + ' (U+' + Records.Strings[j] + ')'
            else arrSubMenuItemsBtm[j].Caption := ' A' + char (GetIntFromStr ('$' + Records.Strings[j])) + constLongSpace + IniFile.ReadString(Tables.Strings[i], Records.Strings[j],'') + ' (U+' + Records.Strings[j] + ')';
          arrSubMenuItemsBtm[j].Tag := GetIntFromStr ('$' + Records.Strings[j]);
          arrSubMenuItemsBtm[j].OnClick := frmKeySettings.MenuBtmCharOnClick;
          arrMenuItemsBtm[i].Add(arrSubMenuItemsBtm[j]);
        end;

        frmKeySettings.ProgressBar.Position := frmKeySettings.ProgressBar.Position + Delta;
//        Records.SaveToFile('d:\nick\downloads\debug'+ IntToStr(i) + '.txt');
      end;

      frmKeySettings.ShowHide(true);

      Tables.Free;
      Records.Free;
      IniFile.Free;
    except
      DoBalon('Oops! Can''t create additional characters submenu.');
    end
  else DoBalon('There is no УTiE.additional.chars.iniФ file!');
end;

end.
