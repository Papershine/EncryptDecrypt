import SwiftUI

struct NavigationView: View {
    
    @State var pageIntro = true
    @State var pageCipher = false
    @State var pageDiffie = false
    
    var body: some View {
        if pageIntro {
            IntroView(pageIntro: $pageIntro, pageCipher: $pageCipher)
        }
        if pageCipher {
            CipherView(pageCipher: $pageCipher, pageDiffie: $pageDiffie)
        }
        if pageDiffie {
            DiffieHellmanView()
        }
    }
}

struct NavigationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView()
    }
}
