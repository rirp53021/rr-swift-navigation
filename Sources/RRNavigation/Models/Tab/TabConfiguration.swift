//
//  TabConfiguration.swift
//  RRNavigation
//
//  Created by Ronald Ivan Ruiz Poveda on 01/10/25.
//

import SwiftUI

// MARK: - Tab Style

/// Defines the visual style of the tab bar
public enum TabStyle {
    /// Native SwiftUI TabView
    case native
    /// Custom RRUIComponents tab bar
    case rrUIComponents
}

// MARK: - Tab Configuration

/// Configuration for tab bar appearance and behavior
public struct TabConfiguration {
    /// The visual style of the tab bar
    public let style: TabStyle
    
    public init(style: TabStyle = .native) {
        self.style = style
    }
    
    // MARK: - Convenience Presets
    
    /// Native SwiftUI tabs (default)
    public static let native = TabConfiguration(style: .native)
    
    /// RRUIComponents custom tabs
    public static let rrUIComponents = TabConfiguration(style: .rrUIComponents)
}

