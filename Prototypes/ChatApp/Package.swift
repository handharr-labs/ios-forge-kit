// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "ChatApp",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "ChatApp", targets: ["ChatApp"])
    ],
    dependencies: [
        .package(name: "iOSForgeKit", path: "../..")
    ],
    targets: [
        .target(
            name: "ChatApp",
            dependencies: [
                .product(name: "Core", package: "iOSForgeKit"),
                .product(name: "AppleClient", package: "iOSForgeKit"),
                .product(name: "ForgeUI", package: "iOSForgeKit"),
            ],
            path: "Sources/ChatApp",
            resources: [
                .process("Data/MockData")
            ]
        )
    ]
)
