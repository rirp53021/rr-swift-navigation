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
            NewContentView()
                .environmentObject(navigationManager)
                .environmentObject(navigationCoordinator)
        }
    }
    
    private func setupRoutes(manager: any NavigationManagerProtocol) {
        print("🚀 Setting up routes with Strategy Validation...")
        print("=============================================")
        
        // Register simple factories using RouteKey definitions
        print("\n📱 Registering simple factories using RouteKey definitions:")
        
        // New demo app factories
        print("🎯 Registering NewHomeViewFactory for key: \(RouteID.newHome.key)")
        manager.register(NewHomeViewFactory(), for: RouteID.newHome)
        print("🎯 Registering NewSettingsViewFactory for key: \(RouteID.newSettings.key)")
        manager.register(NewSettingsViewFactory(), for: RouteID.newSettings)
        print("🎯 Registering NestedNavigationViewFactory for key: \(RouteID.nestedNavigation.key)")
        manager.register(NestedNavigationViewFactory(), for: RouteID.nestedNavigation)
        
        // Demo view factories
        print("🎯 Registering PushDemoViewFactory for key: \(RouteID.pushDemo.key)")
        manager.register(PushDemoViewFactory(), for: RouteID.pushDemo)
        print("🎯 Registering PushAViewFactory for key: \(RouteID.pushA.key)")
        manager.register(PushAViewFactory(), for: RouteID.pushA)
        print("🎯 Registering PushBViewFactory for key: \(RouteID.pushB.key)")
        manager.register(PushBViewFactory(), for: RouteID.pushB)
        print("🎯 Registering PushCViewFactory for key: \(RouteID.pushC.key)")
        manager.register(PushCViewFactory(), for: RouteID.pushC)
        print("🎯 Registering SheetDemoViewFactory for key: \(RouteID.sheetDemo.key)")
        manager.register(SheetDemoViewFactory(), for: RouteID.sheetDemo)
        print("🎯 Registering FullScreenDemoViewFactory for key: \(RouteID.fullScreenDemo.key)")
        manager.register(FullScreenDemoViewFactory(), for: RouteID.fullScreenDemo)
        print("🎯 Registering ModalDemoViewFactory for key: \(RouteID.modalDemo.key)")
        manager.register(ModalDemoViewFactory(), for: RouteID.modalDemo)
        print("🎯 Registering ReplaceDemoViewFactory for key: \(RouteID.replaceDemo.key)")
        manager.register(ReplaceDemoViewFactory(), for: RouteID.replaceDemo)
        print("🎯 Registering TabDemoViewFactory for key: \(RouteID.tabDemo.key)")
        manager.register(TabDemoViewFactory(), for: RouteID.tabDemo)
        
        // Original factories
        print("🎯 Registering HomeViewFactory for key: \(RouteID.home.key)")
        manager.register(HomeViewFactory(), for: RouteID.home)
        print("🎯 Registering ProfileViewFactory for key: \(RouteID.profile.key)")
        manager.register(ProfileViewFactory(), for: RouteID.profile)
        print("🎯 Registering SettingsViewFactory for key: \(RouteID.settings.key)")
        manager.register(SettingsViewFactory(), for: RouteID.settings)
        
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
