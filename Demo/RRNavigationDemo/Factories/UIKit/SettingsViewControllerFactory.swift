// MARK: - Settings View Controller Factory

import Foundation
import RRNavigation

#if canImport(UIKit)
import UIKit

public struct SettingsViewControllerFactory: UIKitViewControllerFactory {
    public typealias Output = UIViewController
    
    public init() {}
    
    public func present(_ component: UIViewController, with context: RouteContext) {
        print("📱 SettingsViewControllerFactory: Creating SettingsViewController")
    }
    
    public func presentViewController(_ viewController: UIViewController, with context: RouteContext) {
        present(viewController, with: context)
    }
    
    public func createViewController(with context: RouteContext) -> UIViewController {
        let userId = context.parameters.data["userId"] ?? "unknown"
        
        // Note: This factory needs access to NavigationManager, but we can't pass it through RouteContext
        // In a real implementation, you'd need to inject the NavigationManager differently
        return SettingsViewController(userId: userId, navigationManager: NavigationManager.shared)
    }
}

// Note: SettingsViewController is defined in Demo/RRNavigationDemo/UIKit/SettingsViewController.swift

#endif
