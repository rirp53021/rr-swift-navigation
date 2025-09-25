// MARK: - Admin Route Handler

import Foundation
import SwiftUI

/// Handler for admin routes in the chain of responsibility
public class AdminRouteHandler: BaseRouteRegistrationHandler {
    
    public override init() {
        super.init()
    }
    
    public override func canHandle(routeID: RouteID) -> Bool {
        // Handle admin routes
        return routeID.key.hasPrefix("admin_")
    }
    
    @MainActor
    public override func registerRoute(for routeID: RouteID, in manager: any NavigationManagerProtocol) -> Bool {
        // Check if current strategy supports admin routes
        let supportedTypes: Set<NavigationType> = [.push, .sheet, .fullScreen, .modal]
        guard supportedTypes.contains(routeID.presentationType) else {
            print("⚠️ AdminRouteHandler: Strategy does not support \(routeID.presentationType)")
            return false
        }
        
        // This handler is generic and doesn't register specific views
        // Specific admin view registration should be done in the app layer
        print("✅ AdminRouteHandler: Can handle admin route: \(routeID.key)")
        return true
    }
}

// MARK: - Factory Adapters
// Note: Specific admin view adapters should be defined in the app layer, not in the library