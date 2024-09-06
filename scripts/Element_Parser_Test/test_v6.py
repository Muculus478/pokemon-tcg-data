import subprocess
import re
import yaml
import time

# Load the YAML file to get the URLs
with open('Deck_data_Manual.yml', 'r') as file:
    data = yaml.safe_load(file)
    urls = data.get('Decks', [])

# Dictionary to store results
results = {}

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

        # Extract the <title> content
        title_match = re.search(r'<title>(.*?)</title>', page_content, re.DOTALL)
        title_data = title_match.group(1).strip() if title_match else "No title found"

        # Extract the <textarea> content
        textarea_match = re.search(r'<form>.*?<textarea.*?id="export0".*?>(.*?)</textarea>.*?</form>', page_content, re.DOTALL)
        textarea_data = textarea_match.group(1).strip() if textarea_match else "No textarea found"

        # Extract the var maindeckjs content
        maindeckjs_match = re.search(r"var maindeckjs\s*=\s*'(\[.*?\])';", page_content)
        maindeckjs_data = maindeckjs_match.group(1) if maindeckjs_match else "No maindeckjs data found"

        # Store results in the dictionary for this URL
        results[url] = {
            'title': title_data,
            'textarea': textarea_data,
            'maindeckjs': maindeckjs_data
        }
    else:
        print(f"Error: {result.stderr}")

    # Wait for 1 second before processing the next URL
    time.sleep(3)

# Write the results to a new YAML file
with open('Deck_extracted_data.yml', 'w') as output_file:
    yaml.dump(results, output_file, default_flow_style=False)

print("Data has been written to 'Deck_extracted_data.yml'")
