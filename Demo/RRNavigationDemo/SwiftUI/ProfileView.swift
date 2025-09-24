import SwiftUI
import RRNavigation

struct ProfileView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    let userId: String
    let name: String
    
    init(userId: String = "unknown", name: String = "Unknown User") {
        self.userId = userId
        self.name = name
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Profile Header
            VStack(spacing: 12) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                
                Text(name)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("User ID: \(userId)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(16)
            
            // Profile Actions
            VStack(spacing: 16) {
                Button("Edit Profile") {
                    navigationManager.navigate(
                        to: "settings",
                        parameters: RouteParameters(data: ["section": "profile", "userId": userId]),
                        in: nil
                    )
                }
                .buttonStyle(.borderedProminent)
                
                Button("View Settings") {
                    navigationManager.navigate(
                        to: "settings",
                        parameters: RouteParameters(data: ["userId": userId]),
                        in: nil,
                        type: .sheet
                    )
                }
                .buttonStyle(.bordered)
                
                Button("Back to Home") {
                    navigationManager.navigateBack()
                }
                .buttonStyle(.bordered)
            }
            
            // Profile Info
            VStack(alignment: .leading, spacing: 12) {
                Text("Profile Information")
                    .font(.headline)
                
                ProfileInfoRow(title: "User ID", value: userId)
                ProfileInfoRow(title: "Name", value: name)
                ProfileInfoRow(title: "Source", value: "SwiftUI")
                ProfileInfoRow(title: "Navigation", value: "RRNavigation")
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ProfileInfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
        }
    }
}

#Preview {
    NavigationView {
        ProfileView(userId: "preview123", name: "Preview User")
            .environmentObject(NavigationManager.shared)
    }
}
