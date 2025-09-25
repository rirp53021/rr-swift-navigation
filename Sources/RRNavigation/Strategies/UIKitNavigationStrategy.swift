// MARK: - UIKit Navigation Strategy

import Foundation
import RRFoundation
#if canImport(UIKit)
import UIKit
#endif

@MainActor
public class UIKitNavigationStrategy: NavigationStrategy {
    public let strategyType: NavigationStrategyType = .uikit
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
            navigateTab(destination, with: component, in: tab)
        }
    }
    
    public func navigateBack() {
        #if canImport(UIKit)
        // Check if there are any presented view controllers to dismiss first
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController,
           let presentedVC = rootViewController.presentedViewController {
            
            // Dismiss the presented view controller (sheet, fullscreen, modal)
            Logger.shared.info("Dismissing presented view controller: \(type(of: presentedVC))")
            presentedVC.dismiss(animated: true) {
                Logger.shared.info("Presented view controller dismissed successfully")
            }
        } else if let currentNavController = getCurrentNavigationController() {
            // Check if we can pop a view controller
            if currentNavController.viewControllers.count > 1 {
                Logger.shared.info("Popping view controller from navigation stack")
                currentNavController.popViewController(animated: true)
            } else {
                Logger.shared.warning("Cannot pop - only one view controller in navigation stack")
            }
        } else {
            Logger.shared.error("No navigation controller available for back navigation")
        }
        #else
        Logger.shared.info("UIKit navigate back requested (not available on this platform)")
        #endif
    }
    
    public func navigateToRoot(in tab: String?)  {
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
    
    public func setTab(_ tabId: String)  {
        #if canImport(UIKit)
        guard let tabBarController = tabBarController else {
            Logger.shared.error("Tab bar controller not available")
            return
        }
        
        if let tabIndex = tabBarController.viewControllers?.firstIndex(where: { $0.tabBarItem.tag == Int(tabId) }) {
            tabBarController.selectedIndex = tabIndex
            Logger.shared.info("UIKit tab switched to: \(tabId)")
        } else {
            Logger.shared.error("Tab not found: \(tabId)")
        }
        #else
        Logger.shared.info("UIKit tab switch requested: \(tabId) (not available on this platform)")
        #endif
    }
    
    public func registerTab(_ tab: TabConfiguration)  {
        // This would be called during tab bar setup
        Logger.shared.info("Registered UIKit tab: \(tab.id)")
    }
    
    // MARK: - Modal Dismissal Methods
    
    public func dismissModal() {
        #if canImport(UIKit)
        DispatchQueue.main.async {
            if let presentingViewController = Self.getCurrentWindowScene()?.windows.first?.rootViewController?.presentedViewController {
                presentingViewController.dismiss(animated: true)
                Logger.shared.info("UIKit modal dismissed")
            } else {
                Logger.shared.warning("No modal to dismiss")
            }
        }
        #else
        Logger.shared.info("UIKit modal dismissal requested (not available on this platform)")
        #endif
    }
    
    public func dismissAllModals() {
        #if canImport(UIKit)
        DispatchQueue.main.async {
            if let rootViewController = Self.getCurrentWindowScene()?.windows.first?.rootViewController {
                rootViewController.dismiss(animated: true)
                Logger.shared.info("UIKit all modals dismissed")
            } else {
                Logger.shared.warning("No root view controller found")
            }
        }
        #else
        Logger.shared.info("UIKit dismiss all modals requested (not available on this platform)")
        #endif
    }
    
    public func dismissModal(with key: String) {
        #if canImport(UIKit)
        DispatchQueue.main.async {
            if let presentingViewController = Self.getCurrentWindowScene()?.windows.first?.rootViewController?.presentedViewController {
                presentingViewController.dismiss(animated: true)
                Logger.shared.info("UIKit modal with key dismissed: \(key)")
            } else {
                Logger.shared.warning("No modal found with key: \(key)")
            }
        }
        #else
        Logger.shared.info("UIKit dismiss modal with key requested: \(key) (not available on this platform)")
        #endif
    }
    
    // MARK: - Private Methods
    
    private func navigatePush(_ destination: NavigationDestination, with component: Any, in tab: String?)  {
        let tabId = tab ?? "main"
        #if canImport(UIKit)
        guard let navController = navigationControllers[tabId] else {
            Logger.shared.error("Tab not found: \(tabId)")
            return
        }
        
        // In a real implementation, this would cast the component to UIViewController and push it
        // The component is the built UIViewController from the factory
        if let viewController = component as? UIViewController {
            navController.pushViewController(viewController, animated: true)
        }
        #endif
        
        Logger.shared.info("UIKit push navigation to: \(destination.key) with component: \(type(of: component)) in tab: \(tabId)")
    }
    
    private func navigateSheet(_ destination: NavigationDestination, with component: Any, in tab: String?)  {
        #if canImport(UIKit)
        // The component is the built UIViewController from the factory
        if let viewController = component as? UIViewController {
            viewController.modalPresentationStyle = .pageSheet
            // Present as sheet - would need access to presenting view controller
        }
        #endif
        
        Logger.shared.info("UIKit sheet presentation for: \(destination.key) with component: \(type(of: component))")
    }
    
    private func navigateFullScreen(_ destination: NavigationDestination, with component: Any, in tab: String?)  {
        #if canImport(UIKit)
        // The component is the built UIViewController from the factory
        if let viewController = component as? UIViewController {
            viewController.modalPresentationStyle = .fullScreen
            // Present full screen - would need access to presenting view controller
        }
        #endif
        
        Logger.shared.info("UIKit fullscreen presentation for: \(destination.key) with component: \(type(of: component))")
    }
    
    private func navigateModal(_ destination: NavigationDestination, with component: Any, in tab: String?)  {
        #if canImport(UIKit)
        // The component is the built UIViewController from the factory
        if let viewController = component as? UIViewController {
            viewController.modalPresentationStyle = .formSheet
            // Present modally - would need access to presenting view controller
        }
        #endif
        
        Logger.shared.info("UIKit modal presentation for: \(destination.key) with component: \(type(of: component))")
    }
    
    private func navigateReplace(_ destination: NavigationDestination, with component: Any, in tab: String?)  {
        let tabId = tab ?? "main"
        #if canImport(UIKit)
        guard let navController = navigationControllers[tabId] else {
            Logger.shared.error("Tab not found: \(tabId)")
            return
        }
        
        // Replace current view controller with the built one
        // The component is the built UIViewController from the factory
        if let viewController = component as? UIViewController {
            navController.setViewControllers([viewController], animated: true)
        }
        #endif
        
        Logger.shared.info("UIKit replace navigation for: \(destination.key) with component: \(type(of: component)) in tab: \(tabId)")
    }
    
    private func navigateTab(_ destination: NavigationDestination, with component: Any, in tab: String?)  {
        guard let tabId = destination.tabId ?? tab else {
            Logger.shared.error("Invalid parameters")
            return
        }
        
        setTab(tabId)
    }
    
    #if canImport(UIKit)
    private func getCurrentNavigationController() -> UINavigationController? {
        if let tabBarController = tabBarController,
           let selectedNavController = tabBarController.selectedViewController as? UINavigationController {
            return selectedNavController
        }
        return navigationControllers.values.first
    }
    
    /// Get the current window scene (iOS 13+ compatible)
    /// - Returns: The current UIWindowScene or nil if not available
    @available(iOS 13.0, *)
    private static func getCurrentWindowScene() -> UIWindowScene? {
        if let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive }) {
            return windowScene
        }
        
        // Fallback to any connected window scene
        return UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first
    }
    #endif
}
