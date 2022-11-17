import Foundation
import Distributed

distributed actor Player {
    typealias ActorSystem = MultipeerActorSystem
    
    private let playerName: String
    private let gameState: GameState
    private weak var opponent: Player? // even though it is supposed to be remote, it must be weak to avoid a retain cycle if it is local
    
    init(name: String, gameState: GameState, actorSystem: ActorSystem) {
        self.playerName = name
        self.gameState = gameState
        self.actorSystem = actorSystem
    }

    distributed var name: String {
        get throws { // Warning workaround. Shouldn't be necessary.
            playerName
        }
    }
    
    distributed func setOpponent(_ opponent: Player) async {
        self.opponent = opponent
        await gameState.setPlayers(local: self, opponent: opponent)
    }

    // Local API
    distributed func play(move: Shape) async throws { // has to be distributed too, because called from outside the actor
        guard let opponent else { return }
        try await opponent.opponentDidPlay(move: move)
        await gameState.playerDidPlay(move)
    }

    // Remote API
    private distributed func opponentDidPlay(move: Shape) async {
        await gameState.opponentDidPlay(move)
    }
}
