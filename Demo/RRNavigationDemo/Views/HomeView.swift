//
//  HomeView.swift
//  RRNavigationDemo
//
//  Created by Ronald Ivan Ruiz Poveda on 27/09/25.
//

import SwiftUI
import RRNavigation

struct HomeView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Home")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Welcome to the RRNavigation Demo!")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
            
            VStack(spacing: 16) {
                Button("Go to Profile") {
                    navigationManager.navigate(to: .profile, forceReset: false)
                }
                .buttonStyle(.borderedProminent)
                
                Button("Go to Settings") {
                    navigationManager.navigate(to: .settings)
                }
                .buttonStyle(.bordered)
                
                Button("Show Full Screen Cover") {
                    navigationManager.navigate(to: .fullScreenDemo)
                }
                .buttonStyle(.bordered)
                .foregroundColor(.orange)
                
                Button("Show Sheet") {
                    navigationManager.navigate(to: .sheetDemo)
                }
                .buttonStyle(.bordered)
                .foregroundColor(.blue)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Home")
    }
}

#Preview {
    HomeView()
}
