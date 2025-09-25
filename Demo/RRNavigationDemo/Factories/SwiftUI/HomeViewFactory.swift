// MARK: - Home View Factory

import SwiftUI
import Foundation
import RRNavigation

public struct HomeViewFactory: SwiftUIViewFactory {
    public typealias Output = AnyView
    
    public init() {}
    
    public func present(_ component: AnyView, with context: RouteContext) {
        // In a real implementation, this would handle the presentation
        // For the factory pattern, we just create the view
        print("🏠 HomeViewFactory: Creating HomeView")
    }
    
    public func presentView(_ view: AnyView, with context: RouteContext) {
        present(view, with: context)
    }
    
    public func createView(with context: RouteContext) -> AnyView {
        return AnyView(HomeView())
    }
}

// Note: HomeView is defined in Demo/RRNavigationDemo/SwiftUI/HomeView.swift


