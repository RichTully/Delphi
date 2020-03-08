unit Unit3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DBXMySQL, Data.FMTBcd, Data.DB,
  Data.SqlExpr, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids, FireDAC.VCLUI.Wait,
  FireDAC.Comp.UI, Datasnap.DBClient, Datasnap.Provider,CodeSiteLogging,
  Vcl.StdCtrls, Vcl.ExtCtrls ;

type
  TForm3 = class(TForm)
    SQLConnection1: TSQLConnection;
    SQLQuery1: TSQLQuery;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    DataSetProvider1: TDataSetProvider;
    ClientDataSet1: TClientDataSet;
    Button1: TButton;
    Button2: TButton;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Image3DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Image3DragDrop(Sender, Source: TObject; X, Y: Integer);
  private
    procedure DoIt(j: integer);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

//     jaesupport.db.8167924.hostedresource.com
{$R *.dfm}

procedure TForm3.Button1Click(Sender: TObject);
var
  i: Integer;
begin
  CodeSite.EnterMethod( 'Button1Click' );
  CodeSite.Send('First message');
  for i := 1 to 10 do
  begin
    DoIt(i);
  end;
  CodeSite.Send( 'Main Form', Self );
  CodeSite.ExitMethod( 'Button1Click' );
end;
procedure TForm3.DoIt(j: integer);
begin
  CodeSite.EnterMethod( 'DoIt' );
    CodeSite.Send('Message '+IntToStr(j));
  CodeSite.ExitMethod( 'Doit' );
end;
procedure TForm3.Button2Click(Sender: TObject);
begin
  CodeSite.AddCheckPoint;
end;

procedure TForm3.FormActivate(Sender: TObject);
begin
  CodeSite.Send( 'Main Form Activate', Self.Color );
end;

procedure TForm3.FormCreate(Sender: TObject);
var
   Dest: TCodeSiteDestination;
begin
   Dest := TCodeSiteDestination.Create( Self );

   Dest.LogFile.Active := False;
   Dest.LogFile.FileName := 'MyFirstLog.csl';
   Dest.LogFile.FilePath := '$(MyDocs)';
   Dest.Viewer.Active := True;
   CodeSite.Destination := Dest;
end;

procedure TForm3.FormShow(Sender: TObject);
begin
  //SQLConnection1.Connected := True;
  CodeSite.Send( 'Main Form Show', Self );
  SQLQuery1.SQL.Text := 'Select * FROM X_PROVIDER';
  ClientDataSet1.Open;
end;

procedure TForm3.Image3DragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  (Sender as TImage).Picture.Assign((Source as Timage).Picture);
end;

procedure TForm3.Image3DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept := (SEnder is TImage);
end;

end.
