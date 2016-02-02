import Glibc

@noreturn func usage() {
    print("usage: \(Process.arguments[0]) <hostname> <port>")
    exit(1)
}

func runClient() throws {
    let args = Process.arguments
    guard args.count == 3 else {
        usage()
    }
    let hostname = args[1]
    guard let port = Int(args[2]) else {
        usage()
    }
    print("hostname: \(hostname), port: \(port)")

    try SSL.setup()

    // let host = Host(hostname: hostname, port: port)
    // try host.resolveForAddressType(.Version4)
    // print(host.officialHostname)
    // print(host.aliases)

    // IPAddress4.test()
    IPAddress6.test()
    // let connection = SSL.Connection(hostname: hostname, port: port)
    // try connection.open()
}

do {
    try runClient()
} catch(let error) {
    logError(error)
    exit(1)
}

exit(0)

// do {
//     // UUID.test()
//     // SHA256.test()
//     // Crypto.testRandom()
//     try Crypto.setup()
//     Crypto.testGenerateKeyPair()
// } catch(let error) {
//     logError(error)
// }
