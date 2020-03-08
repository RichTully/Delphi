unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdBaseComponent, IdComponent, IdTCPServer, IdCustomHTTPServer, IdContext,
  IdHTTPServer;

type
  TForm1 = class(TForm)
    IdHTTPServer1: TIdHTTPServer;
    procedure IdHTTPServer1CommandGet(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo;
      AResponseInfo: TIdHTTPResponseInfo);
  private
  public
  end;

var
  Form1: TForm1;

implementation
{$R *.dfm}

procedure TForm1.IdHTTPServer1CommandGet(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
begin
  AResponseInfo.ContentText := 'Hello World. It is ' + TimeToStr(Time);
end;

end.
 