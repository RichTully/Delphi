unit uRS232Signal;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs, ActiveX;

type
  TRS232_Signal = class(TService)
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
  RS232_Signal: TRS232_Signal;

implementation

uses dMain;

{$R *.DFM}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  RS232_Signal.Controller(CtrlCode);
end;

function TRS232_Signal.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TRS232_Signal.ServiceStart(Sender: TService;
  var Started: Boolean);
begin
  CoInitialize(nil);
end;

procedure TRS232_Signal.ServiceStop(Sender: TService;
  var Stopped: Boolean);
begin
  CoUnInitialize;
end;

procedure TRS232_Signal.ServiceExecute(Sender: TService);
begin
  dmMain.FormBased := False;
  dmMain.GetRegSettings;
  while not terminated do
  begin
    ServiceThread.ProcessRequests(TRUE);
  end;  
  
end;

end.
