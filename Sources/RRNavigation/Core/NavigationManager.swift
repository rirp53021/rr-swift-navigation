// MARK: - Main Navigation Manager

import Foundation
import SwiftUI
import Combine
import RRFoundation

@MainActor
public class NavigationManager: ObservableObject {
    // MARK: - Published Properties
    internal var appModules: Set<AppModule> = []
    @Published public var currentAppModule: AppModuleID?
    @Published internal var currentNavigationPath: NavigationPath = NavigationPath()
    internal private(set) var registeredTabs: [RRTab] = []
    internal var tabNavigationPaths: [RRTabID: NavigationPath] = [:]
    @Published internal var isSheetShown: Bool = false
    @Published internal var isFullScreenShown: Bool = false
    @Published internal var currentTab: RRTabID? {
        didSet {
            updateCurrentNavigationPath()
        }
    }
    
    internal var sheetContent: AnyView? {
        didSet {
            isSheetShown = sheetContent != nil
        }
    }
    internal var fullScreenContent: AnyView? {
        didSet {
            isFullScreenShown = fullScreenContent != nil
        }
    }
    internal var handlers: [NavigationHandler] = []
    
    // MARK: - Private Properties
    private let logger = Logger.shared
    
    public init(appModules: Set<AppModule> = [], initialModel: AppModuleID? = nil) {
        self.currentAppModule = initialModel
        self.appModules = appModules
    }
    
    // MARK: - View Registration
    
    public func registerAppModule(_ module: AppModule) {
        appModules.insert(module)
    }
    
    public func setAppModule(_ module: AppModuleID) {
        currentAppModule = module
        
        // Handle app module change
        if let appModule = appModules.first(where: { $0.id == module }) {
            handleAppModuleChange(appModule)
        }
    }
    
    private func handleAppModuleChange(_ appModule: AppModule) {
        // App modules don't automatically clear tabs
        // Tabs should be managed independently through registerTab/unregisterTab methods
        // This method is reserved for future app module-specific logic if needed
    }
    
    /// Register a navigation handler
    /// - Parameter handler: The handler to register
    public func registerHandler(_ handler: NavigationHandler) {
        handlers.append(handler)
    }
    
    // MARK: - Tab Management
    
    /// Register a tab and create its NavigationPath
    /// - Parameter factory: The tab factory
    public func registerTab<Factory: RRTabFactory>(_ factory: Factory) {
        let tab = factory.create()
        registeredTabs.append(tab)
        // Create NavigationPath for the tab
        tabNavigationPaths[tab.id] = NavigationPath()
        currentTab = registeredTabs.first?.id
    }
    
    /// Set the current active tab
    /// - Parameter tab: The tab to set as current
    public func setCurrentTab(_ tab: RRTabID) {
        if tab == currentTab { return }
        currentTab = tab
    }
    
    /// Handle tab selection with reset-to-root behavior when same tab is tapped
    /// - Parameter tabID: The tab to select
    public func selectTab(_ tabID: RRTabID) {
        if tabID == currentTab {
            // Reset navigation for this tab to its root view
            tabNavigationPaths[tabID] = NavigationPath()
        } else {
            // Switch to the new tab
            setCurrentTab(tabID)
        }
    }
    
    /// Update currentNavigationPath based on currentTab
    private func updateCurrentNavigationPath() {
        if let tabID = currentTab {
            currentNavigationPath = tabNavigationPaths[tabID] ?? NavigationPath()
        } else {
            currentNavigationPath = NavigationPath()
        }
    }
    
    // MARK: - Navigation
    
    /// Navigate to a route using the registered handlers
    /// - Parameters:
    ///   - routeID: The route to navigate to
    ///   - forceReset: If true, closes all modals and resets navigation to show only the target view
    public func navigate(to routeID: RouteID, forceReset: Bool = true) {
        guard let handler = handlers.first(where: { $0.canNavigate(to: routeID) }),
              let step = handler.getNavigation(to: routeID)
        else { return }
        
        handleStep(routeID: routeID, step: step, forceReset: forceReset)
    }
    
    /// Reset all navigation state to show only the specified route
    /// - Parameter routeID: The route to show as the root view
    public func resetToRoot(tabID: RRTabID) {
        resetNavigationState()
        tabNavigationPaths[tabID] = NavigationPath()
    }
    
    /// Reset all navigation state (close modals, clear paths)
    private func resetNavigationState() {
        sheetContent = nil
        fullScreenContent = nil
    }
    
    /// Clear all tabs and their navigation paths
    public func clearAllTabs() {
        registeredTabs.removeAll()
        tabNavigationPaths.removeAll()
        currentTab = nil
    }
    
    @ViewBuilder
    func getRegisteredView(for routeID: RouteID) -> some View {
        if let handler = handlers.first(where: { $0.canNavigate(to: routeID) }),
           let step = handler.getNavigation(to: routeID) {
            AnyView(step.factory.createView(params: step.params))
        }
    }
    
    /// Get the root view for a tab (resolves RouteID to view)
    @ViewBuilder
    func getRootView(for tab: RRTab) -> some View {
        // Resolve RouteID to view
        getRegisteredView(for: tab.rootRouteID)
    }
    
    private func handleStep(routeID: RouteID, step: NavigationStep, forceReset: Bool) {
        switch step.type {
        case .push:
            push(routeID, step, forceReset)
        case .sheet:
            resetNavigationState()
            sheetContent = AnyView(step.factory.createView(params: step.params))
        case .fullScreen:
            resetNavigationState()
            fullScreenContent = AnyView(step.factory.createView(params: step.params))
        }
    }
    
    private func push(_ routeID: RouteID, _ step: NavigationStep, _ forceReset: Bool) {
        if let tabID = step.tab ?? currentTab {
            guard let targetTab = registeredTabs.first(where: { $0.id == tabID }) else {
                setCurrentTab(tabID)
                return
            }
            
            let isRootView = targetTab.rootRouteID == routeID
            
            if isRootView && forceReset {
                // If tab's root view is the same as routeID and forceReset is true, append the path
                tabNavigationPaths[tabID]?.append(routeID)
            } else if isRootView && !forceReset {
                // If tab's root view is the same as routeID and forceReset is false, do not append the path
                // (stay at root, don't navigate)
            } else {
                // If tab's root view is different from routeID (regardless of forceReset), append the path
                tabNavigationPaths[tabID]?.append(routeID)
            }
            
            setCurrentTab(tabID)
        }
    }
}
