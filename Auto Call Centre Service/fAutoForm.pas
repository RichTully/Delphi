unit fAutoForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls;

type
  TfrmAutoForm = class(TForm)
    pnlBottom: TPanel;
    StatusBar1: TStatusBar;
    ListBox1: TListBox;
    pnlTop: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure pnlTopClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAutoForm: TfrmAutoForm;

implementation

uses dMain;

{$R *.dfm}

procedure TfrmAutoForm.FormCreate(Sender: TObject);
begin
  dmMain.FormBased := True;
  dmMain.GetRegSettings(True);
  pnlTop.Caption := 'Version: '+dmMain.idsVer.FileVersion;
  pnlBottom.Caption := 'Connected at '+FormatDateTime('hh:mm am/pm, dddd dd mmm yyyy',Now);
end;

procedure TfrmAutoForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  dmMain.FormBased := False;
end;

procedure TfrmAutoForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if MessageDlg('Close Program?'+#13+'Program should remain running'+#13+'Are you sure?', mtConfirmation, [mbYES, mbNO],0) = mrYes then
     CanClose := True
  else
    CanClose := False;
end;

procedure TfrmAutoForm.pnlTopClick(Sender: TObject);
var
  TimeStr : String;
begin
    with dmMain.qryGeneral2 do
    begin
      Close;
      SQL.Text := 'SELECT curtime() AS TME FROM X_GENERALINFO';
      Open;
      TimeStr := FieldByName('TME').AsString;
      showmessage(TimeStr);
    end;
end;

end.