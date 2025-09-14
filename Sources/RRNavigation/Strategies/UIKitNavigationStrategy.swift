// MARK: - UIKit Navigation Strategy

import Foundation
#if canImport(UIKit)
import UIKit
#endif

@MainActor
public class UIKitNavigationStrategy: NavigationStrategyProtocol {
    
    public let navigationType: NavigationType = .uikit
    public let supportedNavigationTypes: Set<NavigationType> = [.push, .sheet, .fullScreen, .modal, .tab, .replace]
    
    #if canImport(UIKit)
    private var navigationControllers: [String: UINavigationController] = [:]
    private var tabBarController: UITabBarController?
    private var presentedViewControllers: [String: UIViewController] = [:]
    #else
    private var navigationControllers: [String: Any] = [:]
    private var tabBarController: Any?
    private var presentedViewControllers: [String: Any] = [:]
    #endif
    
    public init() {}
    
    public func navigate(to destination: NavigationDestination, in tab: String?) async throws {
        switch destination.navigationType {
        case .push:
            try await navigatePush(destination, in: tab)
        case .sheet:
            try await navigateSheet(destination, in: tab)
        case .fullScreen:
            try await navigateFullScreen(destination, in: tab)
        case .modal:
            try await navigateModal(destination, in: tab)
        case .replace:
            try await navigateReplace(destination, in: tab)
        case .tab:
            try await navigateTab(destination, in: tab)
        case .swiftUI, .uikit:
            throw NavigationError.strategyNotSupported("Strategy type not supported in navigation")
        }
    }
    
    public func navigateBack() async throws {
        #if canImport(UIKit)
        if let currentNavController = getCurrentNavigationController() {
            currentNavController.popViewController(animated: true)
            Logger.shared.info("UIKit navigate back executed")
        } else {
            throw NavigationError.navigationFailed("No navigation controller available")
        }
        #else
        Logger.shared.info("UIKit navigate back requested (not available on this platform)")
        #endif
    }
    
    public func navigateToRoot(in tab: String?) async throws {
        #if canImport(UIKit)
        if let tabId = tab {
            if let navController = navigationControllers[tabId] {
                navController.popToRootViewController(animated: true)
            }
        } else {
            // Pop to root in all navigation controllers
            for navController in navigationControllers.values {
                navController.popToRootViewController(animated: true)
            }
        }
        #endif
        Logger.shared.info("UIKit navigation reset to root for tab: \(tab ?? "all")")
    }
    
    public func setTab(_ tabId: String) async throws {
        #if canImport(UIKit)
        guard let tabBarController = tabBarController else {
            throw NavigationError.tabNotFound("Tab bar controller not available")
        }
        
        if let tabIndex = tabBarController.viewControllers?.firstIndex(where: { $0.tabBarItem.tag == Int(tabId) }) {
            tabBarController.selectedIndex = tabIndex
            Logger.shared.info("UIKit tab switched to: \(tabId)")
        } else {
            throw NavigationError.tabNotFound(tabId)
        }
        #else
        Logger.shared.info("UIKit tab switch requested: \(tabId) (not available on this platform)")
        #endif
    }
    
    public func registerTab(_ tab: TabConfiguration) throws {
        // This would be called during tab bar setup
        Logger.shared.info("Registered UIKit tab: \(tab.id)")
    }
    
    // MARK: - Private Methods
    
    private func navigatePush(_ destination: NavigationDestination, in tab: String?) async throws {
        let tabId = tab ?? "main"
        #if canImport(UIKit)
        guard let navController = navigationControllers[tabId] else {
            throw NavigationError.tabNotFound(tabId)
        }
        #endif
        
        // In a real implementation, this would create and push the view controller
        Logger.shared.info("UIKit push navigation to: \(destination.key) in tab: \(tabId)")
    }
    
    private func navigateSheet(_ destination: NavigationDestination, in tab: String?) async throws {
        // Present as sheet
        Logger.shared.info("UIKit sheet presentation for: \(destination.key)")
    }
    
    private func navigateFullScreen(_ destination: NavigationDestination, in tab: String?) async throws {
        // Present full screen
        Logger.shared.info("UIKit fullscreen presentation for: \(destination.key)")
    }
    
    private func navigateModal(_ destination: NavigationDestination, in tab: String?) async throws {
        // Present modally
        Logger.shared.info("UIKit modal presentation for: \(destination.key)")
    }
    
    private func navigateReplace(_ destination: NavigationDestination, in tab: String?) async throws {
        let tabId = tab ?? "main"
        #if canImport(UIKit)
        guard let navController = navigationControllers[tabId] else {
            throw NavigationError.tabNotFound(tabId)
        }
        #endif
        
        // Replace current view controller
        Logger.shared.info("UIKit replace navigation for: \(destination.key) in tab: \(tabId)")
    }
    
    private func navigateTab(_ destination: NavigationDestination, in tab: String?) async throws {
        guard let tabId = destination.tabId ?? tab else {
            throw NavigationError.invalidParameters
        }
        
        try await setTab(tabId)
    }
    
    #if canImport(UIKit)
    private func getCurrentNavigationController() -> UINavigationController? {
        if let tabBarController = tabBarController,
           let selectedNavController = tabBarController.selectedViewController as? UINavigationController {
            return selectedNavController
        }
        return navigationControllers.values.first
    }
    #endif
}
