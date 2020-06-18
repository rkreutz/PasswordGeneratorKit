// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "PasswordGeneratorKit",
    products: [
        .library(
            name: "PasswordGeneratorKit",
            targets: ["PasswordGeneratorKit"]
        ),
        .executable(
            name: "password-generator",
            targets: ["CLI"]
        ),
        #if !os(Linux)
        .library(
            name: "PasswordGeneratorKitPublishers",
            targets: ["PasswordGeneratorKitPublishers"]
        )
        #endif
    ],
    dependencies: [
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/rkreutz/UIntX", .upToNextMajor(from: "1.0.1")),
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "0.0.1"))
    ],
    targets: [
        .target(
            name: "PasswordGeneratorKit",
            dependencies: ["CryptoSwift", "UIntX"]
        ),
        .target(
            name: "CLI",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "PasswordGeneratorKit"
            ]
        ),
        #if !os(Linux)
        .target(
            name: "PasswordGeneratorKitPublishers",
            dependencies: ["PasswordGeneratorKit"]
        ),
        #endif
        .testTarget(
            name: "PasswordGeneratorKitTests",
            dependencies: ["PasswordGeneratorKit", "UIntX"]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
