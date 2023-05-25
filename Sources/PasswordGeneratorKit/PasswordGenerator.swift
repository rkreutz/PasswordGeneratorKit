import UIntX

public final class PasswordGenerator {

    public enum EntropyGenerator {
        case pbkdf2(iterations: UInt = 1_000)
        case argon2(iterations: UInt = 3, memory: UInt = 16_384, threads: UInt = 1)
    }

    private let passwordGenerator: GenericPasswordGenerator<UIntX64>

    public init(masterPasswordProvider: MasterPasswordProvider,
                entropyGenerator: EntropyGenerator = .pbkdf2(),
                bytes: UInt = 64) {

        switch entropyGenerator {
        case let .pbkdf2(iterations):
            self.passwordGenerator = GenericPasswordGenerator<UIntX64>(
                masterPasswordProvider: masterPasswordProvider,
                entropyGenerator: PBKDF2BasedEntropyGenerator(iterations: iterations, bytes: bytes)
            )

        case let .argon2(iterations, memory, threads):
            self.passwordGenerator = GenericPasswordGenerator<UIntX64>(
                masterPasswordProvider: masterPasswordProvider,
                entropyGenerator: Argon2BasedEntropyGenerator(
                    iterations: iterations,
                    memory: memory,
                    threads: threads,
                    bytes: bytes
                )
            )
        }
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

    public func profilePasswordGeneration(
        iterations: Int = 5,
        passwordLengths: [UInt] = [4, 8, 16, 32]
    ) throws -> PasswordGenerationProfilingResult {

        try passwordGenerator.profilePasswordGeneration(iterations: iterations, passwordLengths: passwordLengths)
    }
}
