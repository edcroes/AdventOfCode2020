function ParsePassport
{
    param($UnparsedPassport)

    $passport = @{}
    ($UnparsedPassport -split " ") | ForEach-Object { $key,$value = $_ -split ":"; $passport.Add($key, $value) }

    return $passport
}

function AreRequiredFieldsPresent
{
    param($Passport)

    $missingFields = @("byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid") | Where-Object { $Passport.Keys -notcontains $_ }
    return -not $missingFields
}

function IsNumberValid
{
    param($Number, $MinValue, $MaxValue, $ExactLength)

    if ($Number -notmatch "^\d+$" -or
        ($ExactLength -and $Number.Length -ne $ExactLength))
    {
        return $false
    }

    if ($MinValue -and $MaxValue)
    {
        $realNumber = [int]::Parse($Number)
        return $realNumber -ge $MinValue -and $realNumber -le $MaxValue
    }

    return $true
}

function IsHeightValid
{
    param($Height)

    $boundries = @{
        cm = @{ Min = 150; Max = 193 }
        in = @{ Min = 59; Max = 76 }
    }

    return $Height -match "^(\d+)(cm|in)$" -and (IsNumberValid -Number $Matches[1] -MinValue $boundries[$Matches[2]].Min -MaxValue $boundries[$Matches[2]].Max)
}

function IsPassportValid
{
    param($Passport)

    return `
        (IsNumberValid -Number $Passport["byr"] -MinValue 1920 -MaxValue 2002) -and
        (IsNumberValid -Number $Passport["iyr"] -MinValue 2010 -MaxValue 2020) -and
        (IsNumberValid -Number $Passport["eyr"] -MinValue 2020 -MaxValue 2030) -and
        (IsHeightValid -Height $Passport["hgt"]) -and
        $Passport["hcl"] -match "^#[0-9a-f]{6}$" -and
        @("amb", "blu", "brn", "gry", "grn", "hzl", "oth") -contains $Passport["ecl"] -and
        (IsNumberValid -Number $Passport["pid"] -ExactLength 9)
}

$input = Get-Content -Path "$PSScriptRoot\input.txt" -Raw
$unparsedPassports = $input.Replace("`r", "").Split(@("`n`n"), [System.StringSplitOptions]::None) | ForEach-Object { $_.Replace("`n", " ").Trim() }

$noOfValidPassportsPart1 = 0
$noOfValidPassportsPart2 = 0

foreach ($unparsedPassport in $unparsedPassports)
{
    $passport = ParsePassport -UnparsedPassport $unparsedPassport
    
    if (AreRequiredFieldsPresent -Passport $passport)
    {
        $noOfValidPassportsPart1++
        $noOfValidPassportsPart2 += [int](IsPassportValid -Passport $passport)
    }
}

Write-Host "Answer Part 1: $noOfValidPassportsPart1"
Write-Host "Answer Part 2: $noOfValidPassportsPart2"