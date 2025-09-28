//
//  PublicNavigationHandler.swift
//  RRNavigation
//
//  Created by Ronald Ivan Ruiz Poveda on 28/09/25.
//

import SwiftUI
import RRNavigation

struct PublicNavigationHandler: NavigationHandler {
    func canNavigate(to route: RRNavigation.RouteID) -> Bool {
        [.login].contains(route)
    }
    
    func getNavigation(to route: RRNavigation.RouteID) -> RRNavigation.NavigationStep? {
        switch route {
        case .login: .init(type: .push, factory: LoginViewFactory.self)
        default: nil
        }
    }
}

struct LoginViewFactory: ViewFactory {
    @ViewBuilder static func createView(params: [String: Any]?) -> some View {
        LoginView()
    }
}
