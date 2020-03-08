object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'frmMain'
  ClientHeight = 305
  ClientWidth = 612
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 73
    Width = 612
    Height = 213
    Align = alClient
    Lines.Strings = (
      '<resultset>'
      '<product><sku>01291</sku><price>0.05</price></product>'
      '</resultset>')
    TabOrder = 0
    ExplicitTop = 46
    ExplicitHeight = 240
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 612
    Height = 73
    Align = alTop
    TabOrder = 1
    object Button1: TButton
      Left = 453
      Top = 15
      Width = 49
      Height = 17
      Caption = 'Get'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 453
      Top = 0
      Width = 49
      Height = 17
      Caption = 'Address'
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 207
      Top = 11
      Width = 62
      Height = 25
      Caption = 'Zeald Get'
      TabOrder = 2
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 453
      Top = 29
      Width = 49
      Height = 17
      Caption = 'Currency'
      TabOrder = 3
      OnClick = Button4Click
    end
    object edtTable: TEdit
      Left = 16
      Top = 12
      Width = 121
      Height = 21
      TabOrder = 4
      Text = 'Product'
    end
    object edtID: TEdit
      Left = 144
      Top = 12
      Width = 57
      Height = 21
      TabOrder = 5
      Text = '01245'
    end
    object btnPostPrice: TButton
      Left = 272
      Top = 10
      Width = 82
      Height = 25
      Caption = 'Zeald Post Price'
      TabOrder = 6
      OnClick = btnPostPriceClick
    end
    object btnPostInv: TButton
      Left = 357
      Top = 10
      Width = 82
      Height = 25
      Caption = 'Zeald Post Inv'
      TabOrder = 7
      OnClick = btnPostInvClick
    end
    object Button5: TButton
      Left = 508
      Top = 15
      Width = 75
      Height = 25
      Caption = 'Wilton W'
      TabOrder = 8
      OnClick = Button5Click
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 286
    Width = 612
    Height = 19
    Panels = <>
    SimplePanel = True
    SimpleText = 'Test'
  end
  object Button6: TButton
    Left = 207
    Top = 41
    Width = 75
    Height = 25
    Caption = 'Button6'
    TabOrder = 3
    OnClick = Button6Click
  end
  object IdHTTP1: TIdHTTP
    Intercept = IdLogFile1
    IOHandler = IdSSLIOHandlerSocketOpenSSL1
    AllowCookies = True
    ProxyParams.BasicAuthentication = True
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.Accept = 'text/html,text/xml, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 
      'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20100101 Fire' +
      'fox/12.0'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoInProcessAuth, hoForceEncodeParams]
    OnAuthorization = IdHTTP1Authorization
    Left = 112
    Top = 144
  end
  object IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL
    OnStatus = IdSSLIOHandlerSocketOpenSSL1Status
    Intercept = IdLogFile1
    MaxLineAction = maException
    Port = 0
    DefaultPort = 443
    SSLOptions.Method = sslvSSLv23
    SSLOptions.SSLVersions = [sslvSSLv2, sslvSSLv3, sslvTLSv1]
    SSLOptions.Mode = sslmUnassigned
    SSLOptions.VerifyMode = []
    SSLOptions.VerifyDepth = 0
    Left = 200
    Top = 208
  end
  object SoapConnection1: TSoapConnection
    Agent = 'CodeGear SOAP 1.3'
    Connected = True
    Password = '5ervice2013'
    URL = 'http://ce-dev/bobux.com/soap/'
    SOAPServerIID = 'IAppServerSOAP - {C99F4735-D6D2-495C-8CA2-E53E5A439E61}'
    UserName = 'BobuxAcclaim'
    UseSOAPAdapter = True
    Left = 424
    Top = 112
  end
  object HTTPRIO1: THTTPRIO
    HTTPWebNode.UseUTF8InHeader = True
    HTTPWebNode.InvokeOptions = [soIgnoreInvalidCerts, soAutoCheckAccessPointViaUDDI]
    HTTPWebNode.WebNodeOptions = []
    Converter.Options = [soSendMultiRefObj, soTryAllSchema, soRootRefNodesToBody, soCacheMimeResponse, soUTF8EncodeXML]
    Left = 424
    Top = 168
  end
  object WSDLHTMLPublish1: TWSDLHTMLPublish
    WebDispatch.MethodType = mtAny
    WebDispatch.PathInfo = 'wsdl*'
    TargetNamespace = 'http://http://ce-dev.bobux.com/api/soap/?wsdl'
    Left = 424
    Top = 64
  end
  object IdLogFile1: TIdLogFile
    Filename = 'IPLog.Txt'
    Left = 264
    Top = 136
  end
  object XMLDocument1: TXMLDocument
    Options = [doNodeAutoCreate, doNodeAutoIndent, doAttrNull, doAutoPrefix, doNamespaceDecl]
    Left = 520
    Top = 176
    DOMVendorDesc = 'MSXML'
  end
end
