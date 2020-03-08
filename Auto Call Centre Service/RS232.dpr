program RS232;

uses
  Forms,
  fRS232 in 'fRS232.pas' {frmRS232},
  dMain in 'dMain.pas' {dmMain: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TdmMain, dmMain);
  Application.CreateForm(TfrmRS232, frmRS232);
  Application.Run;
end.
