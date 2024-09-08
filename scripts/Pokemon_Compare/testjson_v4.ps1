# Load necessary assembly for Windows Forms
Add-Type -AssemblyName System.Windows.Forms

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

# Create the Windows Form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Select Pokémon Subtype"
$form.Size = New-Object System.Drawing.Size(300,150)

# Create a label
$label = New-Object System.Windows.Forms.Label
$label.Text = "Choose a Subtype:"
$label.Location = New-Object System.Drawing.Point(20,20)
$form.Controls.Add($label)

# Create a ComboBox to display the subtypes
$comboBox = New-Object System.Windows.Forms.ComboBox
$comboBox.Location = New-Object System.Drawing.Point(120, 20)
$comboBox.Size = New-Object System.Drawing.Size(150,20)
$comboBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList

# Add subtypes to the ComboBox
foreach ($subtype in $subtypeCounts.Keys) {
    $comboBox.Items.Add($subtype)
}

$form.Controls.Add($comboBox)

# Create a button to show the count
$button = New-Object System.Windows.Forms.Button
$button.Text = "Show Count"
$button.Location = New-Object System.Drawing.Point(100, 80)

# Event handler for the button click
$button.Add_Click({
    $selectedSubtype = $comboBox.SelectedItem
    if ($selectedSubtype) {
        $count = $subtypeCounts[$selectedSubtype]
        [System.Windows.Forms.MessageBox]::Show("Count for '$selectedSubtype': $count", "Subtype Count")
    } else {
        [System.Windows.Forms.MessageBox]::Show("Please select a subtype.", "No Subtype Selected")
    }
})

$form.Controls.Add($button)

# Show the form
$form.Add_Shown({$form.Activate()})
[void]$form.ShowDialog()
