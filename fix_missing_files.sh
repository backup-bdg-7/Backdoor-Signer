#!/bin/bash

# Create a script to ensure all necessary files exist in their original locations
# This is a transitional fix to allow the build to succeed while keeping the new organization

echo "=== Ensuring files exist in original locations for build ==="

# Function to ensure original directory exists
ensure_dir() {
  if [ ! -d "$1" ]; then
    mkdir -p "$1"
    echo "Created directory: $1"
  fi
}

# Function to copy file if source exists
copy_if_exists() {
  if [ -f "$1" ]; then
    ensure_dir "$(dirname "$2")"
    cp "$1" "$2"
    echo "Copied: $1 -> $2"
  else
    echo "Source file not found: $1"
  fi
}

# Make sure all directories required by the project exist
ensure_dir "Shared"
ensure_dir "Shared/Data"
ensure_dir "Shared/Resources"
ensure_dir "Shared/Magic"
ensure_dir "Shared/Design"
ensure_dir "Shared/Localizations"
ensure_dir "Shared/Logging"
ensure_dir "Shared/Server"
ensure_dir "Shared/Management"
ensure_dir "iOS"
ensure_dir "iOS/Resources"
ensure_dir "iOS/Delegates"
ensure_dir "iOS/Common"
ensure_dir "iOS/Extensions"
ensure_dir "iOS/Utilities"
ensure_dir "iOS/Views"
ensure_dir "iOS/Design"
ensure_dir "iOS/Models"
ensure_dir "iOS/Management"

# Copy all .md files back to Shared for resource references
echo "Copying documentation files back to Shared/"
find Documentation -name "*.md" | while read file; do
  filename=$(basename "$file")
  copy_if_exists "$file" "Shared/$filename"
done

# Copy resources to their original locations
echo "Copying ellekit.deb back to Shared/Resources/"
copy_if_exists "App/Resources/Frameworks/ellekit.deb" "Shared/Resources/ellekit.deb"

# Search for any additional resource files that may be referenced
echo "Looking for other potential resource files..."
grep -r "CpResource" --include="*.log" ../logs/ | grep "No such file" | cut -d' ' -f4 | sort | uniq | while read file; do
  # Extract the original path
  original_path=$(echo "$file" | sed 's|.*/\(.*\)/\([
^
/]*\)$|\1/\2|')
  echo "Missing resource: $original_path"
  
  # Try to find the file in our new directory structure
  potential_file=$(find . -name "$(basename "$original_path")" | grep -v "Shared/" | head -1)
  
  if [ -n "$potential_file" ]; then
    copy_if_exists "$potential_file" "$original_path"
  else
    echo "Could not find $original_path in new directory structure."
  fi
done

echo "=== Fix complete ==="
