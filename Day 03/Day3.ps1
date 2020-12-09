function GetTreeCount
{
    param($Map, $MoveX, $MoveY)

    $positionX = 0
    $positionY = 0
    $treesFound = 0

    while ($positionY + $moveY -lt $Map.Length)
    {
        $positionX += $moveX
        $positionY += $moveY

        $positionXInMinimap = $positionX % $Map[0].Length

        if ($map[$positionY][$positionXInMinimap])
        {
            $treesFound++
        }
    }

    return $treesFound
}

Import-Module -Name "$PSScriptRoot\..\Modules\Map.psm1" -Force
$lines = Get-Content -Path "$PSScriptRoot\input.txt"
$map = ConvertTo-BoolMatrix -Lines $lines -TrueValue "#"
#DrawMap -Map $map

# Part 1
$treesFound = GetTreeCount -Map $map -MoveX 3 -MoveY 1
Write-Host "Answer Part 1: $treesFound"

# Part 2
$slopesToCheck = @(
    @(1, 1),
    @(3, 1),
    @(5, 1),
    @(7, 1),
    @(1, 2)
)

$totalTrees = 1

foreach ($slope in $slopesToCheck)
{
    $totalTrees *= (GetTreeCount -Map $map -MoveX $slope[0] -MoveY $slope[1])
}

Write-Host "Answer Part 2: $totalTrees"