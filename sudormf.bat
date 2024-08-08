@echo off
SETLOCAL

:: Check if the file/folder path is provided
IF "%~1"=="" (
    echo Usage: %~nx0 ^<file_or_folder_path^>
    EXIT /B 1
)

:: Store the file/folder path from the command-line argument
SET TARGET_PATH=%~1

:: Check if the path is a file or directory
IF EXIST "%TARGET_PATH%\" (
    SET IS_DIR=1
) ELSE (
    SET IS_DIR=0
)

:: Take ownership of the file or directory
echo Taking ownership of %TARGET_PATH%
takeown /f "%TARGET_PATH%" /r /d y >nul 2>&1

:: Grant full permissions to the administrators
echo Granting full permissions to administrators
icacls "%TARGET_PATH%" /grant administrators:F /t /c >nul 2>&1

:: Delete the file or directory
IF %IS_DIR%==1 (
    echo Deleting directory %TARGET_PATH%
    rd /s /q "%TARGET_PATH%" >nul 2>&1
) ELSE (
    echo Deleting file %TARGET_PATH%
    del /F "%TARGET_PATH%" >nul 2>&1
)

:: Verify if deletion was successful
IF EXIST "%TARGET_PATH%" (
    echo Failed to delete %TARGET_PATH%.
) ELSE (
    echo %TARGET_PATH% successfully deleted.
)

ENDLOCAL
