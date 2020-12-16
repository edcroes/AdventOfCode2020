
$script:invalids = @{}
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

    if ($script:invalids.ContainsKey($Class.Name))
    {
        $script:invalids[$Class.Name]++
    }
    else
    {
        $script:invalids.Add($Class.Name, 1)
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

# Parsing
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
$otherTickets = $otherTickets | Where-Object { -not $_.InvalidValues }

$options = [object[]]::new($myTicket.Length)
for ($i = 0; $i -lt $myTicket.Length; $i++)
{
    $options[$i] = $classes | Where-Object { IsFieldValidInClass -Class $_ -Field $myTicket[$i] }
}

foreach ($ticket in $otherTickets)
{
    for ($i = 0; $i -lt $ticket.Values.Length; $i++)
    {
        $options[$i] = @($options[$i] | Where-Object { IsFieldValidInClass -Class $_ -Field $ticket.Values[$i] })
    }
}

while (($options | Where-Object { $_.Length -gt 1 }))
{
    for ($i = 0; $i -lt $options.Length; $i++)
    {
        $currentOptions = $options[$i]

        if ($currentOptions.Length -eq 1)
        {
            for ($j = 0; $j -lt $options.Length; $j++)
            {
                if ($i -eq $j)
                {
                    continue;
                }

                if ($options[$j] -contains $currentOptions[0])
                {
                    $options[$j] = @($options[$j] | Where-Object { $_ -ne $currentOptions[0] })
                }
            }
        }
    }
}

$answerPart2 = 1
for ($i = 0; $i -lt $options.Length; $i++)
{
    if ($options[$i][0].Name -like "departure *")
    {
        $answerPart2 *= $myTicket[$i]
    }
}

Write-Host "Answer Part 2: $answerPart2"