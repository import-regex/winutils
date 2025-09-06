#disable paging file (memory swap)
$path = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
Set-ItemProperty -Path $path -Name "PagingFiles" -Value ""

#disable hibernation file
powercfg -h off

#Disable login bullshit
 # 1) Remove current user's password
net user "$env:USERNAME" ""

 # 2) Enable auto login with blank password
$logonKey = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
Set-ItemProperty -Path $logonKey -Name "AutoAdminLogon" -Value "1"
Set-ItemProperty -Path $logonKey -Name "DefaultUserName" -Value "$env:UserName"
Set-ItemProperty -Path $logonKey -Name "DefaultPassword" -Value ""

 # 3) Disable password prompt after sleep
powercfg -setacvalueindex SCHEME_CURRENT SUB_NONE CONSOLELOCK 0
powercfg -setdcvalueindex SCHEME_CURRENT SUB_NONE CONSOLELOCK 0

 # 4) Completely turn off UAC prompts
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "PromptOnSecureDesktop" -Value 0

 # 5) Optional: Disable Ctrl+Alt+Delete requirement
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "DisableCAD" -Value 1

#Full visibility in explorer
 # Show hidden files/folders
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Value 1

 # Show protected operating system files (super hidden)
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSuperHidden" -Value 1

 # Show file name extensions
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0

 # Enable item checkboxes
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "AutoCheckSelect" -Value 1

# Admin privilleges on all terminals
Set-ExecutionPolicy Unrestricted -Force

#Set default sort to descending-date
 # Registry path for Explorer default view settings
$folderSettings = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Streams\Defaults'

 # Ensure the key exists
New-Item -Path $folderSettings -Force | Out-Null

 # Set sorting to "Date Modified" (Descending order, newest first)
Set-ItemProperty -Path $folderSettings -Name "Sort" -Value 3   # 3 = Date Modified
Set-ItemProperty -Path $folderSettings -Name "SortOrder" -Value 2  # 2 = Descending (newest first)

# Set the default folder view to 'Details' for all folder types in Explorer
 # 1) Clear any existing folder view customizations
Remove-Item "HKCU:\SOFTWARE\Microsoft\Windows\Shell\Bags" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "HKCU:\SOFTWARE\Microsoft\Windows\Shell\BagMRU" -Recurse -Force -ErrorAction SilentlyContinue

 # 2) Increase the folder customization cache size
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\Shell" `
 -Name "BagMRU Size" -Value 5000 -PropertyType DWORD -Force | Out-Null

 # 3) Create the "AllFolders" shell key and set the default view to Details
New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\Shell\Bags\AllFolders\Shell" -Force | Out-Null
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\Shell\Bags\AllFolders\Shell" -Name "Mode" -Value 4
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\Shell\Bags\AllFolders\Shell" -Name "LogicalViewMode" -Value 3

#Disable auto-sleep
powercfg -setacvalueindex SCHEME_CURRENT SUB_SLEEP STANDBYIDLE 0
powercfg -setdcvalueindex SCHEME_CURRENT SUB_SLEEP STANDBYIDLE 0
powercfg -SetActive SCHEME_CURRENT

#Screen sleep after 20 minutes
# Set screen sleep timeout to 20 minutes (1200 seconds) for both AC and DC power modes
powercfg -setacvalueindex SCHEME_CURRENT SUB_VIDEO VIDEOIDLE 1200
powercfg -setdcvalueindex SCHEME_CURRENT SUB_VIDEO VIDEOIDLE 1200
powercfg -SetActive SCHEME_CURRENT

#Disable OneDrive
 # Kill OneDrive process if running
Stop-Process -Name OneDrive -Force -ErrorAction SilentlyContinue

 # Prevent OneDrive from starting automatically
$onedriveRegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
Remove-ItemProperty -Path $onedriveRegPath -Name "OneDrive" -ErrorAction SilentlyContinue

 # Disable OneDrive via Group Policy (if available)
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" -Name "DisableFileSyncNGSC" -Value 1 -Type DWord

 # Uninstall OneDrive completely (optional)
Start-Process -FilePath "$env:SystemRoot\System32\OneDriveSetup.exe" -ArgumentList "/uninstall" -NoNewWindow -Wait

#Enable full visibility in explorer
 # --- ADVANCED EXPLORER OPTIONS ---
 # Always show icons, never thumbnails
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "IconsOnly" -Value 1
 # Decrease space between items (compact view)
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "UseCompactMode" -Value 1
 # Display file icon on thumbnails = off
 # (Disables small file-type icon overlay on thumbnails)
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ThumbnailAdornments" -Value 0
 # Display full path in the title bar
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "FullPath" -Value 1
 # Show hidden files, folders, and drives
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Value 1
 # Hide empty drives = off (i.e. show them)
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideDrivesWithNoMedia" -Value 0
 # Hide extensions for known file types = off (i.e. show file extensions)
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0
 # Hide folder merge conflicts = off (so they are shown)
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowFolderMergeConflicts" -Value 1
 # Hide protected operating system files = off (i.e. show them)
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSuperHidden" -Value 1
 # Restore previous folder windows at logon
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "PersistBrowsers" -Value 1
 # Show encrypted or compressed NTFS files in color
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowEncryptCompressedColor" -Value 1
 # --- APPLY THESE SETTINGS TO ALL FOLDERS ---
 # Clear existing folder view customizations
Remove-Item "HKCU:\SOFTWARE\Microsoft\Windows\Shell\Bags" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "HKCU:\SOFTWARE\Microsoft\Windows\Shell\BagMRU" -Recurse -Force -ErrorAction SilentlyContinue
 # Increase folder cache size
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\Shell" -Name "BagMRU Size" -Value 5000 -PropertyType DWORD -Force | Out-Null
 # Create default bag for AllFolders and set view to Details (Mode=4, LogicalViewMode=3)
New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\Shell\Bags\AllFolders\Shell" -Force | Out-Null
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\Shell\Bags\AllFolders\Shell" -Name "Mode" -Value 4
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\Shell\Bags\AllFolders\Shell" -Name "LogicalViewMode" -Value 3

#Disable wake-up timers
powercfg -setacvalueindex SCHEME_CURRENT SUB_SLEEP AllowWakeTimers 0
powercfg -setdcvalueindex SCHEME_CURRENT SUB_SLEEP AllowWakeTimers 0
powercfg -SetActive SCHEME_CURRENT

#disable network adapter wake-up
powercfg -lastwake
echo "look at this list ^^. now place the names of bullshit that shouldnt wake in the disablewake lists below"
Get-NetAdapter | Where-Object { $_.Name -like "*Realtek*" } | ForEach-Object {
    Set-NetAdapterPowerManagement -Name $_.Name -WakeOnMagicPacket Disabled -WakeOnPatternDisabled $true
}
powercfg -devicedisablewake "Realtek Gaming 2.5GbE Family Controller"

#disable bing search in start menu
 # Create policy key if it doesn't exist
New-Item -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
 # Disable all web/Bing searches
New-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" `
 -Name "ConnectedSearchUseWeb" -Value 0 -PropertyType DWORD -Force | Out-Null
New-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" `
 -Name "ConnectedSearchUseWebOverMeteredConnections" -Value 0 -PropertyType DWORD -Force | Out-Null
New-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" `
 -Name "BingSearchEnabled" -Value 0 -PropertyType DWORD -Force | Out-Null

#disable notifications such as virus scan notifications
 # Create the policy key if it doesn't exist
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Notifications" -Force | Out-Null

 # Disable “informational” Virus & threat protection notifications
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Notifications" `
 -Name "DisableEnhancedNotifications" `
 -Value 1 `
 -PropertyType DWORD `
 -Force | Out-Null

#enable multi line pasting
$oj = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
perl -i -gne 's/((\s*)"?actions"?)/$2"multiLinePasteWarning": false ,$1/s and print' $oj

#disable stupid wifi/wan wakeups
Get-NetAdapter | ForEach-Object { Disable-NetAdapterPowerManagement -Name $_.Name -WakeOnMagicPacket -NoRestart }

#UNTESTED!

#disable system notifications
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\PushNotifications" -Name ToastEnabled -Value 0

#disable system sounds
Set-ItemProperty -Path "HKCU:\AppEvents\Schemes" -Name "Current" -Value ".None"

# Hide Search
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Value 0

# Turn off Widgets
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarDa" -Value 0

# Align Taskbar left
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAl" -Value 0

# Always show icons, never thumbnails in explorer
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "IconsOnly" -Value 1

# Disable thumbnail cache in explorer
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "DisableThumbnailCache" -Value 1

# Allow long paths in registry
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" `
 -Name "LongPathsEnabled" -Value 1 -PropertyType DWORD -Force

 # Then use the \\?\ prefix to bypass the normal path limit:
Get-WmiObject Win32_LogicalDisk -Filter "DriveType=3" | ForEach-Object {
    $drivePath = $_.DeviceID + "\"
    icacls "\\?\$drivePath*" /grant Everyone:(F) /T /C
}

#disable enhanced mouse precision
Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseSpeed" -Value 0
#enable single click to open items
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
 -Name "DoubleClickInWebView" -Value 0

#remove the fucking warm tint in photos.exe
 # Define the sRGB profile path
$sRGBProfile = "$env:SystemRoot\System32\spool\drivers\color\sRGB Color Space Profile.icm"
 # Get the active display device
$Monitor = (Get-WmiObject -Namespace root\wmi -Class WmiMonitorID).InstanceName
 # Check if the sRGB profile exists before applying
if (Test-Path $sRGBProfile) {
    Write-Host "sRGB Profile found. Proceeding with changes..." -ForegroundColor Green
    
    # Remove all existing ICC profiles for the display
    Write-Host "Removing current ICC profiles..."
    & colorcpl.exe /RemoveProfile "$Monitor"

    # Add the sRGB ICC profile
    Write-Host "Applying sRGB IEC61966-2.1 profile..."
    & colorcpl.exe /AddProfile "$Monitor" $sRGBProfile

    # Set sRGB as the default profile
    Write-Host "Setting sRGB as default profile..."
    & colorcpl.exe /SetDefault "$Monitor" $sRGBProfile

    # Force the system to apply the new color profile
    Write-Host "Forcing system to update display settings..."
    rundll32.exe shell32.dll,Control_RunDLL colorcpl.cpl
} else {
    Write-Host "sRGB ICC profile not found. Please ensure it exists at $sRGBProfile" -ForegroundColor Red
}

# Wipe and clean the quick access menu
 # Step 1: Unpin everything from Quick Access
$qaPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\QuickAccess"
Remove-ItemProperty -Path $qaPath -Name "PinnedPaths" -ErrorAction SilentlyContinue

 # Step 2: Clear recent files & frequent folders
Remove-Item "$env:APPDATA\Microsoft\Windows\Recent\*" -Force -ErrorAction SilentlyContinue
Remove-Item "$env:APPDATA\Microsoft\Windows\Recent\AutomaticDestinations\*" -Force -ErrorAction SilentlyContinue
Remove-Item "$env:APPDATA\Microsoft\Windows\Recent\CustomDestinations\*" -Force -ErrorAction SilentlyContinue

 # Step 3: Disable Auto-Population of Quick Access (Registry Tweaks)
$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer"
Set-ItemProperty -Path $regPath -Name "ShowFrequent" -Value 0
Set-ItemProperty -Path $regPath -Name "ShowRecent" -Value 0

 # Step 4: Unpin all default system folders (Downloads, Documents, Pictures, etc.)
$systemFolders = @(
    'Desktop', 'Downloads', 'Documents', 'Pictures', 'Videos', 'Music', '3D Objects'
)
foreach ($folder in $systemFolders) {
    $path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace"
    $guid = (Get-ItemProperty -Path $path -ErrorAction SilentlyContinue).PSObject.Properties.Name -match $folder
    if ($guid) {
        Remove-Item -Path "$path\$guid" -Force -ErrorAction SilentlyContinue
    }
}

 # Step 5: Restart Explorer to apply changes
Stop-Process -Name explorer -Force
Start-Process explorer.exe

# Disable Lock Screen

$regPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization'
# Ensure key exists
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Set DWORD value
New-ItemProperty -Path $regPath -Name 'NoLockScreen' -Value 1 -PropertyType DWord -Force | Out-Null

powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_NONE CONSOLELOCK 0
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_NONE CONSOLELOCK 0




