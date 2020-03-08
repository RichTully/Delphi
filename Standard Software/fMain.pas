unit fMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Vcl.Menus, Vcl.ToolWin, Vcl.ActnMan, Vcl.ActnCtrls, Vcl.ComCtrls,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnList, System.Actions, AccLib,
  Vcl.StdCtrls;

type
  TfrmMain = class(TForm)
    MainMenu1: TMainMenu;
    ActionManager1: TActionManager;
    StatusBar1: TStatusBar;
    ActionToolBar1: TActionToolBar;
    File1: TMenuItem;
    Exit1: TMenuItem;
    Button1: TButton;
    Button2: TButton;
    procedure Exit1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses dMain;

{$R *.dfm}

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  AccLib.GetData(dmMain.qryConn, dmMain.cdsGeneral, 'select Top 1 * from DR_ACCS');
  showmessage(dmMain.cdsGeneral.FieldByName('Name').AsString);
end;

procedure TfrmMain.Button2Click(Sender: TObject);
var
  Acc: Integer;
begin
  AccLib.GetData(dmMain.qryConn, Acc, 'select Top 1 Accno from DR_ACCS');
  showmessage(Inttostr(Acc));
end;

procedure TfrmMain.Exit1Click(Sender: TObject);
begin
  Close;
end;

end.
