public extension PasswordRule {

    enum CharacterSet {
        public static let lowercase = String.lowercaseCharacters
        public static let uppercase = String.uppercaseCharacters
        public static let decimal = String.decimalCharacters
        public static let symbol = String.symbolCharacters
    }

    static let defaultLength = PasswordRule.length(16)
    
    static let defaultCharacterSet = Set<PasswordRule>([
        .mustContain(characterSet: .lowercaseCharacters, atLeast: 1),
        .mustContain(characterSet: .uppercaseCharacters, atLeast: 1),
        .mustContain(characterSet: .decimalCharacters, atLeast: 1),
        .mustContain(characterSet: .symbolCharacters, atLeast: 1)
    ])

    static func mustContainLowercaseCharacters(atLeast count: UInt) -> PasswordRule {

        .mustContain(characterSet: .lowercaseCharacters, atLeast: count)
    }

    static func mustContainUppercaseCharacters(atLeast count: UInt) -> PasswordRule {

        .mustContain(characterSet: .uppercaseCharacters, atLeast: count)
    }

    static func mustContainDecimalCharacters(atLeast count: UInt) -> PasswordRule {

        .mustContain(characterSet: .decimalCharacters, atLeast: count)
    }

    static func mustContainSymbolCharacters(atLeast count: UInt) -> PasswordRule {

        .mustContain(characterSet: .symbolCharacters, atLeast: count)
    }

    static let defaultRules = defaultCharacterSet.union([defaultLength])
}
