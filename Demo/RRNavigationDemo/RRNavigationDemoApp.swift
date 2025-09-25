import SwiftUI
import RRNavigation

@main
struct RRNavigationDemoApp: App {
    @StateObject private var navigationManager: NavigationManager
    @StateObject private var navigationCoordinator: NavigationCoordinator
    
    init() {
        // Create navigation manager with SwiftUI strategy
        let manager = NavigationManagerFactory.createForSwiftUI(
            persistence: InMemoryPersistence()
        )
        _navigationManager = StateObject(wrappedValue: manager as! NavigationManager)
        
        // Create navigation coordinator
        _navigationCoordinator = StateObject(wrappedValue: NavigationCoordinator(navigationManager: manager))
        
        // Register routes
        setupRoutes(manager: manager)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(navigationManager)
                .environmentObject(navigationCoordinator)
        }
    }
    
    private func setupRoutes(manager: any NavigationManagerProtocol) {
        print("🚀 Setting up routes with Strategy Validation...")
        print("=============================================")
        
        // Register SwiftUI view factories using RouteKey definitions (should succeed with SwiftUI strategy)
        print("\n📱 Registering SwiftUI factories using RouteKey definitions:")
        print("🎯 Registering HomeViewFactory for key: \(RouteID.home.key)")
        manager.register(HomeViewFactory(), for: RouteID.home)
        print("🎯 Registering ProfileViewFactory for key: \(RouteID.profile.key)")
        manager.register(ProfileViewFactory(), for: RouteID.profile)
        print("🎯 Registering SettingsViewFactory for key: \(RouteID.settings.key)")
        manager.register(SettingsViewFactory(), for: RouteID.settings)
        
        // Register UIKit view controller factories using RouteKey definitions (should be rejected with SwiftUI strategy)
        print("\n📱 Registering UIKit factories using RouteKey definitions (will be rejected by SwiftUI strategy):")
        manager.register(AnyUIKitViewControllerFactory(ProfileViewControllerFactory()), for: RouteID.profileVC)
        manager.register(AnyUIKitViewControllerFactory(SettingsViewControllerFactory()), for: RouteID.settingsVC)
        
        // Demonstrate Chain of Responsibility with decoupled NavigationManager
        print("\n🔗 Testing Chain of Responsibility with decoupled NavigationManager:")
        let chain = RouteRegistrationChainBuilder()
            .addHandler(AdminRouteHandler())
            .addHandler(DeepLinkRouteHandler())
            .build()
        
        guard let chain = chain else {
            return
        }
        
        // Pass route keys from the app, not hardcoded in NavigationManager
        manager.registerRoutes(RouteID.allRoutes, using: chain)
    }
}
