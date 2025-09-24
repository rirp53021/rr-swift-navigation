// MARK: - Home View Factory

import SwiftUI
import Foundation

public struct HomeViewFactory: SwiftUIViewFactory {
    public typealias Output = AnyView
    
    public init() {}
    
    public func present(_ component: AnyView, with context: RouteContext) {
        // In a real implementation, this would handle the presentation
        // For the factory pattern, we just create the view
        print("🏠 HomeViewFactory: Creating HomeView")
    }
    
    public func presentView(_ view: AnyView, with context: RouteContext) {
        present(view, with: context)
    }
    
    public func createView(with context: RouteContext) -> AnyView {
        return AnyView(HomeView())
    }
}

// Demo HomeView
public struct HomeView: View {
    public init() {}
    
    public var body: some View {
        VStack(spacing: 20) {
            Text("🏠 Home View")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Welcome to the RRNavigation Demo!")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            VStack(alignment: .leading, spacing: 10) {
                Label("Chain of Responsibility Pattern", systemImage: "link")
                Label("Dedicated View Factories", systemImage: "building.2")
                Label("Type-Safe Route Keys", systemImage: "key")
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(10)
        }
        .padding()
        .navigationTitle("Home")
    }
}


