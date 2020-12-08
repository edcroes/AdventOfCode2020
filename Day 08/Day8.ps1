function ParseInstruction
{
    param($Line)

    $op,$val = $Line.Split(" ")

    return @{
        Op = $op
        Val = [int]::Parse($val)
    }
}

function RunProgram
{
    param($Instructions)

    $accumulator = 0
    $currentInstruction = 0
    $loopDetected = $false

    $alreadyRunInstructions = @()

    while ($true)
    {
        if ($alreadyRunInstructions -contains $currentInstruction)
        {
            $loopDetected = $true
            break;
        }

        $alreadyRunInstructions += $currentInstruction
        $instruction = $Instructions[$currentInstruction]

        switch ($instruction.Op)
        {
            "acc" { $accumulator += $instruction.Val; $currentInstruction++ }
            "jmp" { $currentInstruction += $instruction.Val }
            "nop" { $currentInstruction++ }
        }

        if ($currentInstruction -ge $Instructions.Length)
        {
            break
        }
    }

    return @{
        LoopDetected = $loopDetected
        Accumulator = $accumulator
    }
}

$instructions = Get-Content -Path "$PSScriptRoot\input.txt" | Where-Object { $_ } | ForEach-Object { ParseInstruction $_ }

# Part 1
$result = RunProgram -Instructions $instructions
write-Host "Answer Part 1: $($result.Accumulator)"

# Part 2
$result = $null
for ($i = 0; $i -lt $instructions.Length; $i++)
{
    $changedInstructions = @()
    $changedInstructions += $instructions

    $instruction = $instructions[$i]
    if ($instruction.Op -eq "jmp")
    {
        $changedInstructions[$i] = @{ Op = "nop"; Val = $op.Val }
    }
    elseif ($instruction.Op -eq "nop")
    {
        $changedInstructions[$i] = @{ Op = "jmp"; Val = $op.Val }
    }
    else
    {
        continue
    }

    $result = RunProgram -Instructions $changedInstructions
    if (-not $result.LoopDetected)
    {
        break
    }
}

Write-Host "Answer Part 2: $($result.Accumulator) (Loop detected: $($result.LoopDetected))"