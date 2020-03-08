unit fMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,  DB, ADODB, ToolWin, ActnMan, ActnCtrls, ActnList,
  XPStyleActnCtrls, StdCtrls, IniFiles, {Encrypt,} Buttons,StrUtils,
  ComCtrls, JvBaseDlg, JvSelectDirectory, JvComponentBase, JvCipher;

type
  TfrmMain = class(TForm)
    ActionManager1: TActionManager;
    actCheck: TAction;
    dbConn: TADOConnection;
    actTestSaved: TAction;
    PageControl1: TPageControl;
    tsConnection: TTabSheet;
    tsEncryption: TTabSheet;
    gbNewConn: TGroupBox;
    Label21: TLabel;
    Label20: TLabel;
    Label19: TLabel;
    Label18: TLabel;
    edtPassword: TEdit;
    edtLogin: TEdit;
    edtDatabase: TEdit;
    edtServer: TEdit;
    LblConn: TLabel;
    SpeedButton1: TSpeedButton;
    Label5: TLabel;
    btnNewconn: TButton;
    edtPath: TEdit;
    ActionToolBar1: TActionToolBar;
    edtKey: TEdit;
    edtEncrypted: TEdit;
    edtText: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    btnEncrypt: TButton;
    btnDecrypt: TButton;
    LblText: TLabel;
    StatusBar1: TStatusBar;
    LblIni: TLabel;
    PathDialog1: TJvSelectDirectory;
    jvEncrypt: TJvVigenereCipher;
    actGetConnection: TAction;
    edtConnStr: TEdit;
    Label4: TLabel;
    edtConnName: TEdit;
    procedure actCheckExecute(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actTestSavedExecute(Sender: TObject);
    procedure btnEncryptClick(Sender: TObject);
    procedure btnDecryptClick(Sender: TObject);
    procedure actGetConnectionExecute(Sender: TObject);
    procedure edtConnNameChange(Sender: TObject);
  private
    { Private declarations }
    FIniName :String;
    fConnStr: String;
    fConnName: String;
    function CheckConnection: Boolean;
    procedure SaveConnIni(ConnStr, Pwd: String);
    function TestSavedConnection(GetOnly: Boolean): Boolean;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

const     KeyStr = 'Password';
implementation

{$R *.dfm}

procedure TfrmMain.actCheckExecute(Sender: TObject);
var
  Pwd: String;
begin
  if CheckConnection then
  begin
    Pwd := jvEncrypt.EncodeString(KeyStr, edtPassword.Text);
    if MessageDlg('Connected to database - save this connection string to INI file?',mtConfirmation,[mbYes,mbNo],0) = mrYes then
    begin
      SaveConnIni(fConnStr, Pwd);
      Statusbar1.Panels[0].Text := 'Connection string saved to Ini File';
    end;
    //MessageDlg('Connection string saved to Ini File',mtInformation,[mbOK],0);
  end;
  
end;

procedure TfrmMain.SaveConnIni(ConnStr, Pwd: String);
var
  Inifile : TIniFile;
begin
  try
    IniFile:=TIniFile.Create(edtPath.Text+'\'+FIniName);
    IniFile.WriteString('Connections',fConnName,fConnStr);
    IniFile.WriteString('Connections','Password',Pwd);
  finally
    IniFile.Free;
  end;
end;

procedure TfrmMain.SpeedButton1Click(Sender: TObject);
begin
  if PathDialog1.Execute then
    edtPath.Text := PathDialog1.Directory;
end;

procedure TfrmMain.actGetConnectionExecute(Sender: TObject);
begin
  TestSavedConnection(True);
end;

procedure TfrmMain.actTestSavedExecute(Sender: TObject);
begin
  if TestSavedConnection(False) then
    Statusbar1.panels[0].text := 'Connection Successful'
  else
    Statusbar1.panels[0].text := 'Connection Error';
  //  MessageDlg('Error in Connection',mtError,[mbOK],0);
end;

procedure TfrmMain.btnDecryptClick(Sender: TObject);
begin
  LblText.caption := jvEncrypt.DecodeString(edtKey.Text, edtEncrypted.Text);
  if edtText.Text <> LblText.Caption then
    MessageDlg('Encryption / Decryption error',mtError,[mbOK],0);
end;

procedure TfrmMain.btnEncryptClick(Sender: TObject);
begin
  edtEncrypted.Text := jvEncrypt.EncodeString(edtkey.Text, edtText.Text);
end;

function TfrmMain.CheckConnection: Boolean;
var
  {KeyStr,} Pwd: string;
  PPos: Integer;
  AStr : array[1..3] of string;
  i: integer;
begin
  Result := False;
  dbconn.Connected := False;
  StatusBar1.Panels[0].Text := '';
  if not gbNewConn.Visible then
    Close
  else
  begin
    if (edtServer.Text = '') then
    begin
      edtServer.SetFocus;
      StatusBar1.Panels[0].Text := 'Server data required';
      Exit;
    end;
    if (edtDatabase.Text = '') then
    begin
      edtDatabase.SetFocus;
      StatusBar1.Panels[0].Text := 'Database data required';
      Exit;
    end;
    if (edtLogin.Text = '') then
    begin
      edtLogin.SetFocus;
      StatusBar1.Panels[0].Text := 'Login name data required';
      Exit;
    end;
    Result := False;
    AStr[1] := 'Provider=SQLOLEDB.1;Password=[Password];Persist Security Info=True;User ID=[USERID];Initial Catalog=[DATABASE];Data Source=[SERVER]';
    AStr[2] := 'Provider=SQLNCLI.1;Password=[Password];Persist Security Info=True;User ID=[USERID];Initial Catalog=[DATABASE];Data Source=[SERVER]';
    AStr[3] := 'Provider=MSDASQL;Driver={SQL Server};Database=[DATABASE];Server=[SERVER];UID=[USERID];PWD=[Password]';
    for i := 1 to 3 do
    begin
      if not Result then
      begin
        PPos := pos('[USERID]', AStr[i]);
        AStr[i] := Copy(AStr[i], 1, PPos-1)+edtLogin.Text+Copy(AStr[i], PPos+8,length(AStr[i])-PPos-7);
        PPos := pos('[DATABASE]', AStr[i]);
        AStr[i] := Copy(AStr[i], 1, PPos-1)+edtDatabase.Text+Copy(AStr[i], PPos+10,length(AStr[i])-PPos-9);
        PPos := pos('[SERVER]', AStr[i]);
        AStr[i] := Copy(AStr[i], 1, PPos-1)+edtServer.Text+Copy(AStr[i], PPos+8,length(AStr[i])-PPos-7);
        fConnStr := AStr[i];
        //KeyStr := 'Password';
        PPos := pos('['+KeyStr+']', AStr[i]);
        AStr[i] := Copy(AStr[i], 1, PPos-1)+edtPassword.Text+Copy(AStr[i], PPos+10,length(AStr[i])-PPos-9);
        dbConn.ConnectionString := AStr[i];
        try
          dbConn.Connected := True;
          StatusBar1.Panels[0].Text := 'Connection Successful';
          MessageDlg('Connection Successful', mtInformation,[mbOK],0);
          Result := True;
        except
          on E:Exception do
          begin
            MessageDlg(E.Message+#13+AStr[i],mtError,[mbOK],0);
            Result := False;
          end;
        end;
      end;
    end;
  end;
end;

procedure TfrmMain.edtConnNameChange(Sender: TObject);
begin
  fConnName := edtConnName.Text;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  if ParamCount >= 1 then
    FIniName := ParamStr(1)
  else
    FIniName := 'AcclaimConnection.ini';
  LblIni.Caption := 'Ini File: '+FIniName;
end;

procedure TfrmMain.FormShow(Sender: TObject);
var
  TempStr: string;
  i : Integer;
begin
  edtConnName.Text := 'Acclaim';
  if ParamCount >= 0 then
  begin
    TempStr := ReverseString(ParamStr(0));
    if pos('\',TempStr) > 0 then
      i := pos('\',TempStr);
      TempStr := Copy(TempStr,i,Length(TempStr)-i+1);
    edtPath.Text := ReverseString(TempStr);
  end;
end;

function TfrmMain.TestSavedConnection(GetOnly: Boolean): Boolean;
var
  Inifile : TIniFile;
  AStr, {KeyStr,} Pwd: String;
  PPos: Integer;
begin
  try
    Result := False;
    IniFile:=TIniFile.Create(edtPath.Text+'\'+FIniName);
    // Password Encryption added so that we can add this in at any time required
    // Change the ini file Connection Str to have [Password] in the Password= part and
    // add Password=Encrypted(Password) in line below - see local ini file
    dbConn.Connected := False;
    AStr := IniFile.ReadString('Connections',fConnName,'');
    dbConn.ConnectionString := AStr;
    //KeyStr := 'Password';
    Pwd := IniFile.ReadString('Connections', KeyStr,'');
    if Pwd <> '' then
    begin
      Pwd := jvEncrypt.DecodeString(KeyStr,Pwd);
      if pos('['+KeyStr+']',AStr) > 0 then
      begin
        PPos := pos('['+KeyStr+']', AStr);
        AStr := Copy(AStr, 1, PPos-1)+Pwd+Copy(AStr, PPos+10,length(AStr)-PPos-9);
        dbConn.ConnectionString := AStr;
      end;
    end;
    if GetOnly then
    begin
      edtConnStr.Text := AStr;
      Result := False;
    end
    else
      try
        dbConn.Connected := True;
        Result := true;
        dbConn.Connected := False;
      except
        Result := False;
      end;
  finally
    IniFile.Free;
  end;
end;

end.