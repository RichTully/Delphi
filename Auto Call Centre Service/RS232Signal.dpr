program RS232Signal;

uses
  SvcMgr,
  uRS232Signal in 'uRS232Signal.pas' {RS232_Signal: TService},
  dMain in 'dMain.pas' {dmMain: TDataModule};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TRS232_Signal, RS232_Signal);
  Application.CreateForm(TdmMain, dmMain);
  Application.Run;
end.
