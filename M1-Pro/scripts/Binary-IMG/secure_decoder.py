import os
import binascii
from PIL import Image
import subprocess
from cryptography.fernet import Fernet

# Save to same directory
save_dir = os.path.dirname(os.path.realpath(__file__))
# Use fzf to select an image file
image_path = subprocess.run(['fzf', '--preview', 'bat --color=always {}'], stdout=subprocess.PIPE).stdout.decode('utf-8').strip()

if not image_path or not os.path.exists(image_path):
    print("No image file selected or file does not exist.")
    exit(1)

# Load the encryption key
key_path = subprocess.run(['fzf', '--prompt', 'Select encryption key file:'], stdout=subprocess.PIPE).stdout.decode('utf-8').strip()
if not key_path or not os.path.exists(key_path):
    print("No key file selected or file does not exist.")
    exit(1)

with open(key_path, 'rb') as key_file:
    key = key_file.read()

cipher_suite = Fernet(key)

# Read the image file
image = Image.open(image_path)
binary_image_data = image.tobytes()

# Convert the binary image data to hex
hex_data = binascii.hexlify(binary_image_data).decode('ascii')

# Remove padding if present
hex_data = hex_data.rstrip('0')

# Convert the hex data back to encrypted binary data
encrypted_data = binascii.unhexlify(hex_data)

# Decrypt the binary data
binary_data = cipher_suite.decrypt(encrypted_data)

if not save_dir or not os.path.isdir(save_dir):
    print("No directory selected or directory does not exist.")
    exit(1)

# Prompt the user to enter the filename
file_name = input("Enter the name of the file to save the decoded data (include the extension): ")

# Save the decoded data to the specified file
decoded_file_path = os.path.join(save_dir, file_name)
with open(decoded_file_path, 'wb') as decoded_file:
    decoded_file.write(binary_data)

print(f"File decoded and saved as {decoded_file_path} from image {image_path}")

