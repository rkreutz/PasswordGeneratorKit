import XCTest
import UIntX
@testable import PasswordGeneratorKit

final class PerformanceTests: XCTestCase {

    func test1000IterationsUIntX64() {

        let generator = GenericPasswordGenerator<UIntX64>(
            masterPasswordProvider: "masterPassword",
            entropyGenerator: PBKDF2BasedEntropyGenerator(
                iterations: 1_000,
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
                "D&Wij1OxF-row84yvsz8BYE3UnmV3B%Q"
            )
        }
    }

    func test100IterationsUIntX64() {

        let generator = GenericPasswordGenerator<UIntX64>(
            masterPasswordProvider: "masterPassword",
            entropyGenerator: PBKDF2BasedEntropyGenerator(
                iterations: 100,
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
                "yPGPRraFcXJ!Tk%1H3ib8RttZ0dZK#v!"
            )
        }
    }

    func test1000IterationsUIntX8() {

        let generator = GenericPasswordGenerator<UIntX8>(
            masterPasswordProvider: "masterPassword",
            entropyGenerator: PBKDF2BasedEntropyGenerator(
                iterations: 1_000,
                bytes: 24
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
                "nK4TQd%%zCc2m1cHjPJ%%G_i.W7@!zz3"
            )
        }
    }

    func test100IterationsUIntX8() {

        let generator = GenericPasswordGenerator<UIntX8>(
            masterPasswordProvider: "masterPassword",
            entropyGenerator: PBKDF2BasedEntropyGenerator(
                iterations: 100,
                bytes: 24
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
                "pB2U&Qz@wub@HPt4k5sJcYWThUo!Pzbq"
            )
        }
    }

    static var allTests = [
        ("test1000IterationsUIntX64", test1000IterationsUIntX64),
        ("test100IterationsUIntX64", test100IterationsUIntX64),
        ("test1000IterationsUIntX8", test1000IterationsUIntX8),
        ("test100IterationsUIntX8", test100IterationsUIntX8)
    ]
}

