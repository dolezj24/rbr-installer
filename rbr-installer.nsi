!include LogicLib.nsh
!include "MUI2.nsh"
!include nsDialogs.nsh

;-------------------------------------
; The installer and uninstaller file names
OutFile "Richard Burns Rally.exe"
!define UNINSTALLER "RichardBurnsRallyUnistall.exe"

;--------------------------------------
; The name of the installer
Name "Richard Burns Rally"
DirText "Select folder, where Richard Burns Rally will be installed. It is recommended to install RBR outside program files." "Folder"
#InstallDir "test-dir"
InstallDir "C:\"

RequestExecutionLevel admin

;--------------------------------
;Interface Settings
!define MUI_ABORTWARNING
!define MUI_WELCOMEPAGE_TEXT "You are installing Richard Burns Rally with Tournament plugin and NGP Physics."

;--------------------------------
; Pages install
!insertmacro MUI_PAGE_WELCOME
Page custom MyPageFunc MyPageFuncLeave
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
; Pages uninstall
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

;--------------------------------
!insertmacro MUI_LANGUAGE "English"

;--------------------------------
; Variables can be only global, so they are initialized here together
Var username
Var password
Var usernameTextBox
Var passwordTextBox
Var dialog
Var labelUsername
Var labelPassword
Var label
Var button

Section "Install"
  SectionIn RO

  SetOutPath "$INSTDIR\RichardBurnsRally"

  File /r "rbr-files\"

  WriteRegStr HKLM "SOFTWARE\SCi Games\Richard Burns Rally\1.00.000" "" ""
  WriteRegStr HKLM "SOFTWARE\SCi Games\Richard Burns Rally\InstallPath" "" "$INSTDIR\RichardBurnsRally"
  WriteRegStr HKLM "SOFTWARE\SCi Games\Richard Burns Rally\Language" "" "English"

  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Richard Burns Rally" "DisplayName" "Richard Burns Rally"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Richard Burns Rally" "UninstallString" '"$INSTDIR\RichardBurnsRally\${UNINSTALLER}"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Richard Burns Rally" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Richard Burns Rally" "NoRepair" 1

  System::Call 'user32::GetSystemMetrics(i 0) i .r0'
  System::Call 'user32::GetSystemMetrics(i 1) i .r1'

  FileOpen $4 "$INSTDIR\RichardBurnsRally\RichardBurnsRally.ini" a
  FileSeek $4 0 END
  FileWrite $4 "XRes = $0$\r$\n"
  FileWrite $4 "YRes = $1$\r$\n"
  FileClose $4

  CreateShortcut "$DESKTOP\RichardBurnsRally.lnk" "$INSTDIR\RichardBurnsRally\RichardBurnsRally_SSE.exe"

  WriteUninstaller "$INSTDIR\RichardBurnsRally\${UNINSTALLER}"
  
SectionEnd ; end the install section

Section "Uninstall"
  DeleteRegKey HKLM "SOFTWARE\SCi Games\Richard Burns Rally"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Richard Burns Rally"
  Delete "$DESKTOP\RichardBurnsRally.lnk"

  StrCpy $0 $INSTDIR
  StrCpy $1 0
  loop:
    IntOp $1 $1 - 1
    StrCpy $2 $0 1 $1
    StrCmp $2 '\' found
    StrCmp $2 '' stop loop
  found:
    IntOp $1 $1 + 1
  stop:
  StrCpy $2 $0 "" $1

  ${If} $2 == "RichardBurnsRally"
    RMDir /r "$INSTDIR"
  ${Else}
    MessageBox MB_OK|MB_ICONEXCLAMATION "Install directory changed or renamed, files won't be deleted. You can delete them by yourself."
    Abort
  ${EndIf}
SectionEnd ; End uninstall section

Function MyPageFunc
  nsDialogs::Create 1018
  Pop $dialog

  ${NSD_CreateLabel} 0 0 300u 10u "If you are not registered on RBR tournament plugin, click the button underneath."
  Pop $label
  ${NSD_CreateLabel} 0 15 300u 10u "After registring, enter your username and password into textboxes below and click next."
  Pop $label

  ${NSD_CreateButton} 0 40 120u 15u "Register on rbr.onlineracing.cz"
  Pop $button
  ${NSD_OnClick} $button openRBRTMRegister

  ${NSD_CreateLabel} 0 75 50u 10u "Username:"
  Pop $labelUsername
  ${NSD_CreateText} 70 75 100u 12u ""
  Pop $usernameTextBox

  ${NSD_CreateLabel} 0 100 50u 10u "Password:"
  Pop $labelPassword
  ${NSD_CreateText} 70 100 100u 12u ""
  Pop $passwordTextBox
  nsDialogs::Show
FunctionEnd

Function MyPageFuncLeave
  ${NSD_GetText} $usernameTextBox $username
  ${NSD_GetText} $passwordTextBox $password
FunctionEnd

Function openRBRTMRegister
  ExecShell "open" "http://rbr.onlineracing.cz/forum/profile.php?mode=register"
FunctionEnd
