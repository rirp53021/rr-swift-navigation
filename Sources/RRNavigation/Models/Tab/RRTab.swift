//
//  RRTab.swift
//  RRNavigation
//
//  Created by Ronald Ivan Ruiz Poveda on 27/09/25.
//

import SwiftUI
import RRUIComponents

public struct RRTab: Identifiable, Hashable {
    public var id: RRTabID
    public let name: String
    public let icon: Image
    public let selectedIcon: Image?
    public let badge: String?
    internal let rootRouteID: RouteID
    
    /// Convert to RRUIComponents TabItem
    public var tabItem: TabItem {
        TabItem(
            title: name,
            icon: icon,
            selectedIcon: selectedIcon,
            badge: badge
        )
    }
    
    /// Initialize tab with a RouteID (will be resolved to view by NavigationManager)
    public init(
        id: RRTabID,
        name: String,
        icon: Image,
        selectedIcon: Image? = nil,
        badge: String? = nil,
        rootRouteID: RouteID
    ) {
        self.id = id
        self.name = name
        self.icon = icon
        self.selectedIcon = selectedIcon
        self.badge = badge
        self.rootRouteID = rootRouteID
    }
    
    public static func == (lhs: RRTab, rhs: RRTab) -> Bool {
        lhs.id.rawValue == rhs.id.rawValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id.rawValue)
    }
}
