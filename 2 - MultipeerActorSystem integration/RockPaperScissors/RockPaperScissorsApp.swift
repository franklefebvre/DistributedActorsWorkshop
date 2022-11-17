import SwiftUI

@main
struct RockPaperScissorsApp: App {
    @StateObject private var gameSessionManager = GameSessionManager(service: MultipeerService())
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(gameSessionManager)
        }
    }
}
