// MARK: - Settings View Factory

import SwiftUI
import RRNavigation

/// Factory that creates SettingsView as SwiftUI component
public struct SettingsViewFactory: ViewFactory {
    public init() {}
    
    public func createView(with context: RouteContext) -> ViewComponent {
        return .swiftUI(AnyView(SettingsView()))
    }
}