#!/bin/bash

echo "=== Analyzing Current Structure ==="

# Count Swift files by directory
echo "Swift files by top-level directory:"
find App -name "*.swift" | wc -l | xargs echo "App:"
find Core -name "*.swift" | wc -l | xargs echo "Core:"
find Features -name "*.swift" | wc -l | xargs echo "Features:"
find Magic -name "*.swift" | wc -l | xargs echo "Magic:"
find UI -name "*.swift" | wc -l | xargs echo "UI:"
find iOS -name "*.swift" 2>/dev/null | wc -l | xargs echo "iOS (old):"
find Shared -name "*.swift" 2>/dev/null | wc -l | xargs echo "Shared (old):"

# Check for duplicate file names
echo -e "\nPotential duplicate file names:"
find . -name "*.swift" | sed 's|.*/||' | sort | uniq -c | sort -nr | grep -v "
^
      1 " | head -10

# Check imports to understand dependencies
echo -e "\nTop import patterns (sample):"
find . -name "*.swift" | xargs grep -l "import " | head -30 | xargs grep "import " | sort | uniq -c | sort -nr | head -15

# Check nesting depth
echo -e "\nDirectories with excessive nesting:"
find . -type d | awk -F'/' '{ print NF-1, $0 }' | sort -nr | head -20

echo -e "\n=== Analysis Complete ==="
