import UIntX
@testable import PasswordGeneratorKit

final class UIntXEntropyGenerator: EntropyGenerator {

    func generateEntropy(with salt: String, masterPassword: String) throws -> UIntX8 { UIntX8(UInt.max) }
}

final class UIntEntropyGenerator: EntropyGenerator {

    func generateEntropy(with salt: String, masterPassword: String) throws -> UInt { UInt.max }
}
