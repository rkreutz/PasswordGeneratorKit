public extension PasswordRule {

    static let defaultLength = PasswordRule.length(16)
    
    static let defaultCharacterSet = Set<PasswordRule>([
        .mustContain(characterSet: .lowercaseCharacters, atLeast: 1),
        .mustContain(characterSet: .uppercaseCharacters, atLeast: 1),
        .mustContain(characterSet: .decimalCharacters, atLeast: 1),
        .mustContain(characterSet: .symbolCharacters, atLeast: 1)
    ])

    static func mustContainLowercaseCharacters(atLeast count: Int) -> PasswordRule {

        .mustContain(characterSet: .lowercaseCharacters, atLeast: count)
    }

    static func mustContainUppercaseCharacters(atLeast count: Int) -> PasswordRule {

        .mustContain(characterSet: .uppercaseCharacters, atLeast: count)
    }

    static func mustContainDecimalCharacters(atLeast count: Int) -> PasswordRule {

        .mustContain(characterSet: .decimalCharacters, atLeast: count)
    }

    static func mustContainSymbolCharacters(atLeast count: Int) -> PasswordRule {

        .mustContain(characterSet: .symbolCharacters, atLeast: count)
    }

    static let defaultRules = defaultCharacterSet.union([defaultLength])
}
