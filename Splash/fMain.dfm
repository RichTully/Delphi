object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'frmMain'
  ClientHeight = 232
  ClientWidth = 505
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 505
    Height = 65
    Align = alTop
    TabOrder = 0
    object Button1: TButton
      Left = 24
      Top = 24
      Width = 75
      Height = 25
      Caption = 'Orders'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 200
      Top = 21
      Width = 89
      Height = 25
      Caption = 'Check Customers'
      TabOrder = 1
      OnClick = Button2Click
    end
    object btnIntegrated: TButton
      Left = 336
      Top = 34
      Width = 129
      Height = 25
      Caption = 'Set Web Ord integrated'
      TabOrder = 2
      OnClick = btnIntegratedClick
    end
    object edtOrd: TEdit
      Left = 336
      Top = 7
      Width = 73
      Height = 21
      TabOrder = 3
      Text = 'ORD0000855'
    end
    object cbInt: TComboBox
      Left = 415
      Top = 7
      Width = 50
      Height = 21
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 4
      Text = 'false'
      Items.Strings = (
        'false'
        'true')
    end
  end
  object Memo1: TMemo
    Left = 0
    Top = 65
    Width = 505
    Height = 148
    Align = alClient
    TabOrder = 1
    ExplicitHeight = 167
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 213
    Width = 505
    Height = 19
    Panels = <
      item
        Width = 50
      end>
    ExplicitLeft = 32
    ExplicitTop = 192
    ExplicitWidth = 0
  end
  object IdHTTP1: TIdHTTP
    OnStatus = IdHTTP1Status
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    HTTPOptions = [hoForceEncodeParams]
    Left = 424
    Top = 56
  end
  object ADOConnection1: TADOConnection
    ConnectionString = 
      'Provider=SQLNCLI.1;Password=masterkey;Persist Security Info=True' +
      ';User ID=sa;Initial Catalog=Splash;Data Source=Bob\SQL2008R2'
    Provider = 'SQLNCLI.1'
    Left = 416
    Top = 88
  end
  object qryGen: TADOQuery
    Connection = ADOConnection1
    Parameters = <>
    Left = 424
    Top = 136
  end
end
