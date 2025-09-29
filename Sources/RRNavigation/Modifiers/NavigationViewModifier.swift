//
//  NavigationViewModifier.swift
//  RRNavigation
//
//  Created by Ronald Ivan Ruiz Poveda on 27/09/25.
//

import SwiftUI
import RRUIComponents

/// ViewModifier for generating tabs using NavigationManager
public struct NavigationViewModifier: ViewModifier {
    @EnvironmentObject private var navigationManager: NavigationManager
    
    public init() {}
    
    public func body(content: Content) -> some View {
        mainContentView
            .sheet(isPresented: $navigationManager.isSheetShown) {
                navigationManager.sheetContent
            }
            .fullScreenCover(isPresented: $navigationManager.isFullScreenShown) {
                navigationManager.fullScreenContent
            }
    }
    
    var mainContentView: some View {
        MainContentView()
    }
    
}

// MARK: - Main Content View
struct MainContentView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    
    var body: some View {
        if let currentAppModuleID = navigationManager.currentAppModule,
           let currentAppModule = navigationManager.appModules.first(where: { $0.id == currentAppModuleID }) {
            switch currentAppModule.contentMode {
            case .contentOnly:
                // Show content-only view (like login)
                NavigationStack(path: $navigationManager.currentNavigationPath) {
                    AnyView(currentAppModule.rootView.createView(params: nil))
                        .navigationDestination(
                            for: RouteID.self,
                            destination: navigationManager.getRegisteredView
                        )
                }
            case .tabStructure:
                // Show tabbed navigation
                TabView(selection: $navigationManager.currentTab) {
                    ForEach(navigationManager.registeredTabs) { tab in
                        NavigationStack(path: $navigationManager.currentNavigationPath) {
                            navigationManager.getRootView(for: tab)
                                .navigationDestination(
                                    for: RouteID.self,
                                    destination: navigationManager.getRegisteredView
                                )
                        }
                        .tabItem {
                            if let icon = tab.icon {
                                icon
                            }
                            Text(tab.name)
                        }
                        .tag(tab.id)
                    }
                }
            }
        } else {
            // Fallback if no current app module
            Text("No App Module Selected")
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - View Extension
public extension View {
    /// Apply navigation tabs using NavigationManager
    /// - Parameters:
    ///   - navigationManager: The navigation manager to use
    ///   - tabs: The tabs to display
    /// - Returns: A view with navigation tabs
    func navigation() -> some View {
        self.modifier(NavigationViewModifier())
    }
}
