// MARK: - Core Navigation Protocols

import Foundation
import SwiftUI
import Combine

/// Main navigation manager protocol
@MainActor
public protocol NavigationManagerProtocol: ObservableObject {
    var currentState: NavigationState { get }
    
    // Registration methods
    @MainActor
    func register<T: ViewFactory>(_ factory: T, for routeID: RouteID)
    
    // Chain of Responsibility registration methods
    func registerRoutes(_ routeIDs: [RouteID], using chain: RouteRegistrationHandler)
    func registerRoute(_ routeID: RouteID, using chain: RouteRegistrationHandler) -> Bool
    func registerRoutesWithResults(_ routeIDs: [RouteID], using chain: RouteRegistrationHandler) -> [String: Bool]
    
    // Navigation methods with RouteID
    func navigate(to routeID: RouteID, parameters: RouteParameters?, in tab: String?)
    func navigate(to routeID: RouteID, parameters: RouteParameters?, in tab: String?, type: NavigationType)
    
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

/// View component enum that can represent either SwiftUI or UIKit views
public enum ViewComponent {
    case swiftUI(AnyView)
    case uiKit(UIViewController)
}

/// Simple factory protocol that creates view components
public protocol ViewFactory {
    /// Create a view component with the given context
    func createView(with context: RouteContext) -> ViewComponent
}

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

// MARK: - Route ID

/// Concrete route identifier struct
public struct RouteID: Hashable, CustomStringConvertible {
    public let key: String
    public let presentationType: NavigationType
    
    public init(_ key: String, type: NavigationType = .push) {
        self.key = key
        self.presentationType = type
    }
    
    // MARK: - Hashable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(key)
    }
    
    public static func == (lhs: RouteID, rhs: RouteID) -> Bool {
        lhs.key == rhs.key
    }
    
    // MARK: - CustomStringConvertible
    public var description: String { key }
}

// MARK: - Chain of Responsibility Protocols

/// Protocol for chain of responsibility handlers
public protocol RouteRegistrationHandler {
    var nextHandler: RouteRegistrationHandler? { get set }
    @MainActor
    func handleRegistration(for routeID: RouteID, in manager: any NavigationManagerProtocol) -> Bool
}
