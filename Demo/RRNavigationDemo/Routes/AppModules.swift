//
//  AppModules.swift
//  RRNavigation
//
//  Created by Ronald Ivan Ruiz Poveda on 28/09/25.
//

import RRNavigation

extension AppModuleID {
    static var notAuthenticated: Self {
        .init("notAuthenticated")
    }
    
    static var authenticated: Self {
        .init("authenticated")
    }
}

extension AppModule {
    static var notAuthenticated: Self {
        .init(id: .notAuthenticated, rootView: LoginViewFactory.self, contentMode: .contentOnly)
    }
    
    static var authenticated: Self {
        .init(id: .authenticated, rootView: HomeViewFactory.self, contentMode: .tabStructure)
    }
}
