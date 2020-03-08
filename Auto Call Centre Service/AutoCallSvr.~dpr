program AutoCallSvr;

uses
  SvcMgr,
  sAutoCall in 'sAutoCall.pas' {AutoCall: TService},
  dMain in 'dMain.pas' {dmMain: TDataModule};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TAutoCall, AutoCall);
  Application.CreateForm(TdmMain, dmMain);
  Application.Run;
end.
