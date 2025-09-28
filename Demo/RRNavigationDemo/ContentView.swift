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
            if navigationManager.currentAppModule == .notAuthenticated {
                // Show login view for not authenticated state
                LoginView()
            } else {
                // Show tabbed navigation for authenticated state
                EmptyView()
                    .modifier(NavigationViewModifier())
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(NavigationManager(initialModel: .notAuthenticated))
}
