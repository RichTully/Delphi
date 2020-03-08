unit fMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase, IdSMTP, IdText,
  IdMessage, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL,
  IdSSLOpenSSL, ExtCtrls, IdSSLOpenSSLHeaders;

type
  TfrmMain = class(TForm)
    SMTP1: TIdSMTP;
    edthost: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    edtuser: TEdit;
    Label3: TLabel;
    edtPort: TEdit;
    Label4: TLabel;
    edtto: TEdit;
    Label5: TLabel;
    edtFrom: TEdit;
    btnSend: TButton;
    edtSubj: TEdit;
    Label6: TLabel;
    mmoBody: TMemo;
    Label7: TLabel;
    SMTPMsg: TIdMessage;
    edtPass: TEdit;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    Timer1: TTimer;
    LblTmr: TLabel;
    procedure btnSendClick(Sender: TObject);
    procedure SMTP1Status(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: string);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure IdSSLIOHandlerSocketOpenSSL1StatusInfo(const AMsg: string);
    procedure SMTP1Connected(Sender: TObject);
    procedure SMTP1Disconnected(Sender: TObject);
    procedure SMTP1FailedRecipient(Sender: TObject; const AAddress, ACode,
      AText: string; var VContinue: Boolean);
    procedure SMTP1TLSNotAvailable(Asender: TObject; var VContinue: Boolean);
    procedure SMTP1Work(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCount: Int64);
    procedure SMTP1WorkBegin(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCountMax: Int64);
    procedure SMTP1WorkEnd(ASender: TObject; AWorkMode: TWorkMode);
    procedure IdSSLIOHandlerSocketOpenSSL1Status(ASender: TObject;
      const AStatus: TIdStatus; const AStatusText: string);
    procedure IdSSLIOHandlerSocketOpenSSL1StatusInfoEx(ASender: TObject;
      const AsslSocket: PSSL; const AWhere, Aret: Integer; const AType,
      AMsg: string);
    function IdSSLIOHandlerSocketOpenSSL1VerifyPeer(Certificate: TIdX509;
      AOk: Boolean; ADepth, AError: Integer): Boolean;
    procedure IdSSLIOHandlerSocketOpenSSL1GetPassword(var Password: string);
    procedure IdSSLIOHandlerSocketOpenSSL1GetPasswordEx(ASender: TObject;
      var VPassword: string; const AIsWrite: Boolean);
  private
    fHeight: Integer;
    fWidth: Integer;
    fTmr: Integer;
    { Private declarations }
    procedure SendAttachment(ABody: string);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}
Uses Math;

procedure TfrmMain.btnSendClick(Sender: TObject);
var
  ABody: TStringList;
begin
  with SMTP1 do
  begin
    Host := edtHost.Text;
    Username := edtUser.Text;
    Port := StrtoInt(edtPort.Text);
    Password := edtPass.Text;
  end;
  IdSSLIOHandlerSocketOpenSSL1.Port := SMTP1.Port;
  IdSSLIOHandlerSocketOpenSSL1.Host := SMTP1.Host;
  try
    Screen.Cursor := crHourGlass;
    with SMTPMsg do
    begin
      Clear;
      From.Address:= edtFrom.Text;
      From.Name :=edtFrom.Text;
      Recipients.EMailAddresses := edtTo.Text;
      Subject := edtSubj.Text;
    end;
    //----------------------------
    try
      ABody := TStringList.Create;
      //ABody.Clear;
      ABody.Add('<BODY>');
      ABody.Add('<div style="width:750px;padding:10px 0 0 30px;background:#f5f9fc;float:left;" >');
      ABody.Add('<p style="color:#4179b8;font-size:20px;padding:10px;float:left;" >');
      ABody.Add('<b>AshAir    Debtor Account 314-ASH AIR WORKSHOP - AUCKLAND</b>');
      ABody.Add('</p>');
      ABody.Add('<p style="color:#4179b8;font-size:16px;padding:10px;margin:0;float:left;" >');
      ABody.Add('AshAir    Schedule your next service date');
      ABody.Add('</p>');
      ABody.Add('<p style="font-size:16px;padding:10px;line-height:20px;float:left;" >');
      ABody.Add('This is an automated email from Ash Air (NZ) Ltd online system.'+
  'During the month of March, you have compressors or compressed air equipment that is due for servicing.'+
  'You can set up a service date at your convenience.'+
  'To set up your next service date click on the link below');
      ABody.Add('</p>');
      ABody.Add('<a href="http://www.acclaimdev.com/AshAirBk/BookSUService.php?BUser=59m1f4UeSlLWRE2" target="_blanck" >');
      ABody.Add('<div style="text-align:center;text-decoration:none;width:120px;background:#37679b;color:white;font-size:18px;padding:10px 20px 10px 20px;float:left;border-radius:5px;" >');
      ABody.Add('Click here');
      ABody.Add('</div>');
      ABody.Add('</a>');
      ABody.Add('<p style="width:100%;font-size:16px;padding:10px;float:left;" >');
      ABody.Add('Or contact the service dept directly on 09 444 8486 and email@ashair.co.nz');
      ABody.Add('</p>');
      ABody.Add('</div>');
      ABody.Add('</BODY>');
      //----------------------------
      SendAttachment(ABody.Text);
      MessageDlg('File emailed successfully',mtInformation,[mbOK],0);
    finally
      Abody.Free;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
{  fHeight := Height;
  fWidth := Width;}
end;

procedure TfrmMain.FormResize(Sender: TObject);
var
  Ratio: double;
begin
{
  Ratio := Min(ClientWidth/ fWidth , ClientHeight /fHeight);
  ScaleBy(Trunc(Ratio * 100), 100);}
end;

procedure TfrmMain.IdSSLIOHandlerSocketOpenSSL1GetPassword(
  var Password: string);
begin
  showmessage('Handler Get pwd');
end;

procedure TfrmMain.IdSSLIOHandlerSocketOpenSSL1GetPasswordEx(ASender: TObject;
  var VPassword: string; const AIsWrite: Boolean);
begin
  showmessage('Handler Get pwd ex');
end;

procedure TfrmMain.IdSSLIOHandlerSocketOpenSSL1Status(ASender: TObject;
  const AStatus: TIdStatus; const AStatusText: string);
begin
  showmessage('Handler '+AStatusText);
end;

procedure TfrmMain.IdSSLIOHandlerSocketOpenSSL1StatusInfo(const AMsg: string);
begin
  ShowMessage(AMsg);
end;

procedure TfrmMain.IdSSLIOHandlerSocketOpenSSL1StatusInfoEx(ASender: TObject;
  const AsslSocket: PSSL; const AWhere, Aret: Integer; const AType,
  AMsg: string);
begin
  showmessage('Handler Info Ex '+AMsg);
end;

function TfrmMain.IdSSLIOHandlerSocketOpenSSL1VerifyPeer(Certificate: TIdX509;
  AOk: Boolean; ADepth, AError: Integer): Boolean;
begin
  showmessage('Handler verify peer');
end;

procedure TfrmMain.SendAttachment(ABody: string);
var
  idTxtpart: TIdText;
begin
  with SMTPMsg do
  begin
    ContentType := 'Multipart/mixed';
    idTxtPart:=TIdText.Create(SMTPMsg.MessageParts,nil);
    //idTxtPart.ContentType:='text/plain';
    idTxtPart.ContentType:='text/html';
    idTxtPart.Body.Clear;

    idTxtPart.Body.Add(ABody);
  end;
  with SMTP1 do
  begin
    try
      if not Connected then
        Connect;
      //if MessageDlg('Send email to '+SMTP1.PostMessage.ToAddress[0], mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      Send(SMTPMsg);
    finally
      Disconnect;
    end;
  end;
end;


procedure TfrmMain.SMTP1Connected(Sender: TObject);
begin
  Showmessage('Connected');
end;

procedure TfrmMain.SMTP1Disconnected(Sender: TObject);
begin
  Showmessage('DisConnected');

end;

procedure TfrmMain.SMTP1FailedRecipient(Sender: TObject; const AAddress, ACode,
  AText: string; var VContinue: Boolean);
begin
  Showmessage(AAddress+' | '+ACode+' | '+AText);
end;

procedure TfrmMain.SMTP1Status(ASender: TObject; const AStatus: TIdStatus;
  const AStatusText: string);
begin
  ShowMessage(AStatusText);
end;

procedure TfrmMain.SMTP1TLSNotAvailable(Asender: TObject;
  var VContinue: Boolean);
begin
  showmessage('TLS not available');
end;

procedure TfrmMain.SMTP1Work(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
begin
  showmessage('Work');
end;

procedure TfrmMain.SMTP1WorkBegin(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCountMax: Int64);
begin
  showmessage('Work begin');

end;

procedure TfrmMain.SMTP1WorkEnd(ASender: TObject; AWorkMode: TWorkMode);
begin
  showmessage('Work end');

end;

procedure TfrmMain.Timer1Timer(Sender: TObject);
begin
(*
  inc(fTmr);
  LblTmr.Caption := IntToStr(fTmr);
  if fTmr > 60 then
    Close;
*)
end;

end.