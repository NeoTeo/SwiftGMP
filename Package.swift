// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftGMP",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "SwiftGMP",
            targets: ["GMP", "SwiftGMP"]),
	//.executable(name: "GMP", targets: ["GMP"])
	//.library(
	//    name: "GMP",
        //    targets: ["GMP"]),
    ],
    dependencies: [
	//.package(url: "Sources/GMP/", .branch("master")),
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
	    name: "GMP",
	    dependencies: [],
	    sources: ["Sources/GMP"]
	),
	.target(
            name: "SwiftGMP",
            dependencies: ["GMP"]),
	//.target(
	//    name: "GMP",
	//    dependencies: []),
        .testTarget(
            name: "SwiftGMPTests",
            dependencies: ["SwiftGMP"]),
    ]
)
