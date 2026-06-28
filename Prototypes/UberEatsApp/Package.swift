// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "UberEatsApp",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "UberEatsApp", targets: ["UberEatsApp"])
    ],
    dependencies: [
        .package(name: "iOSForgeKit", path: "../..")
    ],
    targets: [
        .target(
            name: "UberEatsApp",
            dependencies: [
                .product(name: "Core", package: "iOSForgeKit"),
                .product(name: "AppleClient", package: "iOSForgeKit"),
                .product(name: "ForgeUI", package: "iOSForgeKit"),
            ],
            path: "Sources/UberEatsApp"
        )
    ]
)
