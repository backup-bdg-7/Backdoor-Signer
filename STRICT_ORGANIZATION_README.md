# Strictly Grouped Code Organization

The codebase has been reorganized with a strict focus on grouping related functionality together. This new organization prioritizes finding all code related to a specific feature or function in one dedicated location.

## Main Structure

- **App/** - Contains ALL application lifecycle components
  - **Delegates/** - ALL delegate files in one place
  - **Resources/** - ALL resources organized by type

- **Features/** - Contains ALL feature-specific code
  - **AI/** - ALL AI-related code grouped together
  - **Debugger/** - ALL debugging functionality
  - **Home/** - ALL home screen functionality
  - **Library/** - ALL app library functionality
  - **Settings/** - ALL settings functionality
  - **Signing/** - ALL signing functionality
  - **Sources/** - ALL sources functionality
  - **Terminal/** - ALL terminal functionality

- **Core/** - Contains ALL core functionality
  - **Data/** - ALL data persistence code
  - **Extensions/** - ALL extensions grouped by framework
  - **Localization/** - ALL localization resources
  - **Network/** - ALL networking code
  - **Services/** - ALL service classes
  - **Utilities/** - ALL utility functions

- **UI/** - Contains ALL UI components
  - **Components/** - UI components organized by type
  - **Design/** - ALL design system elements
  - **Base/** - Base UI classes

- **Magic/** - Contains ALL low-level implementation
  - **Encryption/** - ALL encryption code
  - **Decompression/** - ALL decompression code
  - **Signing/** - ALL signing implementation
  - **Utils/** - ALL magic utilities

## Key Benefits

1. **Intuitive Navigation** - Finding all code related to a specific feature is straightforward
2. **Reduced Context Switching** - All related code is in one place
3. **Clear Ownership** - Each functional area has a dedicated location
4. **Better Maintainability** - Easier to understand what code belongs where
5. **Improved Collaboration** - Clearer boundaries between different parts of the codebase

## Documentation

For detailed organization guidelines, see `Documentation/StrictCodeGrouping.md`.
