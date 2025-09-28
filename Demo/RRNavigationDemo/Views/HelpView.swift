//
//  HelpView.swift
//  RRNavigationDemo
//
//  Created by Ronald Ivan Ruiz Poveda on 27/09/25.
//

import SwiftUI
import RRNavigation

struct HelpView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "questionmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.green)
            
            Text("Help")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 16) {
                Text("How to use this demo:")
                    .font(.headline)
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("•")
                        Text("Use the tabs at the bottom to navigate between sections")
                    }
                    
                    HStack {
                        Text("•")
                        Text("Tap navigation links to go deeper into the app")
                    }
                    
                    HStack {
                        Text("•")
                        Text("Use the back button to return to previous screens")
                    }
                }
                .font(.body)
            }
            .padding()
            
            Spacer()
        }
        .padding()
        .navigationTitle("Help")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        HelpView()
    }
}


