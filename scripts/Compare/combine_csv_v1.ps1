#Define the Paths
$smswshsvcsvs = 'C:\Users\Gunna\Documents\Personal\GitHub\pokemon-tcg-data\cards\csvfiltered'
$outputCsv = 'C:\Users\Gunna\Documents\Personal\GitHub\pokemon-tcg-data\cards\csvcombined\csvcombine.csv'

#Get all the csvs where it starts with s
$csvfiles = Get-ChildItem -Path $smswshsvcsvs -Filter 's*.csv'

#import and combine the CSV data
$combinedData = foreach ($file in $csvfiles) {
    Import-CSV -Path $file.FUllName
}

#Export combined data to the output file
$combinedData | Export-Csv -Path $outputCsv -NoTypeInformation -Force

Write-Output "COmbine CSV file create at: $outputCsv "