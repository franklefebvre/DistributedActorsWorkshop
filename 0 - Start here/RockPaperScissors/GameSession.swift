import Foundation
import Combine

struct GameSession {
    var localGameState: GameViewModel
    var opponentGameState: GameViewModel
    var localPlayer: Player
    var opponent: Player
}

@MainActor
final class GameSessionManager: ObservableObject {
    @Published var session: GameSession?
    
    init() {
        Task {
            let localGameState = GameViewModel()
            let localPlayer = Player(name: "player 1", gameState: localGameState)
            let opponentGameState = GameViewModel()
            let opponent = Player(name: "player 2", gameState: opponentGameState)
            await localPlayer.setOpponent(opponent)
            self.session = GameSession(localGameState: localGameState, opponentGameState: opponentGameState, localPlayer: localPlayer, opponent: opponent)
        }
    }
}
