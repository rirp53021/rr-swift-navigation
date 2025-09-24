// Copyright (c) 2024 Ronald Ruiz
// Licensed under the MIT License

import Foundation
import os.log

/// Simple logger implementation for RRNavigation
public class Logger {
    public static let shared = Logger()
    
    private let osLog = OSLog(subsystem: "com.rrnavigation.core", category: "RRNavigation")
    
    private init() {}
    
    public func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        let fileName = URL(fileURLWithPath: file).lastPathComponent
        let logMessage = "[DEBUG] \(fileName):\(line) \(function) - \(message)"
        os_log("%{public}@", log: osLog, type: .debug, logMessage)
    }
    
    public func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        let fileName = URL(fileURLWithPath: file).lastPathComponent
        let logMessage = "[INFO] \(fileName):\(line) \(function) - \(message)"
        os_log("%{public}@", log: osLog, type: .info, logMessage)
    }
    
    public func warning(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        let fileName = URL(fileURLWithPath: file).lastPathComponent
        let logMessage = "[WARNING] \(fileName):\(line) \(function) - \(message)"
        os_log("%{public}@", log: osLog, type: .default, logMessage)
    }
    
    public func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        let fileName = URL(fileURLWithPath: file).lastPathComponent
        let logMessage = "[ERROR] \(fileName):\(line) \(function) - \(message)"
        os_log("%{public}@", log: osLog, type: .error, logMessage)
    }
}
