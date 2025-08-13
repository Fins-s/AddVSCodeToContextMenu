@echo off
:: =======================================================================
::  Add-VSCodeToContextMenu.bat
::  把“使用 VS Code 打开”添加到资源管理器右键菜单
::  支持单文件、文件夹、磁盘背景、库背景
::  默认仅对当前用户生效；若需对所有用户，请以管理员身份运行并在第55行
::  设置 "ROOT=HKCR"。
:: =======================================================================
title VS Code 右键菜单 安装/卸载脚本
setlocal EnableDelayedExpansion

::-------------------- 用户配置区 ---------------------------------------
:: 如果 VS Code 不在默认位置，请把完整路径填在下面（含 Code.exe）
set "CodePath="
:: 留空则脚本会自动在以下位置查找
:: 当前文件夹\Code.exe
:: %LOCALAPPDATA%\Programs\Microsoft VS Code\Code.exe
:: %ProgramFiles%\Microsoft VS Code\Code.exe
:: %ProgramFiles(x86)%\Microsoft VS Code\Code.exe
::-----------------------------------------------------------------------

::-------------------- 自动查找 VS Code ---------------------------------
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
    echo 未找到 VS Code，请手动指定 CodePath 后重试。
    pause & exit /b 1
)

:found
echo 检测到 VS Code 路径：%CodePath%
echo.

::-------------------- 询问安装还是卸载 ---------------------------------
set /p choice="安装还是卸载？ [I=安装 / U=卸载]："
if /i "%choice%"=="U" goto :uninstall
if /i "%choice%"=="I" goto :install
goto :eof

::=======================================================================
:install
::-------------------- 仅当前用户：写 HKCU\Software\Classes -------------
::---------------------- 所有用户: 写 HKCR ------------------------------
set "ROOT=HKCU\Software\Classes"
call :writeRegistry
echo 安装完成！重启资源管理器生效……
taskkill /f /im explorer.exe >nul 2>&1
start "" explorer.exe
goto :eof

::-------------------- 卸载 ---------------------------------------------
:uninstall
reg delete "%ROOT%\*\shell\VSCode" /f >nul 2>&1
reg delete "%ROOT%\Directory\shell\VSCode" /f >nul 2>&1
reg delete "%ROOT%\Directory\Background\shell\VSCode" /f >nul 2>&1
reg delete "%ROOT%\LibraryFolder\Background\shell\VSCode" /f >nul 2>&1
echo 卸载完成！重启资源管理器生效……
taskkill /f /im explorer.exe >nul 2>&1
start "" explorer.exe
goto :eof

::=======================================================================
:writeRegistry
:: 单文件
reg add "%ROOT%\*\shell\VSCode" /ve /t REG_SZ /d "使用 VS Code 打开" /f >nul
reg add "%ROOT%\*\shell\VSCode" /t REG_EXPAND_SZ /v  "Icon" /d "\"%CodePath%\"" /f >nul
reg add "%ROOT%\*\shell\VSCode\command" /ve /t REG_SZ /d "\"%CodePath%\" \"%%1\"" /f >nul

:: 文件夹
reg add "%ROOT%\Directory\shell\VSCode" /ve /t REG_SZ /d "使用 VS Code 打开" /f >nul
reg add "%ROOT%\Directory\shell\VSCode" /t REG_EXPAND_SZ /v "Icon" /d "\"%CodePath%\"" /f >nul
reg add "%ROOT%\Directory\shell\VSCode\command" /ve /t REG_SZ /d "\"%CodePath%\" \"%%1\"" /f >nul

:: 文件夹空白处 / 磁盘根目录
reg add "%ROOT%\Directory\Background\shell\VSCode" /ve /t REG_SZ /d "使用 VS Code 打开" /f >nul
reg add "%ROOT%\Directory\Background\shell\VSCode" /t REG_EXPAND_SZ /v  "Icon" /d "\"%CodePath%\"" /f >nul
reg add "%ROOT%\Directory\Background\shell\VSCode\command" /ve /t REG_SZ /d "\"%CodePath%\" \"%%V\"" /f >nul

:: Windows 10/11 库窗口背景
reg add "%ROOT%\LibraryFolder\Background\shell\VSCode" /ve /t REG_SZ /d "使用 VS Code 打开" /f >nul
reg add "%ROOT%\LibraryFolder\Background\shell\VSCode" /t REG_EXPAND_SZ /v  "Icon" /d "\"%CodePath%\"" /f >nul
reg add "%ROOT%\LibraryFolder\Background\shell\VSCode\command" /ve /t REG_SZ /d "\"%CodePath%\" \"%%V\"" /f >nul
goto :eof