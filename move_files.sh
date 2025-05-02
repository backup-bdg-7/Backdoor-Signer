#!/bin/bash

# Move files to the new structure

# Function to move a file or directory
move_file() {
    src="$1"
    dst="$2"
    mkdir -p $(dirname "$dst")
    cp -R "$src" "$dst" 2>/dev/null && rm -rf "$src"
    echo "Moved: $src -> $dst"
}

# App
move_file "iOS/Delegates" "App"
move_file "iOS/Resources" "App/Resources"
move_file "iOS/backdoor.entitlements" "App/backdoor.entitlements"
move_file "iOS/Views/TabbarView.swift" "App/Views/TabbarView.swift"
move_file "iOS/Views/ConsentViewController.swift" "App/Views/ConsentViewController.swift"

# Core
move_file "iOS/Common" "Core/Common"
move_file "iOS/Extensions" "Core/Extensions"
move_file "iOS/Utilities" "Core/Utilities"
move_file "Shared/Data/UserDefaults" "Core/Data/UserDefaults"
move_file "Shared/Data/CoreData" "Core/Data/CoreData"
move_file "Shared/Logging" "Core/Logging"
move_file "Shared/Management" "Core/Services"
move_file "Shared/Server" "Core/Server"
move_file "Shared/Localizations" "Core/Localization"

# Features
move_file "iOS/Views/AI Assistant" "Features/AI/Views"
move_file "iOS/Views/Home" "Features/Home/Views"
move_file "iOS/Views/Apps" "Features/Library/Views"
move_file "iOS/Views/Settings" "Features/Settings/Views"
move_file "iOS/Views/Signing" "Features/Signing/Views"
move_file "iOS/Views/Sources" "Features/Sources/Views"
move_file "iOS/Views/Terminal" "Features/Terminal/Views"
move_file "iOS/Debugger" "Features/Debugger"
move_file "iOS/Operations/CoreML" "Features/AI/Services/CoreML"
move_file "iOS/Operations" "Features/AI/Services"
move_file "iOS/Models" "Features/Signing/Models"

# UI & Magic
move_file "Shared/Design" "UI/Design"
move_file "iOS/Design" "UI/Design"
move_file "Shared/Magic" "Magic"

# Documentation
find Shared -name "*.md" -exec bash -c 'file="{}"; dest="Documentation/$(basename "$file")"; mv "$file" "$dest"' \;
move_file "iOS/Views/Settings/SETTINGS_README.md" "Documentation/SETTINGS_README.md"

