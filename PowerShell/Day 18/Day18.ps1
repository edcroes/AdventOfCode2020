function CalculateExpressionPart1
{
    param($Expression)

    $operators = @("+", "*")
    $Expression = $Expression.Replace(" ", "")
    $currentOutcome = 0
    $currentOperator = "+"

    for($i  = 0; $i -lt $Expression.Length; $i++)
    {
        if ($operators -contains $Expression[$i])
        {
            $currentOperator = $Expression[$i]
        }
        elseif ($Expression[$i] -eq "(")
        {
            $end = $i+1
            $depth = 0
            while ($Expression[$end] -ne ")" -or $depth -ne 0)
            {
                if ($Expression[$end] -eq "(")
                {
                    $depth++
                }
                elseif ($Expression[$end] -eq ")")
                {
                    $depth--
                }
                $end++
            }
            $groupResult = CalculateExpressionPart1 -Expression $Expression.Substring($i+1, $end-$i-1)

            if ($currentOperator -eq "+")
            {
                $currentOutcome += $groupResult
            }
            elseif ($currentOperator -eq "*")
            {
                $currentOutcome *= $groupResult
            }

            $i = $end
        }
        else
        {
            if ($currentOperator -eq "+")
            {
                $currentOutcome += [int]::Parse($Expression[$i])
            }
            elseif ($currentOperator -eq "*")
            {
                $currentOutcome *= [int]::Parse($Expression[$i])
            }
        }
    }

    return $currentOutcome
}

function CalculateExpressionPart2
{
    param($Expression, $Depth = 0, [switch]$InMultiplication)

    $Expression = $Expression.Replace(" ", "")
    $currentOutcome = 0
    $currentOperator = "+"

    for($i  = 0; $i -lt $Expression.Length; $i++)
    {
        if ($Expression[$i] -eq "+")
        {
            $currentOperator = $Expression[$i]
        }
        elseif ($Expression[$i] -eq "*")
        {
            $currentOperator = $Expression[$i]
            $result,$newi = CalculateExpressionPart2 -Expression $Expression.Substring($i+1) -Depth $Depth+1 -InMultiplication
            $i += $newi
            $currentOutcome *= $result
        }
        elseif ($Expression[$i] -eq "(")
        {
            $groupResult,$newi = CalculateExpressionPart2 -Expression $Expression.Substring($i+1) -Depth $Depth+1
            $i += $newi

            if ($currentOperator -eq "+")
            {
                $currentOutcome += $groupResult
            }
            elseif ($currentOperator -eq "*")
            {
                $currentOutcome *= $groupResult
            }
        }
        elseif ($Expression[$i] -match "\d")
        {
            if ($currentOperator -eq "+")
            {
                $currentOutcome += [int]::Parse($Expression[$i])
            }
            elseif ($currentOperator -eq "*")
            {
                $currentOutcome *= [int]::Parse($Expression[$i])
            }
        }
        else
        {
            if (-not $InMultiplication)
            {
                $i++
            }
            break
        }
    }

    if ($Depth -ne 0)
    {
        return $currentOutcome,$i
    }
    else
    {
        return $currentOutcome
    }
}

$ErrorActionPreference = "Stop"
$expressions = Get-Content -Path "$PSScriptRoot\input.txt"

$sum = 0
foreach ($expression in $expressions)
{
    $sum += CalculateExpressionPart1 -Expression $expression
}

Write-Host "Answer Part 1: $sum"

$sum = 0
foreach ($expression in $expressions)
{
    $sum += CalculateExpressionPart2 -Expression $expression
}

Write-Host "Answer Part 2: $sum"