// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "PasswordGenerator",
    products: [
        .library(
            name: "PasswordGenerator",
            targets: ["PasswordGenerator"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/rkreutz/UIntX", .upToNextMajor(from: "1.0.1"))
    ],
    targets: [
        .target(
            name: "PasswordGenerator",
            dependencies: ["CryptoSwift", "UIntX"]
        ),
        .testTarget(
            name: "PasswordGeneratorTests",
            dependencies: ["PasswordGenerator", "UIntX"]
        ),
    ]
)
