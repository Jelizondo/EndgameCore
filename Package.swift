// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EndgameCore",
    products: [
        .library(
            name: "EndgameCore",
            targets: ["EndgameCore"]),
    ],
    targets: [
        .target(
            name: "EndgameCore",
            dependencies: []),
        .testTarget(
            name: "EndgameCoreTests",
            dependencies: ["EndgameCore"]),
    ]
)
