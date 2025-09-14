// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RRNavigation",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "RRNavigation",
            targets: ["RRNavigation"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/rirp53021/rr-swift-foundation.git", from: "1.8.1"),
        .package(url: "https://github.com/rirp53021/rr-swift-persistence.git", from: "1.0.3"),
        .package(url: "https://github.com/apple/swift-testing.git", from: "0.99.0")
    ],
    targets: [
        .target(
            name: "RRNavigation",
            dependencies: [
                .product(name: "RRFoundation", package: "rr-swift-foundation"),
                .product(name: "RRPersistence", package: "rr-swift-persistence")
            ]
        ),
        .testTarget(
            name: "RRNavigationTests",
            dependencies: [
                "RRNavigation",
                .product(name: "Testing", package: "swift-testing")
            ]
        )
    ]
)
