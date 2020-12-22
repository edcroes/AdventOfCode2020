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

$allOptions = @{}
$listWithAllergens = @($ingredientLists | Where-Object { $_.Allergens })
while ($listWithAllergens.Length -gt 0)
{
    foreach ($list in $listWithAllergens)
    {
        foreach ($allergen in $list.Allergens)
        {
            if ($knownIngredientAllergen.Keys -contains $allergen)
            {
                continue
            }

            $options = @($list.Ingredients)
            if ($options.Length -gt 1)
            {
                $otherListsWithAllergen = $ingredientLists | Where-Object { $_.Allergens -contains $allergen }

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
                $knownIngredientAllergen.Add($allergen, $options[0])
                $allOptions.Remove($allergen)
            }
            else
            {
                if ($allOptions.ContainsKey($allergen))
                {
                    $allOptions[$allergen] = @($allOptions[$allergen] | Where-Object { $options -contains $_ })
                    if ($allOptions[$allergen].Length -eq 1)
                    {
                        $knownIngredientAllergen.Add($allergen, $allOptions[$allergen][0])
                        $allOptions.Remove($allergen)
                    }
                }
                else
                {
                    $allOptions.Add($allergen, $options)
                }
            }

        }
    }

    foreach ($list in $ingredientLists)
    {
        $list.Ingredients = @($list.Ingredients | Where-Object { $knownIngredientAllergen.Values -notcontains $_ })
        $list.Allergens = @($list.Allergens | Where-Object {$knownIngredientAllergen.Keys -notcontains $_ })
    }

    $listWithAllergens = @($ingredientLists | Where-Object { $_.Allergens })
}

# Part 1
$totalIngredientsWithoutAllergenUsed = 0
$ingredientLists | Foreach-Object { $totalIngredientsWithoutAllergenUsed += $_.Ingredients.Length }

Write-Host "Answer Part 1: $totalIngredientsWithoutAllergenUsed"

# Part 2
$sortedAllergens = $knownIngredientAllergen.Keys | Sort-Object
$ingredients = $sortedAllergens | Foreach-Object { $knownIngredientAllergen[$_] }
Write-Host "Answer Part 2: $($ingredients -join ",")"