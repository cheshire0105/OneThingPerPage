// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OneThingPerPage",
    platforms: [
        .iOS(.v13)  // SwiftUI 최소 지원 버전: iOS 13 이상
    ], products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "OneThingPerPage",
            targets: ["OneThingPerPage"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "OneThingPerPage"),

    ]
)
