# Define the folder paths for JSON input and CSV output
$jsonFolderPath = "C:\Users\Gunna\Documents\GitHub\pokemon-tcg-data\cards\en"
$csvFolderPath = "C:\Users\Gunna\Documents\GitHub\pokemon-tcg-data\cards\csv"

# Get all JSON files in the input folder
$jsonFiles = Get-ChildItem -Path $jsonFolderPath -Filter *.json

# Define the rarities you want to include
$includedRarities = @('Common', 'Uncommon', 'Rare', 'Rare Holo', 'Promo')

# Loop through each JSON file
foreach ($jsonFile in $jsonFiles) {
    # Read the JSON file content
    $jsonData = Get-Content $jsonFile.FullName | ConvertFrom-Json
    $csvRows = @()

    # Process each card in the JSON file
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
                RetreatCost = ($card.convertedRetreatCost -join ", ")
                Rarity      = $card.rarity
            }
            $csvRows += $csvRow
        }
    }

    # Define the CSV file path for each JSON file
    $csvFileName = [System.IO.Path]::GetFileNameWithoutExtension($jsonFile.Name) + ".csv"
    $csvFilePath = Join-Path $csvFolderPath $csvFileName

    # Export the processed data to a CSV file
    $csvRows | Export-Csv -Path $csvFilePath -NoTypeInformation
    Write-Host "CSV file created for $($jsonFile.Name) at: $csvFilePath"

    # Update the CSV by replacing all "é" with "e"
    (Get-Content $csvFilePath) -replace 'é', 'e' | Set-Content $csvFilePath
}

Write-Host "All JSON files have been processed and CSVs created."
