import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    [
        testCase(PasswordGeneratorTests.allTests),
        testCase(GenericPasswordGeneratorTests.allTests),
        testCase(PerformanceTests.allTests)
    ]
}
#endif
