import ArgumentParser

struct PasswordGeneratorCLI: ParsableCommand {

    static var configuration: CommandConfiguration {

        CommandConfiguration(subcommands: [SaltBased.self, ServiceBased.self, DomainBased.self])
    }
}
