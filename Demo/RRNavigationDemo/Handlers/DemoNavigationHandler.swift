//
//  DemoNavigationHandler.swift
//  RRNavigationDemo
//
//  Created by Ronald Ivan Ruiz Poveda on 27/09/25.
//

import SwiftUI
import RRNavigation

struct DemoNavigationHandler: NavigationHandler {
    func canNavigate(to route: RouteID) -> Bool {
        return [.profile, .settings, .editProfile, .about, .help].contains(route)
    }
    
    func getNavigation(to route: RouteID) -> NavigationStep? {
        switch route {
        case .profile:
            return NavigationStep(
                tab: .profile,
                type: .push,
                factory: ProfileViewFactory.self,
                params: route.parameters
            )
            
        case .settings:
            return NavigationStep(
                type: .push,
                factory: SettingsViewFactory.self,
                params: route.parameters
            )
            
        case .editProfile:
            return NavigationStep(
                tab: .profile,
                type: .fullScreen,
                factory: EditProfileViewFactory.self,
                params: route.parameters
            )
            
        case .about:
            return NavigationStep(
                type: .push,
                factory: AboutViewFactory.self,
                params: route.parameters
            )
            
        case .help:
            return NavigationStep(
                type: .push,
                factory: HelpViewFactory.self,
                params: route.parameters
            )
        default:
            return nil
        }
    }
}

// MARK: - View Factories

struct ProfileViewFactory: ViewFactory {
    @ViewBuilder static func createView(params: [String: Any]?) -> some View {
        ProfileView()
    }
}

struct SettingsViewFactory: ViewFactory {
    @ViewBuilder static func createView(params: [String: Any]?) -> some View {
        SettingsView()
    }
}

struct EditProfileViewFactory: ViewFactory {
    @ViewBuilder static func createView(params: [String: Any]?) -> some View {
        EditProfileView()
    }
}

struct AboutViewFactory: ViewFactory {
    @ViewBuilder static func createView(params: [String: Any]?) -> some View {
        AboutView()
    }
}

struct HelpViewFactory: ViewFactory {
    @ViewBuilder static func createView(params: [String: Any]?) -> some View {
        HelpView()
    }
}

