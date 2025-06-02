$time = (Get-Date).AddHours($args[0])

$task_name="Wake_" + (get-date -Date $time -Format "HH_mm_MM_dd_yyyy")
echo "creating a sleep timer: $task_name"

$action = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument '/c exit'
$trigger = New-ScheduledTaskTrigger -Once -At $time
$settings = New-ScheduledTaskSettingsSet -WakeToRun -AllowStartIfOnBatteries -StartWhenAvailable
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -RunLevel Highest

Register-ScheduledTask -TaskName $task_name -Action $action -Trigger $trigger -Settings $settings -Principal $principal -Force
powercfg /h off

echo "Checking for wake timers:"

powercfg /waketimers

echo "sleep the system manually if everything is OK..."
#Start-Sleep -Seconds 5
#rundll32.exe powrprof.dll,SetSuspendState Sleep
