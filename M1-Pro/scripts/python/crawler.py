import requests
from urllib.parse import urlparse, urljoin
from bs4 import BeautifulSoup
import re

class WebsiteTreeCrawler:
    def __init__(self, base_url):
        self.base_url = base_url
        self.domain_name = urlparse(self.base_url).netloc
        self.visited = set()

    def get_absolute_url(self, url):
        return urljoin(self.base_url, url)

    def is_valid_url(self, url):
        parsed = urlparse(url)
        # Check if the link is within the same domain and is not visited
        return bool(parsed.netloc) and parsed.netloc == self.domain_name and url not in self.visited

    def get_links(self, url):
        urls = set()
        try:
            response = requests.get(url)
            response.raise_for_status()  # ensure we raise an exception for bad responses
            soup = BeautifulSoup(response.text, 'html.parser')
            for link in soup.find_all('a', href=True):
                href = link['href']
                if not href.startswith('mailto:') and not href.startswith('javascript:'):
                    full_url = self.get_absolute_url(href)
                    if self.is_valid_url(full_url):
                        urls.add(full_url)
        except requests.RequestException as e:
            print(f"Request failed for {url}: {e}")
        return urls

    def crawl(self, url):
        self.visited.add(url)
        print(url)
        for link in self.get_links(url):
            if link not in self.visited:
                self.crawl(link)

    def start_crawling(self):
        self.crawl(self.base_url)

# Replace 'https://docs.modular.com/mojo/' with your target website
crawler = WebsiteTreeCrawler('https://docs.modular.com/mojo/')
crawler.start_crawling()
