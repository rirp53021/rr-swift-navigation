//
//  AppHandler.swift
//  RRNavigation
//
//  Created by Ronald Ivan Ruiz Poveda on 28/09/25.
//

public struct AppModuleID: Hashable {
    public var rawValue: String
    
    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}

public enum AppRootContentMode {
    case contentOnly
    case tabStructure
}

public struct AppModule: Hashable {
    public var id: AppModuleID
    var rootView: any ViewFactory.Type
    var contentMode: AppRootContentMode
    
    public init(id: AppModuleID, rootView: any ViewFactory.Type, contentMode: AppRootContentMode) {
        self.id = id
        self.rootView = rootView
        self.contentMode = contentMode
    }
    
    public static func == (lhs: AppModule, rhs: AppModule) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id.rawValue)
    }
}
