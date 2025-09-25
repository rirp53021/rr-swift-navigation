# RRNavigation Demo App

This demo app showcases the RRNavigation library with both SwiftUI and UIKit examples.

## 🚀 Features Demonstrated

### ⭐ Strategy Validation (NEW!)
- **Factory Compatibility**: Only views compatible with active strategy can be registered
- **Interactive Testing**: Test different strategies with compatible/incompatible factories
- **Real-time Feedback**: Visual indicators show which registrations succeed or fail
- **Console Integration**: Detailed logs show validation process and results

### ⭐ Path-Based Navigation (NEW!)
- **Type-Safe Routes**: Use centralized RouteKey definitions instead of hardcoded strings
- **Interactive Path Builder**: Visual interface to build navigation paths
- **Route Categories**: Organized routes by type (SwiftUI, UIKit, Admin, Deep Link)
- **Path Tracking**: Real-time display of current navigation path

### SwiftUI Navigation
- **Push Navigation**: Navigate to ProfileView with parameters
- **Sheet Presentation**: Present SettingsView as a sheet
- **Modal Presentation**: Present ProfileView as a modal
- **Replace Navigation**: Replace current view with SettingsView

### UIKit Integration
- **View Controller Navigation**: Navigate to UIKit view controllers
- **Mixed Navigation**: Use UIKit view controllers with SwiftUI navigation
- **Parameter Passing**: Pass data between SwiftUI and UIKit components
- **Strategy Validation**: See how UIKit factories are rejected by SwiftUI strategy

### Navigation Controls
- **Back Navigation**: Navigate back in the stack
- **Root Navigation**: Navigate to root view
- **Tab Navigation**: Switch between different tabs

## 📱 App Structure

```
RRNavigationDemo/
├── RRNavigationDemoApp.swift          # Main app entry point
├── ContentView.swift                  # Main content view with tabs
├── SwiftUI/
│   ├── HomeView.swift                 # Home screen
│   ├── ProfileView.swift              # Profile view with parameters
│   └── SettingsView.swift             # Settings view
├── UIKit/
│   ├── ProfileViewController.swift    # UIKit profile view controller
│   └── SettingsViewController.swift   # UIKit settings view controller
└── Factories/
    └── ViewFactories.swift            # Factory implementations
```

## 🔧 Setup Instructions

1. **Open the Project**
   ```bash
   cd Demo
   open RRNavigationDemo.xcodeproj
   ```

2. **Build and Run**
   - Select a simulator or device
   - Press Cmd+R to build and run

3. **Test Navigation**
   - Tap different buttons to test various navigation patterns
   - Check the console for factory logs
   - Test both SwiftUI and UIKit navigation

## 🧪 Testing Scenarios

### ⭐ Strategy Validation Tab (NEW!)
1. **Test SwiftUI Strategy** - See SwiftUI factories accepted, UIKit factories rejected
2. **Test UIKit Strategy** - See UIKit factories accepted, SwiftUI factories rejected  
3. **Test Chain of Responsibility** - Test automatic validation with route chains
4. **Clear Results** - Reset validation results to test again
5. **Monitor Console** - Check detailed validation logs in Xcode console

### ⭐ Path Navigation Tab (NEW!)
1. **Select Routes** - Tap route buttons to navigate using type-safe RouteKey definitions
2. **Build Paths** - Create navigation paths by selecting multiple routes
3. **View Path History** - See current navigation path displayed in real-time
4. **Test Navigation Controls** - Use back, root, and clear path controls
5. **Explore Route Categories** - See all available routes organized by type

### Basic Navigation
1. Tap "Navigate to Profile (Push)" - Tests push navigation with parameters
2. Tap "Show Settings (Sheet)" - Tests sheet presentation
3. Tap "Show Profile (Modal)" - Tests modal presentation
4. Tap "Replace with Settings" - Tests replace navigation

### UIKit Integration
1. Tap "Navigate to Profile VC (Push)" - Tests UIKit view controller navigation (will fail due to strategy validation)
2. Tap "Show Settings VC (Sheet)" - Tests UIKit sheet presentation (will fail due to strategy validation)
3. Tap "Present Profile ViewController" - Tests UIKit modal presentation

### Navigation Controls
1. Tap "Back" - Tests back navigation
2. Tap "Root" - Tests root navigation
3. Use tab bar to switch between different test views

## 📊 Console Output

The demo app logs detailed information about navigation and strategy validation:

### Strategy Validation Logs
```
🚀 Setting up routes with Strategy Validation...
=============================================

📱 Registering SwiftUI factories:
✅ Registered route factory for key: home with active strategy: SwiftUI
✅ Registered route factory for key: profile with active strategy: SwiftUI
✅ Registered route factory for key: settings with active strategy: SwiftUI

📱 Registering UIKit factories (will be rejected by SwiftUI strategy):
⚠️ Factory for key 'profileVC' is not compatible with active strategy (SwiftUI). Skipping registration.
⚠️ Factory for key 'settingsVC' is not compatible with active strategy (SwiftUI). Skipping registration.

✅ Route registration completed! Check logs above for validation results.
💡 Only SwiftUI factories were accepted due to active SwiftUI strategy.
```

### Navigation Logs
```
🏠 HomeViewFactory: Presenting HomeView with context: home
   Parameters: [:]
   Navigation Type: push

👤 ProfileViewFactory: Presenting ProfileView
   User ID: 123
   Name: John Doe
   Navigation Type: push
   Parameters: ["userId": "123", "name": "John Doe"]
```

## 🎯 Key Learning Points

1. **Decoupled Architecture**: NavigationManager is reusable and doesn't contain hardcoded routes
2. **Factory Pattern**: See how factories receive components and handle presentation
3. **Parameter Passing**: Observe how parameters are passed through RouteContext
4. **Navigation Types**: Test different navigation types (push, sheet, modal, replace)
5. **Mixed UI Frameworks**: See how SwiftUI and UIKit work together
6. **Error Handling**: Observe how navigation errors are handled gracefully
7. **Strategy Validation**: Only compatible factories are registered with active strategy
8. **Type-Safe Routes**: Use RouteKey definitions instead of hardcoded strings

## 🔍 Code Examples

### RouteKey Definitions
```swift
// Centralized route definitions using RouteKey pattern
public enum AppRoutes {
    // SwiftUI Routes
    public static let home = RouteID("home", type: .push)
    public static let profile = RouteID("profile", type: .push)
    public static let settings = RouteID("settings", type: .sheet)
    
    // UIKit Routes
    public static let profileVC = RouteID("profileVC", type: .push)
    public static let settingsVC = RouteID("settingsVC", type: .sheet)
    
    // Admin Routes
    public static let adminDashboard = RouteID("admin_dashboard", type: .push)
    
    // Deep Link Routes
    public static let productDeepLink = RouteID("deeplink_product", type: .push)
}
```

### Registering Routes with RouteKey
```swift
// Type-safe route registration using RouteKey definitions directly
manager.register(HomeViewFactory(), for: AppRoutes.home)
manager.register(ProfileViewFactory(), for: AppRoutes.profile)
manager.register(ProfileViewControllerFactory(), for: AppRoutes.profileVC)

// Chain of Responsibility with decoupled NavigationManager
let chain = RouteRegistrationChainBuilder()
    .addHandler(AdminRouteHandler())
    .addHandler(DeepLinkRouteHandler())
    .build()

// Pass route keys from your app, not hardcoded in NavigationManager
manager.registerRoutes(AppRoutes.allRoutes, using: chain)
```

### Navigation with RouteKey
```swift
// Type-safe navigation using RouteKey definitions
navigationManager.navigate(
    to: AppRoutes.profile,
    parameters: RouteParameters(data: ["userId": "123", "name": "John Doe"])
)

// Path-based navigation with multiple routes
let routes = [AppRoutes.home, AppRoutes.profile, AppRoutes.settings]
for route in routes {
    navigationManager.navigate(to: route, parameters: RouteParameters())
}
```

### Factory Implementation
```swift
class ProfileViewFactory: SwiftUIViewFactoryProtocol {
    func present(_ component: AnyView, with context: RouteContext) throws {
        let userId = context.parameters.data["userId"] ?? "unknown"
        let name = context.parameters.data["name"] ?? "Unknown User"
        
        // Handle presentation based on navigation type
        switch context.navigationType {
        case .push:
            // Push navigation logic
        case .sheet:
            // Sheet presentation logic
        case .modal:
            // Modal presentation logic
        default:
            break
        }
    }
}
```

## 🐛 Troubleshooting

If you encounter issues:

1. **Build Errors**: Make sure RRNavigation is properly linked
2. **Navigation Not Working**: Check console for error messages
3. **Parameters Not Passing**: Verify RouteParameters are correctly formatted
4. **Factory Not Called**: Ensure routes are properly registered

## 📝 Next Steps

1. **Customize Views**: Modify the demo views to test your own components
2. **Add More Routes**: Register additional routes and test them
3. **Implement Real Navigation**: Replace factory logging with actual navigation logic
4. **Test Edge Cases**: Test error scenarios and edge cases
5. **Performance Testing**: Test navigation performance with complex views

This demo provides a comprehensive testing environment for the RRNavigation library! 🎉
