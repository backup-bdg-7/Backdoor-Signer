#!/bin/bash

set -e

echo "=== Starting Deep Code Reorganization ==="

# Create improved directory structure
mkdir -p App/{Lifecycle,Resources/{Assets,Frameworks}}
mkdir -p Core/{Common,Data/{CoreData,UserDefaults},Error,Extensions/{UIKit,Foundation,CoreGraphics},Localization,Logging,Networking,Security,Server,Services,Threading,Utilities}
mkdir -p UI/{Components/{Buttons,Cards,Cells,Inputs,Labels,Modals},Design/{Colors,Fonts,Icons,Styles},Base/{Controllers,Views},Helpers,Modifiers}
mkdir -p Magic/{Encryption,Decompression,Sign,Utils}

# Fix features structure
for feature in AI Debugger Home Hub Library Settings Signing Sources Terminal; do
  mkdir -p Features/$feature/{Models,Services,Views,Coordinators}
done

# Special case for Settings which has submodules
mkdir -p Features/Settings/Modules/{AILearning,About,AppIcon,Certificates,Display,Reset,Search,Server,Terminal}

# Flatten nested directories
echo "=== Flattening Nested Directories ==="

# Fix Extensions/Extensions -> Extensions
if [ -d "Core/Extensions/Extensions" ]; then
  find Core/Extensions/Extensions -type f -exec mv {} Core/Extensions/ \;
  rm -rf Core/Extensions/Extensions
  echo "Flattened Core/Extensions/Extensions"
fi

# Fix Models/Models -> Models
if [ -d "Features/Signing/Models/Models" ]; then
  find Features/Signing/Models/Models -type f -exec mv {} Features/Signing/Models/ \;
  rm -rf Features/Signing/Models/Models
  echo "Flattened Features/Signing/Models/Models"
fi

# Fix Views/Views -> Views (for various features)
for feature in Settings Sources Terminal; do
  if [ -d "Features/$feature/Views/$feature" ]; then
    find "Features/$feature/Views/$feature" -type f -exec mv {} "Features/$feature/Views/" \;
    rm -rf "Features/$feature/Views/$feature"
    echo "Flattened Features/$feature/Views/$feature"
  fi
done

# Fix Settings modules
if [ -d "Features/Settings/Views/Settings" ]; then
  # Move AI Learning files
  if [ -d "Features/Settings/Views/Settings/AI Learning" ]; then
    mkdir -p "Features/Settings/Modules/AILearning"
    find "Features/Settings/Views/Settings/AI Learning" -type f -exec mv {} "Features/Settings/Modules/AILearning/" \;
  fi
  
  # Move About files
  if [ -d "Features/Settings/Views/Settings/About" ]; then
    mkdir -p "Features/Settings/Modules/About"
    find "Features/Settings/Views/Settings/About" -type f -exec mv {} "Features/Settings/Modules/About/" \;
  fi
  
  # Move the rest of the modules
  for module in AppIcon Certificates Components Display Reset Search "Server Options" Terminal "View Logs"; do
    module_clean=$(echo "$module" | tr ' ' '')
    if [ -d "Features/Settings/Views/Settings/$module" ]; then
      mkdir -p "Features/Settings/Modules/$module_clean"
      find "Features/Settings/Views/Settings/$module" -type f -exec mv {} "Features/Settings/Modules/$module_clean/" \;
    fi
  done
  
  # Move remaining files to Views
  find "Features/Settings/Views/Settings" -type f -exec mv {} "Features/Settings/Views/" \;
  rm -rf "Features/Settings/Views/Settings"
  echo "Reorganized Settings modules"
fi

# Clean up remaining files from old structure
echo "=== Moving Remaining Files from Old Structure ==="

# Move remaining iOS files
if [ -d "iOS" ]; then
  # Move Info.plist
  if [ -f "iOS/Info.plist" ]; then
    cp "iOS/Info.plist" "App/"
    echo "Moved Info.plist to App/"
  fi
  
  # Move management files
  if [ -d "iOS/Management" ]; then
    find "iOS/Management" -name "*.swift" -exec cp {} "Core/Services/" \;
    echo "Moved management files to Core/Services/"
  fi
  
  # Move remaining views
  if [ -d "iOS/Views/Extra" ]; then
    mkdir -p "UI/Components/Modals"
    find "iOS/Views/Extra" -name "*.swift" -exec cp {} "UI/Components/Modals/" \;
    echo "Moved Extra views to UI/Components/Modals/"
  fi
  
  if [ -d "iOS/Views/Hub" ]; then
    find "iOS/Views/Hub" -name "*.swift" -exec cp {} "Features/Hub/Views/" \;
    echo "Moved Hub views to Features/Hub/Views/"
  fi
fi

# Move remaining Shared files
if [ -d "Shared" ]; then
  # Move CoreData model
  if [ -d "Shared/Data/Backdoor.xcdatamodeld" ]; then
    mkdir -p "Core/Data/CoreData/Model"
    cp -r "Shared/Data/Backdoor.xcdatamodeld" "Core/Data/CoreData/Model/"
    echo "Moved CoreData model to Core/Data/CoreData/Model/"
  fi
  
  # Move resources
  if [ -d "Shared/Resources" ]; then
    find "Shared/Resources" -type f -exec cp {} "App/Resources/" \;
    echo "Moved resources to App/Resources/"
  fi
fi

# Fix Utilities and Helpers
echo "=== Organizing Utilities and Helpers ==="

if [ -d "Features/Home/Views/Home/Utilities" ]; then
  find "Features/Home/Views/Home/Utilities" -name "*.swift" -exec cp {} "Core/Utilities/" \;
  echo "Moved home utilities to Core/Utilities/"
fi

if [ -d "Features/AI/Services/Operations/Helpers" ]; then
  find "Features/AI/Services/Operations/Helpers" -name "*.swift" -exec cp {} "Core/Utilities/" \;
  echo "Moved AI helpers to Core/Utilities/"
fi

# Add Documentation files
mkdir -p Documentation
if [ -f "README.md" ]; then
  cp README.md Documentation/
fi

# Add Configuration
mkdir -p Configuration
if [ -d "Clean" ]; then
  find "Clean" -type f -exec cp {} "Configuration/" \;
  echo "Moved configuration files to Configuration/"
fi

echo "=== Deep Code Reorganization Complete ==="
echo "You should review the changes, update imports, and update project.pbxproj to reflect these changes."
