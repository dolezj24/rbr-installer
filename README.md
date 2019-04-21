## RBR Installer - bigger then 2GB ##

Installer creation

1. Put rbr files to install into rbr-files directory.
2. Keep RichardBurnsRally.ini as it is in rbr-files directory in repository (without XRes and YRes at the end).
3. (optional - if you already compiled the script and the script did not update, you can reuse the installer) Compile nsi script and insert resulting installer (installer.exe) to rbr-files directory.
4. Create 7z archive selecting all files and directories in rbr-files folder including installer.exe. Keep it in rbr-files directory (archive will be moved to sfx-final folder by script in next step).
5. Run create-sfx-installer.bat script in sfx-final folder. "Richard Burns Rally.exe" is the final SFX archive, which will run the installer after unpacking the files.
