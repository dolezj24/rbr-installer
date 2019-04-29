!include LogicLib.nsh
!include "MUI2.nsh"
!include nsDialogs.nsh
!include "textfunc.nsh"

Unicode True
;-------------------------------------
; The installer and uninstaller file names
OutFile "Richard Burns Rally.exe"
!define UNINSTALLER "RichardBurnsRallyUnistall.exe"

;--------------------------------------
; The name of the installer
Name "Richard Burns Rally"
DirText "$(DIR_TEXT)"
#InstallDir "D:\Hry\RBR_modifikace\Instalatory\rbr\test-dir"
InstallDir "C:\"

RequestExecutionLevel admin

;--------------------------------
;Interface Settings
!define MUI_ABORTWARNING
!define MUI_WELCOMEPAGE_TEXT "$(WELCOMEPAGE_TEXT)"

;--------------------------------
; Pages install
!insertmacro MUI_PAGE_WELCOME
#Page custom AccPageFunc AccPageFuncLeave
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
; Pages uninstall
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

;--------------------------------
!include "langmacros.nsh"

!insertmacro LANG_LOAD "English"
!insertmacro LANG_LOAD "Czech"

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

Function .onInit
  !insertmacro MUI_LANGDLL_DISPLAY
FunctionEnd

Section "Install"
  SectionIn RO

  SetOutPath "$INSTDIR"

  File /r "rbr-files\"
#  File rbr-files\RichardBurnsRally.ini
#  File rbr-files\RichardBurnsRally_SSE.exe
#  File rbr-files\Plugins\Pacenote\PaceNote.ini
#  File /r rbr-files\Audio\Game
#  File /r rbr-files\Audio\Game-cz

  WriteRegStr HKLM "SOFTWARE\SCi Games\Richard Burns Rally\1.00.000" "" ""
  WriteRegStr HKLM "SOFTWARE\SCi Games\Richard Burns Rally\InstallPath" "" "$INSTDIR"
  ${if} $LANGUAGE == 1033 ;English
    WriteRegStr HKLM "SOFTWARE\SCi Games\Richard Burns Rally\Language" "" "English"
  ${elseif} $LANGUAGE == 1029 ;Czech
    WriteRegStr HKLM "SOFTWARE\SCi Games\Richard Burns Rally\Language" "" "Czech"
    ${LineFind} "$INSTDIR\Plugins\Pacenote\PaceNote.ini" "" "1:-1" "SetPacenoteLang"
    Rename "$INSTDIR\Audio\Game" "$INSTDIR\Audio\Game-en"
    Rename "$INSTDIR\Audio\Game-cz" "$INSTDIR\Audio\Game"
  ${endif}

  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Richard Burns Rally" "DisplayName" "Richard Burns Rally"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Richard Burns Rally" "UninstallString" '"$INSTDIR\${UNINSTALLER}"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Richard Burns Rally" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Richard Burns Rally" "NoRepair" 1

  ${LineFind} "$INSTDIR\RichardBurnsRally\RichardBurnsRally.ini" "" "1:-1" "TestRBRIniLine"

  System::Call 'user32::GetSystemMetrics(i 0) i .r0'
  System::Call 'user32::GetSystemMetrics(i 1) i .r1'

  FileOpen $4 "$INSTDIR\RichardBurnsRally.ini" a
  FileSeek $4 0 END
  FileWrite $4 "XRes = $0$\r$\n"
  FileWrite $4 "YRes = $1$\r$\n"
  FileClose $4

  SetShellVarContext all
  CreateShortcut "$DESKTOP\RichardBurnsRally.lnk" "$INSTDIR\RichardBurnsRally_SSE.exe"

  WriteUninstaller "$INSTDIR\${UNINSTALLER}"
  
SectionEnd ; end the install section

Function un.onInit
  !insertmacro MUI_UNGETLANGUAGE
FunctionEnd

Section "Uninstall"
  SetShellVarContext all
  DeleteRegKey HKLM "SOFTWARE\SCi Games\Richard Burns Rally"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Richard Burns Rally"
  Delete "$DESKTOP\RichardBurnsRally.lnk"

  !include "to-delete.nsh"
  !insertmacro UNINSTALL_FILES

  Delete $INSTDIR\${UNINSTALLER}
SectionEnd ; End uninstall section

Function AccPageFunc
  !insertmacro MUI_HEADER_TEXT "$(ACCOUNT_PAGE_HEADER)" ""
  nsDialogs::Create 1018
  Pop $dialog

  ${NSD_CreateLabel} 0 0 300u 10u "$(LABEL1)"
  Pop $label
  ${NSD_CreateLabel} 0 15 300u 10u "$(LABEL2)"
  Pop $label

  ${NSD_CreateButton} 0 40 120u 15u "$(BUTTON_TEXT)"
  Pop $button
  ${NSD_OnClick} $button openRBRTMRegister

  ${NSD_CreateLabel} 0 75 70u 10u "$(USERNAME_LABEL)"
  Pop $labelUsername
  ${NSD_CreateText} 100 75 100u 12u ""
  Pop $usernameTextBox

  ${NSD_CreateLabel} 0 100 70u 10u "$(PASSWORD_LABEL)"
  Pop $labelPassword
  ${NSD_CreateText} 100 100 100u 12u ""
  Pop $passwordTextBox
  nsDialogs::Show
FunctionEnd

Function AccPageFuncLeave
  ${NSD_GetText} $usernameTextBox $username
  ${NSD_GetText} $passwordTextBox $password
FunctionEnd

Function openRBRTMRegister
  ExecShell "open" "http://rbr.onlineracing.cz/forum/profile.php?mode=register"
FunctionEnd

Function TestRBRIniLine
  ${TrimNewLines} '$R9' $R9

  ${if} $R9 == "AutoLoginName = "
    StrCpy $R9 "AutoLoginName = $username$\r$\n"
  ${elseif} $R9 == "AutoLoginPassword = "
    StrCpy $R9 "AutoLoginPassword = $password$\r$\n"
  ${else}
    StrCpy $R9 '$R9$\r$\n'
  ${endif}

  Push $0
FunctionEnd

Function SetPacenoteLang
  ${TrimNewLines} '$R9' $R9

  ${if} $R9 == "language=english"
    StrCpy $R9 "language=czech$\r$\n"
  ${elseif} $R9 == "sounds=english/male/steve"
    StrCpy $R9 "sounds=czech$\r$\n"
  ${else}
    StrCpy $R9 '$R9$\r$\n'
  ${endif}

  Push $0
FunctionEnd
