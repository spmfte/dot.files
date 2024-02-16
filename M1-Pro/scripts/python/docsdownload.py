import os
from urllib.parse import urlparse, urljoin
import requests
from bs4 import BeautifulSoup

base_url = "https://docs.modular.com/mojo/"
output_base_dir = os.path.expanduser("~/local.docs")

parsed_uri = urlparse(base_url)
domain = '{uri.scheme}://{uri.netloc}/'.format(uri=parsed_uri)
website_name = parsed_uri.netloc

output_dir = os.path.join(output_base_dir, website_name, parsed_uri.path.strip('/'))
os.makedirs(output_dir, exist_ok=True)

def save_text_from_url(url, output_path):
    try:
        response = requests.get(url)
        response.raise_for_status()  # Raise an error on bad status

        soup = BeautifulSoup(response.text, 'html.parser')
        text = soup.get_text(separator='\n', strip=True)

        with open(output_path, 'w', encoding='utf-8') as file:
            file.write(text)
        print(f"Saved text from {url} to {output_path}")
    except Exception as e:
        print(f"Error processing {url}: {e}")

def crawl_and_save(base_url, output_dir):
    # This is a very basic crawler and does not handle the discovery of new URLs.
    # You may need to implement URL discovery based on the website's structure.
    save_text_from_url(base_url, os.path.join(output_dir, "index.txt"))

# Start the script
crawl_and_save(base_url, output_dir)
