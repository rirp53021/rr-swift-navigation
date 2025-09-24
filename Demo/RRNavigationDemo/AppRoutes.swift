// MARK: - App Route Keys

import Foundation
import RRNavigation

/// Centralized route definitions using RouteKey pattern
public enum AppRoutes {
    
    // MARK: - SwiftUI Routes
    
    /// Home screen route
    public static let home = RouteID("home", type: .push)
    
    /// Profile screen route
    public static let profile = RouteID("profile", type: .push)
    
    /// Settings screen route (presented as sheet)
    public static let settings = RouteID("settings", type: .sheet)
    
    /// About screen route
    public static let about = RouteID("about", type: .push)
    
    // MARK: - UIKit Routes
    
    /// Profile screen using UIKit view controller
    public static let profileVC = RouteID("profileVC", type: .push)
    
    /// Settings screen using UIKit view controller (presented as sheet)
    public static let settingsVC = RouteID("settingsVC", type: .sheet)
    
    // MARK: - Admin Routes
    
    /// Admin dashboard
    public static let adminDashboard = RouteID("admin_dashboard", type: .push)
    
    /// Admin user management
    public static let adminUsers = RouteID("admin_users", type: .push)
    
    /// Admin analytics (presented as modal)
    public static let adminAnalytics = RouteID("admin_analytics", type: .modal)
    
    // MARK: - Deep Link Routes
    
    /// Product deep link
    public static let productDeepLink = RouteID("deeplink_product", type: .push)
    
    /// Category deep link
    public static let categoryDeepLink = RouteID("deeplink_category", type: .push)
    
    /// User deep link
    public static let userDeepLink = RouteID("deeplink_user", type: .push)
    
    // MARK: - Helper Methods
    
    /// Get all available routes
    public static var allRoutes: [any RouteKey] {
        return [
            home, profile, settings, about,
            profileVC, settingsVC,
            adminDashboard, adminUsers, adminAnalytics,
            productDeepLink, categoryDeepLink, userDeepLink
        ]
    }
    
    /// Get SwiftUI routes only
    public static var swiftUIRoutes: [any RouteKey] {
        return [home, profile, settings, about]
    }
    
    /// Get UIKit routes only
    public static var uiKitRoutes: [any RouteKey] {
        return [profileVC, settingsVC]
    }
    
    /// Get admin routes only
    public static var adminRoutes: [any RouteKey] {
        return [adminDashboard, adminUsers, adminAnalytics]
    }
    
    /// Get deep link routes only
    public static var deepLinkRoutes: [any RouteKey] {
        return [productDeepLink, categoryDeepLink, userDeepLink]
    }
}