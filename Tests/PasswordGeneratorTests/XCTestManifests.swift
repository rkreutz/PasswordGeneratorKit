import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(PasswordGeneratorTests.allTests),
        testCase(GenericPasswordGeneratorTests.allTests),
    ]
}
#endif
