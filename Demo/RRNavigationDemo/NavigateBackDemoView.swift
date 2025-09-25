import SwiftUI
import RRNavigation

struct NavigateBackDemoView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var selectedNavigationType: NavigationType = .push
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Navigate Back Demo")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Test strategy-based navigation back behaviors")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Navigation Type:")
                    .font(.headline)
                
                Picker("Navigation Type", selection: $selectedNavigationType) {
                    Text("Push").tag(NavigationType.push)
                    Text("Sheet").tag(NavigationType.sheet)
                    Text("Full Screen").tag(NavigationType.fullScreen)
                    Text("Modal").tag(NavigationType.modal)
                    Text("Replace").tag(NavigationType.replace)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            VStack(spacing: 12) {
                Button("Navigate to Profile (Push)") {
                    navigationManager.navigate(to: RouteID.profile, type: .push)
                }
                .buttonStyle(.borderedProminent)
                
                Button("Show Settings (Sheet)") {
                    navigationManager.navigate(to: RouteID.settings, type: .sheet)
                }
                .buttonStyle(.bordered)
                
                Button("Show About (Full Screen)") {
                    navigationManager.navigate(to: RouteID.about, type: .fullScreen)
                }
                .buttonStyle(.bordered)
                
                Button("Show Profile (Modal)") {
                    navigationManager.navigate(to: RouteID.profile, type: .modal)
                }
                .buttonStyle(.bordered)
                
                Button("Replace with Settings") {
                    navigationManager.navigate(to: RouteID.settings, type: .replace)
                }
                .buttonStyle(.bordered)
            }
            
            Divider()
            
            VStack(spacing: 12) {
                Text("Back Navigation:")
                    .font(.headline)
                
                Button("Navigate Back (Smart)") {
                    navigationManager.navigateBack()
                }
                .buttonStyle(.borderedProminent)
                
                Button("Navigate Back (Strategy-based)") {
                    navigationManager.navigateBack()
                }
                .buttonStyle(.bordered)
                
                Button("Navigate to Root") {
                    navigationManager.navigateToRoot()
                }
                .buttonStyle(.bordered)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Back Navigation Demo")
        .navigationBarTitleDisplayMode(.inline)
    }
}
