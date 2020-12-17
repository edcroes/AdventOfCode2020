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
x ≡ bᵢ(mod nᵢ) --> bᵢ is the remainder
--------------
x ≡ b₁(mod n₁)
x ≡ b₂(mod n₂)
x ≡ b₃(mod n₃)

M = n₁n₂n₃
Mᵢ = M / nᵢ
xᵢ = Inverse of Mᵢ

Find Inverse of Mᵢ:
Mᵢxᵢ ≡ 1(mod nᵢ)
(Mᵢ%nᵢ)xᵢ ≡ 1(mod nᵢ)
Determine for which (Mᵢ%nᵢ)xᵢ the remainder of dividing by nᵢ equals 1

bᵢ  Mᵢ  xᵢ  bᵢMᵢxᵢ
------------------
b₁  M₁  x₁  b₁M₁x₁
b₂  M₂  x₂  b₂M₂x₂
b₃  M₃  x₃  b₃M₃x₃

x ≡ sum of bᵢMᵢxᵢ (mod M)

Final answer = (sum of bᵢMᵢxᵢ) % M

Example
--------
x ≡ 3(mod 5)
x ≡ 1(mod 7)
x ≡ 6(mod 8)

M = 5 * 7 * 8 = 280

bᵢ  Mᵢ  xᵢ      bᵢMᵢxᵢ
---------------------------------
3   56  1 [a]   3 * 56 * 1 = 168
1   40  3 [b]   1 * 40 * 3 = 120
5   35  3 [c]   5 * 35 * 3 = 630

[a] 56x₁ ≡ 1(mod 5) -> 56 % 5 = 1 -> 1x₁ ≡ 1(mod 5) -> x₁ = 1
[b] 40x₂ ≡ 1(mod 7) -> 40 % 7 = 5 -> 5x₂ ≡ 1(mod 7) -> 5 * 3 = 15, 15 % 7 = 1 -> x₂ = 3
[c] 35x₃ ≡ 1(mod 8) -> 35 % 8 = 3 -> 3x₃ ≡ 1(mod 8) -> 3 * 3 = 9, 9 % 8 = 1 -> x₃ = 3

x = Sum of bᵢMᵢxᵢ = 168 + 120 + 630 = 918
x ≡ 918(mod 280) -> answer:  x ≡ 78(mod 280)
918 % 280 = 78

In this case the answer that is returned is 78.

Explanation used: https://www.youtube.com/watch?v=zIFehsBHB8o
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