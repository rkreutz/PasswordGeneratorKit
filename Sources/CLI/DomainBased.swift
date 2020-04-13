import ArgumentParser
import Foundation
@testable import PasswordGenerator

class DomainBased: ParsableCommand {

    @Option(name: .long, default: 1000, help: "The number of iterations to be used to generate a PBKDF2 key")
    var keyIterations: Int

    @Option(name: .long, default: 64, help: "The size in bytes of the PBKDF2 key")
    var keyLength: Int

    @Option(name: .shortAndLong, help: "The master password to be used")
    var masterPassword: String

    @Option(name: .shortAndLong, help: "The username to which this password generator is used for, e.g. an email")
    var username: String

    @Option(name: .shortAndLong, help: "The domain to which this password generator is used for, e.g. a website")
    var domain: String

    @Option(name: .shortAndLong, default: 1, help: "The seed to be used")
    var seed: Int

    required init() { }

    func run() throws {

        print(
            """
            key-length: \(keyLength)
            key-iterations: \(keyIterations)
            username: \(username)
            domain: \(domain)
            seed: \(seed)
            """
        )

        print("\nGenerating password...\n")

        let passwordGenerator = GenericPasswordGenerator(
            masterPasswordProvider: masterPassword,
            entropyGenerator: PBKDF2BasedEntropyGenerator(iterations: keyIterations, bytes: keyLength)
        )

        let generatedPassword = try passwordGenerator.generatePassword(
            username: username,
            domain: domain,
            seed: seed,
            rules: PasswordRule.defaultRules
        )

        print("Generated password is:")
        print(generatedPassword)
    }
}
