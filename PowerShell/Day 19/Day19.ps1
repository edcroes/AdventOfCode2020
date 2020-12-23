function ParseRule
{
    param ([string] $Line)

    $id,$rest = $Line.Split(":")
    $rule = [PSCustomObject]@{
        Id = [int]::Parse($id)
        Regex = $null
        SubRules = $null
    }

    if ($rest -match "`"([a-z])`"")
    {
        $rule.Regex = $Matches[1]
    }
    else
    {
        $rule.SubRules = $rest.Trim()
    }

    return $rule
}

function GetRegex
{
    param ($Rule, $Rules)

    if ($Rule.Regex)
    {
        return $Rule.Regex
    }

    $regex = ""
    $or = $false
    if (-not $Rule.SubRules)
    {
        Write-Host "wtf"
    }
    $parts = $Rule.SubRules.Split(" ")
    foreach ($part in $parts)
    {
        if ($part -eq "|")
        {
            $regex += $part
            $or = $true
            continue
        }

        $ruleId = [int]::Parse($part)
        $regex += GetRegex -Rule $Rules[$ruleId] -Rules $Rules
    }

    if ($or)
    {
        $regex = "(?:$regex)"
    }

    $Rule.Regex = $regex
    return $regex
}

$ErrorActionPreference = "Stop"
$rulesPart,$messagesPart = (Get-Content -Path "$PSScriptRoot\input.txt" -Raw).Replace("`r", "").Split(@("`n`n"), [System.StringSplitOptions]::RemoveEmptyEntries)
$rules = $rulesPart.Split("`n") | Foreach-Object { ParseRule -Line $_ } | Sort-Object { $_.Id }
$messages = $messagesPart.Split("`n", [System.StringSplitOptions]::RemoveEmptyEntries)

# Part 1
$regexRule0 = GetRegex -Rule $rules[0] -Rules $rules
$messagesThatMatch = $messages | Where-Object { $_ -match "^$regexRule0$" }

Write-Host "Answer Part 1: $($messagesThatMatch.Count)"

# Part 2
# 8: 42 | 42 8 -> could be 42, 42 42, 42 42 42 etc... or in regex language 42+
$rule42Regex = GetRegex -Rule $rules[42] -Rules $rules
$rules[8].Regex = if ($rule42Regex -like "(*)") { "$rule42Regex+" } else { "(?:$rule42Regex)+" }

# 11: 42 31 | 42 11 31 -> could be 42 31, 42 42 31 31, 42 42 42 31 31 31 etc... or the joy of balancing groups
$rule31Regex = GetRegex -Rule $rules[31] -Rules $rules
$rules[11].Regex = "(?<count>$rule42Regex)+(?<-count>$rule31Regex)+(?(count)(?!))"

$rules[0].Regex = $null
$regexRule0 = GetRegex -Rule $rules[0] -Rules $rules
$messagesThatMatch = $messages | Where-Object { $_ -match "^$regexRule0$" }

Write-Host "Answer Part 2: $($messagesThatMatch.Count)"