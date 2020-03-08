object Form_MacroCmd: TForm_MacroCmd
  Left = 386
  Top = 320
  HelpContext = 530
  ActiveControl = Combo_Cmd
  BorderStyle = bsDialog
  Caption = 'Insert special macro command'
  ClientHeight = 245
  ClientWidth = 297
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 5
    Top = 0
    Width = 286
    Height = 136
    TabOrder = 0
    object Label1: TTntLabel
      Left = 10
      Top = 10
      Width = 81
      Height = 13
      Caption = '&Macro command:'
      FocusControl = Combo_Cmd
    end
    object Label2: TTntLabel
      Left = 10
      Top = 55
      Width = 59
      Height = 13
      Caption = '&Parameters:'
      FocusControl = Edit_Params
    end
    object Label3: TTntLabel
      Left = 10
      Top = 95
      Width = 38
      Height = 13
      Caption = 'Syntax:'
    end
    object LB_Syntax: TTntLabel
      Left = 10
      Top = 110
      Width = 12
      Height = 13
      Caption = '...'
      ParentShowHint = False
      ShowAccelChar = False
      ShowHint = True
    end
    object Combo_Cmd: TTntComboBox
      Left = 10
      Top = 25
      Width = 266
      Height = 21
      Style = csDropDownList
      DropDownCount = 12
      ItemHeight = 13
      Sorted = True
      TabOrder = 0
      OnClick = Combo_CmdClick
    end
    object Edit_Params: TTntEdit
      Left = 10
      Top = 70
      Width = 266
      Height = 21
      TabOrder = 1
    end
  end
  object Panel_Help: TPanel
    Left = 5
    Top = 140
    Width = 286
    Height = 66
    BevelOuter = bvLowered
    BorderWidth = 5
    Color = clInfoBk
    TabOrder = 1
    object LB_Help: TTntLabel
      Left = 6
      Top = 6
      Width = 274
      Height = 54
      Align = alClient
      Caption = '(no help available)'
      WordWrap = True
      ExplicitWidth = 88
      ExplicitHeight = 13
    end
  end
  object Button_OK: TTntButton
    Left = 15
    Top = 215
    Width = 75
    Height = 25
    Hint = 'Accept changes and close dialog box'
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
    OnClick = Button_OKClick
  end
  object Button_Cancel: TTntButton
    Left = 95
    Top = 215
    Width = 75
    Height = 25
    Hint = 'Discard changes and close dialog box'
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
    OnClick = Button_CancelClick
  end
  object Button_Help: TTntButton
    Left = 175
    Top = 215
    Width = 75
    Height = 25
    Caption = '&Help'
    TabOrder = 4
    OnClick = Button_HelpClick
  end
end
