function PlayGame
{
    param([string]$StartingPosition, [int]$Moves)

    $game = $StartingPosition

    for ($move = 0; $move -lt $Moves; $move++)
    {
        $cupAt = $move % $game.Length
        $selectedCups = "$game$game".Substring($cupAt + 1, 3)
        $selectedValue = [int]::Parse($game[$cupAt])
        $placeAfterCup = $selectedValue - 1
        if ($placeAfterCup -eq 0)
        {
            $placeAfterCup = $game.Length
        }

        while ($selectedCups.Contains($placeAfterCup) -or $placeAfterCup -eq 0)
        {
            $placeAfterCup = ($placeAfterCup + $game.Length - 1) % $game.Length
            if ($placeAfterCup -eq 0)
            {
                $placeAfterCup = $game.Length
            }
        }

        $selectedCups.ToCharArray() | ForEach-Object { $game = $game.Replace($_.ToString(), "") }
        $placeAfterCupIndex = $game.IndexOf($placeAfterCup.ToString())

        $game = $game.Insert($placeAfterCupIndex + 1, $selectedCups)

        $currentPosition = $game.IndexOf($selectedValue.ToString())
        if ($currentPosition -lt $cupAt)
        {
            $game = "$game$game".Substring($game.Length - ($cupAt - $currentPosition), $game.Length)
        }
        elseif ($currentPosition -gt $cupAt)
        {
            $game = "$game$game".Substring($currentPosition - $cupAt, $game.Length)
        }
    }

    return "$game$game".Substring($game.IndexOf("1") + 1, $game.Length - 1)
}

$result = PlayGame -StartingPosition "364289715" -Moves 100
Write-Host "Answer Part 1: $result"