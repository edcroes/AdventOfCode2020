$adapters = Get-Content -Path "$PSScriptRoot\input.txt" | Where-Object { $_ } | ForEach-Object { [int]::Parse($_) } | Sort-Object

$joltDifferences = @{ "1" = 0; "2" = 0; "3" = 1 }
$joltDifferences[$adapters[0].ToString()]++

for ($i = 1; $i -lt $adapters.Length; $i++)
{
    $difference = ($adapters[$i] - $adapters[$i-1]).ToString()
    $joltDifferences[$difference]++
}

Write-Host "Answer Part 1: $($joltDifferences["1"] * $joltDifferences["3"])"

# Part 2
$pathCountCache = @{}

function GetPathCount
{
    param($Graph, $From, $To)

    if ($From -eq $To)
    {
        return 1
    }

    $pathCount = 0
    foreach ($node in $Graph | Where-Object { $_.To -eq $To })
    {
        if (-not $pathCountCache.ContainsKey($node.From))
        {
            $pathCountCache.Add($node.From, (GetPathCount -Graph $Graph -From $From -To $node.From))
        }
        $pathCount += $pathCountCache[$node.From]
    }

    return $pathCount
}

## Build graph
$graph = @()
$everything = @(0) # Outlet
$everything += $adapters # Adapters
$everything += (($everything | Sort-Object)[-1] + 3) # Device
$everything = $everything | Sort-Object

for ($i = 0; $i -lt $everything.Length-1; $i++)
{
    $everything[($i+1)..($i+3)] | Where-Object { $_ - $everything[$i] -le 3 } | Foreach-Object {
        $graph += [PSCustomObject]@{ From = $everything[$i]; To = $_ }
    }
}

$totalPathCount = GetPathCount -Graph $graph -From $everything[0] -TO $everything[-1]
Write-Host "Answer Part 2: $totalPathCount"