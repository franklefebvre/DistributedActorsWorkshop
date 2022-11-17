import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var gameSessionManager: GameSessionManager

    var body: some View {
        if let session = gameSessionManager.session {
            TwoPlayersView(localVM: session.localGameState, opponentVM: session.opponentGameState, me: session.localPlayer, opponent: session.opponent)
        } else {
            Text("initializing")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(GameSessionManager())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
