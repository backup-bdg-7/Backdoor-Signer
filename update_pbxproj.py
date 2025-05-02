#!/usr/bin/env python3

import os
import re
import shutil

# Backup the project file (use existing if already created)
project_file = "backdoor.xcodeproj/project.pbxproj"
backup_file = project_file + ".backup"
if not os.path.exists(backup_file):
    shutil.copy2(project_file, backup_file)
    print(f"Created backup: {backup_file}")
else:
    print(f"Using existing backup: {backup_file}")

# Read the original project file from backup to ensure we're working with the original
with open(backup_file, 'r') as f:
    original_content = f.read()

# Map of old paths to new paths
path_mappings = {
    # iOS → App
    'iOS/Delegates/': 'App/',
    'iOS/Resources/': 'App/Resources/',
    'iOS/backdoor.entitlements': 'App/backdoor.entitlements',
    'iOS/Views/TabbarView.swift': 'App/Views/TabbarView.swift',
    
    # iOS → Core
    'iOS/Common/': 'Core/Common/',
    'iOS/Extensions/': 'Core/Extensions/',
    'iOS/Utilities/': 'Core/Utilities/',
    
    # Shared → Core
    'Shared/Data/': 'Core/Data/',
    'Shared/Logging/': 'Core/Logging/',
    'Shared/Management/': 'Core/Services/',
    'Shared/Server/': 'Core/Server/',
    'Shared/Localizations/': 'Core/Localization/',
    
    # iOS → Features
    'iOS/Views/AI Assistant/': 'Features/AI/Views/',
    'iOS/Views/Home/': 'Features/Home/Views/',
    'iOS/Views/Apps/': 'Features/Library/Views/',
    'iOS/Views/Settings/': 'Features/Settings/Views/',
    'iOS/Views/Signing/': 'Features/Signing/Views/',
    'iOS/Views/Sources/': 'Features/Sources/Views/',
    'iOS/Views/Terminal/': 'Features/Terminal/Views/',
    'iOS/Debugger/': 'Features/Debugger/',
    'iOS/Operations/CoreML/': 'Features/AI/Services/CoreML/',
    'iOS/Operations/': 'Features/AI/Services/',
    'iOS/Models/': 'Features/Signing/Models/',
    
    # Shared → UI/Magic
    'Shared/Design/': 'UI/Design/',
    'iOS/Design/': 'UI/Design/',
    'Shared/Magic/': 'Magic/',
}

# Replace path entries in the project file
content = original_content
for old_path, new_path in path_mappings.items():
    # Handle paths with and without quotes
    content = content.replace(f'path = {old_path}', f'path = {new_path}')
    content = content.replace(f'path = "{old_path}', f'path = "{new_path}')

# Update group names
content = content.replace('name = iOS;', 'name = Features;')
content = content.replace('name = Shared;', 'name = Core;')

# Write the updated content back to the project file
with open(project_file, 'w') as f:
    f.write(content)

print("Updated project.pbxproj with new file paths")
