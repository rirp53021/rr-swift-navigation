// MARK: - About View Factory

import SwiftUI
import Foundation
import RRNavigation
import RRNavigation

public struct AboutViewFactory: SwiftUIViewFactory {
    public typealias Output = AnyView
    
    public init() {}
    
    public func present(_ component: AnyView, with context: RouteContext) {
        print("ℹ️ AboutViewFactory: Creating AboutView")
    }
    
    public func presentView(_ view: AnyView, with context: RouteContext) {
        present(view, with: context)
    }
    
    public func createView(with context: RouteContext) -> AnyView {
        return AnyView(AboutView())
    }
}

// Note: AboutView is defined in Demo/RRNavigationDemo/SwiftUI/AboutView.swift
