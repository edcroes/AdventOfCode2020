function ParseIngredientList
{
    param([string] $Line)

    $ingredientsPart,$allergensPart = $Line.Split("(");
    $ingredients = @($ingredientsPart.Split(" ", [System.StringSplitOptions]::RemoveEmptyEntries))
    $allergens = @($allergensPart.TrimEnd(")").Replace("contains", "").Trim().Split(", ", [System.StringSplitOptions]::RemoveEmptyEntries))

    return @{
        Ingredients = $ingredients
        Allergens = $allergens
    }
}

$ErrorActionPreference = "Stop"
$ingredientLists = Get-Content -Path "$PSScriptRoot\input.txt" | Where-Object { $_ } | ForEach-Object { ParseIngredientList -Line $_ }

$knownIngredientAllergen = @{}

$listWithOneAllergen = @($ingredientLists | Where-Object { $_.Allergens.Length -eq 1 })
while ($listWithOneAllergen.Length -gt 0)
{
    foreach ($list in $listWithOneAllergen)
    {
        if ($knownIngredientAllergen.Keys -contains $list.Allergens[0])
        {
            continue
        }

        $options = @($list.Ingredients)
        if ($options.Length -gt 1)
        {
            $otherListsWithAllergen = $ingredientLists | Where-Object { $_.Allergens -contains $list.Allergens[0] }

            foreach ($otherList in $otherListsWithAllergen)
            {
                $options = @($options | Where-Object { $otherList.Ingredients -contains $_ })
                if ($options.Length -lt 2)
                {
                    break
                }
            }
        }

        if ($options.Length -eq 1)
        {
            $knownIngredientAllergen.Add($list.Allergens[0], $options[0])
        }
    }

    foreach ($list in $ingredientLists)
    {
        $list.Ingredients = @($list.Ingredients | Where-Object { $knownIngredientAllergen.Values -notcontains $_ })
        $list.Allergens = @($list.Allergens | Where-Object {$knownIngredientAllergen.Keys -notcontains $_ })
    }

    $listWithOneAllergen = @($ingredientLists | Where-Object { $_.Allergens.Length -eq 1 })
}

# Part 1
$totalIngredientsWithoutAllergenUsed = 0
$ingredientLists | Foreach-Object { $totalIngredientsWithoutAllergenUsed += $_.Ingredients.Length }

Write-Host "Answer Part 1: $totalIngredientsWithoutAllergenUsed"

# Part 2
$sortedAllergens = $knownIngredientAllergen.Keys | Sort-Object
$ingredients = $sortedAllergens | Foreach-Object { $knownIngredientAllergen[$_] }
Write-Host "Answer Part 2: $($ingredients -join ",")"