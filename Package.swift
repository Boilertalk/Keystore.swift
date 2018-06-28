// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Keystore",
    products: [
        .library(
            name: "Keystore",
            targets: ["Keystore"]),
    ],
    dependencies: [
        // Package dependencies
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", from: "0.8.0"),
        .package(url: "https://github.com/Boilertalk/secp256k1.swift.git", from: "0.1.1"),

        // Test dependencies
        .package(url: "https://github.com/Quick/Quick.git", from: "1.2.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "7.0.3")
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
