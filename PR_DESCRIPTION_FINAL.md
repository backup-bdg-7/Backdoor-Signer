# Codebase Reorganization Pull Request

## Overview
This PR reorganizes the entire codebase into a more maintainable, modular structure that follows modern iOS development practices. The reorganization improves code discoverability, reduces coupling between components, and makes the codebase easier to navigate and maintain.

## Changes
- Created a feature-oriented module structure
- Moved all files to appropriate new locations
- Updated project.pbxproj file to reference the new structure
- Fixed duplicated and nested directories
- Created clear separation between app, core, features, UI, and magic components

## New Directory Structure
```
BackdoorSigner/
 App/ - Application setup and lifecycle
 Core/ - Foundational services and utilities
 Features/ - Feature-oriented modules
 Magic/ - Low-level signing implementation
 UI/ - Shared UI elements and design system
```

## Features
Each feature follows a consistent structure:
- Models/ - Data structures
- Services/ - Business logic
- Views/ - UI controllers and views
- Components/ - Reusable UI elements

## Benefits
1. **Improved Discoverability**: Related files are grouped together by feature
2. **Clear Architecture**: Better separation of concerns between layers
3. **Better Maintainability**: Modular structure makes updates easier
4. **Simplified Development**: Adding new features has a clear pattern to follow
5. **Reduced Dependencies**: Feature boundaries are more clearly defined

## Testing Instructions
- Pull the branch and open the project in Xcode
- Verify that the project builds successfully
- Run the app to verify that all functionality works as expected

**Note**: No functional changes were made as part of this reorganization, only structural changes.
