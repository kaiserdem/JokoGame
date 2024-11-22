
import SwiftUI

struct HowToPalyVoiew: View {
    @Environment(\.dismiss) var dismiss
    let isLarge: Bool = UIScreen.main.bounds.height > 900
    let isSE: Bool = UIDevice.current.userInterfaceIdiom == .pad
    var body: some View {
        ZStack {
            Image("Main")
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
                                
        
            }
        }
        .navigationBarBackButtonHidden(true)

    }
    
    func closeButton() -> some View {
        Button(action: {
            dismiss()
        }) {
            Image("Group 19071-2")
               .padding(.trailing, 40)

        }
    }
}
