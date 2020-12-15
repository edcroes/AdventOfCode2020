$ErrorActionPreference = "Stop"

$script:NumbersCalled = @{}
$script:PreviousNumber = 0
$script:Turn = 1

function PlayGame
{
    param([int] $UntilTurn)

    for (; $script:Turn -le $UntilTurn; $script:Turn++)
    {
        $spokenWhen = $script:NumbersCalled[$script:PreviousNumber]
        $newNumber = $spokenWhen[1] - $spokenWhen[0]

        if ($script:NumbersCalled.ContainsKey($newNumber))
        {
            $script:NumbersCalled[$newNumber][0] = $script:NumbersCalled[$newNumber][1]
            $script:NumbersCalled[$newNumber][1] = $script:Turn
        }
        else
        {
            $script:NumbersCalled.Add($newNumber, @($script:Turn, $script:Turn))
        }

        $script:PreviousNumber = $newNumber
    }
}

$startingSequence = @(2, 1, 10, 11, 0, 6)
for (;$script:Turn -le $startingSequence.Length; $script:Turn++)
{
    $script:PreviousNumber = $startingSequence[$script:Turn-1]
    $script:NumbersCalled.Add($script:PreviousNumber, @($script:Turn, $script:Turn))
}

PlayGame -UntilTurn 2020
Write-Host "Answer Part 1: $script:PreviousNumber"

PlayGame -UntilTurn 30000000
Write-Host "Answer Part 2: $script:PreviousNumber"