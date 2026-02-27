// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Test1CapacitorJava",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "Test1CapacitorJava",
            targets: ["CapacitorJavaPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "8.0.0")
    ],
    targets: [
        .target(
            name: "CapacitorJavaPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm")
            ],
            path: "ios/Sources/CapacitorJavaPlugin"),
        .testTarget(
            name: "CapacitorJavaPluginTests",
            dependencies: ["CapacitorJavaPlugin"],
            path: "ios/Tests/CapacitorJavaPluginTests")
    ]
)
