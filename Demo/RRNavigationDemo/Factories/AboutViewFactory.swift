// MARK: - About View Factory

import SwiftUI
import RRNavigation

/// Factory that creates AboutView as SwiftUI component
public struct AboutViewFactory: ViewFactory {
    public init() {}
    
    public func createView(with context: RouteContext) -> ViewComponent {
        return .swiftUI(AnyView(AboutView()))
    }
}