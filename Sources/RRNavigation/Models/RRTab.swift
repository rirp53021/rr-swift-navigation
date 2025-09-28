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
    private let rootView: AnyView
    
    public init<V: View>(id: RRTabID, name: String, icon: Image?, rootView: V) {
        self.id = id
        self.name = name
        self.icon = icon
        self.rootView = AnyView(rootView)
    }
    
    public static func == (lhs: RRTab, rhs: RRTab) -> Bool {
        lhs.id.rawValue == rhs.id.rawValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id.rawValue)
    }
    
    /// Get the root view for this tab
    @ViewBuilder
    public func getRootView() -> some View {
        rootView
    }
}
