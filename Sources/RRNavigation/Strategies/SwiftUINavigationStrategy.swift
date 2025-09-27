// MARK: - SwiftUI Navigation Strategy

import Foundation
import SwiftUI
import RRFoundation

/// Protocol for coordinating SwiftUI navigation presentation
@MainActor
public protocol SwiftUINavigationCoordinator: AnyObject {
    func presentSheet(_ view: AnyView)
    func presentFullScreen(_ view: AnyView)
    func presentModal(_ view: AnyView)
    func pushView(_ view: AnyView, routeKey: String, in tab: Int)
    func dismissSheet()
    func dismissFullScreen()
    func dismissModal()
    func dismissAll()
}

@MainActor
public class SwiftUINavigationStrategy: NavigationStrategy {
    
    public let strategyType: NavigationStrategyType = .swiftUI
    public let supportedNavigationTypes: Set<NavigationType> = [.push, .sheet, .fullScreen, .modal]
    
    private var navigationPaths: [String: Any] = [:]
    private var sheetPresentations: [String: Bool] = [:]
    private var fullScreenPresentations: [String: Bool] = [:]
    
    // Navigation coordinator for actual view presentation
    private weak var navigationCoordinator: SwiftUINavigationCoordinator?
    
    public init() {}
    
    public func setNavigationCoordinator(_ coordinator: SwiftUINavigationCoordinator) {
        self.navigationCoordinator = coordinator
    }
    
    public func navigate(to destination: NavigationDestination, with component: Any, in tab: String?) {
        switch destination.navigationType {
        case .push:
            navigatePush(destination, with: component, in: tab)
        case .sheet:
            navigateSheet(destination, with: component, in: tab)
        case .fullScreen:
            navigateFullScreen(destination, with: component, in: tab)
        case .modal:
            navigateModal(destination, with: component, in: tab)
        case .replace:
            navigateReplace(destination, with: component, in: tab)
        case .tab:
            Logger.shared.error("Tab navigation not supported in SwiftUI strategy")
        }
    }
    
    public func navigateBack() {
        // Check if there are any modal presentations to dismiss first
        if !sheetPresentations.isEmpty || !fullScreenPresentations.isEmpty {
            // Dismiss the topmost modal presentation
            let activeSheets = sheetPresentations.filter { $0.value == true }
            let activeFullScreens = fullScreenPresentations.filter { $0.value == true }
            
            if let lastSheet = activeSheets.keys.first {
                Logger.shared.info("Dismissing sheet: \(lastSheet)")
                navigationCoordinator?.dismissSheet()
                sheetPresentations[lastSheet] = false
            } else if let lastFullScreen = activeFullScreens.keys.first {
                Logger.shared.info("Dismissing full screen: \(lastFullScreen)")
                navigationCoordinator?.dismissFullScreen()
                fullScreenPresentations[lastFullScreen] = false
            } else {
                Logger.shared.info("Dismissing any modal presentation")
                navigationCoordinator?.dismissModal()
            }
        } else {
            // No modals to dismiss, handle push navigation
            // In SwiftUI, this would typically be handled by the NavigationStack
            // The actual back navigation is managed by SwiftUI's built-in navigation
            Logger.shared.info("SwiftUI push navigation back - handled by NavigationStack")
        }
    }
    
    public func navigateToRoot(in tab: String?) {
        if let tabId = tab {
            navigationPaths[tabId] = createNavigationPath()
        } else {
            navigationPaths.removeAll()
        }
        Logger.shared.info("SwiftUI navigation reset to root for tab: \(tab ?? "all")")
    }
    
    public func setTab(_ tabId: String) {
        // Tab switching would be handled by the parent view
        Logger.shared.info("SwiftUI tab switch requested: \(tabId)")
    }
    
    public func registerTab(_ tab: TabConfiguration) {
        navigationPaths[tab.id] = createNavigationPath()
        Logger.shared.info("Registered SwiftUI tab: \(tab.id)")
    }
    
    // MARK: - Modal Dismissal Methods
    
    public func dismissModal() {
        // In SwiftUI, modal dismissal is typically handled by the view hierarchy
        // This would be implemented using @Environment(\.dismiss) or similar
        Logger.shared.info("SwiftUI modal dismissal requested")
    }
    
    public func dismissAllModals() {
        // Dismiss all modals in the SwiftUI hierarchy
        Logger.shared.info("SwiftUI dismiss all modals requested")
    }
    
    public func dismissModal(with key: String) {
        // Dismiss specific modal by key
        Logger.shared.info("SwiftUI dismiss modal with key requested: \(key)")
    }
    
    // MARK: - Private Methods
    
    private func createNavigationPath() -> Any {
        #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS) || os(visionOS)
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, visionOS 1.0, *) {
            return NavigationPath()
        }
        #endif
        return "NavigationPath"
    }
    
    private func navigatePush(_ destination: NavigationDestination, with component: Any, in tab: String?) {
        let tabId = tab ?? "main"
        if navigationPaths[tabId] == nil {
            navigationPaths[tabId] = createNavigationPath()
        }
        
        print("🎯 SwiftUINavigationStrategy: navigatePush called for \(destination.key)")
        print("🎯 SwiftUINavigationStrategy: coordinator = \(navigationCoordinator != nil ? "available" : "nil")")
        print("🎯 SwiftUINavigationStrategy: component type = \(type(of: component))")
        
        // Present the view through the navigation coordinator
        if let coordinator = navigationCoordinator,
           let view = component as? AnyView {
            print("🎯 SwiftUINavigationStrategy: calling coordinator.pushView")
            let tabIndex = Int(tabId) ?? 0
            coordinator.pushView(view, routeKey: destination.key, in: tabIndex)
        } else {
            print("🎯 SwiftUINavigationStrategy: coordinator or view is nil")
        }
        
        Logger.shared.info("SwiftUI push navigation to: \(destination.key) with component: \(type(of: component)) in tab: \(tabId)")
    }
    
    private func navigateSheet(_ destination: NavigationDestination, with component: Any, in tab: String?) {
        let tabId = tab ?? "main"
        sheetPresentations[tabId] = true
        
        print("🎯 SwiftUINavigationStrategy: navigateSheet called for \(destination.key)")
        print("🎯 SwiftUINavigationStrategy: coordinator = \(navigationCoordinator != nil ? "available" : "nil")")
        print("🎯 SwiftUINavigationStrategy: component type = \(type(of: component))")
        
        // Present the view through the navigation coordinator
        if let coordinator = navigationCoordinator,
           let view = component as? AnyView {
            print("🎯 SwiftUINavigationStrategy: calling coordinator.presentSheet")
            coordinator.presentSheet(view)
        } else {
            print("🎯 SwiftUINavigationStrategy: coordinator or view is nil")
        }
        
        Logger.shared.info("SwiftUI sheet presentation for: \(destination.key) with component: \(type(of: component)) in tab: \(tabId)")
    }
    
    private func navigateFullScreen(_ destination: NavigationDestination, with component: Any, in tab: String?) {
        let tabId = tab ?? "main"
        fullScreenPresentations[tabId] = true
        
        // Present the view through the navigation coordinator
        if let coordinator = navigationCoordinator,
           let view = component as? AnyView {
            coordinator.presentFullScreen(view)
        }
        
        Logger.shared.info("SwiftUI fullscreen presentation for: \(destination.key) with component: \(type(of: component)) in tab: \(tabId)")
    }
    
    private func navigateModal(_ destination: NavigationDestination, with component: Any, in tab: String?) {
        // Present the view through the navigation coordinator
        if let coordinator = navigationCoordinator,
           let view = component as? AnyView {
            coordinator.presentModal(view)
        }
        
        Logger.shared.info("SwiftUI modal presentation for: \(destination.key) with component: \(type(of: component))")
    }
    
    private func navigateReplace(_ destination: NavigationDestination, with component: Any, in tab: String?) {
        let tabId = tab ?? "main"
        if navigationPaths[tabId] == nil {
            navigationPaths[tabId] = createNavigationPath()
        }
        
        // Replace current navigation stack with the built view
        // The component is the built SwiftUI view from the factory
        Logger.shared.info("SwiftUI replace navigation for: \(destination.key) with component: \(type(of: component)) in tab: \(tabId)")
    }
}
