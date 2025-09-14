// Copyright (c) 2024 Ronald Ruiz
// Licensed under the MIT License

import Foundation
import SwiftUI
import Combine
@_exported import RRFoundation
@_exported import RRPersistence

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
