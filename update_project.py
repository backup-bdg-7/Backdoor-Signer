#!/usr/bin/env python3

import os
import shutil

# Create a backup of the project file if it doesn't exist
project_file = "backdoor.xcodeproj/project.pbxproj"
backup_file = project_file + ".backup"
if not os.path.exists(backup_file):
    shutil.copy2(project_file, backup_file)
    print(f"Created backup: {backup_file}")
else:
    print(f"Using existing backup: {backup_file}")

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
    ('path = iOS/Design/', 'path = UI/Design/'),
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
    ('path = "iOS/Design/', 'path = "UI/Design/'),
    ('path = "Shared/Magic/', 'path = "Magic/'),
    
    # Update group names
    ('name = iOS;', 'name = Features;'),
    ('name = Shared;', 'name = Core;'),
]

# Apply replacements
modified = False
for old_path, new_path in mappings:
    if old_path in content:
        content = content.replace(old_path, new_path)
        modified = True
        print(f"Replaced: {old_path} -> {new_path}")

# Write the updated content if modified
if modified:
    with open(project_file, 'w') as f:
        f.write(content)
    print("Updated project.pbxproj with new paths")
else:
    print("No changes needed in project.pbxproj")
