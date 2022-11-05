import XCTest
import UIntX
@testable import PasswordGeneratorKit

final class PerformanceTests: XCTestCase {

    func testEntropyGenerator() {
        let generator = Argon2BasedEntropyGenerator<UInt64>(
            iterations: 3,
            memory: 16_384,
            threads: 1,
            bytes: 24
        )

        measure {
            XCTAssertEqual(
                try? generator.generateEntropy(with: "salt", masterPassword: "masterPassword").bitWidth,
                192
            )
        }
    }

    func testEntropyGeneratorAlt2() {
        let generator = Argon2BasedEntropyGenerator<UInt64>(
            iterations: 3,
            memory: 16_384,
            threads: 1,
            bytes: 32
        )

        measure {
            XCTAssertEqual(
                try? generator.generateEntropy(with: "salt", masterPassword: "masterPassword").bitWidth,
                256
            )
        }
    }

    func testEntropyGeneratorAlt3() {
        let generator = Argon2BasedEntropyGenerator<UInt64>(
            iterations: 3,
            memory: 16_384,
            threads: 1,
            bytes: 64
        )

        measure {
            XCTAssertEqual(
                try? generator.generateEntropy(with: "salt", masterPassword: "masterPassword").bitWidth,
                512
            )
        }
    }

    func testMostEntropy() {
        let generator = GenericPasswordGenerator<UIntX64>(
            masterPasswordProvider: "masterPassword",
            entropyGenerator: Argon2BasedEntropyGenerator(
                iterations: 3,
                memory: 16_384,
                threads: 1,
                bytes: 64
            )
        )

        measure {
            XCTAssertEqual(
                try? generator.generatePassword(
                    username: "rkreutz",
                    domain: "github.com",
                    seed: 1,
                    rules: PasswordRule.defaultCharacterSet.union([PasswordRule.length(32)])
                ),
                "$!Zx.sp6WImanmR5uEZEe06OFKM#QzFA"
            )
        }
    }

    func testReasonableEntropy() {
        let generator = GenericPasswordGenerator<UIntX64>(
            masterPasswordProvider: "masterPassword",
            entropyGenerator: Argon2BasedEntropyGenerator(
                iterations: 3,
                memory: 16_384,
                threads: 1,
                bytes: 32
            )
        )

        measure {
            XCTAssertEqual(
                try? generator.generatePassword(
                    username: "rkreutz",
                    domain: "github.com",
                    seed: 1,
                    rules: PasswordRule.defaultCharacterSet.union([PasswordRule.length(32)])
                ),
                "AloP5-B77zZoY@l&!0qrwv1_zVLO.t?5"
            )
        }
    }

    func testMostEfficient() {
        let generator = GenericPasswordGenerator<UIntX64>(
            masterPasswordProvider: "masterPassword",
            entropyGenerator: Argon2BasedEntropyGenerator(
                iterations: 3,
                memory: 16_384,
                threads: 1,
                bytes: 24 // 24 gives best performance with 32 bytes max pwd length
            )
        )

        measure {
            XCTAssertEqual(
                try? generator.generatePassword(
                    username: "rkreutz",
                    domain: "github.com",
                    seed: 1,
                    rules: PasswordRule.defaultCharacterSet.union([PasswordRule.length(32)])
                ),
                "tC1nlz?|cE.R-@b!1@zI8CbOneRv6Hm-"
            )
        }
    }
}

