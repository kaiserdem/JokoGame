
import SwiftUI

struct HowToPalyVoiew: View {
    @Environment(\.dismiss) var dismiss
    let isLarge: Bool = UIScreen.main.bounds.height > 900
    let isSE: Bool = UIDevice.current.userInterfaceIdiom == .pad
    
    var  items = ["HowToPalyVoiew1", "HowToPalyVoiew2","HowToPalyVoiew3","HowToPalyVoiew4", "HowToPalyVoiew5"]
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
                
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(items, id: \.self) { item in
                            Image(item)
                                //.resizable()
                                //.scaledToFit()
                                //.frame(height: 100)
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .padding(.top, 15)
                
            }
        }
        .navigationBarBackButtonHidden(true)

    }
    
    func closeButton() -> some View {
        Button(action: {
            dismiss()
        }) {
            Image("Group 19071-2")
               //.padding(.trailing, 0)

        }
    }
}
