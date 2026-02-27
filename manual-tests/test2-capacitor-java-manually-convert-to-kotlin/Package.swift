// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Test2CapacitorJavaManuallyConvertToKotlin",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "Test2CapacitorJavaManuallyConvertToKotlin",
            targets: ["CapacitorJavaToKotlinPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "8.0.0")
    ],
    targets: [
        .target(
            name: "CapacitorJavaToKotlinPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm")
            ],
            path: "ios/Sources/CapacitorJavaToKotlinPlugin"),
        .testTarget(
            name: "CapacitorJavaToKotlinPluginTests",
            dependencies: ["CapacitorJavaToKotlinPlugin"],
            path: "ios/Tests/CapacitorJavaToKotlinPluginTests")
    ]
)
