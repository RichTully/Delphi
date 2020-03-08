unit fMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, XML.xmldom,
  Xml.XMLIntf, Xml.XMLDoc;

type
  TGoogleAuth = class
    private
      FAuthString: string;
      FGoogleEmail: string;
      FGooglePwd: string;
      FAccountType: string;
      FServiceName: String;
      FReqTime: TDateTime;
      procedure SetAuthString(const Value: string);
      procedure SetReqTime(const Value: TDateTime);
      function GetAuthString: string;
      procedure SetGoogleEmail(const Value: string);
      procedure SetGooglePwd(const Value: string);
      procedure SetAccountType(const Value: string);
      procedure SetServiceName(const Value: string);
    public
      property GoogleEmail: string read FGoogleEmail write SetGoogleEmail;
      property GooglePwd: string read FGooglePwd write SetGooglePwd ;
      property AuthString: string read GetAuthString write SetAuthString;
      property ReqTime:TDateTime read FReqTime write SetReqTime;
      //property ServiceName read FServiceName write SetServiceName;
      property AccountType: string read FAccountType write SetAccountType;
      function Expired: boolean;
      Procedure Renew;
  end;

type
  TfrmMain = class(TForm)
    btnSheet: TButton;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    XMLDocument1: TXMLDocument;
    ListBox1: TListBox;
    procedure btnSheetClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;



var
  frmMain: TfrmMain;
  GoogleAuth: TGoogleAuth;

implementation

{$R *.dfm}
function TGoogleAuth.Expired: boolean;
begin

end;

function TGoogleAuth.GetAuthString: string;
begin
  if FAuthString = '' then
    Renew;
  if Expired then
    Renew;
  Result := fAuthString;
end;

procedure TGoogleAuth.Renew;
var
  res, req: string;
  sList: TStringList;
  IdHttp: TIdHttp;
  SslHandler: TIdSSLIOHandlerSocketOpenSSL;
begin
  fAuthString := '';
  IdHttp := TIdHttp.Create(nil);
  try
    SslHandler := SslHandler;
    try
      req:='https://www.google.com/accounts/ClientLogin?Email=' +
         FGoogleEmail+'&Passwd='+FGooglePwd+
         '&accountType='+FAccountType+'&service'+FServiceName+
         '&source=winteckitalia-dbtosheet-v2.01';
    finally
      SslHandler.Free;
    end;
  finally
    IdHttp.Free;
  end;

  sList := TStringList.Create;
  try
    sList.Text := res;
    FAuthString := sList.Values['Auth'];
    FreqTime := Now;
  finally
    sList.Free;
  end;
end;

procedure TGoogleAuth.SetAccountType(const Value: string);
begin

end;

procedure TGoogleAuth.SetAuthString(const Value: string);
begin

end;

procedure TGoogleAuth.SetGoogleEmail(const Value: string);
begin

end;

procedure TGoogleAuth.SetGooglePwd(const Value: string);
begin

end;

procedure TGoogleAuth.SetReqTime(const Value: TDateTime);
begin

end;

procedure TGoogleAuth.SetServiceName(const Value: string);
begin

end;

function getChildNodes (node: IDOMNode): string;
var
  J: integer;
begin
  Result := '';
  for J := 0 to node.childnodes.length - 1 do
    if(node.childnodes.Item[j].nodeType = TEXT_NODE ) or
      (node.childNodes.item[J].nodeType = CDATA_SECTION_NODE) then
      Result := Result + node.childNodes.Item[J].nodeName;//??
end;

function DoAppRequest(const MethodAttr, FromAttr, strData: string): string;
var
  res: string;
  postStream: TStream;
  idHttp: TIdHttp;
  resStream: TStringStream;
begin
  idHttp := TIdHttp.Create(nil);
  try
    IdHttp.Request.CustomHeaders.Values['Authorization'] := 'GoogleLogin auth=' + googleAuth.AuthString;
    IdHttp.Request.CustomHeaders.Values['Content']       := 'application/atom+xml';;
    IdHttp.Request.CustomHeaders.Values['GData']         := '2';
    // use ssl
    idHttp.IoHandler := TIdSSLIOHandlerSocketOpenSSL.Create(idHttp);
    try
      if(methodAttr='post') or (methodAttr='put') then
      begin
        postStream := TStringStream.Create(strData);
        try
          postStream.Position := 0;
          if (methodAttr = 'post')  then
            res := IdHttp.Post(fromAttr, postStream)
          else
            res := IdHttp.Put(fromAttr, postStream);
        finally
          postStream.Free;
        end;
      end
      else if (methodAttr = 'delete') then
      begin
        resStream := TStringStream.Create('');
        try
          // IdHttp.DoRequest(hmDelete, fromAttr);
        finally
          resStream.Position := 0;
          res := resStream.DataString;
          resStream.Free;
        end;
      end
      else  // 'get' or not assigned
        res := iDHttp.Get (FromAttr);
    except
      on E: Exception do
      begin
        res := E.Message; // ??
      end;
    end;
  finally
    IdHttp.Free;
  end;
  Result := res;
end;

procedure TfrmMain.btnSheetClick(Sender: TObject);
var
  strXML: string;
  IDomSel: IDOMNodeSelect;
  Node: IDOMNode;
  i, nCount: integer;
  title, id: string;
begin
  strXML := DoAppRequest('get',
    'http:spreadsheets.google.com/feeds/spreadsheets/private/full','');;
  strXML := stringReplace(strXML,
    '<feeds xmlns=''htt://www.w3.org/2005/Atom''','<feed ',[]);;

  XMLDocument1.LoadFromXML(strXML);
  XMLDocument1.Active := True;

  IDOMSel := (XMLDocument1.DocumentElement.DOMNode as IDOMNodeSelect);
  nCount := IDOMSel.SelectNodes('/feed/entry').length;
  for i  := 1  to nCount do
  begin
    {Node := IDOMSel.selectNode('/feed/entry['+I}
    title := getChildNodes(Node);
    {Node := IDOMSel.selectNode('/feed/entry['+I  }
    id := getChildNodes(Node);
    ListBox1.Items.Add(title + '-'+id);
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  GoogleAuth := TGoogleAuth.Create;
end;

end.