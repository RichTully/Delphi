object Form_Template: TForm_Template
  Left = 382
  Top = 304
  ActiveControl = Edit_Name
  BorderStyle = bsDialog
  Caption = 'Create template'
  ClientHeight = 191
  ClientWidth = 217
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
  PixelsPerInch = 96
  TextHeight = 13
  object Button_OK: TTntButton
    Left = 34
    Top = 160
    Width = 75
    Height = 25
    Hint = 'Accept changes and close dialog box'
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object Button_Cancel: TTntButton
    Left = 114
    Top = 160
    Width = 75
    Height = 25
    Hint = 'Discard changes and close dialog box'
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object GroupBox1: TTntGroupBox
    Left = 5
    Top = 0
    Width = 206
    Height = 153
    TabOrder = 2
    object Label1: TTntLabel
      Left = 10
      Top = 15
      Width = 31
      Height = 13
      Caption = '&Name:'
      FocusControl = Edit_Name
    end
    object RG_Source: TTntRadioGroup
      Left = 10
      Top = 87
      Width = 185
      Height = 57
      Caption = ' &Create from... '
      ItemIndex = 0
      Items.Strings = (
        'Selected text'
        'Full text of active note')
      TabOrder = 2
    end
    object Edit_Name: TTntEdit
      Left = 10
      Top = 30
      Width = 181
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnChange = Edit_NameChange
      OnKeyDown = Edit_NameKeyDown
      OnKeyPress = Edit_NameKeyPress
    end
    object CB_Formatted: TTntCheckBox
      Left = 20
      Top = 60
      Width = 165
      Height = 17
      Caption = '&Formatted text'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
  end
end
