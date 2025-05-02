import Foundation
import UIKit

/// TerminalFileManager provides file system operations for the Terminal interface
/// This class handles file operations like listing, copying, moving, and deleting files
class TerminalFileManager {
    // MARK: - Singleton
    
    /// Shared instance for singleton access
    static let shared = TerminalFileManager()
    
    /// Private initializer to enforce singleton pattern
    private init() {
        // Initialize file manager
        fileManager = FileManager.default
        
        // Set up initial working directory
        currentDirectory = documentsDirectory
    }
    
    // MARK: - Properties
    
    /// File manager instance for file operations
    private let fileManager: FileManager
    
    /// Current working directory
    private(set) var currentDirectory: URL
    
    /// Documents directory URL
    var documentsDirectory: URL {
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    /// Application support directory URL
    var applicationSupportDirectory: URL {
        let paths = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    /// Temporary directory URL
    var temporaryDirectory: URL {
        return fileManager.temporaryDirectory
    }
    
    // MARK: - Directory Navigation
    
    /// Change the current working directory
    /// - Parameter path: The path to change to (absolute or relative)
    /// - Returns: Result of the operation
    func changeDirectory(to path: String) -> Result<String, TerminalFileError> {
        let targetURL: URL
        
        if path.hasPrefix("/") {
            // Absolute path
            targetURL = URL(fileURLWithPath: path)
        } else if path == ".." {
            // Parent directory
            targetURL = currentDirectory.deletingLastPathComponent()
        } else if path == "~" {
            // Home directory
            targetURL = documentsDirectory
        } else {
            // Relative path
            targetURL = currentDirectory.appendingPathComponent(path)
        }
        
        // Check if directory exists
        var isDirectory: ObjCBool = false
        if fileManager.fileExists(atPath: targetURL.path, isDirectory: &isDirectory), isDirectory.boolValue {
            currentDirectory = targetURL
            return .success("Changed directory to \(targetURL.path)")
        } else {
            return .failure(.directoryNotFound(path: targetURL.path))
        }
    }
    
    /// Get the current working directory path
    /// - Returns: Current directory path
    func getCurrentDirectoryPath() -> String {
        return currentDirectory.path
    }
    
    // MARK: - File Operations
    
    /// List files in a directory
    /// - Parameters:
    ///   - path: Directory path (defaults to current directory)
    ///   - showHidden: Whether to show hidden files
    /// - Returns: Result containing array of file information or error
    func listFiles(at path: String? = nil, showHidden: Bool = false) -> Result<[FileInfo], TerminalFileError> {
        let targetURL: URL
        
        if let path = path {
            if path.hasPrefix("/") {
                // Absolute path
                targetURL = URL(fileURLWithPath: path)
            } else {
                // Relative path
                targetURL = currentDirectory.appendingPathComponent(path)
            }
        } else {
            // Current directory
            targetURL = currentDirectory
        }
        
        // Check if directory exists
        var isDirectory: ObjCBool = false
        if !fileManager.fileExists(atPath: targetURL.path, isDirectory: &isDirectory) || !isDirectory.boolValue {
            return .failure(.directoryNotFound(path: targetURL.path))
        }
        
        do {
            // Get directory contents
            let contents = try fileManager.contentsOfDirectory(at: targetURL, includingPropertiesForKeys: [
                .isDirectoryKey, .fileSizeKey, .creationDateKey, .contentModificationDateKey
            ])
            
            // Filter hidden files if needed
            let filteredContents = contents.filter { url in
                if !showHidden && url.lastPathComponent.hasPrefix(".") {
                    return false
                }
                return true
            }
            
            // Get file information
            var fileInfos: [FileInfo] = []
            for url in filteredContents {
                if let fileInfo = getFileInfo(for: url) {
                    fileInfos.append(fileInfo)
                }
            }
            
            // Sort by name
            fileInfos.sort { $0.name < $1.name }
            
            return .success(fileInfos)
        } catch {
            return .failure(.fileOperationFailed(message: error.localizedDescription))
        }
    }
    
    /// Get information about a file
    /// - Parameter url: File URL
    /// - Returns: FileInfo object or nil if error
    private func getFileInfo(for url: URL) -> FileInfo? {
        do {
            let resourceValues = try url.resourceValues(forKeys: [
                .isDirectoryKey, .fileSizeKey, .creationDateKey, .contentModificationDateKey
            ])
            
            let isDirectory = resourceValues.isDirectory ?? false
            let size = resourceValues.fileSize ?? 0
            let creationDate = resourceValues.creationDate ?? Date()
            let modificationDate = resourceValues.contentModificationDate ?? Date()
            
            return FileInfo(
                name: url.lastPathComponent,
                path: url.path,
                isDirectory: isDirectory,
                size: size,
                creationDate: creationDate,
                modificationDate: modificationDate
            )
        } catch {
            Debug.shared.log(message: "Error getting file info: \(error.localizedDescription)", type: .error)
            return nil
        }
    }
    
    /// Create a directory
    /// - Parameter path: Directory path (absolute or relative)
    /// - Returns: Result of the operation
    func createDirectory(at path: String) -> Result<String, TerminalFileError> {
        let targetURL: URL
        
        if path.hasPrefix("/") {
            // Absolute path
            targetURL = URL(fileURLWithPath: path)
        } else {
            // Relative path
            targetURL = currentDirectory.appendingPathComponent(path)
        }
        
        // Check if directory already exists
        var isDirectory: ObjCBool = false
        if fileManager.fileExists(atPath: targetURL.path, isDirectory: &isDirectory) {
            if isDirectory.boolValue {
                return .failure(.directoryAlreadyExists(path: targetURL.path))
            } else {
                return .failure(.fileAlreadyExists(path: targetURL.path))
            }
        }
        
        do {
            try fileManager.createDirectory(at: targetURL, withIntermediateDirectories: true)
            return .success("Created directory at \(targetURL.path)")
        } catch {
            return .failure(.fileOperationFailed(message: error.localizedDescription))
        }
    }
    
    /// Delete a file or directory
    /// - Parameters:
    ///   - path: File or directory path (absolute or relative)
    ///   - recursive: Whether to recursively delete directories
    /// - Returns: Result of the operation
    func delete(at path: String, recursive: Bool = false) -> Result<String, TerminalFileError> {
        let targetURL: URL
        
        if path.hasPrefix("/") {
            // Absolute path
            targetURL = URL(fileURLWithPath: path)
        } else {
            // Relative path
            targetURL = currentDirectory.appendingPathComponent(path)
        }
        
        // Check if file exists
        var isDirectory: ObjCBool = false
        if !fileManager.fileExists(atPath: targetURL.path, isDirectory: &isDirectory) {
            return .failure(.fileNotFound(path: targetURL.path))
        }
        
        // Check if it's a directory and recursive flag
        if isDirectory.boolValue && !recursive {
            return .failure(.directoryNotEmpty(path: targetURL.path))
        }
        
        do {
            try fileManager.removeItem(at: targetURL)
            return .success("Deleted \(isDirectory.boolValue ? "directory" : "file") at \(targetURL.path)")
        } catch {
            return .failure(.fileOperationFailed(message: error.localizedDescription))
        }
    }
    
    /// Copy a file or directory
    /// - Parameters:
    ///   - sourcePath: Source path (absolute or relative)
    ///   - destinationPath: Destination path (absolute or relative)
    /// - Returns: Result of the operation
    func copy(from sourcePath: String, to destinationPath: String) -> Result<String, TerminalFileError> {
        let sourceURL: URL
        let destinationURL: URL
        
        // Resolve source path
        if sourcePath.hasPrefix("/") {
            // Absolute path
            sourceURL = URL(fileURLWithPath: sourcePath)
        } else {
            // Relative path
            sourceURL = currentDirectory.appendingPathComponent(sourcePath)
        }
        
        // Resolve destination path
        if destinationPath.hasPrefix("/") {
            // Absolute path
            destinationURL = URL(fileURLWithPath: destinationPath)
        } else {
            // Relative path
            destinationURL = currentDirectory.appendingPathComponent(destinationPath)
        }
        
        // Check if source exists
        if !fileManager.fileExists(atPath: sourceURL.path) {
            return .failure(.fileNotFound(path: sourceURL.path))
        }
        
        // Check if destination already exists
        if fileManager.fileExists(atPath: destinationURL.path) {
            return .failure(.fileAlreadyExists(path: destinationURL.path))
        }
        
        do {
            try fileManager.copyItem(at: sourceURL, to: destinationURL)
            return .success("Copied from \(sourceURL.path) to \(destinationURL.path)")
        } catch {
            return .failure(.fileOperationFailed(message: error.localizedDescription))
        }
    }
    
    /// Move a file or directory
    /// - Parameters:
    ///   - sourcePath: Source path (absolute or relative)
    ///   - destinationPath: Destination path (absolute or relative)
    /// - Returns: Result of the operation
    func move(from sourcePath: String, to destinationPath: String) -> Result<String, TerminalFileError> {
        let sourceURL: URL
        let destinationURL: URL
        
        // Resolve source path
        if sourcePath.hasPrefix("/") {
            // Absolute path
            sourceURL = URL(fileURLWithPath: sourcePath)
        } else {
            // Relative path
            sourceURL = currentDirectory.appendingPathComponent(sourcePath)
        }
        
        // Resolve destination path
        if destinationPath.hasPrefix("/") {
            // Absolute path
            destinationURL = URL(fileURLWithPath: destinationPath)
        } else {
            // Relative path
            destinationURL = currentDirectory.appendingPathComponent(destinationPath)
        }
        
        // Check if source exists
        if !fileManager.fileExists(atPath: sourceURL.path) {
            return .failure(.fileNotFound(path: sourceURL.path))
        }
        
        // Check if destination already exists
        if fileManager.fileExists(atPath: destinationURL.path) {
            return .failure(.fileAlreadyExists(path: destinationURL.path))
        }
        
        do {
            try fileManager.moveItem(at: sourceURL, to: destinationURL)
            return .success("Moved from \(sourceURL.path) to \(destinationURL.path)")
        } catch {
            return .failure(.fileOperationFailed(message: error.localizedDescription))
        }
    }
    
    /// Read a file's contents as text
    /// - Parameter path: File path (absolute or relative)
    /// - Returns: Result containing file contents or error
    func readFile(at path: String) -> Result<String, TerminalFileError> {
        let fileURL: URL
        
        if path.hasPrefix("/") {
            // Absolute path
            fileURL = URL(fileURLWithPath: path)
        } else {
            // Relative path
            fileURL = currentDirectory.appendingPathComponent(path)
        }
        
        // Check if file exists
        var isDirectory: ObjCBool = false
        if !fileManager.fileExists(atPath: fileURL.path, isDirectory: &isDirectory) {
            return .failure(.fileNotFound(path: fileURL.path))
        }
        
        // Check if it's a directory
        if isDirectory.boolValue {
            return .failure(.isDirectory(path: fileURL.path))
        }
        
        do {
            let contents = try String(contentsOf: fileURL, encoding: .utf8)
            return .success(contents)
        } catch {
            return .failure(.fileOperationFailed(message: error.localizedDescription))
        }
    }
    
    /// Write text to a file
    /// - Parameters:
    ///   - text: Text to write
    ///   - path: File path (absolute or relative)
    ///   - append: Whether to append to existing file
    /// - Returns: Result of the operation
    func writeFile(text: String, to path: String, append: Bool = false) -> Result<String, TerminalFileError> {
        let fileURL: URL
        
        if path.hasPrefix("/") {
            // Absolute path
            fileURL = URL(fileURLWithPath: path)
        } else {
            // Relative path
            fileURL = currentDirectory.appendingPathComponent(path)
        }
        
        // Check if file exists and we're not appending
        if fileManager.fileExists(atPath: fileURL.path) && !append {
            return .failure(.fileAlreadyExists(path: fileURL.path))
        }
        
        do {
            if append, fileManager.fileExists(atPath: fileURL.path) {
                // Append to existing file
                let fileHandle = try FileHandle(forWritingTo: fileURL)
                fileHandle.seekToEndOfFile()
                if let data = text.data(using: .utf8) {
                    fileHandle.write(data)
                }
                fileHandle.closeFile()
            } else {
                // Create new file
                try text.write(to: fileURL, atomically: true, encoding: .utf8)
            }
            return .success("\(append ? "Appended to" : "Wrote") file at \(fileURL.path)")
        } catch {
            return .failure(.fileOperationFailed(message: error.localizedDescription))
        }
    }
    
    /// Get file attributes
    /// - Parameter path: File path (absolute or relative)
    /// - Returns: Result containing file attributes or error
    func getFileAttributes(at path: String) -> Result<[FileAttributeKey: Any], TerminalFileError> {
        let fileURL: URL
        
        if path.hasPrefix("/") {
            // Absolute path
            fileURL = URL(fileURLWithPath: path)
        } else {
            // Relative path
            fileURL = currentDirectory.appendingPathComponent(path)
        }
        
        // Check if file exists
        if !fileManager.fileExists(atPath: fileURL.path) {
            return .failure(.fileNotFound(path: fileURL.path))
        }
        
        do {
            let attributes = try fileManager.attributesOfItem(atPath: fileURL.path)
            return .success(attributes)
        } catch {
            return .failure(.fileOperationFailed(message: error.localizedDescription))
        }
    }
    
    /// Search for files matching a pattern
    /// - Parameters:
    ///   - pattern: Search pattern (glob-style)
    ///   - directory: Directory to search in (defaults to current directory)
    ///   - recursive: Whether to search recursively
    /// - Returns: Result containing matching files or error
    func findFiles(matching pattern: String, in directory: String? = nil, recursive: Bool = false) -> Result<[FileInfo], TerminalFileError> {
        let searchURL: URL
        
        if let directory = directory {
            if directory.hasPrefix("/") {
                // Absolute path
                searchURL = URL(fileURLWithPath: directory)
            } else {
                // Relative path
                searchURL = currentDirectory.appendingPathComponent(directory)
            }
        } else {
            // Current directory
            searchURL = currentDirectory
        }
        
        // Check if directory exists
        var isDirectory: ObjCBool = false
        if !fileManager.fileExists(atPath: searchURL.path, isDirectory: &isDirectory) || !isDirectory.boolValue {
            return .failure(.directoryNotFound(path: searchURL.path))
        }
        
        do {
            // Get all files in directory
            let contents = try fileManager.contentsOfDirectory(at: searchURL, includingPropertiesForKeys: [
                .isDirectoryKey, .fileSizeKey, .creationDateKey, .contentModificationDateKey
            ], options: recursive ? [.skipsHiddenFiles] : [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
            
            // Filter by pattern
            let regex = try NSRegularExpression(pattern: pattern.replacingOccurrences(of: "*", with: ".*"), options: [])
            
            let matchingFiles = contents.filter { url in
                let name = url.lastPathComponent
                let range = NSRange(location: 0, length: name.utf16.count)
                return regex.firstMatch(in: name, options: [], range: range) != nil
            }
            
            // Get file information
            var fileInfos: [FileInfo] = []
            for url in matchingFiles {
                if let fileInfo = getFileInfo(for: url) {
                    fileInfos.append(fileInfo)
                }
            }
            
            return .success(fileInfos)
        } catch {
            return .failure(.fileOperationFailed(message: error.localizedDescription))
        }
    }
}

/// File information structure
struct FileInfo {
    /// File name
    let name: String
    
    /// Full file path
    let path: String
    
    /// Whether the file is a directory
    let isDirectory: Bool
    
    /// File size in bytes
    let size: Int
    
    /// File creation date
    let creationDate: Date
    
    /// File modification date
    let modificationDate: Date
    
    /// Formatted file size string
    var formattedSize: String {
        if isDirectory {
            return "-"
        }
        
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useAll]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(size))
    }
    
    /// Formatted creation date string
    var formattedCreationDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: creationDate)
    }
    
    /// Formatted modification date string
    var formattedModificationDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: modificationDate)
    }
    
    /// File type icon
    var icon: UIImage? {
        if isDirectory {
            return UIImage(systemName: "folder")
        } else {
            // Determine file type based on extension
            let fileExtension = (name as NSString).pathExtension.lowercased()
            
            switch fileExtension {
            case "txt", "md", "rtf", "log":
                return UIImage(systemName: "doc.text")
            case "pdf":
                return UIImage(systemName: "doc.text.viewfinder")
            case "jpg", "jpeg", "png", "gif", "heic":
                return UIImage(systemName: "photo")
            case "mp4", "mov", "avi":
                return UIImage(systemName: "film")
            case "mp3", "wav", "aac":
                return UIImage(systemName: "music.note")
            case "zip", "rar", "7z", "tar", "gz":
                return UIImage(systemName: "archivebox")
            case "ipa":
                return UIImage(systemName: "app.badge")
            case "plist":
                return UIImage(systemName: "list.bullet.rectangle")
            case "swift", "h", "m", "c", "cpp", "js", "html", "css":
                return UIImage(systemName: "chevron.left.forwardslash.chevron.right")
            default:
                return UIImage(systemName: "doc")
            }
        }
    }
}

