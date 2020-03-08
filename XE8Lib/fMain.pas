unit fMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.ImageList,
  Vcl.ImgList, System.Actions, Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls,
  Vcl.ActnMan, Vcl.ToolWin, Vcl.ActnCtrls, Vcl.ActnMenus, Vcl.Menus,
  Vcl.ActnPopup;

type
  TfrmMain = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    btnSO: TButton;
    ActionToolBar1: TActionToolBar;
    ActionManager1: TActionManager;
    Action1: TAction;
    ImageList1: TImageList;
    Action2: TAction;
    Action3: TAction;
    Action4: TAction;
    PopupActionBar1: TPopupActionBar;
    Action31: TMenuItem;
    ActionMainMenuBar1: TActionMainMenuBar;
    N1: TMenuItem;
    Action32: TMenuItem;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure btnSOClick(Sender: TObject);
    procedure Action3Execute(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure Action2Execute(Sender: TObject);
  private
    procedure Execute(SQL: String);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses dAcc, uAcc;

procedure TfrmMain.Action1Execute(Sender: TObject);
begin
  showmessage('1');
end;

procedure TfrmMain.Action2Execute(Sender: TObject);
begin
  showmessage('2');
end;

procedure TfrmMain.Action3Execute(Sender: TObject);
begin
  Showmessage('3');
end;

procedure TfrmMain.btnSOClick(Sender: TObject);
var
  ASO: TSO;
  ASOL:TSalesOrd_Line;
  AFuncs: TFunctions;
begin
  try
   // AFuncs := TFunctions.Create(Execute, GetInteger, GetString, GetDateTime);
//    ASO:=TSO.Create(Self.Execute, 250);//
    ASO.Ref1 := 'Reference';
    ASO.Ref2 := 'Refer Two';
    //ASO.SubTotal := 100;
    ASOL := TSalesOrd_Line.Create('SCODE',4,26.5);
    ASOL.TaxRate := 15;
    ASO.Lines.Add(ASOL);
    ASOL := TSalesOrd_Line.Create('SCODE2',2,20.75);
    //ASOL.TaxRate := 15;
    ASO.Lines.Add(ASOL);
    ASO.InsertSQL;
    //ASO.Execute(ASo.InsertSQL);
    //MessageDlg(ASo.GetInfo, mtInformation, [mbOK],0);
    //MessageDlg(ASo.InsertSQL, mtInformation, [mbOK],0);
  finally
    ASO.Free;
  end;
end;

procedure TfrmMain.Execute(SQL: String);
begin
  MessageDlg('--------------'+#13+#13+SQL, mtInformation, [mbOK],0);
end;

procedure TfrmMain.Button1Click(Sender: TObject);
var
  AStr: string;
begin
  AStr := QU(GetConnStr);
  showmessage(AStr);
end;

procedure TfrmMain.Button2Click(Sender: TObject);
begin
  SetAccConn ('Test');
end;


procedure TfrmMain.Button3Click(Sender: TObject);
var
  AForm: TForm;
begin
  try
    AForm := TForm.Create(Self);
    begin
      with TButton.create(AForm) do
      begin
        Left := 30;
        Top := 30;
        Width := 50;
        Height := 40;
        Caption :='Test';
      end;
      AForm.ShowModal;
    end;
  finally
    AForm.Free;
  end;
end;

end.
