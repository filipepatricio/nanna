#!/bin/sh

# Log executed commands ...
# set -x

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

GIT_DIFF="$(git diff --cached)"
if [ -z "$GIT_DIFF" ]; then
  echo "No changes staged for commit"
  exit 1
fi

# Temporary commit of staged changes ...
git commit --no-verify --message "changes to be verified by pre-commit hook"

GIT_STATUS="$(git status -s)"
if [ ! -z "$GIT_STATUS" ]; then
  # Stash unstaged changes ...
  STASH_NAME="unstaged changes found by pre-commit hook ($(date '+%Y-%m-%d %H:%M:%S'))"
  git stash push --keep-index --message "$STASH_NAME"
fi

make flutter_format
GIT_STATUS_POST_FORMAT="$(git status -s)"
if [ ! -z "$GIT_STATUS_POST_FORMAT" ]; then
    echo "\n\n${red}***ALERT*** Flutter format has changed files. Review and stage them before proceeding with the commit\n\n"
    # Discard all changes made by `make pre-commit` and drop temporary commit...
    git reset --soft HEAD^
    if [ ! -z "$GIT_STATUS" ]; then
        # Restore all unstaged changes ...
        git stash pop
    fi
    exit 1
fi

make pre-commit

RESULT=$?
if [ $RESULT -ne 0 ]; then
  # Discard all changes made by `make pre-commit` and drop temporary commit...
  git reset --soft HEAD^
  if [ ! -z "$GIT_STATUS" ]; then
    # Restore all unstaged changes ...
    git stash pop
  fi
  exit $RESULT
fi

# Stage all fixed files ...
git add -u
# Add changes to temporary commit ...
git commit --no-verify --amend --message "changes verified by pre-commit hook"
# Drop temporary commit ...
git reset --soft HEAD^

##############################################################################
# Now the git index contains all previously staged changes + all fixed files #
##############################################################################

if [ ! -z "$GIT_STATUS" ]; then
  # Restore all unstaged changes ...
  git stash pop
fi
