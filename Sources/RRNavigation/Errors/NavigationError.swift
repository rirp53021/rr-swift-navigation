// MARK: - Navigation Errors

import Foundation

/// Navigation error types
public enum NavigationError: Error, LocalizedError {
    case invalidRouteKey
    case routeNotFound(String)
    case navigationFailed(String)
    case invalidParameters
    case tabNotFound(String)
    case persistenceFailed(String)
    case parameterNotFound(String)
    case parameterDecodingFailed(String, Any.Type)
    case animationNotSupported(String)
    case strategyNotSupported(String)
    case factoryNotRegistered(String)
    case invalidNavigationType(String)
    case circularNavigation(String)
    case stateRestorationFailed(String)
    
    public var errorDescription: String? {
        switch self {
        case .invalidRouteKey:
            return "Invalid route key provided"
        case .routeNotFound(let key):
            return "Route not found: \(key)"
        case .navigationFailed(let reason):
            return "Navigation failed: \(reason)"
        case .invalidParameters:
            return "Invalid parameters provided"
        case .tabNotFound(let tabId):
            return "Tab not found: \(tabId)"
        case .persistenceFailed(let reason):
            return "Persistence failed: \(reason)"
        case .parameterNotFound(let key):
            return "Parameter not found: \(key)"
        case .parameterDecodingFailed(let key, let type):
            return "Parameter decoding failed for key: \(key), type: \(type)"
        case .animationNotSupported(let animation):
            return "Animation not supported: \(animation)"
        case .strategyNotSupported(let strategy):
            return "Strategy not supported: \(strategy)"
        case .factoryNotRegistered(let key):
            return "Factory not registered for key: \(key)"
        case .invalidNavigationType(let type):
            return "Invalid navigation type: \(type)"
        case .circularNavigation(let route):
            return "Circular navigation detected for route: \(route)"
        case .stateRestorationFailed(let reason):
            return "State restoration failed: \(reason)"
        }
    }
    
    public var recoverySuggestion: String? {
        switch self {
        case .invalidRouteKey:
            return "Provide a non-empty route key"
        case .routeNotFound:
            return "Register the route factory before navigation"
        case .navigationFailed:
            return "Check navigation parameters and try again"
        case .invalidParameters:
            return "Verify parameter format and values"
        case .tabNotFound:
            return "Register the tab configuration first"
        case .persistenceFailed:
            return "Check persistence configuration and permissions"
        case .parameterNotFound:
            return "Include the required parameter in the route context"
        case .parameterDecodingFailed:
            return "Ensure parameter value matches expected type"
        case .animationNotSupported:
            return "Use a supported animation type for the current strategy"
        case .strategyNotSupported:
            return "Switch to a supported navigation strategy"
        case .factoryNotRegistered:
            return "Register the route factory before attempting navigation"
        case .invalidNavigationType:
            return "Use a valid navigation type from the supported options"
        case .circularNavigation:
            return "Avoid creating navigation loops in your route configuration"
        case .stateRestorationFailed:
            return "Check state persistence configuration and data integrity"
        }
    }
}
