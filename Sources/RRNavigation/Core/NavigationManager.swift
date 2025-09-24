// MARK: - Main Navigation Manager

import Foundation
import SwiftUI
import Combine

@MainActor
public class NavigationManager: NavigationManagerProtocol {
    
    // MARK: - Properties
    
    public let activeStrategy: NavigationStrategy
    private let persistence: NavigationStatePersistence?
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
        strategy: NavigationStrategy,
        persistence: NavigationStatePersistence? = nil
    ) {
        self.activeStrategy = strategy
        self.persistence = persistence
        setupInitialState()
    }
    
    // MARK: - Public Methods
    
    public func register<T: RouteFactory>(_ factory: T, for key: String) {
        guard !key.isEmpty else {
            logger.error("Invalid route key: empty string")
            return
        }
        
        factories[key] = AnyRouteFactory(factory)
        logger.info("Registered route factory for key: \(key)")
    }
    
    public func register<T: SwiftUIViewFactory>(_ factory: T, for key: String) {
        guard !key.isEmpty else {
            logger.error("Invalid route key: empty string")
            return
        }
        
        factories[key] = AnyRouteFactory(AnySwiftUIViewFactory(factory))
        logger.info("Registered SwiftUI view factory for key: \(key)")
    }
    
    public func register<T: UIKitViewControllerFactory>(_ factory: T, for key: String) {
        guard !key.isEmpty else {
            logger.error("Invalid route key: empty string")
            return
        }
        
        factories[key] = AnyRouteFactory(AnyUIKitViewControllerFactory(factory))
        logger.info("Registered UIKit view controller factory for key: \(key)")
    }
    
    public func register<T: RouteFactory>(_ factory: T, for routeKey: any RouteKey) {
        guard !routeKey.key.isEmpty else {
            logger.error("Invalid route key: empty string")
            return
        }
        
        // Check if factory is compatible with active strategy
        guard isFactoryCompatibleWithActiveStrategy(factory) else {
            logger.warning("Factory for route '\(routeKey.key)' is not compatible with active strategy (\(activeStrategyType)). Skipping registration.")
            return
        }
        
        factories[routeKey.key] = AnyRouteFactory(factory)
        logger.info("Registered route factory for key: \(routeKey.key) with type: \(routeKey.presentationType)")
    }
    
    public func registerRoutes(_ routeKeys: [any RouteKey], using chain: RouteRegistrationHandler) {
        var successCount = 0
        var failureCount = 0
        
        for routeKey in routeKeys {
            let success = registerRoute(routeKey, using: chain)
            if success {
                successCount += 1
            } else {
                failureCount += 1
                logger.warning("Failed to register route: \(routeKey.key)")
            }
        }
        
        logger.info("Route registration completed: \(successCount) successful, \(failureCount) failed")
    }
    
    public func registerRoute(_ routeKey: any RouteKey, using chain: RouteRegistrationHandler) -> Bool {
        let result = chain.handleRegistration(for: routeKey, in: self)
        logger.info("Route registration result for \(routeKey.key): \(result)")
        return result
    }
    
    /// Register routes with detailed results
    /// - Parameters:
    ///   - routeKeys: Array of route keys to register
    ///   - chain: The registration handler chain
    /// - Returns: Dictionary mapping route keys to their registration success status
    public func registerRoutesWithResults(_ routeKeys: [any RouteKey], using chain: RouteRegistrationHandler) -> [String: Bool] {
        var results: [String: Bool] = [:]
        
        for routeKey in routeKeys {
            let success = registerRoute(routeKey, using: chain)
            results[routeKey.key] = success
        }
        
        return results
    }
    
    public func navigate(to key: String, parameters: RouteParameters? = nil, in tab: String? = nil) {
        guard let factory = factories[key] else {
            logger.warning("Route not found: \(key), falling back to home")
            // Fallback to home - would need to implement
            return
        }
        
        // Check for circular navigation
        if navigationHistory.contains(key) {
            logger.warning("Circular navigation detected for route: \(key)")
            logger.error("Circular navigation error for route: \(key)")
            return
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
        
        // Use the factory to present the component
        // The factory handles both building and presenting
        factory.present(Any.self as Any, with: context)
        activeStrategy.navigate(to: destination, with: "Built component for \(key)", in: tab)
        updateNavigationState(destination: destination)
        saveState()
        logger.info("Successfully navigated to: \(key)")
    }
    
    public func navigate(to key: String, parameters: RouteParameters? = nil, in tab: String? = nil, type: NavigationType) {
        guard let factory = factories[key] else {
            logger.warning("Route not found: \(key), falling back to home")
            // Fallback to home - would need to implement
            return
        }
        
        let context = RouteContext(
            key: key,
            parameters: parameters ?? RouteParameters(),
            navigationType: type,
            tabId: tab
        )
        
        let destination = NavigationDestination(
            key: key,
            parameters: context.parameters,
            navigationType: type,
            tabId: tab
        )
        
        // Use the factory to present the component
        // The factory handles both building and presenting
        factory.present(Any.self as Any, with: context)
        activeStrategy.navigate(to: destination, with: "Built component for \(key)", in: tab)
        updateNavigationState(destination: destination)
        saveState()
        logger.info("Successfully navigated to: \(key) with type: \(type)")
    }
    
    public func navigate(to routeKey: any RouteKey, parameters: RouteParameters? = nil, in tab: String? = nil) {
        navigate(to: routeKey.key, parameters: parameters, in: tab, type: routeKey.presentationType)
    }
    
    public func navigateBack() {
        
        activeStrategy.navigateBack()
        updateNavigationStateAfterBack()
        saveState()
        logger.info("Successfully navigated back")
    }
    
    public func navigateToRoot(in tab: String? = nil) {
        
        activeStrategy.navigateToRoot(in: tab)
        resetNavigationState(for: tab)
        saveState()
        logger.info("Successfully navigated to root in tab: \(tab ?? "all")")
    }
    
    public func setTab(_ tabId: String) {
        
        activeStrategy.setTab(tabId)
        currentState.currentTab = tabId
        saveState()
        logger.info("Successfully switched to tab: \(tabId)")
    }
    
    public func registerTab(_ tab: TabConfiguration) {
        tabConfigurations[tab.id] = tab
        activeStrategy.registerTab(tab)
        logger.info("Registered tab: \(tab.id)")
    }
    
    // MARK: - Modal Dismissal Methods
    
    /// Dismiss the topmost modal
    public func dismissModal() {
        Task {
            await dismissModalInternal()
        }
    }
    
    /// Dismiss all modals
    public func dismissAllModals() {
        Task {
            await dismissAllModalsInternal()
        }
    }
    
    /// Dismiss modal with specific key
    public func dismissModal(with key: String) {
        Task {
            await dismissModalInternal(with: key)
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
        navigate(to: "home", in: defaultTab)
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
    
    private func handleNavigationError(_ error: Error, for key: String) {
        // Implement fallback logic
        logger.warning("Handling navigation error for key: \(key), error: \(error)")
        // Fallback to home - would need to implement
    }
    
    // MARK: - Helper Methods
    
    /// Get the active strategy type
    private var activeStrategyType: String {
        return activeStrategy.strategyType.rawValue.capitalized
    }
    
    /// Check if a factory is compatible with the active strategy
    private func isFactoryCompatibleWithActiveStrategy<T: RouteFactory>(_ factory: T) -> Bool {
        // Check if the factory is a SwiftUI factory and we're using SwiftUI strategy
        if factory is any SwiftUIViewFactory {
            return activeStrategy is SwiftUINavigationStrategy
        }
        
        // Check if the factory is a UIKit factory and we're using UIKit strategy
        if factory is any UIKitViewControllerFactory {
            return activeStrategy is UIKitNavigationStrategy
        }
        
        // If it's neither, it's not compatible
        return false
    }
    
    // MARK: - Modal Dismissal Internal Methods
    
    private func dismissModalInternal() async {
        
        if !currentState.modalStack.isEmpty {
            currentState.modalStack.removeLast()
            activeStrategy.dismissModal()
            saveState()
            logger.info("Successfully dismissed topmost modal")
        } else {
            logger.warning("No modals to dismiss")
        }
    }
    
    private func dismissAllModalsInternal() async {
        
        if !currentState.modalStack.isEmpty {
            currentState.modalStack.removeAll()
            activeStrategy.dismissAllModals()
            saveState()
            logger.info("Successfully dismissed all modals")
        } else {
            logger.warning("No modals to dismiss")
        }
    }
    
    private func dismissModalInternal(with key: String) async {
        if let index = currentState.modalStack.firstIndex(where: { $0.key == key }) {
            currentState.modalStack.remove(at: index)
            activeStrategy.dismissModal(with: key)
            saveState()
            logger.info("Successfully dismissed modal with key: \(key)")
        } else {
            logger.warning("No modal found with key: \(key)")
        }
    }
}
