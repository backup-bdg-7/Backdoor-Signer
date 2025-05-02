#!/bin/bash

# Create the localization directories
mkdir -p Shared/Localizations/{zh,ru,en,de,es,fr,ja,ko,tr,cs}.lproj

# Look for localization files in the new structure
echo "Looking for localization files to copy back..."
find . -name "*.lproj" -type d | while read lproj_dir; do
  lang=$(basename "$lproj_dir")
  echo "Found localization directory: $lproj_dir for language: $lang"
  
  # Create the target directory if it doesn't exist
  target_dir="Shared/Localizations/$lang"
  mkdir -p "$target_dir"
  
  # Copy all strings files
  find "$lproj_dir" -name "*.strings" | while read strings_file; do
    cp "$strings_file" "$target_dir/"
    echo "Copied $strings_file to $target_dir/"
  done
done

# Create empty localization files if none exist (as a fallback)
for lang in zh ru en de es fr ja ko tr cs; do
  target_file="Shared/Localizations/$lang.lproj/Localizable.strings"
  if [ ! -f "$target_file" ]; then
    echo "Creating empty $target_file"
    mkdir -p "$(dirname "$target_file")"
    echo '/* Localization file */' > "$target_file"
  fi
done

echo "Localization fix complete"
