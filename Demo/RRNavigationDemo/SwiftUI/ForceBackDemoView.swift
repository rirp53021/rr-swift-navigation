import SwiftUI
import RRNavigation

struct ForceBackDemoView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var navigationPath: [String] = []
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Force Back Navigation Demo")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("This view demonstrates how to set up force back navigation with callbacks")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                VStack(spacing: 15) {
                    NavigationLink(destination: DetailView(navigationPath: $navigationPath)) {
                        Text("Push to Detail View")
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Custom Back Button") {
                        // This is how you would use the force back navigation
                        if let swiftUIStrategy = navigationManager.activeStrategy as? SwiftUINavigationStrategy {
                            swiftUIStrategy.forcePushNavigationBack()
                        }
                    }
                    .buttonStyle(.bordered)
                    .foregroundColor(.orange)
                    
                    Button("Navigate Back (Standard)") {
                        navigationManager.navigateBack()
                    }
                    .buttonStyle(.bordered)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Force Back Demo")
            .onAppear {
                setupForceBackCallback()
            }
        }
    }
    
    private func setupForceBackCallback() {
        // Set up the callback for force back navigation
        if let swiftUIStrategy = navigationManager.activeStrategy as? SwiftUINavigationStrategy {
            swiftUIStrategy.setForceBackNavigationCallback {
                // This callback will be called when forcePushNavigationBack() is invoked
                DispatchQueue.main.async {
                    if !navigationPath.isEmpty {
                        navigationPath.removeLast()
                    }
                }
            }
        }
    }
}

struct DetailView: View {
    @Binding var navigationPath: [String]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Detail View")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("This is a pushed view. Use the custom back button or standard navigation back.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            VStack(spacing: 15) {
                Button("Custom Back Button") {
                    // This demonstrates the force back navigation
                    if let navigationManager = EnvironmentObject<NavigationManager>().wrappedValue as? NavigationManager,
                       let swiftUIStrategy = navigationManager.activeStrategy as? SwiftUINavigationStrategy {
                        swiftUIStrategy.forcePushNavigationBack()
                    }
                }
                .buttonStyle(.bordered)
                .foregroundColor(.orange)
                
                Button("Standard Back") {
                    navigationPath.removeLast()
                }
                .buttonStyle(.borderedProminent)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ForceBackDemoView()
        .environmentObject(NavigationManager(strategy: SwiftUINavigationStrategy()))
}
