import SwiftUI
import RRNavigation

// MARK: - New Settings Factory
struct NewSettingsViewFactory: ViewFactory {
    func createView(with context: RouteContext) -> ViewComponent {
        .swiftUI(AnyView(NewSettingsView()))
    }
}

// MARK: - New Home Factory
struct NewHomeViewFactory: ViewFactory {
    func createView(with context: RouteContext) -> ViewComponent {
        .swiftUI(AnyView(NewHomeView()))
    }
}

// MARK: - Nested Navigation Factory
struct NestedNavigationViewFactory: ViewFactory {
    func createView(with context: RouteContext) -> ViewComponent {
        .swiftUI(AnyView(NestedNavigationView()))
    }
}

// MARK: - Push Demo Factories
struct PushDemoViewFactory: ViewFactory {
    func createView(with context: RouteContext) -> ViewComponent {
        .swiftUI(AnyView(PushDemoView(parameters: context.parameters)))
    }
}

struct PushAViewFactory: ViewFactory {
    func createView(with context: RouteContext) -> ViewComponent {
        .swiftUI(AnyView(PushAView(parameters: context.parameters)))
    }
}

struct PushBViewFactory: ViewFactory {
    func createView(with context: RouteContext) -> ViewComponent {
        .swiftUI(AnyView(PushBView(parameters: context.parameters)))
    }
}

struct PushCViewFactory: ViewFactory {
    func createView(with context: RouteContext) -> ViewComponent {
        .swiftUI(AnyView(PushCView(parameters: context.parameters)))
    }
}

// MARK: - Sheet Demo Factory
struct SheetDemoViewFactory: ViewFactory {
    func createView(with context: RouteContext) -> ViewComponent {
        .swiftUI(AnyView(SheetDemoView(parameters: context.parameters)))
    }
}

// MARK: - Full Screen Demo Factory
struct FullScreenDemoViewFactory: ViewFactory {
    func createView(with context: RouteContext) -> ViewComponent {
        .swiftUI(AnyView(FullScreenDemoView(parameters: context.parameters)))
    }
}

// MARK: - Modal Demo Factory
struct ModalDemoViewFactory: ViewFactory {
    func createView(with context: RouteContext) -> ViewComponent {
        .swiftUI(AnyView(NewModalDemoView(parameters: context.parameters)))
    }
}

// MARK: - Replace Demo Factory
struct ReplaceDemoViewFactory: ViewFactory {
    func createView(with context: RouteContext) -> ViewComponent {
        .swiftUI(AnyView(ReplaceDemoView(parameters: context.parameters)))
    }
}

// MARK: - Tab Demo Factory
struct TabDemoViewFactory: ViewFactory {
    func createView(with context: RouteContext) -> ViewComponent {
        .swiftUI(AnyView(TabDemoView(parameters: context.parameters)))
    }
}
