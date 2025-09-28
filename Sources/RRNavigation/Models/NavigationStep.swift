//
//  NavigationStep.swift
//  RRNavigation
//
//  Created by Ronald Ivan Ruiz Poveda on 27/09/25.
//

import SwiftUI

/// Represents a single step in navigation
public struct NavigationStep {
    /// The tab where navigation should occur
    public let tab: RRTabID?
    
    /// The navigation type for this step
    public let type: NavigationType
    
    /// The view factory to create the view
    public let factory: ViewFactory.Type
    
    /// Parameters for the view
    public let params: [String: Any]?
    
    public init(
        tab: RRTabID? = nil,
        type: NavigationType,
        factory: ViewFactory.Type,
        params: [String: Any]? = nil
    ) {
        self.tab = tab
        self.type = type
        self.factory = factory
        self.params = params
    }
}
