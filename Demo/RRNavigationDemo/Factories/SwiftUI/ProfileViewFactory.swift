// MARK: - Profile View Factory

import SwiftUI
import Foundation
import RRNavigation

public struct ProfileViewFactory: SwiftUIViewFactory {
    public typealias Output = AnyView
    
    public init() {}
    
    public func present(_ component: AnyView, with context: RouteContext) {
        print("👤 ProfileViewFactory: Creating ProfileView")
    }
    
    public func presentView(_ view: AnyView, with context: RouteContext) {
        present(view, with: context)
    }
    
    public func createView(with context: RouteContext) -> AnyView {
        let userId = context.parameters.data["userId"] ?? "unknown"
        let name = context.parameters.data["name"] ?? "Unknown User"
        
        return AnyView(ProfileView(userId: userId, name: name))
    }
}

// Note: ProfileView is defined in Demo/RRNavigationDemo/SwiftUI/ProfileView.swift
