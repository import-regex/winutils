#winget install StrawberryPerl.StrawberryPerl #redundant; git comes with 4 months older version
winget install OpenJS.NodeJS
winget install --id=Brave.Brave --silent
winget install --id Git.Git -e --source winget
winget install --id Microsoft.PowerShell --source winget
winget install Neovim.Neovim
winget install Microsoft.OpenJDK.21
winget install Google.AndroidStudio
winget install GIMP.GIMP
winget install --id=Ultimaker.Cura -e
winget install --id OBSProject.OBSStudio
winget install --id Microsoft.OpenSSH.Server
winget install --id "BlenderFoundation.Blender"
winget install --id "Google.ChromeRemoteDesktopHost"
choco install notepadplusplus --confirm
choco install scrcpy -y
choco install ffmpeg --confirm
choco install jpegoptim -y
choco install directx -y

winget install --id Valve.Steam -e --accept-package-agreements --accept-source-agreements
# to check vcredist versions installed: 
#Get-WmiObject -Query "SELECT * FROM Win32_Product WHERE (Name LIKE 'Microsoft Visual C++%')" | Select-Object Name, Version
# Install Visual C++ Redistributables with Chocolatey
choco install vcredist2005 -y
choco install vcredist2008 -y
choco install vcredist2010 -y
choco install vcredist2012 -y
choco install vcredist2013 -y
choco install vcredist2015 -y
choco install vcredist2017 -y
choco install vcredist2019 -y
choco install vcredist2022 -y

#pip install selenium undetected-chromedriver
#pip install setuptools
#pip install yt-dlp
#stl-boi starts here
#pip install trimesh shapely matplotlib
#pip install vedo
#pip install pyglet
#pip install "pyglet<2"
#pip install networkx
#pip install scipy
#pip install -U pip setuptools wheel
#pip install cmake ninja
#pip install pyopencl
#cd taichi; python -m pip install -r requirements_dev.txt
#python setup.py install
#pip install websockets opencv-python ffmpeg-python
#pip install websockets flask

#https://github.com/obsproject/obs-websocket/releases/download/4.9.1-compat/obs-websocket-4.9.1-compat-Qt6-Windows-Installer.exe




