unit mainform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Grids, dateutils, zipper, LConvEncoding, IniFiles, LCLType;

type

  { Tmainfrm }

  Tmainfrm = class(TForm)
    DeleteFilesBtn: TButton;
    INIOpenDialog1: TOpenDialog;
    ReadINIBtn: TButton;
    INISaveDialog1: TSaveDialog;
    WriteINIBtn: TButton;
    ToFolderBtn: TButton;
    ToFolderLbl: TLabel;
    ZipBtn: TButton;
    DaysEdt: TEdit;
    listfiles2btn: TButton;
    DirectoryLbl: TLabel;
    SaveDialog1: TSaveDialog;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    StringGrid1: TStringGrid;
    procedure DeleteFilesBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ReadINIBtnClick(Sender: TObject);
    procedure ToFolderBtnClick(Sender: TObject);
    procedure WriteINIBtnClick(Sender: TObject);
    procedure ZipBtnClick(Sender: TObject);
    procedure listfiles2btnClick(Sender: TObject);
  private
    procedure Deleteselectedfiles;
    function getfilesinfolder2(folderstore: String; listboxstore: TListBox): TListBox;
    procedure getfilesinfolder(folderstr, daysstr: string);
    function LoadINI(INIFilename: string): boolean;
    procedure zipfiles(filename: string);
    { private declarations }
  public
    { public declarations }
  end;

var
  mainfrm: Tmainfrm;

implementation

{$R *.lfm}

{ Tmainfrm }



procedure Tmainfrm.ToFolderBtnClick(Sender: TObject);
begin
     if SelectDirectoryDialog1.Execute then
     begin
          ToFolderLbl.Caption := SelectDirectoryDialog1.FileName;
     end;
end;

procedure Tmainfrm.ReadINIBtnClick(Sender: TObject);
begin
     if INIOpenDialog1.execute then
     begin
       LoadINI(INIOpenDialog1.filename);
       getfilesinfolder(DirectoryLbl.Caption,DaysEdt.Text);
     end;
end;

procedure Tmainfrm.FormShow(Sender: TObject);
var
  logdata: TStringList;
begin
		logdata := TStringList.Create;
 		if fileexists(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'runlog.log') then
     	begin
     		logdata.LoadFromFile(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'runlog.log');
     	end;
        If ParamCount > 0 then
        begin
    		 if ParamStr(1) <> '' then
             begin
                If FileExists(ParamStr(1)) then
                begin
                    If LoadINI(ParamStr(1)) = false then
                    begin
                       logdata.Add(datetimetostr(now) + ':INI load failed');
                       logdata.SaveToFile(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'runlog.log');
                       Application.Terminate;
                    end
                    else
                    begin
                       	logdata.Add(datetimetostr(now) + ':INI load passed');
                        try
                        	getfilesinfolder(DirectoryLbl.Caption,DaysEdt.Text);
                        	if StringGrid1.Rowcount = 1 then
                        	begin
                        		logdata.Add(datetimetostr(now) + ':0 files zipped');
                                logdata.SaveToFile(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'runlog.log');
                                Application.Terminate;
                        	end
                        	else
                        	begin
                				zipfiles(includeTrailingPathDelimiter(ToFolderLbl.Caption) + FormatDateTime('yyyymmddhhmm',now) + '.zip');
                                Deleteselectedfiles();
                            	logdata.Add(datetimetostr(now) + ':Process completed');
                                logdata.SaveToFile(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'runlog.log');
                                Application.Terminate;
                        	end;
                        except
                          on E: Exception do
                          begin
                            logdata.Add(datetimetostr(now) + ':Process failed ->' + E.Message);
                            logdata.SaveToFile(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'runlog.log');
                            Application.Terminate;
                          end;
                        end;
                    end;
          		end
                else
                begin
                    logdata.Add(datetimetostr(now) + ':INI file not found');
               	    logdata.SaveToFile(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'runlog.log');
                    Application.Terminate;
                end;
             end
             else
             begin
                logdata.Add(datetimetostr(now) + ':INI file not found');
            	logdata.SaveToFile(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'runlog.log');
                Application.Terminate;
             end;
          end;
end;


procedure Tmainfrm.DeleteFilesBtnClick(Sender: TObject);
var
  Reply, BoxStyle: Integer;
begin
     BoxStyle := MB_ICONQUESTION + MB_YESNO;
     Reply := Application.MessageBox('Are you sure you want to delete the files', 'Message', BoxStyle);
     if Reply = IDYES then
     begin
     	Deleteselectedfiles();
     end;
end;

procedure Tmainfrm.WriteINIBtnClick(Sender: TObject);
var
  INI: TINIFile;
begin
     if INISaveDialog1.execute then
     begin
          INI := TINIFile.Create(INISaveDialog1.Filename);
          try
             INI.WriteString('zipdetail','fromfolder',DirectoryLbl.Caption);
             INI.WriteString('zipdetail','tofolder',ToFolderLbl.Caption);
             INI.WriteString('zipdetail','filesolderthan',DaysEdt.Text);
          finally
             INI.free;
          end;
     end;
end;

procedure Tmainfrm.ZipBtnClick(Sender: TObject);
begin
     if SaveDialog1.Execute then
     begin
        zipfiles(SaveDialog1.filename);
     end;
end;

procedure Tmainfrm.listfiles2btnClick(Sender: TObject);
begin
  if SelectDirectoryDialog1.Execute then
  begin
    getfilesinfolder(SelectDirectoryDialog1.filename,DaysEdt.Text);
  end;
end;

function Tmainfrm.getfilesinfolder2(folderstore:String; listboxstore:TListBox): TListBox;
var
  Info : TSearchRec;
  Count : Longint;
  tmplistbox : TListBox;
begin
     tmplistbox := listboxstore;
     Count:=0;
     If FindFirst (folderstore + '\*',faAnyFile and faDirectory,Info)=0 then
     begin
       Repeat
       Inc(Count);
       With Info do
       begin
            If (Attr and faDirectory) = faDirectory then
            begin
               tmplistbox.Items.Add('Dir : ' + folderstore + '\' + Name + ' -> filesize: ' + IntToStr(Size) + ' -> date: ' + datetostr(FileDateToDateTime(Time)));
            end
            else
               tmplistbox.Items.Add('File : ' + SelectDirectoryDialog1.FileName + '\' + Name + ' -> filesize: ' + IntToStr(Size) + ' -> date: ' + datetostr(FileDateToDateTime(Time)));
       end;
       Until FindNext(info)<>0;
     end;
     FindClose(Info);
     getfilesinfolder2 := tmplistbox;
end;

procedure Tmainfrm.getfilesinfolder(folderstr,daysstr: string);
var
  DirFiles: TStringList;
  fa, i, i2 : Longint;
begin
     DirFiles := FindAllFiles(folderstr, '*', true);
     try
        DirectoryLbl.Caption := folderstr;
        i2 := 1;
        for i := 0 to DirFiles.Count -1 do
        begin
             fa:=FileAge(DirFiles[i]);
             If FileDateToDateTime(fa) < date - StrtoInt(daysstr) then
             begin
                  StringGrid1.InsertRowWithValues(i2,[DirFiles[i],datetostr(FileDateToDateTime(fa))]);
                  i2 := i2 + 1;
             end;
        end;
     finally
            DirFiles.Free;
     end;
end;

procedure Tmainfrm.zipfiles(filename:string);
var
  OurZipper: TZipper;
  I: Integer;
  AArchiveFileName :String;
begin
          OurZipper := TZipper.Create;
          try
             OurZipper.FileName := filename;
             for I := 1 to StringGrid1.Rowcount -1 do
             begin
                  AArchiveFileName:=StringReplace(StringGrid1.Cells[0,I],includeTrailingPathDelimiter(DirectoryLbl.Caption),'',[rfReplaceall]);
                  AArchiveFileName:=SysToUTF8(AArchiveFileName);
                  AArchiveFileName:=UTF8ToCP866(AArchiveFileName);
               	  If fileexists(StringGrid1.Cells[0,I]) then
        		  begin
                  	OurZipper.Entries.AddFileEntry(StringGrid1.Cells[0,I],AArchiveFileName);
                  end;
             end;
             OurZipper.ZipAllFiles;
          finally
                 OurZipper.Free;
          end;
end;

function Tmainfrm.LoadINI (INIFilename: string): boolean;
var
  INI: TINIFile;
begin
     	LoadINI := false;
		INI := TINIFile.Create(INIFilename);
        try
        	DirectoryLbl.Caption := INI.ReadString('zipdetail','fromfolder','');
            ToFolderLbl.Caption := INI.ReadString('zipdetail','tofolder','');
            DaysEdt.text:= INI.ReadString('zipdetail','filesolderthan','');
        finally
            INI.free;
            LoadINI := true;
        end;
end;

procedure Tmainfrm.Deleteselectedfiles();
var
  I: Integer;
begin
     for I := 1 to StringGrid1.Rowcount -1 do
     begin
     	If fileexists(StringGrid1.Cells[0,I]) then
        begin
        	DeleteFile(StringGrid1.Cells[0,I]);
        end;
     end;
end;

end.

