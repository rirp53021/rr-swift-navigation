// Copyright (c) 2024 Ronald Ruiz
// Licensed under the MIT License

import Testing
import RRNavigation

@Suite("RRNavigation Tests")
struct RRNavigationTests {
    
    @Test("Navigation Manager Creation")
    func testNavigationManagerCreation() async {
        let strategy = await NavigationStrategyType.swiftUI.createStrategy()
        let manager = await NavigationManager(strategy: strategy)
        
        #expect(manager is NavigationManager)
        #expect(await manager.activeStrategy is SwiftUINavigationStrategy)
    }
    
    @Test("Route Parameters")
    func testRouteParameters() {
        let params = RouteParameters(data: ["userId": "123", "name": "John"])
        
        #expect(params.data["userId"] == "123")
        #expect(params.data["name"] == "John")
    }
    
    @Test("Query String Parsing")
    func testQueryStringParsing() {
        let queryString = "userId=123&name=John%20Doe"
        let params = RouteParameters(from: queryString)
        
        #expect(params.data["userId"] == "123")
        #expect(params.data["name"] == "John Doe")
    }
    
    @Test("Navigation Error")
    func testNavigationError() {
        let error = NavigationError.routeNotFound("test-route")
        
        #expect(error.localizedDescription.contains("test-route"))
        #expect(error.recoverySuggestion != nil)
    }
    
    @Test("Strategy Selection")
    func testStrategySelection() async {
        let swiftUIStrategy = await NavigationStrategyType.swiftUI.createStrategy()
        let uikitStrategy = await NavigationStrategyType.uikit.createStrategy()
        
        #expect(swiftUIStrategy is SwiftUINavigationStrategy)
        #expect(uikitStrategy is UIKitNavigationStrategy)
    }
    
    @Test("Persistence")
    func testPersistence() async throws {
        let persistence = InMemoryPersistence()
        let state = await NavigationState()
        
        try persistence.save(state)
        let restoredState = try persistence.restore()
        
        #expect(restoredState != nil)
    }
}
