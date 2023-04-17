import SwiftUI

struct FinishView: View {
    
    @Binding var pageFinish: Bool
    @Binding var pageIntro: Bool
    
    var body: some View {
        Spacer()
        HStack {
            Spacer()
            VStack(spacing: 15) {
                Text("That is a simple overview of some encryption and decryption methods.").font(.system(.largeTitle))
                Text("Thank You!\n").font(.system(.largeTitle)).fontWeight(.bold)
                Text("You can press the button below to go back to the start menu and learn again.")
                Button("Back to Start") {
                    pageFinish = false
                    pageIntro = true
                }.buttonStyle(IndigoButton())
            }
            .multilineTextAlignment(.center)
            Spacer()
        }
        Spacer()
    }
}
