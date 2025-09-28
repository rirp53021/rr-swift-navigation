//
//  ViewFactory.swift
//  RRNavigation
//
//  Created by Ronald Ivan Ruiz Poveda on 27/09/25.
//

import SwiftUI

/// Protocol for creating views in the navigation system
public protocol ViewFactory<Content> {
    associatedtype Content: View
    /// Creates a view for the given route
    /// - Parameter params: Optional parameters for the view
    /// - Returns: The view to be displayed
    @ViewBuilder static func createView(params: [String: Any]?) -> Content
}

