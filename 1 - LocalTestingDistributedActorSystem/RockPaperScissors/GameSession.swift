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
            do {
                let actorSystem = Player.ActorSystem()
                let localGameState = GameViewModel()
                let localPlayer = Player(name: "player 1", gameState: localGameState, actorSystem: actorSystem)
                let opponentGameState = GameViewModel()
                let opponent = Player(name: "player 2", gameState: opponentGameState, actorSystem: actorSystem)
                try await localPlayer.setOpponent(opponent)
                self.session = GameSession(localGameState: localGameState, opponentGameState: opponentGameState, localPlayer: localPlayer, opponent: opponent)
            } catch {
                self.session = nil
            }
        }
    }
}
