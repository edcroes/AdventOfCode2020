$ErrorActionPreference = "Stop"

function ParseInstruction
{
    param([string]$Line)

    return @{ Instruction = $Line[0].ToString(); Movement = [int]::Parse($Line.Substring(1)) }
}

$instructions = Get-Content -Path "$PSScriptRoot\input.txt" | Where-Object { $_ } | ForEach-Object { ParseInstruction -Line $_ }

$currentDirection = 90
$rotations = @{
    "0" = "N"
    "90" = "E"
    "180" = "S"
    "270" = "W"
}
$movement = @{
    N = 0
    E = 0
    S = 0
    W = 0
}

$rotateInstructions = @{ L = -1; R = 1 }

foreach ($instruction in $instructions)
{
    if ($rotateInstructions.Keys -contains $instruction.Instruction)
    {
        $rotation = $rotateInstructions[$instruction.Instruction] * $instruction.Movement
        $currentDirection += $rotation

        if ($currentDirection -lt 0)
        {
            $currentDirection += 360
        }
        elseif ($currentDirection -gt 270)
        {
             $currentDirection -= 360
        }
    }
    else
    {
        $direction = $rotations[$currentDirection.ToString()]
        if ($movement.Keys -contains $instruction.Instruction)
        {
            $direction = $instruction.Instruction
        }
        $movement[$direction] += $instruction.Movement
    }
}

Write-Host "Asnwer Part 1: $([Math]::Abs($movement["N"] - $movement["S"]) + [Math]::Abs($movement["E"] - $movement["W"]))"