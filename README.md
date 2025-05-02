# Backdoor Signer

This codebase has been reorganized for better maintainability, navigation, and performance.

## Directory Structure

```
BackdoorSigner/
 App/ - Application setup and lifecycle
   ├── AppDelegate.swift - Main application entry point
   ├── Extensions/ - App delegate extensions
   ├── Resources/ - Assets and resources
   └── Views/ - Main app-level views
 Core/ - Foundational services and utilities
   ├── Common/ - Common application components
   ├── Data/ - Data management (CoreData, UserDefaults)
   ├── Extensions/ - System component extensions
   ├── Logging/ - App logging functionality
   ├── Networking/ - Network communication layer
   ├── Server/ - Server interaction
   ├── Services/ - Core application services
   └── Utilities/ - Shared helper utilities
 Features/ - Feature-oriented modules
   ├── AI/ - AI Assistant functionality
   ├── Debugger/ - Debugging capabilities
   ├── Home/ - File management features
   ├── Library/ - App library management
   ├── Settings/ - Application settings
   ├── Signing/ - App signing functionality
   ├── Sources/ - Repository sources management
   └── Terminal/ - Terminal functionality
 Magic/ - Low-level signing implementation
   ├── AppSigner.swift - Main signing functionality
   ├── zsign/ - Zsign implementation
   └── decompression/ - Decompression utilities
 UI/ - Shared UI elements and design system
    ├── Base/ - Base view controllers
    ├── Components/ - Reusable UI components
    ├── Design/ - Design system
    └── Views/ - Shared views
```

## Feature Organization

Each feature follows a consistent structure:

```
Feature/
 Models/ - Data structures
 Services/ - Business logic
 Views/ - UI controllers and views
 Components/ - Reusable UI elements
```

This organization provides several benefits:
1. Improved code discoverability
2. Reduced coupling between components
3. Better maintainability and scalability
4. Clearer architectural boundaries
