import SwiftUI

struct LevelsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = LevelsViewModel()
    
    @State private var selectedLevel: GameLevel? = nil
    @State private var levelIndex = 0
    @State private var isLevelCompleted: Bool = false

    @State private var nextLevelToPlay: GameLevel? = nil
    
    private let isSE: Bool = UIScreen.main.bounds.height < 700
    
    // MARK: - Body
    var body: some View {
        
        ZStack {
            backgroundView()
            
            listView()
                .padding(.top, 40)
                .padding(.bottom, 40)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.clear)
            
            
            VStack {
                
                HStack {
                    
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image("Frame 1171277326")
                    }
                        .padding(.top, isSE ? 0 : 0)
                    Spacer()
                    
                    ZStack {
                        Image("Frame 1171277335")
                        Text("\(viewModel.totalCoins)")
                            .font(.custom(AppFlipupConstants.fontName1, size: 15))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .offset(x: 10, y: 3)
                    }
                    Spacer()
                    Spacer()
                }
                .padding(.leading, 20)
                .padding(.top, 60)
                
                Spacer()
                Spacer()
            }
            .navigationBarBackButtonHidden(true)
            
            
            
            
        }
    }
    
    
    // MARK: - View для списку
    private func listView() -> some View {
        ScrollView(.vertical, showsIndicators: true) {
            LazyVStack(alignment: .center, spacing: nil) {
                ForEach(Array(viewModel.levels.enumerated()), id: \.element.id) { index, level in
                    VStack(spacing: -50) {
                        ZStack {
                            if level.completed {
                                Image("completeLevel\(level.backgroundIndex)")
                                
                                Text("\(index + 1)")
                                    .font(.custom(AppFlipupConstants.fontName1, size: 40))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .offset(y: 28)

                                
                            } else {
                                if index == 0 || (index > 0 && viewModel.levels[index - 1].completed) {
                                    Image("openLevel\(level.backgroundIndex)")
                                    
                                    Text("\(index + 1)")
                                        .font(.custom(AppFlipupConstants.fontName1, size: 40))
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                        .offset(y: 28)
                                    
                                } else {
                                    Image("closedLevel\(level.backgroundIndex)")
                                }
                            }
                        }
                    }
                    .frame(width: 122, height: 139)
                    .onTapGesture {
                        if level.completed || index == 0 || (index > 0 && viewModel.levels[index - 1].completed) {
                            levelIndex = index
                            selectedLevel = level
                        }
                    }
                    .rotationEffect(Angle(degrees: 180))
                    .scaleEffect(x: -1.0, y: 1.0, anchor: .center)
                    .offset(x: index % 2 == 0 ? -80 : 80)
                    
                }

            }

        }
        .rotationEffect(Angle(degrees: 180))
        .scaleEffect(x: -1.0, y: 1.0, anchor: .center)
        .fullScreenCover(item: $selectedLevel) { level in
            GameView(selectedLevel: level, isSE: isSE, isLevelCompleted: $isLevelCompleted, levelIndex: levelIndex)
        }
    }
    
    // MARK: - Background View
    private func backgroundView() -> some View {
        ZStack {
            Image("Main 1")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width + 20, height: UIScreen.main.bounds.height)
                .offset(x: 9)
                .clipped()
                .edgesIgnoringSafeArea(.all)
        }
    }
    
    // MARK: - Button Pause View
    
}
