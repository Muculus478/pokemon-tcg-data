import re
import beautifulsoup
# File paths
file_path = r"C:\Users\Gunna\Documents\GitHub\pokemon-tcg-data\scripts\Element_Parser_Test\MuddyWaters.txt"
output_path = r"C:\Users\Gunna\Documents\GitHub\pokemon-tcg-data\scripts\MuddyWatersData.yaml"

# Read the file content
with open(file_path, 'r') as file:
    file_content = file.readlines()

# Print original content
print("Original Content:")
for line in file_content:
    print(line, end='')

# Filter lines containing 'var maindeckjs'
filtered_content1 = [line for line in file_content if 'var maindeckjs' in line]

# Print filtered content
print("\nFiltered Content (lines containing 'var maindeckjs'):")
for line in filtered_content1:
    print(line, end='')

# Read the file content as raw text
with open(file_path, 'r') as file:
    file_content_raw = file.read()

# Find matches using the regex pattern
pattern = r'(?s)(?<=<form><textarea\b[^>]*>)(.*?)(?=</textarea></form>)'
matches = re.findall(pattern, file_content_raw)

# Print captured content
for match in matches:
    print("\nCaptured content:")
    print(match)

# Combine filtered content and matches
combined = "\n".join(filtered_content1 + matches)

# Write combined content to a new file
with open(output_path, 'w') as file:
    file.write(combined)
