// MARK: - Base Route Registration Handler

import Foundation
import SwiftUI

/// Base implementation for chain handlers
public class BaseRouteRegistrationHandler: RouteRegistrationHandler {
    public var nextHandler: RouteRegistrationHandler?
    
    public init() {}
    
    @MainActor
    public func handleRegistration(for routeID: RouteID, in manager: any NavigationManagerProtocol) -> Bool {
        // If this handler can handle the route, process it
        if canHandle(routeID: routeID) {
            return registerRoute(for: routeID, in: manager)
        } else {
            // Pass to next handler in chain
            return nextHandler?.handleRegistration(for: routeID, in: manager) ?? false
        }
    }
    
    /// Override this method to determine if this handler can handle the route
    public func canHandle(routeID: RouteID) -> Bool {
        return false
    }
    
    /// Override this method to perform the actual registration
    @MainActor
    public func registerRoute(for routeID: RouteID, in manager: any NavigationManagerProtocol) -> Bool {
        return false
    }
}
