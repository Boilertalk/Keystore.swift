// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Keystore",
    platforms: [
       .iOS(.v13),
       .macOS(.v10_15),
       .watchOS(.v6),
       .tvOS(.v13),
       .macCatalyst(.v14),
       .driverKit(.v20),
    ],
    products: [
        .library(
            name: "Keystore",
            targets: ["Keystore"]),
    ],
    dependencies: [
        // Package dependencies
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", from: "1.8.1"),
        .package(url: "https://github.com/Boilertalk/secp256k1.swift.git", from: "0.1.7"),

        // Test dependencies
        .package(url: "https://github.com/Quick/Quick.git", from: "5.0.1"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "10.0.0")
    ],
    targets: [
        .target(
            name: "Keystore",
            dependencies: [
                .product(name: "CryptoSwift", package: "CryptoSwift"),
                .product(name: "secp256k1", package: "secp256k1.swift"),
            ],
            path: "Sources",
            sources: ["Keystore"]),
        .testTarget(
            name: "KeystoreTests",
            dependencies: [
                .target(name: "Keystore"),
                .product(name: "Quick", package: "Quick"),
                .product(name: "Nimble", package: "Nimble"),
            ],
            resources: [.copy("Stubs")])
    ]
)
