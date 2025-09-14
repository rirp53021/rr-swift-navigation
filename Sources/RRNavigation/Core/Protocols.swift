// MARK: - Core Navigation Protocols

import Foundation
import SwiftUI
import Combine

/// Main navigation manager protocol
@MainActor
public protocol NavigationManagerProtocol: ObservableObject {
    var currentState: NavigationState { get }
    var activeStrategy: NavigationStrategyProtocol { get }
    
    func register<T: RouteFactoryProtocol>(_ factory: T, for key: String) throws
    func navigate(to key: String, parameters: RouteParameters?, in tab: String?) async throws
    func navigateBack() async throws
    func navigateToRoot(in tab: String?) async throws
    func setTab(_ tabId: String) async throws
}

/// Navigation strategy protocol
@MainActor
public protocol NavigationStrategyProtocol {
    var navigationType: NavigationType { get }
    var supportedNavigationTypes: Set<NavigationType> { get }
    
    func navigate(to destination: NavigationDestination, in tab: String?) async throws
    func navigateBack() async throws
    func navigateToRoot(in tab: String?) async throws
    func setTab(_ tabId: String) async throws
    func registerTab(_ tab: TabConfiguration) throws
}

/// Route factory protocol for type erasure
public protocol RouteFactoryProtocol {
    associatedtype Output
    func build(with context: RouteContext) throws -> Output
}

/// SwiftUI view factory protocol
public protocol SwiftUIViewFactoryProtocol: RouteFactoryProtocol where Output: View {
    func buildView(with context: RouteContext) throws -> AnyView
}

/// UIKit view controller factory protocol
#if canImport(UIKit)
public protocol UIKitViewControllerFactoryProtocol: RouteFactoryProtocol where Output: UIViewController {
    func buildViewController(with context: RouteContext) throws -> Output
}
#else
public protocol UIKitViewControllerFactoryProtocol: RouteFactoryProtocol {
    associatedtype Output
    func buildViewController(with context: RouteContext) throws -> Output
}
#endif

/// Navigation state persistence protocol
public protocol NavigationStatePersistable {
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
