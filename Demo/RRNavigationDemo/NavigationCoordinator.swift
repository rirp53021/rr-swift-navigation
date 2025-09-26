import SwiftUI
import RRNavigation

/// Navigation coordinator that bridges the navigation manager with SwiftUI views
@MainActor
class NavigationCoordinator: ObservableObject, SwiftUINavigationCoordinator {
    @Published var presentedSheet: AnyView?
    @Published var isSheetPresented = false
    @Published var presentedFullScreen: AnyView?
    @Published var isFullScreenPresented = false
    @Published var presentedModal: AnyView?
    @Published var isModalPresented = false
    
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
