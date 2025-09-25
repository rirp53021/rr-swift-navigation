// MARK: - Main Navigation Manager

import Foundation
import SwiftUI
import Combine
import RRFoundation

@MainActor
public class NavigationManager: NavigationManagerProtocol {
    
    // MARK: - Properties
    
    public let activeStrategy: NavigationStrategy
    private let persistence: NavigationStatePersistence?
    private var factories: [String: AnyViewFactory] = [:]
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
    
    /// Automatically wrap a ViewComponent based on the active strategy
    private func wrapComponentForStrategy(_ component: ViewComponent) -> Any {
        let strategyType = activeStrategy.strategyType
        
        switch (strategyType, component) {
        case (.swiftUI, .swiftUI(let view)):
            // SwiftUI strategy with SwiftUI view - use directly
            return view
            
        case (.swiftUI, .uiKit(let viewController)):
            // SwiftUI strategy with UIKit view controller - wrap in UIHostingController
            return UIHostingController(rootView: UIKitViewControllerWrapper(viewController))
            
        case (.uikit, .uiKit(let viewController)):
            // UIKit strategy with UIKit view controller - use directly
            return viewController
            
        case (.uikit, .swiftUI(let view)):
            // UIKit strategy with SwiftUI view - wrap in UIHostingController
            return UIHostingController(rootView: view)
        }
    }
    
    /// Register a view factory
    public func register<T: ViewFactory>(_ factory: T, for routeID: RouteID) {
        guard !routeID.key.isEmpty else {
            logger.error("Invalid route key: empty string")
            return
        }
        
        factories[routeID.key] = AnyViewFactory(factory)
        logger.info("Registered view factory for key: \(routeID.key)")
    }
    
    public func registerRoutes(_ routeIDs: [RouteID], using chain: RouteRegistrationHandler) {
        var successCount = 0
        var failureCount = 0
        
        for routeID in routeIDs {
            let success = registerRoute(routeID, using: chain)
            if success {
                successCount += 1
            } else {
                failureCount += 1
                logger.warning("Failed to register route: \(routeID.key)")
            }
        }
        
        logger.info("Route registration completed: \(successCount) successful, \(failureCount) failed")
    }
    
    public func registerRoute(_ routeID: RouteID, using chain: RouteRegistrationHandler) -> Bool {
        let result = chain.handleRegistration(for: routeID, in: self)
        logger.info("Route registration result for \(routeID.key): \(result)")
        return result
    }
    
    /// Register routes with detailed results
    /// - Parameters:
    ///   - routeKeys: Array of route keys to register
    ///   - chain: The registration handler chain
    /// - Returns: Dictionary mapping route keys to their registration success status
    public func registerRoutesWithResults(_ routeIDs: [RouteID], using chain: RouteRegistrationHandler) -> [String: Bool] {
        var results: [String: Bool] = [:]
        
        for routeID in routeIDs {
            let success = registerRoute(routeID, using: chain)
            results[routeID.key] = success
        }
        
        return results
    }
    
    public func navigate(to routeID: RouteID, parameters: RouteParameters? = nil, in tab: String? = nil, type: NavigationType? = nil) {
        guard let factory = factories[routeID.key] else {
            logger.warning("Route not found: \(routeID.key), falling back to home")
            // Fallback to home - would need to implement
            return
        }
        
        // Check for circular navigation
        if navigationHistory.contains(routeID.key) {
            logger.warning("Circular navigation detected for route: \(routeID.key)")
            logger.error("Circular navigation error for route: \(routeID.key)")
            return
        }
        
        // Use provided type or fall back to RouteID's default presentation type
        let navigationType = type ?? routeID.presentationType
        
        let context = RouteContext(
            key: routeID.key,
            parameters: parameters ?? RouteParameters(),
            navigationType: navigationType,
            tabId: tab
        )
        
        let destination = NavigationDestination(
            key: routeID.key,
            parameters: context.parameters,
            navigationType: navigationType,
            tabId: tab
        )
        
        // Create the view component using the factory
        let component = factory.createView(with: context)
        logger.info("Created view component for: \(routeID.key)")
        
        // Automatically wrap the component based on the active strategy
        let wrappedComponent = wrapComponentForStrategy(component)
        
        // Present the wrapped component using the active strategy
        activeStrategy.navigate(to: destination, with: wrappedComponent, in: tab)
        updateNavigationState(destination: destination)
        saveState()
        
        if let type = type {
            logger.info("Successfully navigated to: \(routeID.key) with type: \(type)")
        } else {
            logger.info("Successfully navigated to: \(routeID.key)")
        }
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
        let homeRouteID = RouteID("home", type: .push)
        navigate(to: homeRouteID, in: defaultTab)
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
