function GetSeatId
{
    param([string]$Line)

    $row = [Convert]::ToByte($Line.Substring(0, 7).Replace("B", "1").Replace("F", "0"), 2)
    $seat = [Convert]::ToByte($Line.Substring(7).Replace("L", "0").Replace("R", "1"), 2)
    return $row * 8 + $seat
}

$seats = Get-Content -Path "$PSScriptRoot\input.txt" | Foreach-Object { GetSeatId -Line $_ }

# Part 1
# Actually answered this one by just searching the file, start with BBBBBBB etc till found
Write-Host "Answer Part 1: $(($seats | Sort-Object -Descending)[0])"

# Part 2
foreach ($seat in ($seats | Sort-Object))
{
    if ($seats -notcontains $seat + 1 -and $seats -contains $seat + 2)
    {
        Write-Host "Answer Part 2: $($seat + 1)"
        break
    }
}