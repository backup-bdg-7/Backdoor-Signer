# Code Organization Guide

## Overview

This codebase is organized using a feature-first approach, where all code related to a specific feature is grouped together, regardless of its type (models, views, controllers, etc.). This makes the codebase more intuitive to navigate and maintain.

## Directory Structure

### App
Contains application-level code that is not specific to any particular feature.

- **Lifecycle**: Application lifecycle (AppDelegate, SceneDelegate)
- **Resources**: Assets, storyboards, and other resources
- **Launch**: Launch-related code
- **Configuration**: Application configuration

### Features
Contains all feature-specific code, with each feature having its own directory.

- **AIAssistant**: AI assistant feature
  - **Models**: Data models specific to AI
  - **Services**: AI services and logic
  - **UI**: UI components specific to AI
  - **Utils**: Utilities specific to AI

- **AppSigning**: App signing feature
  - **Models**: Signing data models
  - **Services**: Signing services and logic
  - **UI**: Signing UI components
  - **Utils**: Signing-specific utilities

- **FileManager**: File management feature
  - **Models**: File data models
  - **Services**: File operation services
  - **UI**: File management UI
  - **Utils**: File-specific utilities

- **AppLibrary**: App library management
  - **Models**: App data models
  - **Services**: App management services
  - **UI**: Library UI components
  - **Utils**: Library-specific utilities

- **AppSettings**: Settings feature
  - **Models**: Settings data models
  - **Services**: Settings services
  - **UI**: Settings UI components
  - **Utils**: Settings-specific utilities

- **SourceManager**: Source repositories management
  - **Models**: Source data models
  - **Services**: Source management services
  - **UI**: Source UI components
  - **Utils**: Source-specific utilities

- **Terminal**: Terminal feature
  - **Models**: Terminal data models
  - **Services**: Terminal services
  - **UI**: Terminal UI components
  - **Utils**: Terminal-specific utilities

- **Debugger**: Debugging functionality
  - **Core**: Core debugging functionality
  - **UI**: Debugging UI

### Core
Contains core functionality used across multiple features.

- **Data**: Data management
  - **CoreData**: CoreData models and utilities
  - **UserDefaults**: UserDefaults extensions and utilities
  - **Models**: Shared data models

- **Networking**: Networking utilities
- **Extensions**: Framework extensions
- **Services**: Shared services
- **Utils**: Shared utilities
- **Constants**: Global constants
- **Localization**: Localization resources

### UI
Contains UI components and utilities used across multiple features.

- **Components**: Reusable UI components
- **Theme**: Theme and design system
- **BaseClasses**: Base UI classes
- **Extensions**: UI-specific extensions
- **Helpers**: UI helper utilities

### Security
Contains security-related code.

- **Encryption**: Encryption utilities
- **Signing**: Code signing utilities
- **Utils**: Security utilities

## Principles

1. **Feature-First**: All code specific to a feature is grouped together
2. **Minimum Duplication**: Shared components are placed in Core, UI, or Security
3. **Clear Boundaries**: Each feature has clear boundaries
4. **Intuitive Navigation**: Easy to find related code
5. **Consistent Structure**: Each feature follows the same internal structure

## Guidelines for Adding New Code

1. If code is specific to a feature, add it to the appropriate feature directory
2. If code is used by multiple features, add it to Core, UI, or Security
3. Follow the existing naming conventions and structure
4. Update this document if you introduce new structural elements
