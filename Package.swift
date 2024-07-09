// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ACReview",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "ACReview",
            targets: ["ACReview"]),
    ],
    targets: [
        .target(
            name: "ACReview"
            )
    ]
)
