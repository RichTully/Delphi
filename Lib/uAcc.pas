unit uAcc;

interface

uses dAcc, System.SysUtils, Generics.Collections;

type
  TSalesOrd_Line = class
  private
    fStockcode: string;
    fDescription: string;
    fUnitPrice: double;
    fOrd_Quant: double;
    fTaxRate:double;
    fTaxRateNo: Integer;
    procedure GetDescription;
    procedure SetStockcode(const Value: string);
    procedure SetUnitPrice(const Value: double);
    procedure SetTaxRate(const Value: double);
  public
    property TaxRate: double read fTaxRate write SetTaxRate;
    property Stockcode: string read fStockcode write SetStockcode;
    property UnitPrice: double read fUnitPrice write SetUnitPrice;
    constructor Create(Stockcode: string; Ord_Quant, UnitPrice: double);  overload;
    constructor Create(Stockcode, Description: string; Ord_Quant, UnitPrice: double); overload;
  end;

type TSQLExec = procedure(SQL: String) of object;
type
  TSO = class
  private
    fSeqNo: integer;
    fAccNo: Integer;
    fRef1: String;
    fRef2: string;
    fSubTotal: Double;
    fTaxTotal: Double;
    fExecute:TSQLExec;
    procedure SetAccNo(const Value: integer);
    procedure SetRef1(const Value: string);
    procedure SetRef2(const Value: string);
    function GetSubTotal: Double;
    function GetTaxTotal: Double;
  public
    Lines: TObjectList<TSalesOrd_Line>;
    procedure Execute(SQL: string);
    function InsertSQL: string;
    procedure Update;
    function GetInfo: String;
    property SeqNo: integer read fSeqNo;
    property AccNo: integer  read FAccNo write SetAccNo;
    property Ref1: string read FRef1 write SetRef1;
    property Ref2: string read FRef2 write SetRef2;
    property SubTotal: double read GetSubTotal;
    property TaxTotal: double read GetTaxTotal;
    constructor Create(dExecute:TSQLExec; AccNo: Integer);
end;

function GetValue: integer;
procedure SetAccConn(AStr: String);
function GetConnStr: String;
function QU(AStr: string): string;

implementation

function QU(AStr: string): string;
begin
  Result := QuotedStr(AStr);
end;

function GetValue: integer;
begin
  Result := dmAcc.GetValue;

end;

procedure SetAccConn(AStr: String);
begin
  dmAcc.ConnStr := AStr;
end;

function GetConnStr: String;
begin
  Result := dmAcc.ConnStr;
end;

{ TSO }

constructor TSO.Create(dExecute:TSQLExec; AccNo: Integer);
begin
  fExecute := dExecute;
  fAccNo:= AccNo;
  Lines := TObjectList<TSalesOrd_Line>.Create;
end;

function TSO.InsertSQL: string;
var
  SQL: string;
  Line: TSalesOrd_Line;
begin
  SQL := 'declare @SNo int;'+
         'insert into Salesord_Hdr(AccNo, Ref1,Ref2, SubTotal) '+
         ' values('+IntToStr(fAccNo)+
         ','+ QU(fRef1)+
         ','+ QU(fRef2)+
         ','+Format('%10.4f',[fSubTotal])+
         '); select @Sno=scope_identity();';
  for Line in Lines do
    SQL := SQL+'insert into SalesOrd_Lines(Hdr_SeqNo, Stockcode, Description, UnitPrice, Ord_Quant, TaxRate, TaxRate_No) '+
               'values(@SNo,'+QU(Line.fStockcode)+','+QU(Line.fDescription)+
               Format(',%8.2f,%8.2f,%8.2f,%d',[Line.fUnitPrice, Line.fOrd_Quant, Line.fTaxRate, Line.fTaxRateNo])+');';
  Execute(SQL);
  Result := 'Done';
  //fSeqNo := 100;// GetDataInteger(SQL);
end;


procedure TSO.SetAccNo(const Value: integer);
begin
  FAccNo := Value;
end;

procedure TSO.SetRef1(const Value: string);
begin
  FRef1 := Value;
end;

procedure TSO.SetRef2(const Value: string);
begin
  FRef2 := Value;
end;

function TSO.GetSubTotal: double;
var
  fT: Double;
  Line: TSalesOrd_Line;
begin
  fT := 0;
  for Line in Lines do
    fT := fT + Line.fUnitPrice * Line.fOrd_Quant;
  Result := fT;
end;


function TSO.GetTaxTotal: Double;
var
  fT: Double;
  Line: TSalesOrd_Line;
begin
  fT := 0;
  for Line in Lines do
  begin
    fT := fT + Line.fUnitPrice * Line.fOrd_Quant * Line.fTaxRate/100.0;
  end;
  Result := fT;
end;

procedure TSO.Execute(SQL: string);   //; dExecute: TSQLExec
begin
  fExecute(SQL);
end;

function TSO.GetInfo: String;
var
  AStr: String;
  i: integer;
  Line: TSalesOrd_Line;
begin
  AStr := 'Debtor Acc: '+IntToStr(fAccNo);
  AStr := AStr + #13+ 'Ref1: '+fRef1;

  if Lines.Count > 0  then
  begin
    AStr := AStr +#13 +#13+ '---------------------';
    for Line in Lines do
      AStr := AStr + #13+Format('%-23s %10.2f %8.2f',[Line.fStockcode, Line.fOrd_Quant, Line.fUnitPrice]);
    AStr := AStr +#13+ '---------------------';
    AStr := AStr +#13+ 'Sub Total: '+Format('%8.2f',[SubTotal]);
    AStr := AStr +#13+ 'Tax Total: '+Format('%8.2f',[TaxTotal]);
  end;
  Result := AStr;
end;

procedure TSO.Update;
var
  SQL: string;
begin
  SQL := 'update SalesOrd_Hdr '+
         ' set AccNo='+IntToStr(fAccNo)+
         ' Where SeqNo='+IntToStr(fSeqNo);
  //ExecuteSQL(SQL);

end;

{ TSalesOrd_Line }

constructor TSalesOrd_Line.Create(Stockcode: string; Ord_Quant,
  UnitPrice: double);
begin
  fStockcode := Stockcode;
  fUnitPrice := UnitPrice;
  fOrd_Quant := Ord_Quant;
  fTaxRate := 0;     // Default?
end;

constructor TSalesOrd_Line.Create(Stockcode, Description: string; Ord_Quant,
  UnitPrice: double);
begin
  fDescription := Description;
  Create(Stockcode, Ord_Quant, UnitPrice);
end;

procedure TSalesOrd_Line.GetDescription;
begin
  //
end;

procedure TSalesOrd_Line.SetStockcode(const Value: string);
begin
  fStockcode := Value;
end;

procedure TSalesOrd_Line.SetTaxRate(const Value: double);
begin
  fTaxRate := Value;
end;

procedure TSalesOrd_Line.SetUnitPrice(const Value: double);
begin
  fUnitPrice := Value;
end;

end.
