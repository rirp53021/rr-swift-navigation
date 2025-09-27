import SwiftUI
import RRNavigation

struct ContentView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var navigationCoordinator: NavigationCoordinator
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab
            NavigationStack(path: navigationCoordinator.getNavigationPath(for: 0)) {
                HomeView()
                    .navigationDestination(for: String.self) { viewId in
                        if let view = navigationCoordinator.viewRegistry[viewId] {
                            view
                        } else {
                            Text("View not found")
                        }
                    }
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            .tag(0)
            
            // Settings Tab
            NavigationStack(path: navigationCoordinator.getNavigationPath(for: 1)) {
                SettingsView()
                    .navigationDestination(for: String.self) { viewId in
                        if let view = navigationCoordinator.viewRegistry[viewId] {
                            view
                        } else {
                            Text("View not found")
                        }
                    }
            }
            .tabItem {
                Image(systemName: "gear")
                Text("Settings")
            }
            .tag(1)
            
            // Nested Navigation Tab
            NavigationStack(path: navigationCoordinator.getNavigationPath(for: 2)) {
                NestedNavigationView()
                    .navigationDestination(for: String.self) { viewId in
                        if let view = navigationCoordinator.viewRegistry[viewId] {
                            view
                        } else {
                            Text("View not found")
                        }
                    }
            }
            .tabItem {
                Image(systemName: "arrow.branch")
                Text("Nested")
            }
            .tag(2)
        }
        .environmentObject(navigationManager)
        .overlay(
            NavigationPresenter(coordinator: navigationCoordinator)
        )
    }
}

#Preview {
    ContentView()
        .environmentObject(NavigationManager(strategy: SwiftUINavigationStrategy()))
}
