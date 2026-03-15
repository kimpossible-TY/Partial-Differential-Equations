#!/bin/bash

# Find all local nightwatch branches (excluding the currently checked out one)
BRANCHES_TO_DELETE=$(git branch | grep 'nightwatch/' | grep -v '^*' | sed 's/^[[:space:]]*//')

if [ -z "$BRANCHES_TO_DELETE" ]; then
    echo "No local 'nightwatch/*' branches found to delete."
    exit 0
fi

echo "The following branches will be deleted:"
echo "$BRANCHES_TO_DELETE"
echo ""

read -p "Are you sure you want to delete these branches? [y/N]: " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "Operation cancelled."
    exit 0
fi

echo "Deleting branches..."
for branch in $BRANCHES_TO_DELETE; do
    git branch -D "$branch"
done

echo "Cleanup complete!"
