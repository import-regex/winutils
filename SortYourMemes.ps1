#usage: paste into your downloads folder and start up powershell in the same folder. enter this: powershell SortYourMemes.ps1
#all images and .mp4 videos will move into folders sorting them by year. any other file will move to a "misc" folder

$images = @('webp','.jpg', '.jpeg', '.png', '.gif', '.bmp', '.tiff','.mp4')

foreach ($_ in get-childitem $PWD -file)
{
 if ([string]$_ -eq $PSCommandPath) {continue} #skipping myself
 write-host -object "working on: $_"
 $destination = if ($images -contains $_.Extension.ToLower()) {$_.LastWriteTime.Year } else {"misc"}
 if (-not (Test-Path $destination)) {
  New-Item -Path $destination -ItemType Directory
 }
 Move-Item -LiteralPath $_.FullName -Destination $destination
}

