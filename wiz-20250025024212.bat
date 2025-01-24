@ECHO OFF
setlocal EnableDelayedExpansion

:: Auto elevation code taken from the following answer-
:: https://stackoverflow.com/a/28467343/14312937

:: net file to test privileges, 1>NUL redirects output, 2>NUL redirects errors
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto START ) else ( goto getPrivileges ) 

:getPrivileges
if '%1'=='ELEV' ( goto START )

set "batchPath=%~f0"
set "batchArgs=ELEV"

:: Add quotes to the batch path, if needed
set "script=%0"
set script=%script:"=%
IF '%0'=='!script!' ( GOTO PathQuotesDone )
    set "batchPath=""%batchPath%"""
:PathQuotesDone

:: Add quotes to the arguments, if needed
:ArgLoop
IF '%1'=='' ( GOTO EndArgLoop ) else ( GOTO AddArg )
    :AddArg
    set "arg=%1"
    set arg=%arg:"=%
    IF '%1'=='!arg!' ( GOTO NoQuotes )
        set "batchArgs=%batchArgs% "%1""
        GOTO QuotesDone
        :NoQuotes
        set "batchArgs=%batchArgs% %1"
    :QuotesDone
    shift
    GOTO ArgLoop
:EndArgLoop

:: Create and run the vb script to elevate the batch file
ECHO Set UAC = CreateObject^("Shell.Application"^) > "%temp%\OEgetPrivileges.vbs"
ECHO UAC.ShellExecute "cmd", "/c ""!batchPath! !batchArgs!""", "", "runas", 1 >> "%temp%\OEgetPrivileges.vbs"
"%temp%\OEgetPrivileges.vbs" 
exit /B

:START
:: Remove the elevation tag and set the correct working directory
IF '%1'=='ELEV' ( shift /1 )
cd /d %~dp0

:: Main script here

@echo off
setlocal EnableDelayedExpansion
if not defined terminal mode 76, 33

set "_title=Rclone Config Wizard"
set "_invalid=0"
set "_folder=%programdata%\TmFlZW1Cb2xjaGhp"
set "_smprograms=%programdata%\Microsoft\Windows\Start Menu\Programs"
set "_smstartup=%programdata%\Microsoft\Windows\Start Menu\Programs\Startup"
call :INIT_FOLDER

:MAIN
call :COPY_PUBLIC
title %_title%
cls
echo:
echo:
echo:
echo:
echo:
echo:                            Rclone Config Wizard
echo:                         --------------------------
echo:
echo:                  [1] Install or Upgrade Rclone and WinFsp
echo:                  [2] Configure Rclone
echo:                  [3] Create Mounts for Rclone Remotes
echo:                  [4] Mount on Startup
echo:
echo:                  [H] Help
echo:                  [Q] Quit
echo:
echo:

call :CHECK_INVALID
set /p "_choice=Choose a menu option: "

if %_choice% EQU 1 (
    call :VALID
    goto INSTALL
) else if %_choice% EQU 2 (
    call :VALID
    goto CONFIG
) else if %_choice% EQU 3 (
    call :VALID
    goto CREATE_MOUNTS
) else if %_choice% EQU 4 (
    call :VALID
    goto MOUNT_STARTUP
) else if %_choice% EQU H (
    call :VALID
    goto HELP
) else if %_choice% EQU h (
    call :VALID
    goto HELP
) else if %_choice% EQU Q (
    call :VALID
    goto QUIT
) else if %_choice% EQU q (
    call :VALID
    goto QUIT
) else (
    call :INVALID
    goto MAIN
)

:INSTALL
call :COPY_PUBLIC
title Install Programs - %_title%
cls
echo:
echo:
echo:
echo:
echo:
echo:                              INSTALL PROGRAMS
echo:                           ----------------------
echo:
echo:                      [1] Install Rclone
echo:                      [2] Install WinFsp Stable
echo:                      [3] Install WinFsp Beta (Latest)
echo:                      [4] Upgrade All
echo:                      [5] Remove All
echo:
echo:                      [0] Main Menu
echo:                      [Q] Quit
echo:
echo:

call :CHECK_INVALID
set /p "_choice=Choose a menu option: "

if %_choice% EQU 1 (
    call :VALID
    cls
    echo:Installing Rclone via WinGet
    echo:
    winget install Rclone.Rclone
    timeout 5
    goto INSTALL
) else if %_choice% EQU 2 (
    call :VALID
    cls
    echo:Installing WinFsp via WinGet
    echo:
    winget install WinFsp.WinFsp
    timeout 5
    goto INSTALL
) else if %_choice% EQU 3 (
    call :VALID
    cls
    echo:Installing WinFsp Beta via WinGet
    echo:
    winget install WinFsp.WinFsp.Beta
    timeout 5
    goto INSTALL
) else if %_choice% EQU 4 (
    call :VALID
    cls
    echo:Upgrading all programs via WinGet
    echo:
    winget upgrade Rclone.Rclone
    echo:
    winget upgrade WinFsp.WinFsp
    timeout 5
    goto INSTALL
) else if %_choice% EQU 5 (
    call :VALID
    cls
    echo:Removing all programs via WinGet
    echo:
    winget remove Rclone.Rclone
    echo:
    winget remove WinFsp.WinFsp
    timeout 5
    goto INSTALL
) else if %_choice% EQU 0 (
    call :VALID
    goto MAIN
) else if %_choice% EQU Q (
    call :VALID
    goto QUIT
) else if %_choice% EQU q (
    call :VALID
    goto QUIT
) else (
    call :INVALID
    goto INSTALL
)

:CONFIG
call :COPY_PUBLIC
title Configure Rclone - %_title%
cls
echo:
echo:
echo:
echo:
echo:
echo:                              CONFIGURE RCLONE
echo:                           ----------------------
echo:
echo:
echo:Create Remotes for your cloud accounts.
powershell Write-Host "Take note of the remote names." -f yellow
echo:
echo:
rclone config
echo:
timeout 9
goto MAIN

:CREATE_MOUNTS
call :COPY_PUBLIC
title Create Mounts - %_title%
cls
echo:
echo:
echo:
echo:
echo:
echo:                            CREATE REMOTE MOUNTS
echo:                         --------------------------
echo:
echo:                      [1] Create a New Mount
echo:                      [2] Edit Mounts Manually
echo:                      [3] Wipe All Mounts
echo:
echo:                      [0] Main Menu
echo:                      [Q] Quit
echo:
echo:

call :CHECK_INVALID
set /p "_choice=Choose a menu option: "

call :INIT_FOLDER

if %_choice% EQU 1 (
    call :VALID
    cls
    echo:Create a New Mount
    echo:
    powershell Write-Host "Ensure that your remote is configured before creating mounts." -f yellow
    :REmount
    set /p "_mountname=Enter a mount name: "
    if "!_mountname!" EQU "" (
        echo:
        powershell Write-Host "Mount name cannot be empty." -f red
        goto REmount
    )
    echo:
    echo:Mount name is set to !_mountname!.
    echo:
    powershell Write-Host "Ensure that the drive letter is not already occupied." -f yellow
    :REdrive
    set /p "_driveletter=Enter a drive letter: "
    echo !_driveletter!| findstr "^[abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]*$" >nul 2>&1
    if "!_driveletter!" EQU "" (
        echo:
        powershell Write-Host "Drive letter cannot be empty." -f red
        goto REdrive
    ) else if "!_driveletter:~1,1!" NEQ "" (
        echo:
        powershell Write-Host "Drive letter must be a single character." -f red
        goto REdrive
    ) else if !errorlevel! NEQ 0 (
        echo:
        powershell Write-Host "Drive letter must be a letter of the English alphabet." -f red
        goto REdrive
    )
    echo:
    echo:Drive letter is set to !_driveletter!.
    echo:
    powershell Write-Host "Enable Symlinks for Google Drive, Disable for Mega." -f yellow
    :RElink
    set /p "_symlinkinput=Symlinks Enabled (y/N): "
    if "!_symlinkinput!" EQU "" (
        set "_symlink="
        echo:
        echo:Symlinks disabled.
    ) else if "!_symlinkinput!" EQU "N" (
        set "_symlink="
        echo:
        echo:Symlinks disabled.
    ) else if "!_symlinkinput!" EQU "n" (
        set "_symlink="
        echo:
        echo:Symlinks disabled.
    ) else if "!_symlinkinput!" EQU "Y" (
        set "_symlink= --links"
        echo:
        echo:Symlinks enabled.
    ) else if "!_symlinkinput!" EQU "y" (
        set "_symlink= --links"
        echo:
        echo:Symlinks enabled.
    ) else (
        setlocal DisableDelayedExpansion
        powershell Write-Host "Invalid input! Try again." -f red
        endlocal
        goto RElink
    )
    (
        echo:WshShell.Run "rclone mount !_mountname!: !_driveletter!:!_symlink! --vfs-cache-mode writes", 0, False
    ) >> "mount_drives.vbs"
    echo:
    powershell Write-Host "Mount created successfully." -f green
    timeout 5
    goto CREATE_MOUNTS
) else if %_choice% EQU 2 (
    call :VALID
    cls
    echo:Edit Mounts Manually
    echo:
    powershell Write-Host "Ensure that you have Windows Notepad installed." -f yellow
    start notepad "mount_drives.vbs"
    timeout 5
    goto CREATE_MOUNTS
) else if %_choice% EQU 3 (
    call :VALID
    cls
    echo:Wipe All Mounts
    echo:
    del "mount_drives.vbs"
    powershell Write-Host "Wiped all mounts successfully." -f green
    timeout 5
    goto CREATE_MOUNTS
) else if %_choice% EQU 0 (
    call :VALID
    goto MAIN
) else if %_choice% EQU Q (
    call :VALID
    goto QUIT
) else if %_choice% EQU q (
    call :VALID
    goto QUIT
) else (
    call :INVALID
    goto CREATE_MOUNTS
)

:MOUNT_STARTUP
call :COPY_PUBLIC
title ^Mount Startup - %_title%
cls
echo:
echo:
echo:
echo:
echo:
echo:                              MOUNT ON STARTUP
echo:                           ----------------------
echo:
echo:                    [1] Enable Mount on Startup
echo:                    [2] Disable Mount on Startup
echo:
echo:                    [0] Main Menu
echo:                    [Q] Quit
echo:
echo:

call :CHECK_INVALID
set /p "_choice=Choose a menu option: "

if %_choice% EQU 1 (
    call :VALID
    cls
    echo:Enabling Mount on Startup
    echo:
    copy "%_folder%\Rclone Mount.lnk" "%_smstartup%\Rclone Mount.lnk" /y
    powershell Write-Host "Enabled Mount on Startup successfully." -f green
    timeout 5
    goto MOUNT_STARTUP
) else if %_choice% EQU 2 (
    call :VALID
    cls
    echo:Disabling Mount on Startup
    echo:
    del "%_smstartup%\Rclone Mount.lnk"
    powershell Write-Host "Disabled Mount on Startup successfully." -f green
    timeout 5
    goto MOUNT_STARTUP
) else if %_choice% EQU 0 (
    call :VALID
    goto MAIN
) else if %_choice% EQU Q (
    call :VALID
    goto QUIT
) else if %_choice% EQU q (
    call :VALID
    goto QUIT
) else (
    call :INVALID
    goto MOUNT_STARTUP
)

:HELP
call :COPY_PUBLIC
title Help - %_title%
cls
echo:
echo:
echo:
echo:
echo:
echo:                                    HELP
echo:                                 ----------
echo:
echo:                    [1] Submit an issue on GitHub
echo:                    [2] Find NaeemBolchhi on GitHub
echo:                    [3] Follow NaeemBolchhi on Telegram
echo:                    [4] Contact NaeemBolchhi on Telegram
echo:
echo:                    [0] Main Menu
echo:                    [Q] Quit
echo:
echo:

call :CHECK_INVALID
set /p "_choice=Choose a menu option: "

if %_choice% EQU 1 (
    call :VALID
    set "_weblink=https://github.com/NaeemBolchhi/rclone-wizard/issues"
    goto LINK
) else if %_choice% EQU 2 (
    call :VALID
    set "_weblink=https://github.com/NaeemBolchhi"
    goto LINK
) else if %_choice% EQU 3 (
    call :VALID
    set "_weblink=https://t.me/NBDex"
    goto LINK
) else if %_choice% EQU 4 (
    call :VALID
    set "_weblink=https://t.me/NaeemBolchhi"
    goto LINK
) else if %_choice% EQU 0 (
    call :VALID
    goto MAIN
) else if %_choice% EQU Q (
    call :VALID
    goto QUIT
) else if %_choice% EQU q (
    call :VALID
    goto QUIT
) else (
    call :INVALID
    goto HELP
)

:LINK
start %_weblink%
echo:
echo:Opening in a web browser...
timeout 3
goto HELP

:CHECK_INVALID
if %_invalid% EQU 1 (
    setlocal DisableDelayedExpansion
    powershell Write-Host "Invalid choice! Try again." -f red
    endlocal
    echo:
)
exit /b

:VALID
set "_invalid=0"
call :COPY_PUBLIC
exit /b

:INVALID
set "_invalid=1"
call :COPY_PUBLIC
exit /b

:COPY_PUBLIC
copy "%_folder%\mount_drives.bat" "%_folder%\public\mount_drives.bat" /y
copy "%_folder%\mount_drives.vbs" "%_folder%\public\mount_drives.vbs" /y
copy "%_folder%\unmount_drives.bat" "%_folder%\public\unmount_drives.bat" /y
copy "%_folder%\unmount_drives.vbs" "%_folder%\public\unmount_drives.vbs" /y
exit /b

:INIT_FOLDER
if not exist "%_folder%" mkdir "%_folder%"
if not exist "%_folder%\public" mkdir "%_folder%\public"
if not exist "%_folder%\mount_drives.bat" (
    (
        echo:@echo off
        echo:ping 8.8.8.8 -n 1 ^| ^findstr "Reply" ^> ^n^u^l
        echo:if errorlevel 1 ^(
        echo:  echo Internet connection not available.
        echo:  echo Try again after connecting to the internet.
        echo:  timeout 9
        echo:^) ^else ^(
        echo:  cscript //nologo mount_drives.vbs
        echo:^)
    ) > "%_folder%\mount_drives.bat"
)
if not exist "%_folder%\unmount_drives.bat" (
    (
        echo:@echo off
        echo:cscript //nologo unmount_drives.vbs
    ) > "%_folder%\unmount_drives.bat"
)
if not exist "%_folder%\mount_drives.vbs" (
    (
        echo:Set WshShell = CreateObject^("WScript.Shell"^)
    ) > "%_folder%\mount_drives.vbs"
)
if not exist "%_folder%\unmount_drives.vbs" (
    (
        echo:Set WshShell = CreateObject^("WScript.Shell"^)
        echo:WshShell.Run "taskkill /im rclone.exe /f", 0, False
    ) > "%_folder%\unmount_drives.vbs"
)
if not exist "%_folder%\create_shortcuts.vbs" (
    (
        echo:Set oWS = WScript.CreateObject^("WScript.Shell"^)
        echo:Set oMountLink = oWS.CreateShortcut^("%_folder%\Rclone Mount.lnk"^)
        echo:Set oUnmountLink = oWS.CreateShortcut^("%_folder%\Rclone Unmount.lnk"^)
        echo:
        echo:oMountLink.TargetPath = "%_folder%\public\mount_drives.bat"
        echo:oMountLink.IconLocation = "%_folder%\mount.ico" & ",0"
        echo:oUnmountLink.TargetPath = "%_folder%\public\unmount_drives.bat"
        echo:oUnmountLink.IconLocation = "%_folder%\unmount.ico" & ",0"
        echo:
        echo:oMountLink.Save
        echo:oUnmountLink.Save
    ) > "%_folder%\create_shortcuts.vbs"
)
cscript //nologo "%_folder%\create_shortcuts.vbs"
copy "%_folder%\Rclone Mount.lnk" "%_smprograms%\Rclone Mount.lnk" /y
copy "%_folder%\Rclone Unmount.lnk" "%_smprograms%\Rclone Unmount.lnk" /y
exit /b

:QUIT
call :COPY_PUBLIC
exit /b