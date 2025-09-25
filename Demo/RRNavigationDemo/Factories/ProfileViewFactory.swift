// MARK: - Profile View Factory

import SwiftUI
import RRNavigation

/// Factory that creates ProfileView as SwiftUI component
public struct ProfileViewFactory: ViewFactory {
    public init() {}
    
    public func createView(with context: RouteContext) -> ViewComponent {
        let userId = context.parameters.data["userId"] ?? "unknown"
        let name = context.parameters.data["name"] ?? "Unknown User"
        
        return .swiftUI(AnyView(ProfileView(userId: userId, name: name)))
    }
}