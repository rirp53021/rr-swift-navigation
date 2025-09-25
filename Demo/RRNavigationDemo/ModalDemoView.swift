import SwiftUI
import RRNavigation

struct ModalDemoView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var isModalPresented = false
    @State private var isSheetPresented = false
    @State private var isFullScreenPresented = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 8) {
                    Text("Modal Presentation Demo")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Demonstrates modal presentation and dismissal")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top)
                
                // Modal Presentation Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Present Modals")
                        .font(.headline)
                    
                    VStack(spacing: 12) {
                        Button(action: presentSheet) {
                            HStack {
                                Image(systemName: "rectangle.and.pencil.and.ellipsis")
                                Text("Present Sheet")
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Button(action: presentModal) {
                            HStack {
                                Image(systemName: "rectangle.stack")
                                Text("Present Modal")
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Button(action: presentFullScreen) {
                            HStack {
                                Image(systemName: "rectangle.fill")
                                Text("Present Full Screen")
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.blue.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                        )
                )
                
                // Modal Dismissal Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Dismiss Modals")
                        .font(.headline)
                    
                    VStack(spacing: 12) {
                        Button(action: dismissTopModal) {
                            HStack {
                                Image(systemName: "xmark.circle")
                                Text("Dismiss Top Modal")
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .foregroundColor(.orange)
                        
                        Button(action: dismissAllModals) {
                            HStack {
                                Image(systemName: "xmark.circle.fill")
                                Text("Dismiss All Modals")
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .foregroundColor(.red)
                        
                        Button(action: dismissSpecificModal) {
                            HStack {
                                Image(systemName: "xmark.square")
                                Text("Dismiss Settings Modal")
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .foregroundColor(.purple)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.orange.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.orange.opacity(0.2), lineWidth: 1)
                        )
                )
                
                // Code Examples Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Code Examples")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        CodeExample(
                            title: "Present Modal",
                            code: """
navigationManager.presentModal(
    to: "settings",
    parameters: RouteParameters(data: [
        "userId": "demo_user"
    ])
)
"""
                        )
                        
                        CodeExample(
                            title: "Dismiss Modal",
                            code: """
// Dismiss topmost modal
navigationManager.dismissModal()

// Dismiss all modals
navigationManager.dismissAllModals()

// Dismiss specific modal
navigationManager.dismissModal(with: "settings")
"""
                        )
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                )
            }
            .padding()
        }
        .navigationTitle("Modal Demo")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isSheetPresented) {
            ModalContentView(
                title: "Sheet Modal",
                onDismiss: { isSheetPresented = false }
            )
        }
        .fullScreenCover(isPresented: $isFullScreenPresented) {
            ModalContentView(
                title: "Full Screen Modal",
                onDismiss: { isFullScreenPresented = false }
            )
        }
    }
    
    // MARK: - Presentation Methods
    
    private func presentSheet() {
        let parameters = RouteParameters(data: [
            "userId": "demo_user",
            "source": "modal_demo"
        ])
        
        navigationManager.navigate(
            to: RouteID.settings,
            parameters: parameters,
            type: .sheet
        )
        
        // Also show local sheet for demonstration
        isSheetPresented = true
    }
    
    private func presentModal() {
        let parameters = RouteParameters(data: [
            "userId": "demo_user",
            "source": "modal_demo"
        ])
        
        navigationManager.navigate(
            to: RouteID.settings,
            parameters: parameters,
            type: .modal
        )
    }
    
    private func presentFullScreen() {
        let parameters = RouteParameters(data: [
            "userId": "demo_user",
            "source": "modal_demo"
        ])
        
        navigationManager.navigate(
            to: RouteID.settings,
            parameters: parameters,
            type: .fullScreen
        )
        
        // Also show local full screen for demonstration
        isFullScreenPresented = true
    }
    
    // MARK: - Dismissal Methods
    
    private func dismissTopModal() {
        navigationManager.dismissModal()
    }
    
    private func dismissAllModals() {
        navigationManager.dismissAllModals()
    }
    
    private func dismissSpecificModal() {
        navigationManager.dismissModal(with: "settings")
    }
}

// MARK: - Supporting Views

struct ModalContentView: View {
    let title: String
    let onDismiss: () -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("This is a modal view that can be dismissed using the navigation manager or the close button.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                
                VStack(spacing: 12) {
                    Button("Dismiss with NavigationManager") {
                        // This would use the navigation manager in a real app
                        onDismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Close Button") {
                        onDismiss()
                    }
                    .buttonStyle(.bordered)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Modal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        onDismiss()
                    }
                }
            }
        }
    }
}


#Preview {
    ModalDemoView()
        .environmentObject(NavigationManager.shared)
}
