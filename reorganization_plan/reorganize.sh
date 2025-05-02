#!/bin/bash

echo "Starting codebase reorganization..."

# Create a backup before making any changes
echo "Creating temporary backup..."
mkdir -p ./backup_before_reorganization
cp -R ./App ./Core ./Features ./Magic ./UI ./iOS ./Shared ./Documentation ./scripts ./backdoor.xcodeproj ./backup_before_reorganization/

# STEP 1: Clean up unnecessary files
echo "Removing unnecessary files..."

# 1a. Remove empty files
echo "- Removing empty files..."
rm -f ./Features/Settings/Views/Settings/ModifyAppDelegate.swift
rm -f ./Features/Terminal/Views/TerminalFileManager.swift
rm -f ./Magic/BackdoorCLI.swift

# 1b. Remove backup files
echo "- Removing backup files..."
rm -f ./backdoor.xcodeproj/project.pbxproj.backup
rm -f ./scripts/ci/download-artifacts.sh.bak

# 1c. Remove .gitkeep placeholder files
echo "- Removing .gitkeep files..."
find . -name ".gitkeep" -type f -delete

# STEP 2: Consolidate duplicated files
echo "Consolidating duplicate files..."

# 2a. UserDefaults folder duplicates
echo "- Consolidating UserDefaults..."
rm -rf ./Core/Data/UserDefaults/UserDefaults

# 2b. Duplicate CoreData model
echo "- Consolidating CoreData models..."
rm -rf ./Shared/Data/Backdoor.xcdatamodeld

# 2c. iOS directory duplicates - we'll handle these by moving unique content
# and removing duplicates
mkdir -p ./reorganization_plan/ios_unique
# Move the unique AI.swift to our temporary location
cp ./iOS/Views/AI.swift ./reorganization_plan/ios_unique/

# STEP 3: Create new modular directory structure
echo "Creating modular directory structure..."

# 3a. Core module structure
echo "- Setting up Core module..."
mkdir -p ./Core/Common
mkdir -p ./Core/Data/Models
mkdir -p ./Core/Extensions
mkdir -p ./Core/Localization
mkdir -p ./Core/Logging
mkdir -p ./Core/Server/Model
mkdir -p ./Core/Services
mkdir -p ./Core/Utilities

# 3b. Features module structure
echo "- Setting up Features module..."
mkdir -p ./Features/AI/Models
mkdir -p ./Features/AI/Services/CoreML
mkdir -p ./Features/AI/Services/Operations
mkdir -p ./Features/AI/Services/Operations/Helpers
mkdir -p ./Features/AI/Views/AI\ Assistant
mkdir -p ./Features/Debugger/Core
mkdir -p ./Features/Debugger/UI
mkdir -p ./Features/Home/Views/Home/Core
mkdir -p ./Features/Home/Views/Home/Editors
mkdir -p ./Features/Home/Views/Home/Extensions
mkdir -p ./Features/Home/Views/Home/Operations
mkdir -p ./Features/Home/Views/Home/UI
mkdir -p ./Features/Home/Views/Home/Utilities
mkdir -p ./Features/Hub/Views
mkdir -p ./Features/Library/Views/Apps/Information
mkdir -p ./Features/Settings/Views/Settings/AI\ Learning
mkdir -p ./Features/Settings/Views/Settings/About
mkdir -p ./Features/Settings/Views/Settings/AppIcon
mkdir -p ./Features/Settings/Views/Settings/Certificates
mkdir -p ./Features/Settings/Views/Settings/Components
mkdir -p ./Features/Settings/Views/Settings/Display
mkdir -p ./Features/Settings/Views/Settings/Reset
mkdir -p ./Features/Settings/Views/Settings/Search
mkdir -p ./Features/Settings/Views/Settings/Server\ Options
mkdir -p ./Features/Settings/Views/Settings/Terminal
mkdir -p ./Features/Settings/Views/Settings/View\ Logs
mkdir -p ./Features/Signing/Models/Models
mkdir -p ./Features/Signing/Views
mkdir -p ./Features/Sources/Views
mkdir -p ./Features/Terminal/Views

# 3c. UI module structure
echo "- Setting up UI module..."
mkdir -p ./UI/Design
mkdir -p ./UI/Views/Extra

# 3d. Magic module structure - already exists, no need to create

# 3e. Documentation module - already exists, no need to create

# STEP 4: Move iOS unique content to appropriate locations
echo "Moving unique iOS content to appropriate locations..."
cp ./reorganization_plan/ios_unique/AI.swift ./Features/AI/Views/AI.swift

# Note: We already determined backdoor.entitlements is in App/ not iOS/

# STEP 5: Mark any critical files that need to be updated with path references
echo "Creating list of files that may need path updates..."
grep -r "import UIKit" --include="*.swift" . | cut -d: -f1 > ./reorganization_plan/files_to_check.txt

# STEP 6: Let's create a note about updating the project file
cat > ./reorganization_plan/project_file_update.md << 'EOF_PROJ'
# Project File Update

After reorganizing the codebase structure, the Xcode project file (backdoor.xcodeproj/project.pbxproj) will need to be updated to reflect the new file locations. This is a critical step to ensure the project builds correctly.

Key updates needed:
1. Update all file references to point to their new locations
2. Update any group structures to match the new organization
3. Update any build settings that reference specific file paths

Note that we've preserved the Info.plist and entitlements file locations to minimize project changes.
EOF_PROJ

echo "Reorganization script preparation complete"
