# Define the file paths, Read the JSON, and prepare the array for the CSV rows
$folderPath = "C:\Users\Gunna\Documents\GitHub\pokemon-tcg-data\cards\en"
$destPath = "C:\Users\Gunna\Documents\GitHub\pokemon-tcg-data\scripts\Pokemon_Compare"
$jsonFile = Join-Path $folderPath "sm3.json"
$jsonData = Get-Content $jsonFile | ConvertFrom-Json
$csvRows = @()

# Define the rarities you want to include
$includedRarities = @('Common', 'Uncommon', 'Rare', 'Rare Holo', 'Promo')

foreach ($card in $jsonData) {
    # Only include cards with the defined rarities
    if ($card.rarity -ne $null -and $includedRarities -contains $card.rarity) {
        $csvRow = [PSCustomObject]@{
            ID          = $card.id
            Name        = $card.name
            Supertype   = $card.supertype
            Subtypes    = ($card.subtypes -join ", ")
            HP          = $card.hp
            Types       = ($card.types -join ", ")
            RetreatCost = ($card.retreatCost -join ", ")
            Rarity      = $card.rarity
        }
        $csvRows += $csvRow
    }
}

# Define the output CSV path and export the data to a CSV
$csvFilePath = Join-Path $destPath "pokemon_cards_z6.csv"
$csvRows | Export-Csv -Path $csvFilePath -NoTypeInformation
Write-Host "CSV file created at: $csvFilePath"

# Updates to the CSV for cleanup. Update the CSV by replacing all "é" with "e"
(Get-Content $csvFilePath) -replace 'é', 'e' | Set-Content $csvFilePath
Write-Host "CSV file updated to replace accented 'e' with regular 'e'"
