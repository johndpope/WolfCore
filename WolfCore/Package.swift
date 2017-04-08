import PackageDescription

let package = Package(
    name: "WolfCore"
)

#if os(OSX)
package.dependencies.append(.Package(url: "https://github.com/venj/CommonCrypto.git", versions: Version(0,3,0) ..< Version(1,0,0)))
#endif

#if os(Linux)
package.dependencies.append(.Package(url: "https://github.com/Zewo/COpenSSL.git", majorVersion: 0, minor: 14))
#endif

//    dependencies: [
//        //.Package(url: "https://github.com/PureSwift/CUUID.git", majorVersion: 1),
//        //.Package(url: "https://github.com/Zewo/COpenSSL.git", majorVersion: 0, minor: 1),
//        //.Package(url: "https://github.com/AlwaysRightInstitute/CDispatch.git", majorVersion:0),
//    ]
