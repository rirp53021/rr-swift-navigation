import SwiftUI
import RRNavigation

@main
struct RRNavigationDemoApp: App {
    @StateObject private var navigationManager = NavigationManager()
    
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
        // Register navigation handler
        let handler = DemoNavigationHandler()
        navigationManager.registerHandler(handler)
        
        // Register tabs
        let homeFactory = HomeTabFactory()
        let profileFactory = ProfileTabFactory()
        let settingsFactory = SettingsTabFactory()
        
        navigationManager.registerTab(homeFactory)
        navigationManager.registerTab(profileFactory)
        navigationManager.registerTab(settingsFactory)
    }
}
