#!/bin/bash

# Remove any empty directories in Shared and iOS
find ./Shared -type d -empty -delete
find ./iOS -type d -empty -delete

# Check if the directories are now gone
if [ ! -d "./Shared" ] && [ ! -d "./iOS" ]; then
  echo "Successfully removed old directory structure"
else
  # If directories still exist, we need to check for remaining files
  echo "Some files may still need to be moved:"
  find ./Shared -type f
  find ./iOS -type f
fi
