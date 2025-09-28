//
//  RRTab.swift
//  RRNavigation
//
//  Created by Ronald Ivan Ruiz Poveda on 27/09/25.
//

import SwiftUI

public struct RRTabID: Hashable {
    public let rawValue: String
    
    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}

public struct RRTab: Identifiable, Hashable {
    public var id: RRTabID
    public let name: String
    public let icon: Image?
    internal let rootRouteID: RouteID
    
    /// Initialize tab with a RouteID (will be resolved to view by NavigationManager)
    public init(id: RRTabID, name: String, icon: Image?, rootRouteID: RouteID) {
        self.id = id
        self.name = name
        self.icon = icon
        self.rootRouteID = rootRouteID
    }
    
    public static func == (lhs: RRTab, rhs: RRTab) -> Bool {
        lhs.id.rawValue == rhs.id.rawValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id.rawValue)
    }
    
}
