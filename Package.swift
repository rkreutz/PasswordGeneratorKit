// swift-tools-version:5.2

import PackageDescription

#if canImport(Combine)
let targets: [Target] = [
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
    .target(
        name: "PasswordGeneratorKitPublishers",
        dependencies: ["PasswordGeneratorKit"]
    ),
    .testTarget(
        name: "PasswordGeneratorKitTests",
        dependencies: ["PasswordGeneratorKit", "UIntX"]
    )
]
#else
let targets: [Target] = [
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
    .testTarget(
        name: "PasswordGeneratorKitTests",
        dependencies: ["PasswordGeneratorKit", "UIntX"]
    )
]
#endif

let package = Package(
    name: "PasswordGeneratorKit",
    products: [
        .library(
            name: "PasswordGeneratorKit",
            targets: ["PasswordGeneratorKit"]
        ),
        .library(
            name: "PasswordGeneratorKitPublishers",
            targets: ["PasswordGeneratorKitPublishers"]
        ),
        .executable(
            name: "password-generator",
            targets: ["CLI"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/rkreutz/UIntX", .upToNextMajor(from: "1.0.1")),
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "0.0.1"))
    ],
    targets: targets,
    swiftLanguageVersions: [.v5]
)
