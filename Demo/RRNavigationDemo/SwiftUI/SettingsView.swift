import SwiftUI
import RRNavigation

struct SettingsView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var theme = "light"
    @State private var notifications = true
    @State private var userId: String = ""
    
    var body: some View {
        NavigationView {
            List {
                Section("Profile Settings") {
                    HStack {
                        Image(systemName: "person.circle")
                            .foregroundColor(.blue)
                        Text("User ID")
                        Spacer()
                        Text(userId.isEmpty ? "Not set" : userId)
                            .foregroundColor(.secondary)
                    }
                    
                    Button("Edit Profile") {
                        navigationManager.navigate(
                            to: "profile",
                            parameters: RouteParameters(data: ["userId": userId, "edit": "true"]),
                            in: nil
                        )
                    }
                    .foregroundColor(.blue)
                }
                
                Section("Appearance") {
                    HStack {
                        Image(systemName: "paintbrush")
                            .foregroundColor(.purple)
                        Text("Theme")
                        Spacer()
                        Picker("Theme", selection: $theme) {
                            Text("Light").tag("light")
                            Text("Dark").tag("dark")
                            Text("System").tag("system")
                        }
                        .pickerStyle(.menu)
                    }
                }
                
                Section("Notifications") {
                    HStack {
                        Image(systemName: "bell")
                            .foregroundColor(.orange)
                        Text("Push Notifications")
                        Spacer()
                        Toggle("", isOn: $notifications)
                    }
                }
                
                Section("Navigation") {
                    HStack {
                        Image(systemName: "arrow.right.circle")
                            .foregroundColor(.green)
                        Text("Navigation Type")
                        Spacer()
                        Text("RRNavigation")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Image(systemName: "swift")
                            .foregroundColor(.orange)
                        Text("Framework")
                        Spacer()
                        Text("SwiftUI")
                            .foregroundColor(.secondary)
                    }
                }
                
                Section("Actions") {
                    Button("Go Back") {
                        navigationManager.navigateBack()
                    }
                    .foregroundColor(.blue)
                    
                    Button("Go to Home") {
                        navigationManager.navigate(
                            to: "home",
                            parameters: RouteParameters(),
                            in: nil
                        )
                    }
                    .foregroundColor(.green)
                    
                    Button("Reset Navigation") {
                        navigationManager.navigateToRoot(in: nil)
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            // Simulate loading user ID from parameters
            userId = "settings_user_\(Int.random(in: 1000...9999))"
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(NavigationManager.shared)
}
