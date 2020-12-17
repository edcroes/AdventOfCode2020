$groups = (Get-Content -Path "$PSScriptRoot\input.txt" -Raw).Replace("`r", "").Replace("`n`n", "|").Replace("`n", ",").Split("|") | ForEach-Object { $_.Trim().Trim(",") }

# Part 1
$totalYes = 0
foreach ($group in $groups)
{
    $answers = @()
    foreach ($list in $group.Split(","))
    {
        $answers += $list
    }
    $totalYes += ($answers.ToCharArray() | Select-Object -Unique).Count
}

Write-Host "Answer Part 1: $totalYes"

# Part 2
$totalYes = 0

foreach ($group in $groups)
{
    $answers = $group.ToCharArray()
    $noOfLists = ($answers | Where-Object { $_ -eq "," }).Count + 1
    $questions = $answers | Where-Object { $_ -ne "," } | Select-Object -Unique

    foreach ($question in $questions)
    {
        if (($answers | Where-Object { $_ -eq $question }).Count -eq $noOfLists)
        {
            $totalYes++
        }
    }
}

Write-Host "Answer Part 2: $totalYes"