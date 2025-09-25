// MARK: - Deep Link Route Handler

import Foundation
import SwiftUI

/// Handler for deep link routes in the chain of responsibility
public class DeepLinkRouteHandler: BaseRouteRegistrationHandler {
    
    public override init() {
        super.init()
    }
    
    public override func canHandle(routeID: RouteID) -> Bool {
        // Handle deep link routes
        return routeID.key.hasPrefix("deeplink_")
    }
    
    @MainActor
    public override func registerRoute(for routeID: RouteID, in manager: any NavigationManagerProtocol) -> Bool {
        // Check if current strategy supports deep link routes
        let supportedTypes: Set<NavigationType> = [.push, .sheet, .fullScreen, .modal]
        guard supportedTypes.contains(routeID.presentationType) else {
            print("⚠️ DeepLinkRouteHandler: Strategy does not support \(routeID.presentationType)")
            return false
        }
        
        // This handler is generic and doesn't register specific views
        // Specific deep link view registration should be done in the app layer
        print("✅ DeepLinkRouteHandler: Can handle deep link route: \(routeID.key)")
        return true
    }
}
