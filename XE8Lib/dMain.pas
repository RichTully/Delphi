unit dMain;

interface

uses
  System.SysUtils, System.Classes, dAcc, Data.DB, Data.Win.ADODB;

type
  TdmMain = class(TDataModule)
    dbConn: TADOConnection;
  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  dmMain: TdmMain;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}



{$R *.dfm}

end.
