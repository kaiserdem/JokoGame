
import SwiftUI

struct GameView: View {
    @StateObject private var viewModel: GameViewModel
    @State private var timeRemaining = 100
    @State private var timer: Timer?
    @Namespace private var animationNamespace
    @Binding var isLevelCompleted: Bool
    @Environment(\.presentationMode) var presentationMode
    private var levelIndex: Int
    
    private let isSE: Bool = UIScreen.main.bounds.height < 700
    
    
    init(selectedLevel: GameLevel, isSE: Bool, isLevelCompleted: Binding<Bool>, levelIndex: Int) {
        let l = levelIndex + 1
        self.levelIndex = l
        _viewModel = StateObject(wrappedValue: GameViewModel(selectedLevel: selectedLevel, isSE: isSE))
        _isLevelCompleted = isLevelCompleted
    }
    
    var body: some View {
        ZStack {
            Image("bgLevel\(viewModel.selectedLevel.backgroundIndex)")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack {
                
                HStack {
                    
                    Button(action: {
                        self.viewModel.resetGame()
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image("Frame 1171277326")
                    }
                    .padding(.top, isSE ? 20 : 0)
                    Spacer()
                    
                    Image("Joko logo 1")
                    Spacer()
                    Spacer()
                }
                .padding(.leading, 0)
                .padding(.top, isSE ? 10 : 40)
                
                Spacer()
                ///////////////////////
                
                HStack(alignment: .center, spacing: 20) {
                    
                    
                    ZStack {
                        Image("Group 19095")
                        Text("lvl \(levelIndex)")
                            .font(.custom(AppFlipupConstants.fontName1, size: 15))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .offset(x: 10, y: 4)
                    }
                    
                    ZStack {
                        Image("Frame 1171277331")
                        Text(viewModel.formattedGameTime())
                            .font(.custom(AppFlipupConstants.fontName1, size: 15))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .offset(y: 8)
                    }
                    
                    ZStack {
                        Image("Group 19094-2")
                        Text("\(viewModel.currentLevelScores)")
                            .font(.custom(AppFlipupConstants.fontName1, size: 15))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .offset(x: 10, y: 4)
                    }
                    
                }
                /////////////////////////////
                
                HStack(alignment: .center) {
                    GeometryReader { geometry in
                        let totalPadding: CGFloat = 4
                        
                        GridView(game: viewModel, namespace: animationNamespace, size: UIScreen.main.bounds.width )
                            .padding(totalPadding)
                    }
                }
                //////////////////////////////
                HStack(alignment: .center) {
                    VStack {
                        Image("asdfgdfh08")
                        Text("\(viewModel.grass.0) Grass")
                            .font(.custom(AppFlipupConstants.fontName1, size: 15))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }
                    .onTapGesture {
                        if viewModel.grass.0 > 0 {
                            viewModel.useBonus(for: viewModel.grass.1)
                        }
                    }
                    
                    Spacer().frame(width: 30)
                    
                    VStack {
                        Image("asdfgdfh02")
                        Text("\(viewModel.carrot.0) Carrot")
                            .font(.custom(AppFlipupConstants.fontName1, size: 15))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }
                    .onTapGesture {
                        if viewModel.carrot.0 > 0 {
                            viewModel.useBonus(for: viewModel.carrot.1)
                        }
                    }
                    
                    Spacer().frame(width: 30)
                    
                    VStack {
                        Image("asdfgdfh01")
                        Text("\(viewModel.corn.0) Corn")
                            .font(.custom(AppFlipupConstants.fontName1, size: 15))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }
                    .onTapGesture {
                        if viewModel.corn.0 > 0 {
                            viewModel.useBonus(for: viewModel.corn.1)
                        }
                    }
                }
                .padding(.bottom, 100)
                
                
                ////////////////////////////
            }
            .onAppear {
                viewModel.onGameEnd = {
                    self.presentationMode.wrappedValue.dismiss() // Закриває вью
                }
            }
            if viewModel.showingWinningFrame {
                Image("Frame 19064")
                    .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity, maxHeight: .infinity) // Займає весь простір
                            .clipped() // Вирізає все, що виходить за межі
                            .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            
                            viewModel.showingWinningFrame = false
                            viewModel.completeLevel()
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
            }
        }
    }
}



struct GridView: View {
    @ObservedObject var game: GameViewModel
    var namespace: Namespace.ID
    var size: CGFloat
    
    var body: some View {
        let cellSize = (size - (CGFloat(game.columns) * 3)) / CGFloat(game.columns) - 12// Враховуйте padding між клітинками
        
        HStack {
            Spacer()
            
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
                                .padding(5)
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
            .background(Color.yellow.opacity(0.7))
            .shadow(radius: 25)
            .cornerRadius(20)
            
            Spacer()
            
        }
    }
}
