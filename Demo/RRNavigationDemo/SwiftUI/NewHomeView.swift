import SwiftUI
import RRNavigation

struct NewHomeView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var currentStrategy: String = "SwiftUI"
    
    var body: some View {
        ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 8) {
                        Text("RRNavigation Demo")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Testing all navigation types")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text("Strategy: \(currentStrategy)")
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.blue)
                            .clipShape(Capsule())
                    }
                    .padding(.top)
                    
                    // Navigation Type Examples
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        
                        // Push Navigation
                        NavigationExampleCard(
                            title: "Push",
                            description: "Stack navigation",
                            icon: "arrow.right.circle.fill",
                            color: .blue
                        ) {
                            navigationManager.navigate(
                                to: RouteID.pushDemo,
                                parameters: RouteParameters(data: ["source": "home"]),
                                in: nil,
                                type: .push
                            )
                        }
                        
                        // Sheet Navigation
                        NavigationExampleCard(
                            title: "Sheet",
                            description: "Bottom sheet",
                            icon: "rectangle.stack.fill",
                            color: .green
                        ) {
                            navigationManager.navigate(
                                to: RouteID.sheetDemo,
                                parameters: RouteParameters(data: ["source": "home"]),
                                in: nil,
                                type: .sheet
                            )
                        }
                        
                        // Full Screen Navigation
                        NavigationExampleCard(
                            title: "Full Screen",
                            description: "Full screen modal",
                            icon: "rectangle.fill",
                            color: .orange
                        ) {
                            navigationManager.navigate(
                                to: RouteID.fullScreenDemo,
                                parameters: RouteParameters(data: ["source": "home"]),
                                in: nil,
                                type: .fullScreen
                            )
                        }
                        
                        // Modal Navigation
                        NavigationExampleCard(
                            title: "Modal",
                            description: "Standard modal",
                            icon: "square.stack.3d.up.fill",
                            color: .purple
                        ) {
                            navigationManager.navigate(
                                to: RouteID.modalDemo,
                                parameters: RouteParameters(data: ["source": "home"]),
                                in: nil,
                                type: .modal
                            )
                        }
                        
                        // Replace Navigation
                        NavigationExampleCard(
                            title: "Replace",
                            description: "Replace current view",
                            icon: "arrow.2.squarepath",
                            color: .red
                        ) {
                            navigationManager.navigate(
                                to: RouteID.replaceDemo,
                                parameters: RouteParameters(data: ["source": "home"]),
                                in: nil,
                                type: .replace
                            )
                        }
                        
                        // Tab Navigation
                        NavigationExampleCard(
                            title: "Tab",
                            description: "Switch tabs",
                            icon: "square.grid.2x2.fill",
                            color: .indigo
                        ) {
                            navigationManager.navigate(
                                to: RouteID.tabDemo,
                                parameters: RouteParameters(data: ["source": "home"]),
                                in: "nested",
                                type: .tab
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    // Quick Actions
                    VStack(spacing: 12) {
                        Text("Quick Actions")
                            .font(.headline)
                            .padding(.top)
                        
                        HStack(spacing: 12) {
                            Button("Navigate Back") {
                                navigationManager.navigateBack()
                            }
                            .buttonStyle(.bordered)
                            
                            Button("Go to Root") {
                                navigationManager.navigateToRoot(in: nil)
                            }
                            .buttonStyle(.bordered)
                            
                            Button("Settings") {
                                navigationManager.navigate(
                                    to: RouteID.newSettings,
                                    parameters: RouteParameters(),
                                    in: nil,
                                    type: .sheet
                                )
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 20)
                }
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            currentStrategy = navigationManager.activeStrategy.strategyType.rawValue.capitalized
        }
    }
}

struct NavigationExampleCard: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 32))
                    .foregroundColor(color)
                
                VStack(spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    NewHomeView()
        .environmentObject(NavigationManager(strategy: SwiftUINavigationStrategy()))
}
