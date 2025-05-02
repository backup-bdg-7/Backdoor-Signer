#!/bin/bash

echo "=== Starting Complete Feature-Based Reorganization ==="

# Function to create directory if it doesn't exist
mkdir_if_needed() {
  if [ ! -d "$1" ]; then
    mkdir -p "$1"
  fi
}

# Function to safely copy a file, creating directories as needed
safe_copy() {
  source="$1"
  dest="$2"
  
  # Create destination directory if needed
  mkdir_if_needed "$(dirname "$dest")"
  
  # Copy file
  cp "$source" "$dest"
  echo "Copied: $source -> $dest"
}

# 1. App Lifecycle Files
echo "Organizing App Lifecycle files..."
find . -name "*Delegate*.swift" -o -name "main.swift" | while read file; do
  safe_copy "$file" "App/Lifecycle/$(basename "$file")"
done

# 2. Resources
echo "Organizing Resources..."
find . -name "*.xcassets" -o -name "*.storyboard" -o -name "*.xib" -o -name "*.plist" | while read file; do
  if [[ "$file" != "./App/"* ]]; then
    safe_copy "$file" "App/Resources/$(basename "$file")"
  fi
done

# 3. AI Assistant Related Files
echo "Organizing AI Assistant files..."
find . -name "*.swift" | grep -i -E "AI|ChatMessage|ChatSession|Chat" | while read file; do
  filename=$(basename "$file")
  
  # Determine subdirectory based on file content/name
  if [[ "$filename" == *"Model"* ]] || [[ "$filename" == *"Data"* ]]; then
    safe_copy "$file" "Features/AIAssistant/Models/$filename"
  elif [[ "$filename" == *"Service"* ]] || [[ "$filename" == *"Manager"* ]] || [[ "$filename" == *"Client"* ]]; then
    safe_copy "$file" "Features/AIAssistant/Services/$filename"
  elif [[ "$filename" == *"View"* ]] || [[ "$filename" == *"Controller"* ]] || [[ "$filename" == *"Cell"* ]]; then
    safe_copy "$file" "Features/AIAssistant/UI/$filename"
  else
    safe_copy "$file" "Features/AIAssistant/Utils/$filename"
  fi
done

# 4. App Signing Related Files
echo "Organizing App Signing files..."
find . -name "*.swift" | grep -i -E "Sign|Certificate|Cert|Entitlement" | while read file; do
  filename=$(basename "$file")
  
  # Determine subdirectory based on file content/name
  if [[ "$filename" == *"Model"* ]] || [[ "$filename" == *"Data"* ]]; then
    safe_copy "$file" "Features/AppSigning/Models/$filename"
  elif [[ "$filename" == *"Service"* ]] || [[ "$filename" == *"Manager"* ]]; then
    safe_copy "$file" "Features/AppSigning/Services/$filename"
  elif [[ "$filename" == *"View"* ]] || [[ "$filename" == *"Controller"* ]] || [[ "$filename" == *"Cell"* ]]; then
    safe_copy "$file" "Features/AppSigning/UI/$filename"
  else
    safe_copy "$file" "Features/AppSigning/Utils/$filename"
  fi
done

# 5. File Manager Related Files
echo "Organizing File Manager files..."
find . -name "*.swift" | grep -i -E "File|Directory|Home" | grep -v -i -E "AI|Sign|Terminal" | while read file; do
  filename=$(basename "$file")
  
  # Determine subdirectory based on file content/name
  if [[ "$filename" == *"Model"* ]] || [[ "$filename" == *"Data"* ]]; then
    safe_copy "$file" "Features/FileManager/Models/$filename"
  elif [[ "$filename" == *"Service"* ]] || [[ "$filename" == *"Manager"* ]] || [[ "$filename" ^
\./(.*)/[
^
/]+$|\1|')
  filename=$(basename "$file")
  
  # Determine appropriate security subdirectory
  if [[ "$rel_path" == *"decompression"* ]]; then
    safe_copy "$file" "Security/Utils/decompression/$filename"
  elif [[ "$rel_path" == *"zsign"* ]]; then
    safe_copy "$file" "Security/Signing/zsign/$filename"
  elif [[ "$rel_path" == *"Magic"* ]]; then
    safe_copy "$file" "Security/Utils/$filename"
  else
    safe_copy "$file" "Security/Utils/$filename"
  fi
done

# 18. Any remaining important files
echo "Checking for remaining important files..."
find . -name "*.swift" | grep -v -E "
^
\./(App|Core|Features|UI|Security)" | while read file; do
  echo "Remaining Swift file: $file"
  # Add logic to handle these remaining files as needed
done

echo "=== Feature-Based Reorganization Complete ==="
