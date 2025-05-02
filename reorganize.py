#!/usr/bin/env python3

import os
import shutil
import subprocess

def run_command(cmd):
    print(f"Running: {cmd}")
    subprocess.run(cmd, shell=True)

def ensure_dir(directory):
    os.makedirs(directory, exist_ok=True)

# Map of directories to move from the old to new structure
directory_mapping = {
    # App
    "iOS/Delegates": "App",
    "iOS/Resources": "App/Resources",
    
    # Core
    "iOS/Extensions": "Core/Extensions",
    "iOS/Common": "Core/Common",
    "iOS/Utilities": "Core/Utilities",
    "Shared/Data/UserDefaults": "Core/Data/UserDefaults",
    "Shared/Data/CoreData": "Core/Data/CoreData",
    "Shared/Logging": "Core/Logging",
    "Shared/Management": "Core/Services",
    "Shared/Server": "Core/Server",
    "Shared/Localizations": "Core/Localization",
    
    # Features
    "iOS/Views/AI Assistant": "Features/AI/Views",
    "iOS/Operations/CoreML": "Features/AI/Services/CoreML",
    "iOS/Operations": "Features/AI/Services",  # AI-related operations
    "iOS/Views/Home": "Features/Home/Views",
    "iOS/Views/Apps": "Features/Library/Views",
    "iOS/Views/Settings": "Features/Settings/Views",
    "iOS/Views/Signing": "Features/Signing/Views",
    "iOS/Models": "Features/Signing/Models",
    "iOS/Views/Sources": "Features/Sources/Views",
    "iOS/Views/Terminal": "Features/Terminal/Views",
    "iOS/Debugger": "Features/Debugger",
    
    # Magic
    "Shared/Magic": "Magic",
    
    # UI
    "Shared/Design": "UI/Design",
    "iOS/Design": "UI/Design",
}

# Special file mappings
file_mappings = {
    "iOS/Views/TabbarView.swift": "App/Views/TabbarView.swift",
    "iOS/backdoor.entitlements": "App/backdoor.entitlements",
    "iOS/Views/ConsentViewController.swift": "App/Views/ConsentViewController.swift",
    
    # Move markdown files to Documentation
    "Shared/*.md": "Documentation",
}

# Create necessary directories
for dest in directory_mapping.values():
    ensure_dir(dest)

# Move directories first
for src, dest in directory_mapping.items():
    # Check if the source exists
    if os.path.exists(# Let's take a simpler approach since there were issues with the previous scripts

# 1. Let's create the directory structure first
find . -type d -name ".git" -prune -o -type d -print | sort > original_structure.txt

# Create our new directory structure
mkdir -p App/{Extensions,Resources,Services,Views}
mkdir -p Core/{Common,Data/{CoreData/{Extensions,Models},UserDefaults},Extensions,Logging,Networking,Services,Utilities/{Errors,Helpers}}
mkdir -p Features/{AI,Home,Library,Settings,Signing,Sources,Terminal,Debugger}/{Models,Services,Views,Components}
mkdir -p Magic/{decompression,esign,zsign}
mkdir -p UI/{Base,Components,Design,Views}
mkdir -p Documentation
mkdir -p Configuration

# 2. Create a Python script to update the project.pbxproj file
cat > update_project.py << 'EOF'
#!/usr/bin/env python3

import os
import re
import shutil

# Create a backup of the project file
project_file = "backdoor.xcodeproj/project.pbxproj"
backup_file = project_file + ".backup"
shutil.copy2(project_file, backup_file)

# Read the project file
with open(project_file, 'r') as f:
    content = f.read()

# Define path mappings
mappings = [
    # iOS → App
    ('path = iOS/Delegates/', 'path = App/'),
    ('path = iOS/Resources/', 'path = App/Resources/'),
    ('path = iOS/backdoor.entitlements', 'path = App/backdoor.entitlements'),
    ('path = iOS/Views/TabbarView.swift', 'path = App/Views/TabbarView.swift'),
    
    # iOS → Core
    ('path = iOS/Common/', 'path = Core/Common/'),
    ('path = iOS/Extensions/', 'path = Core/Extensions/'),
    ('path = iOS/Utilities/', 'path = Core/Utilities/'),
    
    # Shared → Core
    ('path = Shared/Data/', 'path = Core/Data/'),
    ('path = Shared/Logging/', 'path = Core/Logging/'),
    ('path = Shared/Management/', 'path = Core/Services/'),
    ('path = Shared/Server/', 'path = Core/Server/'),
    ('path = Shared/Localizations/', 'path = Core/Localization/'),
    
    # iOS → Features
    ('path = iOS/Views/AI Assistant/', 'path = Features/AI/Views/'),
    ('path = iOS/Views/Home/', 'path = Features/Home/Views/'),
    ('path = iOS/Views/Apps/', 'path = Features/Library/Views/'),
    ('path = iOS/Views/Settings/', 'path = Features/Settings/Views/'),
    ('path = iOS/Views/Signing/', 'path = Features/Signing/Views/'),
    ('path = iOS/Views/Sources/', 'path = Features/Sources/Views/'),
    ('path = iOS/Views/Terminal/', 'path = Features/Terminal/Views/'),
    ('path = iOS/Debugger/', 'path = Features/Debugger/'),
    ('path = iOS/Operations/', 'path = Features/AI/Services/'),
    ('path = iOS/Models/', 'path = Features/Signing/Models/'),
    
    # Shared → UI/Magic
    ('path = Shared/Design/', 'path = UI/Design/'),
    ('path = Shared/Magic/', 'path = Magic/'),
    
    # With quotes
    ('path = "iOS/Delegates/', 'path = "App/'),
    ('path = "iOS/Resources/', 'path = "App/Resources/'),
    ('path = "iOS/backdoor.entitlements"', 'path = "App/backdoor.entitlements"'),
    ('path = "iOS/Views/TabbarView.swift"', 'path = "App/Views/TabbarView.swift"'),
    ('path = "iOS/Common/', 'path = "Core/Common/'),
    ('path = "iOS/Extensions/', 'path = "Core/Extensions/'),
    ('path = "iOS/Utilities/', 'path = "Core/Utilities/'),
    ('path = "Shared/Data/', 'path = "Core/Data/'),
    ('path = "Shared/Logging/', 'path = "Core/Logging/'),
    ('path = "Shared/Management/', 'path = "Core/Services/'),
    ('path = "Shared/Server/', 'path = "Core/Server/'),
    ('path = "Shared/Localizations/', 'path = "Core/Localization/'),
    ('path = "iOS/Views/AI Assistant/', 'path = "Features/AI/Views/'),
    ('path = "iOS/Views/Home/', 'path = "Features/Home/Views/'),
    ('path = "iOS/Views/Apps/', 'path = "Features/Library/Views/'),
    ('path = "iOS/Views/Settings/', 'path = "Features/Settings/Views/'),
    ('path = "iOS/Views/Signing/', 'path = "Features/Signing/Views/'),
    ('path = "iOS/Views/Sources/', 'path = "Features/Sources/Views/'),
    ('path = "iOS/Views/Terminal/', 'path = "Features/Terminal/Views/'),
    ('path = "iOS/Debugger/', 'path = "Features/Debugger/'),
    ('path = "iOS/Operations/', 'path = "Features/AI/Services/'),
    ('path = "iOS/Models/', 'path = "Features/Signing/Models/'),
    ('path = "Shared/Design/', 'path = "UI/Design/'),
    ('path = "Shared/Magic/', 'path = "Magic/'),
    
    # Update group names
    ('name = iOS;', 'name = Features;'),
    ('name = Shared;', 'name = Core;'),
]

# Apply replacements
for old_path, new_path in mappings:
    content = content.replace(old_path, new_path)

# Write the updated content
with open(project_file, 'w') as f:
    f.write(content)

print("Updated project.pbxproj with new paths")
