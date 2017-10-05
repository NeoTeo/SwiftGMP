import PackageDescription

let package = Package(
    name: "SwiftGMP",
    dependencies: [
        .Package(url: "https://github.com/NeoTeo/GMPLib", majorVersion: 0)
    ]
)
