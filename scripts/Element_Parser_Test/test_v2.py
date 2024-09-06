import subprocess
import re

# Define the curl command
command = [
    'curl',
    '-H', 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3',
    'https://pokemoncard.io/deck/muddy-waters-sglc-semi-gym-leader-challenge-35660'
]

# Run the command
result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

# Check if curl command ran successfully
if result.returncode == 0:
    # Get the response content
    page_content = result.stdout

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

