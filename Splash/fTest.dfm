object frmTest: TfrmTest
  Left = 0
  Top = 0
  Caption = 'frmTest'
  ClientHeight = 264
  ClientWidth = 407
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 48
    Top = 128
    Width = 22
    Height = 13
    Caption = 'Path'
  end
  object Button1: TButton
    Left = 40
    Top = 80
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 40
    Top = 40
    Width = 321
    Height = 21
    TabOrder = 1
    Text = '1234, 56789'
  end
  object edtS: TEdit
    Left = 40
    Top = 13
    Width = 121
    Height = 21
    TabOrder = 2
    Text = '10000'
  end
  object edtPath: TEdit
    Left = 48
    Top = 152
    Width = 281
    Height = 21
    TabOrder = 3
  end
  object btnStart: TButton
    Left = 48
    Top = 192
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 4
    OnClick = btnStartClick
  end
  object btnStop: TButton
    Left = 48
    Top = 224
    Width = 75
    Height = 25
    Caption = 'Stop'
    TabOrder = 5
    OnClick = btnStopClick
  end
  object tmr: TTimer
    Enabled = False
    Interval = 30000
    OnTimer = tmrTimer
    Left = 352
    Top = 184
  end
  object Exonet: TExonet
    Alias = 'AGL'
    Login = 'Richard'
    Password = 'qwertyui'
    ClarityPath = '\\win2k3s2\accounts\Exonet\'
    Operation = exoPreview
    Pages = 1
    Left = 352
    Top = 120
  end
end
