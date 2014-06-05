object frmNewPreset: TfrmNewPreset
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'frmNewPreset'
  ClientHeight = 158
  ClientWidth = 359
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnShow = FormShow
  DesignSize = (
    359
    158)
  PixelsPerInch = 96
  TextHeight = 13
  object shpAbout: TShape
    Left = 0
    Top = 0
    Width = 359
    Height = 114
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    Pen.Color = clWhite
  end
  object bvlKeySettings: TBevel
    Left = 0
    Top = 114
    Width = 359
    Height = 2
    Align = alTop
    Anchors = [akLeft, akRight, akBottom]
    Shape = bsTopLine
    ExplicitLeft = -2
  end
  object btnOK: TButton
    Left = 195
    Top = 125
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'btnOK'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 276
    Top = 125
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'btnCancel'
    ModalResult = 2
    TabOrder = 2
    OnClick = btnCancelClick
  end
  object editNewPresetName: TLabeledEdit
    Left = 32
    Top = 52
    Width = 300
    Height = 21
    EditLabel.Width = 97
    EditLabel.Height = 13
    EditLabel.Caption = 'editNewPresetName'
    EditLabel.Transparent = True
    TabOrder = 0
    Text = 'New Preset'
  end
  object dlgSavePreset: TSaveDialog
    Left = 50
    Top = 126
  end
end
