program AutoCall;

uses
  Forms,
  dMain in 'dMain.pas' {dmMain: TDataModule},
  fAutoForm in 'fAutoForm.pas' {frmAutoForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TdmMain, dmMain);
  Application.CreateForm(TfrmAutoForm, frmAutoForm);
  Application.Run;
end.
