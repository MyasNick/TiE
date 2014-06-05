object frmOptions: TfrmOptions
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'frmOptions'
  ClientHeight = 305
  ClientWidth = 414
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
  OnCanResize = FormCanResize
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnDeactivate = FormDeactivate
  OnShow = FormShow
  DesignSize = (
    414
    305)
  PixelsPerInch = 96
  TextHeight = 13
  object btnOK: TButton
    Left = 331
    Top = 272
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'btnOK'
    Default = True
    TabOrder = 1
    OnClick = btnOKClick
  end
  object pcOptions: TPageControl
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 408
    Height = 260
    Margins.Bottom = 0
    ActivePage = tsOptionsGeneral
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    object tsOptionsGeneral: TTabSheet
      Caption = 'tsOptionsGeneral'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        400
        232)
      object lblRestart: TLabel
        Left = 351
        Top = 0
        Width = 46
        Height = 13
        Anchors = [akLeft, akTop, akRight]
        Caption = 'lblRestart'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Visible = False
        WordWrap = True
      end
      object lblOptMainKey: TLabel
        Left = 10
        Top = 12
        Width = 68
        Height = 13
        Caption = 'lblOptMainKey'
      end
      object bvlOptGeneralA: TBevel
        Left = 10
        Top = 154
        Width = 380
        Height = 3
        Anchors = [akLeft, akTop, akRight]
        Shape = bsTopLine
      end
      object lblOptLang: TLabel
        Left = 10
        Top = 91
        Width = 51
        Height = 13
        Caption = 'lblOptLang'
      end
      object Bevel1: TBevel
        Left = 12
        Top = 75
        Width = 380
        Height = 3
        Anchors = [akLeft, akTop, akRight]
        Shape = bsTopLine
      end
      object lblOptDblClickMode: TLabel
        Left = 12
        Top = 171
        Width = 90
        Height = 13
        Caption = 'lblOptDblClickMode'
      end
      object comboxMainKey: TComboBox
        Left = 10
        Top = 31
        Width = 200
        Height = 21
        ItemHeight = 0
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Text = 'comboxMainKey'
        OnClick = comboxMainKeyClick
        OnEnter = comboxMainKeyEnter
      end
      object comboxLang: TComboBox
        Left = 10
        Top = 110
        Width = 200
        Height = 21
        ItemHeight = 0
        Sorted = True
        TabOrder = 1
        Text = 'comboxLang'
        OnChange = comboxLangClick
      end
      object comboxDblClickMode: TComboBox
        Left = 10
        Top = 190
        Width = 200
        Height = 21
        ItemHeight = 0
        TabOrder = 2
        Text = 'comboxDblClickMode'
        OnChange = comboxDblClickModeChange
      end
    end
    object tsOptionsKeys: TTabSheet
      Caption = 'tsOptionsKeys'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        400
        232)
      object bvlOptKeysA: TBevel
        Left = 10
        Top = 154
        Width = 380
        Height = 3
        Anchors = [akLeft, akTop, akRight]
        Shape = bsTopLine
      end
      object lblFontLeftSide: TLabel
        Left = 97
        Top = 15
        Width = 295
        Height = 13
        AutoSize = False
        Caption = 'lblFontLeftSide'
      end
      object lblFontRightSide: TLabel
        Left = 97
        Top = 46
        Width = 295
        Height = 13
        AutoSize = False
        Caption = 'lblFontRightSide'
      end
      object lblFontDiacrit: TLabel
        Left = 97
        Top = 77
        Width = 295
        Height = 13
        AutoSize = False
        Caption = 'lblFontDiacrit'
      end
      object lblResetFonts: TLabel
        Left = 97
        Top = 122
        Width = 295
        Height = 13
        AutoSize = False
        Caption = 'lblResetFonts'
      end
      object btnLeftSideFont: TButton
        Left = 10
        Top = 10
        Width = 75
        Height = 25
        Caption = 'btnFont'
        TabOrder = 0
        OnClick = btnLeftSideFontClick
      end
      object btnRightSideFont: TButton
        Left = 10
        Top = 41
        Width = 75
        Height = 25
        Caption = 'btnFont'
        TabOrder = 1
        OnClick = btnRightSideFontClick
      end
      object btnDiacritFont: TButton
        Left = 10
        Top = 72
        Width = 75
        Height = 25
        Caption = 'btnFont'
        TabOrder = 2
        OnClick = btnDiacritFontClick
      end
      object chboxKbdDropShadow: TCheckBox
        Left = 10
        Top = 186
        Width = 380
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'chboxKbdDropShadow'
        TabOrder = 5
        OnClick = chboxKbdDropShadowClick
      end
      object chboxUseClearType: TCheckBox
        Left = 10
        Top = 164
        Width = 380
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'chboxUseClearType'
        TabOrder = 4
        OnClick = chboxUseClearTypeClick
      end
      object btnResetKbdFonts: TButton
        Left = 10
        Top = 117
        Width = 75
        Height = 25
        Caption = 'btnReset'
        TabOrder = 3
        OnClick = btnResetKbdFontsClick
      end
      object chboxKbdDelay: TCheckBox
        Left = 10
        Top = 208
        Width = 380
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'chboxKbdDelay'
        TabOrder = 6
        OnClick = chboxKbdDelayClick
      end
    end
    object tsOptionsMisc: TTabSheet
      Caption = 'tsOptionsMisc'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        400
        232)
      object bvlOptMiscA: TBevel
        Left = 10
        Top = 218
        Width = 380
        Height = 3
        Anchors = [akLeft, akTop, akRight]
        Shape = bsTopLine
        Visible = False
      end
      object gbGlobalHotKeys: TGroupBox
        Left = 10
        Top = 10
        Width = 280
        Height = 57
        Caption = 'gbGlobalHotKeys'
        TabOrder = 0
        DesignSize = (
          280
          57)
        object lblHotKeyEnable: TLabel
          Left = 12
          Top = 24
          Width = 222
          Height = 13
          Alignment = taRightJustify
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 'lblHotKeyEnable'
          ExplicitWidth = 192
        end
        object editHotKeyEnable: TEdit
          Left = 240
          Top = 20
          Width = 25
          Height = 21
          Anchors = [akTop, akRight]
          TabOrder = 0
          Text = 'T'
          OnChange = editHotKeyEnableChange
          OnKeyDown = editHotKeyEnableKeyDown
        end
      end
      object chboxShowPresetInfo: TCheckBox
        Left = 10
        Top = 80
        Width = 380
        Height = 17
        Caption = 'chboxShowPresetInfo'
        TabOrder = 1
        OnClick = chboxShowPresetInfoClick
      end
    end
  end
  object dlgFont: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Left = 4
    Top = 274
  end
  object optBalloonHint: TBalloonHint
    Delay = 100
    HideAfter = 4000
    Left = 224
    Top = 56
  end
end
