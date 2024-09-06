import subprocess

# Define the curl command
command = [
    'curl',
    '-H', 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3',
    'https://pokemoncard.io/deck/muddy-waters-sglc-semi-gym-leader-challenge-35660'
]

# Run the command
result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

# Output the result
if result.returncode == 0:
    print(result.stdout)  # Print the response from the server
else:
    print(f"Error: {result.stderr}")
