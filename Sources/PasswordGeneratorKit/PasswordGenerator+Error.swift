public extension PasswordGenerator {

    enum Error: Swift.Error {
        
        case entropyGenerationError(Swift.Error)
        case mustSpecifyLength
        case mustSpecifyAtLeastOneCharacterSet
        case failedToFetchMasterPassword(Swift.Error)
    }
}

