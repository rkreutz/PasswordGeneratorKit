import CryptoSwift
import UIntX

final class PBKDF2BasedEntropyGenerator<BaseInteger>: EntropyGenerator
where BaseInteger: FixedWidthInteger,
      BaseInteger: UnsignedInteger {

    let iterations: Int
    let bytes: Int

    init(
        iterations: Int = 1_000,
        bytes: Int = 64
    ) {

        self.iterations = iterations
        self.bytes = bytes
    }

    func generateEntropy(with salt: String, masterPassword: String) throws -> UIntX<BaseInteger> {

        let key = try PKCS5.PBKDF2(
            password: Array(masterPassword.utf8),
            salt: Array(salt.utf8),
            iterations: iterations,
            keyLength: bytes,
            variant: .sha256
        )
        .calculate()

        return UIntX<BaseInteger>(ascendingArray: key.reversed())
    }
}
