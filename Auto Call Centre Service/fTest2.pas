unit fTest2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    Edit2: TEdit;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  S : String;
  function RemoveNum(S:String): String;
  var
    i,p: integer;
  const
    Digits: array[0..9] of Char = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9');
  begin
    for i:= 0 to 9 do
    begin
      p:=pos(Digits[i], S);
      while p > 0 do
      begin
        S := Copy (S,1,p-1)+Copy(S,p+1,length(S));
        p:=pos(Digits[i], S);
      end;
    end;   
    Result := S;
  end;
begin
  S:= Edit1.Text;
  Edit2.Text := RemoveNum(S);
end;

end.
