unit fTest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Edit1: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    BS: String;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  j,i, ps, pe : integer;
const
  NFlds = 14;
  AKey : Array[0..13] of string =('Branch:','Claim Number:','Excess:','Urgent?:','Customer Name:','Preferred Phone:','Other Phone:','Street Address:','Suburb:','City/Town:','Damage Area:','Event Description:','Notes/Comments:','<P><BR><HR><FONT face=Arial size=2>The information contained in this email message');

begin
    //BS := 'Branch: 1 Claim Number: 2 Excess: 3 Urgent?: 4 Customer Name: 5  Preferred Phone: 6 Other Phone:'+' 7 Street Address: 8  Suburb: 9  City/Town: 10  Damage Area: 11  Event Description: 12  Notes/Comments: 13  <P><BR><HR><FONT face=Arial size=2>The information contained in this email message';
    BS := Edit1.Text;
    for j := 0 to Nflds - 1 do
    begin
      if pos(AKey[j], BS) = 0 then  // if it is zero it means that the particular identification phase is not found
        Memo1.Lines.Add(AKey[j]+'-'+ '')
      else
      begin
        ps := pos(AKey[j], BS) + length(AKey[j]);

                        // I think that this should deal with missing KEY descriptors in the email
        pe := 0;
        i := 1;
        while j+i <= Nflds - 1 do
        begin
          if pos(AKey[j+i],BS) > 0 then
          begin
            pe := pos(AKey[j+i],BS);
            break;
          end
          else
            inc(i);
        end;
        if pe = 0 then
          pe := length(BS);

        (*
        if j+1 <= Nflds - 1 then
          pe := pos(AKey[j+1],BS)
        else
          pe := length(BS);*)
        if ps > 0 then
          Memo1.Lines.Add(AKey[j]+'-'+ Copy(BS,ps,pe-ps));
      end;
    end;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  BS := 'Branch: 1 Claim Number: 2 Excess: 3 Urgent?: 4 Customer Name: 5  Preferred Phone: 6 Other Phone:'+' 7 Street Address: 8  Suburb: 9  City/Town: 10  Damage Area: 11  Event Description: 12  Notes/Comments: 13  <P><BR><HR><FONT face=Arial size=2>The information contained in this email message';
  edit1.Text := BS;
end;

end.
