object Form_NodeNum: TForm_NodeNum
  Left = 308
  Top = 230
  BorderStyle = bsDialog
  Caption = 'Outline node numbering'
  ClientHeight = 231
  ClientWidth = 442
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button_OK: TTntButton
    Left = 10
    Top = 200
    Width = 75
    Height = 25
    Hint = 'Accept settings and execute'
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 5
  end
  object Button_Cancel: TTntButton
    Left = 90
    Top = 200
    Width = 75
    Height = 25
    Hint = 'Cancel'
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 6
  end
  object RG_Scope: TTntRadioGroup
    Left = 5
    Top = 0
    Width = 211
    Height = 56
    Caption = ' &Numbering scope '
    ItemIndex = 0
    Items.Strings = (
      'Apply numbering to whole tree'
      'Apply numbering to current subtree')
    TabOrder = 0
  end
  object RG_CurNum: TTntRadioGroup
    Left = 225
    Top = 0
    Width = 211
    Height = 116
    Caption = ' &Current numbering state '
    ItemIndex = 2
    Items.Strings = (
      'Node names are not yet numbered'
      'Node names are already numbered'
      'Auto-detect existing node numbers')
    TabOrder = 3
  end
  object RG_Method: TTntRadioGroup
    Left = 5
    Top = 60
    Width = 211
    Height = 56
    Caption = ' Numbering &method '
    ItemIndex = 0
    Items.Strings = (
      'Add numbers to node names'
      'Replace node names with numbers')
    TabOrder = 1
    OnClick = RG_MethodClick
  end
  object GroupBox1: TTntGroupBox
    Left = 225
    Top = 120
    Width = 211
    Height = 71
    Caption = ' Numbering style '
    TabOrder = 2
    object Label1: TTntLabel
      Left = 10
      Top = 20
      Width = 96
      Height = 13
      Caption = '&Begin numbering at:'
      FocusControl = Spin_StartNum
    end
    object Spin_StartNum: TSpinEdit
      Left = 10
      Top = 40
      Width = 61
      Height = 22
      MaxLength = 4
      MaxValue = 9999
      MinValue = 1
      TabOrder = 0
      Value = 1
    end
  end
  object GroupBox2: TTntGroupBox
    Left = 5
    Top = 120
    Width = 211
    Height = 71
    Caption = ' Numbering depth'
    TabOrder = 4
    object LB_Depth: TTntLabel
      Left = 10
      Top = 45
      Width = 81
      Height = 13
      Caption = '&Limit level depth:'
      FocusControl = Spin_Depth
    end
    object Spin_Depth: TSpinEdit
      Left = 100
      Top = 40
      Width = 61
      Height = 22
      Enabled = False
      MaxLength = 4
      MaxValue = 9999
      MinValue = 1
      TabOrder = 0
      Value = 1
    end
    object CB_FullDepth: TTntCheckBox
      Left = 10
      Top = 20
      Width = 186
      Height = 17
      Caption = '&Apply numbering to all levels'
      Checked = True
      State = cbChecked
      TabOrder = 1
      OnClick = CB_FullDepthClick
    end
  end
  object Btn_Remove: TTntButton
    Left = 270
    Top = 200
    Width = 161
    Height = 25
    Hint = 'Remove existing numbers from ALL nodes'
    Caption = '&Remove numbering'
    ModalResult = 10
    TabOrder = 7
  end
end
