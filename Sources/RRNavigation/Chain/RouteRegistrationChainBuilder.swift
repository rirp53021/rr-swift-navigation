// MARK: - Route Registration Chain Builder

import Foundation

/// Chain builder for easy setup
public class RouteRegistrationChainBuilder {
    private var handlers: [RouteRegistrationHandler] = []
    
    public init() {}
    
    /// Add a handler to the chain
    public func addHandler(_ handler: RouteRegistrationHandler) -> RouteRegistrationChainBuilder {
        handlers.append(handler)
        return self
    }
    
    /// Build the chain by linking handlers
    public func build() -> RouteRegistrationHandler? {
        guard !handlers.isEmpty else { return nil }
        
        // Link handlers in chain
        for i in 0..<handlers.count - 1 {
            handlers[i].nextHandler = handlers[i + 1]
        }
        
        return handlers.first
    }
}


