import XCTest
@testable import EndgameCore

final class EndgameCoreTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(EndgameCore().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
