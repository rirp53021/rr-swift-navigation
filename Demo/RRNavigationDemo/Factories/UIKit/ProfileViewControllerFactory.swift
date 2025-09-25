// MARK: - Profile View Controller Factory

import Foundation
import RRNavigation

#if canImport(UIKit)
import UIKit

public struct ProfileViewControllerFactory: UIKitViewControllerFactory {
    public typealias Output = UIViewController
    
    public init() {}
    
    public func present(_ component: UIViewController, with context: RouteContext) {
        print("📱 ProfileViewControllerFactory: Creating ProfileViewController")
    }
    
    public func presentViewController(_ viewController: UIViewController, with context: RouteContext) {
        present(viewController, with: context)
    }
    
    public func createViewController(with context: RouteContext) -> UIViewController {
        let userId = context.parameters.data["userId"] ?? "unknown"
        let name = context.parameters.data["name"] ?? "Unknown User"
        
        // Note: This factory needs access to NavigationManager, but we can't pass it through RouteContext
        // In a real implementation, you'd need to inject the NavigationManager differently
        return ProfileViewController(userId: userId, name: name, navigationManager: NavigationManager.shared)
    }
}

// Note: ProfileViewController is defined in Demo/RRNavigationDemo/UIKit/ProfileViewController.swift

#endif
