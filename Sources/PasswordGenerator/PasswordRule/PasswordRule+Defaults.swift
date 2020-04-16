public extension PasswordRule {

    static let defaultLength = PasswordRule.length(16)
    
    static let defaultCharacterSet = Set<PasswordRule>([
        .mustContain(characterSet: .lowercaseCharacters, atLeast: 1),
        .mustContain(characterSet: .uppercaseCharacters, atLeast: 1),
        .mustContain(characterSet: .decimalCharacters, atLeast: 1),
        .mustContain(characterSet: .symbolCharacters, atLeast: 1)
    ])

    static let defaultRules = defaultCharacterSet.union([defaultLength])
}
