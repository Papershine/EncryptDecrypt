import SwiftUI

struct IntroView: View {
    
    @Binding var pageIntro: Bool
    @Binding var pageCipher: Bool
    
    var body: some View {
        HStack{
            Spacer()
            VStack {
                Spacer()
                Text("EncryptDecrypt")
                    .font(Font.custom("Menlo", size: 75, relativeTo: .headline))
                    .multilineTextAlignment(.center)
                    .padding([.bottom], 5).padding()
                Text("Learn more about symmetric and asymmetric encryption algorithms").font(.system(size: 30)).padding()
                Spacer()
                Text("Tap to Begin").font(Font.custom("Menlo", size: 30, relativeTo: .body)).padding()
            }
            .padding()
            Spacer()
        }
        .contentShape(Rectangle()) // so whole page can be tapped
        .onTapGesture {
            print("tap")
            pageIntro = false
            pageCipher = true
        }
    }
}

// blue rounded button, gray when disabled
struct BlueButton: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding([.horizontal], 25)
            .padding([.vertical], 10)
            .foregroundColor(.white)
            .background(isEnabled ? .blue : .gray)
            .clipShape(Capsule())
    }
}
