import XCTest
@testable import PasswordGeneratorKit

final class PasswordGeneratorTests: XCTestCase {

    func testSaltPasswordGeneration() {

        let generator = PasswordGenerator(masterPasswordProvider: "masterPassword", bytes: 64)

        XCTAssertEqual(
            try generator.generatePassword(salt: "salt", rules: PasswordRule.defaultRules),
            "K-T#Mq1$MvQ4@%6l"
        )
    }

    func testSaltPasswordGenerationWithArgon2() {

        let generator = PasswordGenerator(masterPasswordProvider: "masterPassword", entropyGenerator: .argon2(), bytes: 64)

        XCTAssertEqual(
            try generator.generatePassword(salt: "salt", rules: PasswordRule.defaultRules),
            "-Zxrp4h2ttF-xRRu"
        )
    }

    func testUsernameDomainPasswordGeneration() {

        let generator = PasswordGenerator(masterPasswordProvider: "masterPassword", bytes: 64)

        XCTAssertEqual(
            try generator.generatePassword(
                username: "rkreutz",
                domain: "github.com",
                seed: 1,
                rules: PasswordRule.defaultRules
            ),
            "L5bnoSNxy5OZ_6LE"
        )

        XCTAssertEqual(
            try generator.generatePassword(
                username: "rkreutz",
                domain: "github.com",
                seed: 2,
                rules: PasswordRule.defaultRules
            ),
            "&qilq&O_M.J&oR11"
        )
    }

    func testUsernameDomainPasswordGenerationWithArgon2() {

        let generator = PasswordGenerator(masterPasswordProvider: "masterPassword", entropyGenerator: .argon2(), bytes: 64)

        XCTAssertEqual(
            try generator.generatePassword(
                username: "rkreutz",
                domain: "github.com",
                seed: 1,
                rules: PasswordRule.defaultRules
            ),
            "!Z$x.zspWIm6anmR"
        )

        XCTAssertEqual(
            try generator.generatePassword(
                username: "rkreutz",
                domain: "github.com",
                seed: 2,
                rules: PasswordRule.defaultRules
            ),
            "kDzQpUYDcQO4toe_"
        )
    }

    func testServicePasswordGenerator() {

        let generator = PasswordGenerator(masterPasswordProvider: "masterPassword", bytes: 64)

        XCTAssertEqual(
            try generator.generatePassword(service: "Bank name", rules: PasswordRule.defaultRules),
            "Aekve?RLjcc4XD8!"
        )
    }

    func testServicePasswordGeneratorWithArgon2() {

        let generator = PasswordGenerator(masterPasswordProvider: "masterPassword", entropyGenerator: .argon2(), bytes: 64)

        XCTAssertEqual(
            try generator.generatePassword(service: "Bank name", rules: PasswordRule.defaultRules),
            "6NfR?T@qfsOFzVWo"
        )
    }

    func testRuleSetValidation() {

        let generator = PasswordGenerator(masterPasswordProvider: "masterPassword", bytes: 64)

        XCTAssertThrowsError(try generator.generatePassword(salt: "salt", rules: [])) { error in

            guard case PasswordGenerator.Error.mustSpecifyLength = error else {

                XCTFail("Wrong error thrown: \(error)")
                return
            }
        }

        XCTAssertThrowsError(try generator.generatePassword(salt: "salt", rules: [.length(1)])) { error in

            guard case PasswordGenerator.Error.mustSpecifyAtLeastOneCharacterSet = error else {

                XCTFail("Wrong error thrown: \(error)")
                return
            }
        }
    }

    func testCharacterRules() {

        let generator = PasswordGenerator(masterPasswordProvider: "masterPassword", bytes: 64)

        XCTAssertEqual(
            try generator.generatePassword(
                salt: "salt",
                rules: [
                    .length(10),
                    .mustContain(characterSet: String.lowercaseCharacters, atLeast: 4),
                    .mustContain(characterSet: String.uppercaseCharacters, atLeast: 3),
                    .mustContain(characterSet: String.decimalCharacters, atLeast: 2),
                    .mustContain(characterSet: String.symbolCharacters, atLeast: 1)
                ]
            ),
            "YLWnz4r@7b"
        )

        XCTAssertEqual(
            try generator.generatePassword(
                service: "Bank name",
                rules: [
                    .length(4),
                    .mustContain(characterSet: String.decimalCharacters, atLeast: 0)
                ]
            ),
            "3979"
        )
    }

    static var allTests = [
        ("testSaltPasswordGeneration", testSaltPasswordGeneration),
        ("testSaltPasswordGenerationWithArgon2", testSaltPasswordGenerationWithArgon2),
        ("testUsernameDomainPasswordGeneration", testUsernameDomainPasswordGeneration),
        ("testUsernameDomainPasswordGenerationWithArgon2", testUsernameDomainPasswordGenerationWithArgon2),
        ("testServicePasswordGenerator", testServicePasswordGenerator),
        ("testServicePasswordGeneratorWithArgon2", testServicePasswordGeneratorWithArgon2),
        ("testRuleSetValidation", testRuleSetValidation),
        ("testCharacterRules", testCharacterRules)
    ]
}
