// MARK: - Main Navigation Manager

import Foundation
import SwiftUI
import Combine
import RRFoundation

@MainActor
public class NavigationManager: ObservableObject {
    // MARK: - Published Properties
    @Published internal private(set) var tabs: [RRTab] = []
    @Published internal var tabNavigationPaths: [RRTabID: NavigationPath] = [:]
    @Published internal private(set) var currentTab: RRTabID?
    @Published internal var isSheetShown: Bool = false
    @Published internal var isFullScreenShown: Bool = false
    
    internal var sheetContent: AnyView?
    internal var fullScreenContent: AnyView?
    internal var handlers: [NavigationHandler] = []
    
    // MARK: - Private Properties
    private let logger = Logger.shared
    
    public init() { }
    
    // MARK: - View Registration
    
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
        tabs.append(tab)
        // Create NavigationPath for the tab
        tabNavigationPaths[tab.id] = NavigationPath()
        currentTab = tabs.first?.id
    }
    
    /// Set the current active tab
    /// - Parameter tab: The tab to set as current
    public func setCurrentTab(_ tab: RRTabID) {
        if tab == currentTab { return }
        currentTab = tab
    }
    
    // MARK: - Navigation
    
    /// Navigate to a route using the registered handlers
    /// - Parameters:
    ///   - routeID: The route to navigate to
    ///   - tab: Optional RRTab instance (uses current tab if nil)
    public func navigate(to routeID: RouteID) {
        guard let handler = handlers.first(where: { $0.canNavigate(to: routeID) }),
              let step = handler.getNavigation(to: routeID)
        else { return }
        
        handleStep(routeID: routeID, step: step)
    }
    
    @ViewBuilder
    func getRegisteredView(for routeID: RouteID) -> some View {
        if let handler = handlers.first(where: { $0.canNavigate(to: routeID) }),
           let step = handler.getNavigation(to: routeID) {
            AnyView(step.factory.createView(params: step.params))
        }
    }
    
    private func handleStep(routeID: RouteID, step: NavigationStep) {
        switch step.type {
        case .push:
            push(routeID, step)
        case .sheet:
            sheetContent = AnyView(step.factory.createView(params: step.params))
            isSheetShown = true
        case .fullScreen:
            fullScreenContent = AnyView(step.factory.createView(params: step.params))
            isFullScreenShown = true
        case .tab, .modal, .replace:
            print("not implemented")
        }
    }
    
    private func push(_ routeID: RouteID, _ step: NavigationStep) {
        if let tab = step.tab ?? currentTab {
            tabNavigationPaths[tab]?.append(routeID)
            setCurrentTab(tab)
        }
    }
    
    private func present(_ routeID: RouteID, step: NavigationStep) {
        
    }
}
