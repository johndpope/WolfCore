do {
    // UUID.test()
    // SHA256.test()
    // Crypto.testRandom()
    try Crypto.setup()
    Crypto.testGenerateKeyPair()
} catch(let error) {
    logError(error)
}
