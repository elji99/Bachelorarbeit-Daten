import pandas as pd
from googleapiclient.discovery import build

# Your API Key
api_key = "AIzaSyCIuDxG0v0oFR0uSQvNSmQrKhncxRwUN20"
youtube = build('youtube', 'v3', developerKey=api_key)

# Video ID of the video you want to extract comments from
video_id = "Z3IR758iK7E"

# Function to normalize text
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

# Function to retrieve comments
def get_comments(youtube, video_id):
    comments = []
    request = youtube.commentThreads().list(
        part="snippet,replies",
        videoId=video_id,
        textFormat="plainText",
        maxResults=100
    )
    
    while request:
        response = request.execute()
        for item in response['items']:
            comment = item['snippet']['topLevelComment']['snippet']
            # Original and normalized text
            comment_text = comment['textDisplay'].encode('utf-8').decode('utf-8')
            normalized_text = normalize_text(comment_text)
            comments.append({
                'author': comment['authorDisplayName'],
                'comment': comment_text,
                'normalized_comment': normalized_text,
                'likes': comment['likeCount'],
                'published_at': comment['publishedAt'],
                'reply_count': item['snippet']['totalReplyCount']
            })
            
            # Process replies
            if item['snippet']['totalReplyCount'] > 0:
                for reply in item['replies']['comments']:
                    reply_snippet = reply['snippet']
                    reply_text = reply_snippet['textDisplay'].encode('utf-8').decode('utf-8')
                    normalized_reply_text = normalize_text(reply_text)
                    comments.append({
                        'author': reply_snippet['authorDisplayName'],
                        'comment': reply_text,
                        'normalized_comment': normalized_reply_text,
                        'likes': reply_snippet['likeCount'],
                        'published_at': reply_snippet['publishedAt'],
                        'reply_count': 0
                    })

        # Handle pagination
        if 'nextPageToken' in response:
            request = youtube.commentThreads().list(
                part="snippet,replies",
                videoId=video_id,
                pageToken=response['nextPageToken'],
                textFormat="plainText",
                maxResults=100
            )
        else:
            break
    
    return comments

# Retrieve comments and save to CSV with utf-8-sig encoding
comment_data = get_comments(youtube, video_id)
df = pd.DataFrame(comment_data)
df.to_csv(f"{video_id}_comments.csv", index=False, encoding='utf-8-sig')
print("Comments have been successfully downloaded and saved.")
