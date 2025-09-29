import SwiftUI
import RRNavigation

struct ContentView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        VStack {
            // App Module Control
            HStack {
                Button("Not Authenticated") {
                    navigationManager.setAppModule(.notAuthenticated)
                }
                .buttonStyle(.bordered)
                .foregroundColor(.red)
                
                Button("Authenticated") {
                    navigationManager.setAppModule(.authenticated)
                }
                .buttonStyle(.bordered)
                .foregroundColor(.green)
            }
            .padding()
            
            // Main Content
            if let currentAppModuleID = navigationManager.currentAppModule,
               let currentAppModule = navigationManager.appModules.first(where: { $0.id == currentAppModuleID }) {
                switch currentAppModule.contentMode {
                case .contentOnly:
                    // Show content-only view (like login)
                    let rootView = AnyView(currentAppModule.rootView.createView(params: nil))
                    NavigationStack(path: $navigationManager.currentNavigationPath) {
                        rootView
                    }
                case .tabStructure:
                    // Show tabbed navigation
                    EmptyView()
                        .modifier(NavigationViewModifier())
                }
            } else {
                // Fallback if no current app module
                Text("No App Module Selected")
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(NavigationManager(initialModel: .notAuthenticated))
}
