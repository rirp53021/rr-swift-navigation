# RRNavigation

A modern SwiftUI navigation framework for iOS that provides centralized navigation management with a clean, modular architecture. Built with SwiftUI-first design and supports complex navigation patterns including tab-based navigation, modal presentations, and deep linking.

## Features

- **SwiftUI-First**: Built specifically for SwiftUI with NavigationStack support
- **Modular Architecture**: App modules and navigation handlers for organized code
- **Tab Navigation**: Full support for tab-based navigation with individual navigation paths
- **Modal Presentations**: Sheet and full-screen modal support
- **Type-Safe Routes**: RouteID-based navigation with parameter support
- **Chain of Responsibility**: Organized route handling with dedicated navigation handlers
- **App Module System**: Support for different app states (authenticated/unauthenticated)
- **Deep Linking**: Built-in support for route parameters and deep linking
- **iOS 16+**: Leverages modern SwiftUI features with NavigationStack

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/rirp53021/rr-swift-navigator.git", from: "1.1.1")
]
```

Or add it through Xcode:
1. File → Add Package Dependencies
2. Enter the repository URL: `https://github.com/rirp53021/rr-swift-navigator.git`
3. Select version 1.1.1 or later

### Requirements

- iOS 16.0+
- macOS 13.0+
- tvOS 16.0+
- watchOS 9.0+
- visionOS 1.0+
- Swift 5.9+

## Quick Start

### Basic Setup

```swift
import SwiftUI
import RRNavigation

@main
struct MyApp: App {
    @StateObject private var navigationManager = NavigationManager(initialModel: .authenticated)
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(navigationManager)
                .onAppear {
                    setupNavigation()
                }
        }
    }
    
    private func setupNavigation() {
        // Register app modules
        navigationManager.registerAppModule(.authenticated)
        navigationManager.registerAppModule(.notAuthenticated)
        
        // Register navigation handlers
        let handler = MyNavigationHandler()
        navigationManager.registerHandler(handler)
        
        // Register tabs
        let homeFactory = HomeTabFactory()
        let profileFactory = ProfileTabFactory()
        
        navigationManager.registerTab(homeFactory)
        navigationManager.registerTab(profileFactory)
    }
}
```

### Content View

```swift
import SwiftUI
import RRNavigation

struct ContentView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        EmptyView()
            .navigation()
    }
}
```

### Navigation Handler

```swift
import SwiftUI
import RRNavigation

struct MyNavigationHandler: NavigationHandler {
    func canNavigate(to route: RouteID) -> Bool {
        return [.home, .profile, .settings].contains(route)
    }
    
    func getNavigation(to route: RouteID) -> NavigationStep? {
        switch route {
        case .home:
            return NavigationStep(
                tab: .home,
                type: .push,
                factory: HomeViewFactory.self,
                params: route.parameters
            )
        case .profile:
            return NavigationStep(
                tab: .profile,
                type: .push,
                factory: ProfileViewFactory.self,
                params: route.parameters
            )
        default:
            return nil
        }
    }
}
```

### View Factory

```swift
import SwiftUI
import RRNavigation

struct HomeViewFactory: ViewFactory {
    @ViewBuilder static func createView(params: [String: Any]?) -> some View {
        HomeView()
    }
}
```

### Navigation

```swift
// Navigate to a route
navigationManager.navigate(to: .home)

// Navigate with parameters
let routeWithParams = RouteID("profile").addingParameter("userId", value: "123")
navigationManager.navigate(to: routeWithParams)

// Present as sheet
navigationManager.navigate(to: .settings) // If configured as sheet in handler
```

## Architecture

### Core Components

- **NavigationManager**: Central navigation coordinator with ObservableObject support
- **NavigationHandler**: Chain of responsibility pattern for route handling
- **AppModule**: Represents different app states (authenticated/unauthenticated)
- **RouteID**: Type-safe route identifiers with parameter support
- **ViewFactory**: Protocol for creating SwiftUI views
- **NavigationStep**: Defines navigation behavior (push, sheet, fullScreen)
- **RRTab**: Tab configuration with root routes and icons

### App Module System

The framework supports different app states through the AppModule system:

```swift
// Define app modules
let authenticatedModule = AppModule(
    id: .authenticated,
    rootView: AuthenticatedRootViewFactory.self,
    contentMode: .tabStructure
)

let unauthenticatedModule = AppModule(
    id: .notAuthenticated,
    rootView: LoginViewFactory.self,
    contentMode: .contentOnly
)

// Register modules
navigationManager.registerAppModule(authenticatedModule)
navigationManager.registerAppModule(unauthenticatedModule)
```

### Navigation Handler Pattern

Navigation handlers use the Chain of Responsibility pattern to organize route handling:

```swift
struct MyNavigationHandler: NavigationHandler {
    func canNavigate(to route: RouteID) -> Bool {
        // Define which routes this handler can manage
        return [.home, .profile, .settings].contains(route)
    }
    
    func getNavigation(to route: RouteID) -> NavigationStep? {
        // Return navigation configuration for each route
        switch route {
        case .home:
            return NavigationStep(
                tab: .home,
                type: .push,
                factory: HomeViewFactory.self,
                params: route.parameters
            )
        default:
            return nil
        }
    }
}
```

### Tab Management

Tabs are registered with factories and managed automatically:

```swift
// Tab factory
struct HomeTabFactory: RRTabFactory {
    func create() -> RRTab {
        RRTab(
            id: .home,
            name: "Home",
            rootRouteID: .home,
            icon: Image(systemName: "house.fill")
        )
    }
}

// Register tab
navigationManager.registerTab(HomeTabFactory())
```

## Navigation Types

The framework supports three main navigation types:

- **Push**: Standard push navigation within NavigationStack
- **Sheet**: Modal sheet presentation
- **FullScreen**: Full screen modal presentation

```swift
// Configure navigation type in handler
case .profile:
    return NavigationStep(
        tab: .profile,
        type: .push,        // Push navigation
        factory: ProfileViewFactory.self,
        params: route.parameters
    )

case .editProfile:
    return NavigationStep(
        tab: .profile,
        type: .fullScreen,  // Full screen modal
        factory: EditProfileViewFactory.self,
        params: route.parameters
    )

case .settings:
    return NavigationStep(
        type: .sheet,       // Sheet presentation
        factory: SettingsViewFactory.self,
        params: route.parameters
    )
```

## Route Parameters

Routes support parameters for data passing:

```swift
// Create route with parameters
let profileRoute = RouteID("profile")
    .addingParameter("userId", value: "123")
    .addingParameter("name", value: "John")

// Navigate with parameters
navigationManager.navigate(to: profileRoute)

// Access parameters in view factory
struct ProfileViewFactory: ViewFactory {
    @ViewBuilder static func createView(params: [String: Any]?) -> some View {
        let userId = params?["userId"] as? String ?? ""
        ProfileView(userId: userId)
    }
}
```

## Demo App

The framework includes a comprehensive demo app showcasing all features:

### Running the Demo

1. Open `RRNavigation.xcodeproj` in Xcode
2. Select the `RRNavigationDemo` scheme
3. Build and run on iOS Simulator or device

### Demo Features

- **Tab Navigation**: Home, Profile, and Settings tabs
- **Modal Presentations**: Sheet and full-screen demos
- **Route Parameters**: Parameter passing between views
- **App Module Switching**: Authenticated/unauthenticated states
- **Navigation Handlers**: Multiple handlers for different route groups

### Demo Structure

```
Demo/
├── RRNavigationDemo/
│   ├── Handlers/
│   │   ├── DemoNavigationHandler.swift    # Main navigation logic
│   │   └── PublicNavigationHandler.swift  # Public routes
│   ├── Routes/
│   │   ├── Routes.swift                  # Route definitions
│   │   ├── Tabs.swift                    # Tab configurations
│   │   └── AppModules.swift              # App module definitions
│   ├── Factories/
│   │   └── TabFactory.swift              # Tab factories
│   └── Views/
│       ├── HomeView.swift                # Home tab content
│       ├── ProfileView.swift             # Profile tab content
│       ├── SettingsView.swift            # Settings tab content
│       └── ...                           # Additional demo views
```

## Dependencies

- [RRFoundation](https://github.com/rirp53021/rr-swift-foundation) - Core utilities and logging
- [RRPersistence](https://github.com/rirp53021/rr-swift-persistence) - State persistence

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Support

If you encounter any issues or have questions, please open an issue on GitHub.
