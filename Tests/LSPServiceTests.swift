@testable import LSPService
import XCTVapor

final class AppTests: XCTestCase {
    
    func testNonExistingPathIsNotFound() async throws {
        let lspServiceApp = try await LSPServiceApp(useTestEnvironment: true)
        do {
            try await lspServiceApp.vaporApp.test(.GET, "invalidPath") { response async throws in
                XCTAssertEqual(response.status, .notFound)
            }
        } catch {
            try? await lspServiceApp.shutdown()
            throw error
        }
        try await lspServiceApp.shutdown()
    }
    
    // TODO: how do we test the websocket route?
//    func testGetSwiftWebSocket() throws {
//        let lspServiceApp = try LSPServiceApp(useTestEnvironment: true)
//        
//        try lspServiceApp.vaporApp.test(.GET,
//                                        "lspservice/api/swift/websocket") { response in
//            XCTAssertEqual(response.status, .ok)
//        }
//    }
    
    func testConfigForLanguageOfRandomNameIsNotSet() throws {
        XCTAssertNil(ServerExecutableConfigs.config(language: "jdfhbqrufghuidrgb"))
    }
    
    func testSwiftConfigIsSet() throws {
        XCTAssertNotNil(ServerExecutableConfigs.config(language: "swift"))
    }
}
