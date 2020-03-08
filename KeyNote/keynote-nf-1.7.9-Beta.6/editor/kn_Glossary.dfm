object Form_Glossary: TForm_Glossary
  Left = 405
  Top = 291
  HelpContext = 550
  Caption = 'Glossary terms'
  ClientHeight = 272
  ClientWidth = 449
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 17
  object Panel1: TPanel
    Left = 332
    Top = 0
    Width = 117
    Height = 272
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 0
    object Button_OK: TTntButton
      Left = 12
      Top = 15
      Width = 93
      Height = 31
      Hint = 'Accept changes and close dialog box'
      Caption = 'OK'
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ModalResult = 1
      ParentFont = False
      TabOrder = 0
      OnClick = Button_OKClick
    end
    object Button_Cancel: TTntButton
      Left = 12
      Top = 52
      Width = 93
      Height = 30
      Hint = 'Discard changes and close dialog box'
      Cancel = True
      Caption = 'Cancel'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ModalResult = 2
      ParentFont = False
      TabOrder = 1
    end
    object Button_New: TTntButton
      Left = 12
      Top = 105
      Width = 93
      Height = 30
      Caption = '&New'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = Button_NewClick
    end
    object Button_Edit: TTntButton
      Left = 12
      Top = 142
      Width = 93
      Height = 30
      Caption = '&Edit'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = Button_EditClick
    end
    object Button_Del: TTntButton
      Left = 12
      Top = 178
      Width = 93
      Height = 31
      Caption = '&Delete'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = Button_DelClick
    end
    object Button_Help: TTntButton
      Left = 12
      Top = 228
      Width = 93
      Height = 30
      Caption = '&Help'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      OnClick = Button_HelpClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 332
    Height = 272
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 3
    TabOrder = 1
    object LV: TTntListView
      Left = 3
      Top = 3
      Width = 326
      Height = 266
      Align = alClient
      Columns = <
        item
          Caption = 'Shortcut'
          Width = 80
        end
        item
          Caption = 'Expands to'
          Width = 240
        end>
      ColumnClick = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      HideSelection = False
      ReadOnly = True
      RowSelect = True
      ParentFont = False
      TabOrder = 0
      ViewStyle = vsReport
      OnDblClick = Button_EditClick
    end
  end
  object FormPlacement: TFormPlacement
    IniSection = 'GlossaryDlg'
    Options = [fpPosition]
    Left = 90
    Top = 85
  end
end
