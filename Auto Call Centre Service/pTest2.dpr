program pTest2;

uses
  Forms,
  fTest2 in 'fTest2.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
