// MARK: - UIKit Route Handler

import Foundation

#if canImport(UIKit)
import UIKit

/// Handler for UIKit routes in the chain of responsibility
public class UIKitRouteHandler: BaseRouteRegistrationHandler {
    
    public override init() {
        super.init()
    }
    
    public override func canHandle(routeKey: any RouteKey) -> Bool {
        // Handle UIKit routes based on key prefix or specific keys
        return routeKey.key.hasPrefix("uikit_") ||
               routeKey.key.hasSuffix("VC") ||
               ["profileVC", "settingsVC"].contains(routeKey.key)
    }
    
    @MainActor
    public override func registerRoute(for routeKey: any RouteKey, in manager: any NavigationManagerProtocol) -> Bool {
        // Check if current strategy supports UIKit
        let supportedTypes: Set<NavigationType> = [.push, .sheet, .fullScreen, .modal, .tab, .replace]
        guard supportedTypes.contains(routeKey.presentationType) else {
            print("⚠️ UIKitRouteHandler: Strategy does not support \(routeKey.presentationType)")
            return false
        }
        
        switch routeKey.key {
        case "profileVC":
            let factory = AnyUIKitViewControllerFactory(ProfileViewControllerFactoryAdapter())
            manager.register(factory, for: routeKey)
            print("✅ UIKitRouteHandler: Registered ProfileViewController for key: \(routeKey.key)")
            return true
            
        case "settingsVC":
            let factory = AnyUIKitViewControllerFactory(SettingsViewControllerFactoryAdapter())
            manager.register(factory, for: routeKey)
            print("✅ UIKitRouteHandler: Registered SettingsViewController for key: \(routeKey.key)")
            return true
            
        default:
            // Handle dynamic UIKit routes
            if routeKey.key.hasPrefix("uikit_") {
                // For custom UIKit routes, you could implement dynamic registration
                print("⚠️ UIKitRouteHandler: Custom UIKit route not implemented: \(routeKey.key)")
                return false
            }
            return false
        }
    }
}

// MARK: - Factory Adapters

/// Adapter to make dedicated factories work with type-erased system
private struct ProfileViewControllerFactoryAdapter: UIKitViewControllerFactory {
    typealias Output = UIViewController
    private let factory = ProfileViewControllerFactory()
    
    func present(_ component: UIViewController, with context: RouteContext) {
        factory.present(component, with: context)
    }
    
    func presentViewController(_ viewController: UIViewController, with context: RouteContext) {
        // Create the actual view controller and present it
        let actualViewController = factory.createViewController(with: context)
        present(actualViewController, with: context)
    }
}

private struct SettingsViewControllerFactoryAdapter: UIKitViewControllerFactory {
    typealias Output = UIViewController
    private let factory = SettingsViewControllerFactory()
    
    func present(_ component: UIViewController, with context: RouteContext) {
        factory.present(component, with: context)
    }
    
    func presentViewController(_ viewController: UIViewController, with context: RouteContext) {
        let actualViewController = factory.createViewController(with: context)
        present(actualViewController, with: context)
    }
}

#else

/// Stub UIKit handler for non-UIKit platforms
public class UIKitRouteHandler: BaseRouteRegistrationHandler {
    
    public override init() {
        super.init()
    }
    
    public override func canHandle(routeKey: any RouteKey) -> Bool {
        return false // UIKit not available
    }
    
    @MainActor
    public override func registerRoute(for routeKey: any RouteKey, in manager: any NavigationManagerProtocol) -> Bool {
        print("⚠️ UIKitRouteHandler: UIKit not available on this platform")
        return false
    }
}

#endif
