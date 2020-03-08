object dmMain: TdmMain
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 333
  Top = 160
  Height = 332
  Width = 432
  object idsReg: TIDSRegistry
    Enabled = True
    RootKey = bkHKEY_LOCAL_MACHINE
    DeveloperName = 'Acclaim'
    ProgramName = 'AutoCall'
    EncryptionKey = 0
    CanCreate = True
    Left = 20
    Top = 108
  end
  object idsFile: TIDSLogToFile
    Overwrite = False
    TimeStampDelimiter.DelimiterOption = doColon
    TimeStampFormatter.TimeStampFormatOption = foDDDD_MMMM_D_YYYY_HH_NN_AM_PM
    UseTimeStamp = True
    UseNewLine = True
    UseNewLineTStr = True
    Left = 80
    Top = 108
  end
  object idsVer: TIDSShowVersion
    ProjectName = 'C:\PROJECTS\JAE Group\Auto Call Centre Service\AutoCallSvr.exe'
    Left = 152
    Top = 108
  end
  object Tmr: TTimer
    Enabled = False
    Interval = 3600000
    OnTimer = TmrTimer
    Left = 216
    Top = 116
  end
  object qryGeneral: TmySQLQuery
    Database = MySQLdb
    Left = 104
    Top = 16
  end
  object MySQLdb: TmySQLDatabase
    ConnectOptions = [coCompress]
    Params.Strings = (
      'Port=3306'
      'TIMEOUT=30'
      'UID=carpetc'
      'PWD=pass01'
      'Host=hostingdatabases.orcon.net.nz')
    Left = 32
    Top = 24
  end
  object POP3: TNMPOP3
    Port = 110
    TimeOut = 60000
    ReportLevel = 0
    OnDisconnect = POP3Disconnect
    OnConnect = POP3Connect
    OnInvalidHost = POP3InvalidHost
    OnHostResolved = POP3HostResolved
    OnStatus = POP3Status
    OnConnectionFailed = POP3ConnectionFailed
    OnConnectionRequired = POP3ConnectionRequired
    OnPacketRecvd = POP3PacketRecvd
    Parse = False
    DeleteOnRead = False
    OnAuthenticationNeeded = POP3AuthenticationNeeded
    OnAuthenticationFailed = POP3AuthenticationFailed
    OnReset = POP3Reset
    OnList = POP3List
    OnRetrieveStart = POP3RetrieveStart
    OnRetrieveEnd = POP3RetrieveEnd
    OnSuccess = POP3Success
    OnFailure = POP3Failure
    OnDecodeStart = POP3DecodeStart
    OnDecodeEnd = POP3DecodeEnd
    Left = 24
    Top = 176
  end
  object SMTP: TNMSMTP
    Host = 'smtp.xtra.co.nz'
    Port = 25
    ReportLevel = 0
    OnDisconnect = SMTPDisconnect
    OnConnect = SMTPConnect
    OnInvalidHost = SMTPInvalidHost
    OnHostResolved = SMTPHostResolved
    OnStatus = SMTPStatus
    OnConnectionFailed = SMTPConnectionFailed
    OnPacketSent = SMTPPacketSent
    OnConnectionRequired = SMTPConnectionRequired
    PostMessage.LocalProgram = 'autocall'
    EncodeType = uuMime
    ClearParams = True
    SubType = mtPlain
    Charset = 'us-ascii'
    OnRecipientNotFound = SMTPRecipientNotFound
    OnHeaderIncomplete = SMTPHeaderIncomplete
    OnSendStart = SMTPSendStart
    OnSuccess = SMTPSuccess
    OnFailure = SMTPFailure
    OnEncodeStart = SMTPEncodeStart
    OnEncodeEnd = SMTPEncodeEnd
    OnMailListReturn = SMTPMailListReturn
    OnAttachmentNotFound = SMTPAttachmentNotFound
    OnAuthenticationFailed = SMTPAuthenticationFailed
    Left = 124
    Top = 176
  end
  object qryGeneral2: TmySQLQuery
    Database = MySQLdb
    Left = 160
    Top = 16
  end
  object qryGeneral3: TmySQLQuery
    Database = MySQLdb
    Left = 224
    Top = 16
  end
  object qrySMS: TmySQLQuery
    Database = MySQLdb
    Left = 296
    Top = 16
  end
  object qryMoreInfo: TmySQLQuery
    Database = MySQLdb
    SQL.Strings = (
      'SELECT SEQNO, JOBNO, CELLPHONE, PARTREQUIRED'
      'FROM X_SMS_REQUEST '
      'WHERE ISOUTSTANDING = '#39'Y'#39' ORDER BY RECEIVED')
    Left = 364
    Top = 24
  end
  object qryUpdate: TmySQLQuery
    Database = MySQLdb
    Left = 368
    Top = 76
  end
end
