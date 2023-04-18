import SwiftUI

struct IntroView: View {
    
    @Binding var pageIntro: Bool
    @Binding var pageCipher: Bool
    @State var breathingTextOpacity = 0.0
    
    var body: some View {
        ZStack {
            Image("background").resizable().scaledToFill()
            HStack{
                Spacer()
                VStack {
                    Spacer()
                    Text("EncryptDecrypt")
                        .font(Font.custom("Menlo", size: 75, relativeTo: .headline))
                        .multilineTextAlignment(.center)
                        .padding([.bottom], 5).padding()
                    Text("Learn more about encryption!").font(.system(size: 30)).padding()
                    Spacer()
                    Text("Tap to Begin")
                        .font(Font.custom("Menlo", size: 30, relativeTo: .body))
                        .padding()
                        .opacity(breathingTextOpacity)
                        .onAppear {
                            withAnimation(.easeIn(duration: 1).repeatForever(autoreverses: true)) {
                                breathingTextOpacity = 1.0
                            }
                        }
                }.foregroundColor(.black)
                .padding()
                Spacer()
            }
        }
        .preferredColorScheme(.light)
        .contentShape(Rectangle()) // so whole page can be tapped
        .onTapGesture {
            print("tap")
            pageIntro = false
            pageCipher = true
        }
    }
}

