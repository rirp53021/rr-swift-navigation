import SwiftUI
import RRNavigation

struct RouteRegistrationExample: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var registrationResults: [String: Bool] = [:]
    @State private var showResults = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 8) {
                    Text("Route Registration Examples")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Demonstrates different ways to handle route registration results")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top)
                
                // Basic Registration (ignores return value)
                VStack(alignment: .leading, spacing: 16) {
                    Text("Basic Registration")
                        .font(.headline)
                    
                    Text("This method ignores the return value but logs success/failure counts:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Button("Register Routes (Basic)") {
                        registerRoutesBasic()
                    }
                    .buttonStyle(.borderedProminent)
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
                
                // Detailed Registration (uses return values)
                VStack(alignment: .leading, spacing: 16) {
                    Text("Detailed Registration")
                        .font(.headline)
                    
                    Text("This method captures and displays individual registration results:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Button("Register Routes (Detailed)") {
                        registerRoutesDetailed()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    if showResults {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Registration Results:")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            ForEach(Array(registrationResults.keys.sorted()), id: \.self) { routeKey in
                                HStack {
                                    Text(routeKey)
                                        .font(.caption)
                                    Spacer()
                                    Image(systemName: registrationResults[routeKey] == true ? "checkmark.circle.fill" : "xmark.circle.fill")
                                        .foregroundColor(registrationResults[routeKey] == true ? .green : .red)
                                }
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.1))
                        )
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.green.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.green.opacity(0.2), lineWidth: 1)
                        )
                )
                
                // Code Examples
                VStack(alignment: .leading, spacing: 16) {
                    Text("Code Examples")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        CodeExample(
                            title: "Basic Registration (ignores return value)",
                            code: """
// This method logs success/failure counts internally
navigationManager.registerRoutes(
    AppRoutes.allRoutes, 
    using: chain
)
"""
                        )
                        
                        CodeExample(
                            title: "Detailed Registration (uses return values)",
                            code: """
// This method returns detailed results
let results = navigationManager.registerRoutesWithResults(
    AppRoutes.allRoutes, 
    using: chain
)

// Check individual results
for (key, success) in results {
    if success {
        print("✅ \\(key) registered successfully")
    } else {
        print("❌ \\(key) registration failed")
    }
}
"""
                        )
                        
                        CodeExample(
                            title: "Single Route Registration",
                            code: """
// Register a single route and handle the result
let success = navigationManager.registerRoute(
    AppRoutes.home, 
    using: chain
)

if success {
    print("Home route registered successfully")
} else {
    print("Home route registration failed")
}
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
        .navigationTitle("Registration Examples")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Registration Methods
    
    private func registerRoutesBasic() {
        // This method ignores individual return values but logs summary
        guard let chain = RouteRegistrationChainBuilder().build() else {
            print("Failed to build registration chain")
            return
        }
        
        navigationManager.registerRoutes(AppRoutes.allRoutes, using: chain)
    }
    
    private func registerRoutesDetailed() {
        // This method captures and uses individual return values
        guard let chain = RouteRegistrationChainBuilder().build() else {
            print("Failed to build registration chain")
            return
        }
        
        registrationResults = navigationManager.registerRoutesWithResults(AppRoutes.allRoutes, using: chain)
        showResults = true
    }
}

// MARK: - Supporting Views

struct CodeExample: View {
    let title: String
    let code: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
            
            Text(code)
                .font(.caption)
                .font(.system(.caption, design: .monospaced))
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black.opacity(0.05))
                )
        }
    }
}

#Preview {
    RouteRegistrationExample()
        .environmentObject(NavigationManager.shared)
}
