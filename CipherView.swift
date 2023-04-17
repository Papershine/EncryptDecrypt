import SwiftUI
import Combine

// 'key' vector image sourced from https://freesvg.org/yellow-lock-key-vector-image, by 'OpenClipart' licensed under a public domain license

struct CipherView: View {
    
    @Binding var pageCipher: Bool
    @Binding var pageDiffie: Bool
    
    @State var message = ""
    
    @State var keyIndexDbl = 15.0
    var key: Binding<Int> { Binding(
        get: { Int(round(keyIndexDbl)) },
        set: { _ in }
    )}
    
    @State var pageOne = true
    @State var pageTwo = false
    @State var pageThree = false
    @State var pageFour = false
    
    var body: some View {
        GeometryReader { geo in
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Ceasar Cipher").font(.system(.title)).fontWeight(.bold).frame(maxWidth: .infinity, alignment: .center)
                    if pageOne {
                        CipherTextOne()
                        TextField("Enter your word here", text: $message)
                            .padding()
                            .autocorrectionDisabled()
                            .onReceive(Just(message)) { newValue in
                                let filtered = newValue.filter { "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ ".contains($0) }
                                if filtered != newValue {
                                    self.message = filtered
                                }
                            }
                            .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color.gray, style: StrokeStyle(lineWidth: 1.0)))
                        Button("Next") {
                            // hide this page and display next page
                            pageOne = false
                            pageTwo = true
                        }
                        .buttonStyle(BlueButton())
                        .disabled(message == "")
                    }
                    if pageTwo {
                        CipherTextTwo()
                        Slider(value: $keyIndexDbl, in: 1...50)
                        Text("Your key value: ") + Style.monospace("\(key.wrappedValue)")
                        Button("Next") {
                            // hide this page and display next page
                            pageTwo = false
                            pageThree = true
                        }
                        .buttonStyle(BlueButton())
                    }
                    if pageThree {
                        CipherTextThree()
                        TextField("Enter your word here", text: $message)
                            .padding()
                            .autocorrectionDisabled()
                            .onReceive(Just(message)) { newValue in
                                let filtered = newValue.filter { "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ ".contains($0) }
                                if filtered != newValue {
                                    self.message = filtered
                                }
                            }
                            .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color.gray, style: StrokeStyle(lineWidth: 1.0)))
                        Slider(value: $keyIndexDbl, in: 1...50)
                        Text("Current key value: ") + Style.monospace("\(key.wrappedValue)")
                        Button("Next") {
                            pageThree = false
                            pageFour = true
                        }
                        .buttonStyle(BlueButton())
                    }
                    if pageFour {
                        CipherTextFour()
                        Button("Next Chapter") {
                            pageCipher = false
                            pageDiffie = true
                        }
                        .buttonStyle(BlueButton())
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
                            CipherGraphView(message: $message, key: key)
                        }
                        Spacer()
                    }
                }.padding()
            }
        }
    }
}

struct CipherTextOne: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("When sending each other messages or storing sensitive information, we usually want to encode the information so that it cannot be easily seen by others for the sake of privacy.")
            Text("To do so, we use a key in an algorithm to change the plaintext into gibberish, or ciphertext.")
            Text("This key can also be used to change the gibberish back to plaintext.")
            Text("This is called 'symmetric encryption'.")
            Text("Let's demonstrate with an example. Choose some word or sentence that you want to encrypt.")
        }
    }
}

struct CipherTextTwo: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Then, we need to choose some number to be the key.")
            Text("This key is used to encrypt and decrypt the message. When we pass the key into the encryption algorithm, the algorithm scrambles the message based on the key. The same key can also unscramble the message using a decryption algorithm.")
            Text("For this example, we will use the very simple alogrithm called the Ceasar Cipher.")
            Text("This algorithm shifts every letter by the number provided in the key. For instance, if the key is ") + Style.monospace("3") + Text(" , then the letter 'A' will be shifted up by 3 indexes to the letter 'D'. Also, since there are only 26 letters, the algorithm wraps around at the end. That is, the letter 'Z' shifted up by 3 indexes will be the letter 'C'.")
            Text("Use the slider to choose the value of a key below. It can be any integer.")
        }
    }
}

struct CipherTextThree: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Try out this encryption algorithm!")
            Text("You can encrypt your message by dragging and dropping the encryption key on top of your message.")
            Text("You can then decrypt your message by dragging and dropping the decryption key on top of your message.")
            Text("Press hard on a key to pick it up and move it around.")
            Text("This Ceasar Cipher encryption method is very easy to crack, therefore it is not used in real life situations. However, the gist is still the same with practical algorithms like AES (Advanced Encryption Standard), where the same key is fed into an algorithm for encryption and decryption.")
            Text("You can also change your message and key value below to try out different encryption combinations!")
            Text("Message:")
        }
    }
}

struct CipherTextFour: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Therefore, if anybody knows your key, they will be able to decrypt your messages or anything that you store!")
            Text("Think of when you are sending private messages to other people over the internet encrypted.")
            Text("But you cannot send your key over too, since people eavesdropping on the internet can just take the key and decrypt the message!")
            Text("Therefore, we need a method to generate the same key between two people, without people eavesdropping over the internet being able to guess the key.")
            Text("There is an established method for doing so, which is called the 'Diffie Hellman Key Exchange.'")
            Text("Let's explore this method in the next chapter.")
        }
    }
}

struct CipherView_Previews: PreviewProvider {
    static var previews: some View {
        CipherView(pageCipher: .constant(true), pageDiffie: .constant(false)).previewInterfaceOrientation(.landscapeLeft)
    }
}
