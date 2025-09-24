import SwiftUI
import UIKit
import RRNavigation

// MARK: - SwiftUI View Factories

class HomeViewFactory: SwiftUIViewFactory {
    func present(_ component: AnyView, with context: RouteContext) {
        // In a real implementation, this would handle the presentation
        // For demo purposes, we'll just log the action
        print("🏠 HomeViewFactory: Presenting HomeView with context: \(context.key)")
        print("   Parameters: \(context.parameters.data)")
        print("   Navigation Type: \(context.navigationType)")
    }
    
    func presentView(_ view: AnyView, with context: RouteContext) {
        present(view, with: context)
    }
}

class ProfileViewFactory: SwiftUIViewFactory {
    func present(_ component: AnyView, with context: RouteContext) {
        // Extract parameters
        let userId = context.parameters.data["userId"] ?? "unknown"
        let name = context.parameters.data["name"] ?? "Unknown User"
        
        print("👤 ProfileViewFactory: Presenting ProfileView")
        print("   User ID: \(userId)")
        print("   Name: \(name)")
        print("   Navigation Type: \(context.navigationType)")
        print("   Parameters: \(context.parameters.data)")
        
        // In a real implementation, this would:
        // 1. Create the ProfileView with the parameters
        // 2. Present it according to the navigation type
        // 3. Handle the actual navigation logic
    }
    
    func presentView(_ view: AnyView, with context: RouteContext) {
        present(view, with: context)
    }
}

class SettingsViewFactory: SwiftUIViewFactory {
    func present(_ component: AnyView, with context: RouteContext) {
        // Extract parameters
        let section = context.parameters.data["section"] ?? "general"
        let userId = context.parameters.data["userId"] ?? "unknown"
        
        print("⚙️ SettingsViewFactory: Presenting SettingsView")
        print("   Section: \(section)")
        print("   User ID: \(userId)")
        print("   Navigation Type: \(context.navigationType)")
        print("   Parameters: \(context.parameters.data)")
        
        // In a real implementation, this would:
        // 1. Create the SettingsView with the parameters
        // 2. Present it according to the navigation type
        // 3. Handle the actual navigation logic
    }
    
    func presentView(_ view: AnyView, with context: RouteContext) {
        present(view, with: context)
    }
}

// MARK: - UIKit View Controller Factories

class ProfileViewControllerFactory: UIKitViewControllerFactory {
    private let navigationManager: any NavigationManagerProtocol
    
    init(navigationManager: any NavigationManagerProtocol) {
        self.navigationManager = navigationManager
    }
    
    func present(_ component: UIViewController, with context: RouteContext) {
        // Extract parameters
        let userId = context.parameters.data["userId"] ?? "unknown"
        let name = context.parameters.data["name"] ?? "Unknown User"
        
        print("📱 ProfileViewControllerFactory: Presenting ProfileViewController")
        print("   User ID: \(userId)")
        print("   Name: \(name)")
        print("   Navigation Type: \(context.navigationType)")
        print("   Parameters: \(context.parameters.data)")
        
        // In a real implementation, this would:
        // 1. Create the ProfileViewController with the parameters
        // 2. Present it according to the navigation type
        // 3. Handle the actual navigation logic
    }
    
    func presentViewController(_ viewController: UIViewController, with context: RouteContext) {
        present(viewController, with: context)
    }
}

class SettingsViewControllerFactory: UIKitViewControllerFactory {
    private let navigationManager: any NavigationManagerProtocol
    
    init(navigationManager: any NavigationManagerProtocol) {
        self.navigationManager = navigationManager
    }
    
    func present(_ component: UIViewController, with context: RouteContext) {
        // Extract parameters
        let userId = context.parameters.data["userId"] ?? "unknown"
        let section = context.parameters.data["section"] ?? "general"
        
        print("📱 SettingsViewControllerFactory: Presenting SettingsViewController")
        print("   User ID: \(userId)")
        print("   Section: \(section)")
        print("   Navigation Type: \(context.navigationType)")
        print("   Parameters: \(context.parameters.data)")
        
        // In a real implementation, this would:
        // 1. Create the SettingsViewController with the parameters
        // 2. Present it according to the navigation type
        // 3. Handle the actual navigation logic
    }
    
    func presentViewController(_ viewController: UIViewController, with context: RouteContext) {
        present(viewController, with: context)
    }
}
