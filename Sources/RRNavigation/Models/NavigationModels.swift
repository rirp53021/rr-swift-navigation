// MARK: - Core Navigation Models

import Foundation
import SwiftUI
import Combine

/// Navigation state
@MainActor
public final class NavigationState: ObservableObject, @preconcurrency Codable {
    @Published public var currentTab: String?
    @Published public var tabStates: [String: TabNavigationState] = [:]
    @Published public var modalStack: [ModalDestination] = []
    
    public init() {}
    
    // MARK: - Codable Implementation
    
    private enum CodingKeys: String, CodingKey {
        case currentTab, tabStates, modalStack
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let currentTab = try container.decodeIfPresent(String.self, forKey: .currentTab)
        let tabStates = try container.decode([String: TabNavigationState].self, forKey: .tabStates)
        let modalStack = try container.decode([ModalDestination].self, forKey: .modalStack)
        
        // Initialize on main actor
        Task { @MainActor in
            self.currentTab = currentTab
            self.tabStates = tabStates
            self.modalStack = modalStack
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(currentTab, forKey: .currentTab)
        try container.encode(tabStates, forKey: .tabStates)
        try container.encode(modalStack, forKey: .modalStack)
    }
}

/// Tab navigation state
public struct TabNavigationState: Codable {
    public let tabId: String
    public var navigationStack: [RouteToken]
    public var isActive: Bool
    public var lastAccessed: Date
    
    public init(tabId: String, isActive: Bool = false) {
        self.tabId = tabId
        self.navigationStack = []
        self.isActive = isActive
        self.lastAccessed = Date()
    }
}

/// Route token for persistence
public struct RouteToken: Codable {
    public let key: String
    public let parameters: RouteParameters
    public let timestamp: Date
    public let navigationType: NavigationType
    
    public init(key: String, parameters: RouteParameters, navigationType: NavigationType = .push) {
        self.key = key
        self.parameters = parameters
        self.timestamp = Date()
        self.navigationType = navigationType
    }
}

/// Route parameters with Codable support
public struct RouteParameters: Codable {
    public let data: [String: String]
    
    public init(data: [String: String] = [:]) {
        self.data = data
    }
    
    public init(from queryString: String) {
        let components = queryString.components(separatedBy: "&")
        var data: [String: String] = [:]
        
        for component in components {
            let parts = component.components(separatedBy: "=")
            if parts.count == 2 {
                let key = parts[0].removingPercentEncoding ?? parts[0]
                let value = parts[1].removingPercentEncoding ?? parts[1]
                data[key] = value
            }
        }
        
        self.data = data
    }
    
    public var queryString: String {
        return data.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
    }
    
    public func value<T: Codable>(for key: String, as type: T.Type) throws -> T {
        guard let stringValue = data[key] else {
            throw NavigationError.parameterNotFound(key)
        }
        
        // Try to decode from string
        if let data = stringValue.data(using: .utf8) {
            let decoder = JSONDecoder()
            return try decoder.decode(type, from: data)
        }
        
        throw NavigationError.parameterDecodingFailed(key, type)
    }
}

/// Route context
public struct RouteContext {
    public let key: String
    public let parameters: RouteParameters
    public let navigationType: NavigationType
    public let tabId: String?
    public let animation: NavigationAnimation?
    
    public init(
        key: String,
        parameters: RouteParameters,
        navigationType: NavigationType,
        tabId: String? = nil,
        animation: NavigationAnimation? = nil
    ) {
        self.key = key
        self.parameters = parameters
        self.navigationType = navigationType
        self.tabId = tabId
        self.animation = animation
    }
}

/// Navigation types
public enum NavigationType: String, CaseIterable, Codable {
    case push
    case sheet
    case fullScreen
    case tab
    case modal
    case replace
}

/// Tab configuration
public struct TabConfiguration: Codable {
    public let id: String
    public let title: String
    public let icon: String?
    public let isDefault: Bool
    public let badge: String?
    
    public init(
        id: String,
        title: String,
        icon: String? = nil,
        isDefault: Bool = false,
        badge: String? = nil
    ) {
        self.id = id
        self.title = title
        self.icon = icon
        self.isDefault = isDefault
        self.badge = badge
    }
}

/// Navigation destination
public struct NavigationDestination {
    public let key: String
    public let parameters: RouteParameters
    public let navigationType: NavigationType
    public let tabId: String?
    public let animation: NavigationAnimation?
    
    public init(
        key: String,
        parameters: RouteParameters,
        navigationType: NavigationType,
        tabId: String? = nil,
        animation: NavigationAnimation? = nil
    ) {
        self.key = key
        self.parameters = parameters
        self.navigationType = navigationType
        self.tabId = tabId
        self.animation = animation
    }
}

/// Modal destination
public struct ModalDestination: Codable {
    public let key: String
    public let parameters: RouteParameters
    public let navigationType: NavigationType
    public let timestamp: Date
    
    public init(key: String, parameters: RouteParameters, navigationType: NavigationType) {
        self.key = key
        self.parameters = parameters
        self.navigationType = navigationType
        self.timestamp = Date()
    }
}
