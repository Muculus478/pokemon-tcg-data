# Define folder paths
$jsonFolderPath = "C:\Users\Gunna\Documents\GitHub\pokemon-tcg-data\cards\en"
$csv2FolderPath = "C:\Users\Gunna\Documents\GitHub\pokemon-tcg-data\cards\csvfiltered"

# Create output directory if it doesn't exist
if (!(Test-Path -Path $csv2FolderPath)) {
    New-Item -ItemType Directory -Path $csv2FolderPath
}

# Define the rarities you want to include
$includedRarities = @('Common', 'Uncommon', 'Rare', 'Rare Holo', 'Promo')
$excludedSubTypes = @('GX', 'ex', 'EX', 'V', 'VMAX', 'V-UNION', 'Star', 'VSTAR', 'BREAK', 'Radiant')

# Create output directory if it doesn't exist
if (!(Test-Path -Path $csv2FolderPath)) {
    New-Item -ItemType Directory -Path $csv2FolderPath
}

# Convert each JSON file in the specified folder
Get-ChildItem -Path $jsonFolderPath -Filter "*.json" | ForEach-Object {
    # Import JSON file
    $jsonContent = Get-Content -Path $_.FullName -Raw | ConvertFrom-Json

    # Flatten each card entry and export to CSV
    $flattenedData = foreach ($card in $jsonContent) {
        # Skip cards that do not match the included rarities
        if ($null -eq $card.rarity -or -not $includedRarities.Contains($card.rarity)) {
            continue
        }

        # Skip cards with excluded subtypes
        if ($card.subtypes -ne $null -and ($card.subtypes | Where-Object { $excludedSubTypes -contains $_ })) {
            continue
        }
        # Flatten main properties
        $flattenedCard = [PSCustomObject]@{
            id                    = $card.id
            name                  = $card.name
            supertype             = $card.supertype
            hp                    = $card.hp
            types                 = ($card.types -join ", ")
            rarity                = $card.rarity
            retreatCost           = ($card.retreatCost -join ", ")
            convertedRetreatCost  = if ($card.convertedRetreatCost -ne $null) { $card.convertedRetreatCost } else { 0 }

            # Initialize ability fields to blank
            AbilityName           = ""
            AbilityText           = ""

            # Initialize attack fields to blank
            Attack1Name           = ""
            Attack1Cost           = ""
            Attack1ConvertedCost  = ""
            Attack1Damage         = ""
            Attack1Text           = ""
            Attack2Name           = ""
            Attack2Cost           = ""
            Attack2ConvertedCost  = ""
            Attack2Damage         = ""
            Attack2Text           = ""
        }

        # Populate ability fields if available
        if ($card.abilities) {
            $ability = $card.abilities[0]
            $flattenedCard.AbilityName = $ability.name
            $flattenedCard.AbilityText = $ability.text
        }

        # Flatten attacks and populate fields if available
        if ($card.attacks) {
            for ($i = 0; $i -lt [math]::Min(2, $card.attacks.Count); $i++) {
                $attack = $card.attacks[$i]
                $flattenedCard."Attack$($i + 1)Name" = $attack.name
                $flattenedCard."Attack$($i + 1)Cost" = ($attack.cost -join ", ")
                $flattenedCard."Attack$($i + 1)ConvertedCost" = $attack.convertedEnergyCost
                $flattenedCard."Attack$($i + 1)Damage" = $attack.damage
                $flattenedCard."Attack$($i + 1)Text" = $attack.text
            }
        }

        # Flatten weaknesses
        if ($card.weaknesses) {
            $weaknessIndex = 0
            foreach ($weakness in $card.weaknesses) {
                $weaknessIndex++
                $flattenedCard | Add-Member -NotePropertyName "Weakness${weaknessIndex}Type" -NotePropertyValue $weakness.type
                $flattenedCard | Add-Member -NotePropertyName "Weakness${weaknessIndex}Value" -NotePropertyValue $weakness.value
            }
        }

        $flattenedCard
    }
    
    # Export to CSV

    $outputCsv = Join-Path -Path $csv2FolderPath -ChildPath ("$($_.BaseName).csv")

    $flattenedData | Export-Csv -Path $outputCsv -NoTypeInformation -Encoding UTF8
    (Get-Content $outputCsv) -replace 'é', 'e' | Set-Content $outputCsv
    (Get-Content $outputCsv) -replace '×', 'x' | Set-Content $outputCsv
    Write-Host "Exported $outputCsv"
}
