import SwiftUI

@main
struct RockPaperScissorsApp: App {
    @StateObject private var gameSessionManager = GameSessionManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(gameSessionManager)
        }
    }
}
