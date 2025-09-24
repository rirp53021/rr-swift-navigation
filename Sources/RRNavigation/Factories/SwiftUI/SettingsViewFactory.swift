// MARK: - Settings View Factory

import SwiftUI
import Foundation

public struct SettingsViewFactory: SwiftUIViewFactory {
    public typealias Output = AnyView
    
    public init() {}
    
    public func present(_ component: AnyView, with context: RouteContext) {
        print("⚙️ SettingsViewFactory: Creating SettingsView")
    }
    
    public func presentView(_ view: AnyView, with context: RouteContext) {
        present(view, with: context)
    }
    
    public func createView(with context: RouteContext) -> AnyView {
        let theme = context.parameters.data["theme"] ?? "light"
        let notifications = context.parameters.data["notifications"] == "true"
        
        return AnyView(SettingsView(theme: theme, notifications: notifications))
    }
}

// Demo SettingsView
public struct SettingsView: View {
    let theme: String
    let notifications: Bool
    
    @State private var isDarkMode: Bool = false
    @State private var isNotificationsEnabled: Bool = true
    @State private var selectedLanguage = "English"
    
    let languages = ["English", "Spanish", "French", "German", "Japanese"]
    
    public init(theme: String, notifications: Bool) {
        self.theme = theme
        self.notifications = notifications
        self._isDarkMode = State(initialValue: theme == "dark")
        self._isNotificationsEnabled = State(initialValue: notifications)
    }
    
    public var body: some View {
        List {
            Section("Appearance") {
                HStack {
                    Image(systemName: "paintbrush.fill")
                        .foregroundColor(.blue)
                    Text("Theme")
                    Spacer()
                    Text(theme.capitalized)
                        .foregroundColor(.secondary)
                }
                
                Toggle(isOn: $isDarkMode) {
                    HStack {
                        Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                            .foregroundColor(isDarkMode ? .purple : .orange)
                        Text("Dark Mode")
                    }
                }
            }
            
            Section("Notifications") {
                Toggle(isOn: $isNotificationsEnabled) {
                    HStack {
                        Image(systemName: "bell.fill")
                            .foregroundColor(.red)
                        Text("Push Notifications")
                    }
                }
                
                if isNotificationsEnabled {
                    HStack {
                        Image(systemName: "speaker.wave.2.fill")
                            .foregroundColor(.green)
                        Text("Sound")
                        Spacer()
                        Text("Default")
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Section("General") {
                HStack {
                    Image(systemName: "globe")
                        .foregroundColor(.blue)
                    Text("Language")
                    Spacer()
                    Picker("Language", selection: $selectedLanguage) {
                        ForEach(languages, id: \.self) { language in
                            Text(language).tag(language)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                HStack {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.gray)
                    Text("Version")
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(.secondary)
                }
            }
            
            Section("Support") {
                HStack {
                    Image(systemName: "questionmark.circle.fill")
                        .foregroundColor(.orange)
                    Text("Help & Support")
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                
                HStack {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(.blue)
                    Text("Contact Us")
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
            }
        }
        .navigationTitle("Settings")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}


