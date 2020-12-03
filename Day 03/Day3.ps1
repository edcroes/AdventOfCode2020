function DrawMap
{
    param($Map)

    foreach ($line in $Map)
    {
        foreach ($point in $line)
        {
            $char = if ($point) { "#" } else { "." }
            Write-Host $char -NoNewline
        }
        Write-Host ""
    }
}

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

function ParseMap
{
    param($Lines)

    $map = [bool[][]]::new($Lines.Length)

    for ($lineNumber = 0; $lineNumber -lt $lines.Length; $lineNumber++)
    {
        $mapLine = @()
        $Lines[$lineNumber].ToCharArray() | ForEach-Object {
            $isTree = $_ -eq "#"
            $mapLine += $isTree
        }

        $map[$lineNumber] = $mapLine
    }

    return $map
}


$lines = Get-Content -Path "$PSScriptRoot\input.txt"
$map = ParseMap -Lines $lines
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