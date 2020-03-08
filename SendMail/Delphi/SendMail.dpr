{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  29591: SendMail.dpr 
{
{   Rev 1.1    2003.11.29 10:35:22 AM  czhower
{ Update
}
{
{   Rev 1.1    2003.06.15 3:05:44 PM  czhower
{ Updated RES with icon
}
{
{   Rev 1.0    2003.06.15 12:11:12 PM  czhower
{ Initial checkin
}
program SendMail;

uses
  Forms,
  Main in 'Main.pas' {formMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TformMain, formMain);
  Application.Run;
end.
