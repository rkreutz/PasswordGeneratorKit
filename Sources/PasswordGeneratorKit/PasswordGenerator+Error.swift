import Foundation

public extension PasswordGenerator {

    enum Error: LocalizedError {
        
        case entropyGenerationError(Swift.Error)
        case mustSpecifyLength
        case mustSpecifyAtLeastOneCharacterSet
        case failedToFetchMasterPassword(Swift.Error)

        public var errorDescription: String? {
            switch self {
            case .entropyGenerationError(let error):
                return "Failed to generate entropy with: \(error.localizedDescription)"
            case .mustSpecifyLength:
                return "Password length must be specified"
            case .mustSpecifyAtLeastOneCharacterSet:
                return "Must specify at least one character set"
            case .failedToFetchMasterPassword(let error):
                return "Failed to fetch master password with: \(error.localizedDescription)"
            }
        }

        public var failureReason: String? {
            switch self {
            case .entropyGenerationError(let error):
                return error.localizedDescription
            case .mustSpecifyLength:
                return "Password length was not specified"
            case .mustSpecifyAtLeastOneCharacterSet:
                return "No character set was specified"
            case .failedToFetchMasterPassword(let error):
                return error.localizedDescription
            }
        }

        public var recoverySuggestion: String? {
            switch self {
            case .entropyGenerationError, .failedToFetchMasterPassword:
                return nil
            case .mustSpecifyLength:
                return "Specify password length"
            case .mustSpecifyAtLeastOneCharacterSet:
                return "Specify a character set to be used"
            }
        }
    }
}

