object frmAutoForm: TfrmAutoForm
  Left = 473
  Top = 15
  Width = 354
  Height = 524
  Caption = 'CC Email Processor'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBottom: TPanel
    Left = 0
    Top = 448
    Width = 346
    Height = 23
    Align = alBottom
    TabOrder = 0
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 471
    Width = 346
    Height = 19
    Panels = <>
    SimplePanel = False
  end
  object ListBox1: TListBox
    Left = 0
    Top = 41
    Width = 346
    Height = 407
    Align = alClient
    Font.Charset = OEM_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Terminal'
    Font.Style = []
    ItemHeight = 12
    ParentFont = False
    TabOrder = 2
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 346
    Height = 41
    Align = alTop
    Caption = 'Test'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    OnClick = pnlTopClick
  end
end
