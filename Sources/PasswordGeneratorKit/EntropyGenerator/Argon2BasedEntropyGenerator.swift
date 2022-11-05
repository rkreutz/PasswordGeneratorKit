import Foundation
import Argon2Kit
import UIntX

final class Argon2BasedEntropyGenerator<BaseInteger>: EntropyGenerator
where BaseInteger: FixedWidthInteger,
      BaseInteger: UnsignedInteger {

    let iterations: UInt
    let bytes: UInt
    let memory: UInt
    let threads: UInt

    init(
        iterations: UInt = 3,
        memory: UInt = 16_384,
        threads: UInt = 1,
        bytes: UInt = 64
    ) {

        self.iterations = iterations
        self.memory = memory
        self.threads = threads
        self.bytes = bytes
    }

    func generateEntropy(with salt: String, masterPassword: String) throws -> UIntX<BaseInteger> {
        let saltData: Data
        if salt.count < 8 {
            saltData = Data(Array("padded: \(salt)".utf8))
        } else {
            saltData = Data(Array(salt.utf8))
        }

        let digest = try Argon2.hash(
            password: masterPassword,
            salt: saltData,
            iterations: UInt32(clamping: iterations),
            memory: UInt32(clamping: memory),
            threads: UInt32(clamping: threads),
            length: UInt32(clamping: bytes),
            type: .i,
            version: .latest
        )

        let bytesArray = [UInt8](digest.rawData)

        return UIntX<BaseInteger>(bigEndianArray: bytesArray)
    }
}

