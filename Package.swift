// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "AuroraWeather",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(name: "AuroraWeather", targets: ["AuroraWeather"])
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.15.0"),
        .package(url: "https://github.com/apple/swift-algorithms", from: "1.2.0")
    ],
    targets: [
        .target(
            name: "AuroraWeather",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "Algorithms", package: "swift-algorithms")
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "AuroraWeatherTests",
            dependencies: ["AuroraWeather"],
            path: "Tests"
        )
    ]
)
