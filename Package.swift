// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "PasswordGenerator",
    products: [
        .library(
            name: "PasswordGenerator",
            targets: ["PasswordGenerator"]
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
    targets: [
        .target(
            name: "PasswordGenerator",
            dependencies: ["CryptoSwift", "UIntX"]
        ),
        .target(
            name: "CLI",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "PasswordGenerator"
            ]
        ),
        .testTarget(
            name: "PasswordGeneratorTests",
            dependencies: ["PasswordGenerator", "UIntX"]
        ),
    ]
)
