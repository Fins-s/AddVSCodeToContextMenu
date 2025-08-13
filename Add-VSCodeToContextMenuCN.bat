@echo off
:: =======================================================================
::  Add-VSCodeToContextMenu.bat
::  �ѡ�ʹ�� VS Code �򿪡���ӵ���Դ�������Ҽ��˵�
::  ֧�ֵ��ļ����ļ��С����̱������ⱳ��
::  Ĭ�Ͻ��Ե�ǰ�û���Ч������������û������Թ���Ա������в��ڵ�55��
::  ���� "ROOT=HKCR"��
:: =======================================================================
title VS Code �Ҽ��˵� ��װ/ж�ؽű�
setlocal EnableDelayedExpansion

::-------------------- �û������� ---------------------------------------
:: ��� VS Code ����Ĭ��λ�ã��������·���������棨�� Code.exe��
set "CodePath="
:: ������ű����Զ�������λ�ò���
:: ��ǰ�ļ���\Code.exe
:: %LOCALAPPDATA%\Programs\Microsoft VS Code\Code.exe
:: %ProgramFiles%\Microsoft VS Code\Code.exe
:: %ProgramFiles(x86)%\Microsoft VS Code\Code.exe
::-----------------------------------------------------------------------

::-------------------- �Զ����� VS Code ---------------------------------
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
    echo δ�ҵ� VS Code�����ֶ�ָ�� CodePath �����ԡ�
    pause & exit /b 1
)

:found
echo ��⵽ VS Code ·����%CodePath%
echo.

::-------------------- ѯ�ʰ�װ����ж�� ---------------------------------
set /p choice="��װ����ж�أ� [I=��װ / U=ж��]��"
if /i "%choice%"=="U" goto :uninstall
if /i "%choice%"=="I" goto :install
goto :eof

::=======================================================================
:install
::-------------------- ����ǰ�û���д HKCU\Software\Classes -------------
::---------------------- �����û�: д HKCR ------------------------------
set "ROOT=HKCU\Software\Classes"
call :writeRegistry
echo ��װ��ɣ�������Դ��������Ч����
taskkill /f /im explorer.exe >nul 2>&1
start "" explorer.exe
goto :eof

::-------------------- ж�� ---------------------------------------------
:uninstall
reg delete "%ROOT%\*\shell\VSCode" /f >nul 2>&1
reg delete "%ROOT%\Directory\shell\VSCode" /f >nul 2>&1
reg delete "%ROOT%\Directory\Background\shell\VSCode" /f >nul 2>&1
reg delete "%ROOT%\LibraryFolder\Background\shell\VSCode" /f >nul 2>&1
echo ж����ɣ�������Դ��������Ч����
taskkill /f /im explorer.exe >nul 2>&1
start "" explorer.exe
goto :eof

::=======================================================================
:writeRegistry
:: ���ļ�
reg add "%ROOT%\*\shell\VSCode" /ve /t REG_SZ /d "ʹ�� VS Code ��" /f >nul
reg add "%ROOT%\*\shell\VSCode" /t REG_EXPAND_SZ /v  "Icon" /d "\"%CodePath%\"" /f >nul
reg add "%ROOT%\*\shell\VSCode\command" /ve /t REG_SZ /d "\"%CodePath%\" \"%%1\"" /f >nul

:: �ļ���
reg add "%ROOT%\Directory\shell\VSCode" /ve /t REG_SZ /d "ʹ�� VS Code ��" /f >nul
reg add "%ROOT%\Directory\shell\VSCode" /t REG_EXPAND_SZ /v "Icon" /d "\"%CodePath%\"" /f >nul
reg add "%ROOT%\Directory\shell\VSCode\command" /ve /t REG_SZ /d "\"%CodePath%\" \"%%1\"" /f >nul

:: �ļ��пհ״� / ���̸�Ŀ¼
reg add "%ROOT%\Directory\Background\shell\VSCode" /ve /t REG_SZ /d "ʹ�� VS Code ��" /f >nul
reg add "%ROOT%\Directory\Background\shell\VSCode" /t REG_EXPAND_SZ /v  "Icon" /d "\"%CodePath%\"" /f >nul
reg add "%ROOT%\Directory\Background\shell\VSCode\command" /ve /t REG_SZ /d "\"%CodePath%\" \"%%V\"" /f >nul

:: Windows 10/11 �ⴰ�ڱ���
reg add "%ROOT%\LibraryFolder\Background\shell\VSCode" /ve /t REG_SZ /d "ʹ�� VS Code ��" /f >nul
reg add "%ROOT%\LibraryFolder\Background\shell\VSCode" /t REG_EXPAND_SZ /v  "Icon" /d "\"%CodePath%\"" /f >nul
reg add "%ROOT%\LibraryFolder\Background\shell\VSCode\command" /ve /t REG_SZ /d "\"%CodePath%\" \"%%V\"" /f >nul
goto :eof