unit sImport;
interface
{

EXAMPLE ALTER TRIGGER [X_STOCK_ITEMS_UPDATE] ON [dbo].[STOCK_ITEMS]
AFTER UPDATE
AS
BEGIN
  DECLARE @CDE VARCHAR(23), @MINQTY FLOAT, @MAXQTY FLOAT
  SET NOCOUNT ON
    SELECT @CDE=STOCKCODE, @MINQTY=MINSTOCK, @MAXQTY=MAXSTOCK FROM INSERTED;

    UPDATE STOCK_LOC_INFO SET MINSTOCK=@MINQTY, MAXSTOCK=@MAXQTY WHERE STOCKCODE=@CDE AND LOCATION=1;
    IF NOT UPDATE(X_UPDATED)
      UPDATE STOCK_ITEMS SET X_UPDATED='Y' WHERE STOCKCODE=@CDE AND X_UPDATED='N'

  SET NOCOUNT OFF
END

TRIGGER - STOCK_ITEMS_ONEOFF
   Add - AND S.ISACTIVE = 'Y' - to the end of the update query and say something in the implementation notes
}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs, ActiveX,
  IDSRegistry, IDSLogToFile, IdBaseComponent, IdComponent, IdTCPConnection, IdText, IdAttachmentFile,
  IdTCPClient, IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase, MidasLib, 
  IdSMTP, ExtCtrls, DB, ADODB, IdMessage, IdFTP, WideStrings, FMTBcd, SqlExpr,
  DBClient, Provider, RpRender, RpRenderPDF, RpBase, RpSystem, RpDefine, RpRave,
  RpCon, RpConDS, Data.DBXMySQL;
type
  TTax = record
    Rate: Double;
    RateNo: Integer;
  end;

type
  TExoWeb = class(TService)
    idsFile: TIDSLogToFile;
    idsReg: TIDSRegistry;
    dbExonet: TADOConnection;
    qryExo: TADOQuery;
    tmr: TTimer;
    SMTP: TIdSMTP;
    SMTPMsg: TIdMessage;
    FTP: TIdFTP;
    WebConn: TSQLConnection;
    qryWeb: TSQLQuery;
    dspWeb: TDataSetProvider;
    cdsWeb: TClientDataSet;
    cdsGeneral: TClientDataSet;
    dspExo: TDataSetProvider;
    cdsWebDetail: TClientDataSet;
    cdsPrint: TClientDataSet;
    RvProject: TRvProject;
    RvSystem: TRvSystem;
    RvRenderPDF: TRvRenderPDF;
    rvdsInvoice: TRvDataSetConnection;
    qryPrint: TADOQuery;
    dspPrint: TDataSetProvider;
    cdsGeneralInfo: TClientDataSet;
    rvdsGeneralInfo: TRvDataSetConnection;
    cdsGeneralInfoUserName: TStringField;
    cdsGeneralInfoAddress1: TStringField;
    cdsGeneralInfoAddress2: TStringField;
    cdsGeneralInfoAddress3: TStringField;
    cdsGeneralInfoBank_Acc_No: TStringField;
    cdsGeneralInfoBank_Acc_Name: TStringField;
    cdsGeneralInfoPhone: TStringField;
    cdsGeneralInfoFax: TStringField;
    cdsGeneralInfoEmail: TStringField;
    cdsGeneralInfoDelivAddr1: TStringField;
    cdsGeneralInfoDelivAddr2: TStringField;
    cdsGeneralInfoDelivAddr3: TStringField;
    cdsGeneralInfoDelivAddr4: TStringField;
    cdsGeneralInfoTaxRegNo: TStringField;
    cdsGeneralInfoWebSite: TStringField;
    ADOStoredProc1: TADOStoredProc;
    spSIL: TADOStoredProc;
    procedure ServiceExecute(Sender: TService);
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure tmrTimer(Sender: TObject);
    procedure SMTPStatus(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: string);
  private
    { Private declarations }
    fWriteAll: Boolean;
    fWriteSQL: Boolean;
    fLineExists: Boolean;
    fDEBUG: Boolean;
    fLocalEmailAddress: string;
    fExportFolder: string;       // Folder for putting the pdf file before emailing
    fCustAcc: Integer;
    //fFilePath: string;
    procedure WriteToFile(S:String);
    procedure WriteIt(S:String; DoIt: Boolean);
    procedure WriteIf(S: String);
    function zifb(AStr: string): string;
    procedure GetGeneralData(SQL:string);
    procedure ExecuteSQL(SQL: string);
    procedure ExecuteWebSQL(SQL: string);
    function GetDataInteger(SQL: String): integer;
    function GetDataFloat(SQL: String): double;
    function GetDataString(SQL: String): string;
    procedure GetData(cds: TClientDataSet; SQL: String);
    procedure GetWebData(cds: TClientDataSet; SQL: String);
    function GetWebDataString(SQL: String): string;
    function GetWebDataInteger(SQL: String): Integer;
    function GetWebDataFloat(SQL: String): Double;
    function GetTax(Ledger: string; AccNo: Integer): TTax;
    //procedure GetGeneralInfoData;
    procedure SendAttachment(ABody, FileName: string);
    procedure GetRegSettings;
    procedure Process;
    //procedure CheckDebtors;
    //procedure CheckProducts;
    //procedure CheckOrders;
    function ExistsStockCode(StCode: String): Boolean;
    procedure SendEMail(EAdd, Subj, ABody: string);
    //procedure GetPrintData(SQL: string);
    //procedure GetInvoiceData(SeqNo: Integer);
    //function EmailReport(ToAdd, CName: string): Boolean;
    //function GetSalesGLCode(AccNo: Integer): Integer;
    //function GetPurchGLCode(AccNo: Integer): Integer;
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  ExoWeb: TExoWeb;

//const
//  DEBUG=TRUE;

implementation

{$R *.DFM}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  ExoWeb.Controller(CtrlCode);
end;

function TExoWeb.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TExoWeb.ServiceExecute(Sender: TService);
begin
  //GetRegSettings;
  tmr.Enabled := True;
  while not Terminated do
    ServiceThread.ProcessRequests(True);
end;

procedure TExoWeb.ServiceStart(Sender: TService; var Started: Boolean);
var
  Guid: TGuid;
begin
  CoInitialize(nil);
  CreateGUID(Guid);
  RPDefine.DataID := GuidToString(Guid);
  WebConn.AutoClone := False;
end;

procedure TExoWeb.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
  CoUnInitialize;
end;

procedure TExoWeb.SMTPStatus(ASender: TObject; const AStatus: TIdStatus;
  const AStatusText: string);
begin
  WriteIf('SMTP :'+AStatusText);
end;

procedure TExoWeb.tmrTimer(Sender: TObject);
begin
  try
    //Tmr.Enabled := True;
    Tmr.Enabled := False;
    WriteToFile('Timer NOT Enabled');
    GetRegSettings;
    WriteIf('Starting Process');
    Process;
  finally
    Tmr.Enabled := True;
    WriteToFile('Timer IS Enabled');
    dbExonet.Connected := False;
    WriteIf('Process Completed');
  end;
end;
(*
function GetStr(var S: string): String;
var
  Pos1, Pos2 : integer;
begin
  Pos1 := pos('"',S);
  Pos2 := pos('"', Copy(S, Pos1+1, Length(S)-Pos1))+Pos1;
  Result := Copy (S,Pos1+1, Pos2-Pos1-1);
  S := Copy(S,Pos2+1, length(S) - Pos2);
end;
*)
function FileIsThere(FileName: string): Boolean;
{ Boolean function that returns True if the file exists; otherwise,
  it returns False. Closes the file if it exists. }
 var
  F: file;
begin
  {$I-}
  AssignFile(F, FileName);
  FileMode := 0;  {Set file access to read only }
  Reset(F);
  CloseFile(F);
  {$I+}
  FileIsThere := (IOResult = 0) and (FileName <> '');
end;  { FileIsThere }
//-----------------------------------------------------------------------------
procedure TExoWeb.WriteToFile(S:String);
begin
  WriteIt(S, True);
end;

//==============================================================================
procedure TExoWeb.WriteIf(S:String);
begin
  WriteIt(S, fWriteAll);
end;

//==============================================================================
procedure TExoWeb.WriteIt(S:String; DoIt: Boolean);
begin
  if DoIt then
  begin
    idsFile.Write(S);
  end;
end;
//==============================================================================
function TExoWeb.zifb(AStr: string): string;
var
  BStr: string;
begin
  BStr := Trim(AStr);
  if BStr = '' then
    Result := '0'
  else
    Result := BStr;
end;

procedure TExoWeb.GetGeneralData(SQL: String);
begin
  GetData(cdsGeneral, SQL);
end;

procedure TExoWeb.GetData(cds: TClientDataSet; SQL: String);
begin
  cds.Close;
  if cds.ProviderName = '' then
    cds.ProviderName := 'dspExo';
  qryExo.SQL.Text := SQL;
  cds.Open;
end;

procedure TExoWeb.GetWebData(cds: TClientDataSet; SQL: String);
begin
  try
    WebConn.Connected := True;
    cds.Close;
    if cds.ProviderName = '' then
      cds.ProviderName := 'dspWeb';
    qryWeb.SQL.Text := SQL;
    cds.Open;
  finally
    WebConn.Connected := False;
  end;
end;

function TExoWeb.GetWebDataString(SQL: String): string;
begin
  try
    qryWeb.Close;
    WebConn.Connected := True;
    qryWeb.SQL.Text := SQL;
    qryWeb.Open;
    Result := qryWeb.Fields[0].AsString;
  finally
    qryWeb.Close;
    WebConn.Connected := False;
  end;
end;

function TExoWeb.GetWebDataInteger(SQL: String): Integer;
begin
  try
    qryWeb.Close;
    WebConn.Connected := True;
    qryWeb.SQL.Text := SQL;
    qryWeb.Open;
    Result := qryWeb.Fields[0].AsInteger;
  finally
    qryWeb.Close;
    WebConn.Connected := False;
  end;
end;

function TExoWeb.GetWebDataFloat(SQL: String): Double;
begin
  try
    qryWeb.Close;
    WebConn.Connected := True;
    qryWeb.SQL.Text := SQL;
    qryWeb.Open;
    Result := qryWeb.Fields[0].AsFloat;
  finally
    qryWeb.Close;
    WebConn.Connected := False;
  end;
end;

function TExoWeb.GetDataString(SQL: String): string;
begin
  qryExo.Close;
  qryExo.SQL.Text := SQL;
  qryExo.Open;
  Result := qryExo.Fields[0].AsString;
end;

function TExoWeb.GetDataInteger(SQL: String): integer;
begin
  qryExo.Close;
  qryExo.SQL.Text := SQL;
  qryExo.Open;
  Result := qryExo.Fields[0].AsInteger;
end;

function TExoWeb.GetDataFloat(SQL: String): double;
begin
  qryExo.Close;
  qryExo.SQL.Text := SQL;
  qryExo.Open;
  Result := qryExo.Fields[0].AsFloat;
end;

procedure TExoWeb.ExecuteSQL(SQL: string);
begin
  qryExo.Close;
  qryExo.SQL.Text := SQL;
  if fWriteSQL then
    WriteIf('EXO: '+SQL);
  if not fDEBUG then
    qryExo.ExecSQL;
end;

procedure TExoWeb.ExecuteWebSQL(SQL: string);
begin
  try
    qryWeb.Close;
    WebConn.Connected := True;
    qryWeb.SQL.Text := SQL;
    if fWriteSQL then
      WriteIf('Web: '+SQL);
    if not fDEBUG then
      qryWeb.ExecSQL;
  finally
    qryWeb.Close;
    WebConn.Connected := False;
  end;
end;

procedure TExoWeb.GetRegSettings;
var
  LogAll, LogSQL, msg, fName: String;
begin
  fWriteAll := False;
  fWriteSQL := False;
  fDEBUG := TRUE;
  try
    //tmr.Enabled := False;
    fName := idsReg.ReadString('LogFile');
    if UpperCase(Copy(fName,length(fName)-3,4))= '.LOG' then
      fName := Copy(fName,1, length(fName)-4)+FormatDateTime('-yyyy-mm-dd',Date)+'.log';
    idsFile.FileName := fName;
    WriteToFile('===========================================================');
    WriteToFile('Get Reg Settings 1');
    fDebug:=(idsReg.ReadString('DEBUG')='Y');
    if fDebug then
      WriteToFile('Debugging')
    else
      WriteToFile('Updating');

    fExportFolder := idsReg.ReadString('ExportFolder');
    WriteToFile ('Export Folder:('+ fExportFolder+')');

    //fDebug := True;   // Just in case
    // Database Connection
    msg := 'Insufficient database connection parameters';
    dbExonet.Connected := False;
    dbExonet.ConnectionString:=idsReg.ReadString('ConnStr');
    // Timer Interval
    msg := 'Invalid Timer data';
    WriteToFile('Get Reg Settings 3');
    Tmr.Interval := idsReg.ReadInteger('TInterval');
    WriteToFile('Interval = '+ IntToStr(Tmr.Interval));
    // File Path
    (*
    msg := 'Invalid File path';
    fFilePath := idsReg.ReadString('FilePath');
    if not DirectoryExists(fFilePath) then
      WriteToFile('Path ['+fFilepath+'] does not exist');
    // Get Process Interval - values stored in private variables
    *)
    msg := 'Error getting SMTP Settings';
    WriteToFile('Got Reg Settings');
    // SMTP Settings
    SMTP.Host := idsReg.ReadString('SMTPHost');
    SMTP.Port := idsReg.ReadInteger('SMTPPort');
    SMTP.UserName := idsReg.ReadString('SMTPUID');
    with SMTPMsg do
    begin
      Clear;
      From.Address := idsReg.ReadString('SMTPFromAddress');
      From.Name := idsReg.ReadString('SMTPFromName');
      fLocalEMailAddress := idsReg.ReadString('SMTPToAddress');
    end;
    WriteToFile('Got SMTP Reg Settings');
    // This file (WebConn.par) has to be in Windows\System32 !!!
    // Cannot read the file so hard coded in component
    {
    msg := 'Error getting Web Connection Parameters';
    WebConn.Connected := False;
    msg := 'Error getting Web Connection Parameters 2';
    WebConn.Params.Clear;
    msg := 'Error getting Web Connection Parameters 3';
    WebConn.Params.LoadFromFile('WebConn.par');
    WriteToFile('Got Web Connection Parameters');
    }
  except
    On E:Exception do
    begin
      WriteToFile(E.Message+' '+Msg);
      //WriteToFile(Msg);
      WriteToFile('Interval = '+IntToStr(tmr.Interval));
      //SendEMail('richard@acclaimgroup.co.nz','SBS Error', 'Get RegSettings');
      exit;
    end;
  end;
  try
    try
      {
      dbExonet.Connected := True;
      WriteToFile('Connection Succeeds');
      fCustAcc := GetDataInteger('Select X_CUSTOMER_ACCNO FROM GENERAL_INFO');
      dbExonet.Connected := False;
      }
      // WriteSQL
      try
        LogSQL := idsReg.ReadString('LogSQL');
      except
        LogSQL := 'Y';
      end;
      fWriteSQL := (LogSQL = 'Y');
      if fWriteSQL then
        WriteToFile('LogSQL=True')
      else
        WriteToFile('LogSQL=False');
      // WriteAll
      try
        LogAll := idsReg.ReadString('LogAll');
      except
        LogAll := 'Y';
      end;
      fWriteAll := (LogAll = 'Y');
      if fWriteAll then
        WriteToFile('LogAll=True')
      else
        WriteToFile('LogAll=False');
    finally
      //WriteIf('Enable Timer');
      //Tmr.Enabled := True;
    end;
  except
    On E:Exception do
    begin
      WriteToFile(E.Message);
    end;
  end;
end;
//==============================================================================
// Main Processing Loop
//==============================================================================
procedure TExoWeb.Process;
begin
  try
    WriteIf('Start Process');
    //CheckDebtors;
    //CheckProducts;
    //CheckOrders;    // Write data from Web to X_Web_Order (and Lines) tables
  finally

  end;
end;

{
procedure TExoWeb.CheckDebtors;
var
  SQL: string;
begin
  try
    WriteIf('Check Dealers');
    // Check Exonet DR_Accs for any updates
    GetData(cdsGeneral,'Select * from DR_Accs Where (LAST_UPDATED > X_WEBUPDATED OR X_WEBUPDATED IS NULL) AND ACCGROUP=6');
    while not cdsGeneral.Eof do
    begin
      // Check if there is a matching dealer_id
      if GetWebDataInteger('Select Count(*) from dealers where dealer_id='+cdsGeneral.FieldByName('ACCNO').AsString) > 0  then //There is a suppliers->supplier_id = AccNo
      begin
        WriteIf('Web Dealer exists for AccNo: '+cdsGeneral.FieldByName('ACCNO').AsString);
        if GetWebDataString('Select dealer_hasupdate from dealers where dealer_id='+cdsGeneral.FieldByName('ACCNO').AsString) = 'Y' then // The record has supplier_hasupdate = 'Y'
        begin
          SendEMail(fLocalEMailAddress,'Sound Business Systems Data Conflict', 'Exo: DR_ACCS # '+cdsGeneral.FieldByName('ACCNO').AsString+#13+' and Web Member have both been updated.');
          // We need to inform some-one that both record have been changed
          ExecuteWebSQL('Update dealers set dealer_hasupdate='+QuotedStr('N')+' where dealer_id='+cdsGeneral.FieldByName('ACCNO').AsString);
          WriteIf('Send and Email here DR_ACCS ['+ cdsGeneral.FieldByName('ACCNO').AsString+']');
        end
        else
        begin  // We must update the existing record on the web
          SQL:= 'Update dealers set '+
                'dealer_name = '+QuotedStr(cdsGeneral.FieldByName('Name').AsString)+
                ',dealer_alphacode = '+QuotedStr(cdsGeneral.FieldByName('AlphaCode').AsString)+
                ',dealer_address1 = '+QuotedStr(cdsGeneral.FieldByName('Address1').AsString)+
                ',dealer_address2 = '+QuotedStr(cdsGeneral.FieldByName('Address2').AsString)+
                ',dealer_address3 = '+QuotedStr(cdsGeneral.FieldByName('Address3').AsString)+
                ',dealer_address4 = '+QuotedStr(cdsGeneral.FieldByName('Address4').AsString)+
                ',dealer_deladdr1 = '+QuotedStr(cdsGeneral.FieldByName('DelAddr1').AsString)+
                ',dealer_deladdr2 = '+QuotedStr(cdsGeneral.FieldByName('DelAddr2').AsString)+
                ',dealer_deladdr3 = '+QuotedStr(cdsGeneral.FieldByName('DelAddr3').AsString)+
                ',dealer_deladdr4 = '+QuotedStr(cdsGeneral.FieldByName('DelAddr4').AsString)+
                ',dealer_postcode = '+QuotedStr(cdsGeneral.FieldByName('Post_Code').AsString)+
                ',dealer_phone = '+QuotedStr(cdsGeneral.FieldByName('Phone').AsString)+
                ',dealer_email = '+QuotedStr(cdsGeneral.FieldByName('EMail').AsString)+
                ',dealer_website = '+QuotedStr(cdsGeneral.FieldByName('WebSite').AsString)+
                ',dealer_gstnumber = '+QuotedStr(cdsGeneral.FieldByName('TaxReg').AsString)+
                ',dealer_stopcredit = '+QuotedStr(cdsGeneral.FieldByName('StopCredit').AsString)+
                ',dealer_isactive = '+QuotedStr(cdsGeneral.FieldByName('IsActive').AsString)+
                ' Where dealer_id='+cdsGeneral.FieldByName('ACCNO').AsString;
          ExecuteWebSQL(SQL);
          ExecuteSQL('Update DR_ACCS Set X_WEBUPDATED = GetDate() WHERE ACCNO ='+cdsGeneral.FieldByName('AccNo').AsString);
        end;
      end
      else
      begin   //  We need to insert the record on to the web if it is Active
        if cdsGeneral.FieldByName('IsActive').AsString = 'Y' then
        begin
          SQL := 'Insert into dealers (dealer_id,dealer_alphacode, dealer_name, dealer_address1'+
                 ', dealer_address2, dealer_address3, dealer_address4, dealer_deladdr1'+
                 ',dealer_deladdr2, dealer_deladdr3, dealer_deladdr4, dealer_postcode, dealer_phone'+
                 ',dealer_email,dealer_website,dealer_gstnumber,dealer_stopcredit,dealer_isactive'+
                  ') Values ('+cdsGeneral.FieldByName('AccNo').AsString+','+
                  QuotedStr(cdsGeneral.FieldByName('AlphaCode').AsString)+','+
                  QuotedStr(cdsGeneral.FieldByName('Name').AsString)+','+
                  QuotedStr(cdsGeneral.FieldByName('Address1').AsString)+','+
                  QuotedStr(cdsGeneral.FieldByName('Address2').AsString)+','+
                  QuotedStr(cdsGeneral.FieldByName('Address3').AsString)+','+
                  QuotedStr(cdsGeneral.FieldByName('Address4').AsString)+','+
                  QuotedStr(cdsGeneral.FieldByName('DelAddr1').AsString)+','+
                  QuotedStr(cdsGeneral.FieldByName('DelAddr2').AsString)+','+
                  QuotedStr(cdsGeneral.FieldByName('DelAddr3').AsString)+','+
                  QuotedStr(cdsGeneral.FieldByName('DelAddr4').AsString)+','+
                  QuotedStr(cdsGeneral.FieldByName('Post_Code').AsString)+','+
                  QuotedStr(cdsGeneral.FieldByName('Phone').AsString)+','+
                  QuotedStr(cdsGeneral.FieldByName('EMail').AsString)+','+
                  QuotedStr(cdsGeneral.FieldByName('WebSite').AsString)+','+
                  QuotedStr(cdsGeneral.FieldByName('TaxReg').AsString)+','+
                  QuotedStr(cdsGeneral.FieldByName('StopCredit').AsString)+','+
                  QuotedStr(cdsGeneral.FieldByName('IsActive').AsString)+
                  ')';
          ExecuteWebSQL(SQL);
        end;
        ExecuteSQL('Update DR_ACCS Set X_WEBUPDATED = GetDate() WHERE ACCNO ='+cdsGeneral.FieldByName('AccNo').AsString);
      end;
      //=================================================
      cdsGeneral.Next;
    end;
    // Check the web to see if any dealers  dealer_hasupdate = 'Y'
    GetWebData(cdsWeb,'select * from dealers where dealer_hasupdate='+QuotedStr('Y'));
    while not cdsWeb.Eof do
    begin
      if GetDataInteger('Select Count(*) from DR_Accs Where ACCNO = '+cdsWeb.FieldByName('dealer_id').AsString+' AND LAST_UPDATED <= X_WEBUPDATED') = 1 then
      begin   // We need to update Exonet (only UPDATE no Inserts)
        SQL := 'Update DR_ACCS SET '+' NAME='+QuotedStr(cdsWeb.FieldByName('dealer_name').ASString)+
                     // ',AlphaCode='+QuotedStr(cdsWeb.FieldByName('dealer_aplphacode').ASString)+  // This should not be editable
                    ',Address1='+QuotedStr(cdsWeb.FieldByName('dealer_address1').ASString)+
                    ',Address2='+QuotedStr(cdsWeb.FieldByName('dealer_address2').ASString)+
                    ',Address3='+QuotedStr(cdsWeb.FieldByName('dealer_address3').ASString)+
                    ',Address4='+QuotedStr(cdsWeb.FieldByName('dealer_address4').ASString)+
                    ',DelAddr1='+QuotedStr(cdsWeb.FieldByName('dealer_deladdr1').ASString)+
                    ',DelAddr2='+QuotedStr(cdsWeb.FieldByName('dealer_deladdr2').ASString)+
                    ',DelAddr3='+QuotedStr(cdsWeb.FieldByName('dealer_deladdr3').ASString)+
                    ',DelAddr4='+QuotedStr(cdsWeb.FieldByName('dealer_deladdr4').ASString)+
                    ',Post_Code='+QuotedStr(cdsWeb.FieldByName('dealer_postcode').ASString)+
                    ',Phone='+QuotedStr(cdsWeb.FieldByName('dealer_phone').ASString)+
                    ',Email='+QuotedStr(cdsWeb.FieldByName('dealer_email').ASString)+
                    ',Website='+QuotedStr(cdsWeb.FieldByName('dealer_website').ASString)+
                    ',TaxReg='+QuotedStr(cdsWeb.FieldByName('dealer_gstnumber').ASString)+
                    ',IsActive='+QuotedStr(cdsWeb.FieldByName('dealer_isactive').ASString)+

                    ' Where ACCNO = '+cdsWeb.FieldByName('dealer_id').AsString;   // So that the supplier(dealers that have been made inactive on the web do not update exonet)
        ExecuteSQL(SQL);
        SQL := 'update dealers set dealer_hasupdate='+QuotedStr('N')+' where dealer_id='+cdsWeb.FieldByName('dealer_id').AsString;
        ExecuteWebSQL(SQL);
      end;
      cdsWeb.Next;
    end;
  except
    On E:Exception do
    begin
      WriteToFile(E.Message);
    end;
  end;
end;
}
{
procedure TExoWeb.CheckProducts;
var
  SQL, SQL2, NewCode, OnSB, OnDict: string;
  StockQty: Double;
  PGL, SGL, wid: Integer;
  ProductUpdate: Boolean;
  //============================================
  function RemoveHTML(const s: String): String;
  var
     i: Integer;
     inBraces: Boolean;
  begin
     Result := '';
     i := 1;

     inBraces := false;
     while i <= Length(s) do
     begin
        if s[i] = '<' then
           inBraces := true
        else if s[i] = '>' then
           inBraces := false
        else if not inBraces then
        begin
           if s[i] = '&' then
           begin
              if SameText(Copy(s, i, 6), '&nbsp;') then
              begin
                 Result := Result + ' ';
                 Inc(i, 5);
              end;
           end
           else
              Result := Result + s[i];
        end;

        Inc(i);
     end;
  end;
begin
  try
    WriteIf('Check Products');
    // Check Exonet Stock_Items for any updates
    SQL := 'Select S.STOCKCODE,S.DESCRIPTION,W.SALES_HTML, ISNULL(SELLPRICE1,0) as SP1,'+
           'ISNULL(SELLPRICE2,0) as SP2,ISNULL(SELLPRICE3,0) as SP3,ISNULL(SELLPRICE4,0) as SP4,'+
           'ISNULL(SELLPRICE5,0) as SP5,ISNULL(SELLPRICE6,0) as SP6,ISNULL(SELLPRICE7,0) as SP7,'+
           'ISNULL(SELLPRICE8,0) as SP8,ISNULL(SELLPRICE9,0) as SP9,ISNULL(SELLPRICE10,0) as SP10,'+
           'ISACTIVE,X_WEB_ID, X_WEB_SITE '+
           'FROM Stock_Items S left join STOCK_WEB W on S.StockCode = W.StockCode '+
           'Where  X_UPDATED = '+QuotedStr('Y');
    GetData(cdsGeneral,SQL);
    while not cdsGeneral.Eof do                                                          //  Web_Show='+QuotedStr('Y')+' And
    begin
      try
        // Check if there is a matching product_sku
        case cdsGeneral.FieldByName('X_WEB_SITE').AsInteger of
        -1:  begin OnSB:='N'; OnDict := 'N';  end;
        1:   begin OnSB:='Y'; OnDict := 'N';  end;
        2:   begin OnSB:='N'; OnDict := 'Y';  end;
        3:   begin OnSB:='Y'; OnDict := 'Y';  end;
        end;

        spSIL.Parameters.ParamByName('@STOCKCODE').Value := cdsGeneral.FieldByName('StockCode').AsString;
        spsil.Parameters.ParamByName('@LOCATION').Value := 1;

        spsil.ExecProc ;

        StockQty := spsil.Parameters.ParamByName('@ISFREE').Value;
        // spsil.Parameters.ParamByName('@ALLLOCTOTAL').Value;
        // spsil.Parameters.ParamByName('@ISINLOC').Value;
        // spsil.Parameters.ParamByName('@ISCOMMITTED').Value;
        (*
        StockQty := GetDataFloat('Select IsNull(Sum(Qty),0) From Stock_Loc_Info I, Stock_Locations L '+
                                 'where I.Location=L.LocNo '+
                                 ' and L.IsActive = '+QuotedStr('Y')+' and L.Exclude_FromFree_Stock='+QuotedStr('N')+
                                 ' and I.StockCode='+QuotedStr(cdsGeneral.FieldByName('StockCode').AsString));
        *)
        if GetWebDataInteger('Select Count(*) from product where product_id='+cdsGeneral.FieldByName('X_WEB_ID').AsString) > 0  then //There is a product->product_sku = StockCode
        begin
          //if GetWebDataString('Select product_hasupdate from product where product_id='+cdsGeneral.FieldByName('X_WEB_ID').AsString) = 'Y' then //The record has supplier_hasupdate = 'Y'
          //begin
          //  SendEMail(fLocalEMailAddress,'Sound Business Systems Data Conflict', 'Exo: STOCK_ITEMS # '+cdsGeneral.FieldByName('STOCKCODE').AsString+#13+
          //            'and Web Product # '+cdsGeneral.FieldByName('X_WEB_ID').AsString+' have both been updated');
          //  WriteIf('Send and Email here STOCK_ITEMS ['+ cdsGeneral.FieldByName('STOCKCODE').AsString+']');
          //  // We need to inform some-one that both record have been changed
          //end
          //else
          //begin  // We must update the existing record on the web - Update Regardless
          SQL:= 'Update product set '+
                'product_sku = '+QuotedStr(cdsGeneral.FieldByName('StockCode').AsString)+
                ',product_nameExo = '+QuotedStr(cdsGeneral.FieldByName('Description').AsString)+
                ',product_price1='+cdsGeneral.FieldByName('SP1').AsString+
                ',product_price2='+cdsGeneral.FieldByName('SP2').AsString+
                ',product_price3='+cdsGeneral.FieldByName('SP3').AsString+
                ',product_price4='+cdsGeneral.FieldByName('SP4').AsString+
                ',product_price5='+cdsGeneral.FieldByName('SP5').AsString+
                ',product_price6='+cdsGeneral.FieldByName('SP6').AsString+
                ',product_price7='+cdsGeneral.FieldByName('SP7').AsString+
                ',product_price8='+cdsGeneral.FieldByName('SP8').AsString+
                ',product_price9='+cdsGeneral.FieldByName('SP9').AsString+
                ',product_price10='+cdsGeneral.FieldByName('SP10').AsString+
                ',product_websbs='+QuotedStr(OnSB)+
                ',product_stocklevel='+FloatToStr(StockQty)+
                ',product_webdictate='+QuotedStr(OnDict)+
                ',product_isactive = '+QuotedStr(cdsGeneral.FieldByName('IsActive').AsString)+
                ' Where product_id='+cdsGeneral.FieldByName('X_WEB_ID').AsString;
          ExecuteWebSQL(SQL);
          ExecuteSQL('Update STOCK_ITEMS Set X_UPDATED = '+QuotedStr('N')+' WHERE X_WEB_ID ='+cdsGeneral.FieldByName('X_WEB_ID').AsString);
        end
        else
        begin
          if cdsGeneral.FieldByName('X_WEB_SITE').AsInteger > 0 then  // Only insert in product if required
          begin
            SQL:= 'Insert into product (product_sku,product_nameExo,product_price1,product_price2,product_price3,product_price4'+
                  ',product_price5,product_price6,product_price7,product_price8,product_price9,product_price10,'+
                  'product_stocklevel,  product_websbs,product_webdictate,product_isactive) Values ('+
                  QuotedStr(cdsGeneral.FieldByName('StockCode').AsString)+
                  ','+QuotedStr(cdsGeneral.FieldByName('Description').AsString)+
                  //','+QuotedStr(cdsGeneral.FieldByName('Sales_Html').AsString)+
                  ','+cdsGeneral.FieldByName('SP1').AsString+
                  ','+cdsGeneral.FieldByName('SP2').AsString+
                  ','+cdsGeneral.FieldByName('SP3').AsString+
                  ','+cdsGeneral.FieldByName('SP4').AsString+
                  ','+cdsGeneral.FieldByName('SP5').AsString+
                  ','+cdsGeneral.FieldByName('SP6').AsString+
                  ','+cdsGeneral.FieldByName('SP7').AsString+
                  ','+cdsGeneral.FieldByName('SP8').AsString+
                  ','+cdsGeneral.FieldByName('SP9').AsString+
                  ','+cdsGeneral.FieldByName('SP10').AsString+
                  ','+FloatToStr(StockQty)+
                  ','+QuotedStr(OnSB)+
                  ','+QuotedStr(OnDict)+
                  ','+QuotedStr(cdsGeneral.FieldByName('IsActive').AsString)+
                  ')';
            ExecuteWebSQL(SQL);
            wid := GetWebDataInteger('Select Max(product_id) from product where product_sku='+QuotedStr(cdsGeneral.FieldByName('StockCode').AsString));
            if cdsGeneral.FieldByName('Sales_Html').AsString <> '' then
            try
              ExecuteWebSQL('Update product set product_description='+QuotedStr(RemoveHTML(cdsGeneral.FieldByName('Sales_Html').AsString))+' Where product_id='+IntToStr(wid));
            except
              WriteIf('** Error updating Sales HTML');
            end;

            ExecuteSQL('Update STOCK_ITEMS Set X_WEB_ID = '+IntToStr(wid) +' Where STOCKCODE = '+QuotedStr(cdsGeneral.FieldByName('StockCode').AsString));
          end;
          ExecuteSQL('Update STOCK_ITEMS Set X_UPDATED = '+QuotedStr('N')+' WHERE STOCKCODE = '+QuotedStr(cdsGeneral.FieldByName('StockCode').AsString));
        end;
      finally
        cdsGeneral.Next;
      end;
    end;
  except
    On E:Exception do
    begin
      WriteToFile(E.Message);
    end;
  end;
end;
}
function TExoWeb.GetTax(Ledger: string; AccNo: Integer): TTax;
begin
  Result.Rate := 12.5;
  Result.RateNo := 1;
  if Ledger = 'D' then
    Result.RateNo := GetDataInteger('Select TaxStatus From DR_Accs Where AccNo = '+IntToStr(AccNo))
  else
    Result.RateNo := GetDataInteger('Select TaxStatus From CR_Accs Where AccNo = '+IntToStr(AccNo));
  if GetDataInteger('Select Count(*) From Tax_Rates where Seqno = '+IntToStr(Result.RateNo)) = 1 then
    Result.Rate := GetDataFloat('Select Rate From Tax_Rates where Seqno = '+IntToStr(Result.RateNo))
  else
  begin
    if Ledger = 'D' then
      Result.RateNo := GetDataInteger('SELECT FIELDVALUE FROM PROFILE_VALUES WHERE FIELDNAME='+QuotedStr('DRDEFAULTTAXRATENO'))
    else
      Result.RateNo := GetDataInteger('SELECT FIELDVALUE FROM PROFILE_VALUES WHERE FIELDNAME='+QuotedStr('CRDEFAULTTAXRATENO'));
    Result.Rate := GetDataFloat('Select Rate From Tax_Rates where Seqno = '+IntToStr(Result.RateNo));
  end;
end;

{
procedure TExoWeb.CheckOrders;
var
  InvNo, PSeqNo, DHdrSno, CHdrSno, SOHSeq, fAcc: Integer;   // SalesNo
  Rebate, Diff: Double;
  SQL, StockStat, MsgBody : string;
  OrdDate: TDateTime;
  Tax: TTax;
begin
  try
    WriteIf('Check Orders');
    Writeif('Get Data');
    SQL := 'select * from orders o left join customers c on o.customer_id = c.customer_id '+
           ' where order_status in (0,1) '+               // either new order or payment received
           ' and order_hasupdate='+QuotedStr('Y');
    WriteIf(SQL);
    GetWebData(cdsWeb,SQL);
    WriteIf('Got Data');
    while not cdsWeb.Eof do
    begin
      // Check that the sum of the lines is equal to the order subtotal
      Diff := GetWebDataFloat('SELECT Abs(o.order_subtotal - sum(d.order_unitprice*d.order_qty)) '+
                              'FROM orders o left join orders_detail d on o.order_id = d.order_id '+
                              'Where o.order_id='+cdsWeb.FieldByName('order_id').AsString);
      if Diff < 0.01 then   // If less than 1c difference then dont worry - there may be a problem if this does not get fixed and it continues to try and process more and more of these as time goes on
      begin
        if (GetDataInteger('Select Count(*) from SalesOrd_Hdr where X_WEBORD_ID='+cdsWeb.FieldByName('order_id').AsString) > 0) then
        begin
          // Check if this is a Customer and Payment received Status
          if (cdsWeb.FieldByName('order_status').AsInteger = 1) and (cdsWeb.FieldByName('customer_id').AsInteger > 0) then
            ExecuteSQL('Update SalesOrd_Hdr Set OnHold='+QuotedStr('N')+' Where X_WEBORD_ID='+cdsWeb.FieldByName('order_id').AsString)
          else
            SendEMail(fLocalEMailAddress,'Sound Business Systems Data Conflict', 'Web Order Already downloaded: '+cdsWeb.FieldByName('order_id').AsString+'.'+#13+
                                         'Any subsequent changes made will not be on the order.');
        end
        else
        begin
          WriteIf(cdsWeb.FieldByName('order_id').AsString+' '+cdsWeb.FieldByName('dealer_id').AsString+' '+cdsWeb.FieldByName('order_reference').AsString);

          // Build the SOH insert SQL depending on customer or dealer
          //SalesNo := GetDataInteger('Select SalesNo From DR_Accs Where AccNo = '+cdsWeb.FieldByName('dealer_id').AsString);
          SQL := 'INSERT INTO SALESORD_HDR (ACCNO,BRANCHNO, ORDERDATE, DUEDATE, CUSTORDERNO,REFERENCE,'+
                                            'SUBTOTAL,TAXTOTAL, X_WEBORD_ID ';
          if cdsWeb.FieldByName('customer_id').AsInteger > 0 then      // then it is a customer else its a dealer
            SQL := SQL + ',ADDRESS1, ADDRESS2, ADDRESS3, ADDRESS4, ADDRESS5, ADDRESS6, ONHOLD) VALUES('+ IntToStr(fCustAcc)
          else
            SQL := SQL + ') VALUES ('+cdsWeb.FieldByName('dealer_id').AsString;     // Branch 1 - Sales
          SQL := SQL +',1,'+ //IntToStr(SalesNo)+','+
                       QuotedStr(FormatDateTime('mm/dd/yyyy', cdsWeb.FieldByName('order_created').AsDateTime))+','+
                       QuotedStr(FormatDateTime('mm/dd/yyyy', cdsWeb.FieldByName('order_created').AsDateTime))+','+
                       QuotedStr(cdsWeb.FieldByName('order_reference').AsString)+','+
                       QuotedStr(cdsWeb.FieldByName('order_reference').AsString)+','+
                       Format('%10.2f',[cdsWeb.FieldByName('order_subtotal').AsFloat])+','+
                       Format('%10.2f',[cdsWeb.FieldByName('order_gst').AsFloat])+','+
                       cdsWeb.FieldByName('order_id').AsString;
          if cdsWeb.FieldByName('customer_id').AsInteger > 0 then      // then it is a customer else its a dealer
            SQL := SQL + ','+QuotedStr(cdsWeb.FieldByName('customer_name').AsString)+','+
                         QuotedStr(cdsWeb.FieldByName('customer_deladdr1').AsString)+','+
                         QuotedStr(cdsWeb.FieldByName('customer_deladdr2').AsString)+','+
                         QuotedStr(cdsWeb.FieldByName('customer_deladdr3').AsString)+','+
                         QuotedStr(cdsWeb.FieldByName('customer_deladdr4').AsString)+','+
                         QuotedStr(cdsWeb.FieldByName('customer_delpostcode').AsString)+','+
                         QuotedStr('Y');
          SQL := SQL + ')';
          ExecuteSQL(SQL);
          SOHSeq := GetDataInteger('SELECT SCOPE_IDENTITY()');
          fAcc := fCustAcc;
          // If its a dealer get the address details from the debtor account
          if cdsWeb.FieldByName('dealer_id').AsInteger > 0 then      // then it is a dealer
          begin
            ExecuteSQL('Update H SET H.ADDRESS1=D.NAME, H.ADDRESS2=D.DELADDR1, H.ADDRESS3=D.DELADDR2, H.ADDRESS4=D.DELADDR3, H.ADDRESS5=D.DELADDR4 '+
                       ' FROM SALESORD_HDR H LEFT JOIN DR_ACCS D ON H.ACCNO = D.ACCNO '+
                       ' WHERE H.SEQNO='+IntToStr(SOHSeq));
            fAcc := cdsWeb.FieldByName('dealer_id').AsInteger;
          end;
          if cdsWeb.FieldByName('customer_id').AsInteger > 0 then      // then it is a customer - NOT a dealer
          begin
            MsgBody := 'Sales Order : '+IntToStr(SOHSeq)+' has been created from web order: '+cdsWeb.FieldByName('order_id').AsString+'.'+#13+#10;
            if cdsWeb.FieldByName('order_method').AsString = 'cc' then
              MsgBody := MsgBody + 'Credit Card details should be retrieved from the web order and payment processed.'+#13+#10;
            if cdsWeb.FieldByName('order_method').AsString = 'dc' then
              MsgBody := MsgBody + 'Direct Credit payment expected.'+#13+#10;
            MsgBody := MsgBody +   'Once payment has been processed the web order status should be updated.';
            SendEMail(fLocalEMailAddress,'Sound Business Systems Customer Web Order', MsgBody);
          end;

          Tax := GetTax('D',fAcc);
          WriteIf('Get Order Detail');
          SQL := 'select * from orders_detail where order_id ='+cdsWeb.FieldByName('order_id').AsString;
          WriteIf(SQL);
          GetWebData(cdsWebDetail, SQL);
          StockStat := GetDataString('Select Status from Stock_Items where StockCode='+QuotedStr(cdsWebDetail.FieldByName('product_sku').AsString));
          WriteIf('Got Order Detail');
          while not cdsWebDetail.Eof do
          begin
            ExecuteSQL('INSERT INTO SALESORD_LINES(HDR_SEQNO,ACCNO,BRANCHNO,STOCKCODE,DESCRIPTION,ORD_QUANT,UNITPRICE,TAXRATE,TAXRATE_NO,'+
                        'LINKED_STOCKCODE,LINKED_QTY,LINKEDSTATUS) VALUES('+
                        IntToStr(SOHSeq)+','+IntToStr(fAcc)+',1,'+
                        QuotedStr(cdsWebDetail.FieldByName('product_sku').AsString)+','+
                        QuotedStr(cdsWebDetail.FieldByName('order_description').AsString)+','+
                        Format('%10.2f',[cdsWebDetail.FieldByName('order_qty').AsFloat])+','+
                        Format('%10.2f',[cdsWebDetail.FieldByName('order_unitprice').AsFloat])+','+
                        Format('%6.2f,%d,',[Tax.Rate, Tax.RateNo])+
                        QuotedStr(cdsWebDetail.FieldByName('product_sku').AsString)+',1,'+
                        QuotedStr(StockStat)+
                        ')');
            cdsWebDetail.Next;
          end;
        end;
        ExecuteWebSQL('update orders set order_hasupdate = '+QuotedStr('N')+' where order_id='+cdsWeb.FieldByName('order_id').AsString);
      end
      else    // There is a significant deffierence between the totals in the header and the lines so tell someone
      begin
        WriteIf('*** Order '+cdsWeb.FieldByName('order_id').AsString+' has a difference in "o.order_subtotal - sum(d.order_unitprice*d.order_qty))" of '+FloatToStr(Diff)+' and will not be processed');
        SendEMail(fLocalEMailAddress,'Sound Business Systems Data Conflict', 'Order '+cdsWeb.FieldByName('order_id').AsString+' has a difference in "o.order_subtotal - sum(d.order_unitprice*d.order_qty))" of '+FloatToStr(Diff)+' and will not be processed.'+#13+#10+
                   'Order has been marked as processed on the web.');
        ExecuteWebSQL('update orders set order_hasupdate = '+QuotedStr('N')+' where order_id='+cdsWeb.FieldByName('order_id').AsString);
      end;
      cdsWeb.Next;
    end;
  except
    On E:Exception do
    begin
      WriteToFile(E.Message);
    end;
  end;
end;
}
procedure TExoWeb.SendAttachment(ABody, FileName: string);
var
  idTxtpart: TIdText;
  AttachFile: TIDAttachmentfile;
  AFile : string;
  //fFromAddress, fFromName, fEmailAddresses: string;
begin
  with SMTPMsg do
  begin
    ContentType := 'Multipart/mixed';
    idTxtPart:=TIdText.Create(SMTPMsg.MessageParts,nil);
    idTxtPart.ContentType:='text/plain';
    idTxtPart.Body.Clear;

    idTxtPart.Body.Add(ABody);
    while (pos(';',FileName) > 0) or (length(FileName) > 0) do
    begin
      if pos(';',FileName) = 0 then
      begin
        AFile := Filename;
        FileName := '';
      end
      else
      begin
        AFile := Copy(FileName,1,pos(';',FileName)-1);
        FileName := Copy(FileName,pos(';',FileName)+1,length(FileName)-pos(';',FileName));
      end;
      WriteIf('PDF File:'+AFile);
      AttachFile := TIDAttachmentFile.Create(SMTPMsg.MessageParts, AFile);
      WriteIf('File Attached');
    end;
  end;
  with SMTP do
  begin
    WriteIf('Before Connect in SendAttachment');
    if not Connected then
      Connect;
    //if MessageDlg('Send email to '+SMTP1.PostMessage.ToAddress[0], mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    WriteIf('Before Send in SendAttachment');
    Send(SMTPMsg);
    WriteIf('After Send in SendAttachment');
    Disconnect;
  end;
end;

function TExoWeb.ExistsStockCode(StCode: String): Boolean;
begin
  try
    Result := (GetDataInteger('Select Count(*) From Stock_Items Where StockCode ='+QuotedStr(StCode)) > 0);
  except
    Result := True;
  end;
end;

//==============================================================================
procedure TExoWeb.SendEMail(EAdd, Subj, ABody: string);
begin
  with SMTPMsg do
  begin
    Recipients.EMailAddresses := EAdd;

    Subject := Subj;
    Body.Clear;
    Body.Text := ABody;
  end;
  WriteIf('To:'+Eadd+' Subj:'+Subj+' Body:'+ABody);
  try
    if not SMTP.Connected then
      SMTP.Connect;
    if fDEBUG then
    begin
      SMTPMsg.Recipients.EMailAddresses := fLocalEmailAddress;
      WriteIf('Email to Local Address');
    end;
    try
      SMTP.Send(SMTPMsg);
    except
      On E:Exception do
        WriteIf('***** Error Emailing : '+EAdd+' - Msg: '+E.Message);
    end;
  finally
    SMTP.Disconnect;
  end;
end;
end.
