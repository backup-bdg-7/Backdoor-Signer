# Codebase Reorganization

## Summary

This PR reorganizes the codebase structure for better maintainability, navigation, and organization without changing any logic or functionality.

## Changes

- Created a modern, feature-oriented directory structure that improves code organization
- Moved all files to appropriate locations within the new structure
- Updated project.pbxproj to reference the new file locations
- Updated import statements throughout the codebase
- Added documentation for the new structure

## New Directory Structure

```
BackdoorSigner/
 App/ - Application setup and lifecycle
 Core/ - Foundational services and utilities
 Features/ - Feature-oriented modules
 Magic/ - Low-level signing implementation
 UI/ - Shared UI elements and design system
```

## Benefits

1. Improved code discoverability - Files are organized by feature
2. Clear separation of concerns - Core vs. feature-specific code
3. Better maintainability - Related code is grouped together
4. Simplified development - Adding new features is more straightforward
5. Reduced dependencies - Feature boundaries are more clearly defined

## Testing

All existing functionality remains identical - only the organization has changed.
