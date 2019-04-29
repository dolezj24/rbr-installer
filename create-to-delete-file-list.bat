@echo off
echo !macro UNINSTALL_FILES > to-delete.nsh
dir /b /a-d rbr-files > temp.txt
(for /f %%a in (temp.txt) do @echo Delete $INSTDIR\%%a >> to-delete.nsh)
dir /b /ad rbr-files > temp.txt
(for /f %%a in (temp.txt) do @echo RMDir /r $INSTDIR\%%a >> to-delete.nsh)
echo !macroend >> to-delete.nsh
del temp.txt
