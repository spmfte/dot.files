import sys
from PIL import Image

def resize_image(input_path, output_path, size):
    """
    Resize an image to the given size and save it to the output path.

    :param input_path: Path to the input image file.
    :param output_path: Path where the resized image will be saved.
    :param size: Tuple of (width, height) for the new size.
    """
    # Open the image
    with Image.open(input_path) as img:
        # Resize the image
        resized_img = img.resize(size, Image.Resampling.LANCZOS)
        
        # Save the resized image
        resized_img.save(output_path)
        print(f"Image saved to {output_path}")

def main(image_path):
    """
    Main function to resize an image to 512x512 and 192x192.

    :param image_path: Path to the original image file.
    """
    file_path = Image.open(image_path)
    directory = file_path.fp.name.rsplit('/', 1)[0]
    file_name = file_path.fp.name.rsplit('/', 1)[-1]

    # Define the sizes for the two versions
    sizes = [(512, 512), (192, 192)]

    # Resize and save the image in two different sizes
    for size in sizes:
        output_path = f"{directory}/{file_name.rsplit('.', 1)[0]}_{size[0]}x{size[1]}.png"
        resize_image(image_path, output_path, size)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python resize_logo.py path/to/image.png")
        sys.exit(1)
    main(sys.argv[1])
