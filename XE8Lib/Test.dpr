program Test;

uses
  Vcl.Forms,
  fMain in 'fMain.pas' {frmMain},
  dMain in 'dMain.pas' {dmMain: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdmMain, dmMain);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.