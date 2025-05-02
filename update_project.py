#!/usr/bin/env python3

import os
import re
import shutil

# Backup the project file
project_file = "backdoor.xcodeproj/project.pbxproj"
backup_file = project_file + ".backup2"

if not os.path.exists(backup_file):
    shutil.copy2(project_file, backup_file)
    print(f"Created backup: {backup_file}")

# Read the project file
with open(project_file, 'r') as f:
    content = f.read()

# Define path mappings
path_mappings = {
    # App module
    'path = iOS/Delegates/': 'path = App/',
    'path = iOS/Resources/': 'path = App/Resources/',
    'path = "iOS/Delegates/': 'path = "App/',
    'path = "iOS/Resources/': 'path = "App/Resources/',
    'path = iOS/backdoor.entitlements': 'path = App/backdoor.entitlements',
    
    # Core module
    'path = iOS/Common/': 'path = Core/Common/',
    'path = iOS/Extensions/': 'path = Core/Extensions/',
    'path = iOS/Utilities/': 'path = Core/Utilities/',
    'path = "iOS/Common/': 'path = "Core/Common/',
    'path = "iOS/Extensions/': 'path = "Core/Extensions/',
    'path = "iOS/Utilities/': 'path = "Core/Utilities/',
    'path = Shared/Data/': 'path = Core/Data/',
    'path = Shared/Logging/': 'path = Core/Logging/',
    'path = Shared/Management/': 'path = Core/Services/',
    'path = Shared/Server/': 'path = Core/Server/',
    'path = Shared/Localizations/': 'path = Core/Localization/',
    'path = "Shared/Data/': 'path = "Core/Data/',
    'path = "Shared/Logging/': 'path = "Core/Logging/',
    'path = "Shared/Management/': 'path = "Core/Services/',
    'path = "Shared/Server/': 'path = "Core/Server/',
    'path = "Shared/Localizations/': 'path = "Core/Localization/',
    
    # Features module
    'path = iOS/Views/AI': 'path = Features/AI/Views',
    'path = iOS/Views/Home/': 'path = Features/Home/Views/',
    'path = iOS/Views/Apps/': 'path = Features/Library/Views/',
    'path = iOS/Views/Settings/': 'path = Features/Settings/Views/',
    'path = iOS/Views/Signing/': 'path = Features/Signing/Views/',
    'path = iOS/Views/Sources/': 'path = Features/Sources/Views/',
    'path = iOS/Views/Terminal/': 'path = Features/Terminal/Views/',
    'path = iOS/Views/Hub/': 'path = Features/Hub/Views/',
    'path = iOS/Debugger/': 'path = Features/Debugger/',
    'path = iOS/Operations/': 'path = Features/AI/Services/',
    'path = iOS/Models/': 'path = Features/Signing/Models/',
    'path = "iOS/Views/AI': 'path = "Features/AI/Views',
    'path = "iOS/Views/Home/': 'path = "Features/Home/Views/',
    'path = "iOS/Views/Apps/': 'path = "Features/Library/Views/',
    'path = "iOS/Views/Settings/': 'path = "Features/Settings/Views/',
    'path = "iOS/Views/Signing/': 'path = "Features/Signing/Views/',
    'path = "iOS/Views/Sources/': 'path = "Features/Sources/Views/',
    'path = "iOS/Views/Terminal/': 'path = "Features/Terminal/Views/',
    'path = "iOS/Views/Hub/': 'path = "Features/Hub/Views/',
    'path = "iOS/Debugger/': 'path = "Features/Debugger/',
    'path = "iOS/Operations/': 'path = "Features/AI/Services/',
    'path = "iOS/Models/': 'path = "Features/Signing/Models/',
    
    # UI module
    'path = Shared/Design/': 'path = UI/Design/',
    'path = "Shared/Design/': 'path = "UI/Design/',
    'path = iOS/Design/': 'path = UI/Design/',
    'path = "iOS/Design/': 'path = "UI/Design/',
    'path = iOS/Views/Extra/': 'path = UI/Components/',
    'path = "iOS/Views/Extra/': 'path = "UI/Components/',
    
    # Magic module
    'path = Shared/Magic/': 'path = Magic/',
    'path = "Shared/Magic/': 'path = "Magic/',
    
    # Fix Settings modules
    'path = Features/Settings/Views/Settings/AI Learning/': 'path = Features/Settings/Modules/AILearning/',
    'path = Features/Settings/Views/Settings/About/': 'path = Features/Settings/Modules/About/',
    'path = Features/Settings/Views/Settings/AppIcon/': 'path = Features/Settings/Modules/AppIcon/',
    'path = Features/Settings/Views/Settings/Certificates/': 'path = Features/Settings/Modules/Cer# Let's create a new branch for the refined approach
git checkout -b codebase-grouped-organization

# Now let's create a more cohesively grouped directory structure
echo "=== Creating strictly grouped directory structure ==="

# Clear previous organization to start fresh
rm -rf App Core Features Magic UI

# Create the main directory structure with more specific functional grouping
mkdir -p App/Delegates # All delegate files together
mkdir -p App/Resources/{Assets,Frameworks} # Resources grouped by type

# Create feature directories that group all related files together
mkdir -p Features/AI # All AI code goes here
mkdir -p Features/AI/{Models,Services,Views,Helpers} # Subdirectories by file type
mkdir -p Features/Debugger # All debugger code goes here
mkdir -p Features/Signing # All signing code goes here
mkdir -p Features/Signing/{Models,Utils,Views,Data} # Group by purpose
mkdir -p Features/Terminal # All terminal code goes here
mkdir -p Features/Settings # All settings code goes here
mkdir -p Features/Sources # All sources code goes here
mkdir -p Features/Home # All home code goes here
mkdir -p Features/Library # All library code goes here

# Core functionality strictly grouped by purpose
mkdir -p Core/Extensions # All extensions in one place
mkdir -p Core/Extensions/{UIKit,Foundation,SwiftUI} # Group by framework
mkdir -p Core/Data # All data management
mkdir -p Core/Data/{CoreData,UserDefaults} # Group by persistence type
mkdir -p Core/Services # All services
mkdir -p Core/Utilities # All utilities
mkdir -p Core/Network # All networking code
mkdir -p Core/Localization # All localization resources

# Group UI components by their purpose
mkdir -p UI/Components # All UI components in one place
mkdir -p UI/Components/{Buttons,Cards,Cells,Modals,Lists,Views}
mkdir -p UI/Design # All design system code
mkdir -p UI/Design/{Colors,Fonts,Icons,Styles,Theme}
mkdir -p UI/Base # Base UI classes

# All Magic code strictly grouped
mkdir -p Magic/Signing # All signing-specific code
mkdir -p Magic/Encryption # All encryption code
mkdir -p Magic/Decompression # All decompression utilities
mkdir -p Magic/Utils # Magic utilities

# Create documentation that explains this organization
mkdir -p Documentation

cat > Documentation/StrictCodeGrouping.md << 'EOF'
# Strict Code Grouping Guidelines

## Overview

The Backdoor Signer codebase follows a strictly grouped organization where all related code is consolidated in dedicated folders by functionality.

## Main Organizational Principles

1. **Group by functionality first** - All code related to a specific feature or functionality should be in one place
2. **Consistent internal structure** - Similar types of files within a functional group are organized the same way
3. **Clear boundaries** - Each functional group is self-contained with minimal dependencies on other groups
4. **Intuitive navigation** - Finding related code should be straightforward based on its functionality

## Directory Structure

```
BackdoorSigner/
 App/ - Application-specific code
   ├── Delegates/ - ALL delegate files grouped together
   └── Resources/ - ALL resources grouped together
 Features/ - Feature functionality grouped by domain
   ├── AI/ - ALL AI-related code in one place
   ├── Debugger/ - ALL debugger code in one place
   ├── Home/ - ALL home functionality in one place
   ├── Library/ - ALL library functionality in one place
   ├── Settings/ - ALL settings functionality in one place
   ├── Signing/ - ALL signing UI and logic in one place
   ├── Sources/ - ALL sources functionality in one place
   └── Terminal/ - ALL terminal functionality in one place
 Core/ - Core functionality grouped by purpose
   ├── Data/ - ALL data management code
   ├── Extensions/ - ALL extension methods
   ├── Localization/ - ALL localization resources
   ├── Network/ - ALL networking code
   ├── Services/ - ALL service classes
   └── Utilities/ - ALL utility functions
 UI/ - UI components grouped by type
   ├── Base/ - Base UI classes
   ├── Components/ - UI components organized by purpose
   └── Design/ - Design system elements
 Magic/ - Low-level signing implementation
    ├── Decompression/ - ALL decompression code
    ├── Encryption/ - ALL encryption code
    ├── Signing/ - ALL signing-specific code
    └── Utils/ - ALL signing utilities
```

## Key Differences from Traditional Organization

- Files are grouped strictly by their functional domain, not by architectural layer
- All related code is kept together regardless of type (models, services, views)
- Minimal cross-directory dependencies
- Finding all code related to a specific feature is straightforward

## Naming Conventions

- Directories should clearly indicate their purpose
- File names should follow a consistent pattern within each group
- Use prefixes when helpful to identify file purposes (e.g., AI prefixes for AI-related files)
