# Helper function to remove accents
function Remove-Accents {
    param ([string]$input)
    if ($input) {
        # Normalize the string and remove diacritics
        $normalizedString = $input.Normalize([Text.NormalizationForm]::FormD)
        return -join ($normalizedString.ToCharArray() | Where-Object { -not [Char]::GetUnicodeCategory($_).Equals("NonSpacingMark") })
    }
    return $input
}

# Define the file path
$folderPath = "C:\Users\Gunna\Documents\GitHub\pokemon-tcg-data\cards\en"
$destPath = "C:\Users\Gunna\Documents\GitHub\pokemon-tcg-data\scripts\Pokemon_Compare"
$jsonFile = Join-Path $folderPath "sm3.json"

# Read the JSON content
$jsonData = Get-Content $jsonFile | ConvertFrom-Json

# Prepare an array to hold the CSV rows
$csvRows = @()

# Loop through each card in the JSON file
foreach ($card in $jsonData) {
    # Create a custom object for each card, removing accents from relevant fields
    $csvRow = [PSCustomObject]@{
        ID          = $card.id
        Name        = $card.name
        Supertype   = Remove-Accents $card.supertype
        Subtypes    = ($card.subtypes -join ", ")  # Join subtypes array into a comma-separated string
        HP          = $card.hp
        Types       = ($card.types -join ", ")     # Join types array into a comma-separated string
        #Attacks     = ($card.attacks | ForEach-Object { Remove-Accents ($_.type + " " + $_.value) }) -join "; "  # Join each attack's type and value
        RetreatCost = ($card.retreatCost -join ", ")  # Join retreatCost array into a comma-separated string
        Rarity      = $card.rarity
    }
    
    # Add the custom object to the rows array
    $csvRows += $csvRow
}

# Define the output CSV path
$csvFilePath = Join-Path $destPath "pokemon_cards_z2.csv"

# Export the data to a CSV file
$csvRows | Export-Csv -Path $csvFilePath -NoTypeInformation

Write-Host "CSV file created at: $csvFilePath"
