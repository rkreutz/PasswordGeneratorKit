// swift-tools-version:5.2

import PackageDescription

var platforms: [SupportedPlatform]?

var products: [Product] = [
    .library(
        name: "PasswordGeneratorKit",
        targets: ["PasswordGeneratorKit"]
    ),
    .executable(
        name: "password-generator",
        targets: ["CLI"]
    )
]

var targets: [Target] = [
    .target(
        name: "PasswordGeneratorKit",
        dependencies: ["CryptoSwift", "UIntX", "Argon2Kit"]
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

#if canImport(Combine)

platforms = [
    .iOS(.v13),
    .macOS(.v10_15),
    .tvOS(.v13),
    .watchOS(.v6)
]

products.append(
    .library(
        name: "PasswordGeneratorKitPublishers",
        targets: ["PasswordGeneratorKitPublishers"]
    )
)

targets.append(
    .target(
        name: "PasswordGeneratorKitPublishers",
        dependencies: ["PasswordGeneratorKit"]
    )
)

#endif

let package = Package(
    name: "PasswordGeneratorKit",
    platforms: platforms,
    products: products,
    dependencies: [
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/rkreutz/UIntX", .upToNextMajor(from: "3.0.0")),
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "0.0.1")),
        .package(url: "https://github.com/rkreutz/Argon2Kit", .upToNextMajor(from: "0.1.1"))
    ],
    targets: targets,
    swiftLanguageVersions: [.v5]
)
