# RRNavigation

A cross-UI navigation framework for iOS that works with both SwiftUI and UIKit. Provides centralized navigation management with strategy pattern implementation.

## Features

- **Cross-UI Support**: Works with both SwiftUI and UIKit
- **Strategy Pattern**: Clean separation between UI implementations
- **Centralized Management**: Single source of truth for navigation state
- **Type Safety**: Protocol-based factories with type erasure
- **Persistence**: Optional state persistence and restoration
- **Deep Linking**: Query string parameter encoding/decoding
- **Testing**: Built-in test utilities and mock strategies

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/rirp53021/rr-swift-navigator.git", from: "1.0.0")
]
```

Or add it through Xcode:
1. File → Add Package Dependencies
2. Enter the repository URL: `https://github.com/rirp53021/rr-swift-navigator.git`
3. Select the version you want to use

## Quick Start

### Basic Setup

```swift
import RRNavigation

// Create a navigation manager
let strategy = NavigationStrategyType.swiftUI.createStrategy()
let navigationManager = NavigationManager(strategy: strategy)

// Register a route
let homeFactory = SwiftUIViewFactory { context in
    HomeView(parameters: context.parameters)
}
try navigationManager.register(homeFactory, for: "home")

// Navigate to a route
try await navigationManager.navigate(to: "home", parameters: RouteParameters(data: ["userId": "123"]))
```

### SwiftUI Integration

```swift
import SwiftUI
import RRNavigation

struct ContentView: View {
    @StateObject private var navigationManager = NavigationManager.shared
    
    var body: some View {
        NavigationStack {
            VStack {
                Button("Go to Home") {
                    Task {
                        try await navigationManager.navigate(to: "home")
                    }
                }
            }
        }
        .environmentObject(navigationManager)
    }
}
```

### UIKit Integration

```swift
import UIKit
import RRNavigation

class ViewController: UIViewController {
    private let navigationManager = NavigationManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register routes
        let homeFactory = UIKitViewControllerFactory { context in
            HomeViewController(parameters: context.parameters)
        }
        try? navigationManager.register(homeFactory, for: "home")
    }
    
    @IBAction func navigateToHome() {
        Task {
            try await navigationManager.navigate(to: "home")
        }
    }
}
```

## Architecture

### Core Components

- **NavigationManager**: Central navigation coordinator
- **NavigationStrategy**: UI-specific navigation implementation
- **RouteFactory**: Protocol for creating views/controllers
- **NavigationState**: Observable state management
- **RouteParameters**: Type-safe parameter passing

### Strategy Pattern

The framework uses the Strategy Pattern to separate SwiftUI and UIKit implementations:

```swift
// SwiftUI Strategy
let swiftUIStrategy = NavigationStrategyType.swiftUI.createStrategy()

// UIKit Strategy  
let uikitStrategy = NavigationStrategyType.uikit.createStrategy()
```

### Route Registration

Routes are registered with factories that create the appropriate view or controller:

```swift
// SwiftUI View Factory
let viewFactory = SwiftUIViewFactory { context in
    MySwiftUIView(parameters: context.parameters)
}
try navigationManager.register(viewFactory, for: "my-route")

// UIKit View Controller Factory
let controllerFactory = UIKitViewControllerFactory { context in
    MyViewController(parameters: context.parameters)
}
try navigationManager.register(controllerFactory, for: "my-route")
```

## Navigation Types

The framework supports various navigation types:

- **Push**: Standard push navigation
- **Sheet**: Modal sheet presentation
- **FullScreen**: Full screen modal
- **Tab**: Tab-based navigation
- **Modal**: Modal presentation
- **Replace**: Replace current view

## State Persistence

Navigation state can be persisted and restored:

```swift
// With persistence
let persistence = UserDefaultsPersistence()
let navigationManager = NavigationManager(
    strategy: strategy,
    persistence: persistence
)

// State is automatically saved and restored
```

## Deep Linking

Routes support deep linking with query parameters:

```swift
// Parse from URL
let parameters = RouteParameters(from: "userId=123&name=John")

// Navigate with parameters
try await navigationManager.navigate(
    to: "profile",
    parameters: parameters
)
```

## Error Handling

The framework provides comprehensive error handling:

```swift
do {
    try await navigationManager.navigate(to: "unknown-route")
} catch NavigationError.routeNotFound(let key) {
    print("Route not found: \(key)")
} catch {
    print("Navigation failed: \(error)")
}
```

## Testing

The framework includes testing utilities:

```swift
import RRNavigation

// In-memory persistence for testing
let persistence = InMemoryPersistence()
let navigationManager = NavigationManager(
    strategy: strategy,
    persistence: persistence
)

// Test navigation
try await navigationManager.navigate(to: "test-route")
```

## Requirements

- iOS 15.0+
- macOS 12.0+
- tvOS 15.0+
- watchOS 8.0+
- visionOS 1.0+
- Swift 5.9+

## Dependencies

- [RRFoundation](https://github.com/rirp53021/rr-swift-foundation) - Core utilities and logging
- [RRPersistence](https://github.com/rirp53021/rr-swift-persistence) - State persistence

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Support

If you encounter any issues or have questions, please open an issue on GitHub.
