Import-Module -Name "$PSScriptRoot\..\Modules\NumbersList.psm1" -Force
$items = Get-Content -Path "$PSScriptRoot\input.txt" | ForEach-Object { [int]::Parse($_) } | Select-Object -Unique | Sort-Object

# Part 1
$result = Find-ItemsThatMatchUp -Numbers $items -NumberToMatch 2020
Write-Output "Answer part 1: $($result[0]) * $($result[1]) = $($result[0] * $result[1])"

# Part 2
foreach ($item in $items)
{
    $searchFor = 2020 - $item

    $result = Find-ItemsThatMatchUp -Numbers $items -NumberToMatch $searchFor

    if ($result)
    {
        Write-Output "Answer part 2: $item * $($result[0]) * $($result[1]) = $($item * $result[0] * $result[1])"
        break
    }
}