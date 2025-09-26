import SwiftUI
import RRNavigation

struct NestedNavigationView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var navigationPath: [String] = []
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 8) {
                    Text("Nested Navigation")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Test complex navigation scenarios")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top)
                
                // Tab Picker
                Picker("Navigation Type", selection: $selectedTab) {
                    Text("Push Stack").tag(0)
                    Text("Modal Chain").tag(1)
                    Text("Mixed Types").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                // Content based on selected tab
                TabView(selection: $selectedTab) {
                    // Push Stack Navigation
                    PushStackDemo()
                        .tag(0)
                    
                    // Modal Chain Navigation
                    ModalChainDemo()
                        .tag(1)
                    
                    // Mixed Types Navigation
                    MixedTypesDemo()
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .navigationTitle("Nested Navigation")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Push Stack Demo
struct PushStackDemo: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var stackDepth = 0
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Push Stack Navigation")
                .font(.headline)
            
            Text("Current depth: \(stackDepth)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            VStack(spacing: 12) {
                Button("Push View A") {
                    navigationManager.navigate(
                        to: RouteID.pushA,
                        parameters: RouteParameters(data: ["depth": "\(stackDepth + 1)"]),
                        in: nil,
                        type: .push
                    )
                    stackDepth += 1
                }
                .buttonStyle(.borderedProminent)
                
                Button("Push View B") {
                    navigationManager.navigate(
                        to: RouteID.pushB,
                        parameters: RouteParameters(data: ["depth": "\(stackDepth + 1)"]),
                        in: nil,
                        type: .push
                    )
                    stackDepth += 1
                }
                .buttonStyle(.bordered)
                
                Button("Push View C") {
                    navigationManager.navigate(
                        to: RouteID.pushC,
                        parameters: RouteParameters(data: ["depth": "\(stackDepth + 1)"]),
                        in: nil,
                        type: .push
                    )
                    stackDepth += 1
                }
                .buttonStyle(.bordered)
            }
            
            Spacer()
        }
        .padding()
    }
}

// MARK: - Modal Chain Demo
struct ModalChainDemo: View {
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Modal Chain Navigation")
                .font(.headline)
            
            Text("Present modals in sequence")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            VStack(spacing: 12) {
                Button("Show Sheet") {
                    navigationManager.navigate(
                        to: RouteID.sheetDemo,
                        parameters: RouteParameters(data: ["chain": "1"]),
                        in: nil,
                        type: .sheet
                    )
                }
                .buttonStyle(.borderedProminent)
                
                Button("Show Full Screen") {
                    navigationManager.navigate(
                        to: RouteID.fullScreenDemo,
                        parameters: RouteParameters(data: ["chain": "2"]),
                        in: nil,
                        type: .fullScreen
                    )
                }
                .buttonStyle(.bordered)
                
                Button("Show Modal") {
                    navigationManager.navigate(
                        to: RouteID.modalDemo,
                        parameters: RouteParameters(data: ["chain": "3"]),
                        in: nil,
                        type: .modal
                    )
                }
                .buttonStyle(.bordered)
            }
            
            Spacer()
        }
        .padding()
    }
}

// MARK: - Mixed Types Demo
struct MixedTypesDemo: View {
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Mixed Navigation Types")
                .font(.headline)
            
            Text("Combine different navigation types")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            VStack(spacing: 12) {
                Button("Push → Sheet") {
                    navigationManager.navigate(
                        to: RouteID.pushA,
                        parameters: RouteParameters(data: ["next": "sheet"]),
                        in: nil,
                        type: .push
                    )
                }
                .buttonStyle(.borderedProminent)
                
                Button("Sheet → Full Screen") {
                    navigationManager.navigate(
                        to: RouteID.sheetDemo,
                        parameters: RouteParameters(data: ["next": "fullscreen"]),
                        in: nil,
                        type: .sheet
                    )
                }
                .buttonStyle(.bordered)
                
                Button("Modal → Push") {
                    navigationManager.navigate(
                        to: RouteID.modalDemo,
                        parameters: RouteParameters(data: ["next": "push"]),
                        in: nil,
                        type: .modal
                    )
                }
                .buttonStyle(.bordered)
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    NestedNavigationView()
        .environmentObject(NavigationManager(strategy: SwiftUINavigationStrategy()))
}
