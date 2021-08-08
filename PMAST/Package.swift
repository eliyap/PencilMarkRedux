// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PMAST",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "PMAST",
            targets: ["PMAST"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/apple/swift-collections", from: "0.0.4"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "PMAST",
            dependencies: [
                .product(name: "OrderedCollections", package: "swift-collections"),
            ],
            exclude: [
                /// Virtual Environment Folders
                "Javascript/env",
                "Javascript/venv",
                /// TypeScript Source
                "Javascript/src",
                /// Node Library
                "Javascript/node_modules",
                /// Build Settings
                "Javascript/tsconfig.json",
                "Javascript/package.json",
                "Javascript/package-lock.json",
                "Javascript/webpack.config.js",
            ],
            resources: [
                .copy("Javascript/dist/main.js"),
            ]
        ),
        .testTarget(
            name: "PMASTTests",
            dependencies: [
                "PMAST",
                .product(name: "OrderedCollections", package: "swift-collections"),
            ],
            exclude: [
            ]
        ),
    ]
)
