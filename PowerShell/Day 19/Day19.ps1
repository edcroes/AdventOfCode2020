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