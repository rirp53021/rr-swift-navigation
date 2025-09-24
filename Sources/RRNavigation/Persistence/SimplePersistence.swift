// Copyright (c) 2024 Ronald Ruiz
// Licensed under the MIT License

import Foundation

// MARK: - Simple Persistence Implementations

/// Simple in-memory persistence implementation for testing and development
public final class InMemoryPersistence: NavigationStatePersistence {
    private var storedState: NavigationState?
    
    public init() {}
    
    public func save(_ state: NavigationState) throws {
        storedState = state
        Logger.shared.debug("Navigation state saved to memory")
    }
    
    public func restore() throws -> NavigationState? {
        Logger.shared.debug("Navigation state restored from memory")
        return storedState
    }
    
    public func clear() throws {
        storedState = nil
        Logger.shared.debug("Navigation state cleared from memory")
    }
}

/// Simple UserDefaults persistence implementation
public final class UserDefaultsPersistence: NavigationStatePersistence {
    private let key = "RRNavigationState"
    private let userDefaults: UserDefaults
    
    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    public func save(_ state: NavigationState) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(state)
        userDefaults.set(data, forKey: key)
        Logger.shared.info("Navigation state saved to UserDefaults")
    }
    
    public func restore() throws -> NavigationState? {
        guard let data = userDefaults.data(forKey: key) else {
            Logger.shared.info("No navigation state found in UserDefaults")
            return nil
        }
        
        let decoder = JSONDecoder()
        let state = try decoder.decode(NavigationState.self, from: data)
        Logger.shared.info("Navigation state restored from UserDefaults")
        return state
    }
    
    public func clear() throws {
        userDefaults.removeObject(forKey: key)
        Logger.shared.info("Navigation state cleared from UserDefaults")
    }
}
