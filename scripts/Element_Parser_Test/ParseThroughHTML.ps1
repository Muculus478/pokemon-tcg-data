$filePath = "C:\Users\Gunna\Documents\GitHub\pokemon-tcg-data\scripts\Element_Parser_Test\MuddyWaters.txt"
$fileContent = Get-Content -Path $filePath
Write-Host "Original Content:"
Write-Host $fileContent
$filteredContent1 = $fileContent | Where-Object { $_ -match "var maindeckjs" }

$fileContentRaw = Get-Content -Path $filePath -Raw
$pattern = '(?s)(?<=<form><textarea\b[^>]*>)(.*?)(?=</textarea></form>)'
$matches = [regex]::Matches($fileContentRaw, $pattern)

foreach ($match in $matches) {
    Write-Host "Captured content:"
    Write-Host $match.Value
}

Write-Host "`nFiltered Content (lines containing 'var maindeckjs'):"
Write-Host $filteredContent1

$combined = "$filteredContent1
$matches"
$combined | Out-File -FilePath "C:\Users\Gunna\Documents\GitHub\pokemon-tcg-data\scripts\MuddyWatersData.yml"