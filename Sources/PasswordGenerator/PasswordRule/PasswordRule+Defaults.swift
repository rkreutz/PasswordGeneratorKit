extension PasswordRule {

    public static let defaultLength = PasswordRule.length(16)
    
    public static let defaultCharacterSet = Set<PasswordRule>([
        .mustContain(characterSet: .lowercaseCharacters, atLeast: 1),
        .mustContain(characterSet: .uppercaseCharacters, atLeast: 1),
        .mustContain(characterSet: .decimalCharacters, atLeast: 1),
        .mustContain(characterSet: .symbolCharacters, atLeast: 1)
    ])

    public static let defaultRules = defaultCharacterSet.union([defaultLength])
}
