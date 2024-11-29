import SwiftUI

struct LevelsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = LevelsViewModel()
    
    @State private var selectedLevel: GameLevel? = nil
    @State private var isLevelCompleted: Bool = false

    @State private var nextLevelToPlay: GameLevel? = nil
    
    private let isSE: Bool = UIScreen.main.bounds.height < 700
    
    // MARK: - Body
    var body: some View {
        
        ZStack {
            backgroundView()
            
            VStack {
                
                HStack {
                    
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image("Frame 1171277326")
                    }
                        .padding(.top, isSE ? 20 : 0)
                    Spacer()
                    
                    Image("Frame 1171277335")
                    Spacer()
                    Spacer()
                }
                .padding(.leading, 20)
                .padding(.top, 60)
                
                Spacer()
                Spacer()
            }
            .navigationBarBackButtonHidden(true)
            
            
            listView()
                .padding(.top, 130)
                .padding(.bottom, 0)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.clear)
            
            
        }
    }
    
    
    // MARK: - View для списку
    private func listView() -> some View {
        ScrollView(.vertical, showsIndicators: true) {
            LazyVStack(alignment: .center, spacing: nil) {
                ForEach(Array(viewModel.levels.enumerated()), id: \.element.id) { index, level in
                        VStack(spacing: 0) {
                            ZStack {
                                if index < 1 || level.completed {
                                    Image("openLevel\(level.backgroundIndex)")
                                        .offset(y: -75)
                                } else {
                                    Image("openLevel\(level.backgroundIndex)")
                                        .offset(y: -75)
                                }
                                
                                Text("completeLevel\(level.backgroundIndex)")
                                    .font(.custom(AppFlipupConstants.fontName1, size: 30))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    //.padding(.horizontal, 20)
                            }
                        }
                        .frame(width: 248, height: 300)
                        .background(Color.clear)
                        .cornerRadius(8)
                        .onTapGesture {
                            if level.completed[0] != 0 || index == 0 {
                                selectedLevel = level
                            }
                        }
                        .rotationEffect(Angle(degrees: 180))
                        .scaleEffect(x: -1.0, y: 1.0, anchor: .center)
                    }
            }
            .padding(.top, 20)
            .padding(.bottom, 40)
        }
        .rotationEffect(Angle(degrees: 180))
        .scaleEffect(x: -1.0, y: 1.0, anchor: .center)
        .fullScreenCover(item: $selectedLevel) { level in
            GameView(selectedLevel: level, isSE: isSE, isLevelCompleted: $isLevelCompleted)
        }
    }

    
    func levelToPlay(_ level: GameLevel) -> GameLevel {
        var levelToPlay = level
        levelToPlay.completed = Array(repeating: 0, count: levelToPlay.completed.count)
        return levelToPlay
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
