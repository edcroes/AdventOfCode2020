<#
.SYNOPSIS
Finds two numbers in the array that match up to the requested number.

.PARAMETER Numbers
The list of numbers to check.

.PARAMETER NumberToMatch
The number for which a pair should be found that match up to this number.

.OUTPUTS
An array of the numbers that match up to the requested number, null of no matching pair was found.
#>
function Find-ItemsThatMatchUp
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [long[]] $Numbers,

        [Parameter(Mandatory)]
        [long] $NumberToMatch
    )

   foreach ($firstNumber in $Numbers)
    {
        $secondNumber = $NumberToMatch - $firstNumber

        if ($Numbers -contains $secondNumber)
        {
            return @($firstNumber, $secondNumber)
        }
    }

    return $null
}

<#
.SYNOPSIS
Finds a contiguous set of numbers in the array that match up to the requested number.

.PARAMETER Numbers
The list of numbers to in which to find the set.

.PARAMETER NumberToMatch
The number for which a contiguous set should be found that match up to this number.

.OUTPUTS
An object containing StartIndex and EndIndex for the contiguous list, null of not found.
#>
function Find-ContiguousSetOfItemsThatMatchUp
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [long[]] $Numbers,

        [Parameter(Mandatory)]
        [long] $NumberToMatch
    )

    $startIndex = -1
    $endIndex = -1

    for ($i = 0; $i -lt $data.Length; $i++)
    {
        $currentSum = $data[$i]

        for ($j = $i+1; $j -lt $data.Length; $j++)
        {
            $currentSum += $data[$j]
            if ($currentSum -eq $invalidNumber)
            {
                $endIndex = $j
                break
            }
            elseif ($currentSum -gt $invalidNumber)
            {
                break
            }
        }

        if ($endIndex -ne -1)
        {
            $startIndex = $i
            break
        }
    }

    if ($startIndex -ne -1)
    {
        return [PSCustomObject]@{ StartIndex = $startIndex; EndIndex = $endIndex }
    }

    return $null
}

Export-ModuleMember -Function "*-*"