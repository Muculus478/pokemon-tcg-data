import subprocess
from bs4 import BeautifulSoup

# Define the curl command
curl_command = [
    "curl",
    "-H", "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3",
    "https://pokemoncard.io/deck/muddy-waters-sglc-semi-gym-leader-challenge-35660"
]

# Run the curl command to fetch HTML data
try:
    result = subprocess.run(curl_command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, check=True)
    html_data = result.stdout
except subprocess.CalledProcessError as e:
    print(f"Error executing curl command: {e}")
    html_data = None

# Parse the HTML data with BeautifulSoup
if html_data:
    soup = BeautifulSoup(html_data, 'html.parser')

    # Example of extracting title or other elements
    title = soup.title.string if soup.title else "No title found"
    print(f"Page Title: {title}")

    # Find and print any other desired elements
    # Example: Extracting all links (a tags)
    for link in soup.find_all('a'):
        print(f"Link: {link.get('href')}")

else:
    print("Failed to retrieve HTML data.")