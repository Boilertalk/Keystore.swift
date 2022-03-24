// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Keystore",
    products: [
        .library(
            name: "Keystore",
            targets: ["Keystore"]),
    ],
    platforms: [
        .macOS(.v10_12),
    ],
    dependencies: [
        // Package dependencies
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", from: "1.0.0"),
        .package(url: "https://github.com/Boilertalk/secp256k1.swift.git", from: "0.1.1"),

        // Test dependencies
        .package(url: "https://github.com/Quick/Quick.git", from: "2.1.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "8.0.2")
    ],
    targets: [
        .target(
            name: "Keystore",
            dependencies: ["CryptoSwift", "secp256k1"],
            path: "Keystore/Classes",
            sources: ["."]),
        .testTarget(
            name: "KeystoreTests",
            dependencies: ["Keystore", "Quick", "Nimble"])
    ]
)
