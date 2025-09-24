import SwiftUI
import RRNavigation

@main
struct RRNavigationDemoApp: App {
    @StateObject private var navigationManager: NavigationManager
    
    init() {
        // Create navigation manager with SwiftUI strategy
        let manager = NavigationManagerFactory.createForSwiftUI(
            persistence: InMemoryPersistence()
        )
        _navigationManager = StateObject(wrappedValue: manager as! NavigationManager)
        
        // Register routes
        setupRoutes(manager: manager)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(navigationManager)
        }
    }
    
    private func setupRoutes(manager: any NavigationManagerProtocol) {
        print("🚀 Setting up routes with Strategy Validation...")
        print("=============================================")
        
        // Register SwiftUI view factories using RouteKey definitions (should succeed with SwiftUI strategy)
        print("\n📱 Registering SwiftUI factories using RouteKey definitions:")
        manager.register(HomeViewFactory(), for: AppRoutes.home)
        manager.register(ProfileViewFactory(), for: AppRoutes.profile)
        manager.register(SettingsViewFactory(), for: AppRoutes.settings)
        
        // Register UIKit view controller factories using RouteKey definitions (should be rejected with SwiftUI strategy)
        print("\n📱 Registering UIKit factories using RouteKey definitions (will be rejected by SwiftUI strategy):")
        manager.register(AnyUIKitViewControllerFactory(ProfileViewControllerFactory(navigationManager: manager)), for: AppRoutes.profileVC)
        manager.register(AnyUIKitViewControllerFactory(SettingsViewControllerFactory(navigationManager: manager)), for: AppRoutes.settingsVC)
        
        // Demonstrate Chain of Responsibility with decoupled NavigationManager
        print("\n🔗 Testing Chain of Responsibility with decoupled NavigationManager:")
        let chain = RouteRegistrationChainBuilder()
            .addHandler(SwiftUIRouteHandler())
            .addHandler(UIKitRouteHandler())
            .addHandler(AdminRouteHandler())
            .addHandler(DeepLinkRouteHandler())
            .build()
        
        guard let chain = chain else {
            print("❌ Failed to build chain")
            return
        }
        
        // Pass route keys from the app, not hardcoded in NavigationManager
        manager.registerRoutes(AppRoutes.allRoutes, using: chain)
        
        print("\n✅ Route registration completed! Check logs above for validation results.")
        print("💡 Only SwiftUI factories were accepted due to active SwiftUI strategy.")
        print("🔑 Using centralized RouteKey definitions for type-safe navigation.")
        print("🏗️ NavigationManager is now decoupled and reusable!")
    }
}
