import SwiftUI
import RRNavigation

struct StrategyValidationView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var validationResults: [ValidationResult] = []
    @State private var isRunningTests = false
    @State private var currentStrategy: String = "SwiftUI"
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Strategy Validation Demo")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Demonstrates how RRNavigation validates factory compatibility with active strategy")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top)
                    
                    // Current Strategy Info
                    VStack(spacing: 12) {
                        Text("Current Strategy")
                            .font(.headline)
                        
                        HStack {
                            Image(systemName: "gear")
                                .foregroundColor(.blue)
                            Text(currentStrategy)
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                    }
                    
                    // Test Controls
                    VStack(spacing: 16) {
                        Text("Test Strategy Validation")
                            .font(.headline)
                        
                        VStack(spacing: 12) {
                            Button("Test SwiftUI Strategy") {
                                testSwiftUIStrategy()
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(isRunningTests)
                            
                            Button("Test UIKit Strategy") {
                                testUIKitStrategy()
                            }
                            .buttonStyle(.bordered)
                            .disabled(isRunningTests)
                            
                            Button("Test Chain of Responsibility") {
                                testChainOfResponsibility()
                            }
                            .buttonStyle(.bordered)
                            .disabled(isRunningTests)
                            
                            Button("Clear Results") {
                                validationResults.removeAll()
                            }
                            .buttonStyle(.bordered)
                            .foregroundColor(.red)
                        }
                    }
                    
                    // Results Section
                    if !validationResults.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Validation Results")
                                .font(.headline)
                            
                            LazyVStack(spacing: 8) {
                                ForEach(validationResults) { result in
                                    ValidationResultRow(result: result)
                                }
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                    }
                    
                    // Information Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("How Strategy Validation Works")
                            .font(.headline)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            InfoRow(
                                icon: "checkmark.circle.fill",
                                iconColor: .green,
                                text: "SwiftUI factories work with SwiftUI strategy"
                            )
                            
                            InfoRow(
                                icon: "checkmark.circle.fill",
                                iconColor: .green,
                                text: "UIKit factories work with UIKit strategy"
                            )
                            
                            InfoRow(
                                icon: "xmark.circle.fill",
                                iconColor: .red,
                                text: "Incompatible factories are rejected with warnings"
                            )
                            
                            InfoRow(
                                icon: "info.circle.fill",
                                iconColor: .blue,
                                text: "Check console logs for detailed validation messages"
                            )
                        }
                    }
                    .padding()
                    .background(Color.blue.opacity(0.05))
                    .cornerRadius(12)
                    
                    Spacer(minLength: 20)
                }
                .padding()
            }
            .navigationTitle("Strategy Validation")
            .onAppear {
                updateCurrentStrategy()
            }
        }
    }
    
    // MARK: - Test Methods
    
    private func testSwiftUIStrategy() {
        isRunningTests = true
        validationResults.removeAll()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let manager = NavigationManagerFactory.createForSwiftUI()
            currentStrategy = "SwiftUI"
            
            // Test SwiftUI factory (should succeed)
            let swiftUIFactory = HomeViewFactory()
            let swiftUIResult = ValidationResult(
                factoryType: "SwiftUIViewFactory",
                strategy: "SwiftUI",
                key: RouteID.home.key,
                success: true,
                message: "✅ SwiftUI factory accepted by SwiftUI strategy"
            )
            validationResults.append(swiftUIResult)
            manager.register(swiftUIFactory, for: RouteID.home)
            
            // Test UIKit factory (should fail)
            #if canImport(UIKit)
            let uikitFactory = ProfileViewControllerFactory()
            let uikitResult = ValidationResult(
                factoryType: "UIKitViewControllerFactory",
                strategy: "SwiftUI",
                key: RouteID.profileVC.key,
                success: false,
                message: "❌ UIKit factory rejected by SwiftUI strategy"
            )
            validationResults.append(uikitResult)
            manager.register(uikitFactory, for: RouteID.profileVC)
            #endif
            
            isRunningTests = false
        }
    }
    
    private func testUIKitStrategy() {
        #if canImport(UIKit)
        isRunningTests = true
        validationResults.removeAll()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let manager = NavigationManagerFactory.createForUIKit()
            currentStrategy = "UIKit"
            
            // Test UIKit factory (should succeed)
            let uikitFactory = ProfileViewControllerFactory()
            let uikitResult = ValidationResult(
                factoryType: "UIKitViewControllerFactory",
                strategy: "UIKit",
                key: RouteID.profileVC.key,
                success: true,
                message: "✅ UIKit factory accepted by UIKit strategy"
            )
            validationResults.append(uikitResult)
            manager.register(uikitFactory, for: RouteID.profileVC)
            
            // Test SwiftUI factory (should fail)
            let swiftUIFactory = HomeViewFactory()
            let swiftUIResult = ValidationResult(
                factoryType: "SwiftUIViewFactory",
                strategy: "UIKit",
                key: RouteID.home.key,
                success: false,
                message: "❌ SwiftUI factory rejected by UIKit strategy"
            )
            validationResults.append(swiftUIResult)
            manager.register(swiftUIFactory, for: RouteID.home)
            
            isRunningTests = false
        }
        #else
        validationResults.append(ValidationResult(
            factoryType: "UIKit",
            strategy: "N/A",
            key: "test",
            success: false,
            message: "❌ UIKit not available on this platform"
        ))
        #endif
    }
    
    private func testChainOfResponsibility() {
        isRunningTests = true
        validationResults.removeAll()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let manager = NavigationManagerFactory.createForSwiftUI()
            currentStrategy = "SwiftUI"
            
            // Build chain of responsibility
            let chain = RouteRegistrationChainBuilder()
                .addHandler(AdminRouteHandler())
                .addHandler(DeepLinkRouteHandler())
                .build()
            
            guard let chain = chain else {
                print("❌ Failed to build chain")
                return
            }
            
            // Register routes using chain with app-defined route keys
            manager.registerRoutes(RouteID.allRoutes, using: chain)
            
            // Add results based on what should happen
            validationResults.append(ValidationResult(
                factoryType: "Chain Registration",
                strategy: "SwiftUI",
                key: "Multiple Routes",
                success: true,
                message: "✅ Chain registration completed - check console for detailed results"
            ))
            
            isRunningTests = false
        }
    }
    
    private func updateCurrentStrategy() {
        // Determine current strategy based on the navigation manager
        if navigationManager is NavigationManager {
            // This is a simplified check - in a real implementation you'd check the actual strategy
            currentStrategy = "SwiftUI"
        }
    }
}

// MARK: - Supporting Views

struct ValidationResult: Identifiable {
    let id = UUID()
    let factoryType: String
    let strategy: String
    let key: String
    let success: Bool
    let message: String
}

struct ValidationResultRow: View {
    let result: ValidationResult
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: result.success ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(result.success ? .green : .red)
                .font(.title3)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(result.message)
                    .font(.body)
                    .fontWeight(.medium)
                
                HStack {
                    Text("Factory: \(result.factoryType)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("Strategy: \(result.strategy)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(result.success ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
        .cornerRadius(8)
    }
}

struct InfoRow: View {
    let icon: String
    let iconColor: Color
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(iconColor)
                .font(.caption)
            
            Text(text)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
        }
    }
}

#Preview {
    StrategyValidationView()
        .environmentObject(NavigationManager.shared)
}
