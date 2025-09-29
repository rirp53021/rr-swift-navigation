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
            ContentModeView(appModule: currentAppModule)
        } else {
            FallbackView()
        }
    }
}

// MARK: - Content Mode View
struct ContentModeView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    let appModule: AppModule
    
    var body: some View {
        switch appModule.contentMode {
        case .contentOnly:
            ContentOnlyView(rootView: appModule.rootView)
        case .tabStructure:
            TabStructureView()
        }
    }
}

// MARK: - Content Only View
struct ContentOnlyView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    let rootView: any ViewFactory.Type
    
    var body: some View {
        NavigationStack(path: $navigationManager.currentNavigationPath) {
            AnyView(rootView.createView(params: nil))
                .navigationDestination(
                    for: RouteID.self,
                    destination: navigationManager.getRegisteredView
                )
        }
    }
}

// MARK: - Tab Structure View
struct TabStructureView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    
    var body: some View {
        TabView(selection: $navigationManager.currentTab) {
            ForEach(navigationManager.registeredTabs) { tab in
                TabContentView(tab: tab)
            }
        }
    }
}

// MARK: - Tab Content View
struct TabContentView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    let tab: RRTab
    
    var body: some View {
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

// MARK: - Fallback View
struct FallbackView: View {
    var body: some View {
        Text("No App Module Selected")
            .foregroundColor(.secondary)
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
