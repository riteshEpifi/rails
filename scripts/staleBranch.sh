#!/bin/bash

# Set the path to your Git repository
repo_path="."
# Change to the repository directory
cd "$repo_path" || exit 1
# Get the current date in Unix timestamp format
current_date=$(date +%s)

# Convert 3 months to seconds (assuming 30 days per month)
three_months=$((60*60*24*30*12))

# Change to the repository directory
#cd "$repo_path" || exit 1

# Fetch all remote branches
#git fetch --prune
git fetch

# CSV file to store the branch details
csv_file="branch_details.csv"

# Create or truncate the CSV file
echo "Author,Branch,Last Commit Date" > "$csv_file"

# Get the list of remote branches
remote_branches=$(git branch -r| grep -v HEAD)

# Loop through all branches
for branch in $remote_branches; do
  # Check if the branch name contains the substring "stable"
  if [[ "$branch" == *"stable"* ]]; then
    continue
  fi

  # Get the last commit date and author of the branch
  commit_date=$(git show --no-patch --format=%ct "$branch")
  author=$(git show --no-patch --format=%an "$branch")

  # Calculate the age of the branch in seconds
  age=$((current_date - commit_date))

  # Compare the branch age to three months
  if [ "$age" -ge "$three_months" ]; then
    # Convert the last commit date to a readable format
    last_commit_date=$(date -r $commit_date)

    # Append the branch details to the CSV file
    echo "$author,$branch,$last_commit_date,$commit_date,$age"
  fi
done | sort -k 1 >> "$csv_file"

echo "Branch details have been saved to $csv_file."
#comments

if [ -f "$csv_file" ]; then
  echo "File exists: $repo_path =>  $csv_file"
  ls "../scripts"
else
  echo "File does not exist: path/to/your/file.csv"
fi
