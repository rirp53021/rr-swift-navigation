//
//  LoginView.swift
//  RRNavigation
//
//  Created by Ronald Ivan Ruiz Poveda on 28/09/25.
//

import SwiftUI
import RRNavigation

struct LoginView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        Text("Login View")
        
        Button("Logged in") {
            navigationManager.setAppModule(.authenticated)
        }
    }
}
