// MARK: - Main Navigation Manager

import Foundation
import SwiftUI
import Combine

@MainActor
public class NavigationManager: NavigationManagerProtocol {
    
    // MARK: - Properties
    
    public let activeStrategy: NavigationStrategyProtocol
    private let persistence: NavigationStatePersistable?
    private var factories: [String: AnyRouteFactory] = [:]
    private var tabConfigurations: [String: TabConfiguration] = [:]
    private var navigationHistory: [String] = []
    private let maxHistorySize = 50
    private let logger = Logger.shared
    
    @Published public var currentState = NavigationState()
    
    // MARK: - Singleton
    
    public static let shared: NavigationManager = {
        let strategy = NavigationStrategyType.swiftUI.createStrategy()
        return NavigationManager(strategy: strategy)
    }()
    
    // MARK: - Initialization
    
    public init(
        strategy: NavigationStrategyProtocol,
        persistence: NavigationStatePersistable? = nil
    ) {
        self.activeStrategy = strategy
        self.persistence = persistence
        setupInitialState()
    }
    
    // MARK: - Public Methods
    
    public func register<T: RouteFactoryProtocol>(_ factory: T, for key: String) throws {
        guard !key.isEmpty else {
            throw NavigationError.invalidRouteKey
        }
        
        factories[key] = AnyRouteFactory(factory)
        logger.info("Registered route factory for key: \(key)")
    }
    
    public func register<T: SwiftUIViewFactoryProtocol>(_ factory: T, for key: String) throws {
        guard !key.isEmpty else {
            throw NavigationError.invalidRouteKey
        }
        
        factories[key] = AnyRouteFactory(AnySwiftUIViewFactory(factory))
        logger.info("Registered SwiftUI view factory for key: \(key)")
    }
    
    public func register<T: UIKitViewControllerFactoryProtocol>(_ factory: T, for key: String) throws {
        guard !key.isEmpty else {
            throw NavigationError.invalidRouteKey
        }
        
        factories[key] = AnyRouteFactory(AnyUIKitViewControllerFactory(factory))
        logger.info("Registered UIKit view controller factory for key: \(key)")
    }
    
    public func navigate(to key: String, parameters: RouteParameters? = nil, in tab: String? = nil) async throws {
        guard let factory = factories[key] else {
            logger.warning("Route not found: \(key), falling back to home")
            try await navigateToHome()
            return
        }
        
        // Check for circular navigation
        if navigationHistory.contains(key) {
            logger.warning("Circular navigation detected for route: \(key)")
            throw NavigationError.circularNavigation(key)
        }
        
        let context = RouteContext(
            key: key,
            parameters: parameters ?? RouteParameters(),
            navigationType: .push, // Default, can be overridden
            tabId: tab
        )
        
        let destination = NavigationDestination(
            key: key,
            parameters: context.parameters,
            navigationType: context.navigationType,
            tabId: tab
        )
        
        currentState.isNavigating = true
        defer {
            currentState.isNavigating = false
        }
        
        do {
            try await activeStrategy.navigate(to: destination, in: tab)
            updateNavigationState(destination: destination)
            saveState()
            logger.info("Successfully navigated to: \(key)")
        } catch {
            logger.error("Navigation failed for key: \(key), error: \(error)")
            try await handleNavigationError(error, for: key)
        }
    }
    
    public func navigateBack() async throws {
        currentState.isNavigating = true
        defer {
            currentState.isNavigating = false
        }
        
        do {
            try await activeStrategy.navigateBack()
            updateNavigationStateAfterBack()
            saveState()
            logger.info("Successfully navigated back")
        } catch {
            logger.error("Navigate back failed: \(error)")
            throw error
        }
    }
    
    public func navigateToRoot(in tab: String? = nil) async throws {
        currentState.isNavigating = true
        defer {
            currentState.isNavigating = false
        }
        
        do {
            try await activeStrategy.navigateToRoot(in: tab)
            resetNavigationState(for: tab)
            saveState()
            logger.info("Successfully navigated to root in tab: \(tab ?? "all")")
        } catch {
            logger.error("Navigate to root failed: \(error)")
            throw error
        }
    }
    
    public func setTab(_ tabId: String) async throws {
        currentState.isNavigating = true
        defer {
            currentState.isNavigating = false
        }
        
        do {
            try await activeStrategy.setTab(tabId)
            currentState.currentTab = tabId
            saveState()
            logger.info("Successfully switched to tab: \(tabId)")
        } catch {
            logger.error("Set tab failed: \(error)")
            throw error
        }
    }
    
    // MARK: - Private Methods
    
    private func setupInitialState() {
        // Load persisted state if available
        if let persistedState = try? persistence?.restore() {
            currentState = persistedState
            logger.info("Restored navigation state from persistence")
        }
    }
    
    private func navigateToHome() async throws {
        // Find default tab or first tab
        let defaultTab = tabConfigurations.values.first { $0.isDefault }?.id ?? tabConfigurations.keys.first
        try await navigate(to: "home", in: defaultTab)
    }
    
    private func updateNavigationState(destination: NavigationDestination) {
        let routeToken = RouteToken(
            key: destination.key,
            parameters: destination.parameters,
            navigationType: destination.navigationType
        )
        
        if let tabId = destination.tabId {
            if currentState.tabStates[tabId] == nil {
                currentState.tabStates[tabId] = TabNavigationState(tabId: tabId)
            }
            currentState.tabStates[tabId]?.navigationStack.append(routeToken)
            currentState.tabStates[tabId]?.isActive = true
            currentState.tabStates[tabId]?.lastAccessed = Date()
            currentState.currentTab = tabId
        } else {
            // Modal navigation
            let modalDestination = ModalDestination(
                key: destination.key,
                parameters: destination.parameters,
                navigationType: destination.navigationType
            )
            currentState.modalStack.append(modalDestination)
        }
        
        // Update history
        navigationHistory.append(destination.key)
        if navigationHistory.count > maxHistorySize {
            navigationHistory.removeFirst()
        }
    }
    
    private func updateNavigationStateAfterBack() {
        if let currentTab = currentState.currentTab,
           !(currentState.tabStates[currentTab]?.navigationStack.isEmpty ?? true) {
            currentState.tabStates[currentTab]?.navigationStack.removeLast()
        } else if !currentState.modalStack.isEmpty {
            currentState.modalStack.removeLast()
        }
        
        if !navigationHistory.isEmpty {
            navigationHistory.removeLast()
        }
    }
    
    private func resetNavigationState(for tab: String?) {
        if let tabId = tab {
            currentState.tabStates[tabId]?.navigationStack.removeAll()
        } else {
            currentState.modalStack.removeAll()
        }
    }
    
    private func saveState() {
        do {
            try persistence?.save(currentState)
        } catch {
            logger.error("Failed to save navigation state: \(error)")
        }
    }
    
    private func handleNavigationError(_ error: Error, for key: String) async throws {
        // Implement fallback logic
        logger.warning("Handling navigation error for key: \(key), error: \(error)")
        try await navigateToHome()
    }
}
