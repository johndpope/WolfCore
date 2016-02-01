import PackageDescription

let package = Package(
    name: "WolfCore",
    dependencies: [
        .Package(url: "https://github.com/PureSwift/CUUID.git", majorVersion: 1),
        .Package(url: "https://github.com/Zewo/COpenSSL.git", majorVersion: 0, minor: 1),
        //.Package(url: "https://github.com/AlwaysRightInstitute/CDispatch.git", majorVersion:0),
    ]
)
