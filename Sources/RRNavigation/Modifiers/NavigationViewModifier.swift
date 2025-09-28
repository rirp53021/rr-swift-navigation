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
        ZStack {
            content
                .sheet(isPresented: $navigationManager.isSheetShown) {
                    navigationManager.sheetContent
                }
                .fullScreenCover(isPresented: $navigationManager.isFullScreenShown) {
                    navigationManager.fullScreenContent
                }
            
            if let currentAppModuleID = navigationManager.currentAppModule,
               let currentAppModule = navigationManager.appModules.first(where: {$0.id == currentAppModuleID }) {
                let currenctAppRootModule = AnyView(currentAppModule.rootView.createView(params: nil))
                
                switch currentAppModule.contentMode {
                case .contentOnly:
                    NavigationStack(path: $navigationManager.currentNavigationPath) {
                        currenctAppRootModule
                    }
                case .tabStructure:
                    currenctAppRootModule
                        .overlay(tabView)
                }
            }
        }
    }
    
    var tabView: some View {
        TabView(selection: $navigationManager.currentTab, content: tabContent)
    }
    
    private func tabContent() -> some View {
        ForEach(navigationManager.registeredTabs) { tab in
            NavigationStack(path: Binding(
                get: { navigationManager.tabNavigationPaths[tab.id] ?? NavigationPath() },
                set: { navigationManager.tabNavigationPaths[tab.id] = $0 }
            )) {
                tabRootView(tab)
            }
            .tabItem { tabItem(tab) }
            .tag(tab.id)
        }
    }
    
    @ViewBuilder
    private func tabRootView(_ tab: RRTab) -> some View {
        navigationManager.getRootView(for: tab)
            .navigationDestination(
                for: RouteID.self,
                destination: navigationManager.getRegisteredView
            )
    }
    
    @ViewBuilder
    private func tabItem(_ tab: RRTab) -> some View {
        if let icon = tab.icon {
            icon
        }
        Text(tab.name)
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
