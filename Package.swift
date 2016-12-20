import PackageDescription

let package = Package(
    name: "SwiftGMP",
    dependencies: [
        .Package(url: "../GMPLib", majorVersion: 0)
    ]
)
