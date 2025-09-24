// MARK: - Chain of Responsibility Demo Content View

import SwiftUI
import RRNavigation

struct ChainContentView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ChainHomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            ChainNavigationTestView()
                .tabItem {
                    Image(systemName: "arrow.right.circle.fill")
                    Text("Navigation")
                }
                .tag(1)
            
            ChainAdminView()
                .tabItem {
                    Image(systemName: "lock.shield.fill")
                    Text("Admin")
                }
                .tag(2)
            
            ChainDeepLinkView()
                .tabItem {
                    Image(systemName: "link")
                    Text("Deep Links")
                }
                .tag(3)
        }
        .environmentObject(navigationManager)
    }
}

// MARK: - Chain Home View

struct ChainHomeView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("🔗 Chain of Responsibility")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text("Navigation Demo")
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                VStack(spacing: 15) {
                    NavigationCard<AnyView>(
                        title: "Dedicated Factories",
                        description: "Each view has its own factory",
                        icon: "building.2.fill",
                        color: .blue
                    ) {
                        navigationManager.navigate(to: AppRoutes.about)
                    }
                    
                    NavigationCard<AnyView>(
                        title: "Type-Safe Routes",
                        description: "RouteKey ensures compile-time safety",
                        icon: "key.fill",
                        color: .green
                    ) {
                        navigationManager.navigate(
                            to: AppRoutes.profile,
                            parameters: RouteParameters(data: [
                                "userId": "123",
                                "userName": "Chain Demo User"
                            ])
                        )
                    }
                    
                    NavigationCard<AnyView>(
                        title: "Chain Handlers",
                        description: "Organized route registration",
                        icon: "link",
                        color: .orange
                    ) {
                        navigationManager.navigate(
                            to: AppRoutes.settings,
                            parameters: RouteParameters(data: [
                                "theme": "dark",
                                "notifications": "true"
                            ])
                        )
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Chain Demo")
        }
    }
}

// MARK: - Chain Navigation Test View

struct ChainNavigationTestView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Route Testing")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    VStack(spacing: 15) {
                        SectionHeader(title: "SwiftUI Routes", icon: "swift")
                        
                        RouteTestCard(
                            title: "Home",
                            route: AppRoutes.home,
                            parameters: nil
                        )
                        
                        RouteTestCard(
                            title: "Profile",
                            route: AppRoutes.profile,
                            parameters: RouteParameters(data: [
                                "userId": "456",
                                "userName": "Test User"
                            ])
                        )
                        
                        RouteTestCard(
                            title: "Settings",
                            route: AppRoutes.settings,
                            parameters: RouteParameters(data: [
                                "theme": "light",
                                "notifications": "false"
                            ])
                        )
                        
                        RouteTestCard(
                            title: "About",
                            route: AppRoutes.about,
                            parameters: nil
                        )
                    }
                    
                    VStack(spacing: 15) {
                        SectionHeader(title: "UIKit Routes", icon: "iphone")
                        
                        RouteTestCard(
                            title: "Profile VC",
                            route: AppRoutes.profileVC,
                            parameters: RouteParameters(data: [
                                "userId": "789",
                                "userName": "UIKit User"
                            ])
                        )
                        
                        RouteTestCard(
                            title: "Settings VC",
                            route: AppRoutes.settingsVC,
                            parameters: RouteParameters(data: [
                                "theme": "dark",
                                "notifications": "true"
                            ])
                        )
                    }
                }
                .padding()
            }
            .navigationTitle("Route Tests")
        }
    }
}

// MARK: - Chain Admin View

struct ChainAdminView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("🔐 Admin Panel")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Restricted Area")
                    .font(.body)
                    .foregroundColor(.secondary)
                
                VStack(spacing: 15) {
                    RouteTestCard(
                        title: "Dashboard",
                        route: AppRoutes.adminDashboard,
                        parameters: nil
                    )
                    
                    RouteTestCard(
                        title: "User Management",
                        route: AppRoutes.adminUsers,
                        parameters: nil
                    )
                    
                    RouteTestCard(
                        title: "Analytics",
                        route: AppRoutes.adminAnalytics,
                        parameters: RouteParameters(data: [
                            "dateRange": "30days",
                            "includeDetails": "true"
                        ])
                    )
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Admin")
        }
    }
}

// MARK: - Chain Deep Link View

struct ChainDeepLinkView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("🔗 Deep Links")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Simulate deep link navigation")
                    .font(.body)
                    .foregroundColor(.secondary)
                
                VStack(spacing: 15) {
                    RouteTestCard(
                        title: "Product Link",
                        route: AppRoutes.productDeepLink,
                        parameters: RouteParameters(data: [
                            "productId": "abc123",
                            "category": "electronics"
                        ])
                    )
                    
                    RouteTestCard(
                        title: "Category Link",
                        route: AppRoutes.categoryDeepLink,
                        parameters: RouteParameters(data: [
                            "categoryId": "cat456",
                            "subcategory": "smartphones"
                        ])
                    )
                    
                    RouteTestCard(
                        title: "User Link",
                        route: AppRoutes.userDeepLink,
                        parameters: RouteParameters(data: [
                            "userId": "user789",
                            "action": "view_profile"
                        ])
                    )
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Deep Links")
        }
    }
}

// MARK: - Helper Views


struct RouteTestCard: View {
    let title: String
    let route: any RouteKey
    let parameters: RouteParameters?
    
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        Button {
            navigationManager.navigate(to: route, parameters: parameters)
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    HStack {
                        Text(route.key)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text(route.presentationType.rawValue)
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(4)
                    }
                }
                
                Spacer()
                
                Image(systemName: "arrow.right.circle.fill")
                    .foregroundColor(.blue)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(8)
            .shadow(color: .gray.opacity(0.2), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SectionHeader: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
            
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
            
            Spacer()
        }
        .padding(.top)
    }
}

#Preview {
    ChainContentView()
        .environmentObject(NavigationManager.shared)
}
