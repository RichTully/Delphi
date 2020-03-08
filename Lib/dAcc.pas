unit dAcc;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB;

type
  TdmAcc = class(TDataModule)
    dbConn: TADOConnection;
  private
    FConnStr: String;
    procedure SetConnStr(const Value: String);
    procedure Setup(FileName: String);
    { Private declarations }
  public
    { Public declarations }
    property ConnStr: String  read FConnStr write SetConnStr;
    function GetValue: integer;
  end;

var
  dmAcc: TdmAcc;

procedure Setup(FileName: String);
procedure SetAccConn(AStr: String);
function GetConnStr: String;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmAcc }
procedure TdmAcc.Setup(FileName: String);
begin
(*  if dbConn.Connected then
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
*)
end;

function TdmAcc.GetValue: integer;
begin
  Result := 5;
end;

procedure TdmAcc.SetConnStr(const Value: String);
begin
  FConnStr := Value;
end;

{ functions }

procedure Setup(FileName: String);
begin
  dmAcc.Setup(FileName);
end;

procedure SetAccConn(AStr: String);
begin
  dmAcc.ConnStr := AStr;
end;

function GetConnStr: String;
begin
  Result := dmAcc.ConnStr;
end;
end.
