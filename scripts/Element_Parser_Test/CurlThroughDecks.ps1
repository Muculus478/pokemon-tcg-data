# Define the path to PowerShell 7 executable
$pwshPath = "$env:ProgramFiles\PowerShell\7\pwsh.exe"

# Define the URL to access
$url = "https://pokemoncard.io/deck/muddy-waters-sglc-semi-gym-leader-challenge-35660"

# Define the User-Agent string to mimic a browser
$userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3"

# Define the output file path
$outputFile = "HTMLCURL.txt"

# Define the PowerShell command to run
$command = @"
Invoke-WebRequest -Uri '$url' -Headers @{ 'User-Agent' = '$userAgent' } -UseBasicParsing | Out-File -FilePath '$outputFile'
"@

# Start PowerShell 7 and run the command
& $pwshPath -Command $command
