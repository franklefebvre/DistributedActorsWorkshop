import SwiftUI

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
                                    print(error.localizedDescription)
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
