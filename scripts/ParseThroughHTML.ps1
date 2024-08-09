$filePath = "C:\Users\Gunna\Documents\GitHub\pokemon-tcg-data\scripts\MuddyWaters.txt"
$fileContent = Get-Content -Path $filePath
Write-Host "Original Content:"
Write-Host $fileContent
$filteredContent = $fileContent | Where-Object { $_ -match "var maindeckjs" }
Write-Host "`nFiltered Content (lines containing 'var maindeckjs'):"
Write-Host $filteredContent
