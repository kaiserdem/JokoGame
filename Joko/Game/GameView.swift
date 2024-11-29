
import SwiftUI

struct GameView: View {
    @StateObject private var viewModel: GameViewModel
    @State private var timeRemaining = 100
    @State private var timer: Timer?
    @Namespace private var animationNamespace
    @Binding var isLevelCompleted: Bool

    init(selectedLevel: GameLevel, isSE: Bool, isLevelCompleted: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: GameViewModel(selectedLevel: selectedLevel, isSE: isSE))
        _isLevelCompleted = isLevelCompleted
    }
    
    var body: some View {
        ZStack {
            Image("Slot-1") // Задаємо ваше зображення фону
                .resizable()
                .scaledToFill() // Заповнюємо доступний простір
                .ignoresSafeArea()
                .opacity(0.5) // Можна налаштувати прозорість, якщо потрібно
            
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
                    Text("🏆 Score: \(viewModel.score)")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
                
                Spacer()
                Spacer(minLength: 100)
                
                HStack(alignment: .center) {
                    
                    Spacer()

                    
                    GeometryReader { geometry in
                        let totalPadding: CGFloat = 4 // Відступ з усіх боків
                            let spacing: CGFloat = 3 // Відстань між клітинками
//                            let boardWidth = min(geometry.size.width - totalPadding * 2, geometry.size.height) * 0.8 // Використовуйте ширину з відступами
//                            let boardHeight = min(geometry.size.height - totalPadding * 2, geometry.size.width) * 0.8 // Використовуйте висоту з відступами

                            // Обчислення cellSize
                            //let cellWidth = (boardWidth - (CGFloat(game.columns - 1) * spacing)) / CGFloat(game.columns) // Розмір клітинки по ширині
                            //let cellHeight = (boardHeight - (CGFloat(game.rows - 1) * spacing)) / CGFloat(game.rows) // Розмір клітинки по висоті

                            // Обчислення adjustedBoardSize для ширини та висоти
                            //let adjustedBoardWidth = cellWidth * CGFloat(game.columns) + (CGFloat(game.columns - 1) * spacing) + totalPadding * 2
                           // let adjustedBoardHeight = cellHeight * CGFloat(game.rows) + (CGFloat(game.rows - 1) * spacing) + totalPadding * 2

                            // Використовуйте adjustedBoardWidth і adjustedBoardHeight для background
                        GridView(game: viewModel, namespace: animationNamespace, size: UIScreen.main.bounds.width - 40)
                                .padding(totalPadding) // Відстань між бордом та фоном
                                .background(
                                    Image("bgfedfrg") // Ваше зображення фону
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.width + 330) // Встановлення розміру фону
                                        .clipped() // Обрізаємо, щоб відповідати розмірам
                                )
                                .cornerRadius(25)
                                .shadow(radius: 5)
                    }
                }
                
                Button(action: {
                    viewModel.resetGame()
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
    @ObservedObject var game: GameViewModel
    var namespace: Namespace.ID
    var size: CGFloat
    
    var body: some View {
        let cellSize = (size - (CGFloat(game.columns) * 3)) / CGFloat(game.columns) // Враховуйте padding між клітинками
        
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
                            .padding(3) // Внутрішній відступ
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
