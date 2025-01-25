from fuzzywuzzy import fuzz, process
import pandas as pd

# Load the deduplicated file
deduplicated_file = "fully_deduplicated_youtube_comments.csv"
deduplicated_df = pd.read_csv(deduplicated_file)

# Function to find near-duplicates based on similarity
def find_near_duplicates(data, threshold=90):
    potential_duplicates = []
    comments = data["normalized_comment"].tolist()
    for i in range(len(comments)):
        for j in range(i + 1, len(comments)):
            similarity = fuzz.ratio(comments[i], comments[j])
            if similarity >= threshold:
                potential_duplicates.append((i, j, similarity))
    return potential_duplicates

# Find near-duplicates
near_duplicates = find_near_duplicates(deduplicated_df)

# Extract and save near-duplicate pairs for manual review
review_pairs = []
for idx1, idx2, score in near_duplicates:
    review_pairs.append({
        "comment_1": deduplicated_df.iloc[idx1].to_dict(),
        "comment_2": deduplicated_df.iloc[idx2].to_dict(),
        "similarity": score
    })

# Convert to DataFrame for saving
review_df = pd.DataFrame(review_pairs)
review_df.to_csv("near_duplicates_review.csv", index=False, encoding="utf-8-sig")

print(f"Near-duplicate pairs saved for review in 'near_duplicates_review.csv'. Total flagged pairs: {len(review_df)}")

