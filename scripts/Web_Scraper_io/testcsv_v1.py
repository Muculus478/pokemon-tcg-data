import yaml
import csv

# Load YML file
yml_file = 'Deck_data_Manual.yml'  # Update with the actual path to your YML file

with open(yml_file, 'r') as file:
    data = yaml.safe_load(file)

# Extract the Pokemon list
pokemon_list = data.get('Pokemon_List', '').split('\n')[1:]  # Skip the "Pokemon - 17" line

# Write to CSV file
csv_file = 'pokemon_list.csv'
with open(csv_file, 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['Pokemon'])  # Header
    for pokemon in pokemon_list:
        writer.writerow([pokemon])

print(f'Pokemon list has been written to {csv_file}')
