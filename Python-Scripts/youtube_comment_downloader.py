from youtube_comment_downloader import YoutubeCommentDownloader
import pandas as pd

# Video-ID festlegen
video_id = "Z3IR758iK7E"

# Funktion zur Normalisierung von Kommentaren
def normalize_text(text):
    # Convert to lowercase
    text = text.lower()
    # Remove extra spaces
    text = " ".join(text.split())
    # Replace @@username with @username
    text = text.replace("@@", "@")
    # Encode and decode to handle special characters
    text = text.encode('utf-8').decode('utf-8')
    return text

# Initialisiere den Downloader
downloader = YoutubeCommentDownloader()

# Kommentardaten abrufen
comments = downloader.get_comments_from_url(f"https://www.youtube.com/watch?v={video_id}")

# Kommentare in eine Liste laden
comment_data = []
for comment in comments:
    original_text = comment['text']
    normalized_text = normalize_text(original_text)
    comment_data.append({
        'author': comment['author'],
        'comment': original_text,
        'normalized_comment': normalized_text,
        'likes': comment['votes'],
        'time': comment['time']  # Retain relative time as exact timestamps are unavailable
    })

# Kommentare in ein DataFrame umwandeln und als CSV speichern
df = pd.DataFrame(comment_data)
df.to_csv('youtube_comments_normalized.csv', index=False, encoding='utf-8-sig')
print("Kommentare erfolgreich heruntergeladen und gespeichert.")

