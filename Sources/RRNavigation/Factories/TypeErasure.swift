// MARK: - Type Erasure for Factories

import Foundation
import SwiftUI

/// Type-erased route factory
public class AnyRouteFactory: RouteFactoryProtocol {
    public typealias Output = Any
    
    private let _build: (RouteContext) throws -> Any
    
    public init<T: RouteFactoryProtocol>(_ factory: T) {
        self._build = { context in
            try factory.build(with: context)
        }
    }
    
    public func build(with context: RouteContext) throws -> Any {
        return try _build(context)
    }
}

/// Type-erased SwiftUI view factory
public class AnySwiftUIViewFactory: SwiftUIViewFactoryProtocol {
    public typealias Output = AnyView
    
    private let _buildView: (RouteContext) throws -> AnyView
    
    public init<T: SwiftUIViewFactoryProtocol>(_ factory: T) {
        self._buildView = { context in
            AnyView(try factory.buildView(with: context))
        }
    }
    
    public func build(with context: RouteContext) throws -> AnyView {
        return try _buildView(context)
    }
    
    public func buildView(with context: RouteContext) throws -> AnyView {
        return try _buildView(context)
    }
}

/// Type-erased UIKit view controller factory
#if canImport(UIKit)
public class AnyUIKitViewControllerFactory: UIKitViewControllerFactoryProtocol {
    public typealias Output = UIViewController
    
    private let _buildViewController: (RouteContext) throws -> UIViewController
    
    public init<T: UIKitViewControllerFactoryProtocol>(_ factory: T) {
        self._buildViewController = { context in
            try factory.buildViewController(with: context)
        }
    }
    
    public func build(with context: RouteContext) throws -> UIViewController {
        return try _buildViewController(context)
    }
    
    public func buildViewController(with context: RouteContext) throws -> UIViewController {
        return try _buildViewController(context)
    }
}
#else
public class AnyUIKitViewControllerFactory: UIKitViewControllerFactoryProtocol {
    public typealias Output = Any
    
    private let _buildViewController: (RouteContext) throws -> Any
    
    public init<T: UIKitViewControllerFactoryProtocol>(_ factory: T) {
        self._buildViewController = { context in
            try factory.buildViewController(with: context)
        }
    }
    
    public func build(with context: RouteContext) throws -> Any {
        return try _buildViewController(context)
    }
    
    public func buildViewController(with context: RouteContext) throws -> Any {
        return try _buildViewController(context)
    }
}
#endif

// MARK: - Factory Helpers

/// SwiftUI view factory helper
public struct SwiftUIViewFactory<Content: View>: SwiftUIViewFactoryProtocol {
    public typealias Output = AnyView
    
    private let builder: (RouteContext) throws -> Content
    
    public init(_ builder: @escaping (RouteContext) throws -> Content) {
        self.builder = builder
    }
    
    public func build(with context: RouteContext) throws -> AnyView {
        return AnyView(try builder(context))
    }
    
    public func buildView(with context: RouteContext) throws -> AnyView {
        return AnyView(try builder(context))
    }
}

/// UIKit view controller factory helper
#if canImport(UIKit)
public struct UIKitViewControllerFactory<ViewController: UIViewController>: UIKitViewControllerFactoryProtocol {
    public typealias Output = ViewController
    
    private let builder: (RouteContext) throws -> ViewController
    
    public init(_ builder: @escaping (RouteContext) throws -> ViewController) {
        self.builder = builder
    }
    
    public func build(with context: RouteContext) throws -> ViewController {
        return try builder(context)
    }
    
    public func buildViewController(with context: RouteContext) throws -> ViewController {
        return try builder(context)
    }
}
#else
public struct UIKitViewControllerFactory<ViewController>: UIKitViewControllerFactoryProtocol {
    public typealias Output = ViewController
    
    private let builder: (RouteContext) throws -> ViewController
    
    public init(_ builder: @escaping (RouteContext) throws -> ViewController) {
        self.builder = builder
    }
    
    public func build(with context: RouteContext) throws -> ViewController {
        return try builder(context)
    }
    
    public func buildViewController(with context: RouteContext) throws -> ViewController {
        return try builder(context)
    }
}
#endif
