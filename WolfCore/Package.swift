import PackageDescription

let package = Package(
    name: "WolfCore",
    dependencies: [
        .Package(url: "https://github.com/PureSwift/CUUID.git", majorVersion: 1)
    ]
)
