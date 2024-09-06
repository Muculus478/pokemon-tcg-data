import subprocess
import re
import yaml
import time

# Load the YAML file to get the URLs
with open('Deck_data_Manual.yml', 'r') as file:
    data = yaml.safe_load(file)
    urls = data.get('Decks', [])

for url in urls:
    print(f"Processing URL: {url}")

    # Define the curl command using the URL from the YAML file
    command = [
        'curl',
        '-H', 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3',
        url
    ]

    # Run the command
    result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

    # Check if curl command ran successfully
    if result.returncode == 0:
        # Get the response content
        page_content = result.stdout

        # Use regex to extract the contents within <title>
        title_match = re.search(r'<title>(.*?)- PokemonCard</title>', page_content, re.DOTALL)
        if title_match:
            title_data = title_match.group(1).strip()
            print("Extracted Title Data:")
            print(title_data)
        else:
            print("Couldn't find title data.")
        
        # Use regex to extract the contents within <textarea> under <form>
        textarea_match = re.search(r'<form>.*?<textarea.*?id="export0".*?>(.*?)</textarea>.*?</form>', page_content, re.DOTALL)
        if textarea_match:
            textarea_data = textarea_match.group(1).strip()
            print("Extracted Textarea Data:")
            print(textarea_data)
        else:
            print("Couldn't find textarea data.")
        
        # Use regex to extract the contents of var maindeckjs = '[...]'
        maindeckjs_match = re.search(r"var maindeckjs\s*=\s*'(\[.*?\])';", page_content)
        if maindeckjs_match:
            maindeckjs_data = maindeckjs_match.group(1)
            print("\nExtracted maindeckjs Data:")
            print(maindeckjs_data)
        else:
            print("Couldn't find 'maindeckjs' data.")
    else:
        print(f"Error: {result.stderr}")

    # Wait for 1 second before processing the next URL
    time.sleep(10)

    print("\n" + "-"*80 + "\n")
