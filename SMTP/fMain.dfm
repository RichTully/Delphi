object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Send Email Test'
  ClientHeight = 216
  ClientWidth = 426
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 72
    Width = 22
    Height = 13
    Caption = 'Host'
  end
  object Label2: TLabel
    Left = 24
    Top = 99
    Width = 22
    Height = 13
    Caption = 'User'
  end
  object Label3: TLabel
    Left = 24
    Top = 126
    Width = 20
    Height = 13
    Caption = 'Port'
  end
  object Label4: TLabel
    Left = 24
    Top = 11
    Width = 12
    Height = 13
    Caption = 'To'
  end
  object Label5: TLabel
    Left = 24
    Top = 38
    Width = 24
    Height = 13
    Caption = 'From'
  end
  object Label6: TLabel
    Left = 288
    Top = 16
    Width = 36
    Height = 13
    Caption = 'Subject'
  end
  object Label7: TLabel
    Left = 288
    Top = 69
    Width = 24
    Height = 13
    Caption = 'Body'
  end
  object LblTmr: TLabel
    Left = 336
    Top = 192
    Width = 6
    Height = 13
    Caption = '0'
  end
  object edthost: TEdit
    Left = 72
    Top = 69
    Width = 177
    Height = 21
    TabOrder = 0
    Text = 'send.xtra.co.nz'
  end
  object edtuser: TEdit
    Left = 72
    Top = 96
    Width = 177
    Height = 21
    TabOrder = 1
    Text = 'richard.tully'
  end
  object edtPort: TEdit
    Left = 72
    Top = 123
    Width = 25
    Height = 21
    TabOrder = 2
    Text = '465'
  end
  object edtto: TEdit
    Left = 72
    Top = 8
    Width = 177
    Height = 21
    TabOrder = 3
    Text = 'richard@acclaimgroup.co.nz'
  end
  object edtFrom: TEdit
    Left = 72
    Top = 35
    Width = 177
    Height = 21
    TabOrder = 4
    Text = 'richard.tully@xtra.co.nz'
  end
  object btnSend: TButton
    Left = 72
    Top = 167
    Width = 75
    Height = 25
    Caption = 'Send'
    TabOrder = 5
    OnClick = btnSendClick
  end
  object edtSubj: TEdit
    Left = 288
    Top = 35
    Width = 113
    Height = 21
    TabOrder = 6
    Text = 'TEST'
  end
  object mmoBody: TMemo
    Left = 288
    Top = 88
    Width = 113
    Height = 89
    Lines.Strings = (
      'testing testing '
      'testing')
    TabOrder = 7
  end
  object edtPass: TEdit
    Left = 128
    Top = 123
    Width = 121
    Height = 21
    PasswordChar = '*'
    TabOrder = 8
    Text = 'abc123'
  end
  object SMTP1: TIdSMTP
    OnStatus = SMTP1Status
    IOHandler = IdSSLIOHandlerSocketOpenSSL1
    OnDisconnected = SMTP1Disconnected
    OnWork = SMTP1Work
    OnWorkBegin = SMTP1WorkBegin
    OnWorkEnd = SMTP1WorkEnd
    OnConnected = SMTP1Connected
    MailAgent = 'SMTPTest'
    OnFailedRecipient = SMTP1FailedRecipient
    AuthType = satSASL
    Password = 'Acclaim1'
    SASLMechanisms = <>
    UseTLS = utUseExplicitTLS
    OnTLSNotAvailable = SMTP1TLSNotAvailable
    Left = 184
    Top = 160
  end
  object SMTPMsg: TIdMessage
    AttachmentEncoding = 'UUE'
    BccList = <>
    CharSet = 'us-ascii'
    CCList = <>
    ContentType = 'text/html'
    Encoding = meDefault
    FromList = <
      item
      end>
    Recipients = <>
    ReplyTo = <>
    ConvertPreamble = True
    Left = 224
    Top = 160
  end
  object IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL
    OnStatus = IdSSLIOHandlerSocketOpenSSL1Status
    Destination = ':25'
    MaxLineAction = maException
    Port = 25
    DefaultPort = 0
    SSLOptions.Mode = sslmUnassigned
    SSLOptions.VerifyMode = []
    SSLOptions.VerifyDepth = 0
    OnStatusInfo = IdSSLIOHandlerSocketOpenSSL1StatusInfo
    OnStatusInfoEx = IdSSLIOHandlerSocketOpenSSL1StatusInfoEx
    OnGetPassword = IdSSLIOHandlerSocketOpenSSL1GetPassword
    OnGetPasswordEx = IdSSLIOHandlerSocketOpenSSL1GetPasswordEx
    OnVerifyPeer = IdSSLIOHandlerSocketOpenSSL1VerifyPeer
    Left = 248
    Top = 80
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 272
    Top = 152
  end
end