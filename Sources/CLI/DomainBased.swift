import ArgumentParser
import Foundation
@testable import PasswordGeneratorKit

struct DomainBased: ParsableCommand {

    @Option(name: .shortAndLong, help: "The username to which this password generator is used for, e.g. an email")
    var username: String

    @Option(name: .shortAndLong, help: "The domain to which this password generator is used for, e.g. a website")
    var domain: String

    @Option(name: .shortAndLong, default: 1, help: "The seed to be used")
    var seed: Int

    @OptionGroup()
    var options: PasswordGeneratorCLI.Options

    func run() throws {

        print(
            """
            key-length: \(options.keyLength)
            key-iterations: \(options.keyIterations)
            username: \(username)
            domain: \(domain)
            seed: \(seed)
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
            username: username,
            domain: domain,
            seed: seed,
            rules: Set(options.allowedCharacters.map { $0.asPasswordRule() }).union([.length(options.length)])
        )

        print("Generated password is:")
        print(generatedPassword)
    }
}
