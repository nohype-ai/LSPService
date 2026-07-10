import Vapor
import Foundation
import SwiftyToolz

// TODO: move this setter to SwiftyToolz
extension Log {
    /// Cross-actor mutation of `minimumPrintLevel` (property assignment is not allowed).
    func setMinimumPrintLevel(_ level: Level) {
        minimumPrintLevel = level
    }
}

@main
public class LSPServiceApp {
    
    static func main() async throws {
        await Log.shared.setMinimumPrintLevel(.info) // adjust log level for development
        let lspServiceApp = try LSPServiceApp()
        try lspServiceApp.run()
    }

    // MARK: - Life Cycle
    
    public init(useTestEnvironment: Bool = false) throws {
        vaporApp = useTestEnvironment ? Application(.testing) : try Self.makeVaporApp()
        configureVaporApp()
        try RouteConfigurator().registerRoutes(on: vaporApp)
        ServerExecutableConfigs.preload()
    }
    
    deinit { vaporApp.shutdown() }
    
    // MARK: - Vapor App
    
    public func run() throws { try vaporApp.run() }
    
    private static func makeVaporApp() throws -> Application {
        var env = try Environment.detect()
        try LoggingSystem.bootstrap(from: &env)
        return Application(env)
    }
    
    private func configureVaporApp() {
        // uncomment to serve files from /Public folder
        // vaporApp.middleware.use(FileMiddleware(publicDirectory: vaporApp.directory.publicDirectory))
        vaporApp.http.server.configuration.serverName = "LSPService"
        vaporApp.logger.logLevel = .debug
    }
    
    internal let vaporApp: Application
}
