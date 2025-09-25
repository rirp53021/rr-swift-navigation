import SwiftUI
import RRNavigation

struct PathNavigationView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var navigationPath: [String] = []
    @State private var selectedRoute: String = ""
    
    private var headerView: some View {
        VStack(spacing: 8) {
            Text("Path-Based Navigation")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Demonstrates type-safe navigation using RouteKey definitions")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top)
    }
    
    private var currentPathView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Current Navigation Path")
                    .font(.headline)
                
                Spacer()
                
                if !navigationPath.isEmpty {
                    Text("\(navigationPath.count) steps")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            if navigationPath.isEmpty {
                HStack {
                    Image(systemName: "map")
                        .foregroundColor(.secondary)
                    Text("No navigation yet")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .italic()
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(Array(navigationPath.enumerated()), id: \.offset) { (index: Int, route: String) in
                        HStack {
                            ZStack {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 24, height: 24)
                                
                                Text("\(index + 1)")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            
                            Text(route)
                                .font(.body)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            if index < navigationPath.count - 1 {
                                Image(systemName: "arrow.down")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerView
                currentPathView
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    PathNavigationView()
        .environmentObject(NavigationManager.shared)
}