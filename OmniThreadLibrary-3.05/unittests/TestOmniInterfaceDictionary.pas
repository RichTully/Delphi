unit TestOmniInterfaceDictionary;
{

  Delphi DUnit Test Case
  ----------------------
  This unit contains a skeleton test case class generated by the Test Case Wizard.
  Modify the generated code to correctly setup and call the methods from the unit 
  being tested.

}

interface

uses
  TestFramework, GpStuff, Windows, TypInfo, DSiWin32, Classes, SysUtils, Variants,
  OtlCommon;

type
  // Test methods for class IOmniInterfaceDictionary

  TestIOmniInterfaceDictionary = class(TTestCase)
  strict private
    FIOmniInterfaceDictionary: IOmniInterfaceDictionary;
  strict protected
    procedure CheckContainsRange(low, high: integer);
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestClear;
    procedure TestCount;
    procedure TestEnumerate;
    procedure TestRemove1;
    procedure TestRemove2;
    procedure TestResize;
    procedure TestRetrieve1;
    procedure TestRetrieve2;
    procedure TestRetrieve3;
    procedure TestRetrieve4;
    procedure TestRetrieve5;
  end;

implementation

uses
  GpLists,
  GpStringHash,
  TestValue;

procedure TestIOmniInterfaceDictionary.CheckContainsRange(low, high: integer);
var
  i     : integer;
  keys  : IGpIntegerList;
  pair  : TOmniInterfaceDictionaryPair;
  values: IGpIntegerList;
begin
  CheckEquals(high-low+1, FIOmniInterfaceDictionary.Count);
  keys := TGpIntegerList.CreateInterface;
  values := TGpIntegerList.CreateInterface;
  for pair in FIOmniInterfaceDictionary do begin
    keys.Add(pair.Key);
    values.Add((pair.Value as ITestValue).Value);
  end;
  CheckEquals(high-low+1, keys.Count);
  CheckEquals(high-low+1, values.Count);
  for i := low to high do begin
    CheckEquals(keys[i-low], values[i-low]);
    CheckTrue(keys.Contains(i));
    CheckTrue(values.Contains(i));
  end;
end;

procedure TestIOmniInterfaceDictionary.SetUp;
begin
  FIOmniInterfaceDictionary := CreateInterfaceDictionary;
end;

procedure TestIOmniInterfaceDictionary.TearDown;
begin
  FIOmniInterfaceDictionary := nil;
  CheckEquals(0, GTestValueCount);
end;

procedure TestIOmniInterfaceDictionary.TestClear;
begin
  FIOmniInterfaceDictionary.Add(1, TTestValue.Create(1));
  FIOmniInterfaceDictionary.Clear;
  CheckEquals(0, FIOmniInterfaceDictionary.Count);
end;

procedure TestIOmniInterfaceDictionary.TestCount;
begin
  CheckEquals(0, FIOmniInterfaceDictionary.Count);
  FIOmniInterfaceDictionary.Add(1, TTestValue.Create(1));
  CheckEquals(1, FIOmniInterfaceDictionary.Count);
  FIOmniInterfaceDictionary.Clear;
  CheckEquals(0, FIOmniInterfaceDictionary.Count);
end;

procedure TestIOmniInterfaceDictionary.TestEnumerate;
const
  CNumElements = 3 ;
var
  i: integer;
begin
  for i := 1 to CNumElements do
    FIOmniInterfaceDictionary.Add(i, TTestValue.Create(i));
  CheckContainsRange(1, CNumElements);
end;

procedure TestIOmniInterfaceDictionary.TestRemove1;
begin
  FIOmniInterfaceDictionary.Add(1, TTestValue.Create(1));
  FIOmniInterfaceDictionary.Remove(1);
  CheckNull(FIOmniInterfaceDictionary.ValueOf(1));
  CheckEquals(0, FIOmniInterfaceDictionary.Count);
end;

procedure TestIOmniInterfaceDictionary.TestRemove2;
begin
  FIOmniInterfaceDictionary.Add(1, TTestValue.Create(1));
  FIOmniInterfaceDictionary.Remove(2);
  CheckNotNull(FIOmniInterfaceDictionary.ValueOf(1));
  CheckEquals(1, FIOmniInterfaceDictionary.Count);
end;

procedure TestIOmniInterfaceDictionary.TestResize;
var
  i          : integer;
  numElements: integer;
begin
  numElements := GetGoodHashSize(1) * 2;
  for i := 1 to numElements do
    FIOmniInterfaceDictionary.Add(i, TTestValue.Create(i));
  CheckContainsRange(1, numElements);
end;

procedure TestIOmniInterfaceDictionary.TestRetrieve1;
var
  retIntf: ITestValue;
begin
  FIOmniInterfaceDictionary.Add(1, TTestValue.Create(1));
  retIntf := FIOmniInterfaceDictionary.ValueOf(1) as ITestValue;
  CheckNotNull(retIntf);
  CheckEquals(1, retIntf.Value);
end;

procedure TestIOmniInterfaceDictionary.TestRetrieve2;
var
  retIntf: ITestValue;
begin
  FIOmniInterfaceDictionary.Add(1, TTestValue.Create(1));
  retIntf := FIOmniInterfaceDictionary.ValueOf(2) as ITestValue;
  CheckNull(retIntf);
end;

procedure TestIOmniInterfaceDictionary.TestRetrieve3;
var
  retIntf: ITestValue;
begin
  FIOmniInterfaceDictionary.Add(1, TTestValue.Create(1));
  FIOmniInterfaceDictionary.Add(2, TTestValue.Create(2));
  retIntf := FIOmniInterfaceDictionary.ValueOf(1) as ITestValue;
  CheckNotNull(retIntf);
  CheckEquals(1, retIntf.Value);
end;

procedure TestIOmniInterfaceDictionary.TestRetrieve4;
var
  retIntf: ITestValue;
begin
  FIOmniInterfaceDictionary.Add(2, TTestValue.Create(2));
  FIOmniInterfaceDictionary.Add(1, TTestValue.Create(1));
  retIntf := FIOmniInterfaceDictionary.ValueOf(1) as ITestValue;
  CheckNotNull(retIntf);
  CheckEquals(1, retIntf.Value);
end;

procedure TestIOmniInterfaceDictionary.TestRetrieve5;
var
  retIntf: ITestValue;
begin
  FIOmniInterfaceDictionary.Add(1, TTestValue.Create(1));
  FIOmniInterfaceDictionary.Add(1, TTestValue.Create(2));
  retIntf := FIOmniInterfaceDictionary.ValueOf(1) as ITestValue;
  CheckNotNull(retIntf);
  CheckEquals(2, retIntf.Value);
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TestIOmniInterfaceDictionary.Suite);
end.

