unit sImport;
interface
{
Problem
Socket Error 10054 causing the service to hang
Changes
17/10/2013  Change IdHTTP Protocol version to pv1_0 as suggested http://embarcadero.newsgroups.archived.at/public.delphi.internet.winsock/201011/1011245106.html



SplashWebSvr /install
net start SplashWebExo

*******  SPLASH NOTES
NOTE:

*******
Create Table X_WEB_STOCK_PRICE(
SEQNO INT NOT NULL IDENTITY(1,1),
STOCKCODE VARCHAR(23),
PRICENO INT,
GROUPCODE VARCHAR(10),
PRICE FLOAT,
ZUID INT NOT NULL DEFAULT -1
UPDATEWEB CHAR(1) NOT NULL DEFAULT ('N')
)

Alter Table SalesOrd_Hdr ADD X_WEBORD_ID VARCHAR(10)

Create Table X_DR_CASH_ACC (
SEQNO INTEGER identity(1,1),
CURRCODE VARCHAR(3),
ACCNO INTEGER,
Websiteid INT NOT NULL DEFAULT (1)
)

Insert into X_DR_CASH_ACC(currcode, accno) values ('NZD',51)
Insert into X_DR_CASH_ACC(currcode, accno) values ('AUD',235)
Insert into X_DR_CASH_ACC(currcode, accno) values ('USD',287)
INSERT INTO X_DR_CASH_ACC(CURRCODE, ACCNO, webSITEID) VALUES ('NZ',419 ,2)

ALTER TABLE STOCK_ITEMS ADD X_COMMITTED FLOAT NOT NULL DEFAULT (0)
ALTER TABLE STOCK_ITEMS ADD X_UPDATEWEB CHAR(1) NOT NULL DEFAULT ('N')

CREATE TRIGGER [X_STOCK_ITEMS_UPDATE] ON [dbo].[STOCK_ITEMS]
AFTER UPDATE
AS
BEGIN
  DECLARE @CDE VARCHAR(23), @SP1 FLOAT, @SP2 FLOAT, @ISACT CHAR(1), @WS CHAR(1)
  SET NOCOUNT ON
    SELECT @CDE=STOCKCODE, @SP1=SELLPRICE1, @SP2=SELLPRICE2, @ISACT=ISACTIVE, @WS=WEB_SHOW FROM INSERTED;

    IF @WS='Y'
    BEGIN
      IF UPDATE(SELLPRICE1)
      BEGIN
        IF EXISTS (SELECT ZUID FROM X_WEB_STOCK_PRICE WHERE PRICENO=1 AND STOCKCODE=@CDE)
          UPDATE X_WEB_STOCK_PRICE SET PRICE = @SP1, UPDATEWEB='Y' WHERE STOCKCODE=@CDE AND PRICENO = 1
      END
      IF UPDATE(SELLPRICE2)
      BEGIN
        IF EXISTS (SELECT ZUID FROM X_WEB_STOCK_PRICE WHERE PRICENO=2 AND STOCKCODE=@CDE)
          UPDATE X_WEB_STOCK_PRICE SET PRICE = @SP2, UPDATEWEB='Y' WHERE STOCKCODE=@CDE AND PRICENO = 2
      END
    END
  SET NOCOUNT OFF
END
//-----------------------------------------------------
CREATE PROCEDURE [dbo].[X_SOL_COMMITTED]
(
  @SNO INTEGER
)
AS
BEGIN
  DECLARE @STCK VARCHAR(23)
  DECLARE @COMMITQTY FLOAT

  DECLARE CODECURSOR CURSOR FOR
     SELECT STOCKCODE FROM SALESORD_LINES
     WHERE HDR_SEQNO = @SNO

  OPEN CODECURSOR
  FETCH NEXT FROM CODECURSOR INTO @STCK

  WHILE @@FETCH_STATUS = 0
  BEGIN
    SELECT  @COMMITQTY = ISNULL(SUM(L.ORD_QUANT - L.SUP_QUANT),0)
    FROM SALESORD_LINES L LEFT JOIN SALESORD_HDR H ON L.HDR_SEQNO = H.SEQNO
    WHERE H.STATUS < 2 AND H.PROCESSFINALISATION = 0 AND L.STOCKCODE = @STCK AND L.LOCATION = 1

    UPDATE STOCK_ITEMS SET X_COMMITTED = @COMMITQTY, X_UPDATEWEB='Y'
    WHERE STOCKCODE = @STCK

    FETCH NEXT FROM CODECURSOR INTO @STCK
  END
  CLOSE CODECURSOR
  DEALLOCATE CODECURSOR
END
//--------------------------------------------------------------
  ** Note and call this from SalesOrdLineStatuses ! so that it gets updated where orders are processed
//--------------------------------------------------------------

}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs, ActiveX,
  IDSRegistry, IDSLogToFile, IdBaseComponent, IdComponent, IdTCPConnection, IdText, IdAttachmentFile,
  IdTCPClient, IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase, MidasLib,
  IdSMTP, ExtCtrls, DB, ADODB, IdMessage, IdFTP, WideStrings, FMTBcd, SqlExpr,
  DBClient, Provider, RpRender, RpRenderPDF, RpBase, RpSystem, RpDefine, RpRave,
  RpCon, RpConDS, StrUtils, ExonetFunc, IdHTTP, Math;
type
  TTax = record
    Rate: Double;
    RateNo: Integer;
  end;
type
  TZeald = record
    AppKey: string;
    WebSite: string;
  end;

type
  TSplashWebExo = class(TService)
    idsFile: TIDSLogToFile;
    idsReg: TIDSRegistry;
    dbExonet: TADOConnection;
    qryExo: TADOQuery;
    tmr: TTimer;
    SMTP: TIdSMTP;
    SMTPMsg: TIdMessage;
    FTP: TIdFTP;
    cdsGeneral: TClientDataSet;
    dspExo: TDataSetProvider;
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
    Exonet: TExonet;
    IdHTTP1: TIdHTTP;
    cdsSOH: TClientDataSet;
    cdsSOL: TClientDataSet;
    cdsSOHALPHACODE: TStringField;
    cdsSOHACCNO: TIntegerField;
    cdsSOHDUEDATE: TDateTimeField;
    cdsSOHORDERDATE: TDateTimeField;
    cdsSOHCUSTORDERNO: TStringField;
    cdsSOHREFERENCE: TStringField;
    cdsSOHSUBTOTAL: TFloatField;
    cdsSOHTAXTOTAL: TFloatField;
    cdsSOHX_WEBORD_NO: TStringField;
    cdsSOHADDRESS1: TStringField;
    cdsSOHADDRESS2: TStringField;
    cdsSOHADDRESS3: TStringField;
    cdsSOHADDRESS4: TStringField;
    cdsSOHADDRESS5: TStringField;
    cdsSOHADDRESS6: TStringField;
    cdsSOHSALESNO: TIntegerField;
    cdsSOHNARRATIVE_SEQNO: TIntegerField;
    cdsSOHONHOLD: TStringField;
    cdsSOLHDR_SEQNO: TIntegerField;
    cdsSOLACCNO: TIntegerField;
    cdsSOLSTOCKCODE: TStringField;
    cdsSOLDESCRIPTION: TStringField;
    cdsSOLORD_QUANT: TFloatField;
    cdsSOLUNITPRICE: TFloatField;
    cdsSOLTAXRATE: TFloatField;
    cdsSOLTAXRATE_NO: TIntegerField;
    cdsSOLLINKED_STOCKCODE: TStringField;
    cdsSOLLINKED_QTY: TFloatField;
    cdsSOLLINKEDSTATUS: TStringField;
    cdsSOLSubTotal: TFloatField;
    cdsSOHNARRATIVE: TStringField;
    cdsSOHFREIGHT: TFloatField;
    procedure ServiceExecute(Sender: TService);
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure tmrTimer(Sender: TObject);
    procedure SMTPStatus(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: string);
    procedure ExonetPrint(Sender: TObject);
    procedure IdHTTP1Status(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: string);
  private
    { Private declarations }
    fAddress: string;
    fWriteAll: Boolean;
    fWriteSQL: Boolean;
    fDEBUG: Boolean;
    fLocalEmailAddress: string;
    fExportFolder: string;       // Folder for putting the pdf file before emailing
    fStockDate: TDateTime;
    fComputerProfile: Integer;
    //fZ: TZeald;

    procedure WriteToFile(S:String);
    procedure WriteIt(S:String; DoIt: Boolean);
    procedure WriteIf(S: String);
    function zifb(AStr: string): string;
    function ifb(AStr, DefStr: string): string;
    procedure GetGeneralData(SQL:string);
    procedure ExecuteSQL(SQL: string);

    function GetDataInteger(SQL: String): integer;
    function GetDataFloat(SQL: String): double;
    function GetDataString(SQL: String): string;
    procedure GetData(cds: TClientDataSet; SQL: String);

    procedure GetRegSettings;
    procedure Process;
    procedure CheckOrders;
    procedure CheckStock;
    procedure SendEMail(EAdd, CCEAdd, Subj, ABody: string);
    function GetStringProfile(ProfileID: integer; FldName: string): String;
    //function StockCodeExists(StockCode: string): Boolean;
    procedure GetPricing(StockCode: string; webid: integer);
    function GetVal(AStr, id: string): string;
    function GetRecord(var RemStr, RecStr: string; id: string): Boolean;
    function UpdateOrder(ONo, tf: string; webId:integer): Boolean;
    function GetAccNo(Webid: integer; Alpha, Curr: string): integer;
    function GetTax(Ledger: string; AccNo: Integer): TTax;
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  SplashWebExo: TSplashWebExo;

//const
//  z_api_key = '323bdAD5Bb26Aeb6e0d6';
//  z_website = 'pinnaclev';
//  DEBUG=TRUE;
//  https://323bdAD5Bb26Aeb6e0d6:@secure.zeald.com/pinnaclev/API/V2/Order
implementation

{$R *.DFM}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  SplashWebExo.Controller(CtrlCode);
end;

function TSplashWebExo.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TSplashWebExo.ServiceExecute(Sender: TService);
begin
  //GetRegSettings;
  tmr.Enabled := True;
  fStockDate := Date -1;                 // Force the stock and debtor updates to happen initially
  cdsSOH.CreateDataSet;
  cdsSOL.CreateDataSet;
  while not Terminated do
    ServiceThread.ProcessRequests(True);
end;

procedure TSplashWebExo.ServiceStart(Sender: TService; var Started: Boolean);
var
  Guid: TGuid;
begin
  CoInitialize(nil);
  CreateGUID(Guid);
  RPDefine.DataID := GuidToString(Guid);
  //--WebConn.AutoClone := False;
end;

procedure TSplashWebExo.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
  CoUnInitialize;
end;

procedure TSplashWebExo.SMTPStatus(ASender: TObject; const AStatus: TIdStatus;
  const AStatusText: string);
begin
  WriteIf('SMTP :'+AStatusText);
end;

procedure TSplashWebExo.tmrTimer(Sender: TObject);
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
procedure TSplashWebExo.WriteToFile(S:String);
begin
  WriteIt(S, True);
end;

//==============================================================================
procedure TSplashWebExo.WriteIf(S:String);
begin
  WriteIt(S, fWriteAll);
end;

//==============================================================================
procedure TSplashWebExo.WriteIt(S:String; DoIt: Boolean);
begin
  if DoIt then
  begin
    idsFile.Write(S);
  end;
end;
//==============================================================================
function TSplashWebExo.ifb(AStr, DefStr: string): string;
var
  BStr: string;
begin
  BStr := Trim(AStr);
  if BStr = '' then
    Result := DefStr
  else
    Result := BStr;
end;

function TSplashWebExo.zifb(AStr: string): string;
begin
  Result := ifb(AStr,'0');
end;

procedure TSplashWebExo.GetGeneralData(SQL: String);
begin
  GetData(cdsGeneral, SQL);
end;

function TSplashWebExo.GetRecord(var RemStr: string; var RecStr: string; id: string): Boolean;
var
  SStart, SLen: integer;
begin
  if (pos('<'+id,RemStr) > 0) and (pos('</'+id+'>',RemStr) > 0)  then
  begin
    SStart := pos('<'+id+'>',RemStr) + Length(id) + 2;
    SLen := pos('</'+id+'>',RemStr) - SStart;
    RecStr := Copy(RemStr, SStart, SLen);
    SStart := SStart + SLen + Length(id) + 3;
    SLen := Length(RemStr) + 1 - SStart;
    RemStr := Copy(RemStr, SStart, SLen);
    Result := True;
  end
  else
    Result := False;
end;

function TSplashWebExo.GetVal(AStr, id:string): string;
var
  SStart, SLen: integer;
begin
  SStart := pos('<'+id+'>',AStr) + Length(id) + 2;
  SLen := pos('</'+id+'>',AStr) - SStart;
  Result := Copy(AStr, SStart, SLen)
end;

procedure TSplashWebExo.IdHTTP1Status(ASender: TObject;
  const AStatus: TIdStatus; const AStatusText: string);
begin
  WriteIf('Status '+AStatusText);
end;

procedure TSplashWebExo.GetPricing(StockCode: string; webid: integer);
var
  address, Resp, RemResp, RecResp: string;
  PNo, GCode, Price, Zuid, SQL: string;
  SNo: Integer;
begin
  try
    address := fAddress+'?website='+IntToStr(webid)+'&typ=1&table=PricingAdvanced&srchstr=sku&srchval='+StockCode;
    //address := fAddress+'?typ=1&table=PricingAdvanced&srchstr=sku&srchval='+StockCode;
    Resp := idHTTP1.Get(address);
    WriteIf(Resp);
    RemResp := Resp;
    // for each of the advanced pricing records
    while GetRecord(RemResp, RecResp,'PricingAdvanced') do
    begin
      GCode := GetVal(RecResp, 'group_code');
      Price := GetVal(RecResp, 'price');
      //GetVal(RecResp, 'sku');
      Zuid := GetVal(RecResp, 'uid');
      PNo := '-99';
      if GCode = 'B2CVIP' then
        PNo := '3';
      if GCode = 'B2B' then
        PNo := '2';
      if GCode = '' then
        PNo := '1';
      if (PNo <> '-99') then
      begin
        if (GetDataInteger('Select Count(*) From X_WEB_STOCK_PRICE Where StockCode = '+QuotedStr(StockCode)+
                           ' and PriceNo='+PNo+' and WebId='+IntToStr(webid)) = 0) then
        begin
          SQL := 'Insert into X_WEB_STOCK_PRICE(StockCode, PriceNo, GroupCode, Price, Zuid, WebId) Values('+
                 QuotedStr(StockCode)+','+PNo+','+QuotedStr(GCode)+','+Price+','+Zuid+','+IntTostr(webid)+')';
          ExecuteSQL(SQL);
          SNo := GetDataInteger('Select @@IDENTITY from X_WEB_STOCK_PRICE');
          ExecuteSQL('Update X SET X.UPDATEWEB='+QuotedStr('Y')+', X.PRICE=S.SELLPRICE'+PNo+' '+
                     'From X_WEB_STOCK_PRICE X left join STOCK_ITEMS S on X.STOCKCODE = S.STOCKCODE '+
                     'Where X.SEQNO = '+IntToStr(SNo));
        end
        else
        begin
          SQL := 'Update X_WEB_STOCK_PRICE Set Zuid = '+Zuid+ ' Where StockCode = '+QuotedStr(StockCode)+
                 ' and PriceNo = '+PNo+' and WebId='+IntToStr(webid);
          //WriteIf(SQL);
          ExecuteSQL(SQL);
        end;
      end;
    end;
  finally
    idHTTP1.Disconnect;
  end;
end;

procedure TSplashWebExo.GetData(cds: TClientDataSet; SQL: String);
begin
  if fWriteSQL then
    WriteIf('EXO: '+SQL);
  cds.Close;
  if cds.ProviderName = '' then
    cds.ProviderName := 'dspExo';
  qryExo.SQL.Text := SQL;
  cds.Open;
end;

function TSplashWebExo.GetDataString(SQL: String): string;
begin
  if fWriteSQL then
    WriteIf('EXO: '+SQL);
  qryExo.Close;
  qryExo.SQL.Text := SQL;
  qryExo.Open;
  Result := qryExo.Fields[0].AsString;
end;

function TSplashWebExo.GetDataInteger(SQL: String): integer;
begin
  if fWriteSQL then
    WriteIf('EXO: '+SQL);
  qryExo.Close;
  qryExo.SQL.Text := SQL;
  qryExo.Open;
  Result := qryExo.Fields[0].AsInteger;
end;

function TSplashWebExo.GetDataFloat(SQL: String): double;
begin
  if fWriteSQL then
    WriteIf('EXO: '+SQL);
  qryExo.Close;
  qryExo.SQL.Text := SQL;
  qryExo.Open;
  Result := qryExo.Fields[0].AsFloat;
end;

procedure TSplashWebExo.ExecuteSQL(SQL: string);
begin
  qryExo.Close;
  qryExo.SQL.Text := SQL;
  if fWriteSQL then
    WriteIf('EXO: '+SQL);
  //if not fDEBUG then
    qryExo.ExecSQL;
end;

procedure TSplashWebExo.ExonetPrint(Sender: TObject);
begin
  WriteIf((Sender as TExonet).fPrintString);
end;

procedure TSplashWebExo.GetRegSettings;
var
  LogAll, LogSQL, msg, fName: String;
begin
  fWriteAll := False;
  fWriteSQL := False;
  fDEBUG := TRUE;
  try
    fAddress := 'http://galaxi.co.nz/WebSplash.php';
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
    try
      fComputerProfile := idsReg.ReadInteger('ComputerProfile');
    except
      fComputerProfile := 0;
    end;
    WriteToFile('Computer Profile='+IntToStr(fComputerProfile));
    Exonet.ClarityPath := idsReg.ReadString('ClarityPath');
    Exonet.Alias := idsReg.ReadString('ExoAlias');
    Exonet.Login := idsReg.ReadString('ExoLogin');
    Exonet.Password := idsReg.ReadString('ExoPassword');

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
    msg := 'Error getting Zeald Connection Settings';
    //fZ.AppKey := z_api_key; //idsReg.ReadString('ZAppKey');
    //fZ.WebSite := z_website; //idsReg.ReadString('ZWebSite');
  except
    On E:Exception do
    begin
      WriteToFile(E.Message+' '+Msg);
      //WriteToFile(Msg);
      WriteToFile('Interval = '+IntToStr(tmr.Interval));
      //SendEMail('richard@acclaimgroup.co.nz','','Splash Error', 'Get RegSettings');
      exit;
    end;
  end;
  try
    try
      dbExonet.Connected := True;
      WriteToFile('Connection Succeeds');
      dbExonet.Connected := False;
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
procedure TSplashWebExo.Process;
begin
  //try
    WriteIf('Start Process');
    CheckOrders;
    CheckStock;
  //finally
  //  idHttp1.Disconnect;  // do this individually in each of the above
  //end;
end;

function TSplashWebExo.GetStringProfile(ProfileID: integer; FldName: string): String;
var
  SQL :string;
begin
  SQL := 'Select PF.DefaultValue, PV.FieldValue, PV.ProfileID' +
         ' From Profile_Fields PF left join Profile_Values PV ' +
         ' ON PF.FieldName = PV.FieldName Where Upper(PF.FieldName) = Upper('+QuotedStr(FldName)+')'+
         ' Order By ProfileID Desc';
  WriteIf(SQL);
  GetGeneralData(SQL);
  WriteIf('Query Complete');
  cdsGeneral.Locate('PROFILEID',ProfileID,[]);
  if cdsGeneral.FieldByName('FIELDVALUE').IsNull then
    Result := cdsGeneral.FieldByName('DefaultValue').AsString
  else
    Result := cdsGeneral.FieldByName('FieldValue').AsString;
  WriteIf('Result='+Result);
end;

(*
  GET https://[application_key]:@secure.zeald.com/[website name]/API/V2/Order+Orderline?integrated=false
  process the resulting XML file and execute your custom application logic (eg inserting it into a local accounting system)
  Post XML back to the website, setting integrated=true
  POST https://[application_key]:@secure.zeald.com/[website name]/API/V2/Order

  <ResultSet>
  <Order><order_number>ORD0001</order_number><integrated>true</integrated></Order>
  <Order><order_number>ORD0002</order_number><integrated>true</integrated></Order>
  </ResultSet>
*)
function TSplashWebExo.GetAccNo(Webid: integer; Alpha, Curr: string): integer;
var
  Acc: Integer;
begin
  WriteIf('GetAccno  WebId: '+IntToStr(WebID)+' Alpha: '+Alpha+' Curr: '+Curr);
  Acc := 0;
  if GetDataInteger('Select Count(*) from DR_ACCS where AlphaCode='+QuotedStr(Alpha)) = 1 then
    Acc := GetDataInteger('Select AccNo from DR_ACCS where AlphaCode='+QuotedStr(Alpha))
  else
  begin
    if GetDataInteger('Select Count(*) from X_DR_CASH_ACC where WebSiteid='+IntToStr(webid)+' and CurrCode='+QuotedStr(Curr)) = 1 then
      Acc := GetDataInteger('Select AccNo From X_DR_CASH_ACC where WebSiteid='+IntTostr(webid)+' and CurrCode='+QuotedStr(Curr))
    else
      Acc := 0;
  end;
  Result := Acc;
end;

procedure TSplashWebExo.CheckOrders;
var
  address, Resp, RemResp, RecResp, OrdTxt, LineTxt, A1, A2: string;
  Comment, CurrCode, SQL, Held, StockStat : string;
  HasBO: Boolean;
  Tax: TTax;
  NSeqNo, SOHSeq, PNo, Level, i: Integer;
  LPrice, QAvail, QBack: double;
begin
  for I := 1 to 2 do                    // 2 websites
  begin
    try
      WriteIf('Check Orders - site '+InttoStr(i));
      Resp := '';
      address := fAddress+'?website='+IntToStr(i)+'&typ=1&table=Order';       // Splash, then Wild Blue
      //address := fAddress+'?typ=1&table=Order';       // this creates Order+Orderline?integrated=false
      WriteIf('Web Address '+address);                // ie http://galaxi.co.nz/WebSplash.php?typ=1&table=Order

      Resp := idHTTP1.Get(address);
      WriteIf('Get Result');
      RemResp := Resp;
      WriteIf('Check if Orders exits');
      while GetRecord(RemResp, RecResp,'Order') do
      begin
        //WriteIf('Start Transaction');
        //Level := dbExonet.BeginTrans;
        //WriteIf('Level '+IntToStr(Level));
        try
          WriteIf('Empty Temp Datasets');
          cdsSOL.EmptyDataSet;
          cdsSOH.EmptyDataSet;
          OrdTxt := RecResp;
          while GetRecord(OrdTxt, LineTxt, 'OrderLine') do
          begin
            cdsSOL.Insert;
            cdsSOLStockCode.AsString := GetVal(LineTxt, 'sku');
            WriteIf('Get Line:'+cdsSOLStockCode.AsString);
            //cdsSOLDESCRIPTION.AsString := Copy(GetVal(LineTxt, 'description'),1,40);
            cdsSOLDESCRIPTION.AsString := GetDataString('Select Description From Stock_Items where StockCode='+QuotedStr(cdsSOLStockCode.AsString));
            cdsSOLLINKED_STOCKCODE.AsString := cdsSOLStockCode.AsString;
            cdsSOLORD_QUANT.AsString := zifb(GetVal(LineTxt, 'quantity'));
            cdsSOLSubTotal.AsString:= zifb(GetVal(LineTxt, 'subtotal_numeric'));
            cdsSOLUnitPrice.AsFloat := cdsSOLSubTotal.AsFloat / cdsSOLORD_QUANT.AsFloat;  //GetVal(LineTxt, 'price')
            cdsSOL.Post;
          end;
          WriteIf('Get Header');
          cdsSOH.Insert;
          CurrCode := GetVal(OrdTxt, 'currency_code');
          cdsSOHAddress5.AsString := GetVal(OrdTxt, 'b_country');
          cdsSOHAccNo.AsInteger := GetAccNo(i,GetVal(OrdTxt, 'username'), cdsSOHAddress5.AsString);  // Changed from CurrCode 18/6/2011
          WriteIf('4');
          cdsSOHX_WEBORD_NO.AsString := GetVal(OrdTxt, 'order_number');
          WriteIf('Get Tax');
          Tax := GetTax('D',cdsSOHAccNo.AsInteger);
          PNo := GetDataInteger('Select PRICENO from DR_ACCS where ACCNO = '+cdsSOHAccNo.AsString);
          cdsSOHAddress1.AsString := Copy(GetVal(OrdTxt, 'b_fname')+' '+GetVal(OrdTxt, 'b_lname'),1,30);
          cdsSOHAddress2.AsString := GetVal(OrdTxt, 'b_address1');
          cdsSOHAddress3.AsString := GetVal(OrdTxt, 'b_address2');
          cdsSOHAddress4.AsString := GetVal(OrdTxt, 'b_city');
          cdsSOHSalesNo.AsInteger := 1;
          WriteIf('Get State');
          A1 := GetVal(OrdTxt, 'b_state');
          A2 := GetVal(OrdTxt, 'b_zip');
          if (A2<>'') or (A1 <> '') then
          begin
            if (A1 <> '') then
              cdsSOHAddress6.AsString := A1;
            if (A2<>'') then
            begin
              if (A1 <> '') then
                cdsSOHAddress6.AsString := cdsSOHAddress6.AsString+', ';
              cdsSOHAddress6.AsString := cdsSOHAddress6.AsString+A2;
            end;
          end;
          cdsSOHNarrative.AsString := GetVal(OrdTxt, 'comments');
          A1 := GetVal(OrdTxt, 'order_date');
          WriteIf('Order Date');
          cdsSOHOrderDate.AsDateTime := EncodeDate(StrToInt(Copy(A1,1,4)),StrToInt(Copy(A1,6,2)),StrToInt(Copy(A1,9,2)));
          cdsSOHDueDate.AsDateTime := cdsSOHOrderDate.AsDateTime;
          cdsSOHTAXTOTAL.AsString := zifb(GetVal(OrdTxt, 'salestax'));
          cdsSOHSUBTOTAL.AsString := zifb(GetVal(OrdTxt, 'subtotal'));
          cdsSOHFreight.AsString := zifb(GetVal(OrdTxt, 'shipping'));
          cdsSOHSUBTOTAL.AsFloat := cdsSOHSUBTOTAL.AsFloat + cdsSOHFREIGHT.AsFloat;
          WriteIf('cdsSOH Post');
          cdsSOH.Post;
          //txt := GetVal(OrdTxt, 'total_cost');
          // Process7 the order
          WriteIf('Insert Narrative');
          if cdsSOHNarrative.AsString <> '' then
          begin
            SQL := 'Insert into Narratives (Narrative) Values ('+QuotedStr(cdsSOHNarrative.AsString)+')';
            ExecuteSQL(SQL);
            NSeqNo := GetDataInteger('SELECT @@IDENTITY FROM NARRATIVES');
          end
          else
            NSeqNo := -1;
          Held := 'N';
          HasBO := False;
          WriteIf('Insert Header');
          SQL := 'INSERT INTO SALESORD_HDR (ACCNO, ORDERDATE, DUEDATE, CUSTORDERNO,REFERENCE,'+
                      'SUBTOTAL,TAXTOTAL, X_WEBORD_ID ,ADDRESS1, ADDRESS2, ADDRESS3, ADDRESS4, '+
                      'ADDRESS5, ADDRESS6, SALESNO, NARRATIVE_SEQNO, ONHOLD) VALUES('+
                      cdsSOHACCNO.AsString+','+
                      QuotedStr(FormatDateTime('mm/dd/yyyy', cdsSOHOrderDate.AsDateTime))+','+
                      QuotedStr(FormatDateTime('mm/dd/yyyy', cdsSOHDueDate.AsDateTime))+','+
                      QuotedStr(cdsSOHCUSTORDERNO.AsString)+','+
                      QuotedStr(cdsSOHREFERENCE.AsString)+','+
                      cdsSOHSUBTOTAL.AsString+','+
                      cdsSOHTAXTOTAL.AsString+','+
                      QuotedStr(cdsSOHX_WEBORD_NO.AsString)+','+
                      QuotedStr(Copy(cdsSOHAddress1.AsString,1,30))+','+
                      QuotedStr(Copy(cdsSOHAddress2.AsString,1,30))+','+
                      QuotedStr(Copy(cdsSOHAddress3.AsString,1,30))+','+
                      QuotedStr(Copy(cdsSOHAddress4.AsString,1,30))+','+
                      QuotedStr(Copy(cdsSOHAddress5.AsString,1,30))+','+
                      QuotedStr(Copy(cdsSOHAddress6.AsString,1,30))+','+
                      zifb(cdsSOHSALESNO.AsString)+','+
                      IntToStr(NSeqNo)+','+
                      QuotedStr(Held)+
                       //QuotedStr(cdsWeb.FieldByName('DelAddr6').AsString);
                       ')';
          ExecuteSQL(SQL);
          SOHSeq := GetDataInteger('SELECT @@IDENTITY FROM SALESORD_HDR');
          cdsSOL.First;
          while not cdsSOL.Eof do
          begin
            // BKORD_QUANT
            WriteIf('Insert Line: '+cdsSOLSTOCKCODE.AsString);
            LPrice := GetDataFloat('Select SellPrice'+IntToStr(PNo)+' From Stock_Items where StockCode = '+QuotedStr(cdsSOLStockcode.AsString));
            QAvail := MaxValue([0.0,GetDataFloat('Select TOTALSTOCK-X_COMMITTED From Stock_Items where StockCode = '+QuotedStr(cdsSOLStockcode.AsString))]);
            if QAvail >= cdsSOLORD_QUANT.AsFloat then
              QBack := 0.0
            else
            begin
              QBack := cdsSOLORD_QUANT.AsFloat - QAvail;
              HasBO := True;
            end;
            StockStat := GetDataString('Select Status from Stock_Items where StockCode='+QuotedStr(cdsSOLStockcode.AsString));
            SQL := 'INSERT INTO SALESORD_LINES(HDR_SEQNO,ACCNO,STOCKCODE,DESCRIPTION,ORD_QUANT, UNITPRICE,'+
                        'TAXRATE,TAXRATE_NO,LISTPRICE, BKORD_QUANT, LINKED_STOCKCODE,LINKED_QTY,LINKEDSTATUS) VALUES('+
                        IntToStr(SOHSeq)+','+cdsSOHACCNO.AsString+','+
                        QuotedStr(cdsSOLSTOCKCODE.AsString)+','+
                        QuotedStr(cdsSOLDESCRIPTION.AsString)+','+
                        cdsSOLORD_QUANT.AsString+','+
                        cdsSOLUNITPRICE.AsString+','+
                        Format('%6.2f,%d,%10.2f,%10.2f,',[Tax.Rate, Tax.RateNo, LPrice, QBack])+
                        QuotedStr(cdsSOLSTOCKCODE.AsString)+',1,'+
                        QuotedStr(StockStat)+
                        ')';

            ExecuteSQL(SQL);
            cdsSOL.Next;
          end;
          // ****** And a shipping line if there is FREIGHT
          if (cdsSOHFreight.AsFloat <> 0) then
          begin
            WriteIf('Insert Line: Freight');
            StockStat := GetDataString('Select Status from Stock_Items where StockCode='+QuotedStr('FR'));
            SQL := 'INSERT INTO SALESORD_LINES(HDR_SEQNO,ACCNO,STOCKCODE,DESCRIPTION,ORD_QUANT,UNITPRICE,'+
                        'TAXRATE,TAXRATE_NO, LISTPRICE, LINKED_STOCKCODE,LINKED_QTY,LINKEDSTATUS) VALUES('+
                        IntToStr(SOHSeq)+','+cdsSOHACCNO.AsString+','+
                        QuotedStr('FR')+','+
                        QuotedStr('Freight')+',1.0,'+
                        cdsSOHFreight.AsString+','+
                        Format('%6.2f,%d,',[Tax.Rate, Tax.RateNo])+
                        cdsSOHFreight.AsString+','+
                        QuotedStr('FR')+',1,'+
                        QuotedStr(StockStat)+
                        ')';

            ExecuteSQL(SQL);
          end;
          if HasBO then    // It defaults to 'N'
            ExecuteSQL('Update SalesOrd_Hdr Set BACKORDER = '+QuotedStr('Y')+' Where Seqno='+IntToStr(SOHSeq));
          WriteIf('Execute Procedure');
          ExecuteSQL('EXECUTE X_SOL_COMMITTED '+IntToStr(SOHSeq));
          // Update the web
          WriteIf('Update Web data');
          UpdateOrder(cdsSOHX_WebOrd_No.AsString, 'true', i);
          //dbExonet.CommitTrans;
        except
          //on E:Exception do
          //begin
            WriteIf ('Error order: '+ cdsSOHX_WEBORD_NO.AsString+' Transaction rolled back');
            //dbExonet.RollbackTrans;
          //end;
        end;
      end;
    finally
      idHTTP1.Disconnect;
    end;
  end;
end;

function TSplashWebExo.UpdateOrder(ONo, tf: string; webId:integer): Boolean;
var
  PParam: TStringList;
  address, Resp: string;
begin
    Result := False;
    address := fAddress+'?website='+IntToStr(webid)+'&typ=4';              // Splash, then Wild Blue
    //address := fAddress+'?typ=4';              // This update Order - integrated
    //i := 0;
    try
      PParam := TStringList.Create;
      PParam.Clear;
      PParam.Add('ono[0]='+Ono);
      PParam.Add('integ[0]='+tf);
      Resp := idHTTP1.Post(address, PParam);
      Result := (GetVal(Resp,'success') = '1');
    finally
      PParam.Free;
    end;
end;
(*
function TSplashWebExo.StockCodeExists(StockCode: String): Boolean;
var
  Resp: String;
begin
  Result := False;
  Resp := IdHTTP1.Get('https://'+fZ.AppKey+':@secure.zeald.com/'+fZ.WebSite+'/API/V2/Products/'+StockCode);
  // If the product exists
  Result := True;
end;
*)
procedure TSplashWebExo.CheckStock;
var
  SQL, CodeList, Alt_Item, dd, address: string;  //, HStr
  Resp: array [1..2] of string;
  i, HVal: integer;
  PParam: TStringList;
  //-------------------------------------
  function StripIt(InStr: string): string;
  begin
    Result := Trim(InStr);
    Result := ReplaceText(Result,'''','');
  end;
begin
  try
    // Inventory
    WriteIf('---------Check Inventory');
    GetData(cdsGeneral,'Select StockCode, TotalStock - X_COMMITTED as QTY From Stock_Items Where '+
                       'IsActive='+QuotedStr('Y')+
                       ' AND X_UPDATEWEB='+QuotedStr('Y')+
                       ' And Web_Show='+QuotedStr('Y'));
    //address := fAddress+'?website=2&typ=3';              //
    //address := fAddress+'?typ=3';              // This updates Inventory
    //i := 0;
    try
      PParam := TStringList.Create;
      cdsGeneral.First;
      while not cdsGeneral.Eof do
      begin
        try
          PParam.Clear;
          PParam.Add('sku[0]='+cdsGeneral.FieldByName('StockCode').AsString);
          if cdsGeneral.FieldByName('QTY').AsFloat > 0 then
            PParam.Add('qty[0]='+cdsGeneral.FieldByName('QTY').AsString)
          else
            PParam.Add('qty[0]=0');
          for i := 1 to 2 do
          begin
              WriteIf('Try site '+IntToStr(i));
              address := fAddress+'?website='+IntToStr(i)+'&typ=3';              // Splash then Wild Blue
              if fDEBUG then
                WriteIf(address+' '+PParam.Strings[0]+' '+PParam.Strings[1])
              else
                Resp[i] := idHTTP1.Post(address, PParam);
              WriteIf('Response '+IntToStr(i)+' = '+Resp[i]);
          end;
          // If there is a successful response update the X_UpdateWeb flag
          // This might not work as the stock items may not be on both sites - SO TRY "OR"
          if (GetVal(Resp[1],'success') = '1') or (GetVal(Resp[2],'success') = '1') then
            ExecuteSQL('Update Stock_Items Set X_UPDATEWEB='+QuotedStr('P')+    // Change to 'P' then use this to do the pricing
                       ' Where StockCode='+QuotedStr(cdsGeneral.FieldByName('StockCode').AsString))
          else
            WriteIf('*** Unable to update StockCode ('+cdsGeneral.FieldByName('StockCode').AsString+') quantity on the web site');
        except
          On E:Exception do
          begin
            WriteToFile(E.Message);
            //WriteToFile(Msg);
            ExecuteSQL('Update Stock_Items Set X_UPDATEWEB='+QuotedStr('R')+
                       ' Where StockCode='+QuotedStr(cdsGeneral.FieldByName('StockCode').AsString));
            WriteToFile('StockCode '+cdsGeneral.FieldByName('StockCode').AsString +' set X_UPDATEWEB=R');
          end;
        end;
        cdsGeneral.Next;
      end;
    finally
      idHTTP1.Disconnect;
      PParam.Free;
    end;

    WriteIf('---------Check Stock');
    // First check if the stock codes in the PricingAdvanced table have been identified and stored in the X_Stock_Pricing table (for each website)
    GetData(cdsGeneral,'Select Stockcode from Stock_Items where X_UPDATEWEB=''P'' AND IsActive=''Y'' and Web_Show=''Y''');

    for I := 1 to 2 do
    begin
      WriteIf('GetPricing for webid: '+IntToStr(i));
      cdsGeneral.First;
      if i=1 then Hval := 3 else HVal := 1;   // There are 3 prices for website 1 and 1 for website 2
      while not cdsGeneral.Eof do
      begin
        if GetDataInteger('Select Count(*) From X_WEB_STOCK_PRICE Where StockCode='+QuotedStr(cdsGeneral.FieldByName('StockCode').AsString)+
                          ' and ZUID <> -1 and WebID='+IntToStr(i)) < HVal then
        begin
          // Get All the Advanced Pricing for this StockCode and insert into X_WEB_STOCK_PRICE
          GetPricing(cdsGeneral.FieldByName('STOCKCODE').AsString, i);
        end;
        if i=2 then
          ExecuteSQL('Update Stock_Items Set X_UPDATEWEB='+QuotedStr('N')+    // Change to 'N' so now complete
                     ' Where StockCode='+QuotedStr(cdsGeneral.FieldByName('StockCode').AsString));
        cdsGeneral.Next;
      end;
    end;

    WriteIf('---------Check Price Updates');
    // Check Exonet Stock_Items for any updates  - do all except old inactive ones that have not been changed in 7  days
    for i := 1 to 2 do
    begin
      GetData(cdsGeneral,'Select SEQNO, PRICE, ZUID, STOCKCODE FROM X_WEB_STOCK_PRICE '+
                ' Where UPDATEWEB='+QuotedStr('Y')+
                ' And WebId='+IntToStr(i)+
                ' And ZUID > 0');

      // Check if there is a matching stock_id {Perhaps we don't need to do this at all as the web service handles inserts / updates}
      //if StockCodeExists(cdsGeneral.FieldByName('STOCKCODE').AsString) then
      address := fAddress+'?website='+IntToStr(i)+'&typ=2';              // Splash then Wild Blue
      //address := fAddress+'?website=2&typ=2';              //
      //address := fAddress+'?typ=2';              // This update PricingAdvanced
      //i := 0;
      try
        PParam := TStringList.Create;
        while not cdsGeneral.Eof do
        begin
          PParam.Clear;
          PParam.Add('uid[0]='+cdsGeneral.FieldByName('Zuid').AsString);
          PParam.Add('price[0]='+cdsGeneral.FieldByName('Price').AsString);
          if fDEBUG then
            WriteIf(address+' '+PParam.Strings[0]+' '+PParam.Strings[1])
          else
            Resp[i] := idHTTP1.Post(address, PParam);
          // If there is a successful response update the X_UpdateWeb flag
          if (GetVal(Resp[i],'success') = '1') then
            ExecuteSQL('Update X_WEB_STOCK_PRICE Set UPDATEWEB='+QuotedStr('N')+' Where Seqno='+cdsGeneral.FieldByName('SEQNO').AsString)
          else
            WriteIf('*** Unable to update price for: Webid ('+InttoStr(i)+') - Stockcode ('+cdsGeneral.FieldByName('StockCode').AsString+' - Zuid ('+cdsGeneral.FieldByName('Zuid').AsString+'on the web');
          cdsGeneral.Next;
        end;
      finally
        idHTTP1.Disconnect;
        PParam.Free;
      end;
    end;
  except
    On E:Exception do
    begin
      WriteToFile(E.Message);
    end;
  end;
end;

//==============================================================================
procedure TSplashWebExo.SendEMail(EAdd, CCEAdd, Subj, ABody: string);
begin
  with SMTPMsg do
  begin
    Recipients.EMailAddresses := EAdd;
    CCList.EMailAddresses := CCEAdd;
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
      WriteIf('***** Error Emailing : '+EAdd);
    end;
  finally
    SMTP.Disconnect;
  end;
end;


function TSplashWebExo.GetTax(Ledger: string; AccNo: Integer): TTax;
begin
  Result.Rate := 15.0;
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

end.
