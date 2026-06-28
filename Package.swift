// swift-tools-version: 6.0
import PackageDescription

// iOS Forge Kit — shared packages for handharr-labs iOS apps.
// Mirrors the web forge kit: Core (platform-agnostic) → AppleClient (platform/IO) → ForgeUI (design system).
let package = Package(
    name: "iOSForgeKit",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "Core", targets: ["Core"]),
        .library(name: "AppleClient", targets: ["AppleClient"]),
        .library(name: "ForgeUI", targets: ["ForgeUI"]),
    ],
    targets: [
        // Platform-agnostic architecture primitives — depends on nothing.
        .target(name: "Core", path: "Sources/Core"),

        // Apple-platform primitives (URLSession networking, image loading, persistence,
        // UIKit coordinator). Depends on Core.
        .target(
            name: "AppleClient",
            dependencies: ["Core"],
            path: "Sources/AppleClient"
        ),

        // Design system (single base tier — future ForgeUIBronze). No domain knowledge.
        .target(name: "ForgeUI", path: "Sources/ForgeUI"),

        .testTarget(name: "CoreTests", dependencies: ["Core"], path: "Tests/CoreTests"),
        .testTarget(name: "AppleClientTests", dependencies: ["AppleClient"], path: "Tests/AppleClientTests"),
        .testTarget(name: "ForgeUITests", dependencies: ["ForgeUI"], path: "Tests/ForgeUITests"),
    ]
)
