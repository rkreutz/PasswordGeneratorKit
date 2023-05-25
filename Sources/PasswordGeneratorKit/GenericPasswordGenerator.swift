import Foundation

final class GenericPasswordGenerator<Entropy: BinaryInteger> {

    private let masterPasswordProvider: MasterPasswordProvider
    private let entropyGenerator: AnyEntropyGenerator<Entropy>

    init<Generator: EntropyGenerator>(
        masterPasswordProvider: MasterPasswordProvider,
        entropyGenerator: Generator
    ) where Generator.Entropy == Entropy {

        self.masterPasswordProvider = masterPasswordProvider
        self.entropyGenerator = AnyEntropyGenerator(entropyGenerator)
    }

    func generatePassword(username: String, domain: String, seed: Int, rules: Set<PasswordRule>) throws -> String {

        try generatePassword(
            salt: """
            username: \(username),
            domain: \(domain),
            seed: \(seed)
            """,
            rules: rules
        )
    }

    func generatePassword(service: String, rules: Set<PasswordRule>) throws -> String {

        try generatePassword(salt: "service: \(service)", rules: rules)
    }

    func generatePassword(salt: String, rules: Set<PasswordRule>) throws -> String {

        guard case let .length(length) = rules.first(where: { $0.caseMatch(.length) }) else {

            throw PasswordGenerator.Error.mustSpecifyLength
        }

        guard rules.contains(where: { $0.caseMatch(.mustContain) }) else {

            throw PasswordGenerator.Error.mustSpecifyAtLeastOneCharacterSet
        }

        let masterPassword: String
        do {

            masterPassword = try masterPasswordProvider.masterPassword()
        } catch {

            throw PasswordGenerator.Error.failedToFetchMasterPassword(error)
        }

        var entropy: Entropy
        do {

            entropy = try entropyGenerator.generateEntropy(with: salt, masterPassword: masterPassword)
        } catch {

            throw PasswordGenerator.Error.entropyGenerationError(error)
        }

        return generatePassword(from: &entropy, rules: rules, length: length)
    }

    func profilePasswordGeneration(iterations: Int, passwordLengths: [UInt]) throws -> PasswordGenerationProfilingResult {

        var entropyGenerationMeasurements = [TimeInterval]()
        var computationMeasurements = [[TimeInterval]].init(repeating: [], count: passwordLengths.count)
        var totalMeasurements = [[TimeInterval]].init(repeating: [], count: computationMeasurements.count)
        for _ in 0 ..< iterations {

            let startEntropy = Date()
            let entropy: Entropy
            do {

                entropy = try entropyGenerator.generateEntropy(with: "salt", masterPassword: "masterPassword")
            } catch {

                throw PasswordGenerator.Error.entropyGenerationError(error)
            }
            entropyGenerationMeasurements.append(Date().timeIntervalSince(startEntropy))

            for (index, passwordLength) in passwordLengths.enumerated() {
                var entropy = entropy
                let startComputation = Date()
                _ = generatePassword(
                    from: &entropy,
                    rules: [
                        .mustContainDecimalCharacters(atLeast: 1),
                        .mustContainLowercaseCharacters(atLeast: 1),
                        .mustContainUppercaseCharacters(atLeast: 1),
                        .mustContainSymbolCharacters(atLeast: 1)
                    ],
                    length: passwordLength
                )
                computationMeasurements[index].append(Date().timeIntervalSince(startComputation))
                totalMeasurements[index].append(computationMeasurements[index].last.unsafelyUnwrapped + entropyGenerationMeasurements.last.unsafelyUnwrapped)
            }
        }

        return PasswordGenerationProfilingResult(
            entropyGeneration: TimeMeasurement(entropyGenerationMeasurements),
            computation: zip(passwordLengths, computationMeasurements).map(LabeledTimeMeasurement.init),
            total: zip(passwordLengths, totalMeasurements).map(LabeledTimeMeasurement.init)
        )
    }

    private func generatePassword(from entropy: inout Entropy, rules: Set<PasswordRule>, length: UInt) -> String {
        var generatedPassword = ""
        var allowedCharacters = ""
        var extraCharacters = ""
        var extraCount: UInt = 0
        for case let .mustContain(characterSet, count) in rules.sorted() {

            allowedCharacters += characterSet
            extraCount += count
            (extraCharacters, entropy) = entropy.consumeEntropy(
                generatedPassword: extraCharacters,
                characters: characterSet,
                maxLength: extraCount
            )
        }

        (generatedPassword, entropy) = entropy.consumeEntropy(
            generatedPassword: generatedPassword,
            characters: allowedCharacters,
            maxLength: length - extraCount
        )

        generatedPassword.insertStringRandomically(extraCharacters, entropy: entropy)

        return generatedPassword
    }
}
