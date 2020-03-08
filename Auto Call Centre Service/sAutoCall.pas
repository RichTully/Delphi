unit sAutoCall;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs, ActiveX;

type
  TAutoCall = class(TService)
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure ServiceExecute(Sender: TService);
  private
    { Private declarations }
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  AutoCall: TAutoCall;

implementation

uses dMain;

{$R *.DFM}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  AutoCall.Controller(CtrlCode);
end;

function TAutoCall.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TAutoCall.ServiceStart(Sender: TService; var Started: Boolean);
begin
  CoInitialize(nil);
end;

procedure TAutoCall.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
  CoUnInitialize;
end;

procedure TAutoCall.ServiceExecute(Sender: TService);
begin
  dmMain.FormBased := False;
  dmMain.GetRegSettings(True);
  while not Terminated do
  begin
    ServiceThread.ProcessRequests(True);
  end;
end;

end.
