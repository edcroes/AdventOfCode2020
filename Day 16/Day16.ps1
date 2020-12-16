function IsFieldValidInClass
{
    param($Field, $Class)

    foreach ($range in $class.Ranges)
    {
        if ($Field -ge $range.From -and $Field -le $range.To)
        {
            return $true
        }
    }

    return $false
}

function IsFieldValidInClasses
{
    param($Field, $Classes)

    foreach ($class in $Classes)
    {
        if (IsFieldValidInClass -Field $Field -Class $class)
        {
            return $true
        }
    }

    return $false
}

$ErrorActionPreference = "Stop"
$contents = Get-Content -Path "$PSScriptRoot\input.txt" -Raw
$classesPart,$myTicketPart,$otherTicketsPart = $contents.Replace("`r", "").Split(@("`n`n"), [System.StringSplitOptions]::RemoveEmptyEntries)

$classes = @()
$myTicket = $myTicketPart.Split("`n")[1].Split(",") | Foreach-Object { [int]::Parse($_) }
$otherTickets = @()

foreach ($class in $classesPart.Split("`n"))
{
    if ($class -match "^([a-z ]+): (\d+)-(\d+) or (\d+)-(\d+)$")
    {
        $classes += [PSCustomObject]@{
            Name = $Matches[1]
            Ranges = @(
                @{ From = [int]::Parse($Matches[2]); To = [int]::Parse($Matches[3]) }
                @{ From = [int]::Parse($Matches[4]); To = [int]::Parse($Matches[5]) }
            )
        }
    }
}

foreach ($ticket in $otherTicketsPart.Split("`n") | Where-Object { $_ } | Select-Object -Skip 1)
{
    $otherTickets += @{ Values = $ticket.Split(",") | Foreach-Object { [int]::Parse($_) }; InvalidValue = @() }
}

# Part 1
$summedInvalids = 0
foreach ($ticket in $otherTickets)
{
    $ticket.InvalidValues = $ticket.Values | Where-Object { -not (IsFieldValid -Field $_ -Classes $classes) }
    $ticket.InvalidValues | ForEach-Object { $summedInvalids += $_ }
}

Write-Host "Answer Part 1: $summedInvalids"

# Part 2
$otherTickets = $otherTickets | Where-Object { $_.InvalidValues.Length -eq 0 }

$options = [object[]]::new($myTicket.Length)
for ($i = 0; $i -lt $myTicket.Length; $i++)
{
    $options[$i] = @{ FieldIndex = $i; Classes = @($classes | Where-Object { IsFieldValidInClass -Class $_ -Field $myTicket[$i] }) }
}

foreach ($ticket in $otherTickets)
{
    for ($i = 0; $i -lt $ticket.Values.Length; $i++)
    {
        $options[$i].Classes = @($options[$i].Classes | Where-Object { IsFieldValidInClass -Class $_ -Field $ticket.Values[$i] })
    }
}

$fieldClass = [object[]]::new($myTicket.Length)
$sortedOptions = $options | Sort-Object { $_.Classes.Length }
foreach ($option in $sortedOptions)
{
    $lefOverOption = @($option.Classes | Where-Object { $fieldClass -notcontains $_ })
    if ($lefOverOption.Length -ne 1)
    {
        throw "More than one or no choices left"
    }
    $fieldClass[$option.FieldIndex] = $lefOverOption[0]
}

$answerPart2 = 1
for ($i = 0; $i -lt $fieldClass.Length; $i++)
{
    if ($fieldClass[$i].Name -like "departure *")
    {
        $answerPart2 *= $myTicket[$i]
    }
}

Write-Host "Answer Part 2: $answerPart2"