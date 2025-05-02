# Path Changes Reference

This document shows how file paths will change in the reorganized structure.

## Removing Duplicate Directories
- ~~`Core/Data/UserDefaults/UserDefaults`~~ → Files moved to `Core/Data/UserDefaults`
- ~~`Shared/Data/Backdoor.xcdatamodeld`~~ → Using version in `Core/Data/Backdoor.xcdatamodeld`
- ~~`iOS/Views/Extra`~~ → Using version in `UI/Views/Extra`

## Moving iOS-Specific Files
- `iOS/Views/AI.swift` → `Features/AI/Views/AI.swift`

## Keeping Critical Paths (to minimize project file changes)
- `App/backdoor.entitlements` (unchanged)
- `App/Info.plist` (unchanged)

## Project References That Need Updating
- Any imports that reference the old paths
- Project file references in backdoor.xcodeproj/project.pbxproj
