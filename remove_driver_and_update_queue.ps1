if (-not $args[0]) {
	"use:
.\remove_update.ps1 <provider name> 
 where provider name is acquired from 'pnputil /enum-drivers'";
 exit 
 }

$provider_name = $args[0]

$drivers = (pnputil /enum-drivers |
Select-String "Published Name:" -Context 0,6 |
ForEach-Object {
    if ($_ -match $provider_name -and $_ -match 'oem\d+\.inf') {
        $matches[0]
    }
})
$drivers | foreach {pnputil /delete-driver $_ /uninstall /force}