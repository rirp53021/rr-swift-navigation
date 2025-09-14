// MARK: - Navigation Persistence Implementations

import Foundation
import RRPersistence

/// UserDefaults-based navigation state persistence
public class UserDefaultsPersistence: NavigationStatePersistable {
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

/// In-memory navigation state persistence for testing
public class InMemoryPersistence: NavigationStatePersistable {
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
