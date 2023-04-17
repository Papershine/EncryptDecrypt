import SwiftUI

struct NavigationView: View {
    
    @State var pageIntro = true
    @State var pageCipher = false
    @State var pageDiffie = false
    @State var pageQuantum = false
    @State var pageFinish = false
    
    @State var publicKeyColor: Color = .white
    @State var secretKeyColor: Color = .white
    
    var body: some View {
        ZStack {
            if pageIntro {
                IntroView(pageIntro: $pageIntro, pageCipher: $pageCipher).transition(.pushForStart)
            }
            if pageCipher {
                CipherView(pageCipher: $pageCipher, pageDiffie: $pageDiffie).transition(.pushFromRight)
            }
            if pageDiffie {
                DiffieHellmanView(pageDiffie: $pageDiffie, pageQuantum: $pageQuantum, publicKeyColor: $publicKeyColor, secretKeyColor: $secretKeyColor).transition(.pushFromRight)
            }
            if pageQuantum {
                QuantumView(pageQuantum: $pageQuantum, pageFinish: $pageFinish, publicKeyColor: $publicKeyColor, secretKeyColor: $secretKeyColor).transition(.pushFromRight)
            }
            if pageFinish {
                FinishView(pageFinish: $pageFinish, pageIntro: $pageIntro).transition(.pushForEnding)
            }
        }.animation(.default, value: pageIntro)
            .animation(.default, value: pageCipher)
            .animation(.default, value: pageDiffie)
            .animation(.default, value: pageQuantum)
            .animation(.default, value: pageFinish)
    }
}

struct NavigationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView()
    }
}
