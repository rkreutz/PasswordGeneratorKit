import CryptoSwift
import UIntX

final class PBKDF2BasedEntropyGenerator<BaseInteger>: EntropyGenerator
where BaseInteger: FixedWidthInteger,
      BaseInteger: UnsignedInteger {

    let iterations: UInt
    let bytes: UInt

    init(
        iterations: UInt = 1_000,
        bytes: UInt = 64
    ) {

        self.iterations = iterations
        self.bytes = bytes
    }

    func generateEntropy(with salt: String, masterPassword: String) throws -> UIntX<BaseInteger> {

        let key = try PKCS5.PBKDF2(
            password: Array(masterPassword.utf8),
            salt: Array(salt.utf8),
            iterations: Int(clamping: iterations),
            keyLength: Int(clamping: bytes),
            variant: .sha2(.sha256)
        )
        .calculate()

        return UIntX<BaseInteger>(bigEndianArray: key)
    }
}
