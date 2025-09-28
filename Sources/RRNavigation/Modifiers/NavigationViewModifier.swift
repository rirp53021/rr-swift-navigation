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
    
    public func body(content: Content) -> some View {
        content
            .overlay(tabView)
            .sheet(isPresented: $navigationManager.isSheetShown) {
                navigationManager.sheetContent
            }
            .fullScreenCover(isPresented: $navigationManager.isFullScreenShown) {
                navigationManager.fullScreenContent
            }
    }
    
    var tabView: some View {
        TabView(selection: Binding(
            get: { navigationManager.currentTab },
            set: { setCurrentTab($0) }
        ), content: tabContent)
    }
    
    private func tabContent() -> some View {
        ForEach(navigationManager.tabs) { tab in
            NavigationStack(path: Binding(
                get: { navigationManager.tabNavigationPaths[tab.id] ?? NavigationPath() },
                set: { navigationManager.tabNavigationPaths[tab.id] = $0 }
            )) {
                tab.getRootView()
                    .navigationDestination(for: RouteID.self, destination: navigationManager.getRegisteredView)
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
    
    private func setCurrentTab(_ tabID: RRTabID?) {
        if let tabID = tabID {
            navigationManager.setCurrentTab(tabID)
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
