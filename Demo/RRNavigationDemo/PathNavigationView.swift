import SwiftUI
import RRNavigation

struct PathNavigationView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var navigationPath: [String] = []
    @State private var selectedRoute: String = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 8) {
                    Text("Path-Based Navigation")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Demonstrates type-safe navigation using RouteKey definitions")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top)
                
                // Current Path Display
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Current Navigation Path")
                            .font(.headline)
                        
                        Spacer()
                        
                        if !navigationPath.isEmpty {
                            Text("\(navigationPath.count) steps")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    if navigationPath.isEmpty {
                        HStack {
                            Image(systemName: "map")
                                .foregroundColor(.secondary)
                            Text("No navigation yet")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .italic()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                    } else {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(Array(navigationPath.enumerated()), id: \.offset) { index, route in
                                HStack {
                                    ZStack {
                                        Circle()
                                            .fill(Color.blue)
                                            .frame(width: 24, height: 24)
                                        
                                        Text("\(index + 1)")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                    }
                                    
                                    Text(route)
                                        .font(.body)
                                        .fontWeight(.medium)
                                    
                                    Spacer()
                                    
                                    if index < navigationPath.count - 1 {
                                        Image(systemName: "arrow.down")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.blue.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                        )
                )
                
                // Route Selection
                VStack(alignment: .leading, spacing: 12) {
                    Text("Select Route to Navigate")
                        .font(.headline)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 12) {
                        ForEach(availableRoutes, id: \.key) { route in
                            RouteButton(
                                route: route,
                                isSelected: selectedRoute == route.key,
                                action: {
                                    selectedRoute = route.key
                                    navigateToRoute(route)
                                }
                            )
                        }
                    }
                }
                
                // Navigation Controls
                VStack(spacing: 16) {
                    Text("Navigation Controls")
                        .font(.headline)
                    
                    VStack(spacing: 12) {
                        HStack(spacing: 16) {
                            Button(action: navigateBack) {
                                HStack {
                                    Image(systemName: "arrow.left")
                                    Text("Back")
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.bordered)
                            .disabled(navigationPath.isEmpty)
                            
                            Button(action: navigateToRoot) {
                                HStack {
                                    Image(systemName: "house")
                                    Text("Root")
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.bordered)
                            .disabled(navigationPath.isEmpty)
                        }
                        
                        Button(action: clearPath) {
                            HStack {
                                Image(systemName: "trash")
                                Text("Clear Path")
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .foregroundColor(.red)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                )
                
                // Route Information
                VStack(alignment: .leading, spacing: 12) {
                    Text("Available Routes")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        RouteInfoSection(
                            title: "SwiftUI Routes",
                            routes: AppRoutes.swiftUIRoutes,
                            color: .green
                        )
                        
                        RouteInfoSection(
                            title: "UIKit Routes",
                            routes: AppRoutes.uiKitRoutes,
                            color: .orange
                        )
                        
                        RouteInfoSection(
                            title: "Admin Routes",
                            routes: AppRoutes.adminRoutes,
                            color: .purple
                        )
                        
                        RouteInfoSection(
                            title: "Deep Link Routes",
                            routes: AppRoutes.deepLinkRoutes,
                            color: .blue
                        )
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            }
            .padding()
        }
        .navigationTitle("Path Navigation")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Computed Properties
    
    private var availableRoutes: [any RouteKey] {
        return AppRoutes.allRoutes
    }
    
    // MARK: - Navigation Methods
    
    private func navigateToRoute(_ route: any RouteKey) {
        let parameters = RouteParameters(data: [
            "userId": "path_user_123",
            "timestamp": "\(Date().timeIntervalSince1970)",
            "source": "path_navigation"
        ])
        
        navigationManager.navigate(to: route, parameters: parameters, in: nil)
        
        // Update local path tracking
        if !navigationPath.contains(route.key) {
            navigationPath.append(route.key)
        }
    }
    
    private func navigateBack() {
        navigationManager.navigateBack()
        
        // Update local path tracking
        if !navigationPath.isEmpty {
            navigationPath.removeLast()
        }
    }
    
    private func navigateToRoot() {
        navigationManager.navigateToRoot(in: nil)
        navigationPath.removeAll()
    }
    
    private func clearPath() {
        navigationPath.removeAll()
        selectedRoute = ""
    }
}

// MARK: - Supporting Views

struct RouteButton: View {
    let route: any RouteKey
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Text(route.key)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .foregroundColor(isSelected ? .white : .primary)
                
                Text(route.presentationType.rawValue.uppercased())
                    .font(.caption2)
                    .foregroundColor(isSelected ? .white.opacity(0.8) : .secondary)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.blue : Color.gray.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3), lineWidth: 1)
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct RouteInfoSection: View {
    let title: String
    let routes: [any RouteKey]
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Circle()
                    .fill(color)
                    .frame(width: 10, height: 10)
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("\(routes.count) routes")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            ForEach(routes, id: \.key) { route in
                HStack {
                    Circle()
                        .fill(color.opacity(0.3))
                        .frame(width: 6, height: 6)
                    
                    Text(route.key)
                        .font(.caption)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    Text(route.presentationType.rawValue.uppercased())
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(color.opacity(0.1))
                        )
                }
                .padding(.leading, 16)
            }
        }
    }
}

#Preview {
    PathNavigationView()
        .environmentObject(NavigationManager.shared)
}
