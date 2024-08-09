$filePath = "C:\Users\Gunna\Documents\GitHub\pokemon-tcg-data\scripts\MuddyWaters.txt"
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

$outputFilePath = "C:\Users\Gunna\Documents\GitHub\pokemon-tcg-data\scripts\output.txt"
Clear-Content -Path $outputFilePath -ErrorAction SilentlyContinue
foreach ($match in $matches) {
    $match.Value | Out-File -FilePath $outputFilePath -Append
}
Write-Host "Captured content"