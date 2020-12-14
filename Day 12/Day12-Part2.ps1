$ErrorActionPreference = "Stop"

function ParseInstruction
{
    param([string]$Line)

    return @{ Instruction = $Line[0].ToString(); Movement = [int]::Parse($Line.Substring(1)) }
}

$instructions = Get-Content -Path "$PSScriptRoot\input.txt" | Where-Object { $_ } | ForEach-Object { ParseInstruction -Line $_ }

$currentWaypoint = @(1, 10, 0, 0)
$indexer = @{ N = 0; E = 1; S = 2; W = 3 }
$movement = @(0, 0, 0, 0)
$rotateMultiplier = @{ L = -1; R = 1 }

foreach ($instruction in $instructions)
{
    if ($rotateMultiplier.Keys -contains $instruction.Instruction)
    {
        $rotation = $rotateMultiplier[$instruction.Instruction] * $instruction.Movement
        if ($rotation -lt 0)
        {
            $rotation += 360
        }
        elseif ($rotation -gt 270)
        {
             $rotation -= 360
        }
        $rotation = $rotation / 90

        $moveWaypoint = @()
        $moveWaypoint += $currentWaypoint
        $moveWaypoint += $currentWaypoint
        $currentWaypoint = $moveWaypoint[$(4-$rotation)..$(7-$rotation)]
    }
    elseif ($indexer.Keys -contains $instruction.Instruction)
    {
        $currentWaypoint[$indexer[$instruction.Instruction]] += $instruction.Movement
    }
    else
    {
        $movement[0] += $currentWaypoint[0] * $instruction.Movement
        $movement[1] += $currentWaypoint[1] * $instruction.Movement
        $movement[2] += $currentWaypoint[2] * $instruction.Movement
        $movement[3] += $currentWaypoint[3] * $instruction.Movement
    }
}

Write-Host "Asnwer Part 2: $([Math]::Abs($movement[0] - $movement[2]) + [Math]::Abs($movement[1] - $movement[3]))"