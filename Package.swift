// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "DebugPanel",
    platforms: [.iOS(.v10)],
    products: [
        .library(name: "DebugPanel", targets: ["DebugPanel"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SnapKit/SnapKit.git", "5.0.0" ..< "6.0.0"),
    ],
    targets: [
        .target(
            name: "DebugPanel",
            dependencies: ["SnapKit"],
            path: "Source"
        )
    ],
    swiftLanguageVersions: [.v5]
)
