$PasswordRegex = [regex]"^(\d+)-(\d+) ([a-z]): ([a-z]+)$"
$lines = Get-Content -Path "$PSScriptRoot\input.txt" | Where-Object { $_ }

function ParseLine
{
    param([string] $Line)

    $matches = $PasswordRegex.Match($Line)
    return [PSCustomObject] @{
        Min = [int]::Parse($matches.Groups[1].Value)
        Max = [int]::Parse($matches.Groups[2].Value)
        Letter = $matches.Groups[3].Value
        Password = $matches.Groups[4].Value
    }
}

function IsValidPart1
{
    param($PasswordInfo)

    $chars = $PasswordInfo.Password.ToCharArray() | Where-Object { $_ -eq $PasswordInfo.Letter }
    
    return $chars.Count -ge $PasswordInfo.Min -and $chars.Count -le $PasswordInfo.Max
}

function IsValidPart2
{
    param($PasswordInfo)

    $chars = $PasswordInfo.Password.ToCharArray()
    
    return $chars[$PasswordInfo.Min-1] -eq $PasswordInfo.Letter -xor $chars[$PasswordInfo.Max-1] -eq $PasswordInfo.Letter
}

$validPart1Count = 0
$validPart2Count = 0

foreach ($line in $lines)
{
    $pw = ParseLine -Line $line
    $isValidPart1 = IsValidPart1 -PasswordInfo $pw
    $isValidPart2 = IsValidPart2 -PasswordInfo $pw

    if ($isValidPart1)
    {
        $validPart1Count++
    }

    if ($isValidPart2)
    {
        $validPart2Count++
    }
}

Write-Output "Answer Part 1: $($validPart1Count)"
Write-Output "Answer Part 2: $($validPart2Count)"