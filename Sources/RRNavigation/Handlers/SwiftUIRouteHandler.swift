// MARK: - SwiftUI Route Handler

import Foundation
import SwiftUI

/// Handler for SwiftUI routes in the chain of responsibility
public class SwiftUIRouteHandler: BaseRouteRegistrationHandler {
    
    public override init() {
        super.init()
    }
    
    public override func canHandle(routeKey: any RouteKey) -> Bool {
        // Handle SwiftUI routes based on key prefix or specific keys
        return routeKey.key.hasPrefix("swiftui_") ||
               ["home", "profile", "settings", "about"].contains(routeKey.key)
    }
    
    @MainActor
    public override func registerRoute(for routeKey: any RouteKey, in manager: any NavigationManagerProtocol) -> Bool {
        // Check if current strategy supports SwiftUI
        let supportedTypes: Set<NavigationType> = [.push, .sheet, .fullScreen, .modal]
        guard supportedTypes.contains(routeKey.presentationType) else {
            print("⚠️ SwiftUIRouteHandler: Strategy does not support \(routeKey.presentationType)")
            return false
        }
        
        switch routeKey.key {
        case "home":
            let factory = AnySwiftUIViewFactory(HomeViewFactoryAdapter())
            manager.register(factory, for: routeKey)
            print("✅ SwiftUIRouteHandler: Registered HomeView for key: \(routeKey.key)")
            return true
            
        case "profile":
            let factory = AnySwiftUIViewFactory(ProfileViewFactoryAdapter())
            manager.register(factory, for: routeKey)
            print("✅ SwiftUIRouteHandler: Registered ProfileView for key: \(routeKey.key)")
            return true
            
        case "settings":
            let factory = AnySwiftUIViewFactory(SettingsViewFactoryAdapter())
            manager.register(factory, for: routeKey)
            print("✅ SwiftUIRouteHandler: Registered SettingsView for key: \(routeKey.key)")
            return true
            
        case "about":
            let factory = AnySwiftUIViewFactory(AboutViewFactoryAdapter())
            manager.register(factory, for: routeKey)
            print("✅ SwiftUIRouteHandler: Registered AboutView for key: \(routeKey.key)")
            return true
            
        default:
            // Handle dynamic SwiftUI routes
            if routeKey.key.hasPrefix("swiftui_") {
                // For custom SwiftUI routes, you could implement dynamic registration
                print("⚠️ SwiftUIRouteHandler: Custom SwiftUI route not implemented: \(routeKey.key)")
                return false
            }
            return false
        }
    }
}

// MARK: - Factory Adapters

/// Adapter to make dedicated factories work with type-erased system
private struct HomeViewFactoryAdapter: SwiftUIViewFactory {
    typealias Output = AnyView
    private let factory = HomeViewFactory()
    
    func present(_ component: AnyView, with context: RouteContext) {
        factory.present(component, with: context)
    }
    
    func presentView(_ view: AnyView, with context: RouteContext) {
        // Create the actual view and present it
        let actualView = factory.createView(with: context)
        present(actualView, with: context)
    }
}

private struct ProfileViewFactoryAdapter: SwiftUIViewFactory {
    typealias Output = AnyView
    private let factory = ProfileViewFactory()
    
    func present(_ component: AnyView, with context: RouteContext) {
        factory.present(component, with: context)
    }
    
    func presentView(_ view: AnyView, with context: RouteContext) {
        let actualView = factory.createView(with: context)
        present(actualView, with: context)
    }
}

private struct SettingsViewFactoryAdapter: SwiftUIViewFactory {
    typealias Output = AnyView
    private let factory = SettingsViewFactory()
    
    func present(_ component: AnyView, with context: RouteContext) {
        factory.present(component, with: context)
    }
    
    func presentView(_ view: AnyView, with context: RouteContext) {
        let actualView = factory.createView(with: context)
        present(actualView, with: context)
    }
}

private struct AboutViewFactoryAdapter: SwiftUIViewFactory {
    typealias Output = AnyView
    private let factory = AboutViewFactory()
    
    func present(_ component: AnyView, with context: RouteContext) {
        factory.present(component, with: context)
    }
    
    func presentView(_ view: AnyView, with context: RouteContext) {
        let actualView = factory.createView(with: context)
        present(actualView, with: context)
    }
}
