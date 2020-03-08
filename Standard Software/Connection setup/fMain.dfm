object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'SQL Connection setup'
  ClientHeight = 462
  ClientWidth = 479
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 479
    Height = 443
    ActivePage = tsEncryption
    Align = alClient
    TabOrder = 0
    object tsConnection: TTabSheet
      Caption = 'Connection'
      object LblConn: TLabel
        Left = 13
        Top = 203
        Width = 152
        Height = 16
        Caption = 'Connection Information'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object SpeedButton1: TSpeedButton
        Left = 359
        Top = 69
        Width = 23
        Height = 22
        Caption = '...'
        OnClick = SpeedButton1Click
      end
      object Label5: TLabel
        Left = 40
        Top = 38
        Width = 270
        Height = 26
        Caption = 
          'Make sure that the path below is the folder in which the Softwar' +
          'e program is located. '
        WordWrap = True
      end
      object LblIni: TLabel
        Left = 31
        Top = 136
        Width = 38
        Height = 13
        Caption = 'Ini File: '
      end
      object Label4: TLabel
        Left = 40
        Top = 104
        Width = 79
        Height = 13
        Caption = '[Connections]'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object gbNewConn: TGroupBox
        Left = 13
        Top = 231
        Width = 393
        Height = 147
        Caption = 'New Connection'
        TabOrder = 0
        object Label21: TLabel
          Left = 16
          Top = 110
          Width = 50
          Height = 13
          Caption = 'Password:'
        end
        object Label20: TLabel
          Left = 16
          Top = 86
          Width = 66
          Height = 13
          Caption = 'Login (eg sa):'
        end
        object Label19: TLabel
          Left = 16
          Top = 62
          Width = 50
          Height = 13
          Caption = 'Database:'
        end
        object Label18: TLabel
          Left = 16
          Top = 38
          Width = 36
          Height = 13
          Caption = 'Server:'
        end
        object edtPassword: TEdit
          Left = 100
          Top = 107
          Width = 270
          Height = 21
          PasswordChar = '*'
          TabOrder = 3
        end
        object edtLogin: TEdit
          Left = 100
          Top = 83
          Width = 270
          Height = 21
          TabOrder = 2
        end
        object edtDatabase: TEdit
          Left = 100
          Top = 59
          Width = 270
          Height = 21
          TabOrder = 1
        end
        object edtServer: TEdit
          Left = 100
          Top = 35
          Width = 270
          Height = 21
          TabOrder = 0
        end
      end
      object btnNewconn: TButton
        Left = 197
        Top = 200
        Width = 93
        Height = 25
        Caption = 'New connection'
        TabOrder = 1
        Visible = False
      end
      object edtPath: TEdit
        Left = 40
        Top = 70
        Width = 313
        Height = 21
        TabOrder = 2
        Text = 'edtPath'
      end
      object ActionToolBar1: TActionToolBar
        Left = 0
        Top = 0
        Width = 471
        Height = 23
        ActionManager = ActionManager1
        Caption = 'ActionToolBar1'
        ColorMap.HighlightColor = 15660791
        ColorMap.BtnSelectedColor = clBtnFace
        ColorMap.UnusedColor = 15660791
        Spacing = 0
      end
      object edtConnStr: TEdit
        Left = 32
        Top = 152
        Width = 417
        Height = 21
        TabOrder = 4
      end
      object edtConnName: TEdit
        Left = 124
        Top = 101
        Width = 120
        Height = 21
        TabOrder = 5
        OnChange = edtConnNameChange
      end
    end
    object tsEncryption: TTabSheet
      Caption = 'Encryption'
      ImageIndex = 1
      object Label1: TLabel
        Left = 16
        Top = 83
        Width = 22
        Height = 13
        Caption = 'Text'
      end
      object Label2: TLabel
        Left = 16
        Top = 107
        Width = 18
        Height = 13
        Caption = 'Key'
      end
      object Label3: TLabel
        Left = 16
        Top = 179
        Width = 74
        Height = 13
        Caption = 'Encrypted Text'
      end
      object LblText: TLabel
        Left = 208
        Top = 216
        Width = 75
        Height = 13
        Caption = 'Decrypted Text'
      end
      object edtKey: TEdit
        Left = 104
        Top = 104
        Width = 249
        Height = 21
        TabOrder = 0
        Text = 'Password'
      end
      object edtEncrypted: TEdit
        Left = 104
        Top = 176
        Width = 249
        Height = 21
        TabOrder = 1
      end
      object edtText: TEdit
        Left = 104
        Top = 80
        Width = 249
        Height = 21
        TabOrder = 2
      end
      object btnEncrypt: TButton
        Left = 104
        Top = 139
        Width = 89
        Height = 25
        Caption = 'Get Encryption'
        TabOrder = 3
        OnClick = btnEncryptClick
      end
      object btnDecrypt: TButton
        Left = 104
        Top = 211
        Width = 89
        Height = 25
        Caption = 'DeCrypt Check'
        TabOrder = 4
        OnClick = btnDecryptClick
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 443
    Width = 479
    Height = 19
    Panels = <
      item
        Width = 50
      end>
  end
  object ActionManager1: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Action = actCheck
            Caption = '&Check/Save New Connection'
          end
          item
            Action = actTestSaved
            Caption = '&Test Saved Connection'
          end>
      end
      item
        Items = <
          item
            Action = actGetConnection
            Caption = '&Get Saved Connection String'
          end
          item
            Caption = '-'
          end
          item
            Action = actTestSaved
            Caption = '&Test Saved Connection'
          end
          item
            Caption = '-'
          end
          item
            Action = actCheck
            Caption = '&Check/Save New Connection'
          end>
        ActionBar = ActionToolBar1
      end>
    Left = 408
    Top = 157
    StyleName = 'XP Style'
    object actCheck: TAction
      Caption = 'Check/Save New Connection'
      OnExecute = actCheckExecute
    end
    object actTestSaved: TAction
      Caption = 'Test Saved Connection'
      OnExecute = actTestSavedExecute
    end
    object actGetConnection: TAction
      Caption = 'Get Saved Connection String'
      OnExecute = actGetConnectionExecute
    end
  end
  object dbConn: TADOConnection
    LoginPrompt = False
    Left = 264
    Top = 153
  end
  object PathDialog1: TJvSelectDirectory
    Left = 416
    Top = 88
  end
  object jvEncrypt: TJvVigenereCipher
    Left = 408
    Top = 221
  end
end