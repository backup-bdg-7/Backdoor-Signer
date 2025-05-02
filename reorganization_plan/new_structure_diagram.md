# New Codebase Structure Diagram

```
backdoor/
 App/                       # Application-specific code
   ├── Delegates/             # App delegates
   ├── Resources/             # App resources
   ├── Views/                 # App-level views
   ├── Info.plist             # App info file
   └── backdoor.entitlements  # App entitlements

 Core/                      # Core foundation layer
   ├── Common/                # Common utilities
   ├── Data/                  # Data management
   │   ├── Backdoor.xcdatamodeld/  # CoreData model
   │   ├── CoreData/          # CoreData management
   │   ├── Models/            # Data models
   │   └── UserDefaults/      # User defaults management
   ├── Extensions/            # Swift extensions
   ├── Localization/          # Localization files
   ├── Logging/               # Logging infrastructure
   ├── Server/                # Server-related code
   ├── Services/              # Shared services
   └── Utilities/             # Helper utilities

 Features/                  # Feature modules
   ├── AI/                    # AI feature
   │   ├── Models/            # AI models
   │   ├── Services/          # AI services
   │   └── Views/             # AI views
   ├── Debugger/              # Debugging feature
   ├── Home/                  # Home feature
   ├── Hub/                   # Hub feature
   ├── Library/               # Library feature
   ├── Settings/              # Settings feature
   ├── Signing/               # Signing feature
   ├── Sources/               # Sources feature
   └── Terminal/              # Terminal feature

 Magic/                     # Crypto & signing components
   ├── decompression/         # Decompression utilities
   ├── esign/                 # Esign functionality
   ├── zsign/                 # Zsign functionality
   └── ...                    # Other Magic components

 UI/                        # UI components
   ├── Design/                # Design system components
   └── Views/                 # Reusable views

 Documentation/             # Project documentation

 scripts/                   # Build & CI scripts
```

This structure provides clear separation of concerns:
- **App**: Application entry points and configuration
- **Core**: Foundation services and data models
- **Features**: Well-defined feature modules
- **Magic**: Crypto-related functionality
- **UI**: Reusable interface components

Each major feature has been given its own directory with clear internal organization (Models, Services, Views).
