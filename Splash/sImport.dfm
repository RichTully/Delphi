object SplashWebExo: TSplashWebExo
  OldCreateOrder = False
  DisplayName = 'SplashWebExo'
  Interactive = True
  OnExecute = ServiceExecute
  OnStart = ServiceStart
  OnStop = ServiceStop
  Height = 408
  Width = 642
  object dbExonet: TADOConnection
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=masterkey;Persist Security Info=Tru' +
      'e;User ID=sa;Initial Catalog=TVUpgrade;Data Source=Bob;Use Proce' +
      'dure for Prepare=1;Auto Translate=True;Packet Size=4096;Workstat' +
      'ion ID=TULLY1-PC;Use Encryption for Data=False;Tag with column c' +
      'ollation when possible=False'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 40
    Top = 16
  end
  object qryExo: TADOQuery
    Connection = dbExonet
    Parameters = <>
    Left = 96
    Top = 16
  end
  object tmr: TTimer
    Enabled = False
    OnTimer = tmrTimer
    Left = 208
    Top = 24
  end
  object SMTP: TIdSMTP
    OnStatus = SMTPStatus
    SASLMechanisms = <>
    Left = 272
    Top = 112
  end
  object SMTPMsg: TIdMessage
    AttachmentEncoding = 'UUE'
    BccList = <>
    CCList = <>
    ContentType = 'Multipart/mixed'
    Encoding = meDefault
    FromList = <
      item
      end>
    Recipients = <>
    ReplyTo = <>
    ConvertPreamble = True
    Left = 272
    Top = 168
  end
  object FTP: TIdFTP
    IPVersion = Id_IPv4
    NATKeepAlive.UseKeepAlive = False
    NATKeepAlive.IdleTimeMS = 0
    NATKeepAlive.IntervalMS = 0
    ProxySettings.ProxyType = fpcmNone
    ProxySettings.Port = 0
    Left = 336
    Top = 112
  end
  object cdsGeneral: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 96
    Top = 120
  end
  object dspExo: TDataSetProvider
    DataSet = qryExo
    Left = 96
    Top = 64
  end
  object cdsPrint: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspPrint'
    Left = 392
    Top = 304
  end
  object qryPrint: TADOQuery
    Connection = dbExonet
    CursorType = ctStatic
    Parameters = <>
    Left = 392
    Top = 208
  end
  object dspPrint: TDataSetProvider
    DataSet = qryPrint
    Left = 392
    Top = 256
  end
  object cdsGeneralInfo: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 304
    Top = 304
    object cdsGeneralInfoUserName: TStringField
      FieldName = 'UserName'
      Size = 40
    end
    object cdsGeneralInfoAddress1: TStringField
      FieldName = 'Address1'
      Size = 40
    end
    object cdsGeneralInfoAddress2: TStringField
      FieldName = 'Address2'
      Size = 40
    end
    object cdsGeneralInfoAddress3: TStringField
      FieldName = 'Address3'
      Size = 40
    end
    object cdsGeneralInfoBank_Acc_No: TStringField
      FieldName = 'Bank_Acc_No'
      Size = 40
    end
    object cdsGeneralInfoBank_Acc_Name: TStringField
      FieldName = 'Bank_Acc_Name'
      Size = 40
    end
    object cdsGeneralInfoPhone: TStringField
      FieldName = 'Phone'
      Size = 40
    end
    object cdsGeneralInfoFax: TStringField
      FieldName = 'Fax'
      Size = 40
    end
    object cdsGeneralInfoEmail: TStringField
      FieldName = 'Email'
      Size = 60
    end
    object cdsGeneralInfoDelivAddr1: TStringField
      FieldName = 'DelivAddr1'
      Size = 40
    end
    object cdsGeneralInfoDelivAddr2: TStringField
      FieldName = 'DelivAddr2'
      Size = 40
    end
    object cdsGeneralInfoDelivAddr3: TStringField
      FieldName = 'DelivAddr3'
      Size = 40
    end
    object cdsGeneralInfoDelivAddr4: TStringField
      FieldName = 'DelivAddr4'
      Size = 40
    end
    object cdsGeneralInfoTaxRegNo: TStringField
      FieldName = 'TaxRegNo'
      Size = 30
    end
    object cdsGeneralInfoWebSite: TStringField
      FieldName = 'WebSite'
      Size = 60
    end
  end
  object IdHTTP1: TIdHTTP
    OnStatus = IdHTTP1Status
    AllowCookies = True
    ProtocolVersion = pv1_0
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 96
    Top = 192
  end
  object cdsSOH: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 56
    Top = 272
    object cdsSOHALPHACODE: TStringField
      FieldName = 'ALPHACODE'
      Size = 12
    end
    object cdsSOHACCNO: TIntegerField
      FieldName = 'ACCNO'
    end
    object cdsSOHDUEDATE: TDateTimeField
      FieldName = 'DUEDATE'
    end
    object cdsSOHORDERDATE: TDateTimeField
      FieldName = 'ORDERDATE'
    end
    object cdsSOHCUSTORDERNO: TStringField
      FieldName = 'CUSTORDERNO'
    end
    object cdsSOHREFERENCE: TStringField
      FieldName = 'REFERENCE'
    end
    object cdsSOHSUBTOTAL: TFloatField
      FieldName = 'SUBTOTAL'
    end
    object cdsSOHTAXTOTAL: TFloatField
      FieldName = 'TAXTOTAL'
    end
    object cdsSOHX_WEBORD_NO: TStringField
      FieldName = 'X_WEBORD_NO'
      Size = 12
    end
    object cdsSOHADDRESS1: TStringField
      FieldName = 'ADDRESS1'
      Size = 30
    end
    object cdsSOHADDRESS2: TStringField
      FieldName = 'ADDRESS2'
      Size = 30
    end
    object cdsSOHADDRESS3: TStringField
      FieldName = 'ADDRESS3'
      Size = 30
    end
    object cdsSOHADDRESS4: TStringField
      FieldName = 'ADDRESS4'
      Size = 30
    end
    object cdsSOHADDRESS5: TStringField
      FieldName = 'ADDRESS5'
      Size = 30
    end
    object cdsSOHADDRESS6: TStringField
      FieldName = 'ADDRESS6'
      Size = 30
    end
    object cdsSOHSALESNO: TIntegerField
      FieldName = 'SALESNO'
    end
    object cdsSOHNARRATIVE_SEQNO: TIntegerField
      FieldName = 'NARRATIVE_SEQNO'
    end
    object cdsSOHONHOLD: TStringField
      FieldName = 'ONHOLD'
      Size = 1
    end
    object cdsSOHNARRATIVE: TStringField
      FieldName = 'NARRATIVE'
      Size = 1000
    end
    object cdsSOHFREIGHT: TFloatField
      FieldName = 'FREIGHT'
    end
  end
  object cdsSOL: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 56
    Top = 328
    object cdsSOLHDR_SEQNO: TIntegerField
      FieldName = 'HDR_SEQNO'
    end
    object cdsSOLACCNO: TIntegerField
      FieldName = 'ACCNO'
    end
    object cdsSOLSTOCKCODE: TStringField
      FieldName = 'STOCKCODE'
      Size = 23
    end
    object cdsSOLDESCRIPTION: TStringField
      FieldName = 'DESCRIPTION'
      Size = 40
    end
    object cdsSOLORD_QUANT: TFloatField
      FieldName = 'ORD_QUANT'
    end
    object cdsSOLUNITPRICE: TFloatField
      FieldName = 'UNITPRICE'
    end
    object cdsSOLTAXRATE: TFloatField
      FieldName = 'TAXRATE'
    end
    object cdsSOLTAXRATE_NO: TIntegerField
      FieldName = 'TAXRATE_NO'
    end
    object cdsSOLLINKED_STOCKCODE: TStringField
      FieldName = 'LINKED_STOCKCODE'
      Size = 23
    end
    object cdsSOLLINKED_QTY: TFloatField
      FieldName = 'LINKED_QTY'
    end
    object cdsSOLLINKEDSTATUS: TStringField
      FieldName = 'LINKEDSTATUS'
      Size = 1
    end
    object cdsSOLSubTotal: TFloatField
      FieldName = 'SubTotal'
    end
  end
end
