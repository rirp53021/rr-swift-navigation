// MARK: - Profile View Controller Factory

import UIKit
import RRNavigation

/// Factory that creates ProfileViewController as UIKit component
public struct ProfileViewControllerFactory: ViewFactory {
    public init() {}
    
    public func createView(with context: RouteContext) -> ViewComponent {
        let userId = context.parameters.data["userId"] ?? "unknown"
        let name = context.parameters.data["name"] ?? "Unknown User"
        
        // For demo purposes, create a simple view controller
        let viewController = UIViewController()
        viewController.title = "Profile - \(name)"
        viewController.view.backgroundColor = .systemBackground
        
        let label = UILabel()
        label.text = "User: \(name)\nID: \(userId)"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor)
        ])
        
        return .uiKit(viewController)
    }
}