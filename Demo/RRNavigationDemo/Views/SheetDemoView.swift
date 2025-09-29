//
//  SheetDemoView.swift
//  RRNavigationDemo
//
//  Created by Ronald Ivan Ruiz Poveda on 27/09/25.
//

import SwiftUI
import RRNavigation

struct SheetDemoView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Sheet Demo")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("This view is presented as a sheet")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Button("Show Full Screen Cover") {
                    navigationManager.navigate(to: .fullScreenDemo)
                }
                .buttonStyle(.bordered)
                .foregroundColor(.orange)
                
                Button("Go to Settings") {
                    navigationManager.navigate(to: .settings)
                }
                .buttonStyle(.bordered)
                
                Button("Dismiss") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Sheet")
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
    SheetDemoView()
}
