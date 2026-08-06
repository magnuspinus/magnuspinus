#!/bin/bash

# Define co-authors' names and emails
COAUTHOR_1_NAME="Alexandr"
COAUTHOR_1_EMAIL="alexandr54213@gmail.com"

COAUTHOR_2_NAME="Magnus Pinus"
COAUTHOR_2_EMAIL="magnuspinus969@gmail.com"

COAUTHOR_3_NAME="v-c-nguyen"
COAUTHOR_3_EMAIL="veri.lume113@gmail.com"

# Loop to create and merge pull requests 10 times
for i in {1..3}
do
    # Make a change in the dev branch
    echo "NEW_ENV_VARIABLE_$i='value'" >> .envexample

    # Add changes to git
    git add .envexample

    # Calculate commit date: 3 days apart
    DAYS_AGO=$((i * 3))
    COMMIT_DATE=$(date -d "$DAYS_AGO days ago" +"%Y-%m-%dT%H:%M:%S")

    # Commit with multiple co-authors and custom date
    GIT_COMMITTER_DATE="$COMMIT_DATE" GIT_AUTHOR_DATE="$COMMIT_DATE" git commit -F - <<EOF
Update .envexample for change #$i.

Co-authored-by: $COAUTHOR_1_NAME <$COAUTHOR_1_EMAIL>
Co-authored-by: $COAUTHOR_2_NAME <$COAUTHOR_2_EMAIL>
Co-authored-by: $COAUTHOR_3_NAME <$COAUTHOR_3_EMAIL>
EOF

    # Push changes to the dev branch
    git push origin dev

    # Create a pull request from dev to main using GitHub CLI
    pr_number=$(gh pr create --base main --head dev --title "Merge dev to main for change #$i" --body "Merging changes from dev to main for change #$i.")

    echo "Created pull request #$pr_number"

    # Merge the pull request
    gh pr merge $pr_number --merge
    echo "Merged pull request #$pr_number"

    # Optional short sleep to avoid timing issues
    sleep_duration=$((RANDOM % 3 + 1))
    echo "Sleeping for $sleep_duration seconds..."
    sleep $sleep_duration
done
