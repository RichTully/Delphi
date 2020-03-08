unit Capture;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBClient, Grids, DBGrids, StdCtrls, wwdbdatetimepicker,
  Wwdbigrd, Wwdbgrid, TeEngine, TeeFunci, Series, ExtCtrls, TeeProcs,
  Chart, DBChart, CSPC, CSTCBase, DateUtils, PathDialog, DBCtrls, Mask,
  ComCtrls, ODCalend, MyPoint, ActnList, TeeEdit, TeeComma, math,midaslib,
  Menus, ImgList;

type
  TFrmMain = class(TForm)
    cdsRun: TClientDataSet;
    dsRun: TDataSource;
    wwDBDateTimePicker1: TwwDBDateTimePicker;
    cdsRunRunDate: TDateField;
    cdsRunDistance: TFloatField;
    cdsRunDayOfWeek: TStringField;
    cdsRunRunTime: TFloatField;
    csPageControl1: TcsPageControl;
    tsInput: TcsTabSheet;
    tsGraph: TcsTabSheet;
    Panel1: TPanel;
    DBChart1: TDBChart;
    TTeeFunction1: TAddTeeFunction;
    cdsRunYear: TIntegerField;
    cdsRunWeek: TIntegerField;
    PathDialog1: TPathDialog;
    cdsRunWeekTot: TAggregateField;
    ActionList1: TActionList;
    actChangePeriod: TAction;
    cdsRunMinTot: TAggregateField;
    tsImport: TcsTabSheet;
    btnEmpty: TButton;
    btnImport: TButton;
    Panel2: TPanel;
    cdsStats: TClientDataSet;
    actBuildStats: TAction;
    TeeCommander1: TTeeCommander;
    dsStats: TDataSource;
    DBGrid1: TDBGrid;
    Series1: TBarSeries;
    tsGraphStats: TcsTabSheet;
    Chart1: TChart;
    TeeCommander2: TTeeCommander;
    actAddSeries: TAction;
    tsStats: TcsTabSheet;
    cdsStatsYear: TSmallintField;
    cdsStatsWeek: TSmallintField;
    cdsStatsDistance: TFloatField;
    cdsStatsWeek4: TFloatField;
    cdsStatsWeek12: TFloatField;
    cdsStatsWeek8: TFloatField;
    cdsStatsWeek16: TFloatField;
    cdsStatsWeek52: TFloatField;
    Panel3: TPanel;
    wwDBGrid1: TwwDBGrid;
    Panel4: TPanel;
    rgPeriod: TRadioGroup;
    MonthCalendar1: TMonthCalendar;
    btnCreateStats: TButton;
    Panel5: TPanel;
    LBPeriod: TLabel;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    Panel6: TPanel;
    cbType: TComboBox;
    Label1: TLabel;
    btnAddSeries: TButton;
    PopupMenu1: TPopupMenu;
    DeleteRecord1: TMenuItem;
    actDeleteRecord: TAction;
    ImageList1: TImageList;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    actClose: TAction;
    Options1: TMenuItem;
    ShowHints1: TMenuItem;
    wwDBGrid2: TwwDBGrid;
    cbYears: TComboBox;
    Label2: TLabel;
    procedure cdsRunCalcFields(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure actChangePeriodExecute(Sender: TObject);
    procedure btnEmptyClick(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
    procedure actBuildStatsExecute(Sender: TObject);
    procedure actAddSeriesExecute(Sender: TObject);
    procedure MonthCalendar1DblClick(Sender: TObject);
    procedure csPageControl1Changing(Sender: TObject; NewIndex: Integer;
      var AllowChange: Boolean);
    procedure actDeleteRecordExecute(Sender: TObject);
    procedure ShowHints1Click(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure wwDBGrid1CalcCellColors(Sender: TObject; Field: TField;
      State: TGridDrawState; Highlight: Boolean; AFont: TFont;
      ABrush: TBrush);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.dfm}

procedure TFrmMain.cdsRunCalcFields(DataSet: TDataSet);
begin
  case DayOfWeek(cdsRun.FieldByName('RunDate').AsDateTime) of
  1: cdsRun.FieldByName('DayOfWeek').AsString := 'Sunday';
  2: cdsRun.FieldByName('DayOfWeek').AsString := 'Monday';
  3: cdsRun.FieldByName('DayOfWeek').AsString := 'Tuesday';
  4: cdsRun.FieldByName('DayOfWeek').AsString := 'Wednesday';
  5: cdsRun.FieldByName('DayOfWeek').AsString := 'Thursday';
  6: cdsRun.FieldByName('DayOfWeek').AsString := 'Friday';
  7: cdsRun.FieldByName('DayOfWeek').AsString := 'Saturday';
  end;
  cdsRun.FieldByName('Week').AsInteger := WeekOf(cdsRun.FieldByName('RunDate').AsDateTime);
  if (MonthOf(cdsRun.FieldByName('RunDate').AsDateTime) = 1) and (WeekOf(cdsRun.FieldByName('RunDate').AsDateTime) > 50) then
    cdsRun.FieldByName('Year').AsInteger := YearOf(cdsRun.FieldByName('RunDate').AsDateTime) - 1
  else if (MonthOf(cdsRun.FieldByName('RunDate').AsDateTime) = 12) and (WeekOf(cdsRun.FieldByName('RunDate').AsDateTime) = 1) then
    cdsRun.FieldByName('Year').AsInteger := YearOf(cdsRun.FieldByName('RunDate').AsDateTime) + 1
  else
    cdsRun.FieldByName('Year').AsInteger := YearOf(cdsRun.FieldByName('RunDate').AsDateTime);
end;

procedure TFrmMain.FormCreate(Sender: TObject);
var
  i: integer;
begin
  try
    cdsRun.FileName := 'Run.cds';
    cdsRun.Open;
  except
    if PathDialog1.Execute then
    begin
      cdsRun.FileName := PathDialog1.Directory+'\Run.cds';
      if not Fileexists(cdsRun.FileName) then
        cdsRun.CreateDataSet;
      cdsRun.Open;
    end
    else
      Application.Terminate;
  end;
  try
    cdsStats.FileName := 'Stats.cds';
    cdsStats.Open;
  except
    if PathDialog1.Execute then
    begin
      cdsStats.FileName := PathDialog1.Directory+'\Stats.cds';
      if not Fileexists(cdsStats.FileName) then
      cdsStats.CreateDataSet;
      cdsStats.Open;
    end
    else
      Application.Terminate;
  end;
  MonthCalendar1.Date := Date;
  actChangePeriodExecute(Sender);
  csPageControl1.ActivePage := tsInput;
  for i := YearOf(Date) downto YearOf(Date) - 30 do
    cbYears.Items.Add(IntToStr(i));
  cbYears.ItemIndex := 0;
end;

procedure TFrmMain.actChangePeriodExecute(Sender: TObject);
var
  SDate : TDateTime;
begin
  //showMessage(DateToStr(ODCalendar1.StartDate)+' - '+DateToStr(ODCalendar1.FinishDate));
  case rgPeriod.ItemIndex of
  0: begin            // Week
       //SDate := ODCalendar1.StartDate - DayOfWeek(ODCalendar1.StartDate) + 2;
       SDate := MonthCalendar1.Date - DayOfTheWeek(MonthCalendar1.Date) + 1;           //2
       cdsRun.Filter := 'RunDate >= '+''''+(DateToStr(SDate))+''''+
                   'and RunDate < '+''''+DateToStr(SDate+7)+'''';                   //7
       LBPeriod.Caption := 'Total for Week';
     end;
  1: begin             //Month
       //SDate := ODCalendar1.StartDate - DayOfTheMonth(ODCalendar1.StartDate) + 1;
       SDate := MonthCalendar1.Date - DayOfTheMonth(MonthCalendar1.Date) + 1;
       cdsRun.Filter := 'RunDate >= '+''''+(DateToStr(SDate))+''''+
                   'and RunDate < '+''''+DateToStr(SDate+DaysInAMonth(Yearof(SDate),MonthofTheYear(SDate)))+'''';
       LBPeriod.Caption := 'Total for Month';
     end;
  2: begin             // Year
       //SDate := ODCalendar1.StartDate - DayOfTheYear(ODCalendar1.StartDate) + 1;
       SDate := MonthCalendar1.Date - DayOfTheYear(MonthCalendar1.Date) + 1;
       cdsRun.Filter := 'RunDate >= '+''''+(DateToStr(SDate))+''''+
                   'and RunDate < '+''''+DateToStr(SDate+365)+'''';
       LBPeriod.Caption := 'Total for Year';
     end;
  end;
  cdsRun.Filtered := True;
  dbChart1.Invalidate;
end;

procedure TFrmMain.btnEmptyClick(Sender: TObject);
begin
  cdsRun.Filtered := False;;
  while not cdsRun.Eof do
  begin
    cdsRun.Delete;
  end;
end;

procedure TFrmMain.btnImportClick(Sender: TObject);
var
  F : TextFile;
  S, PS : string;
  TheDate: TDateTime;
  MonD, TueD, WedD, ThuD, FriD, SatD, SunD : Extended;
  p1,p2,p3,p4,p5,p6,p7 : integer;
begin
  AssignFile(F, 'run.csv');
  Reset(F);
  while not EOF(F) do
  begin
    Readln(F, S);                        { Read first line of file }
    TheDate := strToDate( Copy(S,1,10));
    p1 := pos(',',S);
    p2 := p1 + pos(',',Copy(S,p1+1,Length(S)-p1));
    p3 := p2 + pos(',',Copy(S,p2+1,Length(S)-p2));
    p4 := p3 + pos(',',Copy(S,p3+1,Length(S)-p3));
    p5 := p4 + pos(',',Copy(S,p4+1,Length(S)-p4));
    p6 := p5 + pos(',',Copy(S,p5+1,Length(S)-p5));
    p7 := p6 + pos(',',Copy(S,p6+1,Length(S)-p6));
    PS := Copy(S,p1+1, p2-p1-1);
    try
      MonD := StrToFloat(PS);
    except
      MonD := 0;
    end;
    PS := Copy(S,p2+1, p3-p2-1);
    try
      TueD := StrToFloat(PS);
    except
      TueD := 0;
    end;
    try
      WedD := StrToFloat(Copy(S,p3+1, p4-p3-1));
    except
      WedD := 0;
    end;
    try
      ThuD := StrToFloat(Copy(S,p4+1, p5-p4-1));
    except
      ThuD := 0;
    end;
    try
      FriD := StrToFloat(Copy(S,p5+1, p6-p5-1));
    except
      FriD := 0;
    end;
    try
      SatD := StrToFloat(Copy(S,p6+1, p7-p6-1));
    except
      SatD := 0;
    end;
    try
      SunD := StrToFloat(Copy(S,p7+1, 4));
    except
      SunD := 0;
    end;
    with cdsRun do
    begin
      Insert;
      FieldByName('RunDate').AsDateTime := TheDate;
      FieldByName('Distance').AsFloat   := MonD;
      FieldByName('RunTime').AsFloat    := 0;
      Post;
      Insert;
      FieldByName('RunDate').AsDateTime := TheDate+1;
      FieldByName('Distance').AsFloat   := TueD;
      FieldByName('RunTime').AsFloat    := 0;
      Post;
      Insert;
      FieldByName('RunDate').AsDateTime := TheDate+2;
      FieldByName('Distance').AsFloat   := WedD;
      FieldByName('RunTime').AsFloat    := 0;
      Post;
      Insert;
      FieldByName('RunDate').AsDateTime := TheDate+3;
      FieldByName('Distance').AsFloat   := ThuD;
      FieldByName('RunTime').AsFloat    := 0;
      Post;
      Insert;
      FieldByName('RunDate').AsDateTime := TheDate+4;
      FieldByName('Distance').AsFloat   := FriD;
      FieldByName('RunTime').AsFloat    := 0;
      Post;
      Insert;
      FieldByName('RunDate').AsDateTime := TheDate+5;
      FieldByName('Distance').AsFloat   := SatD;
      FieldByName('RunTime').AsFloat    := 0;
      Post;
      Insert;
      FieldByName('RunDate').AsDateTime := TheDate+6;
      FieldByName('Distance').AsFloat   := SunD;
      FieldByName('RunTime').AsFloat    := 0;
      Post;
    end;
  end;
  CloseFile(F);

end;

procedure TFrmMain.actBuildStatsExecute(Sender: TObject);
var
  TmpDate, EndDate, StartDate: TDateTime;
  w : array[1..52] of single;
  WDistance, Tot: single;
  wPos, i : integer;
  function GetAve(NWeek : integer; wArray: array of Single; APos: integer): Single;
  var
    NFromTop, i : integer;
  begin
    Tot := 0;
    NFromTop := NWeek - APos;

    for i :=  Apos downto max(0,APos - NWeek) do
        Tot := Tot + wArray[i];
    for i := 52 downto 52 - NFromTop do
        Tot := Tot + wArray[i];
    Result := Tot / NWeek;
  end;
begin
  for i := 1 to 52 do
    w[i] := 0;
  //cdsStats.CreateDataSet;
  cdsStats.Open;
  cdsStats.EmptyDataSet;
  with cdsRun do
  begin
    Filtered := False;
    First;
    StartDate := FieldByName('RunDate').AsDateTime- DayOfWeek(FieldByName('RunDate').AsDateTime);
    EndDate := StartDate + 7;
    wPos := 0;
    while not EOF do
    begin
      wDistance := 0;
      while (not EOF) and (FieldByName('RunDate').AsDateTime <= EndDate) do
      begin
        wDistance := wDistance + FieldByName('Distance').AsFloat;
        Next;
      end;
      inc(WPos);
      if wPos > 52 then wPos := 1;
      w[wPos] := wDistance;
      cdsStats.Insert;
      if (MonthOf(StartDate) = 1) and (WeekOf(StartDate) > 50) then
        cdsStats.FieldByName('Year').AsInteger := YearOf(StartDate) - 1
      else if (MonthOf(StartDate) = 12) and (WeekOf(StartDate) = 1) then
        cdsStats.FieldByName('Year').AsInteger := YearOf(StartDate) + 1
      else
        cdsStats.FieldByName('Year').AsInteger := YearOf(StartDate);
      //cdsStats.FieldByName('Year').AsInteger := YearOf(StartDate);
      cdsStats.FieldByName('Week').AsInteger := WeekOf(StartDate);
      cdsStats.FieldByName('Distance').AsFloat := wDistance;
      cdsStats.FieldByName('Week4').AsFloat := GetAve(4, w, WPos);
      cdsStats.FieldByName('Week12').AsFloat := GetAve(12, w, WPos);
      cdsStats.FieldByName('Week8').AsFloat := GetAve(8, w, WPos);
      cdsStats.FieldByName('Week16').AsFloat := GetAve(16, w, WPos);
      cdsStats.FieldByName('Week52').AsFloat := GetAve(52, w, WPos);
      cdsStats.Post;
      StartDate := EndDate;
      EndDate := EndDate + 7;
    end;
  end;
  cdsStats.Close;
  cdsStats.Open;
end;

procedure TFrmMain.actAddSeriesExecute(Sender: TObject);
var
  ASeries: TLineSeries;
begin
  ASeries := TLineSeries.Create(Self);
  ASeries.ParentChart := Chart1;
  cdsStats.Filter := 'Year = ' + cbYears.Text;
  ASeries.Title := cbYears.Text+' '+cbType.Text;
  cdsStats.Filtered := true;
  cdsStats.First;
  ASeries.Stairs := False;
  while not cdsStats.Eof do
  begin
    case cbType.ItemIndex of
    0:  ASeries.AddXY(cdsStats.FieldByName('Week').AsFloat,
                    cdsStats.FieldByName('Week4').AsFloat,'',clTeeColor);
    1:  ASeries.AddXY(cdsStats.FieldByName('Week').AsFloat,
                    cdsStats.FieldByName('Week8').AsFloat,'',clTeeColor);
    2:  ASeries.AddXY(cdsStats.FieldByName('Week').AsFloat,
                    cdsStats.FieldByName('Week12').AsFloat,'',clTeeColor);
    3:  ASeries.AddXY(cdsStats.FieldByName('Week').AsFloat,
                    cdsStats.FieldByName('Week16').AsFloat,'',clTeeColor);
    4:  ASeries.AddXY(cdsStats.FieldByName('Week').AsFloat,
                    cdsStats.FieldByName('Week52').AsFloat,'',clTeeColor);
    end;
    cdsStats.Next;
  end;

end;

procedure TFrmMain.MonthCalendar1DblClick(Sender: TObject);
begin
  cdsRun.Insert;
  cdsRun.FieldByName('RunDate').AsDateTime := MonthCalendar1.Date;
  wwDBGrid1.SetFocus;
end;

procedure TFrmMain.csPageControl1Changing(Sender: TObject; NewIndex: Integer;
  var AllowChange: Boolean);
begin
  if NewIndex = 1 then
  begin
    cdsRun.Close;
    cdsRun.Open;
  end;
end;

procedure TFrmMain.actDeleteRecordExecute(Sender: TObject);
begin
  if MessageDlg('Are you sure ?',mtConfirmation, [mbYes, mbNo],0) = mrYes then
    cdsRun.Delete;
end;

procedure TFrmMain.ShowHints1Click(Sender: TObject);
begin
  ShowHints1.Checked := not ShowHints1.Checked;
  ShowHint := ShowHints1.Checked;
end;

procedure TFrmMain.actCloseExecute(Sender: TObject);
begin
  Close;
end;

procedure TFrmMain.wwDBGrid1CalcCellColors(Sender: TObject; Field: TField;
  State: TGridDrawState; Highlight: Boolean; AFont: TFont; ABrush: TBrush);
begin
  if DayOfWeek(cdsRunRunDate.AsDateTime) = 1 then
    ABrush.Color := clSkyBlue;
end;

end.
