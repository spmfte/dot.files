
import string
import random
import webbrowser

def generate_random_youtube_url():
    # Length of YouTube video IDs
    video_id_length = 11
    
    # Characters that can appear in YouTube video IDs
    characters = string.ascii_letters + string.digits + '-_'
    
    # Generate a random video ID
    random_video_id = ''.join(random.choice(characters) for _ in range(video_id_length))
    
    # Construct the YouTube URL
    youtube_url = f"https://www.youtube.com/watch?v={random_video_id}"
    
    return youtube_url

# Generate a random YouTube URL
random_youtube_url = generate_random_youtube_url()

# Specify Safari as the browser to use
browser = 'safari'

# Attempt to open the URL in Safari
webbrowser.get(browser).open(random_youtube_url)

print(f"Attempted to open: {random_youtube_url}")

