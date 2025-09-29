# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.1] - 2024-09-26

### Fixed
- Fixed "Publishing changes from within view updates" error in SwiftUI navigation
- Wrapped navigation path updates in DispatchQueue.main.async to prevent publishing during view updates
- Simplified unique ID generation for navigation views using routeKey directly
- Improved SwiftUI NavigationStack integration with proper binding management

### Changed
- Migrated minimum iOS deployment target from 15.0 to 16.0
- Updated project configuration to use iOS 16.0+ features
- Enhanced SwiftUI navigation strategy with better error handling

## [1.1.0] - 2024-09-14

### Added
- SwiftUI NavigationStack support with NavigationPath management
- Tab-based navigation with separate navigation paths per tab
- View registry system for managing pushed views
- NavigationCoordinator for centralized SwiftUI navigation management
- Enhanced logging for debugging navigation flow

## [1.0.0] - 2024-09-14

### Added
- Initial release of RRNavigation framework
- Cross-UI navigation support for SwiftUI and UIKit
- Strategy pattern implementation for clean separation of concerns
- Centralized navigation management with NavigationManager
- Type-safe route registration with factory pattern
- Comprehensive error handling with NavigationError enum
- State persistence support with UserDefaults and in-memory implementations
- Deep linking support with query parameter parsing
- Navigation types: push, sheet, fullScreen, tab, modal, replace
- Protocol-based architecture for extensibility
- Type erasure for factory implementations
- Comprehensive test suite with Swift Testing framework
- Full documentation and usage examples

### Features
- **NavigationManager**: Central navigation coordinator with singleton support
- **Strategy Pattern**: Separate implementations for SwiftUI and UIKit
- **Route Registration**: Type-safe factory-based route registration
- **State Management**: Observable navigation state with persistence
- **Parameter Passing**: Codable route parameters with deep linking
- **Error Handling**: Comprehensive error types with recovery suggestions
- **Testing**: Built-in test utilities and mock strategies
- **Platform Support**: iOS 15.0+, macOS 12.0+, tvOS 15.0+, watchOS 8.0+, visionOS 1.0+

### Dependencies
- RRFoundation 1.8.1 - Core utilities and logging
- RRPersistence 1.0.3 - State persistence
- Swift Testing 0.99.0 - Testing framework

### Architecture
- Protocol-first design with NavigationManagerProtocol
- Strategy pattern with NavigationStrategyProtocol
- Factory pattern with RouteFactoryProtocol
- Type erasure with AnyRouteFactory, AnySwiftUIViewFactory, AnyUIKitViewControllerFactory
- MainActor isolation for UI-related operations
- Codable support for state persistence and deep linking
