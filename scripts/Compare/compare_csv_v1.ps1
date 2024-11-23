# Input and Output File Paths
$inputFile = "C:\Users\Gunna\Documents\GitHub\pokemon-tcg-data\cards\csvfiltered\csvcombined\csvcombine.csv"
$outputFile = "C:\Users\Gunna\Documents\GitHub\pokemon-tcg-data\cards\csvfiltered\csvcombined\csvcompare.csv"

# Read the input CSV
$data = Import-Csv -Path $inputFile

# Initialize an array to store the transformed data
$transformedData = @()

# Process each row
foreach ($row in $data) {
    # Process Attack 1 if it exists
    if ($row.Attack1Name -ne "") {
        $transformedData += [PSCustomObject]@{
            id                       = $row.id
            name                     = $row.name
            supertype                = $row.supertype
            hp                       = $row.hp
            types                    = $row.types
            rarity                   = $row.rarity
            retreatCost              = $row.retreatCost
            convertedRetreatCost     = $row.convertedRetreatCost
            AbilityName              = $row.AbilityName
            AbilityText              = $row.AbilityText
            Attack1Name              = $row.Attack1Name
            Attack1Cost              = $row.Attack1Cost
            Attack1ConvertedCost     = $row.Attack1ConvertedCost
            Attack1Damage            = $row.Attack1Damage
            Attack1Text              = $row.Attack1Text
            DamageFormula            = $row.Empty
        }
    }

    # Process Attack 2 if it exists
    if ($row.Attack2Name -ne "") {
        $transformedData += [PSCustomObject]@{
            id                       = $row.id
            name                     = $row.name
            supertype                = $row.supertype
            hp                       = $row.hp
            types                    = $row.types
            rarity                   = $row.rarity
            retreatCost              = $row.retreatCost
            convertedRetreatCost     = $row.convertedRetreatCost
            AbilityName              = $row.AbilityName
            AbilityText              = $row.AbilityText
            Attack1Name              = $row.Attack2Name
            Attack1Cost              = $row.Attack2Cost
            Attack1ConvertedCost     = $row.Attack2ConvertedCost
            Attack1Damage            = $row.Attack2Damage
            Attack1Text              = $row.Attack2Text
            DamageFormula            = $row.Empty
        }
    }
}

# Export the transformed data to the output CSV
$transformedData | Export-Csv -Path $outputFile -NoTypeInformation

Write-Host "Transformation complete! Output saved to $outputFile"
