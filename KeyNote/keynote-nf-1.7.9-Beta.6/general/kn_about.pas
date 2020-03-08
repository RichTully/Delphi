unit kn_about;

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
  Windows, Messages, SysUtils, Classes,
  Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, Menus,
  Clipbrd, ShellAPI, kn_Info,
  gf_misc, kn_NoteObj, TntMenus, TntStdCtrls;

type
  TAboutBox = class(TForm)
    BTN_Close: TSpeedButton;
    NetMenu: TTntPopupMenu;
    CopyEmailaddress1: TTntMenuItem;
    CopyuWebURL1: TTntMenuItem;
    N1: TTntMenuItem;
    Cancel1: TTntMenuItem;
    Panel_Main: TPanel;
    Label_Name: TTntLabel;
    Label_Desc: TTntLabel;
    Label_License: TTntLabel;
    Label9: TTntLabel;
    Label11: TTntLabel;
    Label_URL: TLabel;
    Label_MAILTO: TLabel;
    Label_Dart: TTntLabel;
    Image1: TImage;
    LB_RichEditVer: TTntLabel;
    Label_Credit2: TTntLabel;
    Label_Credit1: TTntLabel;
    Label3: TTntLabel;
    Label4: TTntLabel;
    Label_MAILTO2: TLabel;
    Label6: TTntLabel;
    Label_Version: TLabel;
    Image_Program: TImage;
    Label_Version_Date: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BTN_CloseClick(Sender: TObject);
    procedure Label_MAILTODblClick(Sender: TObject);
    procedure Label_URLDblClick(Sender: TObject);
    procedure CopyEmailaddress1Click(Sender: TObject);
    procedure CopyuWebURL1Click(Sender: TObject);
    procedure Label_MAILTOMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Label_MAILTOMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Image1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation
uses RxRichEd, kn_const, kn_Main;

{$R *.DFM}

var
  TahomaFontInstalled : boolean;

procedure TAboutBox.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TAboutBox.FormCreate(Sender: TObject);
var
  nameDLL, pathDLL: string;
  Icon: TIcon;

begin

  if TahomaFontInstalled then
    Self.Font.Name := 'Tahoma';

  Panel_Main.Color := _GF_CLWINDOW;
  Label_MAILTO.Font.Color := _GF_PURPLE;
  Label_MAILTO.Font.Style := [fsUnderline];
  Label_MAILTO2.Font.Color := _GF_PURPLE;
  Label_MAILTO2.Font.Style := [fsUnderline];
  Label_URL.Font.Color := _GF_PURPLE;
  Label_URL.Font.Style := [fsUnderline];
  Label_License.Font.Color := _GF_BLACK;
  Label_Dart.Font.Color := _GF_NAVY;

  GetDLLProductVersion(RichEditLibraryHandle, pathDLL);
  nameDLL := ' (' + ExtractFileName(pathDLL) + ')';

  LB_RichEditVer.Font.Style := [fsBold];
  LB_RichEditVer.Caption := Format(
    'RichEdit DLL ver: %.1f %s',
    [_LoadedRichEditVersion, nameDLL]
  );
  LB_RichEditVer.Hint:= pathDLL;

  Caption := 'About - ' + Program_Name;
  Label_Name.Caption := Program_Name;
  Label_Desc.Caption := Program_Desc;

  Label_License.Caption := Program_License;

  Label_Credit1.Caption := Program_Credit1;
  Label_Credit2.Caption := Program_Credit2;
  Label_Mailto2.Caption := Program_Email1;
  Label_Mailto.Caption := Program_Email2;
  Label_URL.Caption :=  Program_URL;

  Label_Version.Caption:= 'v.' + Program_Version;
  Label_Version.Left:= Label_Name.Left + Label_Name.Width + 10;

  Label_Version_Date.Caption:= '(' + Program_Version_Date + ')';
  Label_Version_Date.Left:= Label_Version.Left + Label_Version.Width + 10;

  Icon := TIcon.Create;
  try
    Icon.LoadFromResourceName(HInstance, 'MAINICON');
    Image_Program.Picture.Icon:= Icon;
  finally
    Icon.Free;
  end;
end;

procedure TAboutBox.BTN_CloseClick(Sender: TObject);
begin
  Close;
end;


procedure TAboutBox.Label_MAILTODblClick(Sender: TObject);
begin
  screen.Cursor := crHourGlass;
  ( sender as TLabel ).Font.Color := _GF_BLUE;
  ShellExecute( 0, 'open', PChar( 'mailto:' + ( sender as TLabel ).Caption ), nil, nil, SW_NORMAL );
  ( sender as TLabel ).Font.Color := _GF_PURPLE;
  screen.Cursor := crDefault;
end;

procedure TAboutBox.Label_URLDblClick(Sender: TObject);
begin
  screen.Cursor := crHourGlass;
  ( sender as TLabel ).Font.Color := _GF_BLUE;
  ShellExecute( 0, 'open', PChar( Label_URL.Caption ), nil, nil, SW_NORMAL );
  ( sender as TLabel ).Font.Color := _GF_PURPLE;
  screen.Cursor := crDefault;
end;

procedure TAboutBox.CopyEmailaddress1Click(Sender: TObject);
begin
  Clipboard.SetTextBuf( PChar( Label_MAILTO.Caption ));
end;

procedure TAboutBox.CopyuWebURL1Click(Sender: TObject);
begin
  Clipboard.SetTextBuf( PChar( Label_URL.Caption ));
end;

procedure TAboutBox.Label_MAILTOMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ( sender as TLabel ).Font.Color := _GF_BLUE;
end;

procedure TAboutBox.Label_MAILTOMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ( sender as TLabel ).Font.Color := _GF_PURPLE;
end;


procedure TAboutBox.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    27 : if ( shift = [] ) then
    begin
      key := 0;
      Close;
    end;
  end;
end; // KEY DOWN

procedure TAboutBox.Image1DblClick(Sender: TObject);
begin
  screen.Cursor := crHourGlass;
  ShellExecute( 0, 'open', 'http://www.embarcadero.com', nil, nil, SW_NORMAL );
  screen.Cursor := crDefault;
end;

end.
