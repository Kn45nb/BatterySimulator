# Script for retrieving Dell battery parameters that are not exposed through the standard APIs
# Unofficial doc: https://docs.kernel.org/wmi/devices/dell-wmi-ddv.html
# A C++ implementation can be found in BatteryQuery\DellBattery.hpp 

# NOTICE: Script MUST run as Administrator.

Write-Host "Dell battery parameters:"
$dell = Get-CimInstance -Namespace root\WMI -Class DDVWmiMethodFunction
$inst = 1 # battery instance number

$cycleCount = Invoke-CimMethod -InputObject $dell -MethodName BatteryCycleCount -Arguments @{arg2=$inst}
$cycleCount = $cycleCount.argr
Write-Host BatteryCycleCount: $cycleCount

$date = Invoke-CimMethod -InputObject $dell -MethodName BatteryManufactureDate  -Arguments @{arg2=$inst}
$date = $date.argr # encoding: (year – 1980)*512 + month*32 + day
$day = $date % 32
$month = ($date -shr 5) % 16
$year = 1980 + ($date -shr 9)
Write-Host BatteryManufactureDate: Day=$day, Month=$month, Year=$year

$temp = Invoke-CimMethod -InputObject $dell -MethodName BatteryTemperature -Arguments @{arg2=$inst}
$temp = $temp.argr # in 10ths of a degree Kelvin
$temp = ($temp - 2731)/10; # convert to Celsius
Write-Host BatteryTemperature: $temp Celsius
