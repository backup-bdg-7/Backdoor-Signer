#!/usr/bin/env python3

import os
import re
import shutil

# Create backup of the project file
project_file = "backdoor.xcodeproj/project.pbxproj"
backup_file = project_file + ".strict.backup"

if not os.path.exists(backup_file):
    shutil.copy2(project_file, backup_file)
    print(f"Created backup: {backup_file}")

# Read the project file
with open(project_file, 'r') as f:
    content = f.read()

# Define mappings for strict organization (focus on functionality)
path_mappings = {
    # Delegate files
    'path = iOS/Delegates/': 'path = App/Delegates/',
    'path = "iOS/Delegates/': 'path = "App/Delegates/',
    
    # Resources
    'path = iOS/Resources/': 'path = App/Resources/',
    'path = "iOS/Resources/': 'path = "App/Resources/',
    
    # AI-related
    'path = iOS/Views/AI': 'path = Features/AI/Views',
    'path = "iOS/Views/AI': 'path = "Features/AI/Views',
    'path = iOS/Operations/CoreML/': 'path = Features/AI/Services/',
    'path = "iOS/Operations/CoreML/': 'path = "Features/AI/Services/',
    
    # Signing-related
    'path = iOS/Models/': 'path = Features/Signing/Models/',
    'path = "iOS/Models/': 'path = "Features/Signing/Models/',
    'path = iOS/Views/Signing/': 'path = Features/Signing/Views/',
    'path = "iOS/Views/Signing/': 'path = "Features/Signing/Views/',
    
    # Settings-related
    'path = iOS/Views/Settings/': 'path = Features/Settings/',
    'path = "iOS/Views/Settings/': 'path = "Features/Settings/',
    
    # Sources-related
    'path = iOS/Views/Sources/': 'path = Features/Sources/',
    'path = "iOS/Views/Sources/': 'path = "Features/Sources/',
    
    # Terminal-related
    'path = iOS/Views/Terminal/': 'path = Features/Terminal/',
    'path = "iOS/Views/Terminal/': 'path = "Features/Terminal/',
    
    # Home-related
    'path = iOS/Views/Home/': 'path = Features/Home/',
    'path = "iOS/Views/Home/': 'path = "Features/Home/',
    
    # Library-related
    'path = iOS/Views/Apps/': 'path = Features/Library/',
    'path = "iOS/Views/Apps/': 'path = "Features/Library/',
    
    # Debugger-related
    'path = iOS/Debugger/': 'path = Features/Debugger/',
    'path = "iOS/Debugger/': 'path = "Features/Debugger/',
    
    # Core components
    'path = iOS/Common/': 'path = Core/Common/',
    'path = "iOS/Common/': 'path = "Core/Common/',
    'path = iOS/Extensions/': 'path = Core/Extensions/',
    'path = "iOS/Extensions/': 'path = "Core/Extensions/',
    'path = iOS/Utilities/': 'path = Core/Utilities/',
    'path = "iOS/Utilities/': 'path = "Core/Utilities/',
    
    # Shared components
    'path = Shared/Data/': 'path = Core/Data/',
    'path = "Shared/Data/': 'path = "Core/Data/',
    'path = Shared/Logging/': 'path = Core/Logging/',
    'path = "Shared/Logging/': 'path = "Core/Logging/',
    'path = Shared/Management/': 'path = Core/Services/',
    'path = "Shared/Management/': 'path = "Core/Services/',
    'path = Shared/Server/': 'path = Core/Network/',
    'path = "Shared/Server/': 'path = "Core/Network/',
    'path = Shared/Localizations/': 'path = Core/Localization/',
    'path = "Shared/Localizations/': 'path = "Core/Localization/',
    
    # UI components
    'path = Shared/Design/': 'path = UI/Design/',
    'path = "Shared/Design/': 'path = "UI/Design/',
    'path = iOS/Design/': 'path = UI/Design/',
    'path = "iOS/Design/': 'path = "UI/Design/',
    'path = iOS/Views/Extra/': 'path = UI/Components/Modals/',
    'path = "iOS/Views/Extra/': 'path = "UI/Components/Modals/',
    
    # Magic components
    'path = Shared/Magic/': 'path = Magic/',
    'path = "Shared/Magic/': 'path = "Magic/',
}

# Apply all path mappings
for old_path, new_path in path_mappings.items():
    content = content.replace(old_path, new_path)

# Update group names
content = content.replace('name = iOS;', 'name = Features;')
content = content.replace('name = Shared;', 'name = Core;')

# Write the updated content
with open(project_file, 'w') as f:
    f.write(content)

print(f"Updated project file with new strict functional organization")
