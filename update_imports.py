#!/usr/bin/env python3

import os
import re
import sys

def update_imports(file_path):
    """Update import statements in a Swift file"""
    with open(file_path, 'r') as f:
        content = f.read()
    
    # Define import mappings
    import_mappings = {
        'import iOS.Extensions': 'import Core.Extensions',
        'import iOS.Common': 'import Core.Common',
        'import iOS.Utilities': 'import Core.Utilities',
        'import iOS.Models': 'import Features.Signing.Models',
        'import iOS.Operations': 'import Features.AI.Services',
        'import iOS.Operations.CoreML': 'import Features.AI.Services.CoreML',
        'import iOS.Debugger': 'import Features.Debugger',
        'import iOS.Views.AI': 'import Features.AI.Views',
        'import iOS.Views.Home': 'import Features.Home.Views',
        'import iOS.Views.Apps': 'import Features.Library.Views',
        'import iOS.Views.Settings': 'import Features.Settings.Views',
        'import iOS.Views.Signing': 'import Features.Signing.Views',
        'import iOS.Views.Sources': 'import Features.Sources.Views',
        'import iOS.Views.Terminal': 'import Features.Terminal.Views',
        'import iOS.Delegates': 'import App',
        'import Shared.Data': 'import Core.Data',
        'import Shared.Logging': 'import Core.Logging',
        'import Shared.Management': 'import Core.Services',
        'import Shared.Design': 'import UI.Design',
        'import Shared.Localizations': 'import Core.Localization',
        'import Shared.Magic': 'import Magic',
        'import Shared.Server': 'import Core.Server',
    }
    
    # Apply all mappings
    for old_import, new_import in import_mappings.items():
        content = content.replace(old_import, new_import)
    
    # Write updated content
    with open(file_path, 'w') as f:
        f.write(content)
    
    return True

def update_directory(directory):
    """Update imports in all Swift files in a directory recursively"""
    count = 0
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('.swift'):
                file_path = os.path.join(root, file)
                if update_imports(file_path):
                    count += 1
                    print(f"Updated imports in {file_path}")
    
    print(f"Updated imports in {count} files")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 update_imports.py <directory>")
        sys.exit(1)
    
    directory = sys.argv[1]
    update_directory(directory)
