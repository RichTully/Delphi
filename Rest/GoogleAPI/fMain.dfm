object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'frmMain'
  ClientHeight = 299
  ClientWidth = 635
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
  object btnSheet: TButton
    Left = 56
    Top = 24
    Width = 75
    Height = 25
    Caption = 'Get Sheets'
    TabOrder = 0
    OnClick = btnSheetClick
  end
  object ListBox1: TListBox
    Left = 56
    Top = 64
    Width = 409
    Height = 73
    ItemHeight = 13
    TabOrder = 1
  end
  object IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL
    MaxLineAction = maException
    Port = 0
    DefaultPort = 0
    SSLOptions.Mode = sslmUnassigned
    SSLOptions.VerifyMode = []
    SSLOptions.VerifyDepth = 0
    Left = 344
    Top = 152
  end
  object XMLDocument1: TXMLDocument
    Left = 424
    Top = 56
  end
end