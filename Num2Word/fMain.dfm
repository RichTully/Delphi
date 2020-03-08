object Form6: TForm6
  Left = 0
  Top = 0
  Caption = 'Form6'
  ClientHeight = 417
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 536
    Top = 8
    Width = 75
    Height = 25
    Caption = 'generate'
    TabOrder = 0
    OnClick = Button1Click
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 0
    Width = 530
    Height = 417
    Align = alLeft
    DataSource = DataSource1
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnTitleClick = DBGrid1TitleClick
    Columns = <
      item
        Expanded = False
        FieldName = 'SeqNo'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Num'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Name'
        Visible = True
      end>
  end
  object Button2: TButton
    Left = 536
    Top = 72
    Width = 75
    Height = 25
    Caption = 'Save'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 536
    Top = 41
    Width = 75
    Height = 25
    Caption = 'Read'
    TabOrder = 3
    OnClick = Button3Click
  end
  object cds: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 432
    Top = 72
    object cdsSeqNo: TIntegerField
      FieldName = 'SeqNo'
    end
    object cdsNum: TIntegerField
      FieldName = 'Num'
    end
    object cdsName: TStringField
      FieldName = 'Name'
      Size = 60
    end
  end
  object DataSource1: TDataSource
    DataSet = cds
    Left = 432
    Top = 168
  end
end
