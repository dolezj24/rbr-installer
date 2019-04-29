## RBR Installer - bigger then 2GB ##

Installer creation

1. Put rbr files to install into rbr-files directory except RichardBurnsRally.ini (Keep  as it is in rbr-files directory in repository (without XRes and YRes at the end)).
2. (optional - only when you update content of rbr-files) Run create-to-delete-file-list.bat script to create list of files and directories for uninstaller.
3. (optional - if you already compiled rbr-installer.nsi and the script or content of rbr-files directory didn't update, you can reuse the installer) Compile nsi script and insert resulting installer (installer.exe) to rbr-files directory.
4. Create 7z archive selecting all files and directories in rbr-files folder (IMPORTANT: select files by ctrl+A in folder, not folder itself) including installer.exe. Keep it in rbr-files directory (archive will be moved to sfx-final folder by script in next step).
5. Run create-sfx-installer.bat script in sfx-final folder. "Richard Burns Rally.exe" is the final SFX archive, which will run the installer after unpacking the files.
