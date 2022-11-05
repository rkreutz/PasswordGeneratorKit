import UIntX
@testable import PasswordGeneratorKit

final class UIntXEntropyGenerator: EntropyGenerator {

    private let entropy: UIntX8
    init(entropy: UIntX8 = UIntX8(UInt.max)) {
        self.entropy = entropy
    }

    func generateEntropy(with salt: String, masterPassword: String) throws -> UIntX8 { entropy }
}

final class UIntEntropyGenerator: EntropyGenerator {

    private let entropy: UInt
    init(entropy: UInt = .max) {
        self.entropy = entropy
    }
    func generateEntropy(with salt: String, masterPassword: String) throws -> UInt { entropy }
}
