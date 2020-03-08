unit dConn;

interface

uses
  SysUtils, Classes, IniFiles, DB, ADODB, Dialogs, ImgList, Controls,
  Provider, DBClient, frxClass, frxDBSet, frxExportCSV,
  frxExportPDF, frxVariables, vcl.Forms, StrUtils, AccLib, System.ImageList;

type
  TdmConn = class(TDataModule)
    dbConn: TADOConnection;
    ImageList: TImageList;
    dspConn: TDataSetProvider;
    qryConn: TADOQuery;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    fDebug: Boolean;
    fToFile: Boolean;
    procedure GetData(cds: TClientDataSet; SQL: string); overload;
    procedure GetData(var Value: String; SQL: string); overload;
    procedure GetData(var Value: Integer; SQL: string); overload;
    procedure GetData(var Value: Double; SQL: string); overload;
    procedure GetData(var Value: TDateTime; SQL: string); overload;
    {Exo specific functions}
    function GetProfile(Profile: string): string;

    procedure ExecuteSQL(SQL: string);

    procedure LogMessage(S: string);
  end;

var
  dmConn: TdmConn;


implementation

{$R *.dfm}

procedure TdmConn.DataModuleCreate(Sender: TObject);
var
  Inifile :TIniFile;
  PPos, i : integer;
  Param1, ConStr, ConStrEx, {WeekStr,} KeyStr, AStr, Pwd, FExepath: String;
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
    {
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
    }
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
end;
//===============================================================================

procedure TdmConn.GetData(cds: TClientDataSet; SQL: String);
begin
  cds.Close;
  if cds.ProviderName = '' then
    cds.ProviderName := 'dspConn';
  qryConn.SQL.Text := SQL;
  cds.Open;
end;

procedure TdmConn.GetData(var Value: string; SQL: String);
begin
  qryConn.Close;
  qryConn.SQL.Text := SQL;
  qryConn.Open;
  Value := qryConn.Fields[0].AsString;
end;

procedure TdmConn.GetData(var Value: Integer; SQL: string);
begin
  qryConn.Close;
  qryConn.SQL.Text := SQL;
  qryConn.Open;
  Value := qryConn.Fields[0].AsInteger;
end;

procedure TdmConn.GetData(var Value: Double; SQL: string);
begin
  qryConn.Close;
  qryConn.SQL.Text := SQL;
  qryConn.Open;
  Value := qryConn.Fields[0].AsFloat;
end;

procedure TdmConn.GetData(var Value: TDateTime; SQL: string);
begin
  qryConn.Close;
  qryConn.SQL.Text := SQL;
  qryConn.Open;
  Value := qryConn.Fields[0].AsDateTime;
end;
(*
function TdmMain.GetDataInteger(SQL: String): integer;
begin
  qryConn.Close;
  qryConn.SQL.Text := SQL;
  qryConn.Open;
  Result := qryConn.Fields[0].AsInteger;
end;

function TdmMain.GetDataString(SQL: String): string;
begin
  qryConn.Close;
  qryConn.SQL.Text := SQL;
  qryConn.Open;
  Result := qryConn.Fields[0].AsString;
end;
*)
procedure  TdmConn.ExecuteSQL(SQL: string);
begin
  qryConn.Close;
  qryConn.SQL.Text := SQL;
  qryConn.ExecSQL;
end;

function TdmConn.GetProfile(Profile: string): string;
var
  cds: TClientDataSet;
begin
  try
    cds := TClientDataSet.Create(Self);
    GetData(cds, 'SELECT PF.DEFAULTVALUE, PV.FIELDVALUE ' +
      'FROM PROFILE_FIELDS PF ' +
      'LEFT JOIN PROFILE_VALUES PV ON (PF.FIELDNAME = PV.FIELDNAME) ' +
      'WHERE UPPER(PF.FIELDNAME)=UPPER(' + QuotedStr(Profile) + ')');

    if cds.FieldByName('FIELDVALUE').IsNull then
      Result := cds.FieldByName('DEFAULTVALUE').AsString
    else
      Result := cds.FieldByName('FIELDVALUE').AsString;
  finally
    cds.Free;
  end;
end;

{ Log File}
procedure TdmConn.LogMessage(S: string);
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
