import os
import binascii
from PIL import Image
import subprocess

# Use fzf to select a file
file_path = subprocess.run(['fzf', '--preview', 'bat --color=always {}'], stdout=subprocess.PIPE).stdout.decode('utf-8').strip()

if not file_path or not os.path.exists(file_path):
    print("No file selected or file does not exist.")
    exit(1)

# Read the binary data from the selected file
with open(file_path, 'rb') as file:
    binary_data = file.read()

# Convert binary data to hex
hex_data = binascii.hexlify(binary_data).decode('ascii')

# Define image dimensions
width = 256  # You can adjust this width
height = (len(hex_data) // 2 + width - 1) // width  # Calculate height to fit all data

# Pad the hex data to fit the image dimensions
padded_hex_data = hex_data.ljust(width * height * 2, '0')

# Convert the hex data to binary
binary_image_data = binascii.unhexlify(padded_hex_data)

# Create the image
image = Image.frombytes('L', (width, height), binary_image_data)
image.save('encoded_image.png')

print(f"Image created and saved as encoded_image.png from file {file_path}")
