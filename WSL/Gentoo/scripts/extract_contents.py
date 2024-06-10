import os
import json

def extract_directory_contents_to_json(directory_path, output_json_path):
    # Expand the user path if it starts with ~
    directory_path = os.path.expanduser(directory_path)
    output_json_path = os.path.expanduser(output_json_path)

    files_data = []

    # Walk through the directory
    for root, dirs, files in os.walk(directory_path):
        for file_name in files:
            file_path = os.path.join(root, file_name)
            try:
                with open(file_path, 'r', encoding='utf-8') as file:
                    content = file.read()
            except Exception as e:
                content = f"Error reading file: {e}"

            file_info = {
                'path': file_path,
                'content': content
            }
            files_data.append(file_info)

    # Write to JSON output
    with open(output_json_path, 'w', encoding='utf-8') as json_file:
        json.dump(files_data, json_file, indent=4, ensure_ascii=False)

if __name__ == "__main__":
    directory_path = input("Enter the directory path: ")
    output_json_path = input("Enter the output JSON file path: ")
    extract_directory_contents_to_json(directory_path, output_json_path)
    print(f"Data has been extracted to {output_json_path}")

