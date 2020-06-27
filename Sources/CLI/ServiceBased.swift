import ArgumentParser
@testable import PasswordGeneratorKit

struct ServiceBased: ParsableCommand {

    @Option(name: .shortAndLong, help: "The service to which this password generator is used for, e.g. a bank account")
    var service: String

    @OptionGroup()
    var options: PasswordGeneratorCLI.Options

    func run() throws {

        print(
            """
            key-length: \(options.keyLength)
            key-iterations: \(options.keyIterations)
            service: \(service)
            length: \(options.length)
            allowedCharacters: \(options.allowedCharacters)
            """
        )

        print("\nGenerating password...\n")

        let passwordGenerator = PasswordGenerator(
            masterPasswordProvider: options.masterPassword,
            iterations: options.keyIterations,
            bytes: options.keyLength
        )
        
        let generatedPassword = try passwordGenerator.generatePassword(
            service: service,
            rules: Set(options.allowedCharacters.map { $0.asPasswordRule() }).union([.length(options.length)])
        )

        print("Generated password is:")
        print(generatedPassword)
    }
}
