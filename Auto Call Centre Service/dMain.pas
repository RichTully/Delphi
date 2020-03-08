unit dMain;

interface

uses
  SysUtils, Classes, IDSRegistry, DB, ADODB, IDSLogToFile, ExtCtrls,
  ShowVersion, mySQLDbTables, Dialogs, Psock, NMpop3, NMsmtp;

type
  TEMailData = record
    Subject: String;
    Body: String;
    Provider: String;
    ProcessType: integer;
    Date: String;
    Time: String;
    From: String;
    Name: string;
    Address: String;
    Suburb: String;
    City: String;
    HomePhone: String;
    WorkPhone: String;
    MobilePhone: String;
    Claim: String;
    Risk: String;
    Brand: String;
    Description: String;
    SpecialIns: String;
    RegKind:String;      // Home or Contents from IAG - D or C in table (D-welling)
    Excess: String;
    Excess_Ref: String;
    Urgency: String;
    Service: String;
    Area: String;
    InsuredName: String;
    Email: String;
    Country: String;
    Assessor: String;
    AssessorEMail: String;
    AssessorPhone: String;
    AssessorMobile: String;
    Tenanted: String;
    TenantDetail: String;
    AfterHours: String;
    OtherDesc: String;
    ItemNo: String;
    AItemNo: String;
    AReason: String;
    ItemType: String;
    Coverage: String;
    Salvage: String;
    Loc: String;
    Comment: String;                                        
    ItemDesc: String;
    //LossAdjuster: String;
    //ServiceSpecifics: String;
    //AreaSpecifics: String;
    //RequestID: String;
    CityNo: Integer;
    CityCnt: Integer;
    BranchNo: Integer;
    StreetNo: integer;
    StreetName: String;
    InBoxSeqNo: Integer;
    IsTruncated: string;
    Policy: String;
    ReadErr: Boolean;
  end;
type
  TdmMain = class(TDataModule)
    idsReg: TIDSRegistry;
    idsFile: TIDSLogToFile;
    idsVer: TIDSShowVersion;
    Tmr: TTimer;
    qryGeneral: TmySQLQuery;
    MySQLdb: TmySQLDatabase;
    POP3: TNMPOP3;
    SMTP: TNMSMTP;
    qryGeneral2: TmySQLQuery;
    qryGeneral3: TmySQLQuery;
    qrySMS: TmySQLQuery;
    qryMoreInfo: TmySQLQuery;
    qryUpdate: TmySQLQuery;
    procedure DataModuleDestroy(Sender: TObject);
    procedure TmrTimer(Sender: TObject);
    procedure POP3List(Msg, Size: Integer);
    procedure DataModuleCreate(Sender: TObject);
    procedure POP3RetrieveStart(Sender: TObject);
    procedure POP3RetrieveEnd(Sender: TObject);
    procedure POP3Connect(Sender: TObject);
    procedure POP3Disconnect(Sender: TObject);
    procedure POP3Failure(Sender: TObject);
    procedure POP3ConnectionRequired(var Handled: Boolean);
    procedure POP3ConnectionFailed(Sender: TObject);
    procedure POP3AuthenticationNeeded(var Handled: Boolean);
    procedure POP3Status(Sender: TComponent; Status: String);
    procedure POP3AuthenticationFailed(var Handled: Boolean);
    procedure POP3InvalidHost(var Handled: Boolean);
    procedure POP3PacketRecvd(Sender: TObject);
    procedure POP3Reset(Sender: TObject);
    procedure POP3DecodeStart(var FileName: String);
    procedure POP3DecodeEnd(Sender: TObject);
    procedure POP3HostResolved(Sender: TComponent);
    procedure POP3Success(Sender: TObject);
    procedure SMTPAttachmentNotFound(Filename: String);
    procedure SMTPAuthenticationFailed(var Handled: Boolean);
    procedure SMTPConnect(Sender: TObject);
    procedure SMTPConnectionFailed(Sender: TObject);
    procedure SMTPConnectionRequired(var Handled: Boolean);
    procedure SMTPDisconnect(Sender: TObject);
    procedure SMTPEncodeEnd(Filename: String);
    procedure SMTPEncodeStart(Filename: String);
    procedure SMTPFailure(Sender: TObject);
    procedure SMTPHeaderIncomplete(var handled: Boolean; hiType: Integer);
    procedure SMTPHostResolved(Sender: TComponent);
    procedure SMTPInvalidHost(var Handled: Boolean);
    procedure SMTPMailListReturn(MailAddress: String);
    procedure SMTPPacketSent(Sender: TObject);
    procedure SMTPRecipientNotFound(Recipient: String);
    procedure SMTPSendStart(Sender: TObject);
    procedure SMTPStatus(Sender: TComponent; Status: String);
    procedure SMTPSuccess(Sender: TObject);
  private
    { Private declarations }
    fWriteAll: Boolean;
    fComputer: integer;
    fInboxRecs: integer;
    fMsgCount: integer;
    fInterval: double;
    fResponse: double;
    fSupportCellNo: string;
    fUseSMS: Boolean;
    fMOParam: string;
    fUseReminder: Boolean;
    fClickATellAddress: string;
    fClickATell_api_id: string;
    fClickATell_UID: string;
    fClickATell_PWD: string;
    fClickATell_MO_NO: string;
    fLineCnt: integer;
    fExceptionSent: Boolean;
    fSeqNo : integer;
    fForwardAll: Boolean;
    fCanProcess: Boolean;
    procedure WriteToFile(S:String);
    procedure WriteIt(S:String; DoIt: Boolean);
    procedure GetProcessInterval;
    function ProcessRequired:Boolean;
    procedure Process;
    function EMailsExist: Boolean;
    function FetchEMail(msg: integer): TEmailData;
    function CanCreateJob(var EData: TEMailData): Boolean;
    function CreateJob(EData: TEMailData): integer;
    function GetBranch(EData: TEMailData): integer;
    procedure InformSupport(InfoType,JobNo: Integer; EData: TEMailData; EMail: Boolean);
    procedure SMSSupport(InfoType, JobNo: integer; EData: TEMailData);
    procedure EMailSupport(InfoType, JobNo: integer; EData: TEMailData);
    procedure SMSBranch(LastSent, JobNo: integer; HasEData: Boolean; EData: TEmailData);
    procedure DeleteEmail(i: Integer; IsValidMessage: Boolean);
    function MessageActionRequired: Boolean;
    procedure SendMoreInfo;
    procedure SendNextSMS;
    procedure SendReminders;
    function SaveMessage: integer;
    procedure SendEmailSMS(InfoType, JobNo, Response, ContactNo, OrderNo: integer; CellNo, Msg: string; ErrMsg: Boolean);
    procedure SendBranchEmail(InfoType, JobNo, Response, ContactNo, OrderNo: integer; CellNo, Msg: string; HasEData: Boolean; EData: TEMailData);
    //procedure SendBranchReminder(JobNo: Integer);
    procedure SendEMail(EAdd, Subj, FName:string; ABody: TStringList);
    procedure FixNumbers(var ToNum: string; var FromNum: string);
    procedure SendSMS(SendTo, ReplyNo: string; ABody: TStringList);
    procedure ForwardToSupport;
    procedure SetFlag;
    procedure UpdateServiceLog(Msg, ProcName: String);
    procedure LimitInBox;
    procedure UpdateOutstanding;
    procedure ChkLen(EData: TEmailData);
    function ifb(AStr, DefStr: string): string;
    function zifb(AStr: string): string;
  public
    { Public declarations }
    FormBased: Boolean;
    function GetRegSettings(StartTimer:Boolean): Boolean;
    procedure WriteIf(S: String);
    procedure UpdateLogTable(AStr: String);
  end;

var
  dmMain: TdmMain;

{$DEFINE ISCC}              
//{$UNDEF  ISCC}
// UNDEF  Undefine IS Carpet Court ie comment out above line if Carpet Court

const
  SUPPORTCONTACTNO = 999999;
  //DEBUG = True;
  DEBUG = False;
{$IFDEF ISCC}
  SUPPORT = 37;
  CONAME = 'CC';
{$ELSE}
  SUPPORT = 5;
  CONAME = 'JAE';
{$ENDIF}

implementation

uses fAutoForm;

{$R *.dfm}

//==============================================================================
procedure TdmMain.WriteToFile(S:String);
begin
  WriteIt(S, True);
end;

//==============================================================================
procedure TdmMain.WriteIf(S:String);
begin
  WriteIt(S, fWriteAll);
end;

//==============================================================================
procedure TdmMain.WriteIt(S:String; DoIt: Boolean);
begin
  if DoIt then
  begin
    idsFile.Write(S);
    if FormBased then
    begin
      if fLineCnt > 500 then
      begin
        frmAutoForm.ListBox1.Clear;
        fLineCnt := 0;
      end;
      frmAutoForm.ListBox1.Items.Add(FormatDateTime('dd/mm/yy hh:nn:ss ',Now)+S);
      inc(fLineCnt);
    end;
  end;
end;

//==============================================================================
function TdmMain.GetRegSettings(StartTimer: Boolean): Boolean;
var
  Host, UID, PWD, dbName: string;
  Port, TimeOut: Integer;
  LogAll, msg, Client, fName: String;
begin
  //idsReg.ProgramName := 'AutoCall'+CONAME;
  Result := True;
  fWriteAll := False;
  //WriteToFile('Get Settings 0');
  try
    tmr.Enabled := False;
    fName := idsreg.ReadString('LogFile');
    // If the last 4 characters are ".log" strip them then add the date to the log filename and add ".log" again
    if UpperCase(Copy(fName,length(Fname)-3,4)) = '.LOG' then 
      fName := Copy(fName, 1, length(fName)-4)+FormatDateTime('-yyyy-mm-dd',Date)+'.log';
    idsFile.FileName := fName;
    WriteToFile(fName);
    msg := 'Insufficient database connection parameters';
    Host := idsReg.ReadString('MySQLHost');
    UID := idsReg.ReadString('MySQLUID');
    PWD := idsReg.ReadString('MySQLPWD');
    dbName := idsReg.ReadString('MySQLdbName');
    Port:= idsReg.ReadInteger('MySQLPort');
    TimeOut:= idsReg.ReadInteger('MySQLTimeOut');
    mySQLDB.Disconnect;
    mySQLDB.Params.Clear;
    mySQLDB.Params.Add('Port='+IntToStr(Port));
    mySQLDB.Params.Add('TIMEOUT='+IntToStr(TimeOut));
    mySQLDB.Params.Add('DatabaseName='+dbName);
    mySQLDB.Params.Add('UID='+UID);
    mySQLDB.Params.Add('PWD='+PWD);
    mySQLDB.Params.Add('Host='+Host);
    // Pop3 Mail
    msg := 'Insufficient Pop3 data';
    Pop3.Disconnect;
    Pop3.Host := idsReg.ReadString('Pop3Host');
    Pop3.UserID := idsReg.ReadString('Pop3Account');
    Pop3.Password := idsReg.ReadString('Pop3Password');
    Pop3.Port := idsReg.ReadInteger('Pop3Port');
    // SMTP
    msg := 'Insufficient SMTP data';
    //SMTP.Disconnect;
    //SMTP.ClearParameters;
    SMTP.Host := idsReg.ReadString('SMTPHost');
    SMTP.Port := idsReg.ReadInteger('SMTPPort');
    SMTP.UserID := idsReg.ReadString('SMTPUID');
    
    SMTP.PostMessage.FromName := idsReg.ReadString('SMTPFromName');
    SMTP.PostMessage.FromAddress := idsReg.ReadString('SMTPFromAddress');     // Any place this gets changed - must change it back to this default
    //SMTP.Host   := 'smtp.xtra.co.nz';
    //SMTP.UserID := 'richard.tully';
    // Additional Registry settings for use with Carpet Court
    // Do they use SMS
    fUseSMS := (idsReg.ReadString('UseSMS') = 'Y');
    try
      fMOParam := idsReg.ReadString('MOParam');
    except
      fMOParam := '0';
    end;
    // ************* Until we update the registry
    //fUseSMS := True;
    // Do they use Reminders
    
    fInboxRecs := idsReg.ReadInteger('InboxRecordLimit');     // -1 no limit
    fUseReminder := (idsReg.ReadString('UseReminder') = 'Y');
    // ************* Until we update the registry
    //fUseReminder := False;
    fForwardAll := (idsReg.ReadString('ForwardAll') = 'Y');
    try
      SMTP.Connect;
    except
      WriteToFile('Error Connecting to SMTP');
      Result := False;
      //Halt;
    end;
    SMTP.Disconnect;
    // Timer Interval
    msg := 'Invalid Timer data';
    Tmr.Interval := idsReg.ReadInteger('TInterval');
    // Computer
    msg := 'Invalid Computer # data';
    fComputer := idsReg.ReadInteger('Computer');
    WriteToFile('Computer '+IntToStr(fComputer));
    // Get Process Interval - values stored in private variables
    msg := 'Error getting Process Interval';
    GetProcessInterval;
  except
    WriteToFile(Msg);
    Result := False;
    exit;
  end;
  try
    try
      Client := idsReg.ReadString('Client');
{$IFDEF ISCC}
      if (UpperCase(Client) = 'CARPET COURT') then
        WriteToFile('CARPET COURT')
      else
      begin
        raise Exception.Create('Compiled for OTHER Client');
        Halt;
      end;
{$ELSE}
      if (UpperCase(Client) = 'JAE') then
        WriteToFile('JAE')
      else
      begin
        raise Exception.Create('Compiled for OTHER Client');
        Halt;
      end;
{$ENDIF}
      mySQLDB.Close;
      mySQLDB.Open;
      UpdateLogTable('Start up');
      WriteToFile('Connected');
      try
        LogAll := idsReg.ReadString('Log All');
      except
        LogAll := 'Y';
      end;
      fWriteAll := (LogAll = 'Y');
      if fWriteAll then
        WriteToFile(LogAll+'=True')
      else
        WriteToFile(LogAll+'=False');
    finally
      WriteIf('Enable Timer');
      Tmr.Enabled := StartTimer;   //True;
    end;
  except
    On E:Exception do
    begin
      WriteToFile(E.Message);
      UpdateLogTable('*** GetRegSettings '+E.Message);
      Result := False;
    end;
  end;
end;

procedure TdmMain.GetProcessInterval;
begin
  with qryGeneral do
  begin
    Close;
    SQL.Text := 'SELECT  PROCESSINTERVAL, RESPONSETIME, SUPPORTCELLNO, CLICKATELL_ADDRESS,'+
               ' CLICKATELL_API_ID, CLICKATELL_UID, CLICKATELL_PWD, CLICKATELL_MO_NO FROM X_GENERALINFO';
    Open;
    fInterval := FieldByName('PROCESSINTERVAL').AsFloat;
    fResponse := FieldByName('RESPONSETIME').AsFloat;
    fSupportCellNo := Trim(FieldByName('SUPPORTCELLNO').AsString);
    fClickATellAddress := Trim(FieldByName('CLICKATELL_ADDRESS').AsString);
    fClickATell_api_id := Trim(FieldByName('CLICKATELL_API_ID').AsString);
    fClickATell_UID := Trim(FieldByName('CLICKATELL_UID').AsString);
    fClickATell_PWD := Trim(FieldByName('CLICKATELL_PWD').AsString);
    fClickATell_MO_NO := Trim(FieldByName('CLICKATELL_MO_NO').AsString);
  end;
end;

//==============================================================================
procedure TdmMain.DataModuleDestroy(Sender: TObject);
begin
  UpdateLogTable('*** Shut down');
  mySQLDB.Free;
  WriteToFile('Service Close');
end;

//==============================================================================
procedure TdmMain.UpdateLogTable(AStr: String);
begin
  (*
  if mySQLDB.Connected then
    with qryGeneral do
    begin
      Close;
      SQL.Text := 'Insert into X_EmailLog (ReadString) Values ('+QuotedStr(Copy(AStr,1,100))+')';
      ExecSQL;
    end;
  *)
end;

//==============================================================================
procedure TdmMain.TmrTimer(Sender: TObject);
begin
  try
    Tmr.Enabled := False;
    if (not mySQLDB.Connected) or (not fCanProcess) then
      fCanProcess := GetRegSettings(False);
    WriteIf('Starting Process');
    if not fCanProcess then
      WriteIf('Can NOT process');
    if fCanProcess and ProcessRequired then
      Process;
  finally
    Tmr.Enabled := True;
    WriteIf('Process Complete');
  end;
end;

//==============================================================================            /
// This Function determines whether the computer in question should run the SMS process     /
// or leave it to another computer to do the job.                                           /
// Using the computerID (Integer from Registry) a record is inserted into X_PROCESSLOG      /
// If the difference between the time of insert and last processtime of a Processed record  /
// exceeds the interval (fInterval) then the actaul Processing goes ahead                   /
// If not then the Processed flag is set to false for the record in question                /
//==============================================================================            /
function TdmMain.ProcessRequired: Boolean;
var
  //TimeStr, DateStr: String;
  //MxSeq: Integer;
  ProcessTime, LastTime: TDateTime;
  LastProc, LastComp: Integer;
begin
  with qryGeneral do
  begin
    //Close;
    //SQL.Text := 'SELECT curdate() as DTE, curtime() AS TME FROM X_GENERALINFO';
    //Open;
    //TimeStr := FieldByName('TME').AsString;
    //DateStr := FieldByName('DTE').AsString;

    Close;
    //SQL.Text := 'INSERT INTO X_PROCESSLOG(COMPUTERID, PROCESSTIME, PROCESSED) VALUES ('+
    //             IntToStr(fComputer)+','+QuotedStr(DateStr+' '+TimeStr)+','+QuotedStr('Y')+')';
    // QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',NOW))
    SQL.Text := 'INSERT INTO X_PROCESSLOG(COMPUTERID, PROCESSTIME, PROCESSED) VALUES ('+
                 IntToStr(fComputer)+','+ QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',NOW)) +','+QuotedStr('Y')+')';
                 //IntToStr(fComputer)+', now() ,'+QuotedStr('Y')+')';
    ExecSQL;
    Close;
    SQL.Text := 'SELECT MAX(SEQNO) AS MAXSEQ FROM X_PROCESSLOG WHERE COMPUTERID = '+IntToStr(fComputer);
    Open;
    fSeqNo := FieldByName('MAXSEQ').AsInteger;
    Close;
    SQL.Text := 'SELECT PROCESSTIME FROM X_PROCESSLOG WHERE SEQNO = '+IntToStr(fSeqNo);
    Open;
    ProcessTime := FieldByName('PROCESSTIME').AsDateTime;
    Close;
    SQL.Text := 'SELECT MAX(SEQNO) AS LASTPROC FROM X_PROCESSLOG WHERE PROCESSED = '+QuotedStr('Y') +
                ' and SeqNo < '+IntToStr(fSeqNo);
    Open;
    LastProc := FieldByName('LastProc').AsInteger;
    Close;
    SQL.Text := 'SELECT COMPUTERID, PROCESSTIME AS LASTTIME FROM X_PROCESSLOG WHERE SEQNO = '+ IntToStr(LastProc);
    Open;
    LastTime := FieldByName('LASTTIME').AsDateTime;
    LastComp := FieldByName('COMPUTERID').AsInteger;
    if ((ProcessTime - LastTime > fInterval) and (LastComp = fComputer)) or            // The same computer
       (((ProcessTime - LastTime) > fInterval * 5) and (LastComp <> fComputer)) then     // Different Computer last processed so wait longer
      Result := True
    else
    begin
      Result := False;
      SetFlag;
    end;
    Close;
    SQL.Text := 'DELETE FROM X_PROCESSLOG WHERE SEQNO < '+IntToStr(fSeqNo-20)+' AND COMPUTERID = '+IntToStr(fComputer);
    ExecSQL;
    if not Result then
      WriteIf('No Process Required');
  end;
end;

procedure TdmMain.UpdateServiceLog(Msg, ProcName: String);
begin
  with qryGeneral do
  begin
    Close;                                                                        
    //SQL.Text := 'INSERT INTO X_SERVICELOG(LOGDATE,DESCRIPTION,PROCNAME) VALUES (now(),'+
    SQL.Text := 'INSERT INTO X_SERVICELOG(LOGDATE,DESCRIPTION,PROCNAME) VALUES ('+QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',NOW))+','+
                 QuotedStr(Copy(Msg+' - Computer:'+IntToStr(fComputer),1,200))+','+QuotedStr(ProcName)+')';
    ExecSQL;
  end;
end;

procedure TdmMain.SetFlag;
begin
  WriteIf('SetFlag');
  MySQLDb.Disconnect;
  Pop3.Disconnect;     // Ensure Disconnection so that it does not remain in this state
  //SMTP.Disconnect;   - This Disconnect causes an error !
  fCanProcess := GetRegSettings(False);
  with qryUpdate do
  begin
    Close;
    SQL.Text := 'UPDATE X_PROCESSLOG SET PROCESSED = '+QuotedStr('N')+' WHERE SEQNO = '+IntToStr(fSeqNo);
    ExecSQL;
  end;
end;

// ===  Main Process function
//==============================================================================
procedure TdmMain.Process;
var
  EData: TEMailData;
  CanDel : Boolean;
  JobNo, i: Integer;
begin
  try
    if EmailsExist then
    // For the time being
    begin
      for i := 1 to fMsgCount do
      begin
        EData := FetchEMail(i);
        ChkLen(EData);
        //exit;
        // Only deal with valid IAG NZ Claim Form - we might consider saving (in DB) and deleting those that are invalid to prevent buildup of messages
        //if (Copy(EData.Subject,1,17) = 'IAG NZ Claim Form') or (EData.Provider = '2') then
        if ((EData.Provider = '1') or (EData.Provider = '2')) and (not EData.ReadErr) then
        begin
          //if CanCreateJob(EData) then
          //begin
          try
            CanDel := False;                    // At least this should prevent multiple records in the X_INBOX table
            EData.BranchNo := GetBranch(EData);
            JobNo := CreateJob(EData);
            WriteIf('New Job '+IntToStr(JobNo));
            // If its less than 0 then the job has already been created so ignore
            if (Jobno > 0) then
            begin
              CanDel := True;  // 
              WriteIf('JobNo > 0, BranchNo='+IntToStr(EData.BranchNo));
              if (EData.BranchNo > 0) and (JobNo > 0) then
              begin
                WriteIf('Call SMSBranch');
                SMSBranch(0, JobNo, True, EData);              // All the data should come from the Job data - send email as well (for first SMS)
                WriteIf('Done SMSBranch');
              end
              else
              begin
                WriteIf('Inform Support - Job or Branch not > 0');
                InformSupport(0, JobNo, EData, False);
              end;
                //SMSSupport(0, JobNo, EData);
            end
            else              // Forward the email to Support
            begin
              if fForwardAll and (JobNo = 0) then   // < 0 means that it is a repeat of a job that is already created
              begin
                WriteIf('Forward One');
                ForwardToSupport;
              end;
            end;
            CanDel := True;
            // If its less than 0 then the job has already been created so ignore
            //end
            //else
          except
            try
              UpdateServiceLog('Error Processing Email or Forwarding to Branch - Job '+IntToStr(JobNo),'Process');
              if JobNo > 0 then
                InformSupport(3, JobNo, EData, True)  // Job Created - error somewhere in the process
              else
                InformSupport(1, 0, EData, True);  // no Job Created - error somewhere in the process
            except    
              WriteIf('ERROR Informing support');
            end
          end;
          if CanDel then
          begin
            WriteIf ('Delete the email - 1');
            DeleteEmail(i, True);
          end
          else
            WriteIf('Not deleting Email');
        end
        else   // The EData.provider value is not valid so we assume that it is an invalid message (not a job)
        begin
          try
            if fForwardAll then
            begin
              WriteIf('Forward Two');
              ForwardToSupport;
            end;
          finally                     // Even if there was an error forwarding this we are going to delete it
            if not EData.ReadErr then // But not if there was an error reading the emails !
            begin
              WriteIf ('Delete the email - 2');
              DeleteEMail(i, False);
            end;
          end;
        end;
        //  MessageDlg(Copy(EData.Subject,1,17)+#13+'IAG NZ Claim Form',mtInformation,[mbOK],0);
      end;
      LimitInBox;                     // Delete from X_INBOX where seqno < ...
      if fUseSMS then
        UpdateOutstanding;
      fMsgCount := 0;
    end;
    // now check messages for responses
    pop3.Disconnect;
    WriteIf('No more new emails to Process');
    if fUseSMS then
      while MessageActionRequired do
      begin
        SendNextSMS;
      end;
    // if more info was requested
    if fUseSMS then
      SendMoreInfo;
    writeif('Use Reminder');
    if fUseReminder then
      SendReminders;
  finally
    pop3.Disconnect;
  end;
end;

//==============================================================================
function TdmMain.EMailsExist: Boolean;
var
  NullData: TEMailData;
begin
  Result := False;
  fMsgCount := 0;
  try
    // Force a new connection
    pop3.Disconnect;
    if not pop3.Connected then
    begin
      WriteIf('EE - Pop3.Connect');
      pop3.Connect;
      WriteIf('EE - Pop3 Connect Complete');
    end;
    pop3.List;
    Result := (fMsgCount > 0);
    WriteToFile('Pop 3 - '+IntToStr(fMsgCount)+' messages');
  except
    pop3.Disconnect;
    if not fExceptionSent then
    begin
      UpdateServiceLog('Problem getting Email count','EmailsExist');
      InformSupport(4, 0 , NullData, False);            
      //SMSSupport(4, 0 , NullData);
      fExceptionSent := True;
    end;
    WriteToFile('Pop 3 - EmailsExist exception');
  end;
end;

//==============================================================================
function TdmMain.FetchEMail(msg: integer): TEmailData;
var
  BS, Lne: string;
  i, j, ps, pe, pend, NFlds, IAGPos: integer;
  EMailData: TEmailData;
  AKey : Array[0..36] of string;
const
  {$IFDEF ISCC}
  // IAG - Carpet Court
  Numflds = 17;
  Key : Array[0..16] of string =('Date:','Time:','From:','Name:','Address:','Contact Home:','Contact Work:','Contact Mobile:','Claim Number:','Risk Number:','Brand:','Description:','Special Instructions:','Excess:','ITEM DETAILS','"IAG - one of the Global 100','"NZI - proudly protecting');
  {$ELSE}
  // IAG - JAE
  Numflds = 17;
  Key : Array[0..16] of string =('Date:','Time:','From:','Name:','Address:','Contact Home:','Contact Work:','Contact Mobile:','Claim Number:','Risk Number (NZI Only):','Brand:','Description:','Special Instructions:','Excess:','Urgent:','Service:','Area:');
  {$ENDIF}
  NumIAGNewflds = 38;
   IAGNewKey: Array[0..37] of string=('Claim Number:','==========','Insured'+#39+'s Name:','Risk Number:','Brand:','Contact Person','Contact Name:','Home Number:','Mobile Number:','Work Number:','Email Address:','Street Address:','Suburb:','City:','Country:','Assessor','Assessor:','Assessor Email:','Assessor Phone:','Assessor Mobile:','Other Details','Description of Event:','Other Description of Event:','Special Instructions:','Claim Form Items','Item No:','Urgent:','Amended Item No:','Amended Reason:','Item Type:','Request:','Carpet Area:','Coverage:','Excess $:','Salvage:','Item Location:','Comment:','IAG - one of the');
  // 27-08-2009
  NumIAGXMLflds = 35;
  IAGXMLKey: Array[0..34] of string=('<ClaimNumber>','<InsuredsName>','<RiskNumber>','<Brand>','<ContactPerson>','<ContactName>','<HomeNumber>','<MobileNumber>','<WorkNumber>','<EmailAddress>','<StreetAddress>','<Suburb>','<City>','<Country>','<AssessorName>','<AssessorEmail>','<AssessorPhone>','<AssessorMobile>','<DescEvent>','<OtherDescEvent>','<SpecialInstructions>','<ClaimType>','<Excess>','<Coverage>','<Urgent>','<RequestNo>','<AmendedNo>','<AmendedReason>','<ItemType>','<Request>','<CarpetArea>','<Attached>','<ItemLocation>','<Comment>','<ItemDescription>');  
   
  // Tower
  NumTowerFlds = 14;
  TowerKey : Array[0..13] of string =('Branch:','Claim Number:','Excess:','Urgent?:','Customer Name:','Preferred Phone:','Other Phone:','Street Address:','Suburb:','City/Town:','Damage Area:','Event Description:','Notes/Comments:','<P><BR><HR><FONT face=Arial size=2>The information contained in this email message');

  NumTowerNewFlds = 22;
  TowerNewKey : Array[0..21] of string =('2.1  Billing Branch','2.2  Claim Number','2.3  Applicable Excess','2.4  Urgent?','2.5  Is an after-hours callout approved','3.0  Customer Information','3.1  First Name','3.2  Last Name','3.3  Preferred Telephone','3.4  Mobile Telephone','3.5  Work Phone Number','4.0  Location Details','4.1  Street address where house located','4.2  Suburb where house located','4.3  City/town where house located','4.4  Is property tenanted','4.5  Tenants Contact Details','5.0  Room where Damage has occurred','6.0  What type of cover does the policy have?','7.0  Description of Damage/Event','8.0  If a Carpet Court Appointment; Did Jae assess this job?','Please do not reply to this email');

  NumTowerFlds2009 = 24;
  TowerKey2009 : Array[0..23] of string =('1.0  Claim Number','2.0  Which supplier is this request being submitted to?','3.0  Request','4.0  Details','4.1  Billing Branch','4.2  Applicable Excess','4.3  Urgent?','4.4  Is an after-hours callout approved','5.0  Customer Information','5.1  First Name','5.2  Last Name','5.3  Preferred Telephone','5.4  Mobile Telephone','5.5  Work Phone Number','6.0  Location Details','6.1  Street address where house located','6.2  Suburb where house located','6.3  City/town where house located','6.4  Is property tenanted','6.5  Tenants Contact Details','7.0  Room where Damage has occurred','8.0  Description of Damage/Event','9.0  If Carpet Court Appointment; Did Jae assess this job?','Please do not reply to this email');

  NumTowerFlds2012 = 22;
  TowerKey2012 : Array[0..21] of string =('1.0  Claim Number','2.0  Request','3.0  Details','3.1  Applicable Excess','3.2  Urgent?','3.3  Is an after-hours callout approved','3.4  What type of claim?','3.5  If both what is House Claim #','4.0  Customer Information','4.1  Customer Name','4.2  Preferred Telephone','4.3  Mobile Phone','4.4  Work Phone','5.0  Location Details','5.1  Street address where house located','5.2  Suburb where house located','5.3  City/town where house located','5.4  Is property tenanted','5.5  Tenants Contact Details','6.0  Room where Damage has occurred','7.0  Description of Damage/Event','Please do not reply to this email');

  procedure UpdateResult(Fld: integer; ALine: String; var EMailData: TEMailData);
  var
    Line: string;
    //=====================================
    function RemoveNum(S:String): String;
    var
      i,p: integer;
    const
      Digits: array[0..9] of Char = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9');
    begin
      for i:= 0 to 9 do
      begin
        p:=pos(Digits[i], S);
        while p > 0 do
        begin
          S := Copy (S,1,p-1)+Copy(S,p+1,length(S));
          p:=pos(Digits[i], S);
        end;
      end;   
      Result := S;
    end;
    //=====================================
    function CleanStr(S: String): String;
    var
      i : Integer;
      Rslt: String;
    begin
      try
        S := Trim(S);
        i := pos('<span',S);
        Rslt := Copy (S,i+1,length(S)-i);
        i := pos('>',Rslt);
        Rslt := Copy (Rslt,i+1,length(Rslt)-i);
        i := pos('</span',Rslt);
        if (i <> 0) then
          Rslt := Copy(Rslt,1,i-1);
        if (pos('    ',Rslt) > 0) then                                       // =20
          Rslt := Copy(Rslt,1,pos('    ',Rslt)-1);
        Result := Trim(Rslt);
      except
        Result := '';
      end;
    end;
  begin
    // IAG Insurance Email  OLD Data
    if EMailData.ProcessType = 1 then
    begin
      WriteIf('ALine '+ALine);
      Line := CleanStr(ALine);
      WriteIf('Line '+Line);
      case Fld of
      0: EMailData.Date := Line;
      1: EMailData.Time := Line;
      2: EMailData.From := Line;
      3: EMailData.Name := Line;
      4: begin
           EMailData.Address := Line;
           //ALine := Copy(ALine,length(Line)+6 , length(ALine)-(length(Line)+5));
           Trim(ALine);
           WriteIf('ALINE1:'+ALine);
           if Trim(Line) = '' then
           begin
             WriteIf('==============================');
             ALine := Copy(ALine, pos('</span>', ALine)+1, length(ALine)-pos('</span>', ALine));
             ALine := Copy(ALine, pos('</span>', ALine)+1, length(ALine)-pos('</span>', ALine));
           end
           else
           begin
             WriteIf('Should be here---------'+IntToStr(pos(Line,ALine)));
             ALine := Copy(ALine, pos(Line, ALine)+length(Line), length(ALine)-Length(Line)-pos(Line, ALine)+1);
             if (pos('    ',ALine) = 1) then
               ALine := Copy(ALine,5,Length(ALine)-4);
           end;
           WriteIf(' LINE2:'+Line);
           WriteIf('ALINE2:'+ALine);
           Line := RemoveNum(CleanStr(ALine));
           EMailData.Suburb := Line;
           Trim(ALine);
           //ALine := Copy(ALine,length(Line)+6 , length(ALine)-(length(Line)+5));
           if Trim(Line) = '' then
           begin
             ALine := Copy(ALine, pos('</span>', ALine)+1, length(ALine)-pos('</span>', ALine));
             ALine := Copy(ALine, pos('</span>', ALine)+1, length(ALine)-pos('</span>', ALine));
           end
           else
           begin
             ALine := Copy(ALine, pos(Line, ALine)+Length(Line), length(ALine)-Length(Line)-pos(Line, ALine)+1);
             if (pos('    ',ALine) = 1) then
               ALine := Copy(ALine,5,Length(ALine)-4);
           end;
           Line := RemoveNum(CleanStr(ALine));
           EMailData.City := Line;
         end;
      5: EMailData.HomePhone := Line;
      6: EMailData.WorkPhone := Line;
      7: EMailData.MobilePhone := Line;
      8: EMailData.Claim := Line;
      9: EMailData.Risk := Line;
      10: EMailData.Brand := Line;
      11: EMailData.Description := Line;
      12: EMailData.SpecialIns := Line;
      13: EMailData.Excess := Copy(Line,pos('$',Line)+1,length(Line)-pos('$',Line));
      {$IFDEF ISCC}
      14: begin
           while pos('=20',ALine)>0 do
           begin
             writeif('***'+ALine);
             Insert(' ',ALine,pos('=20',ALine));
             writeif('***'+ALine);
             Delete(ALine,pos('=20',ALine),3);
             writeif('***'+ALine);
           end;
           EMailData.Area := CleanStr(ALine);
          end;
      {$ELSE}
      14: EMailData.Urgency := UpperCase(Copy(Line,1,3));
      15: EMailData.Service := Line;
      16: EMailData.Area := Line;
      {$ENDIF}
      end;
    end;
    // IAG Insurance Email  NEW Data
    if EMailData.ProcessType = 3 then
    begin
      WriteIf('ALine '+ALine);
      Line := CleanStr(ALine);
      WriteIf('Line '+Line);
      case Fld of
      0: EMailData.Claim := Line;
      2: EMailData.InsuredName := Line;
      3: EMailData.Risk := Line;
      4: EMailData.Brand := Line;
      6: EMailData.Name := Line;
      7: EMailData.HomePhone := Line;
      8: EMailData.MobilePhone := Line;
      9: EMailData.WorkPhone := Line;
      10: EMailData.EMail := Line;
      11: EMailData.Address := Line;
      12: EMailData.Suburb := RemoveNum(Line);
      13: EMailData.City := RemoveNum(Line);
      14: EMailData.Country := Line;   // 15: Assessor
      16: EMailData.Assessor := Line;//Copy(Line,pos('$',Line)+1,length(Line)-pos('$',Line));
      17: EMailData.AssessorEMail := Line;
      18: EMailData.AssessorPhone := Line;
      19: EMailData.AssessorMobile := Line;      //20: Other Details
      21: EMailData.Description := Line;
      22: EMailData.OtherDesc := Line;
      23: EMailData.SpecialIns := Line;       // 24:    Claim form Items
      25: EMailData.ItemNo := Line;              // Item No or Request No --- May have to cater for both of these
      26: EMailData.Urgency := UpperCase(Copy(Line,1,3));
      27: EMailData.AItemNo := Line;
      28: EMailData.AReason := Line;
      29: EMailData.ItemType := Line;
      30: EMailData.Service := Line;
      31: EMailData.Area := Line;
      32: EMailData.Coverage := Line;
      33: EMailData.Excess := Line;
      34: EMailData.Salvage := Line;
      35: EMailData.Loc := Line;
      36: EMailData.Comment := Line;
      end;
    end;
    // IAG XML Data
    if EMailData.ProcessType = 6 then
    begin
      WriteIf('ALine '+ALine);
      ALine := Trim(ALine);
      Line := Copy(ALine,1,pos('</',ALine)-1);
      //Line := CleanStr(ALine);
      WriteIf('Line '+Line);
      case Fld of
      0: EMailData.Claim := Line;
      1: EMailData.InsuredName := Line;    // -----
      2: EMailData.Risk := Line;
      3: EMailData.Brand := Line;
      4: ; //EMailData.Brand := Line;  ContactPerson         // If the Insured name is different from the name assume that this is a tenant
      5: begin EMailData.Name := Line; if EMailData.InsuredName <> EMailData.Name then EMailData.TenantDetail := Line;  end;
      6: EMailData.HomePhone := Line;
      7: EMailData.MobilePhone := Line;
      8: EMailData.WorkPhone := Line;
      9: EMailData.EMail := Line;
      10: EMailData.Address := Line;
      11: EMailData.Suburb := RemoveNum(Line);
      12: EMailData.City := RemoveNum(Line);
      13: EMailData.Country := Line;   // 15: Assessor
      14: EMailData.Assessor := Line;
      15: EMailData.AssessorEMail := Line;
      16: EMailData.AssessorPhone := Line;
      17: EMailData.AssessorMobile := Line;                                             
      18: EMailData.Description := Line;
      19: EMailData.OtherDesc := Line;
      20: EMailData.SpecialIns := Line;       // 24:    Claim form Items
      21: EMailData.RegKind := Line;          // This will have "Home" or "Contents" in it
      22: EMailData.Excess := Line;
      23: EMailData.Coverage := Line;
      24: EMailData.Urgency := UpperCase(Copy(Line,1,3));
      25:;                                             // RequestNo
      26:;                                             // AmendNo
      27: EMailData.AReason := Line;
      28: EMailData.ItemType := Line;
      29: EmailData.Service := Line;                   // Request
      30: EMailData.Area := Line;
      31:;                                             // Attached
      32:;                                             // Item Location
      33: EMailData.Comment := Line;
      34: EMailData.ItemDesc := Line;

      //25: EMailData.ItemNo := Line;              // Item No or Request No --- May have to cater for both of these
      //27: EMailData.AItemNo := Line;
      //30: EMailData.Service := Line;
      //34: EMailData.Salvage := Line;
      //35: EMailData.Loc := Line;
      end;
    end;
    // Tower Insurance EMail
    if EMailData.ProcessType = 2 then
    begin
      Line := Trim(ALine);   // Probably need to strip CR & LF from this
      WriteIf('Tower');
      //Line := StringReplace(Line, '=20', ' ',[rfReplaceAll]);
      WriteIf(Line);
      case Fld of
      0: EMailData.Brand := Line; // Branch ? Brand
      1: EMailData.Claim := Line;
      2: EMailData.Excess := Line;
      3: EMailData.Urgency := UpperCase(Copy(Line,1,3));
      4: EMailData.Name := Line;
      5: EMailData.HomePhone := Line;
      6: EMailData.WorkPhone := Line;
      7: EMailData.Address := Line;
      8: EMailData.Suburb := RemoveNum(Line);
      9: EMailData.City := RemoveNum(Line);
      10: EMailData.Area := Line;
      11: EMailData.Description := Line;
      12: EMailData.SpecialIns := Line;
      end;
    end;
    // Tower Insurance New EMail
    if EMailData.ProcessType = 4 then
    begin
      Line := Trim(ALine);   // Probably need to strip CR & LF from this
      WriteIf('Tower');
      //Line := StringReplace(Line, '=20', ' ',[rfReplaceAll]);
      WriteIf(Line);
      case Fld of
      0: EMailData.Brand := Line; // Branch ? Brand
      1: EMailData.Claim := Line;
      2: EMailData.Excess := Line;
      3: EMailData.Urgency := UpperCase(Copy(Line,1,3));
      4: EMailData.AfterHours := UpperCase(Copy(Line,1,3));
      6: EMailData.Name := Line;
      7: EMailData.Name := EMailData.Name+' '+Line;   // Now comes in First and Last
      8: EMailData.HomePhone := Line;
      9: EMailData.MobilePhone := Line;
      10: EMailData.WorkPhone := Line;
      12: EMailData.Address := Line;
      13: EMailData.Suburb := RemoveNum(Line);
      14: EMailData.City := RemoveNum(Line);
      15: EMailData.Tenanted := UpperCase(Copy(Line,1,3));
      16: EMailData.TenantDetail := Line;
      17: EMailData.Area := Line;                      // 18 What type
      18: EMailData.Service := Line;
      19: EMailData.Description := Line;
      end;
    end;
    // Tower Insurance New EMail
    if EMailData.ProcessType = 5 then
    begin
      Line := Trim(ALine);   // Probably need to strip CR & LF from this
      WriteIf('Tower');
      //Line := StringReplace(Line, '=20', ' ',[rfReplaceAll]);
      WriteIf(Line);
      case Fld of
      0: EMailData.Claim := Line; 
      2: EMailData.Service := Line;
      4: EMailData.Brand := Line;
      5: EMailData.Excess := Line;
      6: EMailData.Urgency := UpperCase(Copy(Line,1,3));      
      7: EMailData.AfterHours := UpperCase(Copy(Line,1,3));      
      9: EMailData.Name := Line;   // Now comes in First and Last   EMailData.Name+' '+
      10: EMailData.Name := EMailData.Name+' '+Line;   // Now comes in First and Last   
      11: EMailData.HomePhone := Line;
      12: EMailData.MobilePhone := Line;
      13: EMailData.WorkPhone := Line;
      15: EMailData.Address := Line;
      16: EMailData.Suburb := RemoveNum(Line);
      17: EMailData.City := RemoveNum(Line);
      18: EMailData.Tenanted := UpperCase(Copy(Line,1,3));
      19: EMailData.TenantDetail := Line;
      20: EMailData.Area := Line;                      // 18 What type
      21: EMailData.Description := Line;
      end;
    end;
    // Tower Insurance 2012 EMail
    if EMailData.ProcessType = 7 then
    begin
      Line := Trim(ALine);   // Probably need to strip CR & LF from this
      WriteIf('Tower');
      //Line := StringReplace(Line, '=20', ' ',[rfReplaceAll]);
      WriteIf(Line);
      case Fld of
      0: EMailData.Claim := Line; 
      1: begin EMailData.Service := Line; 
               EMailData.ItemDesc:= Line;
         end;
       //  4: EMailData.Brand := Line;
      3: EMailData.Excess := Line;
      4: EMailData.Urgency := UpperCase(Copy(Line,1,3));      
      5: EMailData.AfterHours := UpperCase(Copy(Line,1,3));      
      6: EmailData.RegKind := Line;   //  REG_KIND with B (both) House / Contents / House & Contents
      7: EMailData.Policy := Line;
      9: EMailData.InsuredName := Line;    // Changed from Name at the time when sorting out Tenant 5/7/2013
      10: EMailData.HomePhone := Line;
      11: EMailData.MobilePhone := Line;
      12: EMailData.WorkPhone := Line;
      14: EMailData.Address := Line;
      15: EMailData.Suburb := RemoveNum(Line);
      16: EMailData.City := RemoveNum(Line);
      17: EMailData.Tenanted := UpperCase(Copy(Line,1,3));
      18: EMailData.TenantDetail := Line;
      19: EMailData.Area := Line;                      
      20: EMailData.Description := Line;
      end;
    end;
  end;
begin
  try
    EMailData.ReadErr := True;              // Assume that we don't read it properly
    pop3.GetMailMessage(msg);
    EMailData.InBoxSeqNo := SaveMessage;
    // Get the Subject
    EmailData.Subject := Trim(pop3.MailMessage.Subject);
    WriteIf('Subject=['+EmailData.Subject+']');
    EmailData.IsTruncated := 'N';
    // Get the Body 
    EmailData.Body:='';  // This is not used !!!!
    BS:='';
    // CAN THIS REPLACE THE LOOP BELOW????
    BS := pop3.MailMessage.Body.Text;
    BS := StringReplace(BS, '=20', ' ',[rfReplaceAll]);
    BS := StringReplace(BS, '='+#13+#10, '',[rfReplaceAll]);
    {
    for i := 0 to pop3.MailMessage.Body.Count-1 do
    begin
      BS := BS + pop3.MailMessage.Body[i];  //+#13+#10;
    end;
    }                                              
    WriteIf('BODY =>'+ BS);
    // Test to see if a TOWER or IAG invoice
    IAGPos := Pos('URGENT IAG NZ Claim Form', EmailData.Subject);
    if IAGPos = 0 then
      IAGPos := Pos('Urgent IAG NZ Claim Form', EmailData.Subject);   // Subject changed 2012/11/
    if IAGPos = 0 then
      IAGPos := Pos('IAG NZ Claim Form', EmailData.Subject);
    if (IAGPos > 0) and (IAGPos < 3) then  // To prevent trying to process RE:IAG NZ.....
    begin
      EMailData.Provider := '1';
      if (Pos('<Claim>', BS)> 0) then
      begin
        EMailData.ProcessType := 6;
        NFlds := NumIAGXMLFlds;
        for i := 0 to NFlds - 1 do
          AKey[i] := IAGXMLKey[i];
      end
      else if pos('Claim Number:',EmailData.Subject) > 0 then  // New Format
      begin
        EMailData.ProcessType := 3;
        NFlds := NumIAGNewFlds;
        for i := 0 to NFlds - 1 do
          AKey[i] := IAGNewKey[i];
      end
      else
      begin
        EMailData.ProcessType := 1;
        NFlds := NumFlds;
        for i := 0 to NFlds - 1 do
          AKey[i] := Key[i];
      end;
    end
    else if (Pos('TOWER INSURANCE CLAIMS', BS)> 0) or (Pos('TOWER=20INSURANCE=20CLAIMS', BS)> 0) then
    begin
      if Pos('TOWER=20INSURANCE=20CLAIMS', BS)> 0 then
        BS := StringReplace(BS, '=20', ' ',[rfReplaceAll]);
      EMailData.Provider := '2'; // Assume that it is a Tower email for everything else
      EMailData.ProcessType := 2;
      NFlds := NumTowerFlds;
      for i := 0 to NFlds - 1 do
        AKey[i] := TowerKey[i];
    end
    else if (Pos('Jaes Referral Form', BS)> 0) then
    begin
      EMailData.Provider := '2';
      EMailData.Brand := 'TOWER DEFAULT';       // Hard code this as all Tower jobs will now be invoiced through this
      EMailData.ProcessType := 7;
      NFlds := NumTowerFlds2012;
      for i := 0 to NFlds - 1 do
        AKey[i] := TowerKey2012[i];
    end
    else if (Pos('Carpet/Vinyl Repair or Replacement', BS)> 0) then
    begin
      EMailData.Provider := '2';
      //if (Pos('1.0  Claim Number', BS) > 0) then  
      //begin
        EMailData.ProcessType := 5;
        NFlds := NumTowerFlds2009;
        for i := 0 to NFlds - 1 do
          AKey[i] := TowerKey2009[i];
      //end;
      //if (Pos('2.2  Claim Number', BS) > 0) then  
      //begin
      //  EMailData.ProcessType := 4;
      //  NFlds := NumTowerNewFlds;
      //  for i := 0 to NFlds - 1 do
      //    AKey[i] := TowerNewKey[i];
      //end;
    end
    else if (Pos('Carpet Repair or Replacement', BS)> 0) then
    begin
      EMailData.Provider := '2';
      EMailData.ProcessType := 4;
      NFlds := NumTowerNewFlds;
      for i := 0 to NFlds - 1 do
        AKey[i] := TowerNewKey[i];
    end
    else
      EMailData.Provider :='?';
    WriteIf ('PROVIDER :'+EMailData.Provider+' Process :'+IntToStr(EMailData.ProcessType));
    // Process the fields
    for j := 0 to Nflds - 1 do
    begin
      if pos(AKey[j], BS) = 0 then  // if it is zero it means that the particular identification phase is not found
      begin
        WriteIf('Key not found:['+AKey[j]+']');
        UpdateResult(j, '', EmailData);
      end
      else
      begin
        ps := pos(AKey[j], BS) + length(AKey[j]);
        // I think that this should deal with missing KEY descriptors in the email
        pe := 0;
        i := 1;
        while j+i <= Nflds - 1 do
        begin
          if pos(AKey[j+i],copy(BS,ps,length(BS)-ps+1)) > 0 then
          begin
            pe := pos(AKey[j+i],copy(BS,ps,length(BS)-ps+1)) + ps -1;
            break;
          end
          else
            inc(i);
        end;
        if pe = 0 then
          pe := length(BS);
        // If problems see pTest Project for testing
        WriteIf('Start '+inttostr(ps)+' end '+inttostr(pe));
        if ps > 0 then
        begin
          // Remove the end tag if there is one
          Lne := Copy(BS,ps,pe-ps);
          pend := Pos('</'+Copy(AKey[j],2,Length(AKey[j])-1),Lne);
          if Pend > 0 then
            Lne := Copy(Lne,1,pend-1);
          WriteIf('Key['+IntToStr(j)+'] '+AKey[j]+'=>['+Lne+']');
          UpdateResult(j, Copy(BS,ps,pe-ps), EmailData);
        end;
      end;
    end;
      //EmailData.Body := EmailData.Body + pop3.MailMessage.Body[i];
    EmailData.ReadErr := False;  
  except
    on E: Exception do
    begin
      EmailData.ReadErr := True;  
      UpdateServiceLog(E.Message,'FetchEmail');
      WriteToFile('Pop 3 - Get Mail Failure');
      InformSupport(5, 0, EmailData, True);
    end;
  end;
  Result := EmailData;
end;

function TdmMain.SaveMessage: integer;
begin
  try
    qryGeneral.Close;
    qryGeneral.SQL.Text := 'INSERT INTO X_INBOX(SUBJECT, BODY, RECEIVED_DATE) VALUES ('+
                            QuotedStr(Copy(pop3.MailMessage.Subject,1,255))+','+
                            QuotedStr(pop3.MailMessage.Body.Text)+','+
                            QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',NOW))+')';
    qryGeneral.ExecSQL;
    qryGeneral.Close;
    qryGeneral.SQL.Text := 'SELECT MAX(SEQNO) AS SEQNO FROM X_INBOX';
    qryGeneral.Open;
    Result := qryGeneral.FieldBYName('SEQNO').AsInteger;
  except
    Result := -1;
  end;
end;

// Set the ISOUTSTANDING flag for records that are old and should have been responded to (to prevent needless processing)
procedure TdmMain.UpdateOutstanding;
var
  MaxSeq: integer;
begin
  try
    qryGeneral.Close;
    qryGeneral.SQL.Text := 'UPDATE X_SMSLOG SET ISOUTSTANDING = '+QuotedStr('N')+      
                           ' WHERE ISOUTSTANDING = '+QuotedStr('Y')+ ' AND DATEDIFF('+QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',NOW))+',RESPONSEREQUIRED) >= 2'  ;
                           //' WHERE ISOUTSTANDING = '+QuotedStr('Y')+ ' AND DATEDIFF(NOW(),RESPONSEREQUIRED) >= 2'  ;
    qryGeneral.ExecSQL;
  except
    WriteIf('Error updating X_SMSLOG'+#13+qryGeneral.SQL.Text);
  end;
end;

procedure TdmMain.LimitInBox;
var
  MaxSeq: integer;
begin
  if ( fInBoxRecs > 0) then
    try
      qryGeneral.Close;
      qryGeneral.SQL.Text := 'SELECT MAX(SEQNO) AS SEQNO FROM X_INBOX';
      qryGeneral.Open;
      MaxSeq := qryGeneral.FieldByName('SEQNO').AsInteger;
      qryGeneral.SQL.Text := 'DELETE FROM X_INBOX WHERE (SEQNO < '+IntToStr(MaxSeq - fInBoxRecs)+')';
      WriteIf(qryGeneral.SQL.Text);
      qryGeneral.ExecSQL;
    except
      WriteIf('Error deleting from X_INBOX'+#13+qryGeneral.SQL.Text);
    end;
end;

//==============================================================================
function TdmMain.CanCreateJob(var EData: TEMailData): Boolean;
begin
  // If there is a name and we can identify the City we should be able to create a job
  {
  qryGeneral.Close;
  qryGeneral.SQL.Text := 'Select Count(*) as Cnt from X_BranchLink B, X_City C Where B.CityNo = C.CityNo and C.CityName = '+QuotedStr(EData.City);
  qryGeneral.Open;
  EData.CityCnt := qryGeneral.FieldByName('Cnt').AsInteger;
  Result := (EData.Name <> '') and (EData.CityCnt > 0);
  }
  Result := (EData.Name <> '');
end;

//==============================================================================
function TdmMain.GetBranch(EData: TEMailData): Integer;
var
  {SuburbCnt, StreetCnt,} B1, B2: integer;
begin
  Result := SUPPORT;           // Hard coded so that the unknown Branch jobs go to Theresa (Support)
  if EData.Suburb <> '' then
  begin
    qryGeneral.Close;
    qryGeneral.SQL.Text := 'SELECT '+QuotedStr('S')+' AS AREA, SUBURBNAME AS NAME, BRANCHNO FROM X_SUBURB'+
                           ' WHERE SUBURBNAME = '+QuotedStr(EData.Suburb)+
                           ' UNION '+
                           'SELECT '+QuotedStr('C')+' AS AREA, CITYNAME AS NAME, BRANCHNO FROM X_CITY '+
                           ' WHERE CITYNAME = '+QuotedStr(EData.Suburb)+
                           ' UNION '+
                           'SELECT '+QuotedStr('C')+' AS AREA, REGIONNAME AS NAME, BRANCHNO FROM X_CITY '+
                           ' WHERE REGIONNAME = '+QuotedStr(EData.Suburb)+
                           ' ORDER BY BRANCHNO';
    qryGeneral.Open;
    qryGeneral.First;
    if not qryGeneral.FieldByName('BRANCHNO').IsNull then
    begin
      B1 := qryGeneral.FieldByName('BRANCHNO').AsInteger;
      qryGeneral.Last;
      B2 := qryGeneral.FieldByName('BRANCHNO').AsInteger;
      if B1 = B2 then
        Result := B1;
    end;
  end;
    //else  // There was more than one result - either multiple suburbs or city and suburb of the same name
  if (Result = SUPPORT) then
  begin
    if EData.City <> '' then
    begin
      qryGeneral.Close;
      qryGeneral.SQL.Text := 'SELECT '+QuotedStr('S')+' AS AREA, SUBURBNAME AS NAME, S.BRANCHNO FROM X_SUBURB S'+
                             ' RIGHT JOIN X_CITY C ON S.CITYNO = C.CITYNO'+
                             ' WHERE S.SUBURBNAME = '+QuotedStr(EData.Suburb)+
                             ' AND C.CITYNAME = '+QuotedStr(EData.City)+
                             ' UNION '+
                             'SELECT '+QuotedStr('C')+' AS AREA, SUBURBNAME AS NAME, S2.BRANCHNO FROM X_SUBURB S2'+
                             ' RIGHT JOIN X_CITY C ON S2.CITYNO = C.CITYNO'+
                             ' WHERE S2.SUBURBNAME = '+QuotedStr(EData.Suburb)+
                             ' AND C.REGIONNAME = '+QuotedStr(EData.City)+
                             ' ORDER BY BRANCHNO';
      qryGeneral.Open;
      qryGeneral.First;
      if not qryGeneral.FieldByName('BRANCHNO').IsNull then
        Result := qryGeneral.FieldByName('BRANCHNO').AsInteger;
    end;
  end;
  //end
  //else  // what ever was in Suburb is not in the database
  if (Result = SUPPORT) then
  begin
    qryGeneral.Close;
    qryGeneral.SQL.Text := 'SELECT '+QuotedStr('S')+' AS AREA, SUBURBNAME AS NAME, BRANCHNO FROM X_SUBURB'+
                           ' WHERE SUBURBNAME = '+QuotedStr(EData.City)+
                           ' UNION '+
                           'Select '+QuotedStr('C')+' AS AREA, CITYNAME AS NAME, BRANCHNO FROM X_CITY '+
                           ' WHERE CITYNAME = '+QuotedStr(EData.City)+
                           ' OR REGIONNAME = '+QuotedStr(EData.City)+
                           ' ORDER BY BRANCHNO';
    qryGeneral.Open;
    qryGeneral.First;
    if not qryGeneral.FieldByName('BRANCHNO').IsNull then
    begin
      B1 := qryGeneral.FieldByName('BRANCHNO').AsInteger;
      qryGeneral.Last;
      B2 := qryGeneral.FieldByName('BRANCHNO').AsInteger;
      if B1 = B2 then
      begin
        Result := B1;
        Exit;
      end;
    end
    else
      // no records were found
      Result := SUPPORT;
  end;
  qryGeneral.Close;
end;

//==============================================================================
procedure TdmMain.ChkLen(EData: TEMailData);
  function ChkIt(AStr: String;L: integer): string;
  begin
    if (Length(AStr) <= L) then
      Result := AStr
    else
    begin
      EData.IsTruncated := 'Y';
      Result := Copy(AStr,1,L);
    end;  
  end;
begin
  EData.Description := ChkIt(EData.Description,255);
  EData.SpecialIns := ChkIt(EData.SpecialIns,255);
  EData.Area := ChkIt(EData.Area,255);
  EData.Comment := ChkIt(EData.Comment,255);
  EData.ItemDesc := ChkIt(EData.ItemDesc,255);
end;

//==============================================================================
function TdmMain.CreateJob(EData: TEMailData): Integer;
var
  Urgent, Flood, Stain, Brand, ADate, ATime, IAGTime, Kind: string;
  AccNo, sp, hr, Cde: Integer;
  Excss: Single;
  //
  function StripAll(AStr:String):String;
  var
    i: integer;
  begin
    Result := '';
    for i := 1 to Length(AStr) do
      if AStr[i] in ['1','2','3','4','5','6','7','8','9','0','.'] then
        Result := Result + AStr[i];
  end;
begin
  try
    WriteIf('Create Job');
    if (EData.Provider = '?') then
    begin
      Result := -1;
      WriteIf('No Provider');
      exit;
    end;
    if (EData.Urgency = 'YES') then
      Urgent := '1'
    else
      Urgent := '2';
    if pos('FLOOD',UpperCase(EData.Service)) > 0  then
    begin
      Flood := 'Y';
      Stain := 'N';
    end
    else
    begin
      Flood := 'N';
      Stain := 'Y';
    end;
    if (EData.Name = '') then
      EData.Name := EData.InsuredName;
    Kind := '';
    if (Uppercase(Edata.RegKind)='HOME') or (Uppercase(Edata.RegKind)='HOUSE') then Kind := 'D'; // Dwelling
    if Uppercase(Edata.RegKind)='CONTENTS' then Kind := 'C'; // Contents
    if Uppercase(Edata.RegKind)='HOUSE & CONTENTS' then Kind := 'B'; // Both
    if EData.Excess='.' then EData.Excess := '0';
    val(EData.Excess, Excss, Cde);
    if (Cde <> 0) then
    begin
      EData.Excess_Ref := EData.Excess;
      EData.Description := 'Excess='+EData.Excess+' '+EData.Description;
      EData.Excess := zifb(StripAll(EData.Excess));
    end;
    // Manipulate the date / time - This is no longer used so don't bother with it
    (*if (EData.Provider = '1') and (EData.ProcessType=1) then
    begin
      sp := pos('/',EData.Date);
      ADate := Copy(EData.Date,sp+4,4)+'-'+Copy(EData.Date,sp+1,2)+'-'+Copy(EData.Date,1,sp-1);
      sp := pos(':',EData.Time);
      hr := StrToInt(Copy(EData.Time,1,sp-1));
      if pos ('p.m.',EData.Time) > 0 then
        if hr < 12 then
          hr := hr + 12;
      ATime := Format('%2.2d:%s:00',[hr,Copy(EData.Time,sp+1,2)]);
      IAGTime := ADate+' '+ATime;
    end
    else *)
      IAGTime := FormatDateTime('yyyy-mm-dd hh:nn:ss', now);
    WriteIf ('Date/Time: '+IAGTime);
    with qryGeneral do
    begin
      Close;
      if (EData.Provider = '1')  and (EData.ProcessType=1) then
        SQL.Text := 'SELECT MAX(SEQNO) AS CNT FROM SALESORD_HDR WHERE RECEIVED_DATE = '+QuotedStr(IAGTime)+
                  ' AND CLAIM_REF = '+ QuotedStr(EData.Claim)+' AND SITE_ADDR1 = '+QuotedStr(EData.Address)
      else         // Tower doesn't have date
        SQL.Text := 'SELECT MAX(SEQNO) AS CNT FROM SALESORD_HDR WHERE CLAIM_REF = '+
                     QuotedStr(EData.Claim)+' AND SITE_ADDR1 = '+QuotedStr(EData.Address);
      WriteIf(qryGeneral.SQL.Text);
      Open;
      if FieldByName('CNT').IsNull then      // None exist so Insert
      begin
        WriteIf('*** No Duplicates');
        Close;
        WriteIf('****** Brand=['+EData.Brand+']');
        SQL.Text := 'SELECT X.DR_ACCNO, X.DR_ACCNO_ALT, D.PROVIDER_SEQNO FROM X_DRACC_BRAND X LEFT JOIN DR_ACCS D ON X.DR_ACCNO=D.ACCNO WHERE X.IAG_BRAND = '+QuotedStr(Copy(EData.Brand,1,20));
        Open;
        AccNo := FieldByName('DR_ACCNO').AsInteger;
        // Hard coded exception to deal with Direct Huon Bonus
        if UpperCase(Copy(Edata.Claim,1,3)) = 'DCC' then
          AccNo := FieldByName('DR_ACCNO_ALT').AsInteger;
        if EData.Provider <> FieldByName('PROVIDER_SEQNO').AsString then        // Change for AMI brand being sent by IAG
          EData.Provider := FieldByName('PROVIDER_SEQNO').AsString;  
        Close;
        SQL.Text := 'SELECT NAME FROM DR_ACCS WHERE ACCNO = '+IntToStr(AccNo);
        Open;
        Brand := FieldByName('Name').AsString;
        WriteIf('Brand=['+Brand+']');
        Close;
        SQL.Text := 'INSERT INTO SALESORD_HDR ('+
                    'PROVIDER_SEQNO, CR_ACCNO,STATUS, RECEIVED_DATE,LASTHISTORYNOTE,'+
                    'LASTEMAILUPDATE, OPERATOR, RECEIVED_FROM, OWNER_NAME, '+
                    'DR_ACCNO, NAME, INSURANCE_ACCNO, INSURANCE_NAME, SITE_NAME, SITE_ADDR1,'+
                    'SITE_ADDR2,SITE_ADDR3,OWNER_PHONE1,OWNER_PHONE2,PHONE,'+
                    'BROKER_NAME, BROKER_CONTACTNAME, BROKER_PHONE, '+
                    'SITE_NOTES,URGENT,REG_KIND, CLAIM_REF, POLICY_REF, EXCESS, EXCESS_REF, EXCESS_PAID, INVNO, ISFLOOD, ISSTAIN,'+
                    'DAMAGE_STRUCTURE, DAMAGE_CONTENTS, REQUEST, INBOX_SEQNO, COMMENT, ITEMDESC, ISCHECKED'+
                    ') VALUES ('+
                    EData.Provider+','+IntToStr(EData.BranchNo)+',0,'+QuotedStr(IAGTime)+','+
                    QuotedStr(IAGTime)+','+
                    QuotedStr(IAGTime)+','+
                    QuotedStr('AutoCallCentre')+','+
                    QuotedStr('Website Referral')+','+
                    //QuotedStr(EData.Name)+','+IntToStr(AccNo)+','+     // 5/7/2013 - this is because the InsuredName and TenantDetail are now used 
                    QuotedStr(EData.InsuredName)+','+IntToStr(AccNo)+','+
                    QuotedStr(Brand)+','+IntToStr(AccNo)+','+
                    QuotedStr(Brand)+','+
                    QuotedStr(EData.TenantDetail)+','+
                    QuotedStr(EData.Address)+','+
                    QuotedStr(EData.Suburb)+','+
                    QuotedStr(EData.City)+','+
                    QuotedStr(EData.HomePhone)+','+
                    QuotedStr(EData.WorkPhone)+','+
                    QuotedStr(EData.MobilePhone)+','+
                    QuotedStr(Copy(EData.Assessor,1,40))+','+
                    QuotedStr(Copy(EData.AssessorEMail,1,40))+','+
                    QuotedStr(Copy(EData.AssessorPhone+' '+EData.AssessorMobile,1,30))+','+
                    QuotedStr(EData.Description)+','+
                    Urgent+','+
                    QuotedStr(Kind)+','+
                    QuotedStr(EData.Claim)+','+
                    QuotedStr(EData.Policy)+','+
      							EData.Excess+','+
                    QuotedStr(EData.Excess_Ref)+','+
                    QuotedStr('N')+','+QuotedStr('NOT INVOICED')+','+
                    QuotedStr(Flood)+','+QuotedStr(Stain)+','+
                    QuotedStr(EData.SpecialIns)+','+
                    QuotedStr(EData.Area)+','+
                    QuotedStr(EData.Service)+','+
                    IntToStr(Edata.InBoxSeqNo)+','+
                    QuotedStr(Copy(EData.Comment,1,255))+','+
                    QuotedStr(Copy(EData.ItemDesc,1,255))+','+
                    QuotedStr(EData.IsTruncated)+
                    ')';
                    //showmessage(qryGeneral.SQL.Text);
        WriteIf(qryGeneral.SQL.Text);
        ExecSQL;
        Close;
        SQL.Text := 'SELECT MAX(SEQNO) AS JOB FROM SALESORD_HDR WHERE CR_ACCNO = '+IntToStr(EData.BranchNo);
        Open;
        Result := FieldByName('JOB').AsInteger;
        Close;
      end 
      else
      begin
        WriteIf('*** Duplicate !');
        Result := FieldByName('CNT').AsInteger;                 // Max(SeqNo) Where Claim No is duplicated
        Close;
        SQL.Text := 'UPDATE SALESORD_HDR SET INBOX_SEQNO = '+IntToStr(Edata.InBoxSeqNo)+' WHERE SEQNO = '+IntToStr(Result);
        ExecSQL;
        Close;
      end;
      SQL.Text := 'UPDATE X_INBOX SET HDR_SEQNO = '+IntToStr(Result)+' WHERE SEQNO='+IntToStr(Edata.InBoxSeqNo);
      ExecSQL;
      //end
      //else
      //  Result := -99;   // Job has already been created
    end;
  except
    on E: Exception do
    begin
      UpdateServiceLog(E.Message,'CreateJob');
      Result := 0;
    end;
  end;
end;

//==============================================================================
procedure TdmMain.SendEmailSMS(InfoType, JobNo, Response, ContactNo, OrderNo: integer; CellNo, Msg: string; ErrMsg: Boolean);
var
  {Bdy,} Urgent, Flood, Provider, MStr{, MStr2}: String;
  {i,} Cnt, MesLen: integer;
  AddAll, SendMore, SendFailed: Boolean;
const
  MSGMAX = 150;
  //===============================================================
  procedure AddText(Part: integer; Body: TStringList; Text: string);
  var
    PartText: string;
    //i: integer;
  begin
    if MesLen < MSGMAX then
    begin
      //MesLen := MesLen + length(Text);
      if MesLen + length(Text) < MSGMAX then
        Body.Add('text:'+Text)
      else
      begin
        if Part = 0 then
        begin
          PartText := Copy(Text,1,length(Text) - (MesLen - MSGMAX));
          Body.Add('text:'+PartText);
        end
        else
        begin
          PartText := Copy(Text, (MSGMAX-MesLen)*(Part-1)+1, MSGMAX-MesLen);
          if (length(PartText) < MSGMAX - 3) and (Part > 1) then
            PartText := '...'+PartText;
          Body.Add('text:'+PartText);
          if Length(PartText) = MSGMAX-MesLen then    // Full amount sent so probably more to go
            SendMore := True;
        end;
      end;
      MesLen := MesLen + length(Text);
    end;
  end;
  //===============================================================
begin
  try
    AddAll := False;
    SendFailed := True;
    MesLen := 0;
    if (InfoType <> 1) and (JobNo > 0) then   // We do not know the job information for those <> 1
    begin
      qryGeneral3.Close;
      qryGeneral3.SQL.Text := 'SELECT COUNT(*) AS CNT FROM X_INBOX WHERE HDR_SEQNO = '+IntToStr(JobNo);
      qryGeneral3.Open;
      Cnt := qryGeneral3.FieldByName('CNT').AsInteger;
      with qryGeneral do
      begin
        Close;
        SQL.Text := 'SELECT * FROM SALESORD_HDR WHERE SEQNO = '+IntToStr(JobNo);
        Open;
        WriteIf('SendEmailSMS Job '+IntToStr(JobNo));
      end;
      if qryGeneral.FieldByName('URGENT').AsInteger = 1 then
        Urgent := 'URGENT'
      else
        Urgent := 'Non Urgent';
      if qryGeneral.FieldByName('PROVIDER_SEQNO').AsInteger = 1 then
        Provider := ' IAG'
      else
        Provider := ' TWR';
      if (qryGeneral.FieldByName('ISFLOOD').AsString = 'Y') then
        Flood  := 'Flood'
      else
        Flood := 'Stain';
    end;
    with SMTP.PostMessage do
    begin
      ToAddress.Clear;
      ToAddress.Add(fClickATellAddress);
      //Subject := 'Job # '+qryGeneral.FieldByName('SeqNo').AsString;// Don't think that the subject makes any difference
      Body.Clear;
      Body.Add ('api_id:'+fClickATell_api_id);                     //1242811
      Body.Add ('user:'+fClickATell_UID);                          //RMTully
      Body.Add ('password:'+fClickATell_PWD);                      //rt6643
      //Body.Add ('concat:3');                                     // No more concatenation as we have problems with this
      // Temp to Test
      //Body.Add ('req_feat:32');                                    // Required feature SENDERID (32) - find a route that has the senderid guaranteed
      Body.Add ('mo:'+fMoParam);                                   // 1 or 0 changed bank - until ClickaTell tell me to change it back !
      Body.Add ('to:'+CellNo);                                     //6421721793
      Body.Add ('from:'+fClickATell_MO_NO);                         //'+fromCellNo
      case InfoType of
      0,2,3:
        begin
          if Cnt > 1 then
          begin
            AddText (0, Body, 'NEW INFO: Job '+qryGeneral.FieldByName('SeqNo').AsString+Provider);
            //Body.Add('reply:richard@acclaimgroup.co.nz');
            MesLen := length('NEW INFO: Job '+qryGeneral.FieldByName('SeqNo').AsString+Provider);
          end
          else
          begin
            AddText (0, Body, 'Job '+qryGeneral.FieldByName('SeqNo').AsString+Provider);
            MesLen := length('Job '+qryGeneral.FieldByName('SeqNo').AsString+Provider);
          end;
          MStr := Urgent +
                  ' CRef '+qryGeneral.FieldByName('Claim_Ref').AsString+
                  ' Name '+qryGeneral.FieldByName('Owner_Name').AsString+
                  ' Addr '+qryGeneral.FieldByName('Site_Addr1').AsString+','+qryGeneral.FieldByName('Site_Addr2').AsString+','+qryGeneral.FieldByName('Site_Addr3').AsString+
                  ' Ph '+qryGeneral.FieldByName('Owner_Phone1').AsString+','+qryGeneral.FieldByName('Owner_Phone2').AsString+','+qryGeneral.FieldByName('Phone').AsString+
                  ' Room '+qryGeneral.FieldByName('Damage_Contents').AsString+
                  ' Desc '+qryGeneral.FieldByName('Site_Notes').AsString+
                  ' Inst '+qryGeneral.FieldByName('Damage_Structure').AsString+
                  ' Excs '+qryGeneral.FieldByName('Excess').AsString+
                  ' Srvc '+Flood;
          if ErrMsg then
            MStr := Msg+' ' + MStr;
          AddText (1, Body, MStr);
        end;
      9:begin
          SendMore := False;
          Body.Add('text:Job('+IntToStr(Response)+') '+qryGeneral.FieldByName('SeqNo').AsString+Provider);
          MesLen := length('Job('+IntToStr(Response)+') '+qryGeneral.FieldByName('SeqNo').AsString+Provider);

          MStr := Urgent +
                  ' CRef '+qryGeneral.FieldByName('Claim_Ref').AsString+
                  ' Name '+qryGeneral.FieldByName('Owner_Name').AsString+
                  ' Addr '+qryGeneral.FieldByName('Site_Addr1').AsString+','+qryGeneral.FieldByName('Site_Addr2').AsString+','+qryGeneral.FieldByName('Site_Addr3').AsString+
                  ' Ph '+qryGeneral.FieldByName('Owner_Phone1').AsString+','+qryGeneral.FieldByName('Owner_Phone2').AsString+','+qryGeneral.FieldByName('Phone').AsString+
                  ' Room '+qryGeneral.FieldByName('Damage_Contents').AsString+
                  ' Desc '+qryGeneral.FieldByName('Site_Notes').AsString+
                  ' Inst '+qryGeneral.FieldByName('Damage_Structure').AsString+
                  ' Excs '+qryGeneral.FieldByName('Excess').AsString+
                  ' Srvc '+Flood;

          AddText (Response, Body, MStr);
        end;
      1,4,5:
        begin
          Body.Add ('text: *** '+msg+' ***');
          Body.Add ('text: See Inbox data');
        end;
      end;
    end;

    try
      WriteIf('SendEmailSMS - SMTP before connect');
      if not SMTP.Connected then
        SMTP.Connect;
      WriteIf('SendEmailSMS - SMTP AFTER connect');
      if DEBUG then
      begin
        SMTP.PostMessage.ToAddress.Clear;
        SMTP.PostMessage.ToAddress.Add('richard@acclaimgroup.co.nz');
        WriteIf('Email to Richard 1');
      end;
      WriteIf('Email to:'+SMTP.PostMessage.ToAddress[0]);
      SMTP.SendMail;
      SendFailed := False;
    finally
      SMTP.Disconnect;
    end;
  finally
    //if (InfoType <> 4) then   // This has JobNo = 0 and the above query is not done (JobNo <> 0)
    if (not ErrMsg) or (ErrMsg and SendFailed) then    // If Normal Branch email or we were trying to Email Support and it failed 
    begin
      with qryGeneral3 do
      begin
        Close;
        if InfoType <> 9 then  // Normally we update X_SMSLOG
        begin
          SQL.Text := 'INSERT INTO X_SMSLOG (JOBNO, BRANCHNO, CONTACTNO, ORDERNO, TIMESENT, RESPONSEREQUIRED) VALUES ('+
                      qryGeneral.FieldByName('SEQNO').AsString+','+
                      qryGeneral.FieldByName('CR_ACCNO').AsString+','+  
                      IntToStr(ContactNo)+','+IntToStr(OrderNo)+','+QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',NOW))+
                      ', Date_Add('+QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',NOW))+', Interval '+IntToStr(Response)+' minute)'+
                      //IntToStr(ContactNo)+','+IntToStr(OrderNo)+',Now(), Date_Add(Now(), Interval '+IntToStr(Response)+' minute)'+
                      ')'
        end
        else
        begin                // But if it is a request for more info we update X_SMS_REQUEST - Just getting the time sent from the local machine so there could be a discrepancy here
          if SendMore then  // More data to be sent
            SQL.Text := 'UPDATE X_SMS_REQUEST SET PARTREQUIRED = '+IntToStr(Response+1)+
                        ' WHERE JOBNO = '+IntToStr(JobNo)+' AND CELLPHONE = '+QuotedStr(CellNo)
          else
            SQL.Text := 'UPDATE X_SMS_REQUEST SET ISOUTSTANDING = '+QuotedStr('N')+', SENT='+QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',now))+
                        ' WHERE JOBNO = '+IntToStr(JobNo)+' AND CELLPHONE = '+QuotedStr(CellNo);
        end;
        ExecSQL;
      end;
    end;
    qryGeneral3.Close;
    qryGeneral.Close;
  end;
end;

//==============================================================================
procedure TdmMain.SendBranchEmail(InfoType, JobNo, Response, ContactNo, OrderNo: integer; CellNo, Msg: string; HasEData: Boolean; EData:TEmailData);
var
  {Bdy,} EMailAddress, FileName, FileText, Urgent, Flood, ToAdd, PartAdd, Prov: String;
  {i, }InBoxSeqNo, FileSize, Cnt: integer;
  AddAll: Boolean;
  F: TextFile;
begin
  AddAll := True;
  if InfoType <> 1 then   // We do not know the job information for those = 1
  begin
    with qryGeneral do
    begin
      Close;
      SQL.Text := 'SELECT S.SEQNO, S.URGENT, S.ISFLOOD, S.CLAIM_REF, S.OWNER_NAME,  C.EMAIL, S.INBOX_SEQNO, '+
                  'S.SITE_ADDR1, S.SITE_ADDR2, S.SITE_ADDR3, S.OWNER_PHONE1, S.OWNER_PHONE2, S.PHONE, S.DAMAGE_CONTENTS, '+
                  'S.SITE_NOTES, S.DAMAGE_STRUCTURE, S.EXCESS, S.PROVIDER_SEQNO '+
                  'FROM SALESORD_HDR S LEFT JOIN CR_ACCS C ON S.CR_ACCNO = C.ACCNO WHERE S.SEQNO = '+IntToStr(JobNo);
      Open;
      case qryGeneral.FieldByName('Provider_SeqNo').AsInteger of
        1: Prov := ' IAG';
        2: Prov := ' TWR';
      end;
      EMailAddress := qryGeneral.FieldByName('EMail').AsString;
      InBoxSeqNo := qryGeneral.FieldByName('INBOX_SEQNO').AsInteger;
      qryGeneral3.Close;
      qryGeneral3.SQL.Text := 'SELECT COUNT(*) AS CNT FROM X_INBOX WHERE HDR_SEQNO = '+IntToStr(JobNo);
      qryGeneral3.Open;
      Cnt := qryGeneral3.FieldByName('CNT').AsInteger;
      qryGeneral3.Close;
      qryGeneral3.SQL.Text := 'SELECT * FROM X_INBOX WHERE SEQNO = '+IntToStr(InBoxSeqNo);
      qryGeneral3.Open;
    end;
    if Length(EMailAddress) < 5 then   // No point in continuing if there is no valid email address
      Exit;

    if qryGeneral.FieldByName('Urgent').AsInteger = 1 then
      Urgent := 'URGENT'
    else
      Urgent := 'Not Urgent';
    if (qryGeneral.FieldByName('IsFlood').AsString = 'Y') then
      Flood  := 'Flood'
    else
      Flood := 'Stain';
  end
  else
  begin                     // Infotype <> 1
    EMailAddress := 'richard@acclaimgroup.co.nz';
  end;
  with SMTP.PostMessage do
  begin
    ToAdd := EMailAddress;
    ToAddress.Clear;

    while pos(';', ToAdd) > 0 do
    begin
      PartAdd := Copy (ToAdd, 1, pos(';', ToAdd)-1);
      ToAddress.Add(PartAdd);
      ToAdd := Copy(ToAdd, pos(';', ToAdd)+1, Length(ToAdd)-pos(';',ToAdd));
    end;
    ToAddress.Add(ToAdd);

    Body.Clear;
    //Body.Add ('Message sent to:'+CellNo + ' ' + msg);
    case InfoType of
    0,2:
      begin
        Subject := ' Job # '+IntToStr(JobNo)+' - '+qryGeneral3.FieldByName('SUBJECT').AsString;
        if Cnt > 1 then
          Subject := 'Email # '+IntToStr(Cnt)+' '+Subject
        else
          Subject := 'New'+Subject;
        // Possibly name this either .txt or .html depending on the file that is created  ie
        if pos('<html',Copy(qryGeneral3.FieldByName('BODY').AsString,1,10)) > 0 then
          FileName := 'Job'+IntToStr(JobNo)+'.html'
        else
          FileName := 'Job'+IntToStr(JobNo)+'.txt';
        AssignFile(F, FileName);
        ReWrite(F);
        FileText :=qryGeneral3.FieldByName('BODY').AsString;
        FileSize := Length(qryGeneral3.FieldByName('BODY').AsString);
        WriteLn(F, FileText);
        CloseFile(F);
        Attachments.Add(FileName);
        //====================
        if HasEData then
        begin
          Body.Add('Claim Details');
          Body.Add('-------------');
          Body.Add('Provider: '+Edata.Provider);
          Body.Add('Claim: '+Edata.Claim);
          Body.Add('Kind: '+Edata.RegKind);
          Body.Add('Risk: '+Edata.Risk);
          Body.Add('Brand: '+Edata.Brand);

          Body.Add('Date: '+Edata.Date);
          Body.Add('Time: '+Edata.Time);
          Body.Add('From: '+Edata.From);

          Body.Add(' ');
          Body.Add('Contact Person');
          Body.Add('--------------');
          Body.Add('InsuredName: '+Edata.InsuredName);
          Body.Add('Name: '+Edata.Name);
          Body.Add('Address: '+Edata.Address);
          Body.Add('Suburb: '+Edata.Suburb);
          Body.Add('City: '+Edata.City);
          Body.Add('Country: '+Edata.Country);
          Body.Add('HomePhone: '+Edata.HomePhone);
          Body.Add('WorkPhone: '+Edata.WorkPhone);
          Body.Add('MobilePhone: '+Edata.MobilePhone);
          Body.Add('Email: '+Edata.Email);
          Body.Add(' ');
          Body.Add('Tenanted: '+Edata.Tenanted);
          Body.Add('TenantDetail: '+Edata.TenantDetail);

          Body.Add(' ');
          Body.Add('Details');
          Body.Add('-------');
          Body.Add('Description: '+Edata.Description);
          Body.Add('SpecialIns: '+Edata.SpecialIns);
          Body.Add('Excess: '+Edata.Excess);
          Body.Add('Urgency: '+Edata.Urgency);
          Body.Add('Service: '+Edata.Service);
          Body.Add('Area: '+Edata.Area);

          Body.Add(' ');
          Body.Add('Assessor');
          Body.Add('--------');
          Body.Add('Assessor: '+Edata.Assessor);
          Body.Add('AssessorEMail: '+Edata.AssessorEMail);
          Body.Add('AssessorPhone: '+Edata.AssessorPhone);
          Body.Add('AssessorMobile: '+Edata.AssessorMobile);

          Body.Add(' ');
          Body.Add('Other Detail');
          Body.Add('------------');
          Body.Add('AfterHours: '+Edata.AfterHours);
          Body.Add('OtherDesc: '+Edata.OtherDesc);
          Body.Add('ItemNo: '+Edata.ItemNo);
          Body.Add('AItemNo: '+Edata.AItemNo);
          Body.Add('AReason: '+Edata.AReason);
          Body.Add('ItemType: '+Edata.ItemType);
          Body.Add('Coverage: '+Edata.Coverage);
          Body.Add('Salvage: '+Edata.Salvage);
          Body.Add('Loc: '+Edata.Loc);
          Body.Add('Comment: '+Edata.Comment);
          Body.Add('ItemDesc: '+Edata.ItemDesc);
          Body.Add('IsTruncated: '+Edata.IsTruncated);
        end;
        Body.Add ('--------------------------------------');
        Body.Add ('See html/txt file for original message');
        Body.Add ('--------------------------------------');
        //{$IFNDEF ISCC}
        if fUseSMS then
        begin
          Body.Add('Data sent to CellPhone ['+CellNo+'] follows:');
          Body.Add ('------------------------------');
        end;
        //{$ENDIF}
        Body.Add ('Job#: '+qryGeneral.FieldByName('SeqNo').AsString+Prov);
        Body.Add (msg);
        Body.Add (Urgent);
        Body.Add ('CRef: '+qryGeneral.FieldByName('Claim_Ref').AsString);
        Body.Add ('Name: '+qryGeneral.FieldByName('Owner_Name').AsString);
        Body.Add ('Addr: '+qryGeneral.FieldByName('Site_Addr1').AsString+','+qryGeneral.FieldByName('Site_Addr2').AsString+','+qryGeneral.FieldByName('Site_Addr3').AsString);
        Body.Add ('Ph #: '+qryGeneral.FieldByName('Owner_Phone1').AsString+','+qryGeneral.FieldByName('Owner_Phone2').AsString+','+qryGeneral.FieldByName('Phone').AsString);
        if AddAll then
        begin
          Body.Add ('Room: '+qryGeneral.FieldByName('Damage_Contents').AsString);
          Body.Add ('Desc: '+qryGeneral.FieldByName('Site_Notes').AsString);
          Body.Add ('Inst: '+qryGeneral.FieldByName('Damage_Structure').AsString);
          Body.Add ('Excs: '+qryGeneral.FieldByName('Excess').AsString);
          Body.Add ('Srvc: '+Flood);
        end;
        //====================
      end;
    1:begin
        Body.Add ('*** '+msg+' ***');
        Body.Add ('See Inbox data - Call Acclaim for assistance');
      end;
    end;
  end;
  try
    if not SMTP.Connected then
      SMTP.Connect;
    if DEBUG then
    begin
      SMTP.PostMessage.ToAddress.Clear;
      SMTP.PostMessage.ToAddress.Add('richard@acclaimgroup.co.nz');
      WriteIf('Email to Richard 2');
    end;
    WriteIf('SendBranchEmail');
    WriteIf('Email to:'+SMTP.PostMessage.ToAddress[0]);
    SMTP.SendMail;
  finally
    WriteIf('Finally - SMTP Disconnect');
    SMTP.Disconnect;
  end;
  qryGeneral.Close;
end;
// THIS ROUTINE IS NOT USED ANYWHERE !!!!
//==============================================================================
{procedure TdmMain.SendBranchReminder(JobNo: integer);
var
  EMailAddress, PartAdd, ToAdd: String;
  Seqno: Integer;
begin
  with qryGeneral do
  begin
    Close;
    SQL.Text := 'SELECT S.SEQNO, S.REMINDER_NOTE, C.EMAIL '+
                'FROM SALESORD_HDR S LEFT JOIN CR_ACCS C ON S.CR_ACCNO = C.ACCNO WHERE S.SEQNO = '+IntToStr(JobNo);
    Open;
    EMailAddress := qryGeneral.FieldByName('EMail').AsString;
    SeqNo :=qryGeneral.FieldByName('SeqNo').AsInteger;
  end;
  if Length(EMailAddress) < 5 then   // No point in continuing if there is no valid email address
    Exit;
  with SMTP.PostMessage do
  begin
    ToAdd := EMailAddress;
    ToAddress.Clear;

    while pos(';', ToAdd) > 0 do
    begin
      PartAdd := Copy (ToAdd, 1, pos(';', ToAdd)-1);
      ToAddress.Add(PartAdd);
      ToAdd := Copy(ToAdd, pos(';', ToAdd)+1, Length(ToAdd)-pos(';',ToAdd));
    end;
    ToAddress.Add(ToAdd);

    Body.Clear;

    Subject := 'Job # '+IntToStr(JobNo)+' - Reminder';
    Body.Add ('Job # '+IntToStr(JobNo)+' - Reminder');
    Body.Add ('----------------------------------');
    Body.Add (qryGeneral.FieldByName('REMINDER_NOTE').AsString);
  end;
  try
    if not SMTP.Connected then
      SMTP.Connect;
    if DEBUG then
    begin
      SMTP.PostMessage.ToAddress.Clear;
      SMTP.PostMessage.ToAddress.Add('richard@acclaimgroup.co.nz');
      WriteIf('Email to Richard 3');
    end;
    WriteIf('Email to:'+SMTP.PostMessage.ToAddress[0]);
    SMTP.SendMail;
  finally
    SMTP.Disconnect;
    with qryGeneral do
    begin
      Close;
      SQL.Text := 'UPDATE SALESORD_HDR SET REMINDER_SENT = '+QUOTEDSTR('Y')+
                  ' WHERE SEQNO = '+intToStr(SeqNo);
      ExecSQL;
    end;
  end;
  qryGeneral.Close;
end;
}
//==============================================================================
procedure TdmMain.SMSBranch(LastSent, JobNo:Integer; HasEData: Boolean; EData: TEmailData);
var
  IsOK : Boolean;
  CellNo, Nme{, TimeStr} : String;
  EDataNull: TEMailData;
  //hr: integer;
  Response, ContactNo, OrderNo, Branch: integer;
begin
  try
    IsOK := False;
    if fUseSMS then
    begin
      with qryGeneral2 do
      begin
        Close;
        SQL.Text := 'SELECT CR_ACCNO FROM SALESORD_HDR WHERE SEQNO = '+IntToStr(JobNo);
        Open;
        Branch := FieldByName('CR_ACCNO').AsInteger;
        Close;
        //SQL.Text := 'SELECT curtime() AS TME FROM X_GENERALINFO';        //Open;        //TimeStr := FieldByName('TME').AsString;        //Close;        // String does not get returned as expected so fix it        //hr := StrToInt(Copy(TimeStr, 1, pos(':', TimeStr)-1));        //if (Pos('p',TimeStr) > 0) and (hr < 12) then        //  hr := hr + 12;        //TimeStr := Format('%2.2d%s',[hr,Copy(TimeStr,pos(':',TimeStr),6)]);
        SQL.Text := 'SELECT * FROM X_BRANCHSMS'+
                  ' WHERE BRANCHNO = '+IntToStr(Branch)+
                  ' AND ISACTIVE = '+QuotedStr('Y')+
                  ' AND CONTACTORDER > '+IntToStr(LastSent)+
                  ' AND FROMDOW <= DayOfWeek('+QuotedStr(FormatDateTime('yyyy-mm-dd',Date))+')'+
                  ' AND TODOW >= DayOfWeek('+QuotedStr(FormatDateTime('yyyy-mm-dd',Date))+')'+
                  ' AND FROMTIME <= '+QuotedStr(FormatDateTime('0000-00-00 hh:nn:ss',Now))+ //'+curtime()'+
                  ' AND TOTIME >= '+QuotedStr(FormatDateTime('0000-00-00 hh:nn:ss',Now))+   //'+curtime()'+
                  ' ORDER BY CONTACTORDER';
        Open;
        if (not qryGeneral2.FieldByName('CELLPHONE').IsNull) then
        begin
          IsOK := true;
          CellNo := qryGeneral2.FieldByName('CELLPHONE').AsString;
          Nme := qryGeneral2.FieldByName('NAME').AsString;
          ContactNo :=qryGeneral2.FieldByName('SEQNO').AsInteger;
          OrderNo := qryGeneral2.FieldByName('CONTACTORDER').AsInteger;
          Response := qryGeneral2.FieldByName('RESPONSEMINUTE').AsInteger;
        end;
      end;
      qryGeneral2.Close;
    end;
    if not IsOK then  // if there are no more contact for the branch send to Support
    begin
      CellNo := fSupportCellNo;
      ContactNo := SUPPORTCONTACTNO;
      OrderNo := SUPPORTCONTACTNO;
      Nme := 'Support';
    end;
    if fUseSMS then
      SendEmailSMS(2,JobNo, Response, ContactNo, OrderNo, CellNo, Nme, False);

    if LastSent = 0 then // This is the first SMS sent so email the branch as well
    begin
      WriteIf ('Call - SendBranchEmail');
      SendBranchEmail(2,JobNo, Response, ContactNo, OrderNo, CellNo, Nme, HasEdata, EData);
      WriteIf ('Return - SMSBranch from SendBranchEmail');
    end

  except
    on E: Exception do
    begin
      WriteIf('SMSBranch Error');
      UpdateServiceLog(E.Message,'SMSBranch');
      InformSupport(2, JobNo, EDataNull, True);     // Error SMSing branch
    end;
  end;
end;

//==============================================================================
procedure TdmMain.InformSupport(InfoType, JobNo: Integer; EData: TEMailData; EMail: Boolean);
begin
  if fUseSMS then
    SMSSupport(InfoType, JobNo, EData);
  if (not fUseSMS) or EMail then
    EMailSupport(InfoType, JobNo, EData);
end;

//==============================================================================
procedure TdmMain.EMailSupport(InfoType, JobNo:Integer; EData: TEMailData);
begin
  // Not sure if this is necessay
  SendBranchEmail(InfoType,JobNo, 0, SUPPORTCONTACTNO, SUPPORTCONTACTNO, '', '', True,EData);
end;

//==============================================================================
procedure TdmMain.DeleteEmail(i: Integer; IsValidMessage: Boolean);
var
  CanDelete: Boolean;
begin
  //
  //  This does not Delete Valid messages when in DEBUG mode (ie so we can use them again as we are testing
  //
  CanDelete := (((not DEBUG) or (not IsValidMessage)) and Pop3.Connected);
  if CanDelete then
  begin
    Pop3.DeleteMailMessage(i);
  end;
end;

// InfoType 0 - Cannot identify Branch;  1 - no Job Created;  2 - No EMailData
//==============================================================================
procedure TdmMain.SMSSupport(InfoType, JobNo:Integer; EData: TEMailData);
var
  SMSMessage: String;
  Response: integer;
begin
  case InfoType of
  0: begin
       SMSMessage := 'Job # '+IntToStr(JobNo)+ '- Cannot identify BRANCH or not informed';
     end;
  1: begin
       SMSMessage := 'NO JOB CREATED - InBox SeqNo = '+IntToStr(Edata.InBoxSeqNo);
     end;
  2: begin
       SMSMessage := 'Job # '+IntToStr(JobNo)+ ' Error sending SMS to branch';
     end;
  3: begin
       SMSMessage := 'Job # '+IntToStr(JobNo)+ ' Error in process after creating Job';
     end;
  4: begin
       SMSMessage := 'Critical EMail Exception - Contact Richard (021721793)';
       UpdateServiceLog('Critical EMail Exception - Contact Richard (021721793)','SMSSupport');
     end;
  5: begin
       SMSMessage := 'Error retrieving EMail - InBox SeqNo = '+IntToStr(Edata.InBoxSeqNo);
     end;

  end;
  Response := 5;   // This should not make any difference as the Support person is the last one to receive an SMS
  SendEmailSMS(InfoType, JobNo, Response, SUPPORTCONTACTNO, SUPPORTCONTACTNO, fSupportCellNo, SMSMessage,True);
end;

//==============================================================================
function TdmMain.MessageActionRequired: Boolean;
begin
  with qryGeneral do
  begin
    Close;
    SQL.Text := 'SELECT JOBNO FROM X_SMSLOG WHERE ISOUTSTANDING = '+QuotedStr('Y')+
                ' GROUP BY JOBNO'+
                ' HAVING MAX(ORDERNO) < '+IntToStr(SUPPORTCONTACTNO)+     
                ' AND '+QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',NOW))+' > MAX(RESPONSEREQUIRED)';
                //' AND NOW() > MAX(RESPONSEREQUIRED)';
                ;
    Open;
    WriteIf('Message Action Required Job:'+FieldByName('JOBNO').AsString);
    Result := (FieldByName('JOBNO').AsInteger > 0);
  end;
end;

//==============================================================================
procedure TdmMain.SendMoreInfo;
var
  //To: String;
  SeqNo, JobNo, Part: integer;
  CellNo: String;
begin
  WriteIf('SendMoreInfo Start');
  with qryMoreInfo do
  begin
    //SQL.Text := 'SELECT JOBNO, CELLPHONE, PARTREQUIRED FROM X_SMS_REQUEST WHERE ISOUTSTANDING = '+QuotedStr('Y')+' ORDER BY RECEIVED';
    Open;
    WriteIf('SendMoreInfo Query Open');
    qryMoreInfo.First;
    while not qryMoreInfo.Eof do
    begin
      try
        SeqNo := qryMoreInfo.FieldByName('SEQNO').AsInteger;
        JobNo := qryMoreInfo.FieldByName('JOBNO').AsInteger;
        Part := qryMoreInfo.FieldByName('PARTREQUIRED').AsInteger;
        CellNo := qryMoreInfo.FieldByName('CELLPHONE').AsString;
        // Only if Job exists
        WriteIf('SendMoreInfo Job '+IntToStr(JobNo));
        qryGeneral3.Close;
        qryGeneral3.SQL.Text := 'SELECT COUNT(*) AS CNT FROM SALESORD_HDR WHERE SEQNO = '+IntToStr(JobNo);
        qryGeneral3.Open;
        if (qryGeneral3.FieldByName('CNT').AsInteger = 1) then
        begin
          WriteIf('SendMoreInfo - SendEmailSMS');
          SendEmailSMS(9,JobNo, Part,0,0, CellNo, '', False);            // Request for job info
        end
        else
        begin
          qryGeneral3.Close;
          qryGeneral3.SQL.Text := 'UPDATE X_SMS_REQUEST SET ISOUTSTANDING = '+QuotedStr('N')+', SENT='+QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',now))+
                      ' WHERE SEQNO = '+IntToStr(SeqNo);
          WriteIf(qryGeneral3.SQL.Text);
          qryGeneral3.ExecSQL;
        end;
      except
        on E: Exception do
          UpdateServiceLog(E.Message,'SendMoreInfo');
      end;
      qryMoreInfo.Next;
    end;
    WriteIf('SendMoreInfo End of File');
    Close;
  end;
  WriteIf('SendMoreInfo End');
end;
//==============================================================================
procedure TdmMain.FixNumbers(var ToNum: string; var FromNum: string);
begin
  while pos('0',ToNum) = 1 do
    ToNum := copy(ToNum,2,length(ToNum)-1);
  if pos('64',ToNum) <> 1 then
    ToNum := '64'+ToNum;
  if pos('27',ToNum) = 3 then   // Its to Telecom
    if pos('64',FromNum) = 1 then
      FromNum := Copy(FromNum,3,length(FromNum)-2);     // Now remove the 0 and see what happens
      //FromNum := '0'+Copy(FromNum,3,length(FromNum)-2);
end;

procedure TdmMain.SendSMS(SendTo, ReplyNo: string; ABody: TStringList);
begin
  FixNumbers(SendTo, ReplyNo);
  with SMTP.PostMessage do
  begin
    ToAddress.Clear;
    ToAddress.Add(fClickATellAddress);
    //ToCarbonCopy.Clear;
    //ToCarbonCopy.Add('richard@acclaimgroup.co.nz');
    Body.Clear;
    Body.Add ('api_id:'+fClickATell_api_id);                     //1242811
    Body.Add ('user:'+fClickATell_UID);                          //RMTully
    Body.Add ('password:'+fClickATell_PWD);                      //rt6643
    //Body.Add ('mo:0');
    //Body.Add ('req_feat:32');                                    // Required feature SENDERID (32) - find a route that has the senderid guaranteed
    Body.Add ('to:'+SendTo);                                     //6421721793
    Body.Add ('from:'+ReplyNo);                                  //'+fromCellNo
    Body.Add('text:'+ABody.Text);
  end;
  try
    WriteIf('SendSMS - SMTP before connect');
    if not SMTP.Connected then
      SMTP.Connect;
    WriteIf('SendSMS - SMTP AFTER connect ReplyNo:'+ReplyNo);
    if DEBUG then
    begin
      SMTP.PostMessage.ToAddress.Clear;
      SMTP.PostMessage.ToAddress.Add('richard@acclaimgroup.co.nz');
      WriteIf('Email to Richard 1');
    end;
    WriteIf('Email to:'+SMTP.PostMessage.ToAddress[0]);
    SMTP.SendMail;
  finally
    SMTP.Disconnect;
  end;
end;

procedure TdmMain.SendEMail(EAdd, Subj, FName:string; ABody: TStringList);
var
  i: integer;
  Address: string;
begin
  with SMTP.PostMessage do
  begin
    ToAddress.Clear;

    while pos(';',EAdd) > 0 do
    begin
      Address := Copy(EAdd,1,pos(';',EAdd)-1);
      ToAddress.Add(Address);
      EAdd := Copy(EAdd, pos(';',EAdd)+1, length(EAdd)-pos(';',EAdd));
    end;
    ToAddress.Add(EAdd);

    Subject := Subj;
    Body.Clear;
    for i := 0 to ABody.Count-1 do
      Body.Add (ABody[i]);
    (* // We do not seem to be able to add attachments like this !! 
    if (FName <> '') then
    begin
      WriteIf('Email Attachments');
      Attachments.Clear;
      Attachments.Add(FName);
    end
    else
      WriteIf('NO Email Attachments');
    *)
  end;
  try
    WriteIf('SMTP - Try Connect');
    if not SMTP.Connected then
      SMTP.Connect;
    if DEBUG then
    begin
      SMTP.PostMessage.ToAddress.Clear;
      SMTP.PostMessage.ToAddress.Add('richard@acclaimgroup.co.nz');
      WriteIf('Email to Richard 4');
    end;
    WriteIf('Email to:'+SMTP.PostMessage.ToAddress[0]);
    SMTP.SendMail;
    WriteIf('Sent');
  finally
    SMTP.Disconnect;
    WriteIf('Disconnected');
  end;
end;

//==============================================================================
procedure TdmMain.SendReminders;
var
  SOHSeqNo: Integer;
  PBody: TStringList;
  EAdd, Subj, InSeqNo, FName, Reply, DR_Acc, CR_Acc: String;
  //========================
  procedure SendGeneralEmails;
  begin
    WriteIf('SGE1');
    qryGeneral2.Close;
    qryGeneral2.SQL.Text := 'SELECT SEQNO, BATCHNO, EMAIL, SUBJECT, BODY, FILE, ISSMS, REPLYTO '+
       'FROM X_SENDEMAIL WHERE SEND='+QuotedStr('Y');
    //WriteIf(qryGeneral2.SQL.Text);
    qryGeneral2.Open;
    WriteIf('SGE2');
    while not qryGeneral2.Eof do
    begin
      WriteIf('SGE3');
      PBody.Clear;
      Subj := qryGeneral2.FieldByName('SUBJECT').AsString;
      PBody.Add(qryGeneral2.FieldByName('BODY').AsString);

      EAdd := qryGeneral2.FieldByName('EMAIL').AsString;
      FName := qryGeneral2.FieldByName('FILE').AsString;
      Reply := qryGeneral2.FieldByName('REPLYTO').AsString;
      WriteIf('SGE4');
      // Send Email
      if (EAdd <> '') then
      begin
        WriteIf('SGE5 Replyto:'+Reply);
        if (qryGeneral2.FieldByName('ISSMS').AsString = 'Y') then
        begin
          PBody.Text := Copy(PBody.Text,1,160);
          SendSMS(EAdd, Reply, PBody);
        end
        else
          SendEMail(EAdd, Subj, FName, PBody);
        // Update Field
        WriteIf('SGE6');
        qryGeneral3.Close;                                                
        //qryGeneral3.SQL.Text := 'UPDATE X_SENDEMAIL SET SEND='+QuotedStr('S')+',DATESENT=NOW()'+
        qryGeneral3.SQL.Text := 'UPDATE X_SENDEMAIL SET SEND='+QuotedStr('S')+',DATESENT='+QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',NOW))+
                                ' WHERE SEQNO = '+qryGeneral2.FieldByName('SEQNO').AsString;
        qryGeneral3.ExecSQL;
        WriteIf('SGE7');
      end;
      WriteIf('SGE8');
      qryGeneral2.Next;
    end;
    WriteIf('SGE9');
  end;
  //========================
  procedure SendImmediate;
  begin
    WriteIf('Send Immediate');
    qryGeneral2.Close;
    qryGeneral2.SQL.Text := 'SELECT H.SEQNO, H.HDR_SEQNO, H.TRANSDATE, H.NOTE, S.CLAIM_REF '+
       'FROM HISTORY_NOTES H LEFT JOIN SALESORD_HDR S ON H.HDR_SEQNO = S.SEQNO WHERE H.SEND_NOW='+QuotedStr('Y');
    //WriteIf(qryGeneral2.SQL.Text);
    qryGeneral2.Open;
    while not qryGeneral2.Eof do
    begin
      WriteIf('SI4');
      PBody.Clear;
      Subj := 'Job Status Update - Claim # '+qryGeneral2.FieldByName('CLAIM_REF').AsString;
      PBody.Add('Job Status Update');
      PBody.Add('Job # '+qryGeneral2.FieldByName('HDR_SEQNO').AsString);
      PBody.Add('Claim # '+qryGeneral2.FieldByName('CLAIM_REF').AsString);
      PBody.Add('====================');
      PBody.Add(FormatDateTime('yyyy/mm/dd',qryGeneral2.FieldByName('TRANSDATE').AsDateTime)+' '+qryGeneral2.FieldByName('NOTE').AsString);
      // Get Email
      qryGeneral3.Close;
      qryGeneral3.SQL.Text := 'SELECT D.EMAIL AS DEFMAIL, B.EMAIL '+
                              'FROM SALESORD_HDR H LEFT JOIN DR_ACCS D ON H.INSURANCE_ACCNO = D.ACCNO '+
                              'LEFT JOIN X_BRANCH_BRAND B ON H.CR_ACCNO = B.CR_ACCNO AND H.PROVIDER_SEQNO = B.PROVIDER_SEQNO '+
                              'WHERE H.SEQNO = '+qryGeneral2.FieldByName('HDR_SEQNO').AsString;
      qryGeneral3.Open;
      WriteIf('SI5 '+qryGeneral2.FieldByName('HDR_SEQNO').AsString);
      EAdd := qryGeneral3.FieldByName('EMAIL').AsString;
      if ((qryGeneral3.FieldByName('EMAIL').IsNull) or (Length(Trim(qryGeneral3.FieldByName('EMAIL').AsString))<5) ) then
        EAdd := qryGeneral3.FieldByName('DEFMAIL').AsString;
      // Send Email
      WriteIf('SI5 To:'+EAdd);
      if (EAdd <> '') then
      begin
        SendEMail(EAdd, Subj,'', PBody);
        // Update Field
        WriteIf('SI5a');
        // AND WE SHOULD UPDATE THE SALESORD_HDR
        qryGeneral3.Close;
        qryGeneral3.SQL.Text := 'UPDATE SALESORD_HDR SET LASTEMAILUPDATE = '+QuotedStr(FormatDateTime('yyyy-mm-dd',Date))+', '+
                                'BRANCHREMINDED='+QuotedStr('N')+
                                ' WHERE SEQNO = '+qryGeneral2.FieldByName('HDR_SEQNO').AsString;
        //WriteIf(qryGeneral3.SQL.Text);
        qryGeneral3.ExecSQL;
        qryGeneral3.Close;
        qryGeneral3.SQL.Text := 'UPDATE HISTORY_NOTES SET SEND_NOW='+QuotedStr('S')+
                                ' WHERE SEQNO = '+qryGeneral2.FieldByName('SEQNO').AsString+
                               ' AND SEND_NOW='+QuotedStr('Y');
        qryGeneral3.ExecSQL;
      end
      else
        WriteIf('SI5b');
      WriteIf('SI6');
      qryGeneral2.Next;
    end;
  end;
  //========================
  procedure SendHistoryNotes;
    //----------------------
    procedure SendToProvider;
    begin
      qryGeneral2.Close;
      qryGeneral2.SQL.Text := 'SELECT H.SEQNO, H.CLAIM_REF, P.SEND_KPI,'+qryGeneral.FieldByName('CHECKFIELD').AsString +
                              ' FROM SALESORD_HDR H LEFT JOIN X_PROVIDER P ON H.PROVIDER_SEQNO = P.SEQNO'+
                              ' WHERE (DATEDIFF('+QuotedStr(FormatDateTime('yyyy-mm-dd',Date))+','+qryGeneral.FieldByName('CHECKFIELD').AsString+') > '+qryGeneral.FieldByName('DAYSTOPROVIDER').AsString+
                              ' ) AND (H.STATUS BETWEEN '+ qryGeneral.FieldByName('STATUSFROM').AsString +' AND '+ qryGeneral.FieldByName('STATUSTO').AsString+
                              ' ) AND (P.SEND_KPI = '+QuotedStr('Y')+')';
      WriteIf(qryGeneral2.SQL.Text);
      qryGeneral2.Open;
      while not qryGeneral2.Eof do
      begin
        WriteIf('3');
        if (qryGeneral2.FieldByName('SEND_KPI').AsString = 'Y') then
        begin
          PBody.Clear;
          SOHSeqNo := qryGeneral2.FieldByName('SEQNO').AsInteger;
          qryGeneral3.Close;
          qryGeneral3.SQL.Text := 'SELECT * FROM HISTORY_NOTES WHERE HDR_SEQNO = '+intToStr(SOHSeqNo)+
                                 ' AND DATEDIFF(TRANSDATE, '+QuotedStr(FormatDateTime('yyyy-mm-dd',qryGeneral2.FieldByName(qryGeneral.FieldByName('CHECKFIELD').AsString).AsDateTime))+') > 0'+
                                 ' AND SEND_NOW='+QuotedStr('N');
          WriteIf(qryGeneral3.SQL.Text);
          qryGeneral3.Open;

          WriteIf('4');
          Subj := qryGeneral.FieldByName('SUBJECTPROVIDER').AsString+' Claim # '+qryGeneral2.FieldByName('CLAIM_REF').AsString;
          PBody.Add(qryGeneral.FieldByName('BODYPROVIDER').AsString);
          PBody.Add('Job # '+IntToStr(SOHSeqNo));
          PBody.Add('Claim # '+qryGeneral2.FieldByName('CLAIM_REF').AsString);
          PBody.Add('====================');
          while not qryGeneral3.Eof do
          begin
            PBody.Add(FormatDateTime('yyyy/mm/dd',qryGeneral3.FieldByName('TRANSDATE').AsDateTime)+' '+qryGeneral3.FieldByName('NOTE').AsString);
            qryGeneral3.Next;
          end;
          // Get Email
          qryGeneral3.Close;
          qryGeneral3.SQL.Text := 'SELECT B.EMAIL_HIST AS DEFMAIL, D.EMAIL FROM SALESORD_HDR H LEFT JOIN DR_ACCS D ON H.INSURANCE_ACCNO = D.ACCNO '+
                                  ' LEFT JOIN X_BRANCH_BRAND B ON H.CR_ACCNO = B.CR_ACCNO AND H.PROVIDER_SEQNO = B.PROVIDER_SEQNO WHERE H.SEQNO = '+IntToStr(SOHSeqNo);
          qryGeneral3.Open;
          WriteIf('5');
          EAdd := qryGeneral3.FieldByName('EMAIL').AsString;
          if ((qryGeneral3.FieldByName('EMAIL').IsNull) or (Length(qryGeneral3.FieldByName('EMAIL').AsString)<5) ) then
            EAdd := qryGeneral3.FieldByName('DEFMAIL').AsString;
          // Send Email
          if (EAdd <> '') then
          begin
            try
              SendEMail(EAdd, Subj,'', PBody);
              // Update Field
              WriteIf('5a-Update');
              qryGeneral3.Close;
              qryGeneral3.SQL.Text := 'UPDATE SALESORD_HDR SET '+qryGeneral.FieldByName('DATEFIELD').AsString+' = '+QuotedStr(FormatDateTime('yyyy-mm-dd',Date))+', '+
                                       qryGeneral.FieldByName('CCFIELD').AsString+'='+QuotedStr('N')+
                                      ' WHERE SEQNO = '+IntToStr(SOHSeqNo);
              WriteIf(qryGeneral3.SQL.Text);
              qryGeneral3.ExecSQL;
              WriteIf('5a');
              qryGeneral3.Close;
              qryGeneral3.SQL.Text := 'UPDATE HISTORY_NOTES SET SEND_NOW='+QuotedStr('S')+
                                      ' WHERE  HDR_SEQNO = '+intToStr(SOHSeqNo)+
                                     ' AND DATEDIFF(TRANSDATE, '+QuotedStr(FormatDateTime('yyyy-mm-dd',qryGeneral2.FieldByName(qryGeneral.FieldByName('CHECKFIELD').AsString).AsDateTime))+') > 0'+
                                     ' AND SEND_NOW='+QuotedStr('N');
              WriteIf('5b');
              qryGeneral3.ExecSQL;
            except
              WriteIf('*** Error Sending Email or updating tables after sending email');
            end;
          end;
          WriteIf('6');
        end;
        qryGeneral2.Next;
      end;
    end;  
    //---------------------
    procedure SendToBranch;
    begin
      qryGeneral2.Close;
      qryGeneral2.SQL.Text := 'SELECT H.SEQNO, H.CLAIM_REF, P.SEND_KPI FROM SALESORD_HDR H LEFT JOIN X_PROVIDER P ON H.PROVIDER_SEQNO = P.SEQNO'+
                              ' WHERE (DATEDIFF('+QuotedStr(FormatDateTime('yyyy-mm-dd',Date))+','+qryGeneral.FieldByName('CHECKFIELD').AsString+') > '+qryGeneral.FieldByName('DAYSTOCC').AsString+
                              ' ) AND ('+qryGeneral.FieldByName('CCFIELD').AsString+' = '+QuotedStr('N')+
                              ' ) AND (H.STATUS BETWEEN '+ qryGeneral.FieldByName('STATUSFROM').AsString +' AND '+ qryGeneral.FieldByName('STATUSTO').AsString+
                              ' ) AND ('+qryGeneral.FieldByName('CHECKFIELD').AsString+' >= H.LASTHISTORYNOTE'+
                              ' ) AND (P.SEND_KPI = '+QuotedStr('Y')+')';
      qryGeneral2.Open;
      WriteIf(qryGeneral2.SQL.Text);
      while not qryGeneral2.Eof do
      begin
        WriteIf('7');
        PBody.Clear;
        if (qryGeneral2.FieldByName('SEND_KPI').AsString = 'Y') then
        begin
          SOHSeqNo := qryGeneral2.FieldByName('SEQNO').AsInteger;
          qryGeneral3.Close;
          qryGeneral3.SQL.Text := 'SELECT H.SEQNO, H.LASTEMAILUPDATE, MAX(HN.TRANSDATE) AS LASTDATE '+
                                  ' FROM HISTORY_NOTES HN '+
                                  ' LEFT JOIN SALESORD_HDR H ON H.SEQNO = HN.HDR_SEQNO '+
                                  ' WHERE HN.HDR_SEQNO = '+intToStr(SOHSeqNo)+
                                  ' GROUP BY H.SEQNO, H.LASTEMAILUPDATE';
          WriteIf(qryGeneral3.SQL.Text);
          qryGeneral3.Open;
          WriteIf('8');
          if (qryGeneral3.FieldByName('LASTDATE').IsNull) or (qryGeneral3.FieldByName('LASTDATE').AsDateTime < qryGeneral3.FieldByName('LASTEMAILUPDATE').AsDateTime) then
          begin
            PBody.Add(qryGeneral.FieldByName('BODYCC').AsString);
            Subj := qryGeneral.FieldByName('SUBJECTCC').AsString+' Job # '+intToStr(SOHSeqNo);
            PBody.Add(' ');
            PBody.Add('Job No. '+intToStr(SOHSeqNo)+' requires History Note update.');
            // Get Email
            qryGeneral3.Close;
            qryGeneral3.SQL.Text := 'SELECT C.EMAIL FROM SALESORD_HDR H LEFT JOIN CR_ACCS C ON H.CR_ACCNO = C.ACCNO '+
                                    ' WHERE H.SEQNO = '+IntToStr(SOHSeqNo);
            qryGeneral3.Open;
            WriteIf('9');
            EAdd := qryGeneral3.FieldByName('EMAIL').AsString;
            // Send Email
            if (EAdd <> '') then
              SendEMail(EAdd, Subj,'', PBody);
            // Update Field
            qryGeneral3.Close;
            qryGeneral3.SQL.Text := 'UPDATE SALESORD_HDR SET '+
                                     qryGeneral.FieldByName('CCFIELD').AsString+'='+QuotedStr('Y')+
                                    ' WHERE SEQNO = '+IntToStr(SOHSeqNo);
            qryGeneral3.ExecSQL;
            WriteIf('10');
          end;
        end;
        qryGeneral2.Next;
      end;
    end;  
  begin
    SendToProvider;
    // ---------------------------------------------------------------------
    // And then for the  local Emails (to Branches)
    SendToBranch;
  end;
  //===============
  procedure SendFCR;
  begin
    qryGeneral2.Close;
    qryGeneral2.SQL.Text := 'SELECT H.SEQNO, H.CR_ACCNO, H.DR_ACCNO, H.INBOX_SEQNO, '+     // Should this be INSURANCE_ACCNO
                            'H.CLAIM_REF FROM SALESORD_HDR H LEFT JOIN X_PROVIDER P ON H.PROVIDER_SEQNO = P.SEQNO'+
                            ' WHERE P.USE_FCR = '+QuotedStr('Y') + ' AND H.SENDREPORT = '+QuotedStr('Y');
    qryGeneral2.Open;
    while not qryGeneral2.Eof do
    begin
      WriteIf('11');
      PBody.Clear;
      SOHSeqNo := qryGeneral2.FieldByName('SEQNO').AsInteger;
      DR_Acc := qryGeneral2.FieldByName('DR_ACCNO').AsString;
      CR_Acc := qryGeneral2.FieldByName('CR_ACCNO').AsString;
      InSeqNo:= qryGeneral2.FieldByName('INBOX_SEQNO').AsString;

      Subj := qryGeneral.FieldByName('SUBJECTPROVIDER').AsString+' Claim # '+qryGeneral2.FieldByName('CLAIM_REF').AsString;
      PBody.Add(qryGeneral.FieldByName('BODYPROVIDER').AsString);

      PBody.Add('Floor Covering Report http://www.carpetcourtinsurance.co.nz/pdf/FCR'+IntToStr(SOHSeqNo)+'.pdf');
      PBody.Add(' ');
      PBody.Add('To approve this Claim click the link below');
      PBody.Add('http://www.carpetcourtinsurance.co.nz/jobstatusupdate.php?s=17&j='+IntToStr(SOHSeqNo)+'&d='+DR_Acc+'&c='+CR_Acc+'&i='+InSeqNo);
      PBody.Add(' ');
      PBody.Add('If the Claim is NOT approved click the link below');
      PBody.Add('http://www.carpetcourtinsurance.co.nz/jobstatusupdate.php?s=30&j='+IntToStr(SOHSeqNo)+'&d='+DR_Acc+'&c='+CR_Acc+'&i='+InSeqNo);
      // Get Email
      qryGeneral3.Close;
      qryGeneral3.SQL.Text := 'SELECT D.EMAIL AS DEFMAIL,  B.EMAIL FROM SALESORD_HDR H LEFT JOIN DR_ACCS D ON H.DR_ACCNO = D.ACCNO '+
                              ' LEFT JOIN X_BRANCH_BRAND B ON H.CR_ACCNO = B.CR_ACCNO AND H.PROVIDER_SEQNO = B.PROVIDER_SEQNO WHERE H.SEQNO = '+IntToStr(SOHSeqNo);
      WriteIf(qryGeneral3.SQL.Text);
      qryGeneral3.Open;
      if (not qryGeneral3.FieldByName('EMAIL').IsNull) then
        EAdd := qryGeneral3.FieldByName('EMAIL').AsString
      else
        EAdd := qryGeneral3.FieldByName('DEFMAIL').AsString;
      WriteIf('12');
      // Send Email
      if (EAdd <> '') then
        SendEMail(EAdd, Subj,'', PBody);
      // Update Field
      qryGeneral3.Close;
      qryGeneral3.SQL.Text := 'UPDATE SALESORD_HDR SET '+qryGeneral.FieldByName('DATEFIELD').AsString+' = '+QuotedStr(FormatDateTime('yyyy-mm-dd',Date))+', '+
                               qryGeneral.FieldByName('CCFIELD').AsString+'='+QuotedStr('N')+
                              ' WHERE SEQNO = '+IntToStr(SOHSeqNo);
      WriteIf(qryGeneral3.SQL.Text);
      qryGeneral3.ExecSQL;
      WriteIf('13');
      qryGeneral2.Next;
    end;
  end;
  //==================
  procedure SendRemit;
  begin
    qryGeneral2.Close;
    qryGeneral2.SQL.Text := 'SELECT SEQNO, BRANCH_REF FROM X_REMITTANCE_LOG '+
                            ' WHERE EMAILIT = '+QuotedStr('Y');
    qryGeneral2.Open;

    WriteIf('Remit 1');

    Subj := qryGeneral.FieldByName('SUBJECTCC').AsString;

    while not qryGeneral2.Eof do
    begin
      qryGeneral3.Close;
      qryGeneral3.SQL.Text := 'SELECT DISTINCT(S.CR_ACCNO) AS CR_ACCNO, C.EMAIL '+
                              'FROM SALESORD_HIST H LEFT JOIN SALESORD_HDR S ON H.SO_SEQNO = S.SEQNO '+
                              'LEFT JOIN CR_ACCS C ON C.ACCNO = S.CR_ACCNO '+
                              'WHERE H.BRANCH_REF = '+QuotedStr(qryGeneral2.FieldByName('BRANCH_REF').AsString);
      qryGeneral3.Open;
      while not qryGeneral3.Eof do
      begin
        PBody.Clear;
        PBody.Add(qryGeneral.FieldByName('BODYCC').AsString);
        PBody.Add(' ');
        PBody.Add('Remittance Advice for Payment '+qryGeneral2.FieldByName('BRANCH_REF').AsString+
                  ' http://www.carpetcourtinsurance.co.nz/pdf/Remit-'+qryGeneral2.FieldByName('SEQNO').AsString+'-'+qryGeneral3.FieldByName('CR_ACCNO').AsString+'.pdf');
        PBody.Add(' ');
        EAdd := qryGeneral3.FieldByName('EMAIL').AsString;
        WriteIf('Remit 2 '+ EAdd);
        // Send Email
        if (EAdd <> '') then
          SendEMail(EAdd, Subj,'', PBody);
        qryGeneral3.Next;
      end;
      qryGeneral3.Close;
      qrygeneral3.SQL.Text := 'UPDATE X_REMITTANCE_LOG SET EMAILIT = '+QuotedStr('N')+' WHERE SEQNO='+qryGeneral2.FieldByName('SEQNO').AsString;
      qryGeneral3.ExecSQL;
      qryGeneral2.Next;
    end;
  end;
begin
  try
    WriteIf('Send Reminders');
    PBody := TStringList.Create;
    // Send Immediate Emails - not related to KPI (if they ticked the box)
    SendGeneralEmails;
    SendImmediate;
    with qryGeneral do
    begin
      Close;
      SQL.Text := 'SELECT * FROM X_KPI WHERE ISACTIVE = '+QuotedStr('Y');
      Open;
      WriteIf('1');
      while not EOF do
      begin
        // ---------------------------------------------------------------------
        // First do all those that must be sent to Insurance Providers
        if (qryGeneral.FieldByName('KPITYPE').AsString = 'KPI_HISTORY') then
        begin
          WriteIf('2');
          //ProcessKPI;
          SendHistoryNotes;
        end;
        // ---------------------------------------------------------------------
        // And finally Floor Covering Reports
        if (qryGeneral.FieldByName('KPITYPE').AsString = 'KPI_FCR') then
        begin
          SendFCR;
        end;
        // And Remittances
        if (qryGeneral.FieldByName('KPITYPE').AsString = 'KPI_REMIT') then
        begin
          SendRemit;
        end;
        Next;
      end;
    end;
  finally
    PBody.Free;
  end;
end;

//==============================================================================
procedure TdmMain.SendNextSMS;
var
  OrderNo: Integer;
  NoData: TEMailData;
  //hh,mm,ss: integer;
begin
  with qrySMS do
  begin
    Close;
    //SQL.Text := 'Select JobNo, BranchNo, ContactNo From X_SMSLog where IsOutstanding = '+QuotedStr('Y')+
    //            ' and TimeDiff(Now(),TimeSent) > '+QuotedStr(Format('0000-00-00 %2.2d:%2.2d:%2.2d',[hh,mm,ss]));

    // Proposed change
    SQL.Text := 'SELECT JOBNO, MAX(SEQNO) AS SEQNO FROM X_SMSLOG '+
                'WHERE ISOUTSTANDING ='+ QuotedStr('Y')+
                ' GROUP BY JOBNO ORDER BY JOBNO DESC'; 
    // Changed From
    //SQL.Text := 'SELECT JOBNO, MAX(BRANCHNO) BRANCHNO, MAX(ORDERNO) MAXORDERNO '+
    //            'FROM X_SMSLOG WHERE ISOUTSTANDING = '+QuotedStr('Y')+
    //            ' GROUP BY JOBNO'+
    //            ' HAVING MAX(CONTACTNO) < '+IntToStr(SUPPORTCONTACTNO)+
    //            ' AND NOW() > MAX(RESPONSEREQUIRED)';
    Open;
    WriteIf('Next SMS');
    while not EOF do
    begin
      qryGeneral3.Close;                  // Because the MaxOrderNo selected above, for some reason returns 0
      // Proposed Change                                    
      //qryGeneral3.SQL.Text := 'SELECT ORDERNO AS MAXORDER FROM X_SMSLOG WHERE NOW() > RESPONSEREQUIRED AND SEQNO = '+FieldByName('SEQNO').AsString;
      qryGeneral3.SQL.Text := 'SELECT ORDERNO AS MAXORDER FROM X_SMSLOG WHERE '+QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',NOW))+
                              ' > RESPONSEREQUIRED AND SEQNO = '+FieldByName('SEQNO').AsString;
      WriteIf(qryGeneral3.SQL.Text);
      // ONLY PROCESS this if this not 999999 (SUPPORTCONTACTNO) AND NOT NULL (which will be the case if the time is not yet up
      // Changed from
      //qryGeneral3.SQL.Text := 'SELECT MAX(ORDERNO) AS MAXORDER FROM X_SMSLOG WHERE JOBNO = '+FieldByName('JOBNO').AsString;
      qryGeneral3.Open;
      if (not qryGeneral3.FieldByName('MAXORDER').IsNull) then
        if (qryGeneral3.FieldByName('MAXORDER').AsInteger < SUPPORTCONTACTNO) then
        begin
          OrderNo := qryGeneral3.FieldByName('MAXORDER').AsInteger;
          qryGeneral3.Close;
          WriteIf('Resend for Job # '+FieldByName('JOBNO').AsString);
          SMSBranch(OrderNo, FieldByName('JOBNO').AsInteger, False,NoData);
        end;
      Next;
    end;
    WriteIf('Next SMS - Done');
  end;
end;

//==============================================================================
procedure TdmMain.ForwardToSupport;
var
  ToAdd, PartAdd, SaveFrom: string;
  i: integer;
begin
  writeif('Forward to Support COMMENTED OUT FOR NOW');
  Exit;
  with qryGeneral do
  begin
    Close;
    SQL.Text := 'SELECT EMAIL FROM CR_ACCS WHERE ACCNO = '+IntToStr(SUPPORT);
    Open;
    ToAdd := FieldByname('EMAIL').AsString;
  end;
  WriteIf ('Mail forwarded to Support');
  with SMTP.PostMessage do
  begin
    ToAddress.Clear;
    while pos(';', ToAdd) > 0 do
    begin
      PartAdd := Copy (ToAdd, 1, pos(';', ToAdd)-1);
      ToAddress.Add(PartAdd);
      ToAdd := Copy(ToAdd, pos(';', ToAdd)+1, Length(ToAdd)-pos(';',ToAdd));
    end;
    ToAddress.Add(ToAdd);
    Subject := 'FW:(Auto CC) '+Pop3.MailMessage.Subject;
    Body.Clear;
    for i := 0 to Pop3.MailMessage.Body.Count -1 do
      Body.Add (Pop3.MailMessage.Body.Strings[i]);                     //1242811
    SaveFrom := FromAddress;
    FromAddress := Pop3.MailMessage.From;     
  end;
  try
    if not SMTP.Connected then
      SMTP.Connect;
    if DEBUG then
    begin
      SMTP.PostMessage.ToAddress.Clear;
      SMTP.PostMessage.ToAddress.Add('richard@acclaimgroup.co.nz');
      WriteIf('Email to Richard - Forward');
    end;
    WriteIf('Email to:'+SMTP.PostMessage.ToAddress[0]);
    SMTP.SendMail;
  finally
    SMTP.Disconnect;
    SMTP.PostMessage.FromAddress := SaveFrom;
  end;
end;

//==============================================================================
procedure TdmMain.POP3List(Msg, Size: Integer);
begin
  inc(fMsgCount);
end;

procedure TdmMain.DataModuleCreate(Sender: TObject);
begin
  fLineCnt := 0;
  fExceptionSent := False;
end;

procedure TdmMain.POP3RetrieveStart(Sender: TObject);
begin
  WriteIf('Pop 3 - Retrieve Start');
end;

procedure TdmMain.POP3RetrieveEnd(Sender: TObject);
begin
  WriteIf('Pop 3 - Retrieve End');
end;

procedure TdmMain.POP3Connect(Sender: TObject);
begin
  WriteIf('Pop 3 - Connect');
end;

procedure TdmMain.POP3Disconnect(Sender: TObject);
begin
  WriteIf('Pop 3 - DisConnect');
end;

procedure TdmMain.POP3Failure(Sender: TObject);
begin
  WriteIf('Pop 3 - Failure');
  UpdateServiceLog('Pop 3 - Failure','Pop3Failure');
  SetFlag;
end;

procedure TdmMain.POP3ConnectionRequired(var Handled: Boolean);
begin
  WriteIf('Pop 3 - Connection Required');
end;

procedure TdmMain.POP3ConnectionFailed(Sender: TObject);
begin
  WriteIf('Pop 3 - Connection Failed');
  UpdateServiceLog('Pop 3 - Connection Failed','Pop3ConnectionFailed');
  SetFlag;
end;

procedure TdmMain.POP3AuthenticationNeeded(var Handled: Boolean);
begin
  WriteIf('Pop 3 - Authentication Needed');
end;

procedure TdmMain.POP3Status(Sender: TComponent; Status: String);
begin
  WriteIf('Pop 3 - Status ' + Status);
end;

procedure TdmMain.POP3AuthenticationFailed(var Handled: Boolean);
begin
  WriteIf('Pop 3 - Authentication Failed');
  UpdateServiceLog('SMTP - Authentication Failed','SMTPAuthenticationFailed');
  SetFlag;
end;

procedure TdmMain.POP3InvalidHost(var Handled: Boolean);
begin
  WriteIf('Pop 3 - Invalid host');
  UpdateServiceLog('Pop 3 - Invalid host','Pop3Invalidhost');
  SetFlag;
end;

procedure TdmMain.POP3PacketRecvd(Sender: TObject);
begin
  WriteIf('Pop 3 - Packet Received');
end;

procedure TdmMain.POP3Reset(Sender: TObject);
begin
  WriteIf('Pop 3 - Reset');
end;

procedure TdmMain.POP3DecodeStart(var FileName: String);
begin
  FileName := 'SavedFile.Txt';
  WriteIf('Pop 3 - Decode Start');
end;

procedure TdmMain.POP3DecodeEnd(Sender: TObject);
begin
  WriteIf('Pop 3 - Decode End');
end;

procedure TdmMain.POP3HostResolved(Sender: TComponent);
begin
  WriteIf('Pop 3 - Host Resolved');
end;

procedure TdmMain.POP3Success(Sender: TObject);
begin
  WriteIf('Pop 3 - Success');
end;

procedure TdmMain.SMTPAttachmentNotFound(Filename: String);
begin
  WriteIf('SMTP - Attachment not found');
  UpdateServiceLog('SMTP - Attachment not found','SMTPAttachmentNotFound');
end;

procedure TdmMain.SMTPAuthenticationFailed(var Handled: Boolean);
begin
  WriteIf('SMTP - Authentication Failed');
  UpdateServiceLog('SMTP - Authentication Failed','SMTPAuthenticationFailed');
end;

procedure TdmMain.SMTPConnect(Sender: TObject);
begin
  WriteIf('SMTP - Connect');
end;

procedure TdmMain.SMTPConnectionFailed(Sender: TObject);
begin
  WriteIf('SMTP - Connection Failed');
  UpdateServiceLog('SMTP - Connection Failed','SMTPConnectionFailed');
end;

procedure TdmMain.SMTPConnectionRequired(var Handled: Boolean);
begin
  WriteIf('SMTP - Connection Required');
end;

procedure TdmMain.SMTPDisconnect(Sender: TObject);
begin
  WriteIf('SMTP - Disconnect');
end;

procedure TdmMain.SMTPEncodeEnd(Filename: String);
begin
  WriteIf('SMTP - Encode End');
end;

procedure TdmMain.SMTPEncodeStart(Filename: String);
begin
  WriteIf('SMTP - Encode Start');
end;

procedure TdmMain.SMTPFailure(Sender: TObject);
begin
  WriteIf('SMTP - Failure');
  UpdateServiceLog('SMTP - Failure','SMTPFailure');
end;

procedure TdmMain.SMTPHeaderIncomplete(var handled: Boolean;
  hiType: Integer);
begin
  WriteIf('SMTP - Header Incomplete');
end;

procedure TdmMain.SMTPHostResolved(Sender: TComponent);
begin
  WriteIf('SMTP - Host Resolved');
end;

procedure TdmMain.SMTPInvalidHost(var Handled: Boolean);
begin
  WriteIf('SMTP - Invalid Host');
end;

procedure TdmMain.SMTPMailListReturn(MailAddress: String);
begin
  WriteIf('SMTP - Mail List Return');
end;

procedure TdmMain.SMTPPacketSent(Sender: TObject);
begin
  WriteIf('SMTP - Packet Sent');
end;

procedure TdmMain.SMTPRecipientNotFound(Recipient: String);
begin
  WriteIf('SMTP - Recipient Not Found');
  UpdateServiceLog('SMTP - Recipient Not Found','SMTPRecipientNotFound');
end;

procedure TdmMain.SMTPSendStart(Sender: TObject);
begin
  WriteIf('SMTP - Start Send');
end;

procedure TdmMain.SMTPStatus(Sender: TComponent; Status: String);
begin
  WriteIf('SMTP - Status '+Status);
end;

procedure TdmMain.SMTPSuccess(Sender: TObject);
begin
  WriteIf('SMTP - Success');
end;

function TdmMain.ifb(AStr, DefStr: string): string;
var
  BStr: string;
begin
  BStr := Trim(AStr);
  if BStr= '' then
    Result := DefStr
  else
    Result := BStr;
end;

function TdmMain.zifb(AStr: string): string;
begin
  Result := ifb(AStr,'0');
end;

end.
