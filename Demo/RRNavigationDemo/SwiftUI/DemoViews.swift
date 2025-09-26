import SwiftUI
import RRNavigation

// MARK: - Push Demo Views
struct PushDemoView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    let parameters: RouteParameters
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Push Navigation Demo")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("This view was pushed onto the navigation stack")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            if let source = parameters.data["source"] {
                Text("Source: \(source)")
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .clipShape(Capsule())
            }
            
            VStack(spacing: 12) {
                Button("Push Another View") {
                    navigationManager.navigate(
                        to: RouteID.pushA,
                        parameters: RouteParameters(data: ["source": "pushDemo"]),
                        in: nil,
                        type: .push
                    )
                }
                .buttonStyle(.borderedProminent)
                
                Button("Show Sheet") {
                    navigationManager.navigate(
                        to: RouteID.sheetDemo,
                        parameters: RouteParameters(data: ["source": "pushDemo"]),
                        in: nil,
                        type: .sheet
                    )
                }
                .buttonStyle(.bordered)
                
                Button("Go Back") {
                    navigationManager.navigateBack()
                }
                .buttonStyle(.bordered)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Push Demo")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PushAView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    let parameters: RouteParameters
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Push A View")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("This is view A in the push stack")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            if let depth = parameters.data["depth"] {
                Text("Depth: \(depth)")
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.1))
                    .foregroundColor(.green)
                    .clipShape(Capsule())
            }
            
            VStack(spacing: 12) {
                Button("Push View B") {
                    navigationManager.navigate(
                        to: RouteID.pushB,
                        parameters: RouteParameters(data: ["source": "pushA"]),
                        in: nil,
                        type: .push
                    )
                }
                .buttonStyle(.borderedProminent)
                
                Button("Go Back") {
                    navigationManager.navigateBack()
                }
                .buttonStyle(.bordered)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Push A")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PushBView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    let parameters: RouteParameters
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Push B View")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("This is view B in the push stack")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            VStack(spacing: 12) {
                Button("Push View C") {
                    navigationManager.navigate(
                        to: RouteID.pushC,
                        parameters: RouteParameters(data: ["source": "pushB"]),
                        in: nil,
                        type: .push
                    )
                }
                .buttonStyle(.borderedProminent)
                
                Button("Go Back") {
                    navigationManager.navigateBack()
                }
                .buttonStyle(.bordered)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Push B")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PushCView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    let parameters: RouteParameters
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Push C View")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("This is the final view in the push stack")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            VStack(spacing: 12) {
                Button("Go Back") {
                    navigationManager.navigateBack()
                }
                .buttonStyle(.borderedProminent)
                
                Button("Go to Root") {
                    navigationManager.navigateToRoot(in: nil)
                }
                .buttonStyle(.bordered)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Push C")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Sheet Demo View
struct SheetDemoView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    let parameters: RouteParameters
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Sheet Demo")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("This view is presented as a sheet")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            if let source = parameters.data["source"] {
                Text("Source: \(source)")
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.1))
                    .foregroundColor(.green)
                    .clipShape(Capsule())
            }
            
            VStack(spacing: 12) {
                Button("Show Another Sheet") {
                    navigationManager.navigate(
                        to: RouteID.fullScreenDemo,
                        parameters: RouteParameters(data: ["source": "sheetDemo"]),
                        in: nil,
                        type: .fullScreen
                    )
                }
                .buttonStyle(.borderedProminent)
                
                Button("Dismiss Sheet") {
                    navigationManager.navigateBack()
                }
                .buttonStyle(.bordered)
            }
            
            Spacer()
        }
        .padding()
    }
}

// MARK: - Full Screen Demo View
struct FullScreenDemoView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    let parameters: RouteParameters
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Full Screen Demo")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("This view is presented full screen")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            if let source = parameters.data["source"] {
                Text("Source: \(source)")
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color.orange.opacity(0.1))
                    .foregroundColor(.orange)
                    .clipShape(Capsule())
            }
            
            VStack(spacing: 12) {
                Button("Show Modal") {
                    navigationManager.navigate(
                        to: RouteID.modalDemo,
                        parameters: RouteParameters(data: ["source": "fullScreenDemo"]),
                        in: nil,
                        type: .modal
                    )
                }
                .buttonStyle(.borderedProminent)
                
                Button("Dismiss Full Screen") {
                    navigationManager.navigateBack()
                }
                .buttonStyle(.bordered)
            }
            
            Spacer()
        }
        .padding()
    }
}

// MARK: - Modal Demo View
struct NewModalDemoView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    let parameters: RouteParameters
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Modal Demo")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("This view is presented as a modal")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            if let source = parameters.data["source"] {
                Text("Source: \(source)")
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color.purple.opacity(0.1))
                    .foregroundColor(.purple)
                    .clipShape(Capsule())
            }
            
            VStack(spacing: 12) {
                Button("Dismiss Modal") {
                    navigationManager.navigateBack()
                }
                .buttonStyle(.borderedProminent)
                
                Button("Go to Home") {
                    navigationManager.navigate(
                        to: RouteID.newHome,
                        parameters: RouteParameters(),
                        in: nil,
                        type: nil
                    )
                }
                .buttonStyle(.bordered)
            }
            
            Spacer()
        }
        .padding()
    }
}

// MARK: - Replace Demo View
struct ReplaceDemoView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    let parameters: RouteParameters
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Replace Demo")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("This view replaced the previous one")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            if let source = parameters.data["source"] {
                Text("Source: \(source)")
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color.red.opacity(0.1))
                    .foregroundColor(.red)
                    .clipShape(Capsule())
            }
            
            VStack(spacing: 12) {
                Button("Go Back") {
                    navigationManager.navigateBack()
                }
                .buttonStyle(.borderedProminent)
                
                Button("Go to Home") {
                    navigationManager.navigate(
                        to: RouteID.newHome,
                        parameters: RouteParameters(),
                        in: nil,
                        type: nil
                    )
                }
                .buttonStyle(.bordered)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Replace Demo")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Tab Demo View
struct TabDemoView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    let parameters: RouteParameters
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Tab Demo")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("This view is in a different tab")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            if let source = parameters.data["source"] {
                Text("Source: \(source)")
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color.indigo.opacity(0.1))
                    .foregroundColor(.indigo)
                    .clipShape(Capsule())
            }
            
            VStack(spacing: 12) {
                Button("Go Back") {
                    navigationManager.navigateBack()
                }
                .buttonStyle(.borderedProminent)
                
                Button("Switch to Home Tab") {
                    navigationManager.navigate(
                        to: RouteID.newHome,
                        parameters: RouteParameters(),
                        in: "main",
                        type: .tab
                    )
                }
                .buttonStyle(.bordered)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Tab Demo")
        .navigationBarTitleDisplayMode(.inline)
    }
}
