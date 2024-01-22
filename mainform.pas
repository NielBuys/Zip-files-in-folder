unit mainform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Grids, dateutils, zipper, LConvEncoding, IniFiles, LCLType,
  ComCtrls, Buttons, ExtCtrls, LazUTF8;

type

  { Tmainfrm }

  Tmainfrm = class(TForm)
    CopyFilePreservetime: TCheckBox;
    CopyFileOverwrite: TCheckBox;
    CopyFilesBtn: TButton;
    CancelRunBtn: TBitBtn;
    CopyFileCancelRunBtn: TBitBtn;
    CopyFileDaysEdt: TEdit;
    CopyFileFilenameStructureEdt: TEdit;
    IncludeSubFolderCheck: TCheckBox;
    CopyFileslistfilesbtn: TButton;
    OnlyNewestFileCheck: TCheckBox;
    CopyFileIncludeSubFolderCheck: TCheckBox;
    DaysEdt: TEdit;
    DaysLabel: TLabel;
    DaysLbl: TLabel;
    DeleteEmptyfoldersBtn: TButton;
    deleteemptyfolderscheck: TCheckBox;
    DeleteFilesBtn: TButton;
    deletefileswithruncheck: TCheckBox;
    DirectoryLbl: TLabel;
    CopyFilesSearchMaskEdit: TEdit;
    CopyFileDirectoryLbl: TLabel;
    listfiles2btn: TButton;
    PageControl1: TPageControl;
    ReadINIBtn: TButton;
    CopyFileReadINIBtn: TButton;
    SearchMaskEdit: TEdit;
    StatusLbl: TLabel;
    CopyFileStatusLbl: TLabel;
    StringGrid1: TStringGrid;
    CopyFilesSheet: TTabSheet;
    CopyFileStringGrid: TStringGrid;
    CopyFileWriteINIBtn: TButton;
    CopyFileToFolderLbl: TLabel;
    CopyFileToFolderBtn: TButton;
    ZipFilesinFolderSheet: TTabSheet;
    INIOpenDialog1: TOpenDialog;
    ProgressBar1: TProgressBar;
    INISaveDialog1: TSaveDialog;
    ToFolderBtn: TButton;
    SaveDialog1: TSaveDialog;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    ToFolderLbl: TLabel;
    WriteINIBtn: TButton;
    ZipBtn: TButton;
    zipfileswithruncheck: TCheckBox;
    procedure CancelRunBtnClick(Sender: TObject);
    procedure CopyFileReadINIBtnClick(Sender: TObject);
    procedure CopyFilesBtnClick(Sender: TObject);
    procedure CopyFileslistfilesbtnClick(Sender: TObject);
    procedure CopyFileToFolderBtnClick(Sender: TObject);
    procedure CopyFileWriteINIBtnClick(Sender: TObject);
    procedure DeleteEmptyfoldersBtnClick(Sender: TObject);
    procedure DeleteFilesBtnClick(Sender: TObject);
    procedure ReadINIBtnClick(Sender: TObject);
    procedure ToFolderBtnClick(Sender: TObject);
    procedure WriteINIBtnClick(Sender: TObject);
    procedure ZipBtnClick(Sender: TObject);
    procedure listfiles2btnClick(Sender: TObject);
  private
    procedure copyfilesgetfilesinfolder(folderstr,daysstr,searchmask: string; includesubfolders, onlynewestfile, progressbar:boolean);
    function CopyListofFiles(progressbar:boolean): boolean;
    function deleteemptydirectories(folderstr: string;progressbar:boolean): boolean;
    procedure Deleteselectedfiles(progressbar:boolean);
    procedure getfilesinfolder(folderstr,daysstr,searchmask: string; includesubfolders,progressbar:boolean);
    function LoadINI(INIFilename: string): boolean;
    function WriteINI(INIFilename: string): boolean;
    procedure zipfiles(filename: string; progressbar:boolean);
    { private declarations }
  public
    procedure startupcode;
    { public declarations }
  end;

var
  mainfrm: Tmainfrm;
  CancelRunBool: Boolean;

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
       getfilesinfolder(DirectoryLbl.Caption,DaysEdt.Text, SearchMaskEdit.Text, IncludeSubFolderCheck.Checked, True);
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
     	Deleteselectedfiles(True);
        showmessage('Process completed');
     end;
end;

procedure Tmainfrm.DeleteEmptyfoldersBtnClick(Sender: TObject);
begin
     deleteemptydirectories(DirectoryLbl.Caption, True);
     showmessage('Process completed');
end;

procedure Tmainfrm.CancelRunBtnClick(Sender: TObject);
begin
    CancelRunBool := True;
end;

procedure Tmainfrm.CopyFileReadINIBtnClick(Sender: TObject);
begin
     if INIOpenDialog1.execute then
     begin
       LoadINI(INIOpenDialog1.filename);
       copyfilesgetfilesinfolder(CopyFileDirectoryLbl.Caption, CopyFileDaysEdt.Text, CopyFilesSearchMaskEdit.text,
          CopyFileIncludeSubFolderCheck.checked, OnlyNewestFileCheck.checked, true);
     end;
end;

procedure Tmainfrm.CopyFilesBtnClick(Sender: TObject);
begin
     CopyListofFiles(true);
end;

procedure Tmainfrm.CopyFileslistfilesbtnClick(Sender: TObject);
begin
     if SelectDirectoryDialog1.Execute then
     begin
       copyfilesgetfilesinfolder(SelectDirectoryDialog1.filename, CopyFileDaysEdt.Text, CopyFilesSearchMaskEdit.text,
          CopyFileIncludeSubFolderCheck.checked, OnlyNewestFileCheck.checked, true);
     end;
end;

procedure Tmainfrm.CopyFileToFolderBtnClick(Sender: TObject);
begin
     if SelectDirectoryDialog1.Execute then
     begin
          CopyFileToFolderLbl.Caption := SelectDirectoryDialog1.FileName;
     end;
end;

procedure Tmainfrm.CopyFileWriteINIBtnClick(Sender: TObject);
begin
     if INISaveDialog1.execute then
     begin
        WriteINI(INISaveDialog1.filename);
     end;
end;
procedure Tmainfrm.WriteINIBtnClick(Sender: TObject);
begin
     if INISaveDialog1.execute then
     begin
        WriteINI(INISaveDialog1.filename);
     end;
end;

procedure Tmainfrm.ZipBtnClick(Sender: TObject);
begin
     if SaveDialog1.Execute then
     begin
        zipfiles(SaveDialog1.filename,True);
        showmessage('Process completed');
     end;
end;

procedure Tmainfrm.listfiles2btnClick(Sender: TObject);
begin
  if SelectDirectoryDialog1.Execute then
  begin
    getfilesinfolder(SelectDirectoryDialog1.filename,DaysEdt.Text, SearchMaskEdit.Text, IncludeSubFolderCheck.Checked, True);
  end;
end;


procedure Tmainfrm.getfilesinfolder(folderstr,daysstr,searchmask: string; includesubfolders,progressbar:boolean);
var
  DirFiles: TStringList;
  fa, i, i2 : Longint;
begin
     DirFiles := FindAllFiles(folderstr, searchmask, includesubfolders);
     try
        If progressbar = true then
        begin
          ProgressBar1.Max:= DirFiles.Count -1;
          ProgressBar1.Position:= 0;
          CancelRunBool := False;
          CancelRunBtn.Enabled := True;
          StatusLbl.Caption := 'Status: Searching for valid files ...';
        end;
        StringGrid1.Clear;
        StringGrid1.Rowcount := 1;
        DirectoryLbl.Caption := folderstr;
        i2 := 1;
        for i := 0 to DirFiles.Count -1 do
        begin
             fa:=FileAge(DirFiles[i]);
             If (FileDateToDateTime(fa) < date - StrtoInt(daysstr)) or (StrtoInt(daysstr) = 0) then
             begin
                  StringGrid1.InsertRowWithValues(i2,[DirFiles[i],FormatDateTime('yyyy-mm-dd hh:nn',FileDateToDateTime(fa))]);
                  i2 := i2 + 1;
             end;
             If progressbar = true then
             begin
               ProgressBar1.Position:=i;
               if CancelRunBool then
               begin
                  CancelRunBtn.Enabled := False;
                  break;
               end;
               Application.ProcessMessages;
             end;
        end;
        If progressbar = true then
        begin
          CancelRunBtn.Enabled := False;
          StatusLbl.Caption := 'Status: Search for files has completed';
        end;
     finally
            DirFiles.Free;
     end;
end;

procedure Tmainfrm.copyfilesgetfilesinfolder(folderstr,daysstr,searchmask: string; includesubfolders, onlynewestfile, progressbar:boolean);
var
  DirFiles: TStringList;
  fa, i, i2, newestfilei : Longint;
  filefolderstr: String;
  newestfiledfbool:boolean;
begin
     DirFiles := FindAllFiles(folderstr, searchmask, includesubfolders);
     try
        If progressbar = true then
        begin
          ProgressBar1.Max:= DirFiles.Count -1;
          ProgressBar1.Position:= 0;
          CancelRunBool := False;
          CopyFileCancelRunBtn.Enabled := True;
          CopyFileStatusLbl.Caption := 'Status: Searching for valid files ...';
        end;
        CopyFileStringGrid.Clear;
        CopyFileStringGrid.Rowcount := 1;
        CopyFileDirectoryLbl.Caption := folderstr;
        i2 := 1;
        for i := 0 to DirFiles.Count -1 do
        begin
             fa := FileAge(DirFiles[i]);
             filefolderstr := ExtractFileDir(DirFiles[i]);
             If (FileDateToDateTime(fa) > date - StrtoInt(daysstr)) or (StrtoInt(daysstr) = 0) then
             begin
               If onlynewestfile = true then
               begin
                  newestfiledfbool := false;
                  for newestfilei := 0 to CopyFileStringGrid.RowCount - 1 do
                  begin
           //          showmessage(CopyFileStringGrid.Cells[2,newestfilei]);
                     if (CopyFileStringGrid.Cells[2,newestfilei] = filefolderstr) then
                     begin
                       newestfiledfbool := true;
                       if (FormatDateTime('yyyy-mm-dd hh:nn',FileDateToDateTime(fa)) > CopyFileStringGrid.Cells[1,newestfilei]) then
                       begin
                        CopyFileStringGrid.Cells[0,newestfilei] := DirFiles[i];
                        CopyFileStringGrid.Cells[1,newestfilei] := FormatDateTime('yyyy-mm-dd hh:nn',FileDateToDateTime(fa));
           //             CopyFileStringGrid.InsertRowWithValues(newestfilei,[DirFiles[i],FormatDateTime('yyyy-mm-dd hh:nn',FileDateToDateTime(fa)),filefolderstr]);
                        break;
                       end;
                     end;
                  end;
                  if newestfiledfbool = false then
                  begin
                    CopyFileStringGrid.InsertRowWithValues(CopyFileStringGrid.RowCount,[DirFiles[i],FormatDateTime('yyyy-mm-dd hh:nn',FileDateToDateTime(fa)),filefolderstr]);
                  end;
                  i2 := i2 + 1;
               end
               else
               begin
                   CopyFileStringGrid.InsertRowWithValues(i2,[DirFiles[i],FormatDateTime('yyyy-mm-dd hh:nn',FileDateToDateTime(fa)),filefolderstr]);
                   i2 := i2 + 1;
               end;
             end;
             If progressbar = true then
             begin
               ProgressBar1.Position:=i;
               if CancelRunBool then
               begin
                  CopyFileCancelRunBtn.Enabled := False;
                  break;
               end;
               Application.ProcessMessages;
             end;
        end;
        If progressbar = true then
        begin
          CopyFileCancelRunBtn.Enabled := False;
          CopyFileStatusLbl.Caption := 'Status: Search for files has completed';
        end;
     finally
            DirFiles.Free;
     end;
end;

procedure Tmainfrm.zipfiles(filename:string; progressbar:boolean);
var
  OurZipper: TZipper;
  I: Integer;
  AArchiveFileName :String;
  BreakedRun: Boolean;
begin
     If progressbar = true then
     begin
          ProgressBar1.Max:=StringGrid1.Rowcount -1;
          ProgressBar1.Position:= 0;
          StatusLbl.Caption := 'Status: Adding Files to Compress ...';
          CancelRunBool := False;
          CancelRunBtn.Enabled := True;
          BreakedRun := False;
     end;
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
                  If progressbar = true then
                  begin
                    ProgressBar1.Position:=I;
                    if CancelRunBool then
                    begin
                        BreakedRun := True;
                        CancelRunBtn.Enabled := False;
                        break;
                    end;
                    Application.ProcessMessages;
                  end;
             end;
             If progressbar = true then
             begin
               CancelRunBtn.Enabled := False;
               StatusLbl.Caption := 'Status: Compressing Added Files ...';
               Application.ProcessMessages;
             end;
             if not BreakedRun then
             begin
               OurZipper.ZipAllFiles;
             end;
             If progressbar = true then
             begin
               StatusLbl.Caption := 'Status: Finished with the Compression';
             end;
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
           DirectoryLbl.Caption := INI.ReadString('zipdetail','fromfolder','Nothing selected.');
           SearchMaskEdit.Text := INI.ReadString('zipdetail','searchmask','*');
           ToFolderLbl.Caption := INI.ReadString('zipdetail','tofolder','No To folder yet');
           DaysEdt.text:= INI.ReadString('zipdetail','filesolderthan','90');
           zipfileswithruncheck.checked := StrtoBool(INI.ReadString('zipdetail','zipfileswithrun','0'));
           deletefileswithruncheck.checked := StrtoBool(INI.ReadString('zipdetail','deletefileswithrun','0'));
           deleteemptyfolderscheck.checked := StrtoBool(INI.ReadString('zipdetail','deleteemptyfolders','0'));
           IncludeSubFolderCheck.checked := StrtoBool(INI.ReadString('zipdetail','includesubfolders','1'));

           CopyFileDirectoryLbl.Caption := INI.ReadString('copyfiledetail','fromfolder','Nothing selected.');
           CopyFilesSearchMaskEdit.Text := INI.ReadString('copyfiledetail','searchmask','*');
           CopyFileToFolderLbl.Caption := INI.ReadString('copyfiledetail','tofolder','No To folder yet');
           CopyFileDaysEdt.text:= INI.ReadString('copyfiledetail','filesnewerthan','90');
           CopyFileIncludeSubFolderCheck.checked := StrtoBool(INI.ReadString('copyfiledetail','includesubfolders','1'));
           OnlyNewestFileCheck.checked := StrtoBool(INI.ReadString('copyfiledetail','onlynewestfileinfolder','0'));
           CopyFileOverwrite.checked := StrtoBool(INI.ReadString('copyfiledetail','overwrite','0'));
           CopyFilePreservetime.checked := StrtoBool(INI.ReadString('copyfiledetail','preservetime','1'));
           CopyFileFilenameStructureEdt.Text := INI.ReadString('copyfiledetail','filenamestructure','');
        finally
           INI.free;
           LoadINI := true;
        end;
end;

function Tmainfrm.WriteINI (INIFilename: string): boolean;
var
  INI: TINIFile;
begin
     	WriteINI := false;
        INI := TINIFile.Create(INISaveDialog1.Filename);
        try
           INI.WriteString('zipdetail','fromfolder',DirectoryLbl.Caption);
           INI.WriteString('zipdetail','searchmask',SearchMaskEdit.Text);
           INI.WriteString('zipdetail','tofolder',ToFolderLbl.Caption);
           INI.WriteString('zipdetail','filesolderthan',DaysEdt.Text);
           INI.WriteString('zipdetail','zipfileswithrun',BooltoStr(zipfileswithruncheck.Checked));
           INI.WriteString('zipdetail','deletefileswithrun',BooltoStr(deletefileswithruncheck.Checked));
           INI.WriteString('zipdetail','deleteemptyfolders',BooltoStr(deleteemptyfolderscheck.Checked));
           INI.WriteString('zipdetail','includesubfolders',BooltoStr(IncludeSubFolderCheck.Checked));

           INI.WriteString('copyfiledetail','fromfolder',CopyFileDirectoryLbl.Caption);
           INI.WriteString('copyfiledetail','searchmask',CopyFilesSearchMaskEdit.Text);
           INI.WriteString('copyfiledetail','tofolder',CopyFileToFolderLbl.Caption);
           INI.WriteString('copyfiledetail','filesnewerthan',CopyFileDaysEdt.Text);
           INI.WriteString('copyfiledetail','includesubfolders',BooltoStr(CopyFileIncludeSubFolderCheck.Checked));
           INI.WriteString('copyfiledetail','onlynewestfileinfolder',BooltoStr(OnlyNewestFileCheck.Checked));
           INI.WriteString('copyfiledetail','overwrite',BooltoStr(CopyFileOverwrite.Checked));
           INI.WriteString('copyfiledetail','preservetime',BooltoStr(CopyFilePreservetime.Checked));
           INI.WriteString('copyfiledetail','filenamestructure',CopyFileFilenameStructureEdt.Text);
        finally
           INI.free;
           WriteINI := true;
        end;
end;

procedure Tmainfrm.Deleteselectedfiles(progressbar:boolean);
var
  I: Integer;
begin
     If progressbar = true then
     begin
         ProgressBar1.Max:=StringGrid1.Rowcount -1;
         ProgressBar1.Position:= 0;
         CancelRunBool := False;
         CancelRunBtn.Enabled := True;
         StatusLbl.Caption := 'Status: Busy deleting files ...';
     end;
     for I := 1 to StringGrid1.Rowcount -1 do
     begin
        If fileexists(StringGrid1.Cells[0,I]) then
        begin
          if not DeleteFile(StringGrid1.Cells[0,I]) then
          begin
            If progressbar = true then
            begin
               showmessage(ExtractFileName(StringGrid1.Cells[0,I]) + ' - ' + SysErrorMessage(GetLastOSError));
            end;
          end;
        end;
        If progressbar = true then
        begin
          ProgressBar1.Position:=I;
          if CancelRunBool then
          begin
            CancelRunBtn.Enabled := False;
            break;
          end;
          Application.ProcessMessages;
        end;
     end;
     If progressbar = true then
     begin
       CancelRunBtn.Enabled := False;
       StatusLbl.Caption := 'Status: Deleting of files completed';
     end;
end;

function tmainfrm.deleteemptydirectories(folderstr:string;progressbar:boolean): boolean;
var
     FoldersList: TStringList;
     DirFiles: TStringList;
     i, i2, countfiles : Longint;
begin
     FoldersList := FindAllDirectories(folderstr);
     If progressbar = true then
     begin
         ProgressBar1.Max:=FoldersList.Count -1;
         ProgressBar1.Position:= 0;
         CancelRunBool := False;
         CancelRunBtn.Enabled := True;
         StatusLbl.Caption := 'Status: Busy deleting empty folders ...';
     end;
     deleteemptydirectories := false;
     try
        i2 := 1;
        for i := 0 to FoldersList.Count -1 do
        begin
            DirFiles := FindAllFiles(FoldersList[i], '*', true);
            countfiles := DirFiles.Count;
            if countfiles = 0 then
            begin
            	DeleteDirectory(FoldersList[i],false);
            end;
            i2 := i2 + 1;
            If progressbar = true then
            begin
              ProgressBar1.Position:=i;
              if CancelRunBool then
              begin
                CancelRunBtn.Enabled := False;
                break;
              end;
              Application.ProcessMessages;
            end;
        end;
        If progressbar = true then
        begin
          CancelRunBtn.Enabled := False;
          StatusLbl.Caption := 'Status: Deleting of empty folders completed';
        end;
     finally
        FoldersList.Free;
        DirFiles.Free;
        deleteemptydirectories := true;
     end;
end;

function tmainfrm.CopyListofFiles(progressbar:boolean): boolean;
var
  ok:boolean;
  fromfile,tofile,topmostfolder, fileextension: string;
  i: integer;
begin
     Result := false;
     if CopyFileStringGrid.RowCount = 1 then
     begin
       If progressbar = true then
       begin
         CopyFileStatusLbl.Caption := 'Status: Nothing to Copy';
       end;
       exit;
     end;
     If progressbar = true then
     begin
         ProgressBar1.Max:=CopyFileStringGrid.Rowcount -1;
         ProgressBar1.Position:= 0;
         CancelRunBool := False;
         CopyFileCancelRunBtn.Enabled := True;
         CopyFileStatusLbl.Caption := 'Status: Busy copying files ...';
     end;
     if (DirectoryExists(CopyFileToFolderLbl.Caption) = false) then
     begin
       If progressbar = true then
       begin
         CopyFileStatusLbl.Caption := 'Status: To folder do not exist';
       end;
       exit;
     end;
     try
       for i := 1 to CopyFileStringGrid.RowCount -1 do
       begin
  //       showmessage(CopyFileStringGrid.Cells[0,i]);
         If fileexists(CopyFileStringGrid.Cells[0,i]) then
         begin
            fromfile:=SysToUTF8(CopyFileStringGrid.Cells[0,i]);
            fromfile:=UTF8ToCP866(fromfile);
            topmostfolder := ExtractFileName(ExcludeTrailingPathDelimiter(ExtractFilePath(fromfile)));
            fileextension := ExtractFileExt(fromfile);
            if (CopyFileFilenameStructureEdt.Text = '') then
              tofile := stringReplace(fromfile , CopyFileDirectoryLbl.Caption, CopyFileToFolderLbl.Caption, [rfIgnoreCase])
            else
            begin
              tofile := IncludeTrailingPathDelimiter(CopyFileToFolderLbl.Caption) + CopyFileFilenameStructureEdt.text + fileextension;
              tofile := stringReplace(tofile , '[topmostfolder]', topmostfolder, [rfIgnoreCase]);
              tofile := stringReplace(tofile , '[month:mmm]', FormatDateTime('mmm',Now), [rfIgnoreCase]);
            end;
            showmessage(tofile);
            tofile:=SysToUTF8(tofile);
            tofile:=UTF8ToCP866(tofile);
            try
              if (DirectoryExists(ExtractFilePath(tofile)) = false) then
              begin
                  CreateDir(ExtractFilePath(tofile));
              end;
  //            showmessage(CopyFileStringGrid.Cells[0,i] + '**' + tofile);
              if (CopyFilePreservetime.checked = true) and (CopyFileOverwrite.checked = true) then
                ok := CopyFile(fromfile, tofile, [cffPreserveTime,cffOverwriteFile])
              else if (CopyFilePreservetime.checked = true) then
                ok := CopyFile(fromfile, tofile, [cffPreserveTime])
              else
                ok := CopyFile(fromfile, tofile, [cffOverwriteFile]);
            except
                on E: Exception do
                begin
                  If progressbar = true then
                  begin
                     CopyFileStatusLbl.Caption := 'Status: Error Copying. ' + fromfile + ' ' + E.Message;
                     break;
                  end;
                end;
            end;
         end
         else
         begin
           If progressbar = true then
           begin
              CopyFileStatusLbl.Caption := 'Status: Copying failed. ' + fromfile + ' file not found. Run stopped.';
              break;
           end;
         end;
         If progressbar = true then
         begin
           if ok = false then
           begin
             CopyFileStatusLbl.Caption := 'Status: Copying failed. ' + CopyFileStringGrid.Cells[0,i] + ' ' + SysErrorMessage(GetLastOSError);
             break;
           end;
           ProgressBar1.Position:=I;
           if CancelRunBool then
           begin
             CopyFileCancelRunBtn.Enabled := False;
             break;
           end;
           Application.ProcessMessages;
         end;
       end;
       If progressbar = true then
       begin
         CopyFileCancelRunBtn.Enabled := False;
         CopyFileStatusLbl.Caption := 'Status: Copying of files finished';
       end;
     finally
        Result := true;
     end;
end;

procedure tmainfrm.startupcode();
var
  logdata: TStringList;
  logfilepath, inifilename: String;
  i,i2: Integer;
begin
      logdata := TStringList.Create;
      try
        logfilepath := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'runlog.log';
        if fileexists(logfilepath) then
        begin
          logdata.LoadFromFile(logfilepath);
        end;
        i := logdata.Count - 1;
        i2 := 0;
        while i >= 0 do
        begin
          if (i2 > 100) then
          begin
            logdata.Delete(i);
          end;
          dec(i);
          inc(i2);
        end;
        If ParamCount > 0 then
        begin
           if ParamStr(1) <> '' then
           begin
              If FileExists(ParamStr(1)) then
              begin
                  inifilename := ExtractFileName(ParamStr(1));
                  If LoadINI(ParamStr(1)) = false then
                  begin
                     logdata.Add(datetimetostr(now) + ':' + inifilename + ' failed to load');
                     logdata.SaveToFile(logfilepath);
                     Application.Terminate;
                  end
                  else
                  begin
                      logdata.Add(datetimetostr(now) + ':' + inifilename + ' successfully loaded');
                      try
                              getfilesinfolder(DirectoryLbl.Caption,DaysEdt.Text, SearchMaskEdit.Text, IncludeSubFolderCheck.Checked , False);
                              if StringGrid1.Rowcount = 1 then
                              begin
                      	        logdata.Add(datetimetostr(now) + ':' + inifilename + ' no files to zip');
                                logdata.SaveToFile(logfilepath);
                                Application.Terminate;
                              end
                              else
                              begin
                                  if zipfileswithruncheck.checked then
                                  begin
                                    zipfiles(includeTrailingPathDelimiter(ToFolderLbl.Caption) + FormatDateTime('yyyymmddhhmm',now) + '.zip',False);
                                  end;
                                  if deletefileswithruncheck.checked then
                                  begin
                                    Deleteselectedfiles(False);
                                  end;
                                if deleteemptyfolderscheck.checked then
                                begin
                                     deleteemptydirectories(DirectoryLbl.Caption, False);
                                end;
                                logdata.Add(datetimetostr(now) + ':' + inifilename + ' Process completed');
                                logdata.SaveToFile(logfilepath);
                                Application.Terminate;
                              end;
                      except
                        on E: Exception do
                        begin
                          logdata.Add(datetimetostr(now) + ':' + inifilename + ' Process failed ->' + E.Message);
                          logdata.SaveToFile(logfilepath);
                          Application.Terminate;
                        end;
                      end;
                  end;
              end
              else
              begin
                  logdata.Add(datetimetostr(now) + ':(' + ParamStr(1) + ') file not found');
                  logdata.SaveToFile(logfilepath);
                  Application.Terminate;
              end;
           end
           else
           begin
              logdata.Add(datetimetostr(now) + ':INI file not found');
              logdata.SaveToFile(logfilepath);
              Application.Terminate;
           end;
        end;
      finally
         logdata.free;
      end;
end;

end.

