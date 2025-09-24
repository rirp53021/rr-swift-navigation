import SwiftUI
import RRNavigation

struct HomeView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("🏠 Home")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Welcome to RRNavigation Demo!")
                    .font(.title2)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                VStack(spacing: 20) {
                    NavigationCard<AnyView>(
                        title: "Profile",
                        description: "View user profile with parameters",
                        icon: "person.circle.fill",
                        color: .blue
                    ) {
                        navigationManager.navigate(
                            to: "profile",
                            parameters: RouteParameters(data: ["userId": "home123", "source": "home"]),
                            in: nil
                        )
                    }
                    
                    NavigationCard<AnyView>(
                        title: "Settings",
                        description: "App settings and configuration",
                        icon: "gear.circle.fill",
                        color: .green
                    ) {
                        navigationManager.navigate(
                            to: "settings",
                            parameters: RouteParameters(data: ["section": "general"]),
                            in: nil,
                            type: .sheet
                        )
                    }
                    
                    NavigationCard<AnyView>(
                        title: "UIKit Demo",
                        description: "Test UIKit integration",
                        icon: "iphone.circle.fill",
                        color: .orange
                    ) {
                        navigationManager.navigate(
                            to: "profileVC",
                            parameters: RouteParameters(data: ["demo": "true"]),
                            in: nil,
                            type: .modal
                        )
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("RRNavigation Demo")
        }
    }
}

struct NavigationCard<Content: View>: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(color)
                    .frame(width: 40, height: 40)
                    .background(color.opacity(0.1))
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    HomeView()
        .environmentObject(NavigationManager.shared)
}
