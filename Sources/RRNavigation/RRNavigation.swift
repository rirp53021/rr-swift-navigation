// Copyright (c) 2024 Ronald Ruiz
// Licensed under the MIT License

import Foundation
import SwiftUI
import Combine

// Self-contained framework - no external dependencies

/// Main module for RRNavigation
/// 
/// A cross-UI navigation framework for iOS that works with SwiftUI and UIKit.
/// Provides centralized navigation management with strategy pattern implementation.
/// 
/// ## Features
/// - **Cross-UI Support**: Works with both SwiftUI and UIKit
/// - **Strategy Pattern**: Clean separation between UI implementations
/// - **Centralized Management**: Single source of truth for navigation state
/// - **Type Safety**: Protocol-based factories with type erasure
/// - **Persistence**: Optional state persistence and restoration
/// - **Deep Linking**: Query string parameter encoding/decoding
/// - **Testing**: Built-in test utilities and mock strategies
/// - **Chain of Responsibility**: Organized route registration with dedicated handlers
/// - **Dedicated Factories**: One factory per view for clear organization
/// - **Route Keys**: Type-safe route identifiers

// MARK: - Public API Exports
// All public types are automatically exported by the module
