// MARK: - Type Erasure for Factories

import Foundation
import SwiftUI
import UIKit

/// Type-erased view factory that works with ViewComponent enum
internal class AnyViewFactory: ViewFactory {
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

/// Internal wrapper for SwiftUI views to be used in UIKit navigation
internal struct SwiftUIViewWrapper: UIViewControllerRepresentable {
    let view: AnyView
    
    init(_ view: AnyView) {
        self.view = view
    }
    
    func makeUIViewController(context: Context) -> UIHostingController<AnyView> {
        return UIHostingController(rootView: view)
    }
    
    func updateUIViewController(_ uiViewController: UIHostingController<AnyView>, context: Context) {
        uiViewController.rootView = view
    }
}

/// Internal wrapper for UIKit view controllers to be used in SwiftUI navigation
internal struct UIKitViewControllerWrapper: View {
    let viewController: UIViewController
    
    init(_ viewController: UIViewController) {
        self.viewController = viewController
    }
    
    var body: some View {
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
