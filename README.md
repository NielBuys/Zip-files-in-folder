# NComp File Toolbox

Small Open Source tool written for my office. It have 2 functions.

1. First function Compress the files (Recursive) in the selected folder older than the specified days, and then delete the files after the compress. The tool is used to backup and delete the older auto generated files in the specified folder. Deleting empty folders also.<br>
2. Second function copy only the newest file in the folders (Recursive). Save the Newest file as a Monthly Copy in a destination folder. Name of file is renamed to the top most folder name and the month. To keep monthly copy's of backups for a year.<br>
<br>
Tool was written in Lazarus.<br>
<br>
Manual run instructions:<br>
No install needed just download and run.<br>
You choose target folder by pressing the "List files" button.<br>
You set how old the file must be before the tool delete a file. ex. default is 90 so if file is older than 90 days its deleted if its younger than 90 days its kept.<br>
You choose the to folder by pressing the "Set To Folder" button.<br>
Press the "Zip Files" button.<br>
Press the "Delete Files" button.<br>
<br>
Auto run instructions:<br>
No install needed just download and run.<br>
You choose target folder by pressing the "List files" button.<br>
You set how old the file must be before the tool delete a file. ex. default is 90 so if file is older than 90 days its deleted if its younger than 90 days its kept.<br>
You choose the to folder by pressing the "Set To Folder" button.<br>
Press the "Write INI" button and save an ini file.<br>
You run the tool by executing the exe with the ini file as parameter. Do a zip and delete process. This can be added in the task scheduler. ex. "zipfilesinfolder.exe" "c:\tempfolder\testini.ini"<br>
<br>
To download and use the software go to http://www.ncomp.co.za/index.php/software/zip-files-in-folder
<br>
Disclaimer: We accept no liability for any loss or damage caused by the downloading, installation and use of this software.
