import UIKit
import SwiftUI

/// ModifyAppDelegate provides functionality to modify app delegate behavior at runtime
/// This allows for dynamic configuration of app features without requiring a restart
class ModifyAppDelegate {
    // MARK: - Singleton
    
    /// Shared instance for singleton access
    static let shared = ModifyAppDelegate()
    
    /// Private initializer to enforce singleton pattern
    private init() {
        loadSavedConfigurations()
    }
    
    // MARK: - Properties
    
    /// Dictionary of feature flags that can be toggled
    private(set) var featureFlags: [String: Bool] = [:]
    
    /// Dictionary of configuration values
    private(set) var configValues: [String: Any] = [:]
    
    /// Available feature flags with descriptions
    let availableFeatureFlags: [FeatureFlag] = [
        FeatureFlag(id: "enable_terminal", name: "Terminal Access", description: "Enable terminal access for advanced users", defaultValue: true),
        FeatureFlag(id: "enable_debugging", name: "Debug Mode", description: "Enable advanced debugging features", defaultValue: false),
        FeatureFlag(id: "enable_ai_learning", name: "AI Learning", description: "Enable AI learning capabilities", defaultValue: true),
        FeatureFlag(id: "enable_background_refresh", name: "Background Refresh", description: "Enable background app refresh", defaultValue: true),
        FeatureFlag(id: "enable_floating_buttons", name: "Floating Buttons", description: "Show floating action buttons", defaultValue: true),
        FeatureFlag(id: "enable_crash_reporting", name: "Crash Reporting", description: "Send anonymous crash reports", defaultValue: true),
        FeatureFlag(id: "enable_analytics", name: "Analytics", description: "Collect anonymous usage statistics", defaultValue: false),
        FeatureFlag(id: "enable_cloud_sync", name: "Cloud Sync", description: "Enable cloud synchronization", defaultValue: false),
        FeatureFlag(id: "enable_experimental", name: "Experimental Features", description: "Enable experimental features", defaultValue: false),
        FeatureFlag(id: "enable_advanced_signing", name: "Advanced Signing", description: "Enable advanced app signing options", defaultValue: true)
    ]
    
    /// Available configuration options with descriptions
    let availableConfigurations: [ConfigOption] = [
        ConfigOption(id: "max_concurrent_downloads", name: "Max Concurrent Downloads", description: "Maximum number of concurrent downloads", type: .integer, defaultValue: 3),
        ConfigOption(id: "download_timeout", name: "Download Timeout", description: "Download timeout in seconds", type: .integer, defaultValue: 60),
        ConfigOption(id: "cache_size_mb", name: "Cache Size (MB)", description: "Maximum cache size in megabytes", type: .integer, defaultValue: 500),
        ConfigOption(id: "log_level", name: "Log Level", description: "Logging verbosity level", type: .string, defaultValue: "info"),
        ConfigOption(id: "theme", name: "App Theme", description: "Visual theme for the app", type: .string, defaultValue: "system"),
        ConfigOption(id: "refresh_interval", name: "Refresh Interval", description: "Source refresh interval in minutes", type: .integer, defaultValue: 60),
        ConfigOption(id: "max_history_items", name: "Max History Items", description: "Maximum number of history items to keep", type: .integer, defaultValue: 100),
        ConfigOption(id: "default_certificate", name: "Default Certificate", description: "Default certificate to use for signing", type: .string, defaultValue: ""),
        ConfigOption(id: "ai_model", name: "AI Model", description: "AI model to use for learning", type: .string, defaultValue: "default"),
        ConfigOption(id: "network_timeout", name: "Network Timeout", description: "Network request timeout in seconds", type: .integer, defaultValue: 30)
    ]
    
    // MARK: - Feature Flag Management
    
    /// Set a feature flag value
    /// - Parameters:
    ///   - flag: The feature flag ID
    ///   - value: The boolean value
    func setFeatureFlag(_ flag: String, value: Bool) {
        featureFlags[flag] = value
        saveConfigurations()
        notifyConfigurationChanged(flag: flag)
    }
    
    /// Get a feature flag value
    /// - Parameter flag: The feature flag ID
    /// - Returns: The boolean value or default if not set
    func getFeatureFlag(_ flag: String) -> Bool {
        if let value = featureFlags[flag] {
            return value
        }
        
        // Return default value if available
        if let featureFlag = availableFeatureFlags.first(where: { $0.id == flag }) {
            return featureFlag.defaultValue
        }
        
        return false
    }
    
    // MARK: - Configuration Management
    
    /// Set a configuration value
    /// - Parameters:
    ///   - key: The configuration key
    ///   - value: The value to set
    func setConfigValue(_ key: String, value: Any) {
        configValues[key] = value
        saveConfigurations()
        notifyConfigurationChanged(key: key)
    }
    
    /// Get a configuration value
    /// - Parameters:
    ///   - key: The configuration key
    ///   - defaultValue: Default value if not set
    /// - Returns: The configuration value or default
    func getConfigValue<T>(_ key: String, defaultValue: T) -> T {
        if let value = configValues[key] as? T {
            return value
        }
        
        // Return default value from available configurations if possible
        if let configOption = availableConfigurations.first(where: { $0.id == key }),
           let defaultOptionValue = configOption.defaultValue as? T {
            return defaultOptionValue
        }
        
        return defaultValue
    }
    
    // MARK: - Persistence
    
    /// Save configurations to UserDefaults
    private func saveConfigurations() {
        UserDefaults.standard.set(featureFlags, forKey: "ModifyAppDelegate.featureFlags")
        
        // Convert configValues to a serializable dictionary
        var serializableConfig: [String: Any] = [:]
        for (key, value) in configValues {
            if JSONSerialization.isValidJSONObject([key: value]) {
                serializableConfig[key] = value
            } else {
                Debug.shared.log(message: "Could not serialize config value for key: \(key)", type: .warning)
            }
        }
        
        UserDefaults.standard.set(serializableConfig, forKey: "ModifyAppDelegate.configValues")
    }
    
    /// Load saved configurations from UserDefaults
    private func loadSavedConfigurations() {
        if let savedFlags = UserDefaults.standard.dictionary(forKey: "ModifyAppDelegate.featureFlags") as? [String: Bool] {
            featureFlags = savedFlags
        } else {
            // Initialize with default values
            for flag in availableFeatureFlags {
                featureFlags[flag.id] = flag.defaultValue
            }
        }
        
        if let savedConfig = UserDefaults.standard.dictionary(forKey: "ModifyAppDelegate.configValues") {
            configValues = savedConfig
        } else {
            // Initialize with default values
            for option in availableConfigurations {
                configValues[option.id] = option.defaultValue
            }
        }
    }
    
    // MARK: - Reset Functions
    
    /// Reset all feature flags to default values
    func resetFeatureFlags() {
        for flag in availableFeatureFlags {
            featureFlags[flag.id] = flag.defaultValue
        }
        saveConfigurations()
        notifyConfigurationChanged()
    }
    
    /// Reset all configuration values to default values
    func resetConfigValues() {
        for option in availableConfigurations {
            configValues[option.id] = option.defaultValue
        }
        saveConfigurations()
        notifyConfigurationChanged()
    }
    
    /// Reset everything to default values
    func resetAll() {
        resetFeatureFlags()
        resetConfigValues()
    }
    
    // MARK: - Notification
    
    /// Notify that configuration has changed
    /// - Parameters:
    ///   - flag: Optional flag that changed
    ///   - key: Optional key that changed
    private func notifyConfigurationChanged(flag: String? = nil, key: String? = nil) {
        var userInfo: [String: Any] = [:]
        
        if let flag = flag {
            userInfo["flag"] = flag
        }
        
        if let key = key {
            userInfo["key"] = key
        }
        
        NotificationCenter.default.post(
            name: .appDelegateConfigurationChanged,
            object: self,
            userInfo: userInfo
        )
    }
}

// MARK: - Supporting Types

/// Feature flag definition
struct FeatureFlag {
    /// Unique identifier
    let id: String
    
    /// Display name
    let name: String
    
    /// Description of the feature
    let description: String
    
    /// Default value
    let defaultValue: Bool
}

/// Configuration option definition
struct ConfigOption {
    /// Unique identifier
    let id: String
    
    /// Display name
    let name: String
    
    /// Description of the option
    let description: String
    
    /// Value type
    let type: ConfigValueType
    
    /// Default value
    let defaultValue: Any
}

/// Configuration value type
enum ConfigValueType {
    case string
    case integer
    case double
    case boolean
}

// MARK: - Notification Extension

extension Notification.Name {
    /// Notification sent when app delegate configuration changes
    static let appDelegateConfigurationChanged = Notification.Name("appDelegateConfigurationChanged")
}

// MARK: - SwiftUI View

/// SwiftUI view for modifying app delegate configuration
struct ModifyAppDelegateView: View {
    @State private var selectedTab = 0
    @State private var featureFlags: [FeatureFlag] = []
    @State private var configOptions: [ConfigOption] = []
    @State private var flagValues: [String: Bool] = [:]
    @State private var configValues: [String: Any] = [:]
    @State private var showResetAlert = false
    @State private var resetType = 0
    
    var body: some View {
        VStack {
            Picker("", selection: $selectedTab) {
                Text("Feature Flags").tag(0)
                Text("Configuration").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            if selectedTab == 0 {
                featureFlagsView
            } else {
                configurationView
            }
            
            Spacer()
            
            Button(action: {
                showResetAlert = true
            }) {
                Text("Reset to Defaults")
                    .foregroundColor(.red)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle("App Configuration")
        .onAppear {
            loadData()
        }
        .alert(isPresented: $showResetAlert) {
            Alert(
                title: Text("Reset Configuration"),
                message: Text("Are you sure you want to reset all settings to their default values?"),
                primaryButton: .destructive(Text("Reset")) {
                    resetToDefaults()
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    /// Feature flags view
    private var featureFlagsView: some View {
        List {
            ForEach(featureFlags, id: \.id) { flag in
                Toggle(isOn: Binding(
                    get: { flagValues[flag.id] ?? flag.defaultValue },
                    set: { newValue in
                        flagValues[flag.id] = newValue
                        ModifyAppDelegate.shared.setFeatureFlag(flag.id, value: newValue)
                    }
                )) {
                    VStack(alignment: .leading) {
                        Text(flag.name)
                            .font(.headline)
                        Text(flag.description)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
    
    /// Configuration options view
    private var configurationView: some View {
        List {
            ForEach(configOptions, id: \.id) { option in
                configOptionRow(for: option)
            }
        }
    }
    
    /// Create a row for a configuration option
    /// - Parameter option: The configuration option
    /// - Returns: A view for the option
    @ViewBuilder
    private func configOptionRow(for option: ConfigOption) -> some View {
        VStack(alignment: .leading) {
            Text(option.name)
                .font(.headline)
            Text(option.description)
                .font(.caption)
                .foregroundColor(.gray)
            
            switch option.type {
            case .string:
                TextField("Value", text: Binding(
                    get: { configValues[option.id] as? String ?? option.defaultValue as? String ?? "" },
                    set: { newValue in
                        configValues[option.id] = newValue
                        ModifyAppDelegate.shared.setConfigValue(option.id, value: newValue)
                    }
                ))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.top, 4)
                
            case .integer:
                HStack {
                    Text("Value:")
                    TextField("Value", text: Binding(
                        get: { String(configValues[option.id] as? Int ?? option.defaultValue as? Int ?? 0) },
                        set: { newValue in
                            if let intValue = Int(newValue) {
                                configValues[option.id] = intValue
                                ModifyAppDelegate.shared.setConfigValue(option.id, value: intValue)
                            }
                        }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                }
                .padding(.top, 4)
                
            case .double:
                HStack {
                    Text("Value:")
                    TextField("Value", text: Binding(
                        get: { String(configValues[option.id] as? Double ?? option.defaultValue as? Double ?? 0.0) },
                        set: { newValue in
                            if let doubleValue = Double(newValue) {
                                configValues[option.id] = doubleValue
                                ModifyAppDelegate.shared.setConfigValue(option.id, value: doubleValue)
                            }
                        }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
                }
                .padding(.top, 4)
                
            case .boolean:
                Toggle("Enabled", isOn: Binding(
                    get: { configValues[option.id] as? Bool ?? option.defaultValue as? Bool ?? false },
                    set: { newValue in
                        configValues[option.id] = newValue
                        ModifyAppDelegate.shared.setConfigValue(option.id, value: newValue)
                    }
                ))
                .padding(.top, 4)
            }
        }
        .padding(.vertical, 4)
    }
    
    /// Load data from ModifyAppDelegate
    private func loadData() {
        featureFlags = ModifyAppDelegate.shared.availableFeatureFlags
        configOptions = ModifyAppDelegate.shared.availableConfigurations
        
        // Load current values
        for flag in featureFlags {
            flagValues[flag.id] = ModifyAppDelegate.shared.getFeatureFlag(flag.id)
        }
        
        for option in configOptions {
            switch option.type {
            case .string:
                configValues[option.id] = ModifyAppDelegate.shared.getConfigValue(option.id, defaultValue: option.defaultValue as? String ?? "")
            case .integer:
                configValues[option.id] = ModifyAppDelegate.shared.getConfigValue(option.id, defaultValue: option.defaultValue as? Int ?? 0)
            case .double:
                configValues[option.id] = ModifyAppDelegate.shared.getConfigValue(option.id, defaultValue: option.defaultValue as? Double ?? 0.0)
            case .boolean:
                configValues[option.id] = ModifyAppDelegate.shared.getConfigValue(option.id, defaultValue: option.defaultValue as? Bool ?? false)
            }
        }
    }
    
    /// Reset all settings to defaults
    private func resetToDefaults() {
        if selectedTab == 0 {
            ModifyAppDelegate.shared.resetFeatureFlags()
        } else {
            ModifyAppDelegate.shared.resetConfigValues()
        }
        
        // Reload data
        loadData()
    }
}

// MARK: - UIKit View Controller

/// UIKit view controller for modifying app delegate configuration
class ModifyAppDelegateViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up SwiftUI view
        let swiftUIView = ModifyAppDelegateView()
        let hostingController = UIHostingController(rootView: swiftUIView)
        
        // Add as child view controller
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        // Set up constraints
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        hostingController.didMove(toParent: self)
        
        // Set title
        title = "App Configuration"
    }
}

