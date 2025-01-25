import pandas as pd

# Load the two files
comments_file = "Z3IR758iK7E_comments.csv"  # Output from comments.py
downloaded_file = "youtube_comments_normalized.csv"  # Output from download_comments.py

comments_df = pd.read_csv(comments_file)
downloaded_df = pd.read_csv(downloaded_file)

# Ensure column consistency: Add missing columns to the downloaded file
if "reply_count" not in downloaded_df.columns:
    downloaded_df["reply_count"] = None
if "published_at" not in downloaded_df.columns:
    downloaded_df["published_at"] = None

# Merge the files
# Priority to the comments file if (author, normalized_comment) matches
merged_df = pd.concat([comments_df, downloaded_df]).drop_duplicates(
    subset=["author", "normalized_comment"], keep="first"
)

# Save the merged file
merged_file = "merged_youtube_comments.csv"
merged_df.to_csv(merged_file, index=False, encoding="utf-8-sig")

print(f"Merged file saved as {merged_file}. Total comments: {len(merged_df)}")

