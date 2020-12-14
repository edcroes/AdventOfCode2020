$ErrorActionPreference = "Stop"

function GetInverseNi
{
    [CmdletBinding()]
    param
    (
        [long] $Mi,
        [int] $n
    )

    $normalizedMi = $Mi % $n
    $xi = 0
    while(($normalizedMi * $xi) % $n -ne 1)
    {
        $xi++
    }

    return $xi
}

<#
x = bi(mod ni) --> bi is the remainder
--------------
x = b1(mod n1)
x = b2(mod n2)
x = b3(mod n3)

M = n1n2n3
Mi = M / ni
xi = Inverse of Mi

Find Inverse of Mi:
Mixi = 1(mod ni)
(Mi%ni)xi = 1(mod ni)
Determine for which (Mi%ni)xi the remainder of dividing by ni equals 1

bi  Mi  xi  biMixi
------------------
b1  M1  x1  b1M1x1
b2  M2  x2  b2M2x2
b3  M3  x3  b3M3x3

x = sum of biMixi (mod M)

Final answer = (sum of biMixi) % M

Example
--------
x = 3(mod 5)
x = 1(mod 7)
x = 6(mod 8)

M = 5 x 7 x 8 = 280

bi  Mi  xi    biMixi
------------------
3   56  1 [a] 3 x 56 x 1 = 168
1   40  3 [b] 1 x 40 x 3 = 120
5   35  3 [c] 5 x 35 x 3 = 630

[a] 56x1 = 1(mod 5) -> 56 % 5 = 1 -> 1x1 = 1(mod 5) -> x1 = 1
[b] 40x2 = 1(mod 7) -> 40 % 7 = 5 -> 5x2 = 1(mod 7) -> 5 x 3 = 15, 15 % 7 = 1 -> x2 = 3
[c] 35x3 = 1(mod 8) -> 35 % 8 = 3 -> 3x3 = 1(mod 8) -> 3 x 3 = 9, 9 % 8 = 1 -> x3 = 3

x = Sum of biMixi = 168 + 120 + 630 = 918
x = 918(mod 280) -> x = 78(mod 280)
918 % 280 = 78

So the answer is 78
#>
function ChineseRemainder
{
    [CmdletBinding()]
    param
    (
        [int[]] $Remainders,
        [int[]] $Values
    )

    [long]$M = 1
    $Values | ForEach-Object { $M *= $_ }

    $sumbiMixi = 0
    for ($i = 0; $i -lt $Values.Length; $i++)
    {
        $n = $Values[$i]
        $bi = $Remainders[$i]
        $Mi = $M / $n
        $xi = GetInverseNi -Mi $Mi -n $n
        $biMixi = $bi * $Mi * $xi
        $sumbiMixi += $biMixi
    }

    return $sumbiMixi % $M
}

$allBusses = (Get-Content -Path "$PSScriptRoot\input.txt")[1].Split(",")

$remainders = @()
$busses = @()

for ($i = 0; $i -lt $allBusses.Length; $i++)
{
    if ($allBusses[$i] -ne "x")
    {
        $bus = [int]::Parse($allBusses[$i])
        $busses += $bus
        $remainders += $bus - ($i % $bus)
    }
}

$answer = ChineseRemainder -Remainders $remainders -Values $busses
Write-Host "Answer Part 2: $answer"