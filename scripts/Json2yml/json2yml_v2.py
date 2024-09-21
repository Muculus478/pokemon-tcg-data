import json
import yaml
import os
import glob

# Function to convert JSON to YAML
def convert_json_to_yaml(json_file, yaml_file):
    with open(json_file, 'r', encoding='utf-8') as file:
        json_data = json.load(file)
    
    with open(yaml_file, 'w', encoding='utf-8') as file:
        yaml.dump(json_data, file, allow_unicode=True, sort_keys=False)

# Set the source directory for JSON files and the destination directory for YAML files
json_dir = r'C:\Users\Gunna\Documents\GitHub\pokemon-tcg-data\cards\en'
yaml_dir = r'C:\Users\Gunna\Documents\GitHub\pokemon-tcg-data\cards\yml'

# Ensure the YAML directory exists, create if not
os.makedirs(yaml_dir, exist_ok=True)

# Find all JSON files in the source directory
json_files = glob.glob(os.path.join(json_dir, '*.json'))

# Iterate through each JSON file
for json_file_path in json_files:
    # Get the base filename (without the extension) and create the corresponding YAML file path
    base_name = os.path.basename(json_file_path).replace('.json', '.yml')
    yaml_file_path = os.path.join(yaml_dir, base_name)
    
    # Convert the JSON to YAML
    convert_json_to_yaml(json_file_path, yaml_file_path)
    print(f"Converted {json_file_path} to {yaml_file_path}")

print("All JSON files have been converted to YAML.")
