import json
import yaml

# Function to convert JSON to YAML
def convert_json_to_yaml(json_file, yaml_file):
    with open(json_file, 'r', encoding='utf-8') as file:
        json_data = json.load(file)
    
    with open(yaml_file, 'w', encoding='utf-8') as file:
        yaml.dump(json_data, file, allow_unicode=True, sort_keys=False)

# Specify the input JSON file and the output YAML file
json_file_path = r'C:\Users\Gunna\Documents\GitHub\pokemon-tcg-data\cards\en\sm3.json'
yaml_file_path = r'C:\Users\Gunna\Documents\GitHub\pokemon-tcg-data\cards\yml\sm3.yml' 

# Convert the JSON to YAML
convert_json_to_yaml(json_file_path, yaml_file_path)

print(f"Conversion from {json_file_path} to {yaml_file_path} is complete.")
