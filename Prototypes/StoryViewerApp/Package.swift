// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "StoryViewerApp",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "StoryViewerApp", targets: ["StoryViewerApp"])
    ],
    dependencies: [
        .package(name: "iOSForgeKit", path: "../..")
    ],
    targets: [
        .target(
            name: "StoryViewerApp",
            dependencies: [
                .product(name: "Core", package: "iOSForgeKit"),
                .product(name: "AppleClient", package: "iOSForgeKit"),
            ],
            path: "Sources/StoryViewerApp",
            resources: [
                .process("Data/MockData")
            ]
        )
    ]
)
