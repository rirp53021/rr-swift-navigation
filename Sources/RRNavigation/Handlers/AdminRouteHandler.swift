// MARK: - Admin Route Handler

import Foundation
import SwiftUI

/// Handler for admin routes in the chain of responsibility
public class AdminRouteHandler: BaseRouteRegistrationHandler {
    
    public override init() {
        super.init()
    }
    
    public override func canHandle(routeKey: any RouteKey) -> Bool {
        // Handle admin routes
        return routeKey.key.hasPrefix("admin_")
    }
    
    @MainActor
    public override func registerRoute(for routeKey: any RouteKey, in manager: any NavigationManagerProtocol) -> Bool {
        // Check if current strategy supports admin routes
        let supportedTypes: Set<NavigationType> = [.push, .sheet, .fullScreen, .modal]
        guard supportedTypes.contains(routeKey.presentationType) else {
            print("⚠️ AdminRouteHandler: Strategy does not support \(routeKey.presentationType)")
            return false
        }
        
        switch routeKey.key {
        case "admin_dashboard":
            let factory = AnySwiftUIViewFactory(AdminDashboardFactoryAdapter())
            manager.register(factory, for: routeKey)
            print("✅ AdminRouteHandler: Registered AdminDashboard for key: \(routeKey.key)")
            return true
            
        case "admin_users":
            let factory = AnySwiftUIViewFactory(AdminUsersFactoryAdapter())
            manager.register(factory, for: routeKey)
            print("✅ AdminRouteHandler: Registered AdminUsers for key: \(routeKey.key)")
            return true
            
        case "admin_analytics":
            let factory = AnySwiftUIViewFactory(AdminAnalyticsFactoryAdapter())
            manager.register(factory, for: routeKey)
            print("✅ AdminRouteHandler: Registered AdminAnalytics for key: \(routeKey.key)")
            return true
            
        default:
            print("⚠️ AdminRouteHandler: Unknown admin route: \(routeKey.key)")
            return false
        }
    }
}

// MARK: - Admin Factories

private struct AdminDashboardFactory: SwiftUIViewFactory {
    typealias Output = AnyView
    
    func present(_ component: AnyView, with context: RouteContext) {
        print("📊 AdminDashboardFactory: Creating AdminDashboard")
    }
    
    func presentView(_ view: AnyView, with context: RouteContext) {
        present(view, with: context)
    }
    
    func createView(with context: RouteContext) -> AnyView {
        return AnyView(AdminDashboardView())
    }
}

private struct AdminUsersFactory: SwiftUIViewFactory {
    typealias Output = AnyView
    
    func present(_ component: AnyView, with context: RouteContext) {
        print("👥 AdminUsersFactory: Creating AdminUsers")
    }
    
    func presentView(_ view: AnyView, with context: RouteContext) {
        present(view, with: context)
    }
    
    func createView(with context: RouteContext) -> AnyView {
        return AnyView(AdminUsersView())
    }
}

private struct AdminAnalyticsFactory: SwiftUIViewFactory {
    typealias Output = AnyView
    
    func present(_ component: AnyView, with context: RouteContext) {
        print("📈 AdminAnalyticsFactory: Creating AdminAnalytics")
    }
    
    func presentView(_ view: AnyView, with context: RouteContext) {
        present(view, with: context)
    }
    
    func createView(with context: RouteContext) -> AnyView {
        return AnyView(AdminAnalyticsView())
    }
}

// MARK: - Factory Adapters

private struct AdminDashboardFactoryAdapter: SwiftUIViewFactory {
    typealias Output = AnyView
    private let factory = AdminDashboardFactory()
    
    func present(_ component: AnyView, with context: RouteContext) {
        factory.present(component, with: context)
    }
    
    func presentView(_ view: AnyView, with context: RouteContext) {
        let actualView = factory.createView(with: context)
        present(actualView, with: context)
    }
}

private struct AdminUsersFactoryAdapter: SwiftUIViewFactory {
    typealias Output = AnyView
    private let factory = AdminUsersFactory()
    
    func present(_ component: AnyView, with context: RouteContext) {
        factory.present(component, with: context)
    }
    
    func presentView(_ view: AnyView, with context: RouteContext) {
        let actualView = factory.createView(with: context)
        present(actualView, with: context)
    }
}

private struct AdminAnalyticsFactoryAdapter: SwiftUIViewFactory {
    typealias Output = AnyView
    private let factory = AdminAnalyticsFactory()
    
    func present(_ component: AnyView, with context: RouteContext) {
        factory.present(component, with: context)
    }
    
    func presentView(_ view: AnyView, with context: RouteContext) {
        let actualView = factory.createView(with: context)
        present(actualView, with: context)
    }
}

// MARK: - Demo Admin Views

private struct AdminDashboardView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("📊 Admin Dashboard")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Welcome to the admin area")
                .font(.body)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 10) {
                Label("User Management", systemImage: "person.3.fill")
                Label("Analytics & Reports", systemImage: "chart.bar.fill")
                Label("System Settings", systemImage: "gearshape.2.fill")
                Label("Security Center", systemImage: "shield.fill")
            }
            .padding()
            .background(Color.red.opacity(0.1))
            .cornerRadius(10)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Admin")
    }
}

private struct AdminUsersView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("👥 User Management")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            List {
                UserRow(name: "John Doe", email: "john@example.com", role: "Admin")
                UserRow(name: "Jane Smith", email: "jane@example.com", role: "User")
                UserRow(name: "Bob Johnson", email: "bob@example.com", role: "Moderator")
            }
        }
        .navigationTitle("Users")
    }
}

private struct AdminAnalyticsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("📈 Analytics")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 15) {
                AnalyticsCard(title: "Total Users", value: "1,234", change: "+12%")
                AnalyticsCard(title: "Active Sessions", value: "456", change: "+5%")
                AnalyticsCard(title: "Revenue", value: "$12,345", change: "+18%")
                AnalyticsCard(title: "Performance", value: "98.5%", change: "+2%")
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle("Analytics")
    }
}

private struct UserRow: View {
    let name: String
    let email: String
    let role: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(name)
                .fontWeight(.medium)
            Text(email)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(role)
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .background(Color.blue.opacity(0.2))
                .cornerRadius(4)
        }
    }
}

private struct AnalyticsCard: View {
    let title: String
    let value: String
    let change: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            
            Spacer()
            
            Text(change)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.green)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}
