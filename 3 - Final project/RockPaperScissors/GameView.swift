import SwiftUI
import Distributed

struct GameView: View {
    @ObservedObject var viewModel: GameViewModel
    let player: Player

    var body: some View {
        VStack {
            Text("\(viewModel.playerName) vs. \(viewModel.opponentName)")
                .font(.title)
            Spacer()
            if let opponentMove = viewModel.opponentMove {
                Text("\(viewModel.opponentName)'s move:")
                Text(opponentMove.icon)
                    .font(.largeTitle)
            } else {
                Text("Waiting for both players to pick a move")
            }
            Spacer()
            Text("Your move:")
            if let playerMove = viewModel.playerMove {
                Text(playerMove.icon)
                    .font(.largeTitle)
            } else {
                HStack {
                    ForEach(Shape.allCases, id: \.self) { move in
                        Button {
                            Task {
                                do {
                                    try await player.play(move: move)
                                } catch {
                                    print("play failed: \(error.localizedDescription)")
                                }
                            }
                        } label: {
                            Text(move.icon)
                        }
                        
                    }
                }
                .font(.largeTitle)
            }
            Spacer()
            Text(viewModel.outcomeText)
        }
        .padding()
    }
}

//struct GameView_Previews: PreviewProvider {
//    static var viewModel = GameViewModel()
//    static let service = MultipeerService(serviceType: "rps-dist-actors", displayName: "test")
//    static let actorSystem = MultipeerActorSystem(service: service)
//    static var me = Player(gameState: viewModel, actorSystem: actorSystem)
//    static var opponent = Player(gameState: nil, actorSystem: actorSystem)
//
//    static var previews: some View {
//        GameView(viewModel: viewModel, player: me)
//            .task {
//                try? await me.setOpponent(opponent)
//            }
//    }
//}
