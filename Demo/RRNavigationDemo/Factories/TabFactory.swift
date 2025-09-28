//
//  TabFactory.swift
//  RRNavigationDemo
//
//  Created by Ronald Ivan Ruiz Poveda on 27/09/25.
//

import SwiftUI
import RRNavigation

struct HomeTabFactory: RRTabFactory {
    func create() -> RRTab {
        RRTab(
            id: .home,
            name: "Home",
            icon: Image(systemName: "house.fill"),
            rootRouteID: .home
        )
    }
}

struct ProfileTabFactory: RRTabFactory {
    func create() -> RRTab {
        RRTab(
            id: .profile,
            name: "Profile",
            icon: Image(systemName: "person.fill"),
            rootRouteID: .profile
        )
    }
}

struct SettingsTabFactory: RRTabFactory {
    func create() -> RRTab {
        RRTab(
            id: .settings,
            name: "Settings",
            icon: Image(systemName: "gear"),
            rootRouteID: .settings
        )
    }
}
