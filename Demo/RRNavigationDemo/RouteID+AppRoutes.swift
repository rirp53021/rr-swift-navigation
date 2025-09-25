// MARK: - App Route Keys

import Foundation
import RRNavigation

/// Centralized route definitions using RouteKey pattern
extension RouteID {
    
    // MARK: - SwiftUI Routes
    
    /// Home screen route
    static let home = RouteID("home", type: .push)
    
    /// Profile screen route
    static let profile = RouteID("profile", type: .push)
    
    /// Settings screen route (presented as sheet)
    static let settings = RouteID("settings", type: .sheet)
    
    /// About screen route
    static let about = RouteID("about", type: .push)
    
    // MARK: - UIKit Routes
    
    /// Profile screen using UIKit view controller
    static let profileVC = RouteID("profileVC", type: .push)
    
    /// Settings screen using UIKit view controller (presented as sheet)
    static let settingsVC = RouteID("settingsVC", type: .sheet)
    
    // MARK: - Admin Routes
    
    /// Admin dashboard
    static let adminDashboard = RouteID("admin_dashboard", type: .push)
    
    /// Admin user management
    static let adminUsers = RouteID("admin_users", type: .push)
    
    /// Admin analytics (presented as modal)
    static let adminAnalytics = RouteID("admin_analytics", type: .modal)
    
    // MARK: - Deep Link Routes
    
    /// Product deep link
    static let productDeepLink = RouteID("deeplink_product", type: .push)
    
    /// Category deep link
    static let categoryDeepLink = RouteID("deeplink_category", type: .push)
    
    /// User deep link
    static let userDeepLink = RouteID("deeplink_user", type: .push)
    
    // MARK: - Helper Methods
    
    /// Get all available routes
    static var allRoutes: [RouteID] {
        return [
            home, profile, settings, about,
            profileVC, settingsVC,
            adminDashboard, adminUsers, adminAnalytics,
            productDeepLink, categoryDeepLink, userDeepLink
        ]
    }
    
    /// Get SwiftUI routes only
    static var swiftUIRoutes: [RouteID] {
        return [home, profile, settings, about]
    }
    
    /// Get UIKit routes only
    static var uiKitRoutes: [RouteID] {
        return [profileVC, settingsVC]
    }
    
    /// Get admin routes only
    static var adminRoutes: [RouteID] {
        return [adminDashboard, adminUsers, adminAnalytics]
    }
    
    /// Get deep link routes only
    static var deepLinkRoutes: [RouteID] {
        return [productDeepLink, categoryDeepLink, userDeepLink]
    }
}
