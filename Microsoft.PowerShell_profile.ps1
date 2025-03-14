#run these once
#Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
#winget install --id Git.Git
#git config --global http.sslBackend schannel
#git config --global core.sshCommand "C:/Windows/System32/OpenSSH/ssh.exe"
# writes to C:\Users\$env:USERNAME\.gitconfig

$env:PAGER = "cat" #removing the --More-- pager in powershell
set-alias help 'Get-Help'

#enabling all the important linux utils (native windows executables)
$gitbin="C:\Program Files\Git"
$gitbina = "$gitbin\usr\bin" 
set-alias vim   "$gitbina\vim.exe"
set-alias find  "$gitbina\find.exe"
set-alias awk   "$gitbina\awk.exe"
set-alias grep  "$gitbina\grep.exe"
set-alias sed  "$gitbina\sed.exe"
set-alias perl  "$gitbina\perl.exe"
set-alias which  "$gitbina\which.exe"
set-alias uniq  "$gitbina\uniq.exe"

$gitbinb = "$gitbin\mingw64\bin"
set-alias tclsh "$gitbinb\tclsh.exe"
set-alias wish  "$gitbinb\wish.exe"

#enabling android dev tools
set-alias kotlinc 'C:\Program Files\Android\Android Studio\plugins\Kotlin\kotlinc\bin\kotlinc.bat'
set-alias d8 'D:\Programs\Android_Studio_SDK\build-tools\35.0.1\d8.bat'
set-alias adb 'D:\Programs\Android_Studio_SDK\platform-tools\adb.exe'

#other misc tools
function tcc { param([string]$file); & 'D:\Programs\tcc-0.9.27-win64-bin\tcc\tcc.exe' -run $file }
#function tclsh { param([string]$file); python -c ("from tkinter import Tcl; Tcl().evalfile('"+($file-replace"\\","\\")+"')")}

#sort your media files quickly
#moves all media files from the current folder to .\misc\$year_of_date_modified
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

#same as sort-media, but for documents. moves to .\documents\$year
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
#convert any video file to mp4. requires ffmpeg (winget install ffmpeg)
function conv-mp4 {
    $args = $MyInvocation.UnboundArguments[0]
    $output = ($args -replace '\w+$', "mp4")
	ffmpeg -i $args $output
}

#force delete file
function sudormf {
    param([string]$file)
    takeown /f $file /r /d y | Out-Null
    icacls $file /grant administrators:F /t | Out-Null
    Remove-Item -Path $file -Recurse -Force
}

#run the last modified file from current directory. useful for script prototyping in VI editors
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
