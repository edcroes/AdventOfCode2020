$ErrorActionPreference = "Stop"
$lines = Get-Content -Path "$PSScriptRoot\input.txt" | Where-Object { $_ }

function ApplyMask
{
    param([long]$Value, [char[]]$Mask)

    $valueInBit = [Convert]::ToString($Value, 2).PadLeft(36, "0").ToCharArray()

    for ($i = 0; $i -lt $Mask.Length; $i++)
    {
        if (@("1", "0") -contains $Mask[$i])
        {
            $valueInBit[$i] = $Mask[$i]
        }
    }

    return [Convert]::ToInt64([string]::new($valueInBit), 2)
}

function SetMemory
{
    param([long]$Value, [long]$Address, [char[]]$Mask, [hashtable]$Memory)

    $addresses = @("")
    $addressInBit = [Convert]::ToString($Address, 2).PadLeft(36, "0").ToCharArray()

    for ($i = $Mask.Length - 1; $i -ge 0; $i--)
    {
        if ($Mask[$i] -eq "X")
        {
            $newAddresses = @()
            foreach ($addr in $addresses)
            {
                $newAddresses += "0" + $addr
                $newAddresses += "1" + $addr
            }
            $addresses = $newAddresses
        }
        else
        {
            $bitToSet = if ($Mask[$i] -eq "1") { "1" } else { $addressInBit[$i] }
            for($j = 0; $j -lt $addresses.Length; $j++)
            {
                $addresses[$j] = $bitToSet + $addresses[$j]
            }
        }
    }

    foreach ($addr in $addresses)
    {
        $location = [Convert]::ToInt64($addr, 2)
        $Memory[$location] = $Value
    }
}

# Part 1
$currentMask = @()
$memory = @{}

foreach ($line in $lines)
{
    if ($line -match "^mem\[(\d+)\] = (\d+)$")
    {
        $location = $Matches[1]
        $value = [long]::Parse($Matches[2])
        $memory[$location] = ApplyMask -Value $value -Mask $currentMask
    }
    else
    {
        $currentMask = $line.Replace("mask = ", "").ToCharArray()
    }
}

$grandTotal = 0L
$memory.Values | ForEach-Object { $grandTotal += $_ }
Write-Host "Answer Part 1: $grandTotal"

# Part 2
$currentMask = @()
$memory = @{}

foreach ($line in $lines)
{
    if ($line -match "^mem\[(\d+)\] = (\d+)$")
    {
        $location = $Matches[1]
        $value = [long]::Parse($Matches[2])
        SetMemory -Value $value -Address $location -Mask $currentMask -Memory $memory
    }
    else
    {
        $currentMask = $line.Replace("mask = ", "").ToCharArray()
    }
}

$grandTotal = 0L
$memory.Values | ForEach-Object { $grandTotal += $_ }
Write-Host "Answer Part 2: $grandTotal"