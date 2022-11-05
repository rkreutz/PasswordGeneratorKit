import ArgumentParser
import PasswordGeneratorKit

struct ServiceBased: ParsableCommand {

    @Option(name: .shortAndLong, help: "The service to which this password generator is used for, e.g. a bank account")
    var service: String

    @OptionGroup()
    var options: PasswordGeneratorCLI.Options

    func run() throws {

        let passwordGenerator: PasswordGenerator
        switch options.entropySource {
        case .pbkdf2:
            passwordGenerator = PasswordGenerator(
                masterPasswordProvider: options.masterPassword,
                entropyGenerator: .pbkdf2(iterations: options.iterations),
                bytes: options.entropy
            )

            if options.verbose {
                print(
                    """
                    entropy-source: pbkdf2
                        - iterations: \(options.iterations)
                    entropy: \(options.entropy) B
                    """
                )
            }

        case .argon2:
            passwordGenerator = PasswordGenerator(
                masterPasswordProvider: options.masterPassword,
                entropyGenerator: .argon2(
                    iterations: options.iterations,
                    memory: options.memory,
                    threads: options.threads
                ),
                bytes: options.entropy
            )
            if options.verbose {
                print(
                """
                entropy-source: argon2
                    - iterations: \(options.iterations)
                    - memory: \(options.memory) kB
                    - threads: \(options.threads)
                entropy: \(options.entropy) B
                """
                )
            }
        }

        if options.verbose {
            print(
                """
                service: \(service)
                length: \(options.length)
                allowed-characters: \(options.allowedCharacters.map(\.rawValue).joined(separator: ","))
                """
            )

            print("\nGenerating password...\n")
        }
        
        let generatedPassword = try passwordGenerator.generatePassword(
            service: service,
            rules: Set(options.allowedCharacters.map { $0.asPasswordRule() }).union([.length(options.length)])
        )

        if options.verbose {
            print("Generated password is:")
        }
        
        print(generatedPassword)
    }
}
