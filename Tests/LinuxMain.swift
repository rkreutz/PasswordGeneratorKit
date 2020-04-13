import XCTest

import PasswordGeneratorTests

var tests = [XCTestCaseEntry]()
tests += PasswordGeneratorTests.allTests()
tests += GenericPasswordGeneratorTests.allTests()
XCTMain(tests)
