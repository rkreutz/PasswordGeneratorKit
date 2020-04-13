import ArgumentParser
@testable import PasswordGenerator

class ServiceBased: ParsableCommand {

    @Option(name: .long, default: 1000, help: "The number of iterations to be used to generate a PBKDF2 key")
    var keyIterations: Int

    @Option(name: .long, default: 64, help: "The size in bytes of the PBKDF2 key")
    var keyLength: Int

    @Option(name: .shortAndLong, help: "The master password to be used")
    var masterPassword: String

    @Option(name: .shortAndLong, help: "The service to which this password generator is used for, e.g. a bank account")
    var service: String

    required init() { }

    func run() throws {

        print(
            """
            key-length: \(keyLength)
            key-iterations: \(keyIterations)
            service: \(service)
            """
        )

        print("\nGenerating password...\n")

        let passwordGenerator = GenericPasswordGenerator(
            masterPasswordProvider: masterPassword,
            entropyGenerator: PBKDF2BasedEntropyGenerator(iterations: keyIterations, bytes: keyLength)
        )

        let generatedPassword = try passwordGenerator.generatePassword(service: service, rules: PasswordRule.defaultRules)

        print("Generated password is:")
        print(generatedPassword)
    }
}
