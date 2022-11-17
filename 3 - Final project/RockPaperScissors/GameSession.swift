import Foundation
import Combine

struct GameSession {
    var actorSystem: MultipeerActorSystem
    var gameState: GameViewModel
    var localPlayer: Player
    var opponent: Player
}

@MainActor
final class GameSessionManager: ObservableObject {
    private(set) var service: MultipeerService
    private var subscription: AnyCancellable?
    @Published var session: GameSession?
    
    init(service: MultipeerService) {
        self.service = service
        subscription = service.objectWillChange
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self else { return }
                guard let remotePeer = service.remotePeer else {
                    self.session = nil
                    return
                }
                Task {
                    do {
                        let actorSystem = MultipeerActorSystem(service: service, acceptedTypes: [String.self])
                        let gameState = GameViewModel()
                        let localPlayer = Player(name: service.peerName, gameState: gameState, actorSystem: actorSystem)
                        let opponentID = MultipeerActorSystem.ActorID(peer: remotePeer, type: Player.self)
                        let opponent = try Player.resolve(id: opponentID, using: actorSystem)
                        try await localPlayer.setOpponent(opponent)
                        self.session = GameSession(actorSystem: actorSystem, gameState: gameState, localPlayer: localPlayer, opponent: opponent)
                    } catch {
                        self.session = nil
                    }
                }
        }
    }
}
