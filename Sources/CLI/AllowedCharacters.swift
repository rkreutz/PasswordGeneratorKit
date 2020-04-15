import ArgumentParser
@testable import PasswordGenerator

public enum AllowedCharacters: String, CaseIterable, ExpressibleByArgument, CustomStringConvertible {

    case lowercase
    case uppercase
    case decimal
    case symbols

    public var description: String { rawValue }

    func asPasswordRule() -> PasswordRule {

        switch self {

            case .lowercase: return .mustContain(characterSet: String.lowercaseCharacters, atLeast: 1)
            case .uppercase: return .mustContain(characterSet: String.uppercaseCharacters, atLeast: 1)
            case .symbols: return .mustContain(characterSet: String.symbolCharacters, atLeast: 1)
            case .decimal: return .mustContain(characterSet: String.decimalCharacters, atLeast: 1)
        }
    }
}

extension Array: ExpressibleByArgument where Element == AllowedCharacters {

    public init?(argument: String) {

        guard let allowedCharacters = AllowedCharacters(argument: argument) else { return nil }
        self = [allowedCharacters]
    }
}
