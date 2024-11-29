import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    let isLarge: Bool = UIScreen.main.bounds.height > 900
    let isSE: Bool = UIDevice.current.userInterfaceIdiom == .pad
    var body: some View {
        ZStack {
            Image("Slot-2")
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
                    
                    Image("Frame 1171277324")
                        .padding(.top, 40)
                        .padding(.bottom, 10)
                        .onTapGesture {
                            MusicManager.shared.toggleMusic()
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
