program TreadTest;

uses
  Vcl.Forms,
  fMain in 'fMain.pas' {frmMain},
  AccThread in 'AccThread.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
