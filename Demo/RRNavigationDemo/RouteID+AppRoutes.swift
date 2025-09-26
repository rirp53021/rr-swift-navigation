// MARK: - App Route Keys

import Foundation
import RRNavigation

/// Centralized route definitions using RouteKey pattern
extension RouteID {
    
    // MARK: - SwiftUI Routes
    
    /// New Home screen route
    static let newHome = RouteID("newHome", type: .push)
    
    /// New Settings screen route
    static let newSettings = RouteID("newSettings", type: .push)
    
    /// Nested Navigation screen route
    static let nestedNavigation = RouteID("nestedNavigation", type: .push)
    
    // MARK: - Demo Routes
    
    /// Push navigation demo
    static let pushDemo = RouteID("pushDemo", type: .push)
    
    /// Push A view
    static let pushA = RouteID("pushA", type: .push)
    
    /// Push B view
    static let pushB = RouteID("pushB", type: .push)
    
    /// Push C view
    static let pushC = RouteID("pushC", type: .push)
    
    /// Sheet demo
    static let sheetDemo = RouteID("sheetDemo", type: .sheet)
    
    /// Full screen demo
    static let fullScreenDemo = RouteID("fullScreenDemo", type: .fullScreen)
    
    /// Modal demo
    static let modalDemo = RouteID("modalDemo", type: .modal)
    
    /// Replace demo
    static let replaceDemo = RouteID("replaceDemo", type: .replace)
    
    /// Tab demo
    static let tabDemo = RouteID("tabDemo", type: .tab)
    
    
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
            newHome, newSettings, nestedNavigation,
            pushDemo, pushA, pushB, pushC, sheetDemo, fullScreenDemo, modalDemo, replaceDemo, tabDemo,
            adminDashboard, adminUsers, adminAnalytics,
            productDeepLink, categoryDeepLink, userDeepLink
        ]
    }
    
    /// Get SwiftUI routes only
    static var swiftUIRoutes: [RouteID] {
        return [newHome, newSettings, nestedNavigation]
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
