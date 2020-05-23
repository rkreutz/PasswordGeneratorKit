import UIntX

public final class PasswordGenerator {

    private let passwordGenerator: GenericPasswordGenerator<UIntX8>

    public init(masterPasswordProvider: MasterPasswordProvider,
                iterations: Int = 1_000,
                bytes: Int = 64) {

        self.passwordGenerator = GenericPasswordGenerator<UIntX8>(
            masterPasswordProvider: masterPasswordProvider,
            entropyGenerator: PBKDF2BasedEntropyGenerator(iterations: iterations, bytes: bytes)
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
