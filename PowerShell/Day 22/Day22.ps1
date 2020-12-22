$ErrorActionPreference = "Stop"
[int[]]$player1Deck,[int[]]$player2Deck = (Get-Content -Path "$PSScriptRoot\input.txt" -Raw).Replace("`r", "").Split(@("`n`n"), [System.StringSplitOptions]::RemoveEmptyEntries) | ForEach-Object {
    $deck = $_.Split("`n", [System.StringSplitOptions]::RemoveEmptyEntries)
    return ,($deck[1..$($deck.Length - 1)] | Foreach-Object { [int]::Parse($_) })
}

function PlayCombat
{
    param([int[]]$Player1Deck, [int[]]$Player2Deck)

    while ($Player1Deck.Length -gt 0 -and $Player2Deck -gt 0)
    {
        if ($Player1Deck[0] -gt $Player2Deck[0])
        {
            $Player1Deck += $Player1Deck[0]
            $Player1Deck += $Player2Deck[0]
        }
        else
        {
            $Player2Deck += $Player2Deck[0]
            $Player2Deck += $Player1Deck[0]
        }

        $Player1Deck = if ($Player1Deck.Length -eq 1) { @() } else { $Player1Deck[1..$($Player1Deck.Length - 1)] }
        $Player2Deck = if ($Player2Deck.Length -eq 1) { @() } else { $Player2Deck[1..$($Player2Deck.Length - 1)] }
    }

    $winningDeck = if (-not $Player1Deck) { $Player2Deck } else { $Player1Deck }

    $totalScore = 0
    for ($i = 0; $i -lt $winningDeck.Length; $i++)
    {
        $cardScore = $winningDeck.Length - $i
        $totalScore += $cardScore * $winningDeck[$i]
    }

    return $totalScore
}

$combatScore = PlayCombat -Player1Deck @($player1Deck) -Player2Deck @($player2Deck)
Write-Host "Answer Part 1: $combatScore"

# Part 2
function PlayRecursiveCombat
{
    param([int[]]$Player1Deck, [int[]]$Player2Deck)

    $gameState = @{
        Player1PlayedDecks = [string[]]@()
        Player2PlayedDecks = [string[]]@()
    }

    while ($Player1Deck.Length -gt 0 -and $Player2Deck -gt 0)
    {
        $player1PlayedDeckId = $Player1Deck -join "-"
        $player2PlayedDeckId = $Player2Deck -join "-"
        if ($gameState.Player1PlayedDecks -contains $player1PlayedDeckId -or $gameState.Player2PlayedDecks -contains $player2PlayedDeckId)
        {
            break;
        }
        $gameState.Player1PlayedDecks += $player1PlayedDeckId
        $gameState.Player2PlayedDecks += $player2PlayedDeckId

        $roundWinner = 0
        if ($Player1Deck[0] -le ($Player1Deck.Length - 1) -and $Player2Deck[0] -le ($Player2Deck.Length - 1))
        {
            $player1SubGameDeck = $Player1Deck[1..$($Player1Deck[0])]
            $player2SubGameDeck = $Player2Deck[1..$($Player2Deck[0])]

            $winnerSubGame = PlayRecursiveCombat -Player1Deck $player1SubGameDeck -Player2Deck $player2SubGameDeck
            $roundWinner = $winnerSubGame.Winner
        }
        else
        {
            $roundWinner = if ($Player1Deck[0] -gt $Player2Deck[0]) { 1 } else { 2 }
        }

        if ($roundWinner -eq 1)
        {
            $Player1Deck += $Player1Deck[0]
            $Player1Deck += $Player2Deck[0]
        }
        else
        {
            $Player2Deck += $Player2Deck[0]
            $Player2Deck += $Player1Deck[0]
        }

        $Player1Deck = if ($Player1Deck.Length -eq 1) { @() } else { $Player1Deck[1..$($Player1Deck.Length - 1)] }
        $Player2Deck = if ($Player2Deck.Length -eq 1) { @() } else { $Player2Deck[1..$($Player2Deck.Length - 1)] }
    }

    if ($Player1Deck)
    {
        $winner = 1
        $winningDeck = $Player1Deck
    }
    else
    {
        $winner = 2
        $winningDeck = $Player2Deck
    }

    $totalScore = 0
    for ($i = 0; $i -lt $winningDeck.Length; $i++)
    {
        $cardScore = $winningDeck.Length - $i
        $totalScore += $cardScore * $winningDeck[$i]
    }

    return @{
        Winner = $winner
        Score = $totalScore
    }
}

$recursiveCombatWinner = PlayRecursiveCombat -Player1Deck @($player1Deck) -Player2Deck @($player2Deck)
Write-Host "Answer Part 2: $($recursiveCombatWinner.Score)"