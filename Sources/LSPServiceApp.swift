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
        let lspServiceApp = try await LSPServiceApp()
        do {
            try await lspServiceApp.run()
        } catch {
            try? await lspServiceApp.shutdown()
            throw error
        }
        try await lspServiceApp.shutdown()
    }

    // MARK: - Life Cycle
    
    public init(useTestEnvironment: Bool = false) async throws {
        vaporApp = useTestEnvironment
            ? try await Application.make(.testing)
            : try await Self.makeVaporApp()
        configureVaporApp()
        try RouteConfigurator().registerRoutes(on: vaporApp)
        ServerExecutableConfigs.preload()
    }
    
    /// Required for apps created via `Application.make` (async storage hooks).
    public func shutdown() async throws {
        try await vaporApp.asyncShutdown()
    }
    
    // MARK: - Vapor App
    
    public func run() async throws { try await vaporApp.execute() }
    
    private static func makeVaporApp() async throws -> Application {
        var env = try Environment.detect()
        try LoggingSystem.bootstrap(from: &env)
        return try await Application.make(env)
    }
    
    private func configureVaporApp() {
        // uncomment to serve files from /Public folder
        // vaporApp.middleware.use(FileMiddleware(publicDirectory: vaporApp.directory.publicDirectory))
        vaporApp.http.server.configuration.serverName = "LSPService"
        vaporApp.logger.logLevel = .debug
    }
    
    internal let vaporApp: Application
}
