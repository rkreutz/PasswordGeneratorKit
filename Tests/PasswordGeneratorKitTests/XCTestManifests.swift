import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    [
        testCase(EntropyGeneratorTests.allTests),
        testCase(PasswordGeneratorTests.allTests),
        testCase(GenericPasswordGeneratorTests.allTests)
    ]
}
#endif
