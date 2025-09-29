//
//  SettingsView.swift
//  RRNavigationDemo
//
//  Created by Ronald Ivan Ruiz Poveda on 27/09/25.
//

import SwiftUI
import RRNavigation

struct SettingsView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    
    @State private var notificationsEnabled = true
    @State private var darkModeEnabled = false
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "gear.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.gray)
            
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Form {
                Section("Preferences") {
                    Toggle("Notifications", isOn: $notificationsEnabled)
                    Toggle("Dark Mode", isOn: $darkModeEnabled)
                }
                
                Section("Navigation") {
                    Button("About") { navigationManager.navigate(to: .about) }
                    Button("Help") { navigationManager.navigate(to: .help) }
                }
                
                Section("Account") {
                    Button("Sign Out") {
                        navigationManager.setAppModule(.notAuthenticated)
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}


