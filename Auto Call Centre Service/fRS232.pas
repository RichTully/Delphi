unit fRS232;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls;

type
  TfrmRS232 = class(TForm)
    pnlBottom: TPanel;
    StatusBar1: TStatusBar;
    ListBox1: TListBox;
    pnlTop: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmRS232: TfrmRS232;

implementation

uses dMain;

{$R *.dfm}

procedure TfrmRS232.FormCreate(Sender: TObject);
begin
  dmMain.FormBased := True;
  dmMain.GetRegSettings;
  pnlTop.Caption := 'Version: '+dmMain.idsVer.FileVersion;
  pnlBottom.Caption := 'Connected at '+FormatDateTime('hh:mm am/pm, dddd dd mmm yyyy',Now);
end;

procedure TfrmRS232.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  dmMain.FormBased := False;
end;

procedure TfrmRS232.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if MessageDlg('Close Program?'+#13+'Program should remain running'+#13+'Are you sure?', mtConfirmation, [mbYES, mbNO],0) = mrYes then
     CanClose := True
  else
    CanClose := False;
end;

end.
