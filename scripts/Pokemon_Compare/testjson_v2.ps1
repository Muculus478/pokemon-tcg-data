# Define the folder path and the list of JSON file names
$folderPath = "C:\Users\Gunna\Documents\GitHub\pokemon-tcg-data\cards\en"
$jsonFiles = @(
    'swshp.json', 'sm1.json', 'sm2.json', 'sm3.json', 'sm4.json', 'sm5.json', 
    'sm6.json', 'sm7.json', 'sm8.json', 'sm9.json', 'sm10.json', 'sm11.json', 
    'sm12.json', 'sm35.json', 'sm75.json', 'sm115.json', 'sma.json', 'smp.json', 
    'sv1.json', 'sv2.json', 'sv3.json', 'sv3pt5.json', 'sv4.json', 'sv4pt5.json', 
    'sv5.json', 'sv6.json', 'sv6pt5.json', 'sve.json', 'svp.json', 'swsh1.json', 
    'swsh2.json', 'swsh3.json', 'swsh4.json', 'swsh5.json', 'swsh6.json', 'swsh7.json', 
    'swsh8.json', 'swsh9.json', 'swsh9tg.json', 'swsh10.json', 'swsh10tg.json', 
    'swsh11.json', 'swsh11tg.json', 'swsh12.json', 'swsh12pt5.json', 'swsh12pt5gg.json', 
    'swsh12tg.json', 'swsh35.json', 'swsh45.json', 'swsh45sv.json'
)

# Initialize a hashtable to store counts of each subtype
$subtypeCounts = @{}

# Loop through each JSON file
foreach ($file in $jsonFiles) {
    # Construct the full file path
    $filePath = Join-Path -Path $folderPath -ChildPath $file

    # Check if the file exists
    if (Test-Path $filePath) {
        # Read and convert the JSON data
        $jsonData = Get-Content -Path $filePath -Raw | ConvertFrom-Json

        # Iterate over each card in the JSON data
        foreach ($card in $jsonData) {
            foreach ($subtype in $card.subtypes) {
                # Increment the count for the subtype
                if ($subtypeCounts.ContainsKey($subtype)) {
                    $subtypeCounts[$subtype]++
                } else {
                    $subtypeCounts[$subtype] = 1
                }
            }
        }
    } else {
        Write-Host "File not found: $filePath"
    }
}

# Output the total counts for each subtype
foreach ($subtype in $subtypeCounts.Keys) {
    Write-Host "${subtype}: $(${subtypeCounts[$subtype]})"

}
