import XCTest
@testable import PasswordGeneratorKit

final class EntropyGeneratorTests: XCTestCase {

    func testPBKDF2EntropyGeneration() {

        let generator = PBKDF2BasedEntropyGenerator<UInt64>(iterations: 1, bytes: 8)
        let entropy = try? generator.generateEntropy(with: "salt", masterPassword: "password")
        XCTAssertEqual(entropy?.bitWidth, 64)

        let generator2 = PBKDF2BasedEntropyGenerator<UInt64>(iterations: 1, bytes: 16)
        let entropy2 = try? generator2.generateEntropy(with: "salt", masterPassword: "password")
        XCTAssertEqual(entropy2?.bitWidth, 128)

        let generator3 = PBKDF2BasedEntropyGenerator<UInt64>(iterations: 1, bytes: 20)
        let entropy3 = try? generator3.generateEntropy(with: "salt", masterPassword: "password")
        XCTAssertEqual(entropy3?.bitWidth, 192)

        let generator4 = PBKDF2BasedEntropyGenerator<UInt8>(iterations: 1, bytes: 32)
        let entropy4 = try? generator4.generateEntropy(with: "salt", masterPassword: "password")
        XCTAssertEqual(entropy4?.bitWidth, 256)
    }

    static let allTests = [
        ("testPBKDF2EntropyGeneration", testPBKDF2EntropyGeneration)
    ]
}
