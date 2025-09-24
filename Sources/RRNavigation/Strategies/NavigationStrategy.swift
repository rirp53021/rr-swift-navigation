// MARK: - Strategy Selection

import Foundation

/// Navigation strategy type
public enum NavigationStrategyType: String, CaseIterable {
    case swiftUI
    case uikit
    
    @MainActor
    public func createStrategy() -> NavigationStrategy {
        switch self {
        case .swiftUI:
            return SwiftUINavigationStrategy()
        case .uikit:
            return UIKitNavigationStrategy()
        }
    }
}

/// Navigation manager factory
public class NavigationManagerFactory {
    @MainActor
    public static func create(
        strategy: NavigationStrategyType,
        persistence: NavigationStatePersistence? = nil
    ) -> any NavigationManagerProtocol {
        let strategyInstance = strategy.createStrategy()
        return NavigationManager(
            strategy: strategyInstance,
            persistence: persistence
        )
    }
    
    @MainActor
    public static func createForSwiftUI(
        persistence: NavigationStatePersistence? = nil
    ) -> any NavigationManagerProtocol {
        return create(strategy: .swiftUI, persistence: persistence)
    }
    
    @MainActor
    public static func createForUIKit(
        persistence: NavigationStatePersistence? = nil
    ) -> any NavigationManagerProtocol {
        return create(strategy: .uikit, persistence: persistence)
    }
}
