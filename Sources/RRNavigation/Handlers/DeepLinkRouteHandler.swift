// MARK: - Deep Link Route Handler

import Foundation
import SwiftUI

/// Handler for deep link routes in the chain of responsibility
public class DeepLinkRouteHandler: BaseRouteRegistrationHandler {
    
    public override init() {
        super.init()
    }
    
    public override func canHandle(routeKey: any RouteKey) -> Bool {
        // Handle deep link routes
        return routeKey.key.hasPrefix("deeplink_")
    }
    
    @MainActor
    public override func registerRoute(for routeKey: any RouteKey, in manager: any NavigationManagerProtocol) -> Bool {
        // Check if current strategy supports deep link routes
        let supportedTypes: Set<NavigationType> = [.push, .sheet, .fullScreen, .modal]
        guard supportedTypes.contains(routeKey.presentationType) else {
            print("⚠️ DeepLinkRouteHandler: Strategy does not support \(routeKey.presentationType)")
            return false
        }
        
        switch routeKey.key {
        case "deeplink_product":
            let factory = AnySwiftUIViewFactory(ProductDeepLinkFactoryAdapter())
            manager.register(factory, for: routeKey)
            print("✅ DeepLinkRouteHandler: Registered ProductDeepLink for key: \(routeKey.key)")
            return true
            
        case "deeplink_category":
            let factory = AnySwiftUIViewFactory(CategoryDeepLinkFactoryAdapter())
            manager.register(factory, for: routeKey)
            print("✅ DeepLinkRouteHandler: Registered CategoryDeepLink for key: \(routeKey.key)")
            return true
            
        case "deeplink_user":
            let factory = AnySwiftUIViewFactory(UserDeepLinkFactoryAdapter())
            manager.register(factory, for: routeKey)
            print("✅ DeepLinkRouteHandler: Registered UserDeepLink for key: \(routeKey.key)")
            return true
            
        default:
            print("⚠️ DeepLinkRouteHandler: Unknown deep link route: \(routeKey.key)")
            return false
        }
    }
}

// MARK: - Deep Link Factories

private struct ProductDeepLinkFactory: SwiftUIViewFactory {
    typealias Output = AnyView
    
    func present(_ component: AnyView, with context: RouteContext) {
        print("🛍️ ProductDeepLinkFactory: Creating ProductDeepLink")
    }
    
    func presentView(_ view: AnyView, with context: RouteContext) {
        present(view, with: context)
    }
    
    func createView(with context: RouteContext) -> AnyView {
        let productId = context.parameters.data["productId"] ?? "unknown"
        let category = context.parameters.data["category"] ?? "general"
        
        return AnyView(ProductDeepLinkView(productId: productId, category: category))
    }
}

private struct CategoryDeepLinkFactory: SwiftUIViewFactory {
    typealias Output = AnyView
    
    func present(_ component: AnyView, with context: RouteContext) {
        print("📂 CategoryDeepLinkFactory: Creating CategoryDeepLink")
    }
    
    func presentView(_ view: AnyView, with context: RouteContext) {
        present(view, with: context)
    }
    
    func createView(with context: RouteContext) -> AnyView {
        let categoryId = context.parameters.data["categoryId"] ?? "unknown"
        let subcategory = context.parameters.data["subcategory"] ?? ""
        
        return AnyView(CategoryDeepLinkView(categoryId: categoryId, subcategory: subcategory))
    }
}

private struct UserDeepLinkFactory: SwiftUIViewFactory {
    typealias Output = AnyView
    
    func present(_ component: AnyView, with context: RouteContext) {
        print("👤 UserDeepLinkFactory: Creating UserDeepLink")
    }
    
    func presentView(_ view: AnyView, with context: RouteContext) {
        present(view, with: context)
    }
    
    func createView(with context: RouteContext) -> AnyView {
        let userId = context.parameters.data["userId"] ?? "unknown"
        let action = context.parameters.data["action"] ?? "view"
        
        return AnyView(UserDeepLinkView(userId: userId, action: action))
    }
}

// MARK: - Factory Adapters

private struct ProductDeepLinkFactoryAdapter: SwiftUIViewFactory {
    typealias Output = AnyView
    private let factory = ProductDeepLinkFactory()
    
    func present(_ component: AnyView, with context: RouteContext) {
        factory.present(component, with: context)
    }
    
    func presentView(_ view: AnyView, with context: RouteContext) {
        let actualView = factory.createView(with: context)
        present(actualView, with: context)
    }
}

private struct CategoryDeepLinkFactoryAdapter: SwiftUIViewFactory {
    typealias Output = AnyView
    private let factory = CategoryDeepLinkFactory()
    
    func present(_ component: AnyView, with context: RouteContext) {
        factory.present(component, with: context)
    }
    
    func presentView(_ view: AnyView, with context: RouteContext) {
        let actualView = factory.createView(with: context)
        present(actualView, with: context)
    }
}

private struct UserDeepLinkFactoryAdapter: SwiftUIViewFactory {
    typealias Output = AnyView
    private let factory = UserDeepLinkFactory()
    
    func present(_ component: AnyView, with context: RouteContext) {
        factory.present(component, with: context)
    }
    
    func presentView(_ view: AnyView, with context: RouteContext) {
        let actualView = factory.createView(with: context)
        present(actualView, with: context)
    }
}

// MARK: - Demo Deep Link Views

private struct ProductDeepLinkView: View {
    let productId: String
    let category: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "gift.fill")
                .font(.system(size: 60))
                .foregroundColor(.orange)
            
            Text("🛍️ Product Deep Link")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 12) {
                InfoRow(label: "Product ID", value: productId)
                InfoRow(label: "Category", value: category)
                InfoRow(label: "Source", value: "Deep Link")
                InfoRow(label: "Timestamp", value: Date().formatted())
            }
            .padding()
            .background(Color.orange.opacity(0.1))
            .cornerRadius(10)
            
            Text("This view was opened via a deep link!")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Product")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

private struct CategoryDeepLinkView: View {
    let categoryId: String
    let subcategory: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "folder.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            Text("📂 Category Deep Link")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 12) {
                InfoRow(label: "Category ID", value: categoryId)
                InfoRow(label: "Subcategory", value: subcategory.isEmpty ? "None" : subcategory)
                InfoRow(label: "Source", value: "Deep Link")
                InfoRow(label: "Timestamp", value: Date().formatted())
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(10)
            
            Text("Browse products in this category")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Category")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

private struct UserDeepLinkView: View {
    let userId: String
    let action: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.green)
            
            Text("👤 User Deep Link")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 12) {
                InfoRow(label: "User ID", value: userId)
                InfoRow(label: "Action", value: action)
                InfoRow(label: "Source", value: "Deep Link")
                InfoRow(label: "Timestamp", value: Date().formatted())
            }
            .padding()
            .background(Color.green.opacity(0.1))
            .cornerRadius(10)
            
            Text("Performing action: \(action)")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding()
        .navigationTitle("User")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

private struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label + ":")
                .fontWeight(.medium)
            
            Spacer()
            
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}
