#!/bin/bash

set -e

SOURCE_BRANCH=$1
TARGET_BRANCH=$2

echo "🔄 Fetching branches..."
git fetch origin $SOURCE_BRANCH
git fetch origin $TARGET_BRANCH

echo "🚀 Checking out target branch: $TARGET_BRANCH"
git checkout $TARGET_BRANCH

echo "🔍 Looking for the next unmerged commit from $SOURCE_BRANCH..."
NEXT_COMMIT=$(git log origin/$SOURCE_BRANCH --not $TARGET_BRANCH --reverse --pretty=format:"%H" | head -n 1)

if [ -z "$NEXT_COMMIT" ]; then
  echo "✅ All commits from $SOURCE_BRANCH are merged into $TARGET_BRANCH."
  exit 0
fi

echo "🔁 Trying to cherry-pick $NEXT_COMMIT..."
if git cherry-pick $NEXT_COMMIT; then
  echo "✅ Cherry-pick successful!"
else
  echo "⚠️ Conflict detected. Aborting cherry-pick and skipping."
  git cherry-pick --abort
  exit 0
fi
