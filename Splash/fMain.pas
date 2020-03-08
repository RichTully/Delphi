unit fMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP, DB, ADODB, ComCtrls;

type
  TfrmMain = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    IdHTTP1: TIdHTTP;
    Memo1: TMemo;
    Button2: TButton;
    ADOConnection1: TADOConnection;
    qryGen: TADOQuery;
    btnIntegrated: TButton;
    edtOrd: TEdit;
    cbInt: TComboBox;
    StatusBar1: TStatusBar;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure btnIntegratedClick(Sender: TObject);
    procedure IdHTTP1Status(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: string);
  private
    { Private declarations }
    fAddress: string;
    function GetRecord(var RemStr, RecStr: string; id: string): Boolean;
    procedure CheckOrders;
    function GetVal(AStr, id: string): string;
    function UpdateOrder(ONo, tf: string): Boolean;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  try
    CheckOrders;
  finally
    idHTTP1.Disconnect;
  end;
end;

procedure TfrmMain.Button2Click(Sender: TObject);
var
  address, Resp, RemResp, RecResp, txt: string;

begin
  qryGen.SQL.Text := 'Select AccNo, Alphacode, Name From DR_Accs order by AccNo';
  qryGen.Open;
  while not qryGen.Eof do
  begin
    address := fAddress+'?typ=1&table=Customer&srchstr=username&srchval='+qryGen.FieldByName('AlphaCode').AsString;       // this creates Order+Orderline?integrated=false
    Resp := idHTTP1.Get(address);
    //Memo1.Lines.Add(Resp);
    RemResp := Resp;
    while GetRecord(RemResp, RecResp,'Customer') do
    begin
      //Memo1.Lines.Add('=================================');
      Memo1.Lines.Add(qryGen.FieldByName('AccNo').AsString);//+' '+qryGen.FieldByName('AlphaCode').AsString+' '+qryGen.FieldByName('Name').AsString);
      //txt := GetVal(RecResp, 'username');
      //txt := GetVal(RecResp, 'b_company');
      //txt := GetVal(RecResp, 'company');
      //txt := GetVal(RecResp, 'dealer');
      //txt := GetVal(RecResp, 'email');
      //Memo1.Lines.Add('---------------------------------');
    end;
    qryGen.Next;
  end;
end;

procedure TfrmMain.btnIntegratedClick(Sender: TObject);
begin
 //WriteIf('********* Setting orders 854 855 as not integreated !!!!!!!!!');
  if UpdateOrder(edtOrd.Text,cbInt.Text) then
    Memo1.Lines.Add(edtOrd.Text + ' updated - integrated='+cbInt.Text)
  else
    Memo1.Lines.Add(edtOrd.Text + ' error integrated not set');
end;

function TfrmMain.UpdateOrder(ONo, tf: string): Boolean;
var
  PParam: TStringList;
  address, Resp: string;
begin
  Result := False;
  address := fAddress+'?typ=4';              // This update Order - integrated
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

procedure TfrmMain.CheckOrders;
var
  address, Resp, RemResp, RecResp, OrdTxt, LineTxt: string;
  SQL, txt, Otxt: string;
begin
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
    memo1.Lines.Clear;
    address := fAddress+'?typ=1&table=Order';       // this creates Order+Orderline?integrated=false
    try
      Resp := idHTTP1.Get(address);
    except
      idHTTP1.Disconnect;
      Memo1.Lines.Add('GET Error');
      Exit;
    end;
    RemResp := Resp;
    Memo1.Lines.Add('------- Start Data -------');
    while GetRecord(RemResp, RecResp,'Order') do
    begin
      OrdTxt := RecResp;
      while GetRecord(OrdTxt, LineTxt, 'OrderLine') do
      begin
         Memo1.Lines.Add('-----------------------');
         txt:= GetVal(LineTxt, 'code');
         txt:= GetVal(LineTxt, 'price');
         txt:= GetVal(LineTxt, 'quantity');
         txt:= GetVal(LineTxt, 'sku');
         txt:= GetVal(LineTxt, 'subtotal');
         txt:= GetVal(LineTxt, 'subtotal_numeric');

      end;
      Memo1.Lines.Add('=======================');
      txt := GetVal(OrdTxt, 'currency_code');
      txt := GetVal(OrdTxt, 'email');
      Otxt:= GetVal(OrdTxt, 'order_number');
      txt := GetVal(OrdTxt, 'salestax');
      txt := GetVal(OrdTxt, 'subtotal');
      txt := GetVal(OrdTxt, 'total_cost');
      txt := GetVal(OrdTxt, 'username');
      Memo1.Lines.Add('=======================');
      // Process the order
      // Update the web

      //UpdateOrder(Otxt,'true');
    end;
    Memo1.Lines.Add('------- End Data -------');

end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  fAddress := 'http://galaxi.co.nz/WebSplash.php';
  ADOConnection1.ConnectionString :=
  'Provider=SQLOLEDB.1;Password=masterkey;Persist Security Info=True;User ID=sa;Initial Catalog=Splash;Data Source=PC-Server';
//  'Provider=SQLNCLI.1;Password=masterkey;Persist Security Info=True;User ID=sa;Initial Catalog=Splash;Data Source=Bob\SQL2008R2';
end;

function TfrmMain.GetRecord(var RemStr: string; var RecStr: string; id: string): Boolean;
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

function TfrmMain.GetVal(AStr, id:string): string;
var
  SStart, SLen: integer;
begin
  SStart := pos('<'+id+'>',AStr) + Length(id) + 2;
  SLen := pos('</'+id+'>',AStr) - SStart;
  Result := Copy(AStr, SStart, SLen);
  Memo1.Lines.Add(id+' : '+Result);
end;



procedure TfrmMain.IdHTTP1Status(ASender: TObject; const AStatus: TIdStatus;
  const AStatusText: string);
begin
  StatusBar1.Panels[0].Text := AStatusText;
  Memo1.Lines.Add('Status ['+AStatusText+']');
  Application.ProcessMessages;
end;

end.
