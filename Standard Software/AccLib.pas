unit AccLib;

interface
uses
  ADODB, DB, Datasnap.dbClient, System.SysUtils;
{
type
  TQryConn = class(TObject)
  private
    fQryConn:TAdoQuery;
    fActive: Boolean;
    procedure SetQryConn(value: TAdoQuery);
  public
    property QryConn: TAdoQuery read fQryConn write SetQryConn;
  end;
}

//function GetDataInteger(qryConn:TAdoQuery; SQL: String): integer; overload;
//function GetDataInteger(qryConn:TAdoQuery; SQL: String): double;  overload;
procedure GetData(qryConn:TAdoQuery; cds: TClientDataSet; SQL: String); overload;
procedure GetData(qryConn:TAdoQuery; var Val: integer; SQL: String); overload;

function GetSearchStr(IntFieldName, FieldName, IsActiveFieldName, SearchKey: String; IncInActive: Boolean): string;
function ifb(AStr, DefStr: string): string;
function nifb(AStr: string): string;
function nif(AStr, NStr: string): string;
function zifb(AStr: string): string;


implementation

procedure GetData(qryConn:TAdoQuery; cds: TClientDataSet; SQL: String);
begin
  cds.Close;
  if cds.ProviderName = '' then
    cds.ProviderName := 'dspConn';
  qryConn.SQL.Text := SQL;
  cds.Open;
end;

procedure GetData(qryConn:TAdoQuery; var Val: integer; SQL: String);
begin
  qryConn.Close;
  qryConn.SQL.Text := SQL;
  qryConn.Open;
  Val := qryConn.Fields[0].AsInteger;
end;

(*
function GetDataInteger(qryConn:TAdoQuery; SQL: String): integer;
begin
  qryConn.Close;
  qryConn.SQL.Text := SQL;
  qryConn.Open;
  Result := qryConn.Fields[0].AsInteger;
end;

function GetDataInteger(qryConn:TAdoQuery; SQL: String): double;
begin
  qryConn.Close;
  qryConn.SQL.Text := SQL;
  qryConn.Open;
  Result := qryConn.Fields[0].AsInteger;
end;
*)
//------------------------------------------------------------------------------

function GetSearchStr(IntFieldName, FieldName, IsActiveFieldName, SearchKey: String; IncInActive: Boolean): string;
var
  Act, Srch, S1, S2, FNames: String;
  V, Code, i: Integer;
  IsAnd: Boolean;
  //======================
  function AndOr:String;
  begin
    if IsAnd then
      Result := ' And( '
    else
      Result := ' OR ';
    IsAnd := False;
  end;
begin
  i := 0;
  IsAnd := True;
  Srch := '';
  if IncInActive then
    Act := ' '
  else
    Act := ' And '+IsActiveFieldName+' = '+ QuotedStr('Y');
  if SearchKey <> '' then
  begin
    SearchKey := Trim(SearchKey);    // Remove blanks from either end
    Val(SearchKey, V, Code);
    FNames := FieldName+';';
    while pos(';',FNames) > 0 do
    begin
      FieldName := Copy(FNames,1,pos(';',FNames)-1);
      FNames := Copy(FNames,length(FieldName)+2,Length(FNames)-length(FieldName)-1);
      if (Code = 0) and (i = 0) then
      begin
        if IntFieldName <> '' then
          Srch := AndOr+' ('+IntFieldName+' = '+SearchKey+')';
        inc(i);
      end;
      //else
      if pos(' ',SearchKey) > 0 then
      begin
        S1 := Copy(SearchKey, 1, pos(' ', SearchKey)-1);
        S2 := Copy(SearchKey,pos(' ', SearchKey)+1, length(SearchKey));
        Srch := Srch + AndOr+' (Upper('+FieldName+') Like UPPER('+QuotedStr('%'+S1+'%'+S2+'%')+')'+
                ' Or Upper('+FieldName+') Like UPPER('+QuotedStr('%'+S2+'%'+S1+'%')+'))';
      end
      else
        Srch :=  Srch + AndOr+' (Upper('+FieldName+') Like UPPER('+QuotedStr('%'+SearchKey+'%')+'))'
    end;
    if not IsAnd then
      Srch := Srch + ')';
  end
  else
    Srch := ' ';
  Result := Act+Srch;
end;


function ifb(AStr, DefStr: string): string;
var
  BStr: string;
begin
  BStr := Trim(AStr);
  if BStr = '' then
    Result := DefStr
  else
    Result := BStr;
end;

function nifb(AStr: string): string;
begin
  Result := ifb(AStr,'null');
end;

function nif(AStr, NStr: string): string;
begin
  if AStr = NStr then
    Result := 'null'
  else
    Result := AStr;
end;

function zifb(AStr: string): string;
begin
  Result := ifb(AStr,'0');
end;

end.