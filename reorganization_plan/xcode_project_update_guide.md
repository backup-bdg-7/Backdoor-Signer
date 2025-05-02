# Xcode Project Update Guide

After reorganizing the codebase, you'll need to update your Xcode project to reflect the new file structure. Here's a step-by-step guide to help you through this process.

## Before You Begin

1. Make sure you have the backup copy available in `./backup_before_reorganization`
2. Have Xcode installed and ready to open the project

## Updating the Project

### Method 1: Via Xcode (Recommended)

1. **Open the project in Xcode**
   - Open `backdoor.xcodeproj`
   - Xcode may show missing file references (red files in the project navigator)

2. **Remove references to deleted files**
   - Right-click on any red file references
   - Select "Delete" (choose "Remove Reference" not "Move to Trash")
   - This includes:
     - Empty files we removed
     - Duplicate UserDefaults directory
     - Duplicate CoreData model in Shared directory

3. **Update file references for moved files**
   - For `iOS/Views/AI.swift` that was moved to `Features/AI/Views/AI.swift`:
     - First, remove the reference to the old file location
     - Then Add the new file: File > Add Files to "backdoor"... > navigate to the new location

4. **Verify file structure in project navigator**
   - Make sure the project organization matches our new directory structure
   - Any red files indicate missing references that need to be fixed

5. **Update any build settings referencing specific paths**
   - In Xcode, select the project in the navigator
   - Select the "backdoor" target
   - Check "Build Settings" for any paths that need updating:
     - Search for "path" to find relevant settings
     - Check Info.plist and entitlements references

### Method 2: Manual Project File Editing (Advanced)

If you're comfortable editing the project.pbxproj file directly:

1. Open `backdoor.xcodeproj/project.pbxproj` in a text editor
2. Search for paths to files we've moved or deleted
3. Update these paths to reflect the new locations
4. This is recommended only if you're familiar with the Xcode project file format

## Testing Your Changes

1. **Try building the project**
   - Cmd+B or Product > Build
   - Address any compiler errors related to file paths

2. **Verify all features work**
   - Run the app and check all features that might be affected by moved files
   - Pay special attention to features related to the areas we reorganized

## Common Issues and Solutions

### Missing Files
- **Problem**: Red files in project navigator
- **Solution**: Remove the reference and add the file from its new location

### Build Errors
- **Problem**: "File not found" errors during build
- **Solution**: Check that the file exists at the referenced path and update if needed

### Import Errors
- **Problem**: "No such module" or "Import could not be resolved"
- **Solution**: Check import statements in files, they may need to be updated for the new structure

### Info.plist Errors
- **Problem**: "Info.plist file not found"
- **Solution**: Update the Info.plist path in build settings

## Final Steps

Once everything builds and works correctly, you can:

1. **Remove the iOS directory** now that its unique content has been moved
2. **Clean up the backup** if you're satisfied with the reorganization
3. **Commit your changes** to version control with a clear message about the reorganization

If you encounter any issues, you can always revert to the backup we created before the reorganization.
