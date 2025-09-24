// MARK: - Profile View Factory

import SwiftUI
import Foundation

public struct ProfileViewFactory: SwiftUIViewFactory {
    public typealias Output = AnyView
    
    public init() {}
    
    public func present(_ component: AnyView, with context: RouteContext) {
        print("👤 ProfileViewFactory: Creating ProfileView")
    }
    
    public func presentView(_ view: AnyView, with context: RouteContext) {
        present(view, with: context)
    }
    
    public func createView(with context: RouteContext) -> AnyView {
        let userId = context.parameters.data["userId"] ?? "unknown"
        let userName = context.parameters.data["userName"] ?? "Unknown User"
        
        return AnyView(ProfileView(userId: userId, userName: userName))
    }
}

// Demo ProfileView
public struct ProfileView: View {
    let userId: String
    let userName: String
    
    public init(userId: String, userName: String) {
        self.userId = userId
        self.userName = userName
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            Circle()
                .fill(Color.blue)
                .frame(width: 100, height: 100)
                .overlay(
                    Text(String(userName.prefix(2)).uppercased())
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                )
            
            VStack(spacing: 8) {
                Text(userName)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("ID: \(userId)")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                ProfileInfoRow(icon: "person.fill", title: "User Name", value: userName)
                ProfileInfoRow(icon: "number", title: "User ID", value: userId)
                ProfileInfoRow(icon: "calendar", title: "Joined", value: "January 2024")
                ProfileInfoRow(icon: "star.fill", title: "Profile Type", value: "Premium")
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Profile")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

struct ProfileInfoRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            Text(title)
                .fontWeight(.medium)
            
            Spacer()
            
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}
