object Form_Password: TForm_Password
  Left = 424
  Top = 369
  ActiveControl = Edit_Pass
  BorderStyle = bsDialog
  Caption = 'File access passphrase'
  ClientHeight = 115
  ClientWidth = 448
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  ShowHint = True
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Button_OK: TTntButton
    Left = 151
    Top = 82
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = Button_OKClick
  end
  object Button_Cancel: TTntButton
    Left = 239
    Top = 82
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
    OnClick = Button_CancelClick
  end
  object GroupBox1: TTntGroupBox
    Left = 5
    Top = 5
    Width = 435
    Height = 66
    Caption = ' Enter access passphrase to open the file : '
    TabOrder = 2
    object Label_FileName: TTntLabel
      Left = 10
      Top = 15
      Width = 12
      Height = 13
      Caption = '...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHighlight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TTntLabel
      Left = 10
      Top = 40
      Width = 82
      Height = 13
      AutoSize = False
      Caption = '&Passphrase:'
      FocusControl = Edit_Pass
    end
    object Edit_Pass: TTntEdit
      Left = 96
      Top = 35
      Width = 313
      Height = 21
      Hint = 'Enter access passphrase for the file you wish to open'
      PasswordChar = '*'
      TabOrder = 0
    end
  end
end
