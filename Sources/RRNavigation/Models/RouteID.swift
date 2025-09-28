//
//  RouteID.swift
//  RRNavigation
//
//  Created by Ronald Ivan Ruiz Poveda on 27/09/25.
//

import Foundation

/// Unique identifier for navigation routes with parameters support
public struct RouteID: Hashable {
    public let value: String
    public private(set) var parameters: [String: AnyHashable]
    
    public init(_ value: String, parameters: [String: AnyHashable] = [:]) {
        self.value = value
        self.parameters = parameters
    }
    
    /// Add a parameter to this route
    /// - Parameters:
    ///   - key: The parameter key
    ///   - value: The parameter value
    /// - Returns: A new RouteID with the added parameter
    public func addingParameter(_ key: String, value: AnyHashable) -> RouteID {
        var newParameters = parameters
        newParameters[key] = value
        return RouteID(self.value, parameters: newParameters)
    }
    
    /// Add multiple parameters to this route
    /// - Parameter parameters: Dictionary of parameters to add
    /// - Returns: A new RouteID with the added parameters
    public func addingParameters(_ parameters: [String: AnyHashable]) -> RouteID {
        var newParameters = self.parameters
        for (key, value) in parameters {
            newParameters[key] = value
        }
        return RouteID(self.value, parameters: newParameters)
    }
    
    /// Get a parameter value for the given key
    /// - Parameter key: The parameter key
    /// - Returns: The parameter value, or nil if not found
    public func parameter<T: Hashable>(for key: String) -> T? {
        return parameters[key] as? T
    }
}
