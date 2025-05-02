#!/usr/bin/env python3

import os

# Read the current project file
project_file = "backdoor.xcodeproj/project.pbxproj"
with open(project_file, 'r') as f:
    content = f.read()

# Additional path mappings that might have been missed
additional_mappings = {
    'path = iOS/Info.plist': 'path = App/Info.plist',
    'path = "iOS/Info.plist"': 'path = "App/Info.plist"',
    'path = Shared/Resources/ellekit.deb': 'path = App/Resources/Frameworks/ellekit.deb',
    'path = "Shared/Resources/ellekit.deb"': 'path = "App/Resources/Frameworks/ellekit.deb"',
    'path = Shared/Data/Backdoor.xcdatamodeld': 'path = Core/Data/Backdoor.xcdatamodeld',
    'path = "Shared/Data/Backdoor.xcdatamodeld"': 'path = "Core/Data/Backdoor.xcdatamodeld"',
    'path = iOS/Views/Extra/': 'path = UI/Views/Extra/',
    'path = "iOS/Views/Extra/"': 'path = "UI/Views/Extra/"',
    'path = iOS/Views/Hub/': 'path = Features/Hub/Views/',
    'path = "iOS/Views/Hub/"': 'path = "Features/Hub/Views/"',
    'path = iOS/Management/': 'path = Core/Services/',
    'path = "iOS/Management/"': 'path = "Core/Services/"',
}

# Apply the additional mappings
for old_path, new_path in additional_mappings.items():
    content = content.replace(old_path, new_path)

# Fix Resources folder references, ensure we don't have duplicated paths
content = content.replace('path = App/Resources/Resources/', 'path = App/Resources/')
content = content.replace('path = "App/Resources/Resources/"', 'path = "App/Resources/"')

# Write the updated content
with open(project_file, 'w') as f:
    f.write(content)

print("Final update of project.pbxproj completed")
