import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    let isLarge: Bool = UIScreen.main.bounds.height > 900
    let isSE: Bool = UIDevice.current.userInterfaceIdiom == .pad
    
    @State private var isMusicEnabled: Bool = false

    var body: some View {
        ZStack {
            Image("bgLevel6")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            VStack {
                HStack {
                    
                    closeButton()
                        .padding(.top, 60)
                    
                    Spacer()
                }
                Spacer()
                
                VStack {
                    //Frame 1171277336
                    Image(isMusicEnabled ? "Frame 1171277324" : "Frame 1171277336")
                        .padding(.top, 40)
                        .padding(.bottom, 10)
                        .onTapGesture {
                            isMusicEnabled = MusicManager.shared.toggleMusic()
                        }
                        .onAppear {
                            isMusicEnabled = MusicManager.shared.audioPlayer?.isPlaying == true
                        }
                    
                    Image("Frame 1171277320")
                    
                    
                        Image("Frame 1171277322")
                    
                    NavigationLink(destination: HowToPalyVoiew()) {
                        Image("Frame 1171277323")
                    }
                    Spacer()

                }


            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func closeButton() -> some View {
        Button(action: {
            dismiss()
        }) {
            Image("Group 19071")
               .padding(.trailing, 40)

        }
    }
}
