@echo off
:: =======================================================================
::  Add-VSCodeToContextMenu.bat
::  Add "Open with VS Code" to context menu
::  Suppoert file, folder, directory background, libraryfolder background
::  Only take effect with current user by default, if effect all user is needed,
::  please run as Administrator and set "ROOT=HKCR" at line 55
:: =======================================================================
title VS Code ContextMenu install/uninstall script
setlocal EnableDelayedExpansion

::-------------------- user configration ---------------------------------
:: if VS Code not in default path, please fill full path below?include Code.exe?
set "CodePath="
:: if "CodePath" keep empty, script will search Code.exe at path below:
:: .\Code.exe
:: %LOCALAPPDATA%\Programs\Microsoft VS Code\Code.exe
:: %ProgramFiles%\Microsoft VS Code\Code.exe
:: %ProgramFiles(x86)%\Microsoft VS Code\Code.exe
::-----------------------------------------------------------------------

::-------------------- auto search VS Code ---------------------------------
set "SCRIPT_DIR=%~dp0"
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"
if not defined CodePath (
    for %%P in (
        "%SCRIPT_DIR%\Code.exe"
        "%LOCALAPPDATA%\Programs\Microsoft VS Code\Code.exe"
        "%ProgramFiles%\Microsoft VS Code\Code.exe"
        "%ProgramFiles(x86)%\Microsoft VS Code\Code.exe"
    ) do (
        if exist "%%~P" (
            set "CodePath=%%~P"
            goto :found
        )
    )
    echo Cant find VS Code, please set "CodePath" menully and retry !!!
    pause & exit /b 1
)

:found
echo VS Code detected at : %CodePath%
echo.

::-------------------- ask install or uninstall -------------------------
set /p choice="install or uninstall [I=install / U=uninstall]: "
if /i "%choice%"=="U" goto :uninstall
if /i "%choice%"=="I" goto :install
goto :eof

::=======================================================================
:install
::-------------- only current user : set HKCU\Software\Classes ----------
::----------------------- all user : set HKCR ---------------------------
set "ROOT=HKCU\Software\Classes"
call :writeRegistry
echo Install complete ! Restarting the explorer.exe ...
taskkill /f /im explorer.exe >nul 2>&1
start "" explorer.exe
goto :eof

::-------------------- uninstall ----------------------------------------
:uninstall
reg delete "%ROOT%\*\shell\VSCode" /f >nul 2>&1
reg delete "%ROOT%\Directory\shell\VSCode" /f >nul 2>&1
reg delete "%ROOT%\Directory\Background\shell\VSCode" /f >nul 2>&1
reg delete "%ROOT%\LibraryFolder\Background\shell\VSCode" /f >nul 2>&1
echo Install complete ! Restarting the explorer.exe ...
taskkill /f /im explorer.exe >nul 2>&1
start "" explorer.exe
goto :eof

::=======================================================================
:writeRegistry
:: File
reg add "%ROOT%\*\shell\VSCode" /ve /t REG_SZ /d "Open with VS Code" /f >nul
reg add "%ROOT%\*\shell\VSCode" /t REG_EXPAND_SZ /v  "Icon" /d "\"%CodePath%\"" /f >nul
reg add "%ROOT%\*\shell\VSCode\command" /ve /t REG_SZ /d "\"%CodePath%\" \"%%1\"" /f >nul

:: Folder
reg add "%ROOT%\Directory\shell\VSCode" /ve /t REG_SZ /d "Open with VS Code" /f >nul
reg add "%ROOT%\Directory\shell\VSCode" /t REG_EXPAND_SZ /v "Icon" /d "\"%CodePath%\"" /f >nul
reg add "%ROOT%\Directory\shell\VSCode\command" /ve /t REG_SZ /d "\"%CodePath%\" \"%%1\"" /f >nul

:: Directory background
reg add "%ROOT%\Directory\Background\shell\VSCode" /ve /t REG_SZ /d "Open with VS Code" /f >nul
reg add "%ROOT%\Directory\Background\shell\VSCode" /t REG_EXPAND_SZ /v  "Icon" /d "\"%CodePath%\"" /f >nul
reg add "%ROOT%\Directory\Background\shell\VSCode\command" /ve /t REG_SZ /d "\"%CodePath%\" \"%%V\"" /f >nul

:: LibraryFolder background
reg add "%ROOT%\LibraryFolder\Background\shell\VSCode" /ve /t REG_SZ /d "Open with VS Code" /f >nul
reg add "%ROOT%\LibraryFolder\Background\shell\VSCode" /t REG_EXPAND_SZ /v  "Icon" /d "\"%CodePath%\"" /f >nul
reg add "%ROOT%\LibraryFolder\Background\shell\VSCode\command" /ve /t REG_SZ /d "\"%CodePath%\" \"%%V\"" /f >nul
goto :eof