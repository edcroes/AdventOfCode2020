$ErrorActionPreference = "Stop"
$start = Get-Date

Import-Module -Name "$PSScriptRoot\..\Modules\Map.psm1" -Force
$map = ConvertTo-CharMatrix -Lines (Get-Content -Path "$PSScriptRoot\input.txt" | Where-Object { $_ })

$FLOOR = "."
$EMPTY_SEAT = "L"
$OCCUPIED_SEAT = "#"

function CopyMap
{
    param($Map)

    $lines = @()
    foreach ($row in $Map)
    {
        $lines += $row -join ""
    }

    return ConvertTo-CharMatrix -Lines $lines
}

function DistributeChaos
{
    param($Map)

    $newMap = CopyMap -Map $Map
    $changed = $false
    for ($row = 0; $row -lt $Map.Length; $row++)
    {
        for ($col = 0; $col -lt $Map[0].Length; $col++)
        {
            $place = $Map[$row][$col]
            if ($place -eq $FLOOR)
            {
                continue
            }

            $seatsToCheck = @()

            if ($row -ne 0)
            {
                if ($col -ne 0)
                {
                    $seatsToCheck += $Map[$row-1][$col-1]
                }
                if ($col -ne $Map[0].Length - 1)
                {
                    $seatsToCheck += $Map[$row-1][$col+1]
                }
                $seatsToCheck += $Map[$row-1][$col]
            }

            if ($row -ne $Map.Length - 1)
            {
                if ($col -ne 0)
                {
                    $seatsToCheck += $Map[$row+1][$col-1]
                }
                if ($col -ne $Map[0].Length - 1)
                {
                    $seatsToCheck += $Map[$row+1][$col+1]
                }
                $seatsToCheck += $Map[$row+1][$col]
            }

            if ($col -ne 0)
            {
                $seatsToCheck += $Map[$row][$col-1]
            }
            if ($col -ne $Map[0].Length - 1)
            {
                $seatsToCheck += $Map[$row][$col+1]
            }

            $occupiedSeats = $seatsToCheck | Where-Object { $_ -eq $OCCUPIED_SEAT }
            if ($place -eq $EMPTY_SEAT -and -not $occupiedSeats)
            {
                $changed = $true
                $newMap[$row][$col] = $OCCUPIED_SEAT
            }
            elseif ($place -eq $OCCUPIED_SEAT -and $occupiedSeats.Count -ge 4)
            {
                $changed = $true
                $newMap[$row][$col] = $EMPTY_SEAT
            }
        }
    }

    if (-not $changed)
    {
        return $null
    }

    return $newMap
}

function DumpMap
{
    param($Map)

    for ($row = 0; $row -lt $Map.Length; $row++)
    {
        Write-Host $Map[$row]
    }
    Write-Host ""
}

$changed = $true
$changedMap = CopyMap -Map $Map

while ($changed)
{
    $newMap = DistributeChaos -Map $changedMap
    if (-not $newMap)
    {
        break
    }

    $changedMap = $newMap
}

$totalOccupied = 0
for ($row = 0; $row -lt $changedMap.Length; $row++)
{
    $noOfSeatsOccupiedInRow = ($changedMap[$row] | Where-Object { $_ -eq $OCCUPIED_SEAT }).Count
    $totalOccupied += $noOfSeatsOccupiedInRow
}

Write-Host "Answer Part 1: $totalOccupied"
Write-Host "Duration: $((Get-Date) - $start)"