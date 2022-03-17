// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ffmpeg",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "ffmpeg",
            targets: ["ffmpeg"]),
    ],
    dependencies: [
        "ffmpegkit", "libavdevice", "libavfilter", "libswscale", "libavutil", "libavformat", "libavcodec", "libswresample"
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "ffmpeg",
            dependencies: []),
        .binaryTarget(
            name: "ffmpegkit",
            path: "Frameworks/ffmpegkit.xcframework"),
        .binaryTarget(
            name: "libavdevice",
            path: "Frameworks/libavdevice.xcframework"),
        .binaryTarget(
            name: "libavfilter",
            path: "Frameworks/libavfilter.xcframework"),
        .binaryTarget(
            name: "libswscale",
            path: "Frameworks/libswscale.xcframework"),
        .binaryTarget(
            name: "libavutil",
            path: "Frameworks/libavutil.xcframework"),
        .binaryTarget(
            name: "libavformat",
            path: "Frameworks/libavformat.xcframework"),
        .binaryTarget(
            name: "libavcodec",
            path: "Frameworks/libavcodec.xcframework"),
        .binaryTarget(
            name: "libswresample",
            path: "Frameworks/libswresample.xcframework"),
        .testTarget(
            name: "ffmpegTests",
            dependencies: ["ffmpeg"]),
    ]
)
