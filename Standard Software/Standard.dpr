program Standard;

uses
  Forms,
  fMain in 'fMain.pas' {frmMain},
  dConn in 'dConn.pas' {dmConn: TDataModule},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdmConn, dmConn);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
