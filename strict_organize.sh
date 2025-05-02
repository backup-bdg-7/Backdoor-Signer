#!/bin/bash

echo "=== Starting Strict Functional Reorganization ==="

# 1. First collect all delegate files into App/Delegates
echo "Organizing all delegates..."
find iOS -name "*Delegate*.swift" | while read file; do
  echo "  Moving delegate: $file"
  cp "$file" "App/Delegates/"
done

# 2. Group all AI-related code together
echo "Organizing all AI-related code..."
# AI models
find . -name "*.swift" | grep -i "AI" | grep -i "Model" | while read file; do
  echo "  Moving AI model: $file"
  cp "$file" "Features/AI/Models/"
done

# AI services
find . -name "*.swift" | grep -i "AI" | grep -i -E "Service|Manager|Client" | while read file; do
  echo "  Moving AI service: $file"
  cp "$file" "Features/AI/Services/"
done

# AI views
find . -name "*.swift" | grep -i "AI" | grep -i -E "View|Controller" | while read file; do
  echo "  Moving AI view: $file"
  cp "$file" "Features/AI/Views/"
done

# AI helpers
find . -name "*.swift" | grep -i "AI" | grep -i -E "Helper|Util" | while read file; do
  echo "  Moving AI helper: $file"
  cp "$file" "Features/AI/Helpers/"
done

# 3. All Core extensions by framework
echo "Organizing all extensions..."
# UIKit extensions
find . -name "UI*.swift" | grep -i -E "Extension|+.swift" | while read file; do
  echo "  Moving UIKit extension: $file"
  cp "$file" "Core/Extensions/UIKit/"
done

# Foundation extensions
find . -name "*.swift" | grep -v "UI" | grep -v "View+" | grep -i -E "Extension|+.swift" | while read file; do
  echo "  Moving Foundation extension: $file"
  cp "$file" "Core/Extensions/Foundation/"
done

# SwiftUI extensions
find . -name "View+*.swift" | while read file; do
  echo "  Moving SwiftUI extension: $file"
  cp "$file" "Core/Extensions/SwiftUI/"
done

# 4. All signing-related code
echo "Organizing all signing-related code..."
# Signing models
find . -name "*.swift" | grep -i -E "Sign|Certificate|Cert" | grep -i "Model" | while read file; do
  echo "  Moving signing model: $file"
  cp "$file" "Features/Signing/Models/"
done

# Signing utils
find . -name "*.swift" | grep -i -E "Sign|Certificate|Cert" | grep -i -E "Util|Helper" | while read file; do
  echo "  Moving signing util: $file"
  cp "$file" "Features/Signing/Utils/"
done

# Signing views
find . -name "*.swift" | grep -i -E "Sign|Certificate|Cert" | grep -i -E "View|Controller" | while read file; do
  echo "  Moving signing view: $file"
  cp "$file" "Features/Signing/Views/"
done

# Signing data
find . -name "*.swift" | grep -i -E "Sign|Certificate|Cert" | grep -i -E "Data|CoreData" | while read file; do
  echo "  Moving signing data: $file"
  cp "$file" "Features/Signing/Data/"
done

# 5. All UI components by type
echo "Organizing all UI components..."
# Modals/popups
find . -name "*.swift" | grep -i -E "Popup|Modal|Alert" | while read file; do
  echo "  Moving modal: $file"
  cp "$file" "UI/Components/Modals/"
done

# Cells
find . -name "*.swift" | grep -i "Cell" | while read file; do
  echo "  Moving cell: $file"
  cp "$file" "UI/Components/Cells/"
done

# Buttons
find . -name "*.swift" | grep -i "Button" | while read file; do
  echo "  Moving button: $file"
  cp "$file" "UI/Components/Buttons/"
done

# 6. All Core data management code
echo "Organizing all data management code..."
# CoreData
find . -name "*.swift" | grep -i "CoreData" | while read file; do
  echo "  Moving CoreData: $file"
  cp "$file" "Core/Data/CoreData/"
done

# UserDefaults
find . -name "*.swift" | grep -i "UserDefaults" | while read file; do
  echo "  Moving UserDefaults: $file"
  cp "$file" "Core/Data/UserDefaults/"
done

# 7. All network code
echo "Organizing all networking code..."
find . -name "*.swift" | grep -i -E "Network|HTTP|Request|API|Client" | grep -v "AI" | while read file; do
  echo "  Moving network: $file"
  cp "$file" "Core/Network/"
done

# 8. All terminal-related code
echo "Organizing all terminal code..."
find . -name "*.swift" | grep -i "Terminal" | while read file; do
  echo "  Moving terminal: $file"
  cp "$file" "Features/Terminal/"
done

# 9. All settings-related code
echo "Organizing all settings code..."
find . -name "*.swift" | grep -i "Settings" | while read file; do
  echo "  Moving settings: $file"
  cp "$file" "Features/Settings/"
done

# 10. All sources-related code
echo "Organizing all sources code..."
find . -name "*.swift" | grep -i -E "Source|Repo" | grep -v -i "Resource" | while read file; do
  echo "  Moving sources: $file"
  cp "$file" "Features/Sources/"
done

# 11. All home-related code
echo "Organizing all home^
\./(App|Core|Features|UI|Magic)" | grep -v "strict_organize.sh" | grep -v "find_leftover.sh"

# Look for resources not properly organized
echo "Resource files outside new structure:"
find . -name "*.png" -o -name "*.jpg" -o -name "*.pdf" | grep -v -E "
^
\./(App|Resources)"

echo "=== Check Complete ==="
