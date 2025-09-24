// MARK: - About View Factory

import SwiftUI
import Foundation

public struct AboutViewFactory: SwiftUIViewFactory {
    public typealias Output = AnyView
    
    public init() {}
    
    public func present(_ component: AnyView, with context: RouteContext) {
        print("ℹ️ AboutViewFactory: Creating AboutView")
    }
    
    public func presentView(_ view: AnyView, with context: RouteContext) {
        present(view, with: context)
    }
    
    public func createView(with context: RouteContext) -> AnyView {
        return AnyView(AboutView())
    }
}

// Demo AboutView
public struct AboutView: View {
    public init() {}
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // App Icon and Title
                VStack(spacing: 15) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [.blue, .purple]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 100, height: 100)
                        .overlay(
                            Image(systemName: "map.fill")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                        )
                    
                    VStack(spacing: 5) {
                        Text("RRNavigation")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Chain of Responsibility Navigation")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Features Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("Features")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    VStack(spacing: 12) {
                        FeatureRow(
                            icon: "link",
                            title: "Chain of Responsibility",
                            description: "Organized route registration with dedicated handlers"
                        )
                        
                        FeatureRow(
                            icon: "key.fill",
                            title: "Type-Safe Route Keys",
                            description: "Compile-time route validation and safety"
                        )
                        
                        FeatureRow(
                            icon: "building.2.fill",
                            title: "Dedicated Factories",
                            description: "One factory per view for clear organization"
                        )
                        
                        FeatureRow(
                            icon: "gearshape.2.fill",
                            title: "Strategy Pattern",
                            description: "Support for both SwiftUI and UIKit"
                        )
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                // Version Info
                VStack(spacing: 10) {
                    Text("Version 1.0.0")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("Built with ❤️ using Swift")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Spacer(minLength: 50)
            }
            .padding()
        }
        .navigationTitle("About")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
                .padding(.top, 2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
    }
}


