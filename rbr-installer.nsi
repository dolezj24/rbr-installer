!include LogicLib.nsh
!include "MUI2.nsh"

;-------------------------------------
; The installer and uninstaller file names
OutFile "installer.exe"
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

Section "Install"
  SectionIn RO

  CopyFiles "$EXEDIR\*.*" "$INSTDIR\RichardBurnsRally"

  Delete "$INSTDIR\RichardBurnsRally\installer.exe"

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

  SetOutPath "$INSTDIR\RichardBurnsRally"
  CreateShortcut "$DESKTOP\Richard Burns Rally.lnk" "$INSTDIR\RichardBurnsRally\RichardBurnsRally_SSE.exe"

  WriteUninstaller "$INSTDIR\RichardBurnsRally\${UNINSTALLER}"
  
SectionEnd ; end the install section

Function un.onInit
  !insertmacro MUI_UNGETLANGUAGE
FunctionEnd

Section "Uninstall"
  DeleteRegKey HKLM "SOFTWARE\SCi Games\Richard Burns Rally"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Richard Burns Rally"
  Delete "$DESKTOP\Richard Burns Rally.lnk"

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
    MessageBox MB_OK|MB_ICONEXCLAMATION "$(UNINSTALLER_FAIL_TEXT)"
    Abort
  ${EndIf}
SectionEnd ; End uninstall section
