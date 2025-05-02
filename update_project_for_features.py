#!/usr/bin/env python3

import os
import re
import shutil

# Backup the project file
project_file = "backdoor.xcodeproj/project.pbxproj"
backup_file = project_file + ".feature.backup"

if not os.path.exists(backup_file):
    shutil.copy2(project_file, backup_file)
    print(f"Created backup: {backup_file}")

# Read the project file
with open(project_file, 'r') as f:
    content = f.read()

# Define mappings for feature-based organization
path_mappings = {
    # App
    'path = iOS/Delegates/': 'path = App/Lifecycle/',
    'path = "iOS/Delegates/': 'path = "App/Lifecycle/',
    'path = iOS/Resources/': 'path = App/Resources/',
    'path = "iOS/Resources/': 'path = "App/Resources/',
    'path = iOS/Info.plist': 'path = App/Configuration/Info.plist',
    'path = "iOS/Info.plist"': 'path = "App/Configuration/Info.plist"',
    'path = iOS/backdoor.entitlements': 'path = App/Configuration/backdoor.entitlements',
    'path = "iOS/backdoor.entitlements"': 'path = "App/Configuration/backdoor.entitlements"',
    
    # AI Assistant
    'path = iOS/Views/AI': 'path = Features/AIAssistant/UI',
    'path = "iOS/Views/AI': 'path = "Features/AIAssistant/UI',
    'path = iOS/Operations/CoreML/': 'path = Features/AIAssistant/Services/',
    'path = "iOS/Operations/CoreML/': 'path = "Features/AIAssistant/Services/',
    
    # File Manager
    'path = iOS/Views/Home/': 'path = Features/FileManager/UI/',
    'path = "iOS/Views/Home/': 'path = "Features/FileManager/UI/',
    
    # App Library
    'path = iOS/Views/Apps/': 'path = Features/AppLibrary/UI/',
    'path = "iOS/Views/Apps/': 'path = "Features/AppLibrary/UI/',
    
    # App Settings
    'path = iOS/Views/Settings/': 'path = Features/AppSettings/UI/',
    'path = "iOS/Views/Settings/': 'path = "Features/AppSettings/UI/',
    
    # App Signing
    'path = iOS/Views/Signing/': 'path = Features/AppSigning/UI/',
    'path = "iOS/Views/Signing/': 'path = "Features/AppSigning/UI/',
    'path = iOS/Models/': 'path = Features/AppSigning/Models/',
    'path = "iOS/Models/': 'path = "Features/AppSigning/Models/',
    
    # Source Manager
    'path = iOS/Views/Sources/': 'path = Features/SourceManager/UI/',
    'path = "iOS/Views/Sources/': 'path = "Features/SourceManager/UI/',
    
    # Terminal
    'path = iOS/Views/Terminal/': 'path = Features/Terminal/UI/',
    'path = "iOS/Views/Terminal/': 'path = "Features/Terminal/UI/',
    
    # Debugger
    'path = iOS/Debugger/Core/': 'path = Features/Debugger/Core/',
    'path = "iOS/Debugger/Core/': 'path = "Features/Debugger/Core/',
    'path = iOS/Debugger/UI/': 'path = Features/Debugger/UI/',
    'path = "iOS/Debugger/UI/': 'path = "Features/Debugger/UI/',
    'path = iOS/Debugger/': 'path = Features/Debugger/',
    'path = "iOS/Debugger/': 'path = "Features/Debugger/',
    
    # Core
    'path = iOS/Common/': 'path = Core/Utils/',
    'path = "iOS/Common/': 'path = "Core/Utils/',
    'path = iOS/Extensions/': 'path = Core/Extensions/',
    'path = "iOS/Extensions/': 'path = "Core/Extensions/',
    'path = iOS/Utilities/': 'path = Core/Utils/',
    'path = "iOS/Utilities/': 'path = "Core/Utils/',
    'path = Shared/Data/': 'path = Core/Data/',
    'path = "Shared/Data/': 'path = "Core/Data/',
    'path = Shared/Logging/': 'path = Core/Utils/',
    'path = "Shared/Logging/': 'path = "Core/Utils/',
    'path = Shared/Management/': 'path = Core/Services/',
    'path = "Shared/Management/': 'path = "Core/Services/',
    'path = Shared/Server/': 'path = Core/Networking/',
    'path = "Shared/Server/': 'path = "Core/Networking/',
    'path = Shared/Localizations/': 'path = Core/Localization/',
    'path = "Shared/Localizations/': 'path = "Core/Localization/',
    
    # UI
    'path = Shared/Design/': 'path = UI/Theme/',
    'path = "Shared/Design/': 'path = "UI/Theme/',
    'path = iOS/Design/': 'path = UI/Theme/',
    'path = "iOS/Design/': 'path = "UI/Theme/',
    'path = iOS/Views/Extra/': 'path = UI/Components/Modals/',
    'path = "iOS/Views/Extra/': 'path = "UI/Components/Modals/',
    
    # Security
    'path = Shared/Magic/': 'path = Security/Utils/',
    'path = "Shared/Magic/': 'path = "Security/Utils/',
    'path = Shared/Magic/decompression/': 'path = Security/Utils/decompression/',
    'path = "Shared/Magic/decompression/': 'path = "Security/Utils/decompression/',
    'path = Shared/Magic/zsign/': 'path = Security/Signing/zsign/',
    'path = "Shared/Magic/zsign/': 'path = "Security/Signing/zsign/',
}

# Apply all path mappings
for old_path, new_path in path_mappings.items():
    content = content.replace(old_path, new_path)

# Update group names to better reflect features
content = content.replace('name = iOS;', 'name = Features;')
content = content.replace('name = Shared;', 'name = Core;')

# Write the updated content
with open(project_file, 'w') as f:
    f.write(content)

print(f"Updated project file for feature-based organization")
