import SwiftUI
import RRNavigation

struct NewContentView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab
            NavigationView {
                NewHomeView()
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            .tag(0)
            
            // Settings Tab
            NavigationView {
                NewSettingsView()
            }
            .tabItem {
                Image(systemName: "gear")
                Text("Settings")
            }
            .tag(1)
            
            // Nested Navigation Tab
            NavigationView {
                NestedNavigationView()
            }
            .tabItem {
                Image(systemName: "arrow.branch")
                Text("Nested")
            }
            .tag(2)
        }
        .environmentObject(navigationManager)
    }
}

#Preview {
    NewContentView()
        .environmentObject(NavigationManager(strategy: SwiftUINavigationStrategy()))
}
