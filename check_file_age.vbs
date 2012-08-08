Option Explicit  
Dim fso, path, file, recentDate, recentFile, warning , critical, dateExec, pipe
dateExec = now
warning = clng(WScript.Arguments.Named("w"))
critical = clng(WScript.Arguments.Named("c"))
Set fso = CreateObject("Scripting.FileSystemObject")
Set recentFile = Nothing
For Each file in fso.GetFolder("C:\test").Files
  If (recentFile is Nothing) Then
    Set recentFile = file
  ElseIf (file.DateLastModified > recentFile.DateLastModified) Then
    Set recentFile = file
  End If
Next

If recentFile is Nothing Then
  WScript.Echo "CRITICAL - There's no file in this directory"
Else
	if DateDiff("s",recentFile.DateLastModified,dateExec) < critical AND DateDiff("s",recentFile.DateLastModified,dateExec) >= warning then
		Wscript.Echo "WARNING - The most recent file is " & recentFile.Name & " was last modified " & recentFile.DateLastModified
	elseif DateDiff("s",recentFile.DateLastModified,dateExec) >= critical then
		Wscript.Echo "CRITICAL - The most recent file is " & recentFile.Name & " was last modified " & recentFile.DateLastModified
	else
		Wscript.Echo "OK"
	end if
End If