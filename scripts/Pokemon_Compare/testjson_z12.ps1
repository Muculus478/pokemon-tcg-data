# Define folder paths
$jsonFolderPath = "C:\Users\Gunna\Documents\GitHub\pokemon-tcg-data\cards\en"
$csv2FolderPath = "C:\Users\Gunna\Documents\GitHub\pokemon-tcg-data\cards\csv2"

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
        # Flatten main properties
        $flattenedCard = [PSCustomObject]@{
            id                    = $card.id
            name                  = $card.name
            supertype             = $card.supertype
            hp                    = $card.hp
            types                 = ($card.types -join ", ")
            evolvesTo             = ($card.evolvesTo -join ", ")
            evolvesFrom           = $card.evolvesFrom
            number                = $card.number
            rarity                = $card.rarity
            retreatCost           = ($card.retreatCost -join ", ")
            convertedRetreatCost  = $card.convertedRetreatCost
        }

        # Flatten attacks
        if ($card.attacks) {
            $attackIndex = 0
            foreach ($attack in $card.attacks) {
                $attackIndex++
                $flattenedCard | Add-Member -NotePropertyName "Attack${attackIndex}Name" -NotePropertyValue $attack.name
                $flattenedCard | Add-Member -NotePropertyName "Attack${attackIndex}Cost" -NotePropertyValue ($attack.cost -join ", ")
                $flattenedCard | Add-Member -NotePropertyName "Attack${attackIndex}ConvertedCost" -NotePropertyValue $attack.convertedEnergyCost
                $flattenedCard | Add-Member -NotePropertyName "Attack${attackIndex}Damage" -NotePropertyValue $attack.damage
                $flattenedCard | Add-Member -NotePropertyName "Attack${attackIndex}Text" -NotePropertyValue $attack.text
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
    Write-Host "Exported $outputCsv"
}
