import SwiftUI
import RRNavigation

struct ContentView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var navigationCoordinator: NavigationCoordinator
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            NavigationTestView()
                .tabItem {
                    Image(systemName: "arrow.right.circle.fill")
                    Text("Navigation")
                }
                .tag(1)
            
            UIKitTestView()
                .tabItem {
                    Image(systemName: "iphone")
                    Text("UIKit")
                }
                .tag(2)
            
            NavigateBackDemoView()
                .tabItem {
                    Image(systemName: "arrow.left.circle.fill")
                    Text("Back Demo")
                }
                .tag(3)
            
            StrategyValidationView()
                .tabItem {
                    Image(systemName: "checkmark.shield")
                    Text("Strategy")
                }
                .tag(3)
            
            PathNavigationView()
                .tabItem {
                    Image(systemName: "map")
                    Text("Paths")
                }
                .tag(4)
            
            ModalDemoView()
                .tabItem {
                    Image(systemName: "rectangle.stack")
                    Text("Modals")
                }
                .tag(5)
            
            RouteRegistrationExample()
                .tabItem {
                    Image(systemName: "list.bullet.rectangle")
                    Text("Registration")
                }
                .tag(6)
        }
        .environmentObject(navigationManager)
        .overlay(
            NavigationPresenter(coordinator: navigationCoordinator)
        )
        .onAppear {
            // Set up the navigation coordinator with the strategy
            if let strategy = navigationManager.activeStrategy as? SwiftUINavigationStrategy {
                strategy.setNavigationCoordinator(navigationCoordinator)
            }
        }
    }
}

struct NavigationTestView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var presentedSheet: AnyView?
    @State private var isSheetPresented = false
    @State private var presentedModal: AnyView?
    @State private var isModalPresented = false
    @State private var isShowingProfile = false
    @State private var isShowingSettings = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Navigation Test")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                VStack(spacing: 16) {
                    // Strategy Validation Info
                    Group {
                        Text("Strategy Validation Active")
                            .font(.headline)
                            .padding(.top)
                        
                        Text("This app uses SwiftUI strategy - only SwiftUI views are registered successfully")
                            .font(.caption)
                            .foregroundColor(.blue)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    
                    // SwiftUI Navigation Tests
                    Group {
                        Text("SwiftUI Navigation")
                            .font(.headline)
                        
                        NavigationLink(destination: ProfileView(userId: "123", name: "John Doe"), isActive: $isShowingProfile) {
                            Button("Navigate to Profile (Push)") {
                                isShowingProfile = true
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        
                        Button("Show Settings (Sheet)") {
                            showSettingsSheet()
                        }
                        .buttonStyle(.bordered)
                        
                        Button("Show Profile (Modal)") {
                            showProfileModal()
                        }
                        .buttonStyle(.bordered)
                        
                        NavigationLink(destination: SettingsView(), isActive: $isShowingSettings) {
                            Button("Replace with Settings") {
                                isShowingSettings = true
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                    
                    Divider()
                    
                    // UIKit Navigation Tests
                    VStack {
                        Text("UIKit Navigation (Will Fail)")
                            .font(.headline)
                        
                        Text("UIKit factories are rejected by SwiftUI strategy - see console logs")
                            .font(.caption)
                            .foregroundColor(.orange)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Button("Navigate to Profile VC (Push)") {
                            navigationManager.navigate(
                                to: RouteID.profileVC,
                                parameters: RouteParameters(data: ["userId": "789", "name": "UIKit User"])
                            )
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Button("Show Settings VC (Sheet)") {
                            navigationManager.navigate(
                                to: RouteID.settingsVC,
                                parameters: RouteParameters(data: ["mode": "advanced"])
                            )
                        }
                        .buttonStyle(.bordered)
                    }
                    
                    Divider()
                    
                    // Navigation Controls
                    Group {
                        Text("Navigation Controls")
                            .font(.headline)
                        
                        HStack(spacing: 16) {
                            Button("Back") {
                                // Navigation back is handled by SwiftUI automatically
                            }
                            .buttonStyle(.bordered)
                            
                        Button("Root") {
                            isShowingProfile = false
                            isShowingSettings = false
                        }
                            .buttonStyle(.bordered)
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Navigation Demo")
        }
        .sheet(isPresented: $isSheetPresented) {
            if let sheet = presentedSheet {
                sheet
            }
        }
        .fullScreenCover(isPresented: $isModalPresented) {
            if let modal = presentedModal {
                modal
            }
        }
    }
    
    // MARK: - Navigation Methods
    
    private func showSettingsSheet() {
        presentedSheet = AnyView(SettingsView())
        isSheetPresented = true
    }
    
    private func showProfileModal() {
        presentedModal = AnyView(ProfileView(userId: "modal456", name: "Jane Smith"))
        isModalPresented = true
    }
}

struct UIKitTestView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var presentedViewController: UIViewController?
    @State private var isViewControllerPresented = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("UIKit Integration Test")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("This demonstrates how UIKit view controllers can be integrated with RRNavigation")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding()
            
            VStack(spacing: 16) {
                Button("Present Profile ViewController") {
                    presentProfileViewController()
                }
                .buttonStyle(.borderedProminent)
                
                Button("Present Settings ViewController") {
                    presentSettingsViewController()
                }
                .buttonStyle(.bordered)
            }
            
            Spacer()
        }
        .padding()
        .sheet(isPresented: $isViewControllerPresented) {
            if let viewController = presentedViewController {
                UIViewControllerRepresentableWrapper(viewController: viewController)
            }
        }
    }
    
    private func presentProfileViewController() {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .systemBackground
        let label = UILabel()
        label.text = "Profile VC - uikit123"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor)
        ])
        
        presentedViewController = viewController
        isViewControllerPresented = true
    }
    
    private func presentSettingsViewController() {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .systemBackground
        let label = UILabel()
        label.text = "Settings VC - demo"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor)
        ])
        
        presentedViewController = viewController
        isViewControllerPresented = true
    }
}

struct UIViewControllerRepresentableWrapper: UIViewControllerRepresentable {
    let viewController: UIViewController
    
    func makeUIViewController(context: Context) -> UIViewController {
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No updates needed
    }
}

#Preview {
    ContentView()
        .environmentObject(NavigationManager.shared)
}
