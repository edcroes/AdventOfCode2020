$ErrorActionPreference = "Stop"
$start = Get-Date

Import-Module -Name "$PSScriptRoot\..\Modules\Map.psm1" -Force
$map1 = ConvertTo-CharMatrix -Lines (Get-Content -Path "$PSScriptRoot\input.txt" | Where-Object { $_ })
$map2 = ConvertTo-CharMatrix -Lines (Get-Content -Path "$PSScriptRoot\input.txt" | Where-Object { $_ })

$FLOOR = "."
$EMPTY_SEAT = "L"
$OCCUPIED_SEAT = "#"

function IsSeatOccupiedInDirection
{
    param([char[][]]$Map, [int]$Row, [int]$Col, [int]$MoveX, [int]$MoveY, [switch] $RecursiveSeatCheck)

    [int]$maxX = $Map[0].Length
    [int]$maxY = $Map.Length

    [int]$newX = $Col + $MoveX
    [int]$newY = $Row + $MoveY
    while ($newY -ge 0 -and $newY -lt $maxY -and $newX -ge 0 -and $newX -lt $maxX)
    {
        if ($Map[$newY][$newX] -ne $FLOOR)
        {
            return $Map[$newY][$newX] -eq $OCCUPIED_SEAT
        }
        elseif (-not $RecursiveSeatCheck)
        {
            return $false
        }

        $newX += $MoveX
        $newY += $MoveY
    }

    return $false
}

$PointsToCheck = @(
    @{ X = -1; Y = -1 },
    @{ X =  0; Y = -1 },
    @{ X =  1; Y = -1 },
    @{ X = -1; Y =  0 },
    @{ X =  1; Y =  0 },
    @{ X = -1; Y =  1 },
    @{ X =  0; Y =  1 },
    @{ X =  1; Y =  1 }
)

function DistributeChaos
{
    param($Map, $LeaveCount, [switch] $RecursiveSeatCheck)

    $pointsToUpdate = @()
    for ($row = 0; $row -lt $Map.Length; $row++)
    {
        for ($col = 0; $col -lt $Map[0].Length; $col++)
        {
            $place = $Map[$row][$col]
            if ($place -eq $FLOOR)
            {
                continue
            }

            $occupiedSeats = 0
            foreach ($point in $pointsToCheck)
            {
                $occupiedSeats += [int](IsSeatOccupiedInDirection -Map $Map -Row $row -Col $col -MoveX $point.X -MoveY $point.Y -RecursiveSeatCheck:$RecursiveSeatCheck)
                if ($occupiedSeats -ge $LeaveCount -or ($place -eq $EMPTY_SEAT -and $occupiedSeats -gt 0))
                {
                    break
                }
            }

            if ($place -eq $EMPTY_SEAT -and -not $occupiedSeats)
            {
                $pointsToUpdate += @{ Row = $row; Col = $col; Status = $OCCUPIED_SEAT }
            }
            elseif ($place -eq $OCCUPIED_SEAT -and $occupiedSeats -ge $LeaveCount)
            {
                $pointsToUpdate += @{ Row = $row; Col = $col; Status = $EMPTY_SEAT }
            }
        }
    }

    foreach ($point in $pointsToUpdate)
    {
        $Map[$point.Row][$point.Col] = $point.Status
    }

    return $pointsToUpdate.Count -gt 0
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

function GetAnswer
{
    param($Map, $LeaveCount, [switch] $RecursiveSeatCheck)

    $changed = $true
    while ($changed)
    {
        $changed = DistributeChaos -Map $Map -LeaveCount $LeaveCount -RecursiveSeatCheck:$RecursiveSeatCheck
    }

    $totalOccupied = 0
    for ($row = 0; $row -lt $Map.Length; $row++)
    {
        $noOfSeatsOccupiedInRow = ($Map[$row] | Where-Object { $_ -eq $OCCUPIED_SEAT }).Count
        $totalOccupied += $noOfSeatsOccupiedInRow
    }

    return $totalOccupied
}

#Write-Host "Answer Part 1: $(GetAnswer -Map $map1 -LeaveCount 4)"
#Write-Host "Duration: $((Get-Date) - $start)"
Write-Host "Answer Part 2: $(GetAnswer -Map $map2 -LeaveCount 5 -RecursiveSeatCheck)"
Write-Host "Duration: $((Get-Date) - $start)"