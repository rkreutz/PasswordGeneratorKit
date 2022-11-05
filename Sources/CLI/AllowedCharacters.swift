import ArgumentParser
import PasswordGeneratorKit

public enum AllowedCharacters: String, EnumerableFlag {

    case lowercase
    case uppercase
    case decimal
    case symbols

    func asPasswordRule() -> PasswordRule {

        switch self {

        case .lowercase:
            return .mustContain(characterSet: PasswordRule.CharacterSet.lowercase, atLeast: 1)

        case .uppercase:
            return .mustContain(characterSet: PasswordRule.CharacterSet.uppercase, atLeast: 1)

        case .symbols:
            return .mustContain(characterSet: PasswordRule.CharacterSet.symbol, atLeast: 1)
            
        case .decimal:
            return .mustContain(characterSet: PasswordRule.CharacterSet.decimal, atLeast: 1)
        }
    }
}
