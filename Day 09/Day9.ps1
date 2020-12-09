Import-Module -Name "$PSScriptRoot\..\Modules\NumbersList.psm1" -Force
$data = Get-Content -Path "$PSScriptRoot\input.txt" | Where-Object { $_ } | Foreach-Object { [long]::Parse($_) }

$preambleSize = 25
$invalidNumber = 0

for ($i = $preambleSize; $i -lt $data.Length; $i++)
{
    $result = Find-ItemsThatMatchUp -Numbers $data[($i-$preambleSize)..($i-1)] -NumberToMatch $data[$i]
    if (-not $result)
    {
        $invalidNumber = $data[$i]
        break
    }
}

# Part 1
Write-Host "Answer Part 1: $invalidNumber"

#Part 2
$result = Find-ContiguousSetOfItemsThatMatchUp -Numbers $data -NumberToMatch $invalidNumber
$sortedAnswer = $data[$result.StartIndex..$result.EndIndex] | Sort-Object
Write-Host "Answer Part 2: $($sortedAnswer[0] + $sortedAnswer[-1])"