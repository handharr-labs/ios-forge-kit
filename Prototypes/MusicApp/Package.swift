// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "MusicApp",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "MusicApp", targets: ["MusicApp"])
    ],
    dependencies: [
        .package(name: "iOSForgeKit", path: "../..")
    ],
    targets: [
        .target(
            name: "MusicApp",
            dependencies: [
                .product(name: "Core", package: "iOSForgeKit"),
                .product(name: "AppleClient", package: "iOSForgeKit"),
                .product(name: "ForgeUI", package: "iOSForgeKit"),
            ],
            path: "Sources/MusicApp"
        )
    ]
)
