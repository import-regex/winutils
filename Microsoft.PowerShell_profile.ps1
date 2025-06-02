#set-alias psql 'D:\Programs\PostgreSQL 17.0 beta3\bin\psql.exe'
#set-alias konanc 'D:\Programs\kotlin-native-prebuilt-windows-x86_64-2.1.0-RC2\bin\konanc.bat'

#run these once
#Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
#git config --global http.sslBackend schannel
#git config --global core.sshCommand "C:/Windows/System32/OpenSSH/ssh.exe"
# writes to C:\Users\zen\.gitconfig

#removing the --More-- pager garbage on powershell
$env:PAGER = "cat"
set-alias help 'Get-Help'
set-alias python311 'C:\Users\zen\AppData\Local\Programs\Python\Python311\python.exe'

$gitbin="C:\Program Files\Git"
$gitbina = "$gitbin\usr\bin" 
set-alias vim   "$gitbina\vim.exe"
set-alias find  "$gitbina\find.exe"
set-alias awk   "$gitbina\awk.exe"
set-alias grep  "$gitbina\grep.exe"
set-alias sed  "$gitbina\sed.exe"
set-alias tr  "$gitbina\tr.exe"
set-alias bash  "$gitbina\bash.exe"
set-alias which  "$gitbina\which.exe"
set-alias linux-sort  "$gitbina\sort.exe"
set-alias uniq  "$gitbina\uniq.exe"
set-alias [  "$gitbina\[.exe"

$gitbinb = "$gitbin\mingw64\bin"
set-alias tclsh "$gitbinb\tclsh.exe"
set-alias wish  "$gitbinb\wish.exe"

set-alias kotlinc 'C:\Program Files\Android\Android Studio\plugins\Kotlin\kotlinc\bin\kotlinc.bat'
set-alias d8 'D:\Programs\Android_Studio_SDK\build-tools\35.0.1\d8.bat'
set-alias adb 'D:\Programs\Android_Studio_SDK\platform-tools\adb.exe'

function sort-media {
 $images = @('.jpg', '.jpeg', '.png', '.gif', '.bmp', '.tiff','.webp','.mp4','.mp3','.wav','.3gp','.mov','.HEIC','.avi','.webm')
 $files = Get-ChildItem -File
 foreach ($file in $files){
  $year = $file.LastWriteTime.Year
  $destination = if ($images -contains $file.Extension.ToLower()){"media\\${year}"} else {"misc"}
  if (-not (Test-Path $destination)){
   New-Item -Path $destination -ItemType Directory
  }
 Move-Item -Path $file.FullName -Destination $destination
 }
}

function sort-documents {
 $images = @('.pdf' , '.txt' , '.doc' , '.docx', '.rtf' , '.ppt' , '.pptx' , '.xlsx', '.xlx' , '.odt')
 $files = Get-ChildItem -File
 foreach ($file in $files){
  $year = $file.LastWriteTime.Year
  $destination = if ($images -contains $file.Extension.ToLower()){"docs\\$year"} else {"misc"}
  if (-not (Test-Path $destination)){
   New-Item -Path $destination -ItemType Directory
  }
 Move-Item -Path $file.FullName -Destination $destination
 }
}

function conv-mp4 {
    $args = $MyInvocation.UnboundArguments[0]
    $output = ($args -replace '\w+$', "mp4")
	ffmpeg -i $args $output
}

function down-mp3 {
 $args = $MyInvocation.UnboundArguments[0]
 yt-dlp -x --audio-format mp3 $args
}

function cp-picdrop {
 adb shell ls /sdcard/picdrop/* | foreach {if ($_ -ne "/sdcard/picdrop/Placeholder.jpg") {adb pull $_}}
 if ($LASTEXITCODE) {
  $tcpip="192.168.1.50:5555"
  echo "Probably no connected devices? Assuming $tcpip on the local network and connecting for the pull..."
  adb connect $tcpip
  adb shell ls /sdcard/picdrop/* | foreach {if ($_ -ne "/sdcard/picdrop/Placeholder.jpg") {adb pull $_}}
 }
 
}

function wipe-picdrop {
	 adb shell ls /sdcard/picdrop/* | foreach {if ($_ -ne "/sdcard/picdrop/Placeholder.jpg") {adb shell "rm $_"}}
}

function push-picdrop {
	 ls | foreach {adb push $_ /sdcard/picdrop/}
}

function sudormf {
    param([string]$file)
    takeown /f $file /r /d y | Out-Null
    icacls $file /grant administrators:F /t | Out-Null
    Remove-Item -Path $file -Recurse -Force
}

function tcc { param([string]$file); & 'D:\Programs\tcc-0.9.27-win64-bin\tcc\tcc.exe' -run $file }

function run-last-file {
 $executionPaths = @{
  ".bat"  = "cmd"
  ".py"   = "python"
  ".pl"   = "perl"
  ".js"   = "node"
  ".c"    = "tcc -run"
  ".tcl"  = "tclsh"
  ".java" = "java"
  ".ps1"  = ""
  }
 $lastModifiedFile = Get-ChildItem -Path .\* -File | Where-Object { $executionPaths.Keys -contains $_.Extension } | Sort-Object LastWriteTime -Descending | Select-Object -First 1
 if (-not $lastModifiedFile) {
  Write-Host "No valid files found to execute."
  exit(1)
  }
 $interpreter = $executionPaths[$lastModifiedFile.Extension]
 if ($interpreter) {
  & $interpreter $lastModifiedFile
  } else {
  & $lastModifiedFile
  }
}

######### unused:
function sdkmanager {
    $args = $MyInvocation.Line -replace '^\w+', ''
    echo "these are your args:" $args
    $env:ANDROID_SDK_ROOT = "D:\Programs"
	# requires env:java_home and java bin in PATH
    Start-Process -FilePath "D:\Programs\cmdline-tools\bin\sdkmanager.bat" -ArgumentList "$args --sdk_root=$env:ANDROID_SDK_ROOT" -NoNewWindow -Wait
}

function konanc {
    $args = $MyInvocation.Line -replace '^\w+', ''
    echo "these are your args:" $args
	echo "Do not attempt. konanc is useless in the command line"
   # $env:ANDROID_NDK_HOME = "D:\Programs\android-ndk-r21e"
   # $env:KONAN_DATA_DIR = "D:\Programs\kotlin-native-prebuilt-windows-x86_64-2.1.0-RC2\data"
   # $env:PATH = $env:ANDROID_NDK_HOME + "\toolchains\llvm\prebuilt\windows-x86_64\bin;" + "D:\Programs\jdk-21.0.5+11\bin;" + $env:PATH
   # Start-Process -FilePath "D:\Programs\kotlin-native-prebuilt-windows-x86_64-2.1.0-RC2\bin\konanc.bat" -ArgumentList $args -NoNewWindow -Wait
}



#set-alias nvim 'D:\Programs\nvim-win64\bin\nvim.exe -u D:\Programs\nvim-win64\bin\init.vim'
#function tclsh { param([string]$file); python -c ("from tkinter import Tcl; Tcl().evalfile('"+($file-replace"\\","\\")+"')")}
