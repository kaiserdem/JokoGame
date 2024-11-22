
import SwiftUI

struct GameView: View {
    @StateObject private var game = Match3GameViewModel(rows: 6, columns: 5)
    @State private var timeRemaining = 100
    @State private var timer: Timer?
    @Namespace private var animationNamespace

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(gradient: Gradient(colors: [.pink, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack {
                Text("✨ Match 3 Game ✨")
                    .font(.custom("Chalkduster", size: 32))
                    .foregroundColor(.white)
                    .padding()

                HStack {
                    Text("⏱ Time: \(timeRemaining)")
                        .font(.title2)
                        .foregroundColor(.white)
                    Spacer()
                    Text("🏆 Score: \(game.score)")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                .padding(.horizontal)

                GeometryReader { geometry in
                    GridView(game: game, namespace: animationNamespace, size: min(geometry.size.width, geometry.size.height) * 0.8)
                        .frame(width: min(geometry.size.width, geometry.size.height) * 0.8, height: min(geometry.size.width, geometry.size.height) * 0.8)
                        .padding(30)
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }

                Button(action: {
                    game.resetGame()
                    resetTimer()
                }) {
                    Text("Restart")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [.yellow, .orange]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
            }
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }

    func startTimer() {
        timeRemaining = 100
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                timer?.invalidate()
                // Actions when the game ends
            }
        }
    }

    func resetTimer() {
        timer?.invalidate()
        startTimer()
    }
}

struct GridView: View {
    @ObservedObject var game: Match3GameViewModel
    var namespace: Namespace.ID
    var size: CGFloat

    var body: some View {
        let cellSize = size / CGFloat(game.columns)
        VStack(spacing: 0) {
            ForEach(0..<game.rows, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<game.columns, id: \.self) { column in
                        let ball = game.grid[row][column]
                        Image(ball.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: cellSize, height: cellSize)
                            .shadow(radius: 3)
                            .overlay(
                                ZStack {
                                    if ball.isShaking {
                                        Circle()
                                            .stroke(Color.white, lineWidth: 2)
                                            .modifier(ShakeEffect(shakes: 2))
                                    }
                                    if ball.isHinted {
                                        Circle()
                                            .stroke(Color.yellow, lineWidth: 3)
                                            .animation(.easeInOut)
                                    }
                                }
                            )
                            .matchedGeometryEffect(id: ball.id, in: namespace)
                            .onTapGesture {
                                game.selectCell(row: row, column: column)
                            }
                            .transition(.move(edge: .top))
                            .animation(.spring(), value: ball.id)
                    }
                }
            }
        }
    }
}


