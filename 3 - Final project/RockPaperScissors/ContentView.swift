import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var gameSessionManager: GameSessionManager

    var body: some View {
        if let session = gameSessionManager.session {
            GameView(viewModel: session.gameState, player: session.localPlayer)
        } else {
            ChooserView()
                .environmentObject(gameSessionManager.service.dataSource)
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
