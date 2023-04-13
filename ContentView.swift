import SwiftUI

struct IntroView: View {
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

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView().previewInterfaceOrientation(.landscapeLeft)
    }
}