# Code Organization Guidelines

## Overview

The Backdoor Signer codebase follows a modular, feature-oriented architecture designed for maintainability, testability, and scalability.

## Directory Structure

```
BackdoorSigner/
 App/ - Application lifecycle and entry points
 Core/ - Foundational services and infrastructure
 Features/ - Feature modules organized by domain
 UI/ - Shared UI components and design system
 Magic/ - Specialized low-level signing implementation
 Configuration/ - Project configuration files
 Documentation/ - Documentation files
```

## Module Guidelines

### App Module
Contains application-level components and resources:
- AppDelegate and lifecycle management
- Resources (assets, storyboards, etc.)
- Application-wide configuration

### Core Module
Contains foundational components used across the app:
- Extensions - Framework extensions organized by the framework they extend
- Data - Data persistence mechanisms (CoreData, UserDefaults)
- Networking - Network communication
- Services - Core application services
- Utilities - Shared utility functions

### Features Module
Each feature is a self-contained module with its own:
- Models - Domain models and data structures
- Services - Business logic and use cases
- Views - UI components specific to the feature
- Coordinators - Navigation and flow control

### UI Module
Contains shared UI components and design system:
- Components - Reusable UI components organized by type
- Design - Design system (colors, typography, etc.)
- Base - Base classes for UI components

### Magic Module
Contains low-level signing implementation:
- Encryption - Encryption utilities
- Decompression - File decompression utilities
- Sign - Signing implementation
- Utils - Signing-specific utilities

## Dependency Rules

1. App depends on Features, Core, UI, and Magic
2. Features depend on Core and UI
3. UI depends on Core
4. Core has no dependencies on other modules
5. Magic may depend on Core

## Import Guidelines

- Use explicit imports (e.g., `import Core.Extensions.UIKit`)
- Avoid importing entire modules when only a specific component is needed
- Keep imports organized and grouped by module

## Naming Conventions

- Files should be named according to their primary type/class
- Use clear, descriptive names that indicate functionality
- Follow Swift naming conventions (e.g., CamelCase for types, camelCase for variables)
