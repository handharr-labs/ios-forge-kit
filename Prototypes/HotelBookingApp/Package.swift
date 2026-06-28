// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "HotelBookingApp",
    platforms: [.iOS(.v16)],
    products: [.library(name: "HotelBookingApp", targets: ["HotelBookingApp"])],
    dependencies: [
        .package(name: "iOSForgeKit", path: "../..")
    ],
    targets: [
        .target(
            name: "HotelBookingApp",
            dependencies: [
                .product(name: "Core", package: "iOSForgeKit"),
                .product(name: "AppleClient", package: "iOSForgeKit"),
                .product(name: "ForgeUI", package: "iOSForgeKit"),
            ],
            path: "Sources/HotelBookingApp"
        )
    ]
)
