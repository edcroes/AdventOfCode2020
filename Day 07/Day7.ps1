function ParseBags
{
    param($Rules)

    $bagTypes = @{}

    foreach ($rule in $rules)
    {
        $bagTypeName,$allContents = $rule.Split(@(" bags contain "), [System.StringSplitOptions]::RemoveEmptyEntries)
        $contents = @()

        foreach ($bagQuantity in $allContents.Split(@(", "), [System.StringSplitOptions]::RemoveEmptyEntries))
        {
            if ($bagQuantity -match "^?(\d+) ([a-z ]+) bags?.?")
            {
                $quantity = [int]::Parse($Matches[1])
                $type = $Matches[2]
                $contents += @{ Name = $type; Quantity = $quantity }
            }
        }

        $bagTypes.Add($bagTypeName, $contents)
    }

    return $bagTypes
}

function GetTotalBagsPerColor
{
    param($BagTypeName, $BagTypes, $ProcessedBagTypes)

    if ($ProcessedBagTypes.ContainsKey($BagTypeName))
    {
        return $ProcessedBagTypes[$BagTypeName]
    }

    $allColorQuantities = @{}
    $includedBags = $BagTypes[$BagTypeName]
    foreach ($bag in $includedBags)
    {
        if ($allColorQuantities.ContainsKey($bag.Name))
        {
            $allColorQuantities[$bag.Name] += $bag.Quantity
        }
        else
        {
            $allColorQuantities.Add($bag.Name, $bag.Quantity)
        }

        $bagContents = GetTotalBagsPerColor -BagTypeName $bag.Name -BagTypes $BagTypes -ProcessedBagTypes $ProcessedBagTypes
        foreach ($color in $bagContents.Keys)
        {
            if ($allColorQuantities.ContainsKey($color))
            {
                $allColorQuantities[$color] += $bag.Quantity * $bagContents[$color]
            }
            else
            {
                $allColorQuantities.Add($color, $bag.Quantity * $bagContents[$color])
            }
        }
    }

    $ProcessedBagTypes.Add($BagTypeName, $allColorQuantities)

    return $allColorQuantities
}

$rules = Get-Content -Path "$PSScriptRoot\input.txt" | Where-Object { $_ }
$processedBagTypes = @{}
$bagTypes = ParseBags -Rules $rules

# Part 1
$bagsWithShinyGoldCount = 0

foreach ($bag in $bagTypes.Keys)
{
    $colors = GetTotalBagsPerColor $bag $bagTypes $processedBagTypes

    if ($colors.Keys -contains "shiny gold")
    {
        $bagsWithShinyGoldCount++
    }
}

Write-Host "Answer Part 1: $bagsWithShinyGoldCount"

# Part 2
$totalBagsInShinyGold = 0
$bagsInShinyGold = $processedBagTypes["shiny gold"]
$bagsInShinyGold.Values | ForEach-Object { $totalBagsInShinyGold += $_ }

Write-Host "Answer Part 2: $totalBagsInShinyGold"