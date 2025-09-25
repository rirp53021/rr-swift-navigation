// MARK: - Home View Factory

import SwiftUI
import RRNavigation

/// Factory that creates HomeView as SwiftUI component
public struct HomeViewFactory: ViewFactory {
    public init() {}
    
    public func createView(with context: RouteContext) -> ViewComponent {
        return .swiftUI(AnyView(HomeView()))
    }
}