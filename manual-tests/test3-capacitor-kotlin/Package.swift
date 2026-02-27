// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Test3CapacitorKotlin",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "Test3CapacitorKotlin",
            targets: ["CapacitorKotlinPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "8.0.0")
    ],
    targets: [
        .target(
            name: "CapacitorKotlinPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm")
            ],
            path: "ios/Sources/CapacitorKotlinPlugin"),
        .testTarget(
            name: "CapacitorKotlinPluginTests",
            dependencies: ["CapacitorKotlinPlugin"],
            path: "ios/Tests/CapacitorKotlinPluginTests")
    ]
)
