//
//  FullScreenDemoView.swift
//  RRNavigationDemo
//
//  Created by Ronald Ivan Ruiz Poveda on 27/09/25.
//

import SwiftUI
import RRNavigation

struct FullScreenDemoView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Full Screen Cover Demo")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("This view is presented as a full screen cover")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding()
                
                
                Button("Show Sheet") {
                    navigationManager.navigate(to: .sheetDemo)
                }
                .buttonStyle(.bordered)
                .foregroundColor(.blue)
                
                Button("Dismiss") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Full Screen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    FullScreenDemoView()
}
