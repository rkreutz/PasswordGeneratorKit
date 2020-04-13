import UIntX

public final class PasswordGenerator {

    private let passwordGenerator: GenericPasswordGenerator<UIntX8>

    public init(masterPasswordProvider: MasterPasswordProvider) {

        self.passwordGenerator = GenericPasswordGenerator<UIntX8>(
            masterPasswordProvider: masterPasswordProvider,
            entropyGenerator: PBKDF2BasedEntropyGenerator()
        )
    }

    public func generatePassword(username: String, domain: String, seed: Int, rules: Set<PasswordRule>) throws -> String {

        try passwordGenerator.generatePassword(username: username, domain: domain, seed: seed, rules: rules)
    }

    public func generatePassword(service: String, rules: Set<PasswordRule>) throws -> String {

        try passwordGenerator.generatePassword(service: service, rules: rules)
    }

    public func generatePassword(salt: String, rules: Set<PasswordRule>) throws -> String {

        try passwordGenerator.generatePassword(salt: salt, rules: rules)
    }
}
