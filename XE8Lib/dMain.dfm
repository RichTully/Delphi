object dmMain: TdmMain
  OldCreateOrder = False
  Height = 150
  Width = 215
  object dbConn: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=masterkey;Persist Security Info=Tru' +
      'e;User ID=sa;Initial Catalog=Richard;Data Source=Windows8\SQLExp' +
      'ress'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 56
    Top = 48
  end
end
