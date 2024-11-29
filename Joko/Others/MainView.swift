import SwiftUI

struct MainView: View {
    let isSE: Bool = UIScreen.main.bounds.height < 700
    @State private var isSheetPresented = false

    var body: some View {
        NavigationView {
            ZStack {
                Image("Main 1")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Image("Frame 19063")
                        .offset(y: isSE ? 80 : -40)

                    VStack {
                        HStack(alignment: .center, spacing: 40) {
                           
                            NavigationLink(destination: SettingsView()) {
                                Image("Frame 6")
                            }

                            NavigationLink(destination: HowToPalyVoiew()) {
                                Image("Frame 5")
                            }
                        }

                        VStack {
                            NavigationLink(destination:LevelsView()) {
                                Image("Frame 1171277312")
                            }
                        }
                    }
                    .padding(.bottom, isSE ? 140 : 50)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            MusicManager.shared.playBackgroundMusic()
        }
    }
}
