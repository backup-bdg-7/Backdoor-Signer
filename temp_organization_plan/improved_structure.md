# Improved Directory Structure for Backdoor Signer

## Core Principles
- Single responsibility for each module
- Consistent organization within features
- No duplicate or nested directories
- Clear boundaries between modules
- Intuitive navigation for developers

## Main Structure
- App/ - Application lifecycle and entry points
- Core/ - Foundational services and infrastructure
- Features/ - Feature modules organized by domain
- UI/ - Shared UI components and design system
- Magic/ - Specialized low-level signing implementation
- Configuration/ - Project configuration files
- Documentation/ - Documentation files

## Detailed Structure

### App/
- AppDelegate.swift
- Info.plist
- Resources/ - Assets, storyboards, resource files
- Lifecycle/ - App lifecycle management

### Core/
- Common/ - Common application utilities
- Data/ - Data persistence
  - CoreData/ - CoreData models and extensions
  - UserDefaults/ - UserDefaults extensions
- Error/ - Error types and handling
- Extensions/ - System framework extensions
  - UIKit/ - UIKit extensions
  - Foundation/ - Foundation extensions
  - CoreGraphics/ - CG extensions
- Localization/ - Localization resources
- Logging/ - Logging infrastructure
- Networking/ - Networking components
- Security/ - Security-related services
- Server/ - Server interaction
- Services/ - Core application services
- Threading/ - Threading utilities
- Utilities/ - Shared utility functions

### Features/
Each feature follows this consistent structure:
- AI/
  - Models/ - Data models
  - Services/ - Business logic
  - Views/ - UI components
  - Coordinators/ - Navigation/flow control
- Debugger/
  - Models/
  - Services/
  - Views/
- Home/
  - Models/
  - Services/
  - Views/
- Hub/
  - Models/
  - Services/
  - Views/
- Library/
  - Models/
  - Services/
  - Views/
- Settings/
  - Models/
  - Services/
  - Views/
  - Modules/ - Sub-feature specific modules
    - AILearning/
    - About/
    - AppIcon/
    - Certificates/
    - Display/
    - Reset/
    - Search/
    - Server/
    - Terminal/
- Signing/
  - Models/
  - Services/
  - Views/
- Sources/
  - Models/
  - Services/
  - Views/
- Terminal/
  - Models/
  - Services/
  - Views/

### UI/
- Components/ - Reusable UI components
  - Buttons/
  - Cards/
  - Cells/
  - Inputs/
  - Labels/
  - Modals/
- Design/ - Design system
  - Colors/
  - Fonts/
  - Icons/
  - Styles/
- Base/ - Base UI classes
  - Controllers/
  - Views/
- Helpers/ - UI-specific helpers
- Modifiers/ - View modifiers

### Magic/
- AppSigner.swift
- Encryption/
- Decompression/
- Sign/
- Utils/
