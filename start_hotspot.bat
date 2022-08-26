@echo off
title .:: Hosted Network ::.
color 0e
cls

if not "%1"=="am_admin" (powershell start -verb runas '%0' am_admin & exit /b)
setlocal enableextensions disabledelayedexpansion

:MENU
cls
echo.
echo ________________________________________________________________________________
echo.
echo                                 .:: Arset Soft ::.
echo                            .:: https://arsetsoft.id ::.
echo.
echo ________________________________________________________________________________
echo.
echo                              .:: Pilih Menu ::.
echo.
echo [A] Start Hosted Network
echo [B] Status Hosted Network
echo [C] Stop Hosted Network
echo [D] Create Hosted Network
echo [E] Cek Hosted Network Support
echo [F] About
echo [G] Exit
echo.
SET /P "C=[A, B, C, D, E, F, G] ? "
if [%C%]==[A] goto CEK
if [%C%]==[B] goto STATUS
if [%C%]==[C] goto STOP
if [%C%]==[D] goto CREATE
if [%C%]==[E] goto SUPPORT
if [%C%]==[F] goto ABOUT
if [%C%]==[G] goto KELUAR
goto MENU

:SUPPORT
cls
netsh wlan show driver | findstr -i "Hosted" 
pause > nul
goto MENU

:CREATE
cls
ipconfig /release
ipconfig /renew
ipconfig /flushdns
cls
set /P "NameSSID=Masukkan SSID : "
Call:InputPassword "Masukkan Password " PassSSID
netsh wlan set hostednetwork mode=allow ssid=%NameSSID% key=%PassSSID% > nul
echo.
echo.
netsh wlan start hostednetwork > nul
echo Berhasil Membuat Hosted Network !!
echo Hosted Network Status Start...
pause > nul
echo.
echo.
echo Please Sharing Local Area Network...
echo.
echo 1. Pilih Network yang terdapat jaringan Internet, Klik kanan lalu pilih Properties, pilih Tab Sharing.
echo 2. Cheklist pada 'Allow other network', Pilih Share to Hosted Network Virtual
echo 3. Okey !! Enjoy the Internet...
echo.
control ncpa.cpl
pause > nul
goto MENU

:InputPassword
set "psCommand=powershell -Command "$pword = read-host '%1' -AsSecureString ; ^
    $BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pword); ^
      [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)""
        for /f "usebackq delims=" %%p in (`%psCommand%`) do set %2=%%p
)
goto :eof   

:STOP
cls
netsh wlan stop hostednetwork
cls
echo Hosted Network Status STOP...
pause > nul
goto MENU

:STATUS
cls
netsh wlan show hostednetwork | findstr -i "Status" 
echo SSID Name
netsh wlan show hostednetwork | findstr -i "SSID"
netsh wlan show hostednetwork setting=security
echo Connected Clients
netsh wlan show hostednetwork | findstr -i "Number of clients"
pause > nul
goto MENU

:CEK
cls
netsh wlan show hostednetwork | findstr -i "Status" | find "Started"
if errorlevel 1 goto MULAI
cls
echo Hosted Network Sedang Berjalan...
pause > nul
goto MENU

:MULAI
cls
netsh wlan start hostednetwork
cls
echo Hosted Network Status Start...
pause > nul
goto MENU

:ABOUT
cls
echo.
echo ________________________________________________________________________________
echo.
echo                                 .:: Arset Soft ::.
echo                            .:: https://arsetsoft.id ::.
echo.
echo ________________________________________________________________________________
echo.
echo .:: Main Features ::.
echo    - Improve! User Interface
echo    - Improve! Support Windows 10
echo    - Portable Application
echo    - Max Number of client 100
echo    - You create password to hidden
echo.
pause>nul
goto MENU

:KELUAR
EXIT /B