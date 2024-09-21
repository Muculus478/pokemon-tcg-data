import subprocess
import re
import time
import os
import yaml
import json

# Load the YAML file to get the URLs
with open('Deck_Data_Manual_v91.yml', 'r') as file:
    data = yaml.safe_load(file)
    urls = data.get('Decks', [])

# Create a text file with the .txt extension first
output_filename = 'Deck_Data_v91.txt'

with open(output_filename, 'w') as output_file:
    for url in urls:
        print(f"Processing URL: {url}")

        # Define the curl command using the URL from the YAML file
        command = [
            'curl',
            '-H', 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3',
            url
        ]

        # Run the command with the curl and all the variables
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

        # Check if curl command ran successfully
        if result.returncode == 0:
            # Get the response content
            page_content = result.stdout

            # Extract the <title> content
            title_match = re.search(r'<title>(.*?) - PokemonCard</title>', page_content, re.DOTALL)
            title_data = title_match.group(1).strip() if title_match else "No title found"

            # Extract the <textarea> content
            textarea_match = re.search(r'<form>.*?<textarea.*?id="export0".*?>(.*?)</textarea>.*?</form>', page_content, re.DOTALL)
            textarea_data = textarea_match.group(1).strip() if textarea_match else "No textarea found"

            # Extract the var maindeckjs content and format it to display each entry on a new line
            maindeckjs_match = re.search(r"var maindeckjs\s*=\s*'(\[.*?\])';", page_content)
            if maindeckjs_match:
                maindeckjs_raw = maindeckjs_match.group(1)
                # Convert the maindeckjs string to a list
                maindeckjs_list = json.loads(maindeckjs_raw)
                # Format each entry with indentation
                maindeckjs_data = "\n  ".join(maindeckjs_list)
            else:
                maindeckjs_data = "No maindeckjs data found"

            # Write the results to the txt file with indented format
            output_file.write(f"URL: {url}\n")
            output_file.write(f"Deck_Name: {title_data}\n")
            
            # Split Pokemon_List by category (Pokemon, Trainer, Energy)
            lines = textarea_data.split("\n")
            output_file.write("Pokemon_List:\n")
            
            pokemon_category = True
            for line in lines:
                if "Trainer" in line or "Energy" in line:
                    pokemon_category = False
                indent = "  " if pokemon_category else "    "
                output_file.write(f"{indent}{line}\n")
            
            output_file.write(f"Card_Photos:\n  {maindeckjs_data}\n")
            output_file.write("#" * 40 + "\n")

            # Print the results to the console for verification
            print(f"Deck_Name: {title_data}")
            print(f"Pokemon_List: {textarea_data}")
            print(f"Card_Photos:\n{maindeckjs_data}")
        else:
            print(f"Error: {result.stderr}")
        time.sleep(1)

# Rename the .txt file to .yml and print
new_filename = output_filename.replace('.txt', '.yml')
os.rename(output_filename, new_filename)
print(f"Data has been written to '{new_filename}'")
