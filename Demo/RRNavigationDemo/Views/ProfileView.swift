//
//  ProfileView.swift
//  RRNavigationDemo
//
//  Created by Ronald Ivan Ruiz Poveda on 27/09/25.
//

import SwiftUI
import RRNavigation

struct ProfileView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            Text("Profile")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("This is the Profile view")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
            
            VStack(spacing: 16) {
                Button("Edit Profile") {
                    navigationManager.navigate(to: .editProfile)
                }
                .buttonStyle(.borderedProminent)
                
                Button("Navigate to Settings") {
                    // This would use NavigationManager in a real app
                }
                .buttonStyle(.bordered)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
}
