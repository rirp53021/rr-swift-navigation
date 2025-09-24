// MARK: - Core Navigation Protocols

import Foundation
import SwiftUI
import Combine

/// Main navigation manager protocol
@MainActor
public protocol NavigationManagerProtocol: ObservableObject {
    var currentState: NavigationState { get }
    
    // Original registration methods
    @MainActor
    func register<T: RouteFactory>(_ factory: T, for routeKey: any RouteKey)
    
    // Chain of Responsibility registration methods
    func registerRoutes(_ routeKeys: [any RouteKey], using chain: RouteRegistrationHandler)
    func registerRoute(_ routeKey: any RouteKey, using chain: RouteRegistrationHandler) -> Bool
    func registerRoutesWithResults(_ routeKeys: [any RouteKey], using chain: RouteRegistrationHandler) -> [String: Bool]
    
    // Navigation methods with string keys
    func navigate(to key: String, parameters: RouteParameters?, in tab: String?)
    func navigate(to key: String, parameters: RouteParameters?, in tab: String?, type: NavigationType)
    
    // Navigation methods with RouteKeys
    func navigate(to routeKey: any RouteKey, parameters: RouteParameters?, in tab: String?)
    
    func navigateBack()
    func navigateToRoot(in tab: String?)
    func setTab(_ tabId: String)
    func registerTab(_ tab: TabConfiguration)
    
    // Modal dismissal methods
    func dismissModal()
    func dismissAllModals()
    func dismissModal(with key: String)
}

/// Navigation strategy protocol
@MainActor
public protocol NavigationStrategy {
    var strategyType: NavigationStrategyType { get }
    var supportedNavigationTypes: Set<NavigationType> { get }
    
    func navigate(to destination: NavigationDestination, with component: Any, in tab: String?)
    func navigateBack()
    func navigateToRoot(in tab: String?)
    func setTab(_ tabId: String)
    func registerTab(_ tab: TabConfiguration)
    
    // Modal dismissal methods
    func dismissModal()
    func dismissAllModals()
    func dismissModal(with key: String)
}

/// Route factory protocol for type erasure
public protocol RouteFactory {
    associatedtype Output
    func present(_ component: Output, with context: RouteContext)
}

/// SwiftUI view factory protocol
public protocol SwiftUIViewFactory: RouteFactory where Output: View {
    func presentView(_ view: AnyView, with context: RouteContext)
}

/// UIKit view controller factory protocol
#if canImport(UIKit)
public protocol UIKitViewControllerFactory: RouteFactory where Output: UIViewController {
    func presentViewController(_ viewController: UIViewController, with context: RouteContext)
}
#else
public protocol UIKitViewControllerFactory: RouteFactory {
    associatedtype Output
    func presentViewController(_ viewController: Any, with context: RouteContext)
}
#endif

/// Navigation state persistence protocol
public protocol NavigationStatePersistence {
    func save(_ state: NavigationState) throws
    func restore() throws -> NavigationState?
    func clear() throws
}

/// Navigation animation configuration
public struct NavigationAnimation: Codable {
    public let duration: TimeInterval
    public let curve: AnimationCurve
    public let spring: SpringConfiguration?
    
    public init(
        duration: TimeInterval = 0.3,
        curve: AnimationCurve = .easeInOut,
        spring: SpringConfiguration? = nil
    ) {
        self.duration = duration
        self.curve = curve
        self.spring = spring
    }
}

public enum AnimationCurve: String, Codable, CaseIterable {
    case easeInOut
    case easeIn
    case easeOut
    case linear
    case spring
}

public struct SpringConfiguration: Codable {
    public let damping: Double
    public let response: Double
    
    public init(damping: Double = 0.8, response: Double = 0.6) {
        self.damping = damping
        self.response = response
    }
}

// MARK: - Route Key Protocols

/// Protocol for route keys that ensures uniqueness
public protocol RouteKey: Hashable, CustomStringConvertible {
    /// The string identifier for the route
    var key: String { get }
    
    /// The presentation type for this route
    var presentationType: NavigationType { get }
}

/// Default implementation
public extension RouteKey {
    var description: String { key }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(key)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.key == rhs.key
    }
}

/// Concrete route key struct
public struct RouteID: RouteKey {
    public let key: String
    public let presentationType: NavigationType
    
    public init(_ key: String, type: NavigationType = .push) {
        self.key = key
        self.presentationType = type
    }
}

// MARK: - Chain of Responsibility Protocols

/// Protocol for chain of responsibility handlers
public protocol RouteRegistrationHandler {
    var nextHandler: RouteRegistrationHandler? { get set }
    @MainActor
    func handleRegistration(for routeKey: any RouteKey, in manager: any NavigationManagerProtocol) -> Bool
}
