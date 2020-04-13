import ArgumentParser
@testable import PasswordGenerator

class SaltBased: ParsableCommand {

    @Option(name: .long, default: 1000, help: "The number of iterations to be used to generate a PBKDF2 key")
    var keyIterations: Int

    @Option(name: .long, default: 64, help: "The size in bytes of the PBKDF2 key")
    var keyLength: Int

    @Option(name: .shortAndLong, help: "The master password to be used")
    var masterPassword: String

    @Option(name: .shortAndLong, help: "The salt to be used")
    var salt: String

    required init() { }

    func run() throws {

        print(
            """
            key-length: \(keyLength)
            key-iterations: \(keyIterations)
            salt: \(salt)
            """
        )

        print("\nGenerating password...\n")

        let passwordGenerator = GenericPasswordGenerator(
            masterPasswordProvider: masterPassword,
            entropyGenerator: PBKDF2BasedEntropyGenerator(iterations: keyIterations, bytes: keyLength)
        )

        let generatedPassword = try passwordGenerator.generatePassword(salt: salt, rules: PasswordRule.defaultRules)

        print("Generated password is:")
        print(generatedPassword)
    }
}
