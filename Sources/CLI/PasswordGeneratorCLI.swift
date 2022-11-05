import ArgumentParser

struct PasswordGeneratorCLI: ParsableCommand {

    struct Options: ParsableArguments {

        @Option(name: .long, default: .pbkdf2, help: "The entropy source to be used")
        var entropySource: EntropyGenerator

        @Option(name: .shortAndLong, default: 1_000, help: "The number of iterations to be used by the entropy source")
        var iterations: UInt

        @Option(name: .shortAndLong, default: 16_384, help: "The memory cost in kilobytes to be used by Argon2 entropy source. Ignored if using PBKDF2")
        var memory: UInt

        @Option(name: .shortAndLong, default: 1, help: "The number of threads to be used by Argon2 entropy source. Ignored if using PBKDF2")
        var threads: UInt

        @Option(name: .long, default: 64, help: "The size in bytes of the generated entropy")
        var entropy: UInt
        
        @Option(name: [.long, .customShort("p")], help: "The master password to be used")
        var masterPassword: String
        
        @Option(name: .shortAndLong, default: 16, help: "The length in characters of the generated password")
        var length: UInt

        //swiftlint:disable:next line_length
        @Flag(help: "The charactes that must be used in the generated password, at least one must be specified. Any combinations of the flags may be specified and this will be defined as having at least one character of that character set")
        var allowedCharacters: [AllowedCharacters]

        @Flag(name: .shortAndLong, help: "Prints extra info in the terminal")
        var verbose: Bool
    }

    static var configuration: CommandConfiguration {
        CommandConfiguration(
            commandName: "password-generator",
            abstract: "Deterministic password generator.",
            discussion: "A password generator which will detereministically generate random passwords. Will always generate the same passwords given the same input.",
            version: "4.1.0",
            subcommands: [SaltBased.self, ServiceBased.self, DomainBased.self]
        )
    }
}
