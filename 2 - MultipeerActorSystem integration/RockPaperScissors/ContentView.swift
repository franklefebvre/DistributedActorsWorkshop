import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var gameSessionManager: GameSessionManager

    var body: some View {
        if let session = gameSessionManager.session {
            GameView(viewModel: session.localGameState, player: session.localPlayer)
        } else {
            ChooserView()
                .environmentObject(gameSessionManager.service.dataSource)
        }
    }
}
