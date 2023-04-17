import SwiftUI
import Combine

// 'key' vector image sourced from https://freesvg.org/yellow-lock-key-vector-image, by 'OpenClipart' licensed under a public domain license

struct CipherView: View {
    
    @Binding var pageCipher: Bool
    @Binding var pageDiffie: Bool
    
    @StateObject var viewModel: CipherViewModel = CipherViewModel()
    
    var body: some View {
        GeometryReader { geo in
            HStack {
                VStack(alignment: .leading, spacing: 25) {
                    Text("Ceasar Cipher").font(.system(.title)).fontWeight(.bold).frame(maxWidth: .infinity, alignment: .leading)
                    if viewModel.pageOne {
                        VStack(alignment: .leading, spacing: 25) {
                            CipherTextOne()
                            TextField("Enter your word here", text: $viewModel.message)
                                .padding()
                                .autocorrectionDisabled()
                                .onReceive(Just($viewModel.message)) { newValue in
                                    let filtered = newValue.wrappedValue.filter { "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ ".contains($0) }
                                    if filtered != newValue.wrappedValue {
                                        viewModel.message = filtered
                                    }
                                }
                                .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color.gray, style: StrokeStyle(lineWidth: 1.0)))
                            Button("Next >") {
                                // hide this page and display next page
                                viewModel.pageOne = false
                                viewModel.pageTwo = true
                            }
                            .buttonStyle(BlueButton())
                            .disabled(viewModel.message == "")
                        }.transition(.enterFromBottom)
                    }
                    if viewModel.pageTwo {
                        VStack(alignment: .leading, spacing: 25) {
                            CipherTextTwo()
                            Slider(value: $viewModel.keyIndexDbl, in: 1...50)
                            Text("Your key value: ") + Style.monospace("\(viewModel.key.wrappedValue)")
                            Button("Next >") {
                                // hide this page and display next page
                                viewModel.pageTwo = false
                                viewModel.pageThree = true
                            }
                            .buttonStyle(BlueButton())
                        }.transition(.enterFromBottom)
                    }
                    if viewModel.pageThree {
                        CipherTextThree().transition(.enterFromBottom)
                    }
                    if viewModel.pageFour {
                        VStack(alignment: .leading, spacing: 25) {
                            CipherTextFour()
                            if viewModel.pageFourSub {
                                VStack(alignment: .leading, spacing: 25) {
                                    CipherTextFourSub()
                                    Button("Next >") {
                                        // revert back to encrypted
                                        viewModel.message = viewModel.encryptedMessage
                                        
                                        // hide this page and display next page
                                        viewModel.pageFour = false
                                        viewModel.pageFive = true
                                    }
                                    .buttonStyle(BlueButton())
                                }.transition(.enterFromBottom)
                            }
                        }.transition(.enterFromBottom)
                    }
                    if viewModel.pageFive {
                        VStack(alignment: .leading, spacing: 25) {
                            CipherTextFive()
                            if viewModel.pageFiveSub {
                                VStack(alignment: .leading, spacing: 25) {
                                    CipherTextFiveSub()
                                    Button("Next >") {
                                        // hide this page and display next page
                                        viewModel.pageFive = false
                                        viewModel.pageSix = true
                                    }
                                    .buttonStyle(BlueButton())
                                }.transition(.enterFromBottom)
                            }
                        }.transition(.enterFromBottom)
                    }
                    if viewModel.pageSix {
                        VStack(alignment: .leading, spacing: 25) {
                            CipherTextSix()
                            Button("Next Chapter >") {
                                pageCipher = false
                                pageDiffie = true
                            }
                            .buttonStyle(IndigoButton())
                        }.transition(.enterFromBottom)
                    }
                    Spacer()
                }
                .frame(maxWidth: geo.size.width*0.333)
                .padding()
                Divider()
                
                VStack {
                    HStack {
                        Spacer()
                        VStack {
                            CipherGraphView(viewModel: viewModel)
                        }
                        Spacer()
                    }
                }.padding()
            }.animation(.default, value: viewModel.pageOne)
                .animation(.default, value: viewModel.pageTwo)
                .animation(.default, value: viewModel.pageThree)
                .animation(.default, value: viewModel.pageFour)
                .animation(.default, value: viewModel.pageFourSub)
                .animation(.default, value: viewModel.pageFive)
                .animation(.default, value: viewModel.pageFiveSub)
                .animation(.default, value: viewModel.pageSix)
        }
    }
}

@MainActor class CipherViewModel: ObservableObject {
    @Published var message = ""
    var originalMessage = ""
    var encryptedMessage = ""
    var wrongMessage = ""
    
    @Published var keyIndexDbl = 15.0
    var key: Binding<Int> { Binding(
        get: { Int(round(self.keyIndexDbl)) },
        set: { _ in }
    )}
    
    @Published var pageOne = true
    @Published var pageTwo = false
    @Published var pageThree = false
    @Published var pageFourSub = false
    @Published var pageFour = false
    @Published var pageFive = false
    @Published var pageFiveSub = false
    @Published var pageSix = false
}

struct CipherTextOne: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Let's see how we can protect a message that you want to send.")
            Text("To do so, we use a key in an algorithm to change the plaintext into gibberish, or ciphertext.")
            Text("This key can also be used to change the gibberish back to plaintext.")
            Text("Type some word or sentence below that you want to encrypt.")
        }
    }
}

struct CipherTextTwo: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Then, we need to choose some number to be the key.")
            /*
            Text("This key is used to encrypt and decrypt the message. When we pass the key into the encryption algorithm, the algorithm scrambles the message based on the key. The same key can also unscramble the message using a decryption algorithm.")
            Text("For this example, we will use the very simple alogrithm called the Ceasar Cipher.")
            Text("This algorithm shifts every letter by the number provided in the key. For instance, if the key is ") + Style.monospace("3") + Text(" , then the letter 'A' will be shifted up by 3 indexes to the letter 'D'. Also, since there are only 26 letters, the algorithm wraps around at the end. That is, the letter 'Z' shifted up by 3 indexes will be the letter 'C'.")
            */
            Text("Use the slider below to choose the value of the key. It can be any integer.")
        }
    }
}

struct CipherTextThree: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Now, we can encrypt our message with this encryption key.")
            Text("Drag and drop the key into the encryption algorithm to do so.")
            Text("Note: You may have to do a long press on the key to pick it up!")
        }
    }
}

struct CipherTextFour: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("We can also decrypt our message with this encryption key.")
            Text("Drag and drop the key into the decryption algorithm to do so.")
        }
    }
}

struct CipherTextFourSub: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Great! We have encrypted and decrypted the message correctly.")
            Text("Now let's see what happens if we have the wrong key on the encrypted message.")
        }
    }
}

struct CipherTextFive: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Here is a key with the wrong value.")
            Text("Try to use this key to decrypt the message.")
            Text("Drag and drop this wrong key into the decryption algorithm.")
        }
    }
}
struct CipherTextFiveSub: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Since it is not the right key, the algorithm will not decrypt the message accurately.")
        }
    }
}

struct CipherTextSix: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("So, if anybody knows the correct value of your key, they will be able to decrypt your messages or anything that you store.")
            Text("When you are sending private messages to other people over the internet encrypted, both you and the other person need to have the same key.")
            Text("But you cannot send the key over too, since people eavesdropping on the internet can see the key and decrypt the message using it.")
            Text("Therefore, we need a method to generate the same key between two people, without people eavesdropping over the internet being able to guess the key.")
            Text("There is an established method for doing so, which is called 'Diffie Hellman Key Exchange.'")
            Text("Let's explore this.")
        }
    }
}

struct CipherView_Previews: PreviewProvider {
    static var previews: some View {
        CipherView(pageCipher: .constant(true), pageDiffie: .constant(false)).previewInterfaceOrientation(.landscapeLeft)
    }
}
