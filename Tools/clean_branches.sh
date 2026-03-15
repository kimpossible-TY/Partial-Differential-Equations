#!/bin/bash

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
# Get all local branches starting with nightwatch/
BRANCHES=$(git for-each-ref --format='%(refname:short)' refs/heads/nightwatch/)

if [ -z "$BRANCHES" ]; then
    echo "No 'nightwatch/*' branches found."
    exit 0
fi

echo "The following branches will be deleted:"
TO_DELETE=""
for branch in $BRANCHES; do
    if [ "$branch" != "$CURRENT_BRANCH" ]; then
        echo "  - $branch"
        TO_DELETE="$TO_DELETE $branch"
    fi
done

if [ -z "$TO_DELETE" ]; then
    echo "No eligible branches to delete (current branch is excluded)."
    exit 0
fi

echo ""
read -p "Are you sure you want to force delete these branches? (y/n) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    for branch in $TO_DELETE; do
        git branch -D "$branch"
    done
    echo "Branches deleted."
else
    echo "Aborted."
fi
