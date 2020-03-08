unit fMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Datasnap.DBClient, Vcl.StdCtrls,
  Vcl.Grids, Vcl.DBGrids;

type
  TForm6 = class(TForm)
    Button1: TButton;
    cds: TClientDataSet;
    cdsSeqNo: TIntegerField;
    cdsName: TStringField;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    Button2: TButton;
    Button3: TButton;
    cdsNum: TIntegerField;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form6: TForm6;

implementation

{$R *.dfm}
type //used in converting number to string
  TNumberStr = string[13];
const
  Numbers: array[1..19] of TNumberStr = ('One', 'Two', 'Three', 'Four',
  'Five', 'Six', 'Seven', 'Eight', 'Nine', 'Ten', 'Eleven', 'Twelve',
  'Thirteen', 'Fourteen', 'Fifteen', 'Sixteen', 'Seventeen', 'Eighteen',
  'Nineteen');

Tenths: array[1..9] of TNumberStr = ('Ten', 'Twenty', 'Thirty', 'Forty',
  'Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety');
Min= 0; Max=10000000;

function RecurseNumber(N: LongWord): string;
begin
  case N of
  1..19:  Result := Numbers[N];
  20..99: Result := Tenths[N div 10] + ' ' + RecurseNumber(N mod 10);
  100..999: Result := Numbers[N div 100] + ' Hundred ' + RecurseNumber(N mod 100);
  1000..999999:Result := RecurseNumber(N div 1000) + ' Thousand ' +
                RecurseNumber(N mod 1000);
  1000000..999999999: Result := RecurseNumber(N div 1000000) + ' Million '
                                + RecurseNumber(N mod 1000000);
  1000000000..4294967295: Result := RecurseNumber(N div 1000000000) + ' Billion ' +
                          RecurseNumber(N mod 1000000000);
  end;{Case N of}
end;{RecurseNumber}

function NumToLetters(Number: Real): string;
begin
  if (Number >= Min) and (Number <= Max) then
  begin
    Result := RecurseNumber(Round(Int(Number)))+ ' Dollars';
    {Added for cents in a currency value}
    if not(Frac(Number) = 0.00) then
      Result := Result + ' and ' + IntToStr(Round(Frac(Number) * 100)) + '/100'
    else
      Result := Result + ' and 0/100';
    Result := StringReplace(Result, ' ', ' ', []);
  end ;
  //else
  //  raise ERangeError.CreateFmt('%g ' + ErrorString + ' %g..%g',[Number, Min, Max]);
end;{NumToLetters}

procedure TForm6.Button1Click(Sender: TObject);
var
  i,  n1,n2,n3,n4,n5,n6,n: Integer;
  NStr: string;
begin
  for i := 0 to 999999 do
  begin
    n1 := Random(10);
    n2 := Random(10);
    n3 := Random(10);
    n4 := Random(10);
    n5 := Random(10);
    n6 := Random(10);
    n := n1+N2*10+n3*100+n4*1000+n5*10000+n6*100000;
    NStr := RecurseNumber(N);
    cds.InsertRecord([i,n,NStr]);
  end;
end;

procedure TForm6.Button2Click(Sender: TObject);
begin
  cds.SaveToFile('Numbers.cds');
end;

procedure TForm6.Button3Click(Sender: TObject);
begin
  cds.LoadFromFile('Numbers.cds');
end;

procedure TForm6.DBGrid1TitleClick(Column: TColumn);
begin
  cds.IndexFieldNames := Column.FieldName;
end;

procedure TForm6.FormShow(Sender: TObject);
begin
  cds.CreateDataSet;
end;

end.
