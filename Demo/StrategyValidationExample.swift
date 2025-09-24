// MARK: - Strategy Validation Example
//
// This file demonstrates how the NavigationManager now validates
// that factories are compatible with the active navigation strategy

import Foundation
import SwiftUI
import RRNavigation

#if canImport(UIKit)
import UIKit
#endif

/// Example demonstrating strategy validation
public class StrategyValidationExample {
    
    /// Example showing SwiftUI strategy with compatible and incompatible registrations
    @MainActor
    public static func demonstrateSwiftUIStrategy() {
        print("🧪 Testing SwiftUI Strategy Validation")
        print("=====================================")
        
        // Create a SwiftUI navigation manager
        let swiftUIManager = NavigationManagerFactory.createForSwiftUI()
        print("✅ Created SwiftUI NavigationManager")
        
        // Try to register a SwiftUI factory (should succeed)
        let swiftUIFactory = HomeViewFactory()
        swiftUIManager.register(swiftUIFactory, for: "home")
        print("✅ SwiftUI factory registration completed (check logs for success/failure)")
        
        #if canImport(UIKit)
        // Try to register a UIKit factory (should fail with SwiftUI strategy)
        let uikitFactory = ProfileViewControllerFactory()
        swiftUIManager.register(uikitFactory, for: "profileVC")
        print("✅ UIKit factory registration completed (should be rejected)")
        #endif
        
        print("")
    }
    
    /// Example showing UIKit strategy with compatible and incompatible registrations
    @MainActor
    public static func demonstrateUIKitStrategy() {
        print("🧪 Testing UIKit Strategy Validation")
        print("===================================")
        
        #if canImport(UIKit)
        // Create a UIKit navigation manager
        let uikitManager = NavigationManagerFactory.createForUIKit()
        print("✅ Created UIKit NavigationManager")
        
        // Try to register a UIKit factory (should succeed)
        let uikitFactory = ProfileViewControllerFactory()
        uikitManager.register(uikitFactory, for: "profileVC")
        print("✅ UIKit factory registration completed (check logs for success/failure)")
        
        // Try to register a SwiftUI factory (should fail with UIKit strategy)
        let swiftUIFactory = HomeViewFactory()
        uikitManager.register(swiftUIFactory, for: "home")
        print("✅ SwiftUI factory registration completed (should be rejected)")
        #else
        print("⚠️ UIKit not available on this platform")
        #endif
        
        print("")
    }
    
    /// Example showing Chain of Responsibility with strategy validation
    @MainActor
    public static func demonstrateChainOfResponsibilityValidation() {
        print("🧪 Testing Chain of Responsibility with Strategy Validation")
        print("=========================================================")
        
        // Create a SwiftUI navigation manager
        let manager = NavigationManagerFactory.createForSwiftUI()
        print("✅ Created SwiftUI NavigationManager")
        
        // Build the chain of responsibility
        let chain = RouteRegistrationChainBuilder()
            .addHandler(SwiftUIRouteHandler())
            .addHandler(UIKitRouteHandler())
            .addHandler(AdminRouteHandler())
            .addHandler(DeepLinkRouteHandler())
            .build()
        print("✅ Built chain of responsibility")
        
        // Register routes using the chain
        // The chain will try to register both SwiftUI and UIKit routes,
        // but only SwiftUI routes should succeed due to strategy validation
        manager.registerRoutes(using: chain)
        print("✅ Chain registration completed (check logs for which routes were accepted/rejected)")
        
        print("")
    }
    
    /// Run all validation examples
    @MainActor
    public static func runAllExamples() {
        print("🚀 Running Strategy Validation Examples")
        print("=======================================")
        print("")
        
        demonstrateSwiftUIStrategy()
        demonstrateUIKitStrategy()
        demonstrateChainOfResponsibilityValidation()
        
        print("✅ All examples completed!")
        print("Check the console logs above to see which registrations were accepted or rejected based on strategy compatibility.")
    }
}
