// MARK: - Type Erasure for Factories

import Foundation
import SwiftUI
import UIKit

/// Type-erased view factory that works with ViewComponent enum
public class AnyViewFactory: ViewFactory {
    private let _createView: (RouteContext) -> ViewComponent
    
    public init<T: ViewFactory>(_ factory: T) {
        self._createView = { context in
            factory.createView(with: context)
        }
    }
    
    public func createView(with context: RouteContext) -> ViewComponent {
        return _createView(context)
    }
}

/// Wrapper for SwiftUI views to be used in UIKit navigation
public struct SwiftUIViewWrapper: UIViewControllerRepresentable {
    let view: AnyView
    
    public init(_ view: AnyView) {
        self.view = view
    }
    
    public func makeUIViewController(context: Context) -> UIHostingController<AnyView> {
        return UIHostingController(rootView: view)
    }
    
    public func updateUIViewController(_ uiViewController: UIHostingController<AnyView>, context: Context) {
        uiViewController.rootView = view
    }
}

/// Wrapper for UIKit view controllers to be used in SwiftUI navigation
public struct UIKitViewControllerWrapper: View {
    let viewController: UIViewController
    
    public init(_ viewController: UIViewController) {
        self.viewController = viewController
    }
    
    public var body: some View {
        UIViewControllerRepresentableWrapper(viewController)
    }
}

/// Internal wrapper for UIViewControllerRepresentable
private struct UIViewControllerRepresentableWrapper: UIViewControllerRepresentable {
    let viewController: UIViewController
    
    init(_ viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No updates needed
    }
}