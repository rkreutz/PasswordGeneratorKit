final class GenericPasswordGenerator<Entropy: BinaryInteger> {

    let masterPasswordProvider: MasterPasswordProvider
    let entropyGenerator: AnyEntropyGenerator<Entropy>

    init<Generator: EntropyGenerator>(
        masterPasswordProvider: MasterPasswordProvider,
        entropyGenerator: Generator
    ) where Generator.Entropy == Entropy {

        self.masterPasswordProvider = masterPasswordProvider
        self.entropyGenerator = AnyEntropyGenerator(entropyGenerator)
    }

    func generatePassword(username: String, domain: String, seed: Int, rules: Set<PasswordRule>) throws -> String {

        try generatePassword(
            salt: """
            username: \(username),
            domain: \(domain),
            seed: \(seed)
            """,
            rules: rules
        )
    }

    func generatePassword(service: String, rules: Set<PasswordRule>) throws -> String {

        try generatePassword(salt: "service: \(service)", rules: rules)
    }

    func generatePassword(salt: String, rules: Set<PasswordRule>) throws -> String {

        guard case let .length(length) = rules.first(where: { $0.caseMatch(.length) }) else {

            throw PasswordGenerator.Error.mustSpecifyLength
        }

        guard rules.contains(where: { $0.caseMatch(.mustContain) }) else {

            throw PasswordGenerator.Error.mustSpecifyAtLeastOneCharacterSet
        }

        let masterPassword = masterPasswordProvider.masterPassword

        var entropy: Entropy
        do {

            entropy = try entropyGenerator.generateEntropy(with: salt, masterPassword: masterPassword)
        } catch {

            throw PasswordGenerator.Error.entropyGenerationError(error)
        }

        var generatedPassword = ""
        var allowedCharacters = ""
        var extraCharacters = ""
        var extraCount = 0
        for case let .mustContain(characterSet, count) in rules.sorted() {

            allowedCharacters += characterSet
            extraCount += count
            (extraCharacters, entropy) = entropy.consumeEntropy(
                generatedPassword: extraCharacters,
                characters: characterSet,
                maxLength: extraCount
            )
        }

        (generatedPassword, entropy) = entropy.consumeEntropy(
            generatedPassword: generatedPassword,
            characters: allowedCharacters,
            maxLength: length - extraCount
        )

        generatedPassword.insertStringRandomically(extraCharacters, entropy: entropy)

        return generatedPassword
    }
}
