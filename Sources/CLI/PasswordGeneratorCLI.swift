import ArgumentParser

struct PasswordGeneratorCLI: ParsableCommand {

    struct Options: ParsableArguments {

        @Option(name: .long, default: 1_000, help: "The number of iterations to be used to generate a PBKDF2 key")
        var keyIterations: Int

        @Option(name: .long, default: 64, help: "The size in bytes of the PBKDF2 key")
        var keyLength: Int
        
        @Option(name: .shortAndLong, help: "The master password to be used")
        var masterPassword: String
        
        @Option(name: .shortAndLong, default: 16, help: "The length in characters of the generated password")
        var length: Int

        //swiftlint:disable:next line_length
        @Flag(help: "The charactes that must be used in the generated password, at least one must be specified. Any combinations of the flags may be specified and this will be defined as having at least one character of that character set")
        var allowedCharacters: [AllowedCharacters]
    }

    static var configuration: CommandConfiguration {

        CommandConfiguration(subcommands: [SaltBased.self, ServiceBased.self, DomainBased.self])
    }
}
