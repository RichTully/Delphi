program HttpGet_XE2;

uses
  Forms,
  fMain in 'fMain.pas' {frmMain},
  securezealdcompinnaclevAPIV2Product in 'securezealdcompinnaclevAPIV2Product.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
