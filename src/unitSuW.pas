unit unitSuW;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, KWizard, StdCtrls, jpeg, ImgList, ExtCtrls;

type
  TfrmSuW = class(TForm)
    kwizStartUp: TKWizard;
    kwWelcome: TKWizardWelcomePage;
    lbLang: TListBox;
    lblChooseLang: TLabel;
    kwMainKey: TKWizardInteriorPage;
    kwFinish: TKWizardWelcomePage;
    ilHeaders: TImageList;
    lbMainKey: TListBox;
    lblMainKey: TLabel;
    kwInterface: TKWizardInteriorPage;
    chboxKbdClearType: TCheckBox;
    chboxKbdShadow: TCheckBox;
    kwHotKeys: TKWizardInteriorPage;
    lblHotKeyEnableWin: TLabel;
    lblHotKeyKbdLockWin: TLabel;
    edtHotKeyEnable: TEdit;
    edtHotKeyKbdLock: TEdit;
    lblMainKeyInfo: TLabel;
    lblHotKeyEnable: TLabel;
    lblHotKeyKbdLock: TLabel;
    bvlHotKeys: TBevel;
    Bevel1: TBevel;
    lblClearType: TLabel;
    lblKbdShadow: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure kwizStartUpFinishButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSuW: TfrmSuW;
  CM_TIE_INFO: DWORD;

implementation

{$R *.dfm}

procedure TfrmSuW.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//  SendMessage (HWND_BROADCAST, CM_TIE_INFO, 1{WPARAM=1 активировать actFirstStartWizard}, 1);
end;

procedure TfrmSuW.FormCreate(Sender: TObject);
begin
  kwFinish.WaterMark.Image.Picture.Assign(kwWelcome.WaterMark.Image.Picture);
end;

procedure TfrmSuW.FormShow(Sender: TObject);
begin
//  SendMessage (HWND_BROADCAST, CM_TIE_INFO, 2{WPARAM=2 деактивировать actFirstStartWizard}, 1);
end;

procedure TfrmSuW.kwizStartUpFinishButtonClick(Sender: TObject);
begin
  Close;
end;

end.
