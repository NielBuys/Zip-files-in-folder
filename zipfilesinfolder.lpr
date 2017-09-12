program zipfilesinfolder;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, mainform
  { you can add units after this };

{$R *.res}

begin
  Application.Title:='Zip files in Folder';
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(Tmainfrm, mainfrm);
  mainfrm.startupcode;
  Application.Run;
end.

