import SwiftUI

struct CipherGraphView: View {
    
    let lowercaseLetter = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
    let uppercaseLetter = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    
    @ObservedObject var viewModel: CipherViewModel
    
    @State var encryptPulseStart = false
    @State var decryptPulseStart = false
    
    var body: some View {
        VStack(spacing: 25) {
            Spacer()
            if #available(iOS 16.0, *) {
                Text(" \(viewModel.message) ")
                    .font(.system(size: 50))
                    .dropDestination(for: String.self) { text, _ in
                        if text.first == "enc" {
                            viewModel.message = encrypt(viewModel.message, key: viewModel.key.wrappedValue)
                        } else if text.first == "dec" {
                            viewModel.message = decrypt(viewModel.message, key: viewModel.key.wrappedValue)
                        } else {
                            print("ERROR: unkown drop origin")
                        }
                        return true
                    }
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color.gray, style: StrokeStyle(lineWidth: 1.0)))
            } else {
                // Fallback on earlier versions
            }
            Spacer()
            HStack {
                Spacer()
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
                                
                                // show the encrypted message
                                viewModel.message = viewModel.encryptedMessage
                                
                                // next page
                                viewModel.pageThree = false
                                viewModel.pageFour = true
                                return true
                            }
                    } else {
                        Image("encryption")
                    }
                }
                Spacer()
                if #available(iOS 16.0, *) {
                    if viewModel.pageFour {
                        Image("decryption")
                            .scaleEffect(decryptPulseStart ? 1.05 : 1)
                            .animation(decryptPulseStart ? .easeInOut.repeatForever(autoreverses: true) : .default, value: decryptPulseStart)
                            .dropDestination(for: String.self) { _, _ in
                                // stop animating
                                decryptPulseStart = false
                                
                                // show the dencrypted message
                                viewModel.message = viewModel.originalMessage
                                
                                // display success
                                viewModel.pageFourSub = true
                                return true
                            }
                    } else if viewModel.pageFive {
                        Image("decryption")
                            .scaleEffect(decryptPulseStart ? 1.05 : 1)
                            .animation(decryptPulseStart ? .easeInOut.repeatForever(autoreverses: true) : .default, value: decryptPulseStart)
                            .dropDestination(for: String.self) { _, _ in
                                // stop animating
                                decryptPulseStart = false
                                
                                // show the wrong dencrypted message
                                viewModel.message = viewModel.wrongMessage
                                
                                // display success
                                viewModel.pageFiveSub = true
                                return true
                            }
                    } else {
                        Image("decryption")
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
                            Style.monospaceBig("\(viewModel.key.wrappedValue)").offset(x: -30)
                        }.onDrag {
                            encryptPulseStart = true
                            return NSItemProvider(object: "enc" as NSItemProviderWriting)
                        }
                    } else if viewModel.pageFour {
                        ZStack {
                            Image("key")
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
                    if viewModel.pageFive {
                        ZStack {
                            Image("key_wrong")
                            Style.monospaceBig("\(viewModel.key.wrappedValue+1)").offset(x: -30)
                        }.onDrag {
                            decryptPulseStart = true
                            return NSItemProvider(object: "enc" as NSItemProviderWriting)
                        }
                        Spacer()
                    } else if viewModel.pageSix {
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
        }
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
}
