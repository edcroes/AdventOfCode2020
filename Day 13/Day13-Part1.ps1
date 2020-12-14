$ErrorActionPreference = "Stop"

$lines = Get-Content -Path "$PSScriptRoot\input.txt" | Where-Object { $_ }
$arrivalTime = [int]::Parse($lines[0])
$busTimes = $lines[1].Split(",") | Where-Object { $_ -match "\d+" } | ForEach-Object { [int]::Parse($_) }

$earliestBus = 0
$earliestArrivalTime = [int]::MaxValue
foreach ($bus in $busTimes)
{
    $times = [int]($arrivalTime / $bus + 0.5)
    $busArrival = $times * $bus

    if ($busArrival -lt $earliestArrivalTime)
    {
        $earliestArrivalTime = $busArrival
        $earliestBus = $bus
    }
}

$earliestBus * ($earliestArrivalTime - $arrivalTime)