unit kn_URL;

(****** LICENSE INFORMATION **************************************************
 
 - This Source Code Form is subject to the terms of the Mozilla Public
 - License, v. 2.0. If a copy of the MPL was not distributed with this
 - file, You can obtain one at http://mozilla.org/MPL/2.0/.           
 
------------------------------------------------------------------------------
 (c) 2000-2005 Marek Jedlinski <marek@tranglos.com> (Poland)
 (c) 2007-2015 Daniel Prado Velasco <dprado.keynote@gmail.com> (Spain) [^]

 [^]: Changes since v. 1.7.0. Fore more information, please see 'README.md'
     and 'doc/README_SourceCode.txt' in https://github.com/dpradov/keynote-nf      
   
 *****************************************************************************) 

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,
  registry, gf_misc, kn_Info, kn_const, TntStdCtrls;

type
  TForm_URLAction = class(TForm)
    Button_Copy: TTntButton;
    Button_Cancel: TTntButton;
    Label1: TTntLabel;
    Button_Open: TTntButton;
    Button_OpenNew: TTntButton;
    Edit_URL: TTntEdit;
    Label2: TTntLabel;
    Edit_TextURL: TTntEdit;
    Button_Modify: TTntButton;
    procedure CheckURL(OnlyEnsureLink: boolean);
    procedure Edit_URLExit(Sender: TObject);
    procedure Button_ModifyClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button_CopyClick(Sender: TObject);
    procedure Button_OpenClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button_OpenNewClick(Sender: TObject);
    procedure Label_URLClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    URLAction : TURLAction;
    AllowURLModification: boolean;      // URL, not the text associated
  end;


function FileNameToURL( fn : wideString ) : wideString;
function HTTPDecode(const AStr: wideString): wideString;
function HTTPEncode(const AStr: wideString): wideString;

function StripFileURLPrefix( const AStr : wideString ) : wideString;

implementation
uses
  RxRichEd, kn_Global, kn_LinksMng;

{$R *.DFM}

resourcestring
  STR_01 = 'OK';
  STR_02 = 'Create Hyperlink';
  STR_03 = 'Modify';
  STR_04 = 'Choose Action for Hyperlink';
  STR_05 = '(KNT Location)';


function FileNameToURL( fn : wideString ) : wideString;
var
  i : integer;
begin
  result := '';
  for i := 1 to length( fn ) do
  begin
    if  ( fn[i] in [' ', '%', '|'] ) then
    begin
      result := result + '%' + IntToHex( ord( fn[i] ), 2 );
    end
    else
    begin
      result := result + fn[i];
    end;
  end;
end; // FileNameToURL


function HTTPDecode(const AStr: wideString): wideString;
// source: Borland Delphi 5
var
  Sp, Rp, Cp: PWideChar;
begin
  try
      SetLength(Result, Length(AStr));
      Sp := PWideChar(AStr);
      Rp := PWideChar(Result);
      while Sp^ <> #0 do
      begin
        if not (Sp^ in ['+','%']) then
          Rp^ := Sp^
        else
          begin
            inc(Sp);
            if Sp^ = '%' then
              Rp^ := '%'
            else
            begin
              Cp := Sp;
              Inc(Sp);
              Rp^ := WideChar(Chr(StrToInt(WideFormat('$%s%s',[Cp^, Sp^]))));
            end;
          end;
        Inc(Rp);
        Inc(Sp);
      end;
      SetLength(Result, Rp - PWideChar(Result));

  except
      Result:= AStr;   // It will be assumed that the filename includes plus sign but it is not URL encoded.
  end;
end;

function HTTPEncode(const AStr: wideString): wideString;
// source: Borland Delphi 5, **modified**
const
  NoConversion = ['A'..'Z','a'..'z','*','@','.','_','-', '/', '?',
                  '0'..'9','$','!','''','(',')'];
var
  Sp, Rp: PWideChar;
begin
  SetLength(Result, Length(AStr) * 3);
  Sp := PWideChar(AStr);
  Rp := PWideChar(Result);
  while Sp^ <> #0 do
  begin
    if Sp^ in NoConversion then
      Rp^ := Sp^
    else
      begin
        FormatBuf(Rp^, 3, '%%%.2x', 6, [Ord(Sp^)]);
        Inc(Rp,2);
      end;
    Inc(Rp);
    Inc(Sp);
  end;
  SetLength(Result, Rp - PWideChar(Result));
end;



procedure TForm_URLAction.FormCreate(Sender: TObject);
begin
  URLAction := low( urlOpen );
  // Label_URL.Font.Color := clBlue;
  // Label_URL.Font.Style := [fsUnderline];
  Edit_URL.Font.Name := 'Tahoma';
  // Edit_URL.Font.Style := [fsBold];
  if ( Edit_URL.Font.Size < 10 ) then
      Edit_URL.Font.Size := 10;

  Edit_TextURL.Font.Name := 'Tahoma';
  if ( Edit_TextURL.Font.Size < 10 ) then
      Edit_TextURL.Font.Size := 10;

  if RichEditVersion < 4 then begin
    Edit_TextURL.Enabled := false;
    label2.Enabled := false;
  end;
  AllowURLModification:= True;
end;

procedure TForm_URLAction.Button_CopyClick(Sender: TObject);
begin
  URLAction := urlCopy;
end;

procedure TForm_URLAction.Button_ModifyClick(Sender: TObject);
begin
     if Edit_TextURL.Text = '' then
        CheckURL(true);
     URLAction := urlCreateOrModify;
end;

procedure TForm_URLAction.Button_OpenClick(Sender: TObject);
begin
  URLAction := urlOpen;
end;

procedure TForm_URLAction.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    27 : if ( shift = [] ) then
    begin
      key := 0;
      Close;
    end;
  end;
end;

procedure TForm_URLAction.FormKeyPress(Sender: TObject; var Key: Char);
begin
    if not Button_Modify.Default then begin
       Button_Modify.Default := true;
       Button_Open.Default := false;
    end;

end;

procedure TForm_URLAction.FormShow(Sender: TObject);
begin

   // Look to the default, initial action
     if URLAction = urlCreateOrModify then begin
        Button_Copy.Visible := false;
        Button_Open.Visible := false;
        Button_OpenNew.Visible := false;
        Button_Modify.Caption := STR_01;
        Button_Modify.Default := true;
        Caption:= STR_02;
     end
     else begin
        Button_Copy.Visible := true;
        Button_Open.Visible := true;
        Button_OpenNew.Visible := true;
        Button_Modify.Caption := STR_03;
        Button_Open.Default := true;
        Caption:= STR_04;
     end;

      if AllowURLModification then begin
        Edit_URL.ReadOnly:= False;
        Edit_URL.SelectAll;
      end
      else begin
        Edit_URL.Text:= STR_05 + ' ' + Edit_URL.Text;
        Edit_URL.ReadOnly:= True;
        Edit_TextURL.SetFocus;
        Edit_TextURL.SelectAll;
      end;

      {
      if (RichEditVersion < 4) or (ActiveNote.PlainText) then begin
        Edit_TextURL.Text:= '';
        Label2.Enabled:= false;
        Edit_TextURL.Enabled:= false;
        if not AllowURLModification then Button_Modify.Enabled:= false;
      end;
      }

      if (Edit_URL.Text = '') or (not Edit_TextURL.Enabled) then
          Edit_URL.SetFocus
      else
          Edit_TextURL.SetFocus;

end;

// KEY DOWN


procedure TForm_URLAction.Button_OpenNewClick(Sender: TObject);
begin
  URLAction := urlOpenNew;
end;

{
 Revisa el campo TextURL, igual�ndolo al campo URL si est� vac�o
 OnlyEnsureLink: Si True, s�lo modifica el campo si no es posible dejar �nicamente el campo
    URL sin texto asociado (v�a HYPERLINK "...) al tratarse de tipo de URL no reconocido por RichEdit o
    tener alg�n problema con su �ltimo car�cter.
}
procedure TForm_URLAction.CheckURL(OnlyEnsureLink: boolean);
var
  url: wideString;
  InterpretedUrl: wideString;
  KNTlocation, EnsureLink: boolean;
  URLType: TKNTURL;
  lastChar: WideChar;
begin
 if not Edit_TextURL.Enabled then exit;

 if Edit_TextURL.Text = '' then begin
    EnsureLink:= False;
    url:= Edit_URL.Text;
    if ( pos(STR_05, url) = 1 ) then
        delete( url, 1, length( STR_05 ));

     url:= trim(url);
     if url='' then exit;

     InterpretedUrl:= url;
     URLType:= TypeURL( InterpretedUrl, KNTlocation);
     lastChar:= url[length(url)];
     if (URLType = urlOTHER) or (( URLType in [urlHTTP, urlHTTPS]) and ( lastChar in [')', ']'] ))  then begin
         // Si el texto es igual a la URL, y no es de los reconocidos por el control RichEdit (http://msdn.microsoft.com/en-us/library/windows/desktop/bb787991%28v=vs.85%29.aspx)
         // no lo tratar� como hiperlenlace
         // Tambi�n deja sin reconocer el �ltimo car�cter si �ste es ) o ], como m�nimo
        url:= '<' + url + '>';
        EnsureLink:= True;
     end
     else
         if url <> interpretedUrl then begin
            Edit_URL.Text:= interpretedUrl;
         end;

    if (Not OnlyEnsureLink) or (EnsureLink= True) then
       Edit_TextURL.Text:= url;
 end;
end;

procedure TForm_URLAction.Edit_URLExit(Sender: TObject);
begin
  CheckURL(false);
end;


procedure TForm_URLAction.Label_URLClick(Sender: TObject);
begin
  if ShiftDown then
    URLAction := urlOpenNew
  else
    URLAction := urlOpen;
  ModalResult := mrOK;
end;

function StripFileURLPrefix( const AStr : WideString ) : wideString;
const
  FILEPREFIX = 'file:';
var
  l, i, n: integer;
begin
  // In URLs like file://192.168.1.1/..... we must preserve the prefix
  // We can eliminate it in URLs like file:///C:.....
  result := AStr;

  if ( pos( FILEPREFIX, wideLowerCase( result )) = 1 ) then
  begin
    i:= length( FILEPREFIX)+1;
    l:= length(result);
    n:= 0;
    while (i <= l) and ( result[i] = '/' ) do begin
        i:= i + 1;
        n:= n + 1;
    end;

    if (n <> 2) or ( ( l>i+1 ) and (result[i+1]=':')) then
       delete( result, 1, i-1);
  end;
end; // StripFileURLPrefix

end.
