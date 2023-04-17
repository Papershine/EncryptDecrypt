import SwiftUI

struct CipherGraphView: View {
    
    let lowercaseLetter = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
    let uppercaseLetter = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    
    @ObservedObject var viewModel: CipherViewModel
    
    @State var encryptPulseStart = false
    @State var decryptPulseStart = false
    
    @State var keyShake = 0
    @State var keyShakeAgain = 0
    @State var wrongKeyShake = 0
    
    var body: some View {
        VStack(spacing: 25) {
            Spacer()
            ZStack {
                Text(" \(viewModel.message) ")
                    .font(.custom("menlo", size: 48, relativeTo: .largeTitle))
                    .id("message" + viewModel.message)
                    .transition(.opacity)
            }
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color.gray, style: StrokeStyle(lineWidth: 1.0)))
            HStack {
                Spacer()
                VStack {
                    Image("arrow_right")
                        .resizable()
                        .frame(width: 18, height: 18)
                        .scaleEffect(x: 1, y: -1, anchor: .center)
                        .offset(x: 3)
                        .invertOnDarkTheme()
                    if #available(iOS 16.0, *) {
                        if viewModel.pageThree {
                            Image("encryption")
                                .scaleEffect(encryptPulseStart ? 1.05 : 1)
                                .animation(encryptPulseStart ? .easeInOut.repeatForever(autoreverses: true) : .default, value: encryptPulseStart)
                                .dropDestination(for: String.self) { _, _ in
                                    // save user choices
                                    viewModel.originalMessage = viewModel.message
                                    viewModel.encryptedMessage = encrypt(viewModel.message, key: viewModel.key.wrappedValue)
                                    viewModel.wrongMessage = encrypt(viewModel.message, key: viewModel.key.wrappedValue+1)
                                    
                                    Task {
                                        // show the encrypted message
                                        await animateToEncrypted()
                                    }
                                    
                                    return true
                                }
                        } else {
                            Image("encryption")
                        }
                    }
                }
                Spacer()
                VStack {
                    Image("arrow_left")
                        .resizable()
                        .frame(width: 18, height: 18)
                        .scaleEffect(x: 1, y: -1, anchor: .center)
                        .invertOnDarkTheme()
                    if #available(iOS 16.0, *) {
                        if viewModel.pageFour {
                            Image("decryption")
                                .scaleEffect(decryptPulseStart ? 1.05 : 1)
                                .animation(decryptPulseStart ? .easeInOut.repeatForever(autoreverses: true) : .default, value: decryptPulseStart)
                                .dropDestination(for: String.self) { _, _ in
                                    // stop animating
                                    decryptPulseStart = false
                                    
                                    Task {
                                        // show the decrypted message
                                        await animateToDecrypted()
                                    }
                                    return true
                                }
                        } else if viewModel.pageFive {
                            Image("decryption")
                                .scaleEffect(decryptPulseStart ? 1.05 : 1)
                                .animation(decryptPulseStart ? .easeInOut.repeatForever(autoreverses: true) : .default, value: decryptPulseStart)
                                .dropDestination(for: String.self) { _, _ in
                                    // stop animating
                                    decryptPulseStart = false
                                    
                                    Task {
                                        // show the wrong dencrypted message
                                        await animateToWrongDecrypted()
                                        
                                    }
                                    return true
                                }
                        } else {
                            Image("decryption")
                        }
                    }
                }
                Spacer()
            }
            HStack {
                Spacer()
                // correct key
                if #available(iOS 16.0, *) {
                    if viewModel.pageThree {
                        ZStack {
                            Image("key")
                                .shake(with: keyShake)
                                .onAppear {
                                    withAnimation(.shakeSpring()) {
                                        keyShake = 3
                                    }
                                }
                            Style.monospaceBig("\(viewModel.key.wrappedValue)").offset(x: -30)
                        }.onDrag {
                            encryptPulseStart = true
                            return NSItemProvider(object: "enc" as NSItemProviderWriting)
                        }
                    } else if viewModel.pageFour && !viewModel.pageFourSub {
                        ZStack {
                            Image("key")
                                .shake(with: keyShakeAgain)
                                .onAppear {
                                    withAnimation(.shakeSpring()) {
                                        keyShakeAgain = 3
                                    }
                                }
                            Style.monospaceBig("\(viewModel.key.wrappedValue)").offset(x: -30)
                        }.onDrag {
                            decryptPulseStart = true
                            return NSItemProvider(object: "enc" as NSItemProviderWriting)
                        }
                    } else {
                        ZStack {
                            Image("key")
                            Style.monospaceBig("\(viewModel.key.wrappedValue)").offset(x: -30)
                        }
                    }
                } else {
                    // Fallback on earlier versions
                }
                Spacer()
                // wrong key
                if #available(iOS 16.0, *) {
                    if viewModel.pageFive && !viewModel.pageFiveSub {
                        ZStack {
                            Image("key_wrong")
                                .shake(with: wrongKeyShake)
                                .onAppear {
                                    withAnimation(.shakeSpring()) {
                                        wrongKeyShake = 3
                                    }
                                }
                            Style.monospaceBig("\(viewModel.key.wrappedValue+1)").offset(x: -30)
                        }
                        .onDrag {
                            decryptPulseStart = true
                            return NSItemProvider(object: "enc" as NSItemProviderWriting)
                        }
                        .transition(.enterFromRight)
                        Spacer()
                    } else if viewModel.pageFiveSub || viewModel.pageSix {
                        ZStack {
                            Image("key_wrong")
                            Style.monospaceBig("\(viewModel.key.wrappedValue+1)").offset(x: -30)
                        }
                        Spacer()
                    }
                } else {
                    // Fallback on earlier versions
                }
            }
            Spacer()
        }.animation(.default, value: viewModel.pageFive)
    }
    
    func encrypt(_ t: String, key: Int) -> String {
        var encrypted = ""
        for letter in t {
            if String(letter) == " " {
                encrypted.append(" ")
                continue
            }
            if letter.isLowercase { // lowercase
                if let oldIndex = lowercaseLetter.firstIndex(of: String(letter)) {
                    let newIndex = (oldIndex + key) % 26
                    encrypted.append(lowercaseLetter[newIndex])
                } else {
                    print("SOME ERROR WITH OPTIONALS")
                }
            } else { // uppercase
                if let oldIndex = uppercaseLetter.firstIndex(of: String(letter)) {
                    let newIndex = (oldIndex + key) % 26
                    encrypted.append(uppercaseLetter[newIndex])
                }
            }
        }
        
        return encrypted
    }
    
    func decrypt(_ t: String, key: Int) -> String {
        var decrypted = ""
        for letter in t {
            if String(letter) == " " {
                decrypted.append(" ")
                continue
            }
            if letter.isLowercase { // lowercase
                if let oldIndex = lowercaseLetter.firstIndex(of: String(letter)) {
                    let newIndex = (oldIndex - key) %% 26
                    decrypted.append(lowercaseLetter[newIndex])
                } else {
                    print("SOME ERROR WITH OPTIONALS")
                }
            } else { // uppercase
                if let oldIndex = uppercaseLetter.firstIndex(of: String(letter)) {
                    let newIndex = (oldIndex - key) %% 26
                    print(newIndex)
                    decrypted.append(uppercaseLetter[newIndex])
                }
            }
        }
        
        return decrypted
    }
    
    func animateToEncrypted() async {
        try? await Task.sleep(nanoseconds: 50_000_000) // 0.1 seconds
        withAnimation(.default) {
            viewModel.message = encrypt(viewModel.message, key: 1)
        }
        if viewModel.message != viewModel.encryptedMessage {
            Task {
                await animateToEncrypted()
            }
        } else {
            // next page
            viewModel.pageThree = false
            viewModel.pageFour = true
        }
    }
    
    func animateToDecrypted() async {
        try? await Task.sleep(nanoseconds: 50_000_000) // 0.1 seconds
        withAnimation(.default) {
            viewModel.message = decrypt(viewModel.message, key: 1)
        }
        if viewModel.message != viewModel.originalMessage {
            Task {
                await animateToDecrypted()
            }
        } else {
            // display success
            viewModel.pageFourSub = true
        }
    }
    
    func animateToWrongDecrypted() async {
        try? await Task.sleep(nanoseconds: 50_000_000) // 0.1 seconds
        withAnimation(.default) {
            viewModel.message = decrypt(viewModel.message, key: 1)
        }
        if viewModel.message != viewModel.wrongMessage {
            Task {
                await animateToWrongDecrypted()
            }
        } else {
            // display success
            viewModel.pageFiveSub = true
        }
    }
}
