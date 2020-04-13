import CryptoSwift
import UIntX

final class PBKDF2BasedEntropyGenerator: EntropyGenerator {

    public let iterations: Int
    public let bytes: Int

    public init(
        iterations: Int = 1_000,
        bytes: Int = 64
    ) {

        self.iterations = iterations
        self.bytes = bytes
    }

    public func generateEntropy(with salt: String, masterPassword: String) throws -> UIntX8 {

        let key = try PKCS5.PBKDF2(
            password: Array(masterPassword.utf8),
            salt: Array(salt.utf8),
            iterations: iterations,
            keyLength: bytes,
            variant: .sha256
        )
        .calculate()

        return UIntX8(ascendingArray: key.reversed())
    }
}
