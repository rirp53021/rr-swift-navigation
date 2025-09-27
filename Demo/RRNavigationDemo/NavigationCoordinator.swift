import SwiftUI
import RRNavigation

/// Hashable wrapper for AnyView to work with NavigationPath
struct HashableView: Hashable {
    let id: String
    let view: AnyView
    
    init(_ view: AnyView, routeKey: String) {
        self.view = view
        // Create unique identifier with timestamp to ensure each push is unique
        self.id = "\(routeKey)_\(Date().timeIntervalSince1970)_\(UUID().uuidString.prefix(8))"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: HashableView, rhs: HashableView) -> Bool {
        lhs.id == rhs.id
    }
}

/// Navigation coordinator that bridges the navigation manager with SwiftUI views
@MainActor
class NavigationCoordinator: ObservableObject, SwiftUINavigationCoordinator {
    @Published var presentedSheet: AnyView?
    @Published var isSheetPresented = false
    @Published var presentedFullScreen: AnyView?
    @Published var isFullScreenPresented = false
    @Published var presentedModal: AnyView?
    @Published var isModalPresented = false
    
    // Push navigation support (iOS 16+)
    @Published var navigationPaths: [Int: NavigationPath] = [:]
    @Published var pushDestination: AnyView?
    
    private let navigationManager: any NavigationManagerProtocol
    
    init(navigationManager: any NavigationManagerProtocol) {
        self.navigationManager = navigationManager
    }
    
    func presentSheet(_ view: AnyView) {
        print("🎯 NavigationCoordinator: presentSheet called with view: \(type(of: view))")
        presentedSheet = view
        isSheetPresented = true
        print("🎯 NavigationCoordinator: isSheetPresented = \(isSheetPresented)")
    }
    
    func presentFullScreen(_ view: AnyView) {
        presentedFullScreen = view
        isFullScreenPresented = true
    }
    
    func presentModal(_ view: AnyView) {
        presentedModal = view
        isModalPresented = true
    }
    
    func pushView(_ view: AnyView, routeKey: String, in tab: Int = 0) {
        print("🎯 NavigationCoordinator: pushView called with view: \(type(of: view)) routeKey: \(routeKey) in tab: \(tab)")
        pushDestination = view
        
        if navigationPaths[tab] == nil {
            navigationPaths[tab] = NavigationPath()
        }
        
        // Clear the path first to ensure clean navigation
        navigationPaths[tab] = NavigationPath()
        
        let hashableView = HashableView(view, routeKey: routeKey)
        navigationPaths[tab]?.append(hashableView)
        print("🎯 NavigationCoordinator: navigationPath count for tab \(tab) = \(navigationPaths[tab]?.count ?? 0)")
    }
    
    func getNavigationPath(for tab: Int) -> Binding<NavigationPath> {
        if navigationPaths[tab] == nil {
            navigationPaths[tab] = NavigationPath()
        }
        return Binding(
            get: { self.navigationPaths[tab] ?? NavigationPath() },
            set: { self.navigationPaths[tab] = $0 }
        )
    }
    
    func dismissSheet() {
        isSheetPresented = false
        presentedSheet = nil
    }
    
    func dismissFullScreen() {
        isFullScreenPresented = false
        presentedFullScreen = nil
    }
    
    func dismissModal() {
        isModalPresented = false
        presentedModal = nil
    }
    
    func dismissAll() {
        dismissSheet()
        dismissFullScreen()
        dismissModal()
    }
}

/// SwiftUI view that handles navigation presentation
struct NavigationPresenter: View {
    @ObservedObject var coordinator: NavigationCoordinator
    
    var body: some View {
        Color.clear
            .sheet(isPresented: $coordinator.isSheetPresented) {
                if let sheet = coordinator.presentedSheet {
                    sheet
                        .environmentObject(coordinator)
                }
            }
            .fullScreenCover(isPresented: $coordinator.isFullScreenPresented) {
                if let fullScreen = coordinator.presentedFullScreen {
                    fullScreen
                        .environmentObject(coordinator)
                }
            }
    }
}
