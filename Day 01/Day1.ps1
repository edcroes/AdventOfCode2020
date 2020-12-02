$items = Get-Content -Path "$PSScriptRoot\input.txt" | ForEach-Object { [int]::Parse($_) } | Select-Object -Unique | Sort-Object

function FindItemsThatMatchUp
{
    param($Items, $Number)

    foreach ($item in $Items)
    {
        $searchFor = $Number - $item

        if ($Items -contains $searchFor)
        {
            return @($item, $searchFor)
        }
    }

    return $null
}

# Part 1
$result = FindItemsThatMatchUp $items 2020
Write-Output "Answer part 1: $($result[0]) * $($result[1]) = $($result[0] * $result[1])"


# Part 2
foreach ($item in $items)
{
    $searchFor = 2020 - $item

    $result = FindItemsThatMatchUp -Items $items -Number $searchFor

    if ($result)
    {
        Write-Output "Answer part 2: $item * $($result[0]) * $($result[1]) = $($item * $result[0] * $result[1])"
        break
    }
}