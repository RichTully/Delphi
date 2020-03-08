unit fMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AccThread, Data.DB, Data.Win.ADODB,
  Vcl.StdCtrls, IdBaseComponent, IdScheduler, IdSchedulerOfThread,
  IdSchedulerOfThreadDefault;

type
  TfrmMain = class(TForm)
    Conn: TADOConnection;
    Qry1: TADOQuery;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);

  private
    { Private declarations }
    numThreads: Integer;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.Button1Click(Sender: TObject);
var
  th: TADOSQLThread;
  ThNo: Integer;
  SQL: String;
begin
  //crear el Thread
  SQL := 'SELECT * FROM TAB1';
  ThNo := 1;
  th := TADOSQLThread.Create(True, Conn.ConnectionString, SQL, ThNo);
  // internal for me (for controled the number of active threads and limete it)
  inc(numThreads);
  // evento finalizacion
  //th.OnTerminate := TerminateThread;
  // Ejecutarlo
  th.Resume;
end;

procedure TfrmMain.Button2Click(Sender: TObject);
var
  StrUserName: PChar;
  Size: DWord;
begin
  Size:=250;
  GetMem(StrUserName, Size);
  GetUserName(StrUserName, Size);
  Label1.Caption:=StrPas(StrUserName);
  FreeMem(StrUserName);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  NumThreads := 0;
end;

end.
