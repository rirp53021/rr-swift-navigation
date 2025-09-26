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
        
        // Register simple factories using RouteKey definitions
        
        // New demo app factories
        manager.register(NewHomeViewFactory(), for: .newHome)
        manager.register(NewSettingsViewFactory(), for: .newSettings)
        manager.register(NestedNavigationViewFactory(), for: .nestedNavigation)
        
        // Demo view factories
        manager.register(PushDemoViewFactory(), for: .pushDemo)
        manager.register(PushAViewFactory(), for: .pushA)
        manager.register(PushBViewFactory(), for: .pushB)
        manager.register(PushCViewFactory(), for: .pushC)
        manager.register(SheetDemoViewFactory(), for: .sheetDemo)
        manager.register(FullScreenDemoViewFactory(), for: .fullScreenDemo)
        manager.register(ModalDemoViewFactory(), for: .modalDemo)
        manager.register(ReplaceDemoViewFactory(), for: .replaceDemo)
        manager.register(TabDemoViewFactory(), for: .tabDemo)
        
        
        // Demonstrate Chain of Responsibility with decoupled NavigationManager
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
