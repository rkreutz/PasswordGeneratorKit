import ArgumentParser
@testable import PasswordGeneratorKit

struct SaltBased: ParsableCommand {

    @Option(name: .shortAndLong, help: "The salt to be used")
    var salt: String

    @OptionGroup()
    var options: PasswordGeneratorCLI.Options

    func run() throws {

        print(
            """
            key-length: \(options.keyLength)
            key-iterations: \(options.keyIterations)
            salt: \(salt)
            length: \(options.length)
            allowedCharacters: \(options.allowedCharacters)
            """
        )

        print("\nGenerating password...\n")

        let passwordGenerator = GenericPasswordGenerator(
            masterPasswordProvider: options.masterPassword,
            entropyGenerator: PBKDF2BasedEntropyGenerator(
                iterations: options.keyIterations,
                bytes: options.keyLength
            )
        )

        let generatedPassword = try passwordGenerator.generatePassword(
            salt: salt,
            rules: Set(options.allowedCharacters.map { $0.asPasswordRule() }).union([.length(options.length)])
        )

        print("Generated password is:")
        print(generatedPassword)
    }
}
