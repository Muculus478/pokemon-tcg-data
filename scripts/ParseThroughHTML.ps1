$filePath = "C:\Users\Gunna\Documents\GitHub\pokemon-tcg-data\scripts\MuddyWaters.txt"
$fileContent = Get-Content -Path $filePath
Write-Host "Original Content:"
Write-Host $fileContent
$filteredContent1 = $fileContent | Where-Object { $_ -match "var maindeckjs" }
$filteredContent2 = $fileContent | Where-Object { $_ -match "var maindeckcount" }
Write-Host "`nFiltered Content (lines containing 'var maindeckjs'):"
Write-Host "`nFiltered Content (lines containing 'var maindeckcount'):"
Write-Host $filteredContent1
Write-Host $filteredContent2
