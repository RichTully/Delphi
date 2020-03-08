unit AccThread;

interface
uses
  System.Classes, Data.DB, Data.Win.ADODb;
type
  TADOSQLThread = class(TThread)
  private
    FADOQ: TADOQuery;  // Internal query
    FSQL: string;      // SQL To execute
    FID: integer;      // Internal ID

  public
    constructor Create(CreateSuspended:Boolean; AConnString:String;
                       ASQL:string; IDThread:integer);
    destructor Destroy; override;
    procedure Execute(); override;

    property ID:integer read FID write FID;
    property SQL:string read FSQL write FSQL;
    property ADOQ:TADOQuery read FADOQ write FADOQ;
  end;

implementation

constructor TADOSQLThread.Create(CreateSuspended:Boolean; AConnString:String;
                                 ASQL:string; IDThread:integer);
begin

  inherited Create(CreateSuspended);

  // ini
  Self.FreeOnTerminate := False;

  // Create the Query
  FADOQ := TAdoquery.Create(nil);
  // assign connections
  FADOQ.ConnectionString := AConnString;
  FADOQ.SQL.Add(ASQL);
  Self.FID := IDThread;
  Self.FSQL:= ASQL;
end;


destructor TADOSQLThread.Destroy;
begin

  inherited;
end;

procedure TADOSQLThread.Execute();
begin

  inherited;

  try
    // Ejecutar la consulta
    Self.FADOQ.Open;
  except
    // Error al ejecutar
    //...Error treatement
  end;
end;
end.
