@echo off
title Changer
REM **********************************************
REM * Batch Datei zum ändern der Systemsteuerung *
REM *          Version 1.0 - 11.07.16            *
REM **********************************************


REM ***********************************
REM * Benutzer- und Adminrechtabfrage *
REM ***********************************
for /f "tokens=1,2*" %%s in ('bcdedit') do set STRING=%%s
if (%STRING%)==(Zugriff) (echo  Die Datei hat keine Adminrechte! Bitte mit Administrationsrechten ausfueren! && timeout /t 5 > nul && exit)
if %USERNAME%==Administrator (goto ADMIN) else (echo.)


REM ********
REM * Menü *
REM ********
echo  ******************************************************************************
echo  *                             C H A N G E R                                  *
echo  *                                                                            *
echo  *  Folgende Aenderungen orientieren sich an der aktuellen Checkliste. Dazu   *
echo  *           bitte trotzdem die beigelegte README-Datei lesen!                *
echo  *                                                                            *
echo  *                          --Stand 11.07.16--                                *
echo  *                                                                            *
echo  * Benutzer: %USERNAME%                                          %date:~0% %time:~0,8% *
echo  ******************************************************************************
echo.
echo.
echo  Weiter mit beliebiger Taste, [STRG]+[C] zum abbrechen.
pause >nul


REM ******************************************
REM * Falls die Batch vom USB gestartet wird *
REM ******************************************
mkdir C:\Admin\Batch 2>nul
cd C:\Admin\Batch



REM *********************
REM * Logfile erstellen *
REM *********************
del "C:\Admin\Batch\Logfile.html"
del "C:\Admin\Batch\Logfile.txt"
echo ^<!DOCTYPE html^> ^<html lang="Ge"^> ^<head^> >>Logfile.txt
echo ^<title^>Logfile^</title^> ^<meta charset="utf-8"^> ^<style type="text/css"^> >>Logfile.txt
echo body {font-family:Helvetica; background-color: #E8E8E8;} h1{background: white; text-align: center;} ^</style^> >>Logfile.txt
echo ^</head^> ^<body^> ^<h1^>Auswertung des Logfiles^</h1^> ^<br^> >>Logfile.txt
echo %date:~0% %time:~0,8%::[%USERNAME%] Systemaenderung %USERNAME% Start^<br^> >>Logfile.txt  


REM ********************************************
REM * Betriebssystem und Bit-Version bestimmen *
REM ********************************************
ver | find "Microsoft Windows [Version 6.1" > nul
if %errorlevel% EQU 0 set OS=WIN7
ver | find "Microsoft Windows [Version 6.2" > nul
if %errorlevel% EQU 0 set OS=WIN8
ver | find "Microsoft Windows [Version 6.3" > nul
if %errorlevel% EQU 0 set OS=WIN8
if %PROCESSOR_ARCHITECTURE%==AMD64 (set BIT=64) else (set BIT=32)
echo %date:~0% %time:~0,8%::[%USERNAME%] Betriebssystem: %OS% %BIT%BIT^<br^> >>Logfile.txt


REM ***********************************
REM * Internet Explorer konfigurieren *
REM ***********************************
echo - Startseite im Internet Explorer einrichten:
reg add "HKCU\Software\Microsoft\Internet Explorer\Main" /v "Start Page" /t REG_SZ /d "https://changeme.de" /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Startseite fuer Internet Explorer eingerichtet^<br^> >>Logfile.txt
reg add "HKCU\Software\Microsoft\Internet Explorer\Main" /v "RunOnceHasShown" /t REG_DWORD /d 1 /f && reg add "HKCU\Software\Microsoft\Internet Explorer\Main" /v "RunOnceComplete" /t REG_DWORD /d 1 /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Internet Explorer Startwizard blockiert^<br^> >>Logfile.txt 
if %OS%==WIN8 reg add "HKCU\Software\Policies\Microsoft\Internet Explorer\Main" /v "ApplicationTileImmersiveActivation" /t REG_DWORD /d 0 /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Internet Explorer-Kacheln werden immer auf dem Desktop geoeffnet^<br^> >>Logfile.txt
if %OS%==WIN8 reg add "HKCU\Software\Policies\Microsoft\Internet Explorer\Main" /v "AssociationActivationMode" /t REG_DWORD /d 2 /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Links werden immer mit der Desktop-Version geoeffnet^<br^> >>Logfile.txt
REM timeout /t 20 > nul
echo - Verknuepfung auf dem Desktop erstellen:
if %BIT%==64 goto 64
echo Set objShell = CreateObject("WScript.Shell") >> IE.vbs
echo sShortcut = "C:\Users\Public\Desktop\Internet Explorer.lnk" >> IE.vbs
echo set objLink = objShell.CreateShortcut(sShortcut) >> IE.vbs
echo objLink.TargetPath = "C:\Program Files\Internet Explorer\iexplore.exe" >> IE.vbs
echo objLink.Save >> IE.vbs
cscript //nologo "C:\Admin\Batch\IE.vbs" && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Verknuepfung auf dem Desktop erstellt^<br^> >>Logfile.txt
del C:\Admin\Batch\IE.vbs
echo Der Vorgang wurde erfolgreich beendet.
start /MIN iexplore.exe
goto WEITER
:64
echo Set objShell = CreateObject("WScript.Shell") >> FM.vbs
echo sShortcut = "C:\Users\Public\Desktop\Internet Explorer.lnk" >> FM.vbs
echo set objLink = objShell.CreateShortcut(sShortcut) >> FM.vbs
echo objLink.TargetPath = "C:\Program Files (x86)\Internet Explorer\iexplore.exe" >> FM.vbs
echo objLink.Save >> FM.vbs
echo sShortcut = "C:\Users\Public\Desktop\Word.lnk" >> FM.vbs
echo set objLink = objShell.CreateShortcut(sShortcut) >> FM.vbs
echo objLink.TargetPath = "C:\Program Files\Microsoft Office\Office14\WINWORD.exe" >> FM.vbs
echo objLink.Save >> FM.vbs
echo sShortcut = "C:\Users\Public\Desktop\Excel.lnk" >> FM.vbs
echo set objLink = objShell.CreateShortcut(sShortcut) >> FM.vbs
echo objLink.TargetPath = "C:\Program Files\Microsoft Office\Office14\EXCEL.exe" >> FM.vbs
echo objLink.Save >> FM.vbs
echo sShortcut = "C:\Users\Public\Desktop\Outlook.lnk" >> FM.vbs
echo set objLink = objShell.CreateShortcut(sShortcut) >> FM.vbs
echo objLink.TargetPath = "C:\Program Files\Microsoft Office\Office14\OUTLOOK.exe" >> FM.vbs
echo objLink.Save >> FM.vbs
cscript //nologo "C:\Admin\Batch\FM.vbs" && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Verknuepfung auf dem Desktop erstellt^<br^> >>Logfile.txt
del C:\Admin\Batch\FM.vbs
echo Der Vorgang wurde erfolgreich beendet.
:WEITER
echo.

REM*****************************************
REM* ausführen von .js Dateien verhindern *
REM*****************************************
assoc .js=textfile

REM ************************
REM * Eingabegebietsschema *
REM ************************
echo - Eingabegebietsschemaleiste deaktivieren:
reg add "HKCU\Software\Microsoft\CTF\LangBar" /v "ShowStatus" /t REG_DWORD /d "3" /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Eingabegebietsschemaleiste wurde deaktiviert^<br^> >>Logfile.txt
cls
echo.

REM ******************************************
REM * Verantwortliche in der Registry ändern *
REM ******************************************
set /p KUNA= - Wie heißt der Administrator? 
echo - Verantwortlichen in RegisteredOrganization und RegisteredOwner eintragen:
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "RegisteredOrganization" /t REG_SZ /d "%KUNA%" /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: "%KUNA%" wurde in RegisteredOrganization eingetragen^<br^> >>Logfile.txt  
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "RegisteredOwner" /t REG_SZ /d "%KUNA%" /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: "%KUNA%" wurde in RegisteredOwner eingetragen^<br^> >>Logfile.txt  



REM **********************
REM * Klassische Ansicht *
REM **********************
echo - Klassiche Ansicht der Systemsteuerung:
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "ForceClassicControlPanel" /t REG_DWORD /d 1 /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Zur klassischen Ansicht in der Systemsteuerung gewechselt^<br^> >>Logfile.txt
echo.


REM *************
REM * Anpassung *
REM *************
echo - Windows7 Desktoptheme waehlen:
C:\Windows\Resources\Themes\aero.theme && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Standard Windows Theme aktiviert^<br^> >>Logfile.txt
echo - Sidebar deaktivieren:
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Windows\Sidebar" /v "TurnOffSidebar" /t REG_DWORD /d 1 /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Sidebar wurde deaktiviert^<br^> >>Logfile.txt
echo.


REM *******************
REM * Energieoptionen *
REM *******************
echo - Energiesparmodus Hoechstleistung einstellen:
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c    
echo - Bildschirm niemals aus und Energiesparmodus deaktiviert
powercfg -change -monitor-timeout-ac 0
powercfg -change -monitor-timeout-dc 0
powercfg -change -disk-timeout-ac 0
powercfg -change -disk-timeout-dc 0
powercfg -change -standby-timeout-ac 0
powercfg -change -standby-timeout-dc 0
echo %date:~0% %time:~0,8%::[%USERNAME%] >>Logfile.txt
powercfg -getactivescheme >>Logfile.txt
echo ^<br^> %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Bildschirm ausschalten und Energiesparmodus deaktiviert^<br^> >>Logfile.txt
echo - Bildschirmhelligkeit nicht automatisch abdunkeln: 
reg add "HKLM\Software\Policies\Microsoft\Power\PowerSettings\f1fbfde2-a960-4165-9f88-50667911ce96" /v "ACSettingIndex" /t REG_DWORD /d 0 /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Automatische Bildschirmabdunkelung auf 100% gestellt (AC) ^<br^>>>Logfile.txt
reg add "HKLM\Software\Policies\Microsoft\Power\PowerSettings\f1fbfde2-a960-4165-9f88-50667911ce96" /v "DCSettingIndex" /t REG_DWORD /d 0 /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Automatische Bildschirmabdunkelung auf 100% gestellt (DC) ^<br^>>>Logfile.txt
reg add "HKLM\Software\Policies\Microsoft\Power\PowerSettings\3C0BC021-C8A8-4E07-A973-6B14CBCB2B7E" /v "ACSettingIndex" /t REG_DWORD /d 0 /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Automatische Bildschirmabdunkelung auf 0 Minuten gestellt (AC) ^<br^>>>Logfile.txt
reg add "HKLM\Software\Policies\Microsoft\Power\PowerSettings\3C0BC021-C8A8-4E07-A973-6B14CBCB2B7E" /v "DCSettingIndex" /t REG_DWORD /d 0 /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Automatische Bildschirmabdunkelung auf 0 Minuten gestellt (DC) ^<br^>>>Logfile.txt
echo.


REM ***********************
REM * Infobereichssymbole *
REM ***********************
echo - Systemsymbol Wartungscenter deaktivieren:
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAHealth" /t REG_DWORD /d 1 /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Benutzerkontensteuerung erfolgreich deaktiviert^<br^> >>Logfile.txt
echo.


REM ***************************
REM * Ordneroptionen anpassen * 
REM ***************************
echo - Erweiterung bei bekannten Dateitypen ausblenden:
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d "0" /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Erweiterung bei bekannten Dateitypen ausblenden deaktiviert^<br^> >>Logfile.txt
echo - Freigabe-Assisten deaktivieren:
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SharingWizardOn" /t REG_DWORD /d "0" /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Freigabe-Assisten deaktiviert^<br^> >>Logfile.txt
echo - Geschuetzte Systemdateien ausblenden:
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSuperHidden" /t REG_DWORD /d "0" /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Geschuetzte Systemdateien ausgeblendet^<br^> >>Logfile.txt
echo - Immer Menues anzeigen:
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "AlwaysShowMenus" /t REG_DWORD /d "1" /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Menues werden immer angezeigt^<br^> >>Logfile.txt
echo - Versteckte Dateien und Ordner anzeigen:
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d "0" /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Versteckte Dateien und Ordner werden angezeigt^<br^> >>Logfile.txt
echo.


REM **********************************
REM * erweiterte Systemeinstellungen *
REM **********************************
echo - Umgebungsvariable eintragen:
setx DEVMGR_SHOW_NONPRESENT_DEVICES 1 -m && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Umgebungsvariable eingetragen^<br^> >>Logfile.txt
echo - Automatischer Neustart durchfuehren deaktivieren:
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "AutoReboot" /t REG_DWORD /d "0" /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Automatischer Neustart durchfuehren deaktiviert^<br^> >>Logfile.txt
echo - Remotedesktop aktivieren:
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v "fDenyTSConnection" /t REG_DWORD /d "0" /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Remotedesktop aktiviert^<br^> >>Logfile.txt
echo - Erweiterte Systemeinstellungen (siehe Checkliste):
sysdm.cpl,3
echo.


REM ****************************
REM * Taskleiste und Startmenü *
REM ****************************
if %OS%==WIN8 goto WEITER
echo - Zuletzt installierte Programme hervorheben deaktivieren:
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_NotifyNewApps" /t REG_DWORD /d 0 /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Zuletzt installierte Programme hervorheben deaktiviert^<br^> >>Logfile.txt
echo.
:WEITER


REM **************
REM * Verwaltung *
REM **************
echo - Administrator wird aktiviert:
net user Administrator /active && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Administrator aktiviert^<br^> >>Logfile.txt
echo - Administrator Kennwort wird gesetzt:
net user Administrator changeme && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Admin Kennwort gesetzt^<br^> >>Logfile.txt
echo - Remoteregistrierung auf automatisch stellen:
reg add "HKLM\SYSTEM\CurrentControlSet\services\RemoteRegistry" /v "Start" /t REG_DWORD /d 2 /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Remoteregistrierung auf automatisch gestellt (wird erst nach einem Neustart gestartet)^<br^> >>Logfile.txt
echo.


REM ******************
REM * Wartungscenter *
REM ******************
echo - Programm zu Verbesserung der Benutzerfreundlichkeit deaktivieren:
reg add "HKLM\Software\Policies\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d "0" /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Programm zu Verbesserung der Benutzerfreundlichkeit deaktiviert^<br^> >>Logfile.txt
echo - Einstellungen fuer die Problemberichterstattung werden deaktiviert:
reg add "HKCU\Software\Policies\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d "1" /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Einstellungen fuer die Problemberichterstattung deaktiviert^<br^> >>Logfile.txt
echo.


REM **************************
REM * Firewall konfigurieren *
REM **************************
echo - Datei- und Druckerfreigabe in der Firewall aktivieren:
netsh advfirewall firewall set rule name="Datei- und Druckerfreigabe (Echoanforderung - ICMPv4 eingehend)" new enable=Yes && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Datei- und Druckerfreigabe (Echoanforderung - ICMPv4 eingehend) aktiviert^<br^> >>Logfile.txt
netsh advfirewall firewall set rule name="Datei- und Druckerfreigabe (Echoanforderung - ICMPv6 eingehend)" new enable=Yes && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Datei- und Druckerfreigabe (Echoanforderung - ICMPv6 eingehend) aktiviert^<br^> >>Logfile.txt
echo.


REM *********************************
REM * Windows Updates konfigurieren *
REM *********************************
echo - Windows Updates werden konfiguriert:
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUOptions" /t REG_DWORD /d "4" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "ScheduledInstallDay" /t REG_DWORD /d "4" /f
echo.


REM *****************************
REM * Systemstart konfigurieren *
REM *****************************
echo - Java und Adobe Reader aus dem Systemstart nehmen:
reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run" /v "SunJavaUpdateSched" /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Java aus dem Systemstart genommen^<br^> >>Logfile.txt
reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run" /v "Adobe ARM" /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Adobe Reader aus dem Systemstart genommen^<br^> >>Logfile.txt
if %OS%==WIN7 goto WEITER
echo - Nach der Anmeldung wird immer der Desktop angezeigt (nur unter Windows 8.1):
reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v "DefaultSignIn" /t REG_DWORD /d 1 /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Nach der Anmeldung wird immer der Desktop angezeigt^<br^> >>Logfile.txt
:WEITER
echo.


REM ******************************
REM * Media Player konfigurieren *
REM ******************************
echo - Windows Media Player einrichten:
reg add "HKLM\Software\Policies\Microsoft\WindowsMediaPlayer" /v "GroupPrivacyAcceptance" /t REG_DWORD /d 1 /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Windows Media Player Anfangsmeldung deaktiviert ^<br^> >>Logfile.txt
echo.


REM ************************************
REM *   eigenes Logo bei Systeminfo    *
REM ************************************
echo - Logo wird angepasst:
copy "C:\Admin\logo.bmp" "C:\Windows\System32\logo.bmp"
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformationen" /v "Logo" /t REG_SZ /d "C:\Windows\System32\logo.bmp" /f && reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v "Logo" /t REG_SZ /d "C:\Windows\System32\logo.bmp" /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Logo eingefuegt^<br^> >>Logfile.txt
echo.


REM ***************
REM * Bereinigung *
REM ***************
echo - Startmenue bereinigen:
rd /s /q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\7-Zip"
rd /s /q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Java"
echo - Browserverlauf loeschen:
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 255 && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Browserverlauf geloescht^<br^> >>Logfile.txt
echo - Papierkorb leeren:
rd /s /q C:\$Recycle.Bin && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Papierkorb geleert^<br^> >>Logfile.txt
echo - Temp Ordner leeren:
del /q C:\Users\%USERNAME%\AppData\Local\Temp && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Temp Ordner geleert^<br^> >>Logfile.txt


REM ********
REM * Ende *
REM ********
echo %date:~0% %time:~0,8%::[%USERNAME%] Systemaenderung %USERNAME% Ende^<br^>^<br^> >>Logfile.txt
ren "C:\Admin\Batch\Logfile.txt" Logfile.html
cls
echo.
echo                                       ~~~                    
echo                                     [ o o ] 
echo  ******************************.oooO**(_)**Oooo.*******************************
echo  *                                                                            *
echo  *                                  E N D E                                   *
echo  *                                                                            *
echo  *             Unter C:\Admin\Batch wurde ein Logfile erstellt.               *
echo  * Um diverse Einstellungen endgueltig zu uebernehmen, muss der Computer neu- *
echo  *                             gestartet werden!                              *
echo  *                                                                            *
echo  *                               .oooO                                        *
echo  *                               (   )   Oooo.                                *
echo  *********************************\ (****(   )*********************************
echo                                    \_)    ) /                  
echo                                          (_/
echo.
echo.
set /p CONTINUE= Wollen Sie jetzt neustarten? [j] [n]  
IF /I "%CONTINUE%" == "j" (shutdown -r /f /t 2)
exit


REM ************************************************************************************************************************************************************************************
REM ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
REM ************************************************************************************************************************************************************************************


:ADMIN
REM ********
REM * Menü *
REM ********
echo.
echo  ******************************************************************************
echo  *                             C H A N G E R                                  *
echo  *                                                                            *
echo  *  Folgende Aenderungen orientieren sich an der aktuellen Checkliste. Dazu   *
echo  *           bitte trotzdem die beigelegte README-Datei lesen!                *
echo  *                                                                            *
echo  *                          --Stand 11.07.16--                                *
echo  *                                                                            *
echo  * Benutzer: %USERNAME%                                %date:~0% %time:~0,8% *
echo  ******************************************************************************
echo.
echo.
echo  Weiter mit beliebiger Taste, [STRG]+[C] zum abbrechen.
pause >nul


REM *********************
REM * Logfile erstellen *
REM *********************
cd C:\Admin\Batch
ren "C:\Admin\Batch\Logfile.html" Logfile.txt
echo ^<br^> >>Logfile.txt
echo %date:~0% %time:~0,8%::[%USERNAME%] Systemaenderung %USERNAME% Start^<br^> >>Logfile.txt  


REM ********************************************
REM * Betriebssystem und Bit-Version bestimmen *
REM ********************************************
ver | find "Microsoft Windows [Version 6.1" > nul
if %errorlevel% EQU 0 set OS=WIN7
ver | find "Microsoft Windows [Version 6.2" > nul
if %errorlevel% EQU 0 set OS=WIN8
ver | find "Microsoft Windows [Version 6.3" > nul
if %errorlevel% EQU 0 set OS=WIN8
if %PROCESSOR_ARCHITECTURE%==AMD64 (set BIT=64) else (set BIT=32)
echo %date:~0% %time:~0,8%::[%USERNAME%] Betriebssystem: %OS% %BIT%BIT^<br^> >>Logfile.txt


REM ***********************************
REM * Internet Explorer konfigurieren *
REM ***********************************
echo - Google als Startseite fuer Internet Explorer einrichten:
reg add "HKCU\Software\Microsoft\Internet Explorer\Main" /v "Start Page" /t REG_SZ /d "https://google.de" /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Google als Startseite fuer Internet Explorer einrichtet^<br^> >>Logfile.txt
if %OS%==WIN8 reg add "HKCU\Software\Policies\Microsoft\Internet Explorer\Main" /v "ApplicationTileImmersiveActivation" /t REG_DWORD /d 0 /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Internet Explorer-Kacheln werden immer auf dem Desktop geoeffnet^<br^> >>Logfile.txt
if %OS%==WIN8 reg add "HKCU\Software\Policies\Microsoft\Internet Explorer\Main" /v "AssociationActivationMode" /t REG_DWORD /d 2 /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Links werden immer mit der Desktop-Version geoeffnet^<br^> >>Logfile.txt
start /MIN iexplore.exe
REM timeout /t 20 > nul
echo.


REM ************************
REM * Eingabegebietsschema *
REM ************************
echo - Eingabegebietsschemaleiste deaktivieren:
reg add "HKCU\Software\Microsoft\CTF\LangBar" /v "ShowStatus" /t REG_DWORD /d "3" /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Eingabegebietsschemaleiste wurde deaktiviert^<br^> >>Logfile.txt
echo.


REM **********************
REM * Klassische Ansicht *
REM **********************
echo - Klassiche Ansicht der Systemsteuerung:
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "ForceClassicControlPanel" /t REG_DWORD /d 1 /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Zur klassischen Ansicht in der Systemsteuerung gewechselt^<br^> >>Logfile.txt
echo.


REM *************
REM * Anpassung *
REM *************
echo - Desktopsymbole hinzufuegen:
C:\Windows\Resources\Themes\aero.theme && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Standard Windows Theme aktiviert ^<br^> >>Logfile.txt
echo - Sidebar aktivieren:
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Windows\Sidebar" /v "TurnOffSidebar" /t REG_DWORD /d 0 /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Sidebar wurde wieder aktiviert^<br^> >>Logfile.txt
echo Set objShell = CreateObject("WScript.Shell") >> FM.vbs
echo sShortcut = "C:\Users\Public\Desktop\Internet Explorer.lnk" >> FM.vbs
echo set objLink = objShell.CreateShortcut(sShortcut) >> FM.vbs
echo objLink.TargetPath = "C:\Program Files (x86)\Internet Explorer\iexplore.exe" >> FM.vbs
echo objLink.Save >> FM.vbs
echo sShortcut = "C:\Users\Public\Desktop\Word.lnk" >> FM.vbs
echo set objLink = objShell.CreateShortcut(sShortcut) >> FM.vbs
echo objLink.TargetPath = "C:\Program Files\Microsoft Office\Office 14\WINWORD.exe" >> FM.vbs
echo objLink.Save >> FM.vbs
echo sShortcut = "C:\Users\Public\Desktop\Excel.lnk" >> FM.vbs
echo set objLink = objShell.CreateShortcut(sShortcut) >> FM.vbs
echo objLink.TargetPath = "C:\Program Files\Microsoft Office\Office 14\EXCEL.exe" >> FM.vbs
echo objLink.Save >> FM.vbs
echo sShortcut = "C:\Users\Public\Desktop\Outlook.lnk" >> FM.vbs
echo set objLink = objShell.CreateShortcut(sShortcut) >> FM.vbs
echo objLink.TargetPath = "C:\Program Files\Microsoft Office\Office 14\OUTLOOK.exe" >> FM.vbs
echo objLink.Save >> FM.vbs
cscript //nologo "C:\Admin\Batch\FM.vbs" && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Verknuepfung auf dem Desktop erstellt^<br^> >>Logfile.txt
del C:\Admin\Batch\FM.vbs
echo Der Vorgang wurde erfolgreich beendet.
echo.


REM ******************
REM * Benutzerkonten *
REM ******************
echo - Benutzerkontensteuerung deaktivieren:
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d 0 /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Benutzerkontensteuerung deaktiviert ^<br^> >>Logfile.txt
echo.


REM ***********************
REM * Infobereichssymbole *
REM ***********************
echo - Systemsymbol Wartungscenter deaktivieren:
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAHealth" /t REG_DWORD /d 1 /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Systemsymbol Wartungscenter deaktiviert ^<br^> >>Logfile.txt
echo.


REM ***************************
REM * Ordneroptionen anpassen * 
REM ***************************
echo - Erweiterung bei bekannten Dateitypen ausblenden:
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d "0" /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Erweiterung bei bekannten Dateitypen ausgeblendet ^<br^> >>Logfile.txt
echo - Freigabe-Assisten deaktivieren:
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SharingWizardOn" /t REG_DWORD /d "0" /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Freigabe-Assisten deaktiviert ^<br^> >>Logfile.txt
echo - Geschuetzte Systemdateien ausblenden:
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSuperHidden" /t REG_DWORD /d "1" /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Geschuetzte Systemdateien ausgeblendet ^<br^> >>Logfile.txt
echo - Immer Menues anzeigen:
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "AlwaysShowMenus" /t REG_DWORD /d "1" /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Menues werden immer angezeigt ^<br^> >>Logfile.txt
echo - Versteckte Dateien und Ordner anzeigen:
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d "1" /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Versteckte Dateien und Ordner werden angezeigt ^<br^> >>Logfile.txt
echo.


REM ****************************
REM * Taskleiste und Startmenü *
REM ****************************
echo - Zuletzt installierte Programme hervorheben deaktivieren:
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_NotifyNewApps" /t REG_DWORD /d 0 /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Zuletzt installierte Programme hervorheben deaktiviert ^<br^> >>Logfile.txt
echo.


REM ******************
REM * Wartungscenter *     Sicherheitsmeldungen und Wartungscentermeldungen deaktivieren
REM ******************
echo - Programm zu Verbesserung der Benutzerfreundlichkeit deaktivieren:
reg add "HKLM\Software\Policies\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d "0" /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Programm zu Verbesserung der Benutzerfreundlichkeit deaktiviert ^<br^> >>Logfile.txt
echo - Einstellungen fuer die Problemberichterstattung werden deaktiviert:
reg add "HKCU\Software\Policies\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d "1" /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Einstellungen fuer die Problemberichterstattung deaktiviert ^<br^> >>Logfile.txt
echo.


REM *********************************
REM * Windows Updates konfigurieren *
REM *********************************
echo - Updates konfigurieren:
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUOptions" /t REG_DWORD /d "4" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "ScheduledInstallDay" /t REG_DWORD /d "4" /f
echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Windows Updates konfiguriert ^<br^> >>Logfile.txt
echo.

REM**********************
REM*  Hostname aendern  *
REM**********************
set /p PCNA= - Wie lautet der Hostname des Systems?
echo - PC Hostname in der Registry eintragen:
REG add "HKLM\SYSTEM\ControlSet001\Control\ComputerName\ComputerName" /v ComputerName /t REG_SZ /d %PCNA% /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: "%PCNA%" wurde in ComputerName eingetragen^<br^> >>Logfile.txt
REG add "HKLM\SYSTEM\ControlSet001\Services\Tcpip\Parameters" /v "NV Hostname" /t REG_SZ /d %PCNA% /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: "%PCNA%" wurde in NV Hostname eingetragen^<br^> >>Logfile.txt
REG add "HKLM\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName" /v ComputerName /t REG_SZ /d %PCNA% /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: "%PCNA%" wurde in CCS ComputerName eingetragen^<br^> >>Logfile.txt
REG add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "NV Hostname" /t REG_SZ /d %PCNA% /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: "%PCNA%" wurde in CCS NV Hostname eingetragen^<br^> >>Logfile.txt
echo.


REM ******************************
REM * Programme konfigurieren *
REM ******************************
echo - Windows Media Player einrichten:
reg add "HKLM\Software\Policies\Microsoft\WindowsMediaPlayer" /v "GroupPrivacyAcceptance" /t REG_DWORD /d 1 /f && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Windows Media Player Anfangsmeldung deaktiviert ^<br^> >>Logfile.txt
echo.


REM *******************
REM * Windows Updates *
REM *******************
wuauclt /ShowWU


REM ***************
REM * Bereinigung *
REM ***************
:WEITER
echo - Unnoetige Restsoftware deinstallieren
appwiz.cpl
echo - Browserverlauf loeschen:
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 255 && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Browserverlauf geloescht ^<br^> >>Logfile.txt
echo - Papierkorb leeren:
rd /s /q C:\$Recycle.Bin && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Papierkorb geleert ^<br^> >>Logfile.txt
echo - Temp Ordner leeren:
del /q C:\Users\%USERNAME%\AppData\Local\Temp && echo %date:~0% %time:~0,8%::[%USERNAME%] PASSED: Temp Ordner geleert ^<br^> >>Logfile.txt
echo.


REM ********
REM * Ende *
REM ********
taskkill /f /im iexplore.exe
echo %date:~0% %time:~0,8%::[%USERNAME%] Systemaenderung %USERNAME% Ende ^<br^>^<br^> >>Logfile.txt
echo ^</body^> ^</html^> >>Logfile.txt
ren "C:\Admin\Batch\Logfile.txt" Logfile.html
cls
echo.
echo                                       ~~~                    
echo                                     [ o o ] 
echo  ******************************.oooO**(_)**Oooo.*******************************
echo  *                                                                            *
echo  *                                  E N D E                                   *
echo  *                                                                            *
echo  *              Unter C:\Admin\Batch wurde ein Logfile erstellt.              *
echo  *                                                                            *
echo  *                               .oooO                                        *
echo  *                               (   )   Oooo.                                *
echo  *********************************\ (****(   )*********************************
echo                                    \_)    ) /                  
echo                                          (_/
echo.
echo.
pause
del C:\Admin\Batch\Vorinstallation_v1.0.bat
exit
