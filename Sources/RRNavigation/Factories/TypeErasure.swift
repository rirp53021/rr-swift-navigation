// MARK: - Type Erasure for Factories

import Foundation
import SwiftUI

/// Type-erased route factory
public class AnyRouteFactory: RouteFactory {
    public typealias Output = Any
    
    private let _present: (Any, RouteContext) -> Void
    
    public init<T: RouteFactory>(_ factory: T) {
        self._present = { component, context in
            factory.present(component as! T.Output, with: context)
        }
    }
    
    public func present(_ component: Any, with context: RouteContext) {
        _present(component, context)
    }
}

/// Type-erased SwiftUI view factory
public class AnySwiftUIViewFactory: SwiftUIViewFactory {
    public typealias Output = AnyView
    
    private let _presentView: (AnyView, RouteContext) -> Void
    private let _createView: (RouteContext) -> AnyView
    
    public init<T: SwiftUIViewFactory>(_ factory: T) {
        self._presentView = { view, context in
            factory.presentView(view, with: context)
        }
        self._createView = { context in
            factory.createView(with: context)
        }
    }
    
    public func present(_ component: AnyView, with context: RouteContext) {
        _presentView(component, context)
    }
    
    public func presentView(_ view: AnyView, with context: RouteContext) {
        _presentView(view, context)
    }
    
    public func createView(with context: RouteContext) -> AnyView {
        return _createView(context)
    }
}

/// Type-erased UIKit view controller factory
#if canImport(UIKit)
public class AnyUIKitViewControllerFactory: UIKitViewControllerFactory {
    public typealias Output = UIViewController
    
    private let _presentViewController: (UIViewController, RouteContext) -> Void
    
    public init<T: UIKitViewControllerFactory>(_ factory: T) {
        self._presentViewController = { viewController, context in
            factory.presentViewController(viewController, with: context)
        }
    }
    
    public func present(_ component: UIViewController, with context: RouteContext) {
        _presentViewController(component, context)
    }
    
    public func presentViewController(_ viewController: UIViewController, with context: RouteContext) {
        _presentViewController(viewController, context)
    }
}
#else
public class AnyUIKitViewControllerFactory: UIKitViewControllerFactory {
    public typealias Output = Any
    
    private let _presentViewController: (Any, RouteContext) -> Void
    
    public init<T: UIKitViewControllerFactory>(_ factory: T) {
        self._presentViewController = { viewController, context in
            factory.presentViewController(viewController, with: context)
        }
    }
    
    public func present(_ component: Any, with context: RouteContext) {
        _presentViewController(component, context)
    }
    
    public func presentViewController(_ viewController: Any, with context: RouteContext) {
        _presentViewController(viewController, context)
    }
}
#endif

// MARK: - Factory Helpers

/// SwiftUI view factory helper
public struct SwiftUIViewFactoryHelper<Content: View>: SwiftUIViewFactory {
    public typealias Output = AnyView
    
    private let presenter: (AnyView, RouteContext) -> Void
    private let viewCreator: (RouteContext) -> AnyView
    
    public init(_ presenter: @escaping (AnyView, RouteContext) -> Void, viewCreator: @escaping (RouteContext) -> AnyView) {
        self.presenter = presenter
        self.viewCreator = viewCreator
    }
    
    public func present(_ component: AnyView, with context: RouteContext) {
        presenter(component, context)
    }
    
    public func presentView(_ view: AnyView, with context: RouteContext) {
        presenter(view, context)
    }
    
    public func createView(with context: RouteContext) -> AnyView {
        return viewCreator(context)
    }
}

/// UIKit view controller factory helper
#if canImport(UIKit)
public struct UIKitViewControllerFactoryHelper<ViewController: UIViewController>: UIKitViewControllerFactory {
    public typealias Output = ViewController
    
    private let presenter: (UIViewController, RouteContext) -> Void
    
    public init(_ presenter: @escaping (UIViewController, RouteContext) -> Void) {
        self.presenter = presenter
    }
    
    public func present(_ component: ViewController, with context: RouteContext)  {
        presenter(component, context)
    }
    
    public func presentViewController(_ viewController: UIViewController, with context: RouteContext)  {
        presenter(viewController, context)
    }
}
#else
public struct UIKitViewControllerFactoryHelper<ViewController>: UIKitViewControllerFactory {
    public typealias Output = ViewController
    
    private let presenter: (Any, RouteContext) -> Void
    
    public init(_ presenter: @escaping (Any, RouteContext) -> Void) {
        self.presenter = presenter
    }
    
    public func present(_ component: ViewController, with context: RouteContext)  {
        presenter(component as! Any, context)
    }
    
    public func presentViewController(_ viewController: Any, with context: RouteContext)  {
        presenter(viewController, context)
    }
}
#endif
