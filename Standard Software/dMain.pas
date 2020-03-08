unit dMain;

interface

uses
  SysUtils, Classes, IniFiles, DB, ADODB, Dialogs, ImgList, Controls,  ShowVersion,
  Provider, DBClient, IDSRegistry, IDSLogToFile, MidasLib, JvComponentBase,
  JvCipher, JvLogFile,JvLogClasses, frxClass, frxDBSet, frxExportCSV,
  frxExportPDF, frxVariables, vcl.Forms, StrUtils, AccLib;

type
  TdmMain = class(TDataModule)
    dbConn: TADOConnection;
    ImageList: TImageList;
    idsVer: TIDSShowVersion;
    idsReg: TIDSRegistry;
    dspConn: TDataSetProvider;
    qryConn: TADOQuery;
    cdsGeneral: TClientDataSet;
    jvFile: TJvLogFile;
    frxReport: TfrxReport;
    jvCipher: TJvCaesarCipher;
    procedure DataModuleCreate(Sender: TObject);
  private
    ReportParam: array of array[0..1] of string;
    procedure PrintPreview(ReportName, Title, ParamList: string; PP: Integer;
      IsModal: Boolean);
    procedure SetupReport(ReportName, Title, ParamList: string);
    function GetProfile(Profile: string): string;
    procedure ProjectExecute;
    { Private declarations }
  public
    { Public declarations }
    fDebug: Boolean;
    fToFile: Boolean;
    fWeekly: Boolean;
    fClientName:string;
    fReportName: string;
    fRptInvName: String;
    fRptStateName: String;
    fSMTPFromAddress: string;
    fSMTPFromName: string;
    fSMTPHost: string;
    fSMTPUserName: string;
    procedure GetData(cds: TClientDataSet; SQL: string);
    procedure GetGeneralData(SQL: string);
    function GetDataString(SQL: String): String;
    function GetDataInteger(SQL: String): Integer;
    procedure ExecuteSQL(SQL: string);

    procedure LogMessage(S: string);
  end;

var
  dmMain: TdmMain;
const
  PRODUCTNAME='StaffMaint';

implementation

{$R *.dfm}

procedure TdmMain.DataModuleCreate(Sender: TObject);
var
  Inifile :TIniFile;
  PPos, i : integer;
  Param1, ConStr, ConStrEx, WeekStr, KeyStr, AStr, Pwd, FExepath: String;
begin
  if dbConn.Connected then
  begin
    MessageDlg('Close Connection before Distribution',mtInformation,[mbOK],0);
  end;

  dbConn.Close;
  ConStr := 'Acclaim';
  ConStrEx := '';

  fDebug := False;
  fToFile := False;
  PPos := Pos('\', ReverseString(ParamStr(0)));
  FExePath := Copy(ParamStr(0), 1, Length(ParamStr(0)) - PPos + 1);  for i:= 1 to ParamCount do
  begin
    if (UpperCase(ParamStr(i)) = 'DEBUG') then
      fDebug := True
    else if (UpperCase(ParamStr(i)) = 'FILE') then
    begin
      fToFile := True;
      jvFile.FileName := PRODUCTNAME+'.log';
      jvFile.AutoSave := True;
    end
    else if (UpperCase(Copy(ParamStr(i),1,3)) = '/C=') then           // Alternative Connection
      ConStrEx := Copy(ParamStr(i),4,Length(ParamStr(i))-3);
  end;

  try
    dbConn.Close;
    if (not FileExists(FExepath+'AcclaimConnection.ini')) then
      MessageDlg('AcclaimConnection.ini not found',mtInformation,[mbOK],0);
    IniFile:=TIniFile.Create(fExePath+'AcclaimConnection.ini');
    LogMessage('DMain create - Get Connection String');
    ConStr := ConStr + ConStrEx;
    AStr := IniFile.ReadString('Connections',ConStr,'');
    LogMessage('Constr ['+Astr+']');
    KeyStr:='Password';
    Pwd := IniFile.ReadString('Connections',KeyStr,'');
    if Pwd <> '' then
    begin
      jvCipher.Key := 'AcclaimGroup';
      jvCipher.Decoded := Pwd;
      Pwd := jvCipher.Encoded;
      if pos('[Password]',AStr) > 0 then
      begin
        Astr := stringreplace(Astr,'[Password]',pwd,[rfReplaceAll, rfIgnoreCase]);
      end;
    end;
    dbConn.ConnectionString := AStr;        // Incase we don't use the password

    WeekStr := UpperCase(IniFile.ReadString('Settings','Weekly','False'));
    fWeekly := (WeekStr='TRUE');
    fClientName:=IniFile.ReadString('Settings','ClientName','');
    fReportName:=IniFile.ReadString('Settings','ReportName','');
    fRptInvName:=IniFile.ReadString('Settings','InvoiceReport','rptInvoice');
    fRptStateName:=IniFile.ReadString('Settings','StatementReport','rptStatement');
    fSMTPHost:=IniFile.ReadString('SMTP','Host','');
    fSMTPUserName:=IniFile.ReadString('SMTP','UserName','');
    fSMTPfromName:=IniFile.ReadString('SMTP','FromName','');
    fSMTPfromAddress:=IniFile.ReadString('SMTP','FromAddress','');
    if dbConn.Connected then
    begin
      MessageDlg('Close Connection before Distribution',mtInformation,[mbOK],0);
      //Halt;
    end;
    try
      dbConn.Connected := True;
    except
      MessageDlg('Cannot connect to Database'+#13+dbConn.ConnectionString,mtError,[mbOK],0);
      Halt;
    end;
  except
    MessageDlg('Error connecting to Database'+#13+dbConn.ConnectionString,mtError,[mbOK],0);
    Halt;
  end;
  if Trim(fReportName) <> '' then
  begin

  end;
end;
//===============================================================================
procedure TdmMain.GetData(cds: TClientDataSet; SQL: String);
begin
  cds.Close;
  if cds.ProviderName = '' then
    cds.ProviderName := 'dspConn';
  qryConn.SQL.Text := SQL;
  cds.Open;
end;

procedure TdmMain.GetGeneralData(SQL: string);
begin
  GetData(cdsGeneral, SQL);
end;

function TdmMain.GetDataString(SQL: String): string;
begin
  qryConn.Close;
  qryConn.SQL.Text := SQL;
  qryConn.Open;
  Result := qryConn.Fields[0].AsString;
end;

function TdmMain.GetDataInteger(SQL: String): integer;
begin
  qryConn.Close;
  qryConn.SQL.Text := SQL;
  qryConn.Open;
  Result := qryConn.Fields[0].AsInteger;
end;

procedure  TdmMain.ExecuteSQL(SQL: string);
begin
  qryConn.Close;
  qryConn.SQL.Text := SQL;
  qryConn.ExecSQL;
end;

function TdmMain.GetProfile(Profile: string): string;
begin
  GetGeneralData('SELECT PF.DEFAULTVALUE, PV.FIELDVALUE ' +
    'FROM PROFILE_FIELDS PF ' +
    'LEFT JOIN PROFILE_VALUES PV ON (PF.FIELDNAME = PV.FIELDNAME) ' +
    'WHERE UPPER(PF.FIELDNAME)=UPPER(' + QuotedStr(Profile) + ')');

  if cdsGeneral.FieldByName('FIELDVALUE').IsNull then
    Result := cdsGeneral.FieldByName('DEFAULTVALUE').AsString
  else
    Result := cdsGeneral.FieldByName('FIELDVALUE').AsString;
end;

procedure TdmMain.SetupReport(ReportName, Title, ParamList: string);
var
  RPath: string;
  I: Integer;
begin
  RPath := dmMain.GetProfile('CUSTOMFMTPATH');
  frxReport.LoadFromFile(RPath + ReportName + '.fr3');
  frxReport.Variables['ParamList'] := QuotedStr(ParamList);
  frxReport.Variables['Title'] := QuotedStr(Title);
  for I := 0 to length(ReportParam) - 1 do
    frxReport.Variables[ReportParam[i][0]] := ReportParam[i][1];
end;

procedure TdmMain.PrintPreview(ReportName, Title, ParamList: string; PP: Integer; IsModal: Boolean);
var
  Category, Plist: TfrxVariable;
begin
  SetupReport(ReportName, Title, ParamList);
  if PP = 1 then
  begin
    //with TfrxReport.Create(Self) do ShowReport(True);
    frxReport.PreviewOptions.Modal := IsModal;
    frxReport.ShowReport(False);
  end
  else
  begin
    frxReport.PrepareReport(True);
    frxReport.Print;
  end;

    //RvSystem.DoNativeOutput := False;
    //RvSystem.OutputFileName := '*.pdf';
    //RvSystem.RenderObject := RvRenderPDF;
//    RvSystem.SystemSetups := dmPrint.RvSystem.SystemSetups - [ssAllowSetup];
//    RvSystem.DefaultDest := rdPreview;
//    RvSystem.ReportDest := rdPreview;
//  end
//  else
//  begin
//    RvSystem.RenderObject := RvRenderPrinter;
//    RvSystem.ReportDest := rdPrinter;
//    RvSystem.DoNativeOutput := True;
    //RvSystem.DoNativeOutput := False;
//    RvSystem.OutputFileName := '';
//    RvSystem.RenderObject := nil;

//    RvSystem.DefaultDest := rdPrinter;
//    RvSystem.SystemSetups := dmPrint.RvSystem.SystemSetups - [ssAllowSetup];
//  end;
  ProjectExecute;
end;

procedure TdmMain.ProjectExecute;
var
  i: integer;
  Previewing: Boolean;
begin
  Previewing := False;
  for i := 0 to Screen.FormCount-1 do
    if Screen.Forms[i].Visible then
      if Screen.Forms[i].Caption = 'Report Preview' then
        Previewing := True;
//  if not Previewing then
//    RvProject.Execute                      // This does the "print" according to the parameters that were setup earlier.
//  else
//    MessageDlg('Another report is being previewed'+#13+'You cannot preview 2 reports simultaneously',mtWarning, [mbOK],0);
end;

procedure TdmMain.LogMessage(S: string);
begin
  if fDebug then
  begin
    if fToFile then
      jvFile.add(FormatDateTime('yyyy-mm-dd hh:nn:ss',Now),'',lesInformation,S)
      //idsLogFile.write(S)
    else
      ShowMessage(S);
  end;
end;

end.