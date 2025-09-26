import SwiftUI
import RRNavigation

struct NewSettingsView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var selectedStrategy: NavigationStrategyType = .swiftUI
    @State private var showingStrategyChangeAlert = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Navigation Strategy")) {
                    HStack {
                        Image(systemName: "gear.circle.fill")
                            .foregroundColor(.blue)
                        Text("Current Strategy")
                        Spacer()
                        Text(selectedStrategy.rawValue.capitalized)
                            .foregroundColor(.secondary)
                    }
                    
                    Button("Switch to SwiftUI") {
                        if selectedStrategy != .swiftUI {
                            selectedStrategy = .swiftUI
                            showingStrategyChangeAlert = true
                        }
                    }
                    .disabled(selectedStrategy == .swiftUI)
                    .foregroundColor(selectedStrategy == .swiftUI ? .gray : .blue)
                    
                    Button("Switch to UIKit") {
                        if selectedStrategy != .uikit {
                            selectedStrategy = .uikit
                            showingStrategyChangeAlert = true
                        }
                    }
                    .disabled(selectedStrategy == .uikit)
                    .foregroundColor(selectedStrategy == .uikit ? .gray : .blue)
                }
                
                Section(header: Text("Navigation Types")) {
                    SettingsNavigationCard<EmptyView>(
                        title: "Push Navigation",
                        description: "Standard stack-based navigation",
                        icon: "arrow.right.circle.fill",
                        color: .blue
                    ) {
                        navigationManager.navigate(
                            to: RouteID.pushDemo,
                            parameters: RouteParameters(data: ["source": "settings"]),
                            in: nil,
                            type: .push
                        )
                    }
                    
                    SettingsNavigationCard<EmptyView>(
                        title: "Sheet Presentation",
                        description: "Modal sheet from bottom",
                        icon: "rectangle.stack.fill",
                        color: .green
                    ) {
                        navigationManager.navigate(
                            to: RouteID.sheetDemo,
                            parameters: RouteParameters(data: ["source": "settings"]),
                            in: nil,
                            type: .sheet
                        )
                    }
                    
                    SettingsNavigationCard<EmptyView>(
                        title: "Full Screen Cover",
                        description: "Full screen modal presentation",
                        icon: "rectangle.fill",
                        color: .orange
                    ) {
                        navigationManager.navigate(
                            to: RouteID.fullScreenDemo,
                            parameters: RouteParameters(data: ["source": "settings"]),
                            in: nil,
                            type: .fullScreen
                        )
                    }
                    
                    SettingsNavigationCard<EmptyView>(
                        title: "Modal Presentation",
                        description: "Standard modal presentation",
                        icon: "square.stack.3d.up.fill",
                        color: .purple
                    ) {
                        navigationManager.navigate(
                            to: RouteID.modalDemo,
                            parameters: RouteParameters(data: ["source": "settings"]),
                            in: nil,
                            type: .modal
                        )
                    }
                }
                
                Section(header: Text("Actions")) {
                    Button("Go Back") {
                        navigationManager.navigateBack()
                    }
                    .foregroundColor(.blue)
                    
                    Button("Go to Home") {
                        navigationManager.navigate(
                            to: RouteID.home,
                            parameters: RouteParameters(),
                            in: nil,
                            type: nil
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
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            selectedStrategy = navigationManager.activeStrategy.strategyType
        }
        .alert("Strategy Changed", isPresented: $showingStrategyChangeAlert) {
            Button("OK") {
                // Strategy change would be implemented here
                // For now, just show the alert
            }
        } message: {
            Text("Navigation strategy changed to \(selectedStrategy.rawValue.capitalized). Restart the app to see the changes.")
        }
    }
}

struct SettingsNavigationCard<Destination: View>: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    let destination: () -> Void
    
    var body: some View {
        Button(action: destination) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    NewSettingsView()
        .environmentObject(NavigationManager(strategy: SwiftUINavigationStrategy()))
}
