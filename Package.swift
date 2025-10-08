// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RRNavigation",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .tvOS(.v16),
        .watchOS(.v9),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "RRNavigation",
            type: .dynamic,
            targets: ["RRNavigation"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/rirp53021/rr-swift-foundation.git", from: "1.9.0"),
        .package(url: "https://github.com/rirp53021/rr-swift-persistence.git", from: "2.0.0"),
        .package(url: "https://github.com/rirp53021/rr-swift-ui-components.git", from: "2.2.4"),
        .package(url: "https://github.com/apple/swift-testing.git", from: "0.99.0")
    ],
    targets: [
        .target(
            name: "RRNavigation",
            dependencies: [
                .product(name: "RRFoundation", package: "rr-swift-foundation"),
                .product(name: "RRPersistence", package: "rr-swift-persistence"),
                .product(name: "RRUIComponents", package: "rr-swift-ui-components")
            ],
            path: "Sources/RRNavigation"
        ),
    ]
)