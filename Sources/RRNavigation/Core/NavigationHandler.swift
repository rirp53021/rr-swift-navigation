//
//  NavigationHandler.swift
//  RRNavigation
//
//  Created by Ronald Ivan Ruiz Poveda on 27/09/25.
//

import SwiftUI

/// Protocol defining the chain responsibility pattern for navigation handlers
/// A NavigationHandler represents a group of multiple related views that can be navigated together
/// NavigationHandlers always support multiple views - never single views
public protocol NavigationHandler {
    /// Determines if this handler can handle navigation for the given route
    /// - Parameter route: The route identifier to check
    /// - Returns: True if this handler can handle the navigation
    func canNavigate(to route: RouteID) -> Bool
    
    /// Gets the navigation steps for the given route
    /// - Parameter route: The route identifier
    /// - Returns: Array of navigation steps to perform
    func getNavigation(to route: RouteID) -> NavigationStep?
}
