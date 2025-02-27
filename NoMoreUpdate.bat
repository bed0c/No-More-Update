@echo off
title Windows Update Remover - Coded by bed0c
mode con: cols=90 lines=30
color 0A
echo ========================================================
echo          Windows Update Remover - Coded by bed0c
echo       Completely Disables & Removes Windows Update
echo ========================================================
echo.

:: Stop all related services
echo Stopping Windows Update services...
net stop wuauserv /y >nul 2>&1
net stop UsoSvc /y >nul 2>&1
net stop dosvc /y >nul 2>&1
net stop bits /y >nul 2>&1
net stop WaaSMedicSvc /y >nul 2>&1
net stop wscsvc /y >nul 2>&1
net stop TrustedInstaller /y >nul 2>&1

:: Delete Windows Update services
echo Removing Windows Update services...
sc delete wuauserv >nul 2>&1
sc delete UsoSvc >nul 2>&1
sc delete dosvc >nul 2>&1
sc delete bits >nul 2>&1
sc delete WaaSMedicSvc >nul 2>&1
sc delete wscsvc >nul 2>&1
sc delete TrustedInstaller >nul 2>&1

:: Remove Windows Update registry entries
echo Modifying registry to disable Windows Update...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DisableWindowsUpdateAccess" /t REG_DWORD /d 1 /f >nul
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d 1 /f >nul
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wuauserv" /v "Start" /t REG_DWORD /d 4 /f >nul
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\UsoSvc" /v "Start" /t REG_DWORD /d 4 /f >nul
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\bits" /v "Start" /t REG_DWORD /d 4 /f >nul
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc" /v "Start" /t REG_DWORD /d 4 /f >nul

:: Delete Windows Update folders
echo Deleting Windows Update files...
takeown /f "%WINDIR%\SoftwareDistribution" /a /r /d y >nul
icacls "%WINDIR%\SoftwareDistribution" /grant Administrators:F /t >nul
rd /s /q "%WINDIR%\SoftwareDistribution" >nul

takeown /f "%WINDIR%\System32\Tasks\Microsoft\Windows\WindowsUpdate" /a /r /d y >nul
icacls "%WINDIR%\System32\Tasks\Microsoft\Windows\WindowsUpdate" /grant Administrators:F /t >nul
rd /s /q "%WINDIR%\System32\Tasks\Microsoft\Windows\WindowsUpdate" >nul

takeown /f "%WINDIR%\System32\Tasks\Microsoft\Windows\WaaSMedic" /a /r /d y >nul
icacls "%WINDIR%\System32\Tasks\Microsoft\Windows\WaaSMedic" /grant Administrators:F /t >nul
rd /s /q "%WINDIR%\System32\Tasks\Microsoft\Windows\WaaSMedic" >nul

:: Delete Windows Update files
echo Removing Windows Update system files...
takeown /f "%WINDIR%\System32\wuauserv.dll" /a >nul
icacls "%WINDIR%\System32\wuauserv.dll" /grant Administrators:F >nul
del /f /q "%WINDIR%\System32\wuauserv.dll" >nul

takeown /f "%WINDIR%\System32\WaaSMedicSvc.dll" /a >nul
icacls "%WINDIR%\System32\WaaSMedicSvc.dll" /grant Administrators:F >nul
del /f /q "%WINDIR%\System32\WaaSMedicSvc.dll" >nul

:: Remove Windows Update scheduled tasks
echo Deleting scheduled tasks related to Windows Update...
schtasks /delete /tn "Microsoft\Windows\WindowsUpdate" /f >nul 2>&1
schtasks /delete /tn "Microsoft\Windows\WaaSMedic\PerformRemediation" /f >nul 2>&1
schtasks /delete /tn "Microsoft\Windows\WaaSMedic\RunFullScheduledScan" /f >nul 2>&1

echo.
echo ========================================================
echo  Windows Update has been completely removed!
echo  System will restart in 10 seconds...
echo ========================================================
timeout /t 10 /nobreak
shutdown /r /f /t 0
exit
