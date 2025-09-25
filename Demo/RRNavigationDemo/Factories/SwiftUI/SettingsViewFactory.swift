// MARK: - Settings View Factory

import SwiftUI
import Foundation
import RRNavigation

public struct SettingsViewFactory: SwiftUIViewFactory {
    public typealias Output = AnyView
    
    public init() {}
    
    public func present(_ component: AnyView, with context: RouteContext) {
        print("⚙️ SettingsViewFactory: Creating SettingsView")
    }
    
    public func presentView(_ view: AnyView, with context: RouteContext) {
        present(view, with: context)
    }
    
    public func createView(with context: RouteContext) -> AnyView {
        return AnyView(SettingsView())
    }
}

// Note: SettingsView is defined in Demo/RRNavigationDemo/SwiftUI/SettingsView.swift
