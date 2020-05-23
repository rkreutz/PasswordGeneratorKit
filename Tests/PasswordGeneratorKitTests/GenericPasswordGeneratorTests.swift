import XCTest
@testable import PasswordGeneratorKit

final class GenericPasswordGeneratorTests: XCTestCase {

    func testDifferentEntropyTypes() {

        let uintxPasswordGenerator = GenericPasswordGenerator(
            masterPasswordProvider: "masterPassword",
            entropyGenerator: UIntXEntropyGenerator()
        )

        let uintPasswordGenerator = GenericPasswordGenerator(
            masterPasswordProvider: "masterPassword",
            entropyGenerator: UIntEntropyGenerator()
        )

        XCTAssertEqual(
            try uintxPasswordGenerator.generatePassword(salt: "salt", rules: PasswordRule.defaultRules),
            try uintPasswordGenerator.generatePassword(salt: "salt", rules: PasswordRule.defaultRules)
        )

        XCTAssertEqual(
            try uintxPasswordGenerator.generatePassword(service: "A Bank", rules: PasswordRule.defaultRules),
            try uintPasswordGenerator.generatePassword(service: "A Bank", rules: PasswordRule.defaultRules)
        )

        XCTAssertEqual(
            try uintxPasswordGenerator.generatePassword(
                username: "rkreutz",
                domain: "github.com",
                seed: 1,
                rules: PasswordRule.defaultRules
            ),
            try uintPasswordGenerator.generatePassword(
                username: "rkreutz",
                domain: "github.com",
                seed: 1,
                rules: PasswordRule.defaultRules
            )
        )
    }

    static var allTests = [
        ("testDifferentEntropyTypes", testDifferentEntropyTypes)
    ]
}
