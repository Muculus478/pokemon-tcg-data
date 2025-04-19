import subprocess
import re
import time
import os
import yaml
import json

# Load the YAML file to get the URLs
with open('Deck_Data_Manual.yml', 'r') as file:
    data = yaml.safe_load(file)
    urls = data.get('Decks', [])

# Create a text file with the .txt extension first
output_filename = 'Deck_Data_v94.txt'

with open(output_filename, 'w') as output_file:
    for url in urls:
        print(f"Processing URL: {url}")

        command = [
            'curl',
            '-H', 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3',
            url
        ]

        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

        if result.returncode == 0:
            page_content = result.stdout

            title_match = re.search(r'<title>(.*?) - PokemonCard</title>', page_content, re.DOTALL)
            title_data = title_match.group(1).strip() if title_match else "No title found"

            textarea_match = re.search(r'<form>.*?<textarea.*?id="export0".*?>(.*?)</textarea>.*?</form>', page_content, re.DOTALL)
            textarea_data = textarea_match.group(1).strip() if textarea_match else "No textarea found"

            textarea_data = textarea_data.replace("  -  ", ":")

            maindeckjs_match = re.search(r"var maindeckjs\s*=\s*'(\[.*?\])';", page_content)
            if maindeckjs_match:
                maindeckjs_raw = maindeckjs_match.group(1)
                maindeckjs_list = json.loads(maindeckjs_raw)
            else:
                maindeckjs_list = []

            output_file.write(f"URL: {url}\n")
            output_file.write(f"Deck_Name: {title_data}\n")
            output_file.write("Pokemon_List:\n")

            # Split and categorize entries
            lines = textarea_data.split("\n")
            current_category = None
            card_blocks = {'Pokemon': [], 'Trainer': [], 'Energy': []}
            for line in lines:
                line = line.strip()
                if line.startswith("Pokemon -"):
                    current_category = "Pokemon"
                    card_blocks[current_category].insert(0, line.replace(" -", ":"))
                elif line.startswith("Trainer -"):
                    current_category = "Trainer"
                    card_blocks[current_category].insert(0, line.replace(" -", ":"))
                elif line.startswith("Energy -"):
                    current_category = "Energy"
                    card_blocks[current_category].insert(0, line.replace(" -", ":"))
                elif current_category:
                    card_blocks[current_category].append(f"  - {line}")

            for category in ['Pokemon', 'Trainer', 'Energy']:
                for i, entry in enumerate(card_blocks[category]):
                    if i == 0:
                        output_file.write(f"{entry}\n")
                    else:
                        output_file.write(f"{entry}\n")

            output_file.write("Card_Photos:\n")
            for entry in maindeckjs_list:
                output_file.write(f"  - {entry}\n")

            output_file.write("#" * 40 + "\n")

            print(f"Deck_Name: {title_data}")
        else:
            print(f"Error: {result.stderr}")

        time.sleep(1)

# Rename the .txt file to .yml
new_filename = output_filename.replace('.txt', '.yml')
os.rename(output_filename, new_filename)
print(f"Data has been written to '{new_filename}'")
