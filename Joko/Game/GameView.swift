
//                    Text("⏱ Time: \(timeRemaining)")
//                        .font(.title2)
//                        .foregroundColor(.white)
//                    Spacer()
//                    Text("🏆 Score: \(viewModel.score)")
                   
import SwiftUI

struct GameView: View {
    @StateObject private var viewModel: GameViewModel
    @State private var timeRemaining = 100
    @State private var timer: Timer?
    @Namespace private var animationNamespace
    @Binding var isLevelCompleted: Bool
    @Environment(\.presentationMode) var presentationMode
    private var levelIndex: Int
    
    var grass = 0
    var carrot = 0
    var corn = 0
    
    
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
                        Text("\("index")")
                            .font(.custom(AppFlipupConstants.fontName1, size: 15))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .offset(y: 8)
                    }
                    
                    ZStack {
                        Image("Group 19094-2")
                        Text("\("index" )")
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
                        Image("Frame 1171277315")
                        Text("\(grass) Grass")
                            .font(.custom(AppFlipupConstants.fontName1, size: 15))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }

                    Spacer().frame(width: 30) // Відстань між елементами

                    VStack {
                        Image("Frame 1171277317")
                        Text("\(carrot) Carrot")
                            .font(.custom(AppFlipupConstants.fontName1, size: 15))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }
                    
                    Spacer().frame(width: 30) // Відстань між елементами

                    VStack {
                        Image("Frame 1171277319")
                        Text("\(corn) Corn")
                            .font(.custom(AppFlipupConstants.fontName1, size: 15))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.bottom, 100)

                ////////////////////////////
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
