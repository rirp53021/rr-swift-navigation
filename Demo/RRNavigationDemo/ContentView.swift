import SwiftUI
import RRNavigation

struct ContentView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        EmptyView()
            .navigation()
    }
}

#Preview {
    ContentView()
        .environmentObject(NavigationManager(initialModel: .notAuthenticated))
}
